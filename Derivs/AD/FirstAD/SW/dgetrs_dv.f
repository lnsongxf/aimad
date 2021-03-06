!
! Copyright (C) 2006-2014 Houtan Bastani and Luca Guerrieri
!
!
! This free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! It is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with Dynare.  If not, see <http://www.gnu.org/licenses/>.
!

C        Generated by TAPENADE     (INRIA, Tropics team)
C  Tapenade - Version 2.2 (r1239) - Wed 28 Jun 2006 04:59:55 PM CEST
C
C  Differentiation of dgetrs in forward (tangent) mode: (multi-directional mode)
C   variations  of output variables: b
C   with respect to input variables: a b
      SUBROUTINE DGETRS_DV(trans, n, nrhs, a, ad, lda, ipiv, b, bd, ldb
     +                     , info, nbdirs)
      USE DIFFSIZES
      IMPLICIT NONE
C
C     End of DGETRS
C
      INTEGER info, ipiv(*), n, nrhs
      INTEGER lda, ldb, nbdirs
      DOUBLE PRECISION a(lda, *), ad(nbdirsmax, lda, *), b(ldb, *), bd(
     +                 nbdirsmax, ldb, *)
      CHARACTER trans
      DOUBLE PRECISION one
      PARAMETER (one=1.0d+0)
      INTEGER arg1, max1, max2
      LOGICAL LSAME, notran, result1, result2
      INTRINSIC MAX
      EXTERNAL XERBLA, LSAME
C
C  -- LAPACK routine (version 3.1) --
C     Univ. of Tennessee, Univ. of California Berkeley and NAG Ltd..
C     November 2006
C
C     .. Scalar Arguments ..
C     ..
C     .. Array Arguments ..
C     ..
C
C  Purpose
C  =======
C
C  DGETRS solves a system of linear equations
C     A * X = B  or  A' * X = B
C  with a general N-by-N matrix A using the LU factorization computed
C  by DGETRF.
C
C  Arguments
C  =========
C
C  TRANS   (input) CHARACTER*1
C          Specifies the form of the system of equations:
C          = 'N':  A * X = B  (No transpose)
C          = 'T':  A'* X = B  (Transpose)
C          = 'C':  A'* X = B  (Conjugate transpose = Transpose)
C
C  N       (input) INTEGER
C          The order of the matrix A.  N >= 0.
C
C  NRHS    (input) INTEGER
C          The number of right hand sides, i.e., the number of columns
C          of the matrix B.  NRHS >= 0.
C
C  A       (input) DOUBLE PRECISION array, dimension (LDA,N)
C          The factors L and U from the factorization A = P*L*U
C          as computed by DGETRF.
C
C  LDA     (input) INTEGER
C          The leading dimension of the array A.  LDA >= max(1,N).
C
C  IPIV    (input) INTEGER array, dimension (N)
C          The pivot indices from DGETRF; for 1<=i<=N, row i of the
C          matrix was interchanged with row IPIV(i).
C
C  B       (input/output) DOUBLE PRECISION array, dimension (LDB,NRHS)
C          On entry, the right hand side matrix B.
C          On exit, the solution matrix X.
C
C  LDB     (input) INTEGER
C          The leading dimension of the array B.  LDB >= max(1,N).
C
C  INFO    (output) INTEGER
C          = 0:  successful exit
C          < 0:  if INFO = -i, the i-th argument had an illegal value
C
C  =====================================================================
C
C     .. Parameters ..
C     ..
C     .. Local Scalars ..
C     ..
C     .. External Functions ..
C     ..
C     .. External Subroutines ..
C     ..
C     .. Intrinsic Functions ..
C     ..
C     .. Executable Statements ..
C
C     Test the input parameters.
C
      info = 0
      notran = LSAME(trans, 'N')
      result1 = LSAME(trans, 'T')
      result2 = LSAME(trans, 'C')
      IF (.NOT.notran .AND. (.NOT.result1) .AND. (.NOT.result2)) THEN
        info = -1
      ELSE IF (n .LT. 0) THEN
        info = -2
      ELSE IF (nrhs .LT. 0) THEN
        info = -3
      ELSE
        IF (1 .LT. n) THEN
          max1 = n
        ELSE
          max1 = 1
        END IF
        IF (lda .LT. max1) THEN
          info = -5
        ELSE
          IF (1 .LT. n) THEN
            max2 = n
          ELSE
            max2 = 1
          END IF
          IF (ldb .LT. max2) info = -8
        END IF
      END IF
      IF (info .NE. 0) THEN
        arg1 = -info
        CALL XERBLA('DGETRS', arg1)
        RETURN
      ELSE IF (n .EQ. 0 .OR. nrhs .EQ. 0) THEN
C
C     Quick return if possible
C
        RETURN
      ELSE
C
        IF (notran) THEN
C
C        Solve A * X = B.
C
C        Apply row interchanges to the right hand sides.
C
          CALL DLASWP_DV(nrhs, b, bd, ldb, 1, n, ipiv, 1, nbdirs)
C
C        Solve L*X = B, overwriting B with X.
C
          CALL DTRSM_DV('Left', 'Lower', 'No transpose', 'Unit', n, nrhs
     +                  , one, a, ad, lda, b, bd, ldb, nbdirs)
C
C        Solve U*X = B, overwriting B with X.
C
          CALL DTRSM_DV('Left', 'Upper', 'No transpose', 'Non-unit', n,
     +                  nrhs, one, a, ad, lda, b, bd, ldb, nbdirs)
        ELSE
C
C        Solve A' * X = B.
C
C        Solve U'*X = B, overwriting B with X.
C
          CALL DTRSM_DV('Left', 'Upper', 'Transpose', 'Non-unit', n,
     +                  nrhs, one, a, ad, lda, b, bd, ldb, nbdirs)
C
C        Solve L'*X = B, overwriting B with X.
C
          CALL DTRSM_DV('Left', 'Lower', 'Transpose', 'Unit', n, nrhs,
     +                  one, a, ad, lda, b, bd, ldb, nbdirs)
C
C        Apply row interchanges to the solution vectors.
C
          arg1 = -1
          CALL DLASWP_DV(nrhs, b, bd, ldb, 1, n, ipiv, arg1, nbdirs)
        END IF
C
        RETURN
      END IF
      END
