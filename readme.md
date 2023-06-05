PDL::Matrix

    NAME
    VERSION
    SYNOPSIS
    DESCRIPTION
        Overview
        Implementation
    NOTES
    FUNCTIONS
        mpdl, PDL::Matrix::pdl
        mzeroes, mones, msequence
        vpdl
        vzeroes, vones, vsequence
        kroneckerproduct
        det_general
        trace
    BUGS AND PROBLEMS
    TODO
    AUTHOR(S)
    COPYRIGHT

NAME

PDL::Matrix -- a convenience matrix class for column-major access
VERSION

This document refers to version PDL::Matrix 0.5 of PDL::Matrix
SYNOPSIS

  use PDL::Matrix;
  $m = mpdl [[1,2,3],[4,5,6]];
  $m = PDL::Matrix->pdl([[1,2,3],[4,5,6]]);
  $m = msequence(4,3);
  @dimsa = $x->mdims; # 'dims' is not overloaded
  $v = vpdl [0,1,2,3]
  $v = vzeroes(4);

DESCRIPTION
Overview

This package tries to help people who want to use PDL for 2D matrix computation with lots of indexing involved. It provides a PDL subclass so one- and two-dimensional piddles that are used as vectors resp and matrices can be typed in using traditional matrix convention.

If you want to know more about matrix operation support in PDL, you want to read PDL::MatrixOps or PDL::Slatec.

The original pdl class refers to the first index as the first row, the second index as the first column of a matrix. Consider

  print $B = sequence(3,2)
  [
   [0 1 2]
   [3 4 5]
  ]

which gives a 2x3 matrix in terms of the matrix convention, but the constructor used (3,2). This might get more confusing when using slices like sequence(3,2)->slice("1:2,(0)") : with traditional matrix convention one would expect [2 4] instead of [1 2].

This subclass PDL::Matrix overloads the constructors and indexing functions of pdls so that they are compatible with the usual matrix convention, where the first dimension refers to the row of a matrix. So now, the above example would be written as

  print $B = PDL::Matrix->sequence(3,2) # or $B = msequence(3,2)
  [
   [0 1]
   [2 3]
   [4 5]
  ]

Routines like eigens or inv can be used without any changes.

Furthermore one can construct and use vectors as n x 1 matrices without mentioning the second index '1'.
Implementation

PDL::Matrix works by overloading a number of PDL constructors and methods such that first and second args (corresponding to first and second dims of corresponding matrices) are effectively swapped. It is not yet clear if PDL::Matrix achieves a consistent column-major look-and-feel in this way.
NOTES

As of version 0.5 (rewrite by CED) the matrices are stored in the usual way, just constructed and stringified differently. That way indexing and everything else works the way you think it should.
FUNCTIONS
mpdl, PDL::Matrix::pdl

constructs an object of class PDL::Matrix which is a piddle child class.

    $m = mpdl [[1,2,3],[4,5,6]];
    $m = PDL::Matrix->pdl([[1,2,3],[4,5,6]]);

mzeroes, mones, msequence

constructs a PDL::Matrix object similar to the piddle constructors zeroes, ones, sequence.
vpdl

constructs an object of class PDL::Matrix which is of matrix dimensions (n x 1)

    print $v = vpdl [0,1];
    [
     [0]
     [1]
    ]

vzeroes, vones, vsequence

constructs a PDL::Matrix object with matrix dimensions (n x 1), therefore only the first scalar argument is used.

    print $v = vsequence(2);
    [
     [0]
     [1]
    ]

kroneckerproduct

returns kroneckerproduct of two matrices. This is not efficiently implemented.
det_general

returns a generalized determinant of a matrix. If the matrix is not regular, one can specify the rank of the matrix and the corresponding subdeterminant is returned. This is implemented using the eigens function.
trace

returns the trace of a matrix (sum of diagonals)
BUGS AND PROBLEMS

Because we change the way piddles are constructed, not all pdl operators may be applied to piddle-matrices. The inner product is not redefined. We might have missed some functions/methods. Internal consistency of our approach needs yet to be established.

Because PDL::Matrix changes the way slicing behaves, it breaks many operators, notably those in MatrixOps.
TODO

check all PDL functions, benchmarks, optimization, lots of other things ...
AUTHOR(S)

Stephan Heuel (stephan@heuel.org), Christian Soeller (c.soeller@auckland.ac.nz).
COPYRIGHT

All rights reserved. There is no warranty. You are allowed to redistribute this software / documentation under certain conditions. For details, see the file COPYING in the PDL distribution. If this file is separated from the PDL distribution, the copyright notice should be included in the file.
