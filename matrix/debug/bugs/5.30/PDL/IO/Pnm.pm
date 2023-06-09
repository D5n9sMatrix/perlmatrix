
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::IO::Pnm;

@EXPORT_OK  = qw(  rpnm wpnm PDL::PP pnminraw PDL::PP pnminascii PDL::PP pnmout );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::IO::Pnm ;




=head1 NAME

PDL::IO::Pnm -- pnm format I/O for PDL

=head1 SYNOPSIS

  use PDL::IO::Pnm;
  $im = wpnm $pdl, $file, $format[, $raw];
  rpnm $stack->slice(':,:,:,(0)'),"PDL.ppm";

=head1 DESCRIPTION

pnm I/O for PDL.

=cut

use PDL::Core qw/howbig convert/;
use PDL::Types;
use PDL::Basic;  # for max/min
use PDL::IO::Misc;
use Carp;
use File::Temp qw( tempfile );

# return the upper limit of data values an integer PDL data type
# can hold
sub dmax {
    my $type = shift;
    my $sz = 8*howbig($type);
    $sz-- if ($type == $PDL_S || $type == $PDL_L);  # signed types
    return ((1 << $sz)-1);
}

# output any errors that have accumulated
sub show_err {
  my ($file,$showflag) = @_;
  my $err;
  $showflag = 1 unless defined $showflag;
  if (-s "$file") {
    open(INPUT,$file) or barf "Can't open error file";
    if ($showerr) {
      while (<INPUT>) {
       print STDERR "converter: $_";
      }} else {
       $err = join('',<INPUT>);
    }
  }
  close INPUT;
  unlink $file;
  return $err unless $showflag;
}

# barf after showing any accumulated errors
sub rbarf {
  my $err = show_err(shift, 0);
  $err = '' unless defined $err;
  barf @_,"converter error: $err";
}

# carp after showing any accumulated errors
sub rcarp {
  show_err(shift);
  carp @_;
}






=head1 FUNCTIONS



=cut






=head2 pnminraw

=for sig

  Signature: (type(); byte+ [o] im(m,n); int ms => m; int ns => n;
			int isbin; char* fd)



=for ref

Read in a raw pnm file.

read a raw pnm file. The C<type> argument is only there to
determine the type of the operation when creating C<im> or trigger
the appropriate type conversion (maybe we want a byte+ here so that
C<im> follows I<strictly> the type of C<type>).



=for bad

pnminraw does not process bad values.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut






*pnminraw = \&PDL::pnminraw;





=head2 pnminascii

=for sig

  Signature: (type(); byte+ [o] im(m,n); int ms => m; int ns => n;
			int format; char* fd)


=for ref

Read in an ascii pnm file.



=for bad

pnminascii does not process bad values.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut






*pnminascii = \&PDL::pnminascii;





=head2 pnmout

=for sig

  Signature: (a(m); int israw; int isbin; char *fd)


=for ref

Write a line of pnm data.

This function is implemented this way so that threading works
naturally.



=for bad

pnmout does not process bad values.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut






*pnmout = \&PDL::pnmout;



;

=head2 rpnm

=for ref

Read a pnm (portable bitmap/pixmap, pbm/ppm) file into a piddle.

=for usage

  Usage:  $im = rpnm $file;

Reads a file in pnm format (ascii or raw) into a pdl (magic numbers P1-P6).
Based on the input format it returns pdls with arrays of size (width,height)
if binary or grey value data (pbm and pgm) or (3,width,height) if rgb
data (ppm). This also means for a palette image that the distinction between
an image and its lookup table is lost which can be a problem in cases (but can
hardly be avoided when using netpbm/pbmplus).  Datatype is dependent
on the maximum grey/color-component value (for raw and binary formats
always PDL_B). rpnm tries to read chopped files by zero padding the
missing data (well it currently doesn't, it barfs; I'll probably fix it
when it becomes a problem for me ;). You can also read directly into an
existing pdl that has to have the right size(!). This can come in handy
when you want to read a sequence of images into a datacube.

For details about the formats see appropriate manpages that come with the
netpbm/pbmplus packages.

=for example

  $stack = zeroes(byte,3,500,300,4);
  rpnm $stack->slice(':,:,:,(0)'),"PDL.ppm";

reads an rgb image (that had better be of size (500,300)) into the
first plane of a 3D RGB datacube (=4D pdl datacube). You can also do
inplace transpose/inversion that way.

=cut

sub rpnm {PDL->rpnm(@_)}
sub PDL::rpnm {
    barf 'Usage: $im = rpnm($file) or $im = $pdl->rpnm($file)'
       if $#_<0 || $#_>2;
    my ($pdl,$file,$maybe) = @_;


    if (ref($file)) { # $file is really a pdl in this case
	$pdl = $file;
	$file = $maybe;
    } else {
        $pdl = $pdl->initialize;
    }

    my ($errfh, $efile) = tempfile();
    # catch STDERR
    open(SAVEERR, ">&STDERR");
    open(STDERR, ">$efile") || barf "Can't redirect stderr";
    my $succeed = open(PNM, $file);
    # redirection now in effect for child
    # close(STDERR);
    open(STDERR, ">&PDL::IO::Pnm::SAVEERR");
    rbarf $efile,"Can't open pnm file '$file'" unless $succeed;
    binmode PNM;

    read(PNM,(my $magic),2);
    rbarf $efile, "Oops, this is not a PNM file" unless $magic =~ /P[1-6]/;
    print "reading pnm file with magic $magic\n" if $PDL::debug>1;

    my ($isrgb,$israw,$params) = (0,0,3);
    $israw = 1 if $magic =~ /P[4-6]/;
    $isrgb = 1 if $magic =~ /P[3,6]/;
    if ($magic =~ /P[1,4]/) {  # PBM data
	$params = 2;
	$dims[2] = 1; }

    # get the header information
    my ($line, $pgot, @dims) = ("",0,0,0,0);
    while (($pgot<$params) && ($line=<PNM>)) {
       $line =~ s/#.*$//;
	next if $line =~ /^\s*$/;    # just white space
	while ($line !~ /^\s*$/ && $pgot < $params) {
	    if ($line =~ /\s*(\S+)(.*)$/) {
		$dims[$pgot++] = $1; $line = $2; }
	    else {
		rbarf $efile, "no valid header info in pnm";}
	}
    }

    my $type = $PDL_B;
    do {
TYPES:	{  my $pdlt;
	   foreach $pdlt ($PDL_B,$PDL_US,$PDL_L){
	     if ($dims[2] <= dmax($pdlt))
	       { $type = $pdlt;
	         last TYPES;
	       }
	   }
	   rbarf $efile, "rraw: data from ascii pnm file out of range";
        }
    };

    # the file ended prematurely
    rbarf $efile, "no valid header info in pnm" if $pgot < $params;
    rbarf $efile,
        "Dimensions must be > 0" if ($dims[0] <= 0) || ($dims[1] <= 0);

    my @Dims = @dims[0,1];
    $Dims[0] *= 3 if $isrgb;
    if ($pdl->getndims==1 && $pdl->getdim(0)==0 && $isrgb) { #input pdl is null
	local $PDL::debug = 0; # shut up
	$pdl = $pdl->zeroes(PDL::Type->new($type),3,@dims[0,1]);
    }
    my $npdl = $isrgb ? $pdl->clump(2) : $pdl;
    if ($israw) {
       pnminraw (convert(pdl(0),$type), $npdl, $Dims[0], $Dims[1],
	 $magic eq "P4", 'PDL::IO::Pnm::PNM');
    } else {
       my $form = $1 if $magic =~ /P([1-3])/;
       pnminascii (convert(pdl(0),$type), $npdl, $Dims[0], $Dims[1],
	$form, 'PDL::IO::Pnm::PNM');
    }
    print("loaded pnm file, $dims[0]x$dims[1], gmax: $dims[2]",
	   $isrgb ? ", RGB data":"", $israw ? ", raw" : " ASCII"," data\n")
	if $PDL::debug;
    unlink($efile);

    # need to byte swap for little endian platforms
    unless ( isbigendian() ) {
       if ($israw ) {
          $pdl->bswap2 if $type==$PDL_US or $pdl->type == ushort;
          $pdl->bswap4 if $type==$PDL_L;  # not likely, but supported anyway
       }
    }
    return $pdl;
}


=head2 wpnm

=for ref

Write a pnm (portable bitmap/pixmap, pbm/ppm) file into a file.

=for usage

  Usage:  $im = wpnm $pdl, $file, $format[, $raw];

Writes data in a pdl into pnm format (ascii or raw) (magic numbers P1-P6).
The $format is required (normally produced by B<wpic>) and routine just
checks if data is compatible with that format. All conversions should
already have been done. If possible, usage of B<wpic> is preferred. Currently
RAW format is chosen if compliant with range of input data. Explicit control
of ASCII/RAW is possible through the optional $raw argument. If RAW is
set to zero it will enforce ASCII mode. Enforcing RAW is
somewhat meaningless as the routine will always try to write RAW
format if the data range allows (but maybe it should reduce to a RAW
supported type when RAW == 'RAW'?). For details about the formats
consult appropriate manpages that come with the netpbm/pbmplus
packages.

=cut

*wpnm = \&PDL::wpnm;
sub PDL::wpnm {
    barf ('Usage: wpnm($pdl,$filename,$format[,$raw]) ' .
	   'or $pdl->wpnm($filename,$format[,$raw])') if $#_ < 2;
    my ($pdl,$file,$type,$raw) = @_;
    my ($israw,$max,$isrgb,$magic) = (0,255,0,"");

    # need to copy input arg since bswap[24] work inplace
    # might be better if the bswap calls detected if run in
    # void context
    my $swap_inplace = $pdl->is_inplace;

    barf "wpnm: unknown format '$type'" if $type !~ /P[P,G,B]M/;

    # check the data
    my @Dims = $pdl->dims;
    barf "wpnm: expecting 3D (3,w,h) input"
	if ($type =~ /PPM/) && (($#Dims != 2) || ($Dims[0] != 3));
    barf "wpnm: expecting 2D (w,h) input"
	if ($type =~ /P[G,B]M/) && ($#Dims != 1);
    barf "wpnm: user should convert float and double data to appropriate type"
	if ($pdl->get_datatype == $PDL_F) || ($pdl->get_datatype == $PDL_D);
    barf "wpnm: expecting prescaled data"
	if (($pdl->get_datatype != $PDL_B) || ($pdl->get_datatype != $PDL_US)) &&
	    ($pdl->min < 0);

    # check for raw format
    $israw = 1 if (($pdl->get_datatype == $PDL_B) || ($pdl->get_datatype == $PDL_US) || ($type =~ /PBM/));
    $israw = 0 if (defined($raw) && !$raw);


    $magic = $israw ? "P4" : "P1" if $type =~ /PBM/;
    $magic = $israw ? "P5" : "P2" if $type =~ /PGM/;
    $magic = $israw ? "P6" : "P3" if $type =~ /PPM/;
    $isrgb = 1 if $magic =~ /P[3,6]/;

    # catch STDERR and sigpipe
    my ($errfh, $efile) = tempfile();
    local $SIG{"PIPE"} = sub { show_err($efile);
			       die "Bad write to pipe $? $!"; };

    my $pref = ($file !~ /^\s*[|>]/) ? ">" : "";  # test for plain file name
    open(SAVEERR, ">&STDERR");
    open(STDERR, ">$efile") || barf "Can't redirect stderr";
    my $succeed = open(PNM, $pref . $file);
    # close(STDERR);
    open(STDERR, ">&PDL::IO::Pnm::SAVEERR");
    rbarf $efile, "Can't open pnm file" unless $succeed;
    binmode PNM;

    $max =$pdl->max;
    print "writing ". ($israw ? "raw" : "ascii") .
      "format with magic $magic\n" if $PDL::debug;
    # write header
    print PNM "$magic\n";
    print PNM "$Dims[-2] $Dims[-1]\n";
    if ($type !~ /PBM/) {	# fix maxval for raw output formats
       my $outmax = 0;

       if ($max < 256) {
          $outmax =   "255";
       } elsif ($max < 65536) {
          $outmax = "65535";
       } else {
          $outmax = $max;
       };

       print PNM "$outmax\n" unless $type =~ /PBM/;
    };

    # if rgb clump first two dims together
    my $out = ($isrgb ? $pdl->slice(':,:,-1:0')->clump(2)
		 : $pdl->slice(':,-1:0'));

    # handle byte swap issues for little endian platforms
    unless ( isbigendian() ) {
       if ($israw ) {
          # make copy if needed
          $out = $out->copy unless $swap_inplace;
          if ( (255 < $max) and ($max < 65536)) {
             $out->bswap2;
          } elsif ($max >= 65536) {
             $out->bswap4;
          }
       }
    }
    pnmout($out,$israw,$type eq "PBM",'PDL::IO::Pnm::PNM');

    # check if our child returned an error (in case of a pipe)
    if (!(close PNM)) {
      my $err = show_err($efile,0);
      barf "wpnm: pbmconverter error: $err";
    }
    unlink($efile);
}



;# Exit with OK status

1;

=head1 BUGS

The stderr of the converters is redirected to a file. The filename is
currently generated in a probably non-portable way. A method that avoids
a file (and is portable) would be preferred.

C<rpnm> currently relies on the fact that the header is separated
from the image data by a newline. This is not required by the p[bgp]m
formats (in fact any whitespace is allowed) but most of the pnm
writers seem to comply with that. Truncated files are currently
treated ungracefully (C<rpnm> just barfs).

=head1 AUTHOR

Copyright (C) 1996,1997 Christian Soeller <c.soeller@auckland.ac.nz>
All rights reserved. There is no warranty. You are allowed
to redistribute this software / documentation under certain
conditions. For details, see the file COPYING in the PDL
distribution. If this file is separated from the PDL distribution,
the copyright notice should be included in the file.


=cut


############################## END PM CODE ################################




# Exit with OK status

1;

		   