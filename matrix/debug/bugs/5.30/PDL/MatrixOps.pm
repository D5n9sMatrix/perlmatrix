
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::MatrixOps;

@EXPORT_OK  = qw(  identity  stretcher  inv  det  determinant PDL::PP eigens_sym PDL::PP eigens PDL::PP svd  lu_decomp  lu_decomp2  lu_backsub PDL::PP simq PDL::PP squaretotri );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::MatrixOps ;





=head1 NAME

PDL::MatrixOps -- Some Useful Matrix Operations

=head1 SYNOPSIS

    $inv = $x->inv;

    $det = $x->det;

    ($lu,$perm,$par) = $x->lu_decomp;
    $y = lu_backsub($lu,$perm,$z); # solve $x x $y = $z

=head1 DESCRIPTION

PDL::MatrixOps is PDL's built-in matrix manipulation code.  It
contains utilities for many common matrix operations: inversion,
determinant finding, eigenvalue/vector finding, singular value
decomposition, etc.  PDL::MatrixOps routines are written in a mixture
of Perl and C, so that they are reliably present even when there is no
FORTRAN compiler or external library available (e.g.
L<PDL::Slatec|PDL::Slatec> or any of the PDL::GSL family of modules).

Matrix manipulation, particularly with large matrices, is a
challenging field and no one algorithm is suitable in all cases.  The
utilities here use general-purpose algorithms that work acceptably for
many cases but might not scale well to very large or pathological
(near-singular) matrices.

Except as noted, the matrices are PDLs whose 0th dimension ranges over
column and whose 1st dimension ranges over row.  The matrices appear
correctly when printed.

These routines should work OK with L<PDL::Matrix|PDL::Matrix> objects
as well as with normal PDLs.

=head1 TIPS ON MATRIX OPERATIONS

Like most computer languages, PDL addresses matrices in (column,row)
order in most cases; this corresponds to (X,Y) coordinates in the
matrix itself, counting rightwards and downwards from the upper left
corner.  This means that if you print a PDL that contains a matrix,
the matrix appears correctly on the screen, but if you index a matrix
element, you use the indices in the reverse order that you would in a
math textbook.  If you prefer your matrices indexed in (row, column)
order, you can try using the L<PDL::Matrix|PDL::Matrix> object, which
includes an implicit exchange of the first two dimensions but should
be compatible with most of these matrix operations.  TIMTOWDTI.)

Matrices, row vectors, and column vectors can be multiplied with the 'x'
operator (which is, of course, threadable):

    $m3 = $m1 x $m2;
    $col_vec2 = $m1 x $col_vec1;
    $row_vec2 = $row_vec1 x $m1;
    $scalar = $row_vec x $col_vec;

Because of the (column,row) addressing order, 1-D PDLs are treated as
_row_ vectors; if you want a _column_ vector you must add a dummy dimension:

    $rowvec  = pdl(1,2);            # row vector
    $colvec  = $rowvec->(*1);	      # 1x2 column vector
    $matrix  = pdl([[3,4],[6,2]]);  # 2x2 matrix
    $rowvec2 = $rowvec x $matrix;   # right-multiplication by matrix
    $colvec  = $matrix x $colvec;   # left-multiplication by matrix
    $m2      = $matrix x $rowvec;   # Throws an error

Implicit threading works correctly with most matrix operations, but
you must be extra careful that you understand the dimensionality.  In 
particular, matrix multiplication and other matrix ops need nx1 PDLs
as row vectors and 1xn PDLs as column vectors.  In most cases you must
explicitly include the trailing 'x1' dimension in order to get the expected
results when you thread over multiple row vectors.

When threading over matrices, it's very easy to get confused about 
which dimension goes where. It is useful to include comments with 
every expression, explaining what you think each dimension means:

	$x = xvals(360)*3.14159/180;        # (angle)
	$rot = cat(cat(cos($x),sin($x)),    # rotmat: (col,row,angle)
	           cat(-sin($x),cos($x)));

=head1 ACKNOWLEDGEMENTS

MatrixOps includes algorithms and pre-existing code from several
origins.  In particular, C<eigens_sym> is the work of Stephen Moshier,
C<svd> uses an SVD subroutine written by Bryant Marks, and C<eigens>
uses a subset of the Small Scientific Library by Kenneth Geisshirt.
They are free software, distributable under same terms as PDL itself.


=head1 NOTES

This is intended as a general-purpose linear algebra package for
small-to-mid sized matrices.  The algorithms may not scale well to
large matrices (hundreds by hundreds) or to near singular matrices.

If there is something you want that is not here, please add and
document it!

=cut

use Carp;
use PDL::NiceSlice;
use strict;







=head1 FUNCTIONS



=cut




=head2 identity

=for sig

  Signature: (n; [o]a(n,n))

=for ref

Return an identity matrix of the specified size.  If you hand in a
scalar, its value is the size of the identity matrix; if you hand in a
dimensioned PDL, the 0th dimension is the size of the matrix.

=cut

sub identity {
  my $n = shift;
  my $out = ((UNIVERSAL::isa($n,'PDL')) ? 
	  (  ($n->getndims > 0) ? 
	     zeroes($n->dim(0),$n->dim(0)) : 
	     zeroes($n->at(0),$n->at(0))
	  ) :
	  zeroes($n,$n)
	  );
  my $tmp; # work around perl -d "feature"
  ($tmp = $out->diagonal(0,1))++;
  $out;
}



=head2 stretcher

=for sig

  Signature: (a(n); [o]b(n,n))

=for usage

  $mat = stretcher($eigenvalues);

=for ref 

Return a diagonal matrix with the specified diagonal elements

=cut

sub stretcher {
  my $in = shift;
  my $out = zeroes($in->dim(0),$in->dims);
  my $tmp;  # work around for perl -d "feature"
  ($tmp = $out->diagonal(0,1)) += $in;	
  $out;
}




=head2 inv

=for sig

  Signature: (a(m,m); sv opt )

=for usage

  $a1 = inv($a, {$opt});                

=for ref

Invert a square matrix.

You feed in an NxN matrix in $a, and get back its inverse (if it
exists).  The code is inplace-aware, so you can get back the inverse
in $a itself if you want -- though temporary storage is used either
way.  You can cache the LU decomposition in an output option variable.

C<inv> uses C<lu_decomp> by default; that is a numerically stable
(pivoting) LU decomposition method.


OPTIONS:

=over 3

=item * s

Boolean value indicating whether to complain if the matrix is singular.  If
this is false, singular matrices cause inverse to barf.  If it is true, then 
singular matrices cause inverse to return undef.

=item * lu (I/O)

This value contains a list ref with the LU decomposition, permutation,
and parity values for C<$a>.  If you do not mention the key, or if the
value is undef, then inverse calls C<lu_decomp>.  If the key exists with
an undef value, then the output of C<lu_decomp> is stashed here (unless
the matrix is singular).  If the value exists, then it is assumed to
hold the LU decomposition.

=item * det (Output)

If this key exists, then the determinant of C<$a> get stored here,
whether or not the matrix is singular.

=back

=cut

*PDL::inv = \&inv;
sub inv {
  my $x = shift;
  my $opt = shift;
  $opt = {} unless defined($opt);


  barf "inverse needs a square PDL as a matrix\n" 
    unless(UNIVERSAL::isa($x,'PDL') &&
	   $x->dims >= 2 &&
	   $x->dim(0) == $x->dim(1)
	   );

  my ($lu,$perm,$par);
  if(exists($opt->{lu}) &&
     ref $opt->{lu} eq 'ARRAY' &&
     ref $opt->{lu}->[0] eq 'PDL') {
	    ($lu,$perm,$par) = @{$opt->{lu}};
  } else {
    ($lu,$perm,$par) = lu_decomp($x);
    @{$opt->{lu}} = ($lu,$perm,$par)
     if(ref $opt->{lu} eq 'ARRAY');
  }

  my $det = (defined $lu) ? $lu->diagonal(0,1)->prodover * $par : pdl(0);
  $opt->{det} = $det
    if exists($opt->{det});

  unless($det->nelem > 1 || $det) {
    return undef 
      if $opt->{s};
    barf("PDL::inv: got a singular matrix or LU decomposition\n");
  }

  my $idenA = $x->zeros;
  $idenA->diagonal(0,1) .= 1;
  my $out = lu_backsub($lu,$perm,$par,$idenA)->xchg(0,1)->sever;

  return $out
    unless($x->is_inplace);

  $x .= $out;
  $x;
}




=head2 det

=for sig

  Signature: (a(m,m); sv opt)

=for usage

  $det = det($a,{opt});

=for ref

Determinant of a square matrix using LU decomposition (for large matrices)

You feed in a square matrix, you get back the determinant.  Some
options exist that allow you to cache the LU decomposition of the
matrix (note that the LU decomposition is invalid if the determinant
is zero!).  The LU decomposition is cacheable, in case you want to
re-use it.  This method of determinant finding is more rapid than
recursive-descent on large matrices, and if you reuse the LU
decomposition it's essentially free.

OPTIONS:

=over 3

=item * lu (I/O)

Provides a cache for the LU decomposition of the matrix.  If you 
provide the key but leave the value undefined, then the LU decomposition
goes in here; if you put an LU decomposition here, it will be used and
the matrix will not be decomposed again.

=back

=cut

*PDL::det = \&det;
sub det {
  my($x) = shift;
  my($opt) = shift;
  $opt = {} unless defined($opt);

  my($lu,$perm,$par);
  if(exists ($opt->{lu}) and (ref $opt->{lu} eq 'ARRAY')) {
    ($lu,$perm,$par) =  @{$opt->{lu}};
  } else {
    ($lu,$perm,$par) = lu_decomp($x);
    $opt->{lu} = [$lu,$perm,$par]
      if(exists($opt->{lu}));
  }
   
  ( (defined $lu) ? $lu->diagonal(0,1)->prodover * $par : 0 );
}




=head2 determinant

=for sig

  Signature: (a(m,m))

=for usage

  $det = determinant($x);

=for ref

Determinant of a square matrix, using recursive descent (threadable).

This is the traditional, robust recursive determinant method taught in
most linear algebra courses.  It scales like C<O(n!)> (and hence is
pitifully slow for large matrices) but is very robust because no 
division is involved (hence no division-by-zero errors for singular
matrices).  It's also threadable, so you can find the determinants of 
a large collection of matrices all at once if you want.

Matrices up to 3x3 are handled by direct multiplication; larger matrices
are handled by recursive descent to the 3x3 case.

The LU-decomposition method L<det|det> is faster in isolation for
single matrices larger than about 4x4, and is much faster if you end up
reusing the LU decomposition of C<$a> (NOTE: check performance and
threading benchmarks with new code).

=cut

*PDL::determinant = \&determinant;
sub determinant {
  my($x) = shift;
  my($n);
  return undef unless(
		      UNIVERSAL::isa($x,'PDL') &&
		      $x->getndims >= 2 &&
		      ($n = $x->dim(0)) == $x->dim(1)
		      );
  
  return $x->clump(2) if($n==1);
  if($n==2) {
    my($y) = $x->clump(2);
    return $y->index(0)*$y->index(3) - $y->index(1)*$y->index(2);
  }
  if($n==3) {
    my($y) = $x->clump(2);
    
    my $y3 = $y->index(3);
    my $y4 = $y->index(4);
    my $y5 = $y->index(5);
    my $y6 = $y->index(6);
    my $y7 = $y->index(7);
    my $y8 = $y->index(8);

    return ( 
	 $y->index(0) * ( $y4 * $y8 - $y5 * $y7 )
      +  $y->index(1) * ( $y5 * $y6 - $y3 * $y8 )
      +  $y->index(2) * ( $y3 * $y7 - $y4 * $y6 )
	     );
  }
  
  my($i);
  my($sum) = zeroes($x->((0),(0)));

  # Do middle submatrices
  for $i(1..$n-2) {
    my $el = $x->(($i),(0));
    next if( ($el==0)->all );  # Optimize away unnecessary recursion

    $sum += $el * (1-2*($i%2)) * 
      determinant(        $x->(0:$i-1,1:-1)->
		   append($x->($i+1:-1,1:-1)));
  }

  # Do beginning and end submatrices
  $sum += $x->((0),(0))  * determinant($x->(1:-1,1:-1));
  $sum -= $x->((-1),(0)) * determinant($x->(0:-2,1:-1)) * (1 - 2*($n % 2));
  
  return $sum;
}





=head2 eigens_sym

=for sig

  Signature: ([phys]a(m); [o,phys]ev(n,n); [o,phys]e(n))


=for ref

Eigenvalues and -vectors of a symmetric square matrix.  If passed
an asymmetric matrix, the routine will warn and symmetrize it, by taking
the average value.  That is, it will solve for 0.5*($a+$a->mv(0,1)).

It's threadable, so if C<$a> is 3x3x100, it's treated as 100 separate 3x3
matrices, and both C<$ev> and C<$e> get extra dimensions accordingly.

If called in scalar context it hands back only the eigenvalues.  Ultimately,
it should switch to a faster algorithm in this case (as discarding the 
eigenvectors is wasteful).

The algorithm used is due to J. vonNeumann, which was a rediscovery of
L<Jacobi's Method|http://en.wikipedia.org/wiki/Jacobi_eigenvalue_algorithm> .

The eigenvectors are returned in COLUMNS of the returned PDL.  That
makes it slightly easier to access individual eigenvectors, since the
0th dim of the output PDL runs across the eigenvectors and the 1st dim
runs across their components.

    ($ev,$e) = eigens_sym $x;  # Make eigenvector matrix
    $vector = $ev->($n);       # Select nth eigenvector as a column-vector
    $vector = $ev->(($n));     # Select nth eigenvector as a row-vector

=for usage

    ($ev, $e) = eigens_sym($x); # e-vects & e-values
    $e = eigens_sym($x);        # just eigenvalues



=for bad

eigens_sym ignores the bad-value flag of the input piddles.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut





   sub PDL::eigens_sym {
      my ($x) = @_;
      my (@d) = $x->dims;
      barf "Need real square matrix for eigens_sym" 
            if $#d < 1 or $d[0] != $d[1];
      my ($n) = $d[0];
      my ($sym) = 0.5*($x + $x->mv(0,1));
      my ($err) = PDL::max(abs($sym));
      barf "Need symmetric component non-zero for eigens_sym"
          if $err == 0;
      $err = PDL::max(abs($x-$sym))/$err;
      warn "Using symmetrized version of the matrix in eigens_sym"
	if $err > 1e-5 && $PDL::debug;

      ## Get lower diagonal form 
      ## Use whichND/indexND because whereND doesn't exist (yet?) and
      ## the combo is threadable (unlike where).  Note that for historical 
      ## reasons whichND needs a scalar() around it to give back a 
      ## nice 2xn PDL index. 
      my $lt  = PDL::indexND($sym,
			     scalar(PDL::whichND(PDL->xvals($n,$n) <=
						 PDL->yvals($n,$n)))
			     )->copy;
      my $ev  = PDL->zeroes($sym->dims);
      my $e   = PDL->zeroes($sym->index(0)->dims);
      
      &PDL::_eigens_sym_int($lt, $ev, $e);

      return $ev->xchg(0,1), $e
	if(wantarray);
      $e;                #just eigenvalues
   }


*eigens_sym = \&PDL::eigens_sym;





=head2 eigens

=for sig

  Signature: ([phys]a(m); [o,phys]ev(l,n,n); [o,phys]e(l,n))


=for ref

Real eigenvalues and -vectors of a real square matrix.  

(See also L<"eigens_sym"|/eigens_sym>, for eigenvalues and -vectors
of a real, symmetric, square matrix).

The eigens function will attempt to compute the eigenvalues and
eigenvectors of a square matrix with real components.  If the matrix
is symmetric, the same underlying code as L<"eigens_sym"|/eigens_sym>
is used.  If asymmetric, the eigenvalues and eigenvectors are computed
with algorithms from the sslib library.  If any imaginary components
exist in the eigenvalues, the results are currently considered to be
invalid, and such eigenvalues are returned as "NaN"s.  This is true
for eigenvectors also.  That is if there are imaginary components to
any of the values in the eigenvector, the eigenvalue and corresponding
eigenvectors are all set to "NaN".  Finally, if there are any repeated
eigenvectors, they are replaced with all "NaN"s.

Use of the eigens function on asymmetric matrices should be considered
experimental!  For asymmetric matrices, nearly all observed matrices
with real eigenvalues produce incorrect results, due to errors of the
sslib algorithm.  If your assymmetric matrix returns all NaNs, do not
assume that the values are complex.  Also, problems with memory access
is known in this library.

Not all square matrices are diagonalizable.  If you feed in a
non-diagonalizable matrix, then one or more of the eigenvectors will
be set to NaN, along with the corresponding eigenvalues.

C<eigens> is threadable, so you can solve 100 eigenproblems by 
feeding in a 3x3x100 array. Both C<$ev> and C<$e> get extra dimensions accordingly.

If called in scalar context C<eigens> hands back only the eigenvalues.  This
is somewhat wasteful, as it calculates the eigenvectors anyway.

The eigenvectors are returned in COLUMNS of the returned PDL (ie the
the 0 dimension).  That makes it slightly easier to access individual
eigenvectors, since the 0th dim of the output PDL runs across the
eigenvectors and the 1st dim runs across their components.

	($ev,$e) = eigens $x;  # Make eigenvector matrix
	$vector = $ev->($n);   # Select nth eigenvector as a column-vector
	$vector = $ev->(($n)); # Select nth eigenvector as a row-vector

DEVEL NOTES: 

For now, there is no distinction between a complex eigenvalue and an
invalid eigenvalue, although the underlying code generates complex
numbers.  It might be useful to be able to return complex eigenvalues.

=for usage

    ($ev, $e) = eigens($x); # e'vects & e'vals
    $e = eigens($x);        # just eigenvalues



=for bad

eigens ignores the bad-value flag of the input piddles.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut





   sub PDL::eigens {
      my ($x) = @_;
      my (@d) = $x->dims;
      my $n = $d[0];
      barf "Need real square matrix for eigens" 
            if $#d < 1 or $d[0] != $d[1];
      my $deviation = PDL::max(abs($x - $x->mv(0,1)))/PDL::max(abs($x));
      if ( $deviation <= 1e-5 ) {
          #taken from eigens_sym code

          my $lt  = PDL::indexND($x,
			     scalar(PDL::whichND(PDL->xvals($n,$n) <=
						 PDL->yvals($n,$n)))
			     )->copy;
          my $ev  = PDL->zeroes($x->dims);
          my $e   = PDL->zeroes($x->index(0)->dims);
      
          &PDL::_eigens_sym_int($lt, $ev, $e);

          return $ev->xchg(0,1), $e   if wantarray;
          return $e;  #just eigenvalues
      }
      else {
          if($PDL::verbose || $PDL::debug) {
   	    print "eigens: using the asymmetric case from SSL\n";
	  }
	  if( !$PDL::eigens_bug_ack && !$ENV{PDL_EIGENS_ACK} ) {
	    print STDERR "WARNING: using sketchy algorithm for PDL::eigens asymmetric case -- you might\n".
	          "    miss an eigenvector or two\nThis should be fixed in PDL v2.5 (due 2009), \n".
		  "    or you might fix it yourself (hint hint).  You can shut off this warning\n".
		  "    by setting the variable $PDL::eigens_bug_ack, or the environment variable\n".
		  "    PDL_EIGENS_HACK prior to calling eigens() with a non-symmetric matrix.\n";
		  $PDL::eigens_bug_ack = 1;
	  }
	  
          my $ev  = PDL->zeroes(2, $x->dims);
          my $e   = PDL->zeroes(2, $x->index(0)->dims);

          &PDL::_eigens_int($x->clump(0,1), $ev, $e);

          return $ev->index(0)->xchg(0,1)->sever, $e->index(0)->sever
              if(wantarray);
          return $e->index(0)->sever;  #just eigenvalues
      }
   }


*eigens = \&PDL::eigens;





=head2 svd

=for sig

  Signature: (a(n,m); [o]u(n,m); [o,phys]z(n); [o]v(n,n))


=for usage

 ($u, $s, $v) = svd($x);

=for ref

Singular value decomposition of a matrix.

C<svd> is threadable.

Given an m x n matrix C<$a> that has m rows and n columns (m >= n),
C<svd> computes matrices C<$u> and C<$v>, and a vector of the singular
values C<$s>. Like most implementations, C<svd> computes what is
commonly referred to as the "thin SVD" of C<$a>, such that C<$u> is m
x n, C<$v> is n x n, and there are <=n singular values. As long as m
>= n, the original matrix can be reconstructed as follows:

    ($u,$s,$v) = svd($x);
    $ess = zeroes($x->dim(0),$x->dim(0));
    $ess->slice("$_","$_").=$s->slice("$_") foreach (0..$x->dim(0)-1); #generic diagonal
    $a_copy = $u x $ess x $v->transpose;

If m==n, C<$u> and C<$v> can be thought of as rotation matrices that
convert from the original matrix's singular coordinates to final
coordinates, and from original coordinates to singular coordinates,
respectively, and $ess is a diagonal scaling matrix.

If n>m, C<svd> will barf. This can be avoided by passing in the
transpose of C<$a>, and reconstructing the original matrix like so:

    ($u,$s,$v) = svd($x->transpose);
    $ess = zeroes($x->dim(1),$x->dim(1));
    $ess->slice("$_","$_").=$s->slice("$_") foreach (0..$x->dim(1)-1); #generic diagonal
    $x_copy = $v x $ess x $u->transpose;

EXAMPLE

The computing literature has loads of examples of how to use SVD.
Here's a trivial example (used in L<PDL::Transform::map|PDL::Transform/map>)
of how to make a matrix less, er, singular, without changing the
orientation of the ellipsoid of transformation:

    { my($r1,$s,$r2) = svd $x;
      $s++;             # fatten all singular values
      $r2 *= $s;        # implicit threading for cheap mult.
      $x .= $r2 x $r1;  # a gets r2 x ess x r1
    }



=for bad

svd ignores the bad-value flag of the input piddles.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut






*svd = \&PDL::svd;




=head2 lu_decomp

=for sig

  Signature: (a(m,m); [o]lu(m,m); [o]perm(m); [o]parity)

=for ref

LU decompose a matrix, with row permutation

=for usage

  ($lu, $perm, $parity) = lu_decomp($x);

  $lu = lu_decomp($x, $perm, $par);  # $perm and $par are outputs!

  lu_decomp($x->inplace,$perm,$par); # Everything in place.

=for description

C<lu_decomp> returns an LU decomposition of a square matrix,
using Crout's method with partial pivoting. It's ported
from I<Numerical Recipes>. The partial pivoting keeps it
numerically stable but means a little more overhead from
threading.

C<lu_decomp> decomposes the input matrix into matrices L and
U such that LU = A, L is a subdiagonal matrix, and U is a
superdiagonal matrix. By convention, the diagonal of L is
all 1's.

The single output matrix contains all the variable elements
of both the L and U matrices, stacked together. Because the
method uses pivoting (rearranging the lower part of the
matrix for better numerical stability), you have to permute
input vectors before applying the L and U matrices. The
permutation is returned either in the second argument or, in
list context, as the second element of the list. You need
the permutation for the output to make any sense, so be sure
to get it one way or the other.

LU decomposition is the answer to a lot of matrix questions,
including inversion and determinant-finding, and C<lu_decomp>
is used by L<inv|/inv>.

If you pass in C<$perm> and C<$parity>, they either must be
predeclared PDLs of the correct size ($perm is an n-vector,
C<$parity> is a scalar) or scalars.

If the matrix is singular, then the LU decomposition might
not be defined; in those cases, C<lu_decomp> silently returns
undef. Some singular matrices LU-decompose just fine, and
those are handled OK but give a zero determinant (and hence
can't be inverted).

C<lu_decomp> uses pivoting, which rearranges the values in the
matrix for more numerical stability. This makes it really
good for large and even near-singular matrices. There is
a non-pivoting version C<lu_decomp2> available which is
from 5 to 60 percent faster for typical problems at
the expense of failing to compute a result in some cases.

Now that the C<lu_decomp> is threaded, it is the recommended
LU decomposition routine.  It no longer falls back to C<lu_decomp2>.

C<lu_decomp> is ported from I<Numerical Recipes> to PDL. It
should probably be implemented in C.

=cut

*PDL::lu_decomp = \&lu_decomp;

sub lu_decomp {
   my($in) = shift;
   my($permute) = shift;
   my($parity) = shift;
   my($sing_ok) = shift;

   my $TINY = 1e-30;

   barf("lu_decomp requires a square (2D) PDL\n")
   if(!UNIVERSAL::isa($in,'PDL') || 
      $in->ndims < 2 || 
      $in->dim(0) != $in->dim(1));

   my($n) = $in->dim(0);
   my($n1) = $n; $n1--;

   my($inplace) = $in->is_inplace;
   my($out) = ($inplace) ? $in : $in->copy;


   if(defined $permute) {
      barf('lu_decomp: permutation vector must match the matrix')
      if(!UNIVERSAL::isa($permute,'PDL') || 
         $permute->ndims != 1 || 
         $permute->dim(0) != $out->dim(0));
      $permute .= PDL->xvals($in->dim(0));
   } else {
      $permute = $in->((0))->xvals;
   }

   if(defined $parity) {
      barf('lu_decomp: parity must be a scalar PDL') 
      if(!UNIVERSAL::isa($parity,'PDL') ||
         $parity->dim(0) != 1);
      $parity .= 1.0;
   } else {
      $parity = $in->((0),(0))->ones;
   }

   my($scales) = $in->abs->maximum; # elementwise by rows

   if(($scales==0)->sum) {
      return undef;
   }

   # Some holding tanks
   my($tmprow) = $out->((0))->double->zeroes;
   my($tmpval) = $tmprow->((0))->sever;

   my($col,$row);
   for $col(0..$n1) {       
      for $row(1..$n1) {   
         my($klim) = $row<$col ? $row : $col;
         if($klim > 0) {
            $klim--;
            my($el) = $out->index2d($col,$row);
            $el -= ( $out->(($col),0:$klim) *
               $out->(0:$klim,($row)) )->sumover;
         }

      }

      # Figure a_ij, with pivoting

      if($col < $n1) {
         # Find the maximum value in the rest of the row
         my $sl = $out->(($col),$col:$n1);
         my $wh = $sl->abs->maximum_ind;
         my $big = $sl->index($wh)->sever;

         # Permute if necessary to make the diagonal the maximum
         # if($wh != 0)
         { # Permute rows to place maximum element on diagonal.
            my $whc = $wh+$col;

            # my $sl1 = $out->(:,($whc));
            my $sl1 = $out->mv(1,0)->index($whc(*$n));
            my $sl2 = $out->(:,($col));
            $tmprow .= $sl1;  $sl1 .= $sl2;  $sl2 .= $tmprow;

            $sl1 = $permute->index($whc);
            $sl2 = $permute->index($col);
            $tmpval .= $sl1; $sl1 .= $sl2; $sl2 .= $tmpval;

            { my $tmp;
               ($tmp = $parity->where($wh>0)) *= -1.0;
            }
         }

         # Sidestep near-singularity (NR does this; not sure if it is helpful)

         my $notbig = $big->where(abs($big) < $TINY);
         $notbig .= $TINY * (1.0 - 2.0*($notbig < 0));

         # Divide by the diagonal element (which is now the largest element)
         my $tout;
         ($tout = $out->(($col),$col+1:$n1)) /= $big->(*1);
      } # end of pivoting part
   } # end of column loop

   if(wantarray) {
      return ($out,$permute,$parity);
   }
   $out;
}




=head2 lu_decomp2

=for sig

  Signature: (a(m,m); [o]lu(m,m))

=for ref

LU decompose a matrix, with no row permutation

=for usage

  ($lu, $perm, $parity) = lu_decomp2($x);
  
  $lu = lu_decomp2($x,$perm,$parity);   # or
  $lu = lu_decomp2($x);                 # $perm and $parity are optional
  
  lu_decomp($x->inplace,$perm,$parity); # or
  lu_decomp($x->inplace);               # $perm and $parity are optional

=for description

C<lu_decomp2> works just like L<lu_decomp|lu_decomp>, but it does B<no>
pivoting at all.  For compatibility with L<lu_decomp|lu_decomp>, it
will give you a permutation list and a parity scalar if you ask
for them -- but they are always trivial.

Because C<lu_decomp2> does not pivot, it is numerically B<unstable> --
that means it is less precise than L<lu_decomp>, particularly for
large or near-singular matrices.  There are also specific types of 
non-singular matrices that confuse it (e.g. ([0,-1,0],[1,0,0],[0,0,1]),
which is a 90 degree rotation matrix but which confuses C<lu_decomp2>).

On the other hand, if you want to invert rapidly a few hundred thousand
small matrices and don't mind missing one or two, it could be the ticket.
It can be up to 60% faster at the expense of possible failure of the
decomposition for some of the input matrices.

The output is a single matrix that contains the LU decomposition of C<$a>;
you can even do it in-place, thereby destroying C<$a>, if you want.  See
L<lu_decomp> for more information about LU decomposition. 

C<lu_decomp2> is ported from I<Numerical Recipes> into PDL.

=cut

*PDL::lu_decomp2 = \&lu_decomp2;

sub lu_decomp2 {
  my($in) = shift;
  my($perm) = shift;
  my($par) = shift;

  my($sing_ok) = shift;

  my $TINY = 1e-30;
  
  barf("lu_decomp2 requires a square (2D) PDL\n")
    if(!UNIVERSAL::isa($in,'PDL') || 
       $in->ndims < 2 || 
       $in->dim(0) != $in->dim(1));
  
  my($n) = $in->dim(0);
  my($n1) = $n; $n1--;

  my($inplace) = $in->is_inplace;
  my($out) = ($inplace) ? $in : $in->copy;


  if(defined $perm) {
    barf('lu_decomp2: permutation vector must match the matrix')
      if(!UNIVERSAL::isa($perm,'PDL') || 
	 $perm->ndims != 1 || 
	 $perm->dim(0) != $out->dim(0));
    $perm .= PDL->xvals($in->dim(0));
  } else {
    $perm = PDL->xvals($in->dim(0));
  }

  if(defined $par) {
    barf('lu_decomp: parity must be a scalar PDL') 
      if(!UNIVERSAL::isa($par,'PDL') ||
	 $par->nelem != 1);
    $par .= 1.0;
  } else {
    $par = pdl(1.0);
  }

  my $diagonal = $out->diagonal(0,1);

  my($col,$row);
  for $col(0..$n1) {       
    for $row(1..$n1) {   
      my($klim) = $row<$col ? $row : $col;
      if($klim > 0) {
	$klim--;
	my($el) = $out->index2d($col,$row);

	$el -= ( $out->(($col),0:$klim) *
		 $out->(0:$klim,($row)) )->sumover;
      }

    }
    
    # Figure a_ij, with no pivoting
    if($col < $n1) {
      # Divide the rest of the column by the diagonal element 
      my $tmp; # work around for perl -d "feature"
      ($tmp = $out->(($col),$col+1:$n1)) /= $diagonal->index($col)->dummy(0,$n1-$col);
    }

  } # end of column loop

  if(wantarray) {
    return ($out,$perm,$par);
  }
  $out;
}




=head2 lu_backsub

=for sig

  Signature: (lu(m,m); perm(m); b(m))

=for ref

Solve a x = b for matrix a, by back substitution into a's LU decomposition.

=for usage

  ($lu,$perm,$par) = lu_decomp($x);
  
  $x = lu_backsub($lu,$perm,$par,$y);  # or
  $x = lu_backsub($lu,$perm,$y);       # $par is not required for lu_backsub
  
  lu_backsub($lu,$perm,$y->inplace); # modify $y in-place
  
  $x = lu_backsub(lu_decomp($x),$y); # (ignores parity value from lu_decomp)

=for description

Given the LU decomposition of a square matrix (from L<lu_decomp|lu_decomp>),
C<lu_backsub> does back substitution into the matrix to solve
C<a x = b> for given vector C<b>.  It is separated from the
C<lu_decomp> method so that you can call the cheap C<lu_backsub>
multiple times and not have to do the expensive LU decomposition
more than once.

C<lu_backsub> acts on single vectors and threads in the usual
way, which means that it treats C<$y> as the I<transpose>
of the input.  If you want to process a matrix, you must
hand in the I<transpose> of the matrix, and then transpose
the output when you get it back. that is because pdls are
indexed by (col,row), and matrices are (row,column) by
convention, so a 1-D pdl corresponds to a row vector, not a
column vector.

If C<$lu> is dense and you have more than a few points to
solve for, it is probably cheaper to find C<a^-1> with
L<inv|/inv>, and just multiply C<x = a^-1 b>.) in fact,
L<inv|/inv> works by calling C<lu_backsub> with the identity
matrix.

C<lu_backsub> is ported from section 2.3 of I<Numerical Recipes>.
It is written in PDL but should probably be implemented in C.

=cut

*PDL::lu_backsub = \&lu_backsub;

sub lu_backsub {
   my ($lu, $perm, $y, $par);
   print STDERR "lu_backsub: entering debug version...\n" if $PDL::debug;
   if(@_==3) {
      ($lu, $perm, $y) = @_;
   } elsif(@_==4) {
      ($lu, $perm, $par, $y) = @_;
   } 

   barf("lu_backsub: LU decomposition is undef -- probably from a singular matrix.\n")
   unless defined($lu);

   barf("Usage: \$x = lu_backsub(\$lu,\$perm,\$y); all must be PDLs\n") 
   unless(UNIVERSAL::isa($lu,'PDL') &&
      UNIVERSAL::isa($perm,'PDL') &&
      UNIVERSAL::isa($y,'PDL'));

   my $n = $y->dim(0);
   my $n1 = $n; $n1--;

   # Make sure threading dimensions are compatible.
   # There are two possible sources of thread dims:
   #
   # (1) over multiple LU (i.e., $lu,$perm) instances
   # (2) over multiple  B (i.e., $y) column instances
   #
   # The full dimensions of the function call looks like
   #
   #   lu_backsub( lu(m,m,X), perm(m,X), b(m,Y) )
   #
   # where X is the list of extra LU dims and Y is
   # the list of extra B dims.  We have several possible
   # cases:
   #
   # (1) Check that m dims are compatible
   my $ludims = pdl($lu->dims);
   my $permdims = pdl($perm->dims);
   my $bdims = pdl($y->dims);

   print STDERR "lu_backsub: called with args:  \$lu$ludims, \$perm$permdims, \$y$bdims\n" if $PDL::debug;

   my $m = $ludims((0));  # this is the sig dimension
   unless ( ($ludims(0) == $m) and ($ludims(1) == $m) and
      ($permdims(0) == $m) and ($bdims(0) == $m)) {
      barf "lu_backsub: mismatched sig dimensions";
   }

   my $lunumthr = $ludims->dim(0)-2;
   my $permnumthr = $permdims->dim(0)-1;
   my $bnumthr = $bdims->dim(0)-1;
   unless ( ($lunumthr == $permnumthr) and ($ludims(1:-1) == $permdims)->all )  {
      barf "lu_backsub: \$lu and \$perm thread dims not equal! \n";
   }

   # (2) If X == Y then default threading is ok
   if ( ($bnumthr==$permnumthr) and ($bdims==$permdims)->all) {
      print STDERR "lu_backsub: have explicit thread dims, goto THREAD_OK\n" if $PDL::debug;
      goto THREAD_OK;
   }

   # (3) If X == (x,Y) then add x dummy to lu,perm

   # (4) If ndims(X) > ndims(Y) then must have #3

   # (5) If ndims(X) < ndims(Y) then foreach
   #     non-trivial leading dim in X (x0,x1,..)
   #     insert dummy (x0,x1) into lu and perm

   # This means that threading occurs over all
   # leading non-trivial (not length 1) dims of
   # B unless all the thread dims are explicitly
   # matched to the LU dims.

THREAD_OK:

   # Permute the vector and make a copy if necessary.
   my $out;
   # my $nontrivial = ! (($perm==(PDL->xvals($perm->dims)))->all);
   my $nontrivial = ! (($perm==$perm->xvals)->clump(-1)->andover);

   if($nontrivial) {
      if($y->is_inplace) {
         $y .= $y->dummy(1,$y->dim(0))->index($perm->dummy(1,1))->sever;   # TODO: check threading
         $out = $y;
      } else {
         $out = $y->dummy(1,$y->dim(0))->index($perm->dummy(1,1))->sever;  # TODO: check threading
      }
   } else {
      # should check for more matrix dims to thread over
      # but ignore the issue for now
      $out = ($y->is_inplace ? $y : $y->copy);
   }
   print STDERR "lu_backsub: starting with \$out" . pdl($out->dims) . "\n" if $PDL::debug;

   # Make sure threading over lu happens OK...

   if($out->ndims < $lu->ndims-1) {
      print STDERR "lu_backsub: adjusting dims for \$out" . pdl($out->dims) . "\n" if $PDL::debug;
      do {
         $out = $out->dummy(-1,$lu->dim($out->ndims+1));
      } while($out->ndims < $lu->ndims-1);
      $out = $out->sever;
   }

   ## Do forward substitution into L
   my $row; my $r1;

   for $row(1..$n1) {
      $r1 = $row-1;
      my $tmp; # work around perl -d "feature
      ($tmp = $out->index($row)) -= ($lu->(0:$r1,$row) * 
         $out->(0:$r1)
      )->sumover;
   }

   ## Do backward substitution into U, and normalize by the diagonal
   my $ludiag = $lu->diagonal(0,1);
   {
      my $tmp; # work around for perl -d "feature"
      ($tmp = $out->index($n1)) /= $ludiag->index($n1)->dummy(0,1);        # TODO: check threading
   }

   for ($row=$n1; $row>0; $row--) {
      $r1 = $row-1;
      my $tmp; # work around for perl -d "feature"
      ($tmp = $out->index($r1)) -= ($lu->($row:$n1,$r1) *                  # TODO: check thread dims
         $out->($row:$n1)
      )->sumover;
      ($tmp = $out->index($r1)) /= $ludiag->index($r1)->dummy(0,1);        # TODO: check thread dims
   }

   $out;
}






=head2 simq

=for sig

  Signature: ([phys]a(n,n); [phys]b(n); [o,phys]x(n); int [o,phys]ips(n); int flag)


=for ref

Solution of simultaneous linear equations, C<a x = b>.

C<$a> is an C<n x n> matrix (i.e., a vector of length C<n*n>), stored row-wise:
that is, C<a(i,j) = a[ij]>, where C<ij = i*n + j>.  

While this is the transpose of the normal column-wise storage, this
corresponds to normal PDL usage.  The contents of matrix a may be
altered (but may be required for subsequent calls with flag = -1).

C<$y>, C<$x>, C<$ips> are vectors of length C<n>.

Set C<flag=0> to solve.  
Set C<flag=-1> to do a new back substitution for
different C<$y> vector using the same a matrix previously reduced when
C<flag=0> (the C<$ips> vector generated in the previous solution is also
required).

See also L<lu_backsub|lu_backsub>, which does the same thing with a slightly
less opaque interface.



=for bad

simq ignores the bad-value flag of the input piddles.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut






*simq = \&PDL::simq;





=head2 squaretotri

=for sig

  Signature: (a(n,n); b(m))


=for ref

Convert a symmetric square matrix to triangular vector storage.



=for bad

squaretotri does not process bad values.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut






*squaretotri = \&PDL::squaretotri;



;


sub eigen_c {
	print STDERR "eigen_c is no longer part of PDL::MatrixOps or PDL::Math; use eigens instead.\n";

##	my($mat) = @_;
##	my $s = $mat->getdim(0);
##	my $z = zeroes($s * ($s+1) / 2);
##	my $ev = zeroes($s);
##	squaretotri($mat,$z);
##	my $k = 0 * $mat;
##	PDL::eigens($z, $k, $ev);
##	return ($ev, $k);
}


=head1 AUTHOR

Copyright (C) 2002 Craig DeForest (deforest@boulder.swri.edu),
R.J.R. Williams (rjrw@ast.leeds.ac.uk), Karl Glazebrook
(kgb@aaoepp.aao.gov.au).  There is no warranty.  You are allowed to
redistribute and/or modify this work under the same conditions as PDL
itself.  If this file is separated from the PDL distribution, then the
PDL copyright notice should be included in this file.

=cut





# Exit with OK status

1;

		   