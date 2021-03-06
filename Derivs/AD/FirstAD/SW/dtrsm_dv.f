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
C  Differentiation of dtrsm in forward (tangent) mode: (multi-directional mode)
C   variations  of output variables: b
C   with respect to input variables: a b
      SUBROUTINE DTRSM_DV(side, uplo, transa, diag, m, n, alpha, a, ad,
     +                    lda, b, bd, ldb, nbdirs)
      USE DIFFSIZES
      IMPLICIT NONE
C
C     End of DTRSM .
C
      DOUBLE PRECISION alpha
      INTEGER lda, ldb, nbdirs
      DOUBLE PRECISION a(lda, *), ad(nbdirsmax, lda, *), b(ldb, *), bd(
     +                 nbdirsmax, ldb, *)
      INTEGER m, n
      CHARACTER diag, side, transa, uplo
      DOUBLE PRECISION one, zero
      PARAMETER (one=1.0d+0, zero=0.0d+0)
      INTEGER i, info, j, k, max1, max2, nd, nrowa
      LOGICAL LSAME, lside, nounit, result1, result2, result3, upper
      DOUBLE PRECISION temp, tempd(nbdirsmax)
      INTRINSIC MAX
      EXTERNAL XERBLA, LSAME
C     .. Scalar Arguments ..
C     ..
C     .. Array Arguments ..
C     ..
C
C  Purpose
C  =======
C
C  DTRSM  solves one of the matrix equations
C
C     op( A )*X = alpha*B,   or   X*op( A ) = alpha*B,
C
C  where alpha is a scalar, X and B are m by n matrices, A is a unit, or
C  non-unit,  upper or lower triangular matrix  and  op( A )  is one  of
C
C     op( A ) = A   or   op( A ) = A'.
C
C  The matrix X is overwritten on B.
C
C  Arguments
C  ==========
C
C  SIDE   - CHARACTER*1.
C           On entry, SIDE specifies whether op( A ) appears on the left
C           or right of X as follows:
C
C              SIDE = 'L' or 'l'   op( A )*X = alpha*B.
C
C              SIDE = 'R' or 'r'   X*op( A ) = alpha*B.
C
C           Unchanged on exit.
C
C  UPLO   - CHARACTER*1.
C           On entry, UPLO specifies whether the matrix A is an upper or
C           lower triangular matrix as follows:
C
C              UPLO = 'U' or 'u'   A is an upper triangular matrix.
C
C              UPLO = 'L' or 'l'   A is a lower triangular matrix.
C
C           Unchanged on exit.
C
C  TRANSA - CHARACTER*1.
C           On entry, TRANSA specifies the form of op( A ) to be used in
C           the matrix multiplication as follows:
C
C              TRANSA = 'N' or 'n'   op( A ) = A.
C
C              TRANSA = 'T' or 't'   op( A ) = A'.
C
C              TRANSA = 'C' or 'c'   op( A ) = A'.
C
C           Unchanged on exit.
C
C  DIAG   - CHARACTER*1.
C           On entry, DIAG specifies whether or not A is unit triangular
C           as follows:
C
C              DIAG = 'U' or 'u'   A is assumed to be unit triangular.
C
C              DIAG = 'N' or 'n'   A is not assumed to be unit
C                                  triangular.
C
C           Unchanged on exit.
C
C  M      - INTEGER.
C           On entry, M specifies the number of rows of B. M must be at
C           least zero.
C           Unchanged on exit.
C
C  N      - INTEGER.
C           On entry, N specifies the number of columns of B.  N must be
C           at least zero.
C           Unchanged on exit.
C
C  ALPHA  - DOUBLE PRECISION.
C           On entry,  ALPHA specifies the scalar  alpha. When  alpha is
C           zero then  A is not referenced and  B need not be set before
C           entry.
C           Unchanged on exit.
C
C  A      - DOUBLE PRECISION array of DIMENSION ( LDA, k ), where k is m
C           when  SIDE = 'L' or 'l'  and is  n  when  SIDE = 'R' or 'r'.
C           Before entry  with  UPLO = 'U' or 'u',  the  leading  k by k
C           upper triangular part of the array  A must contain the upper
C           triangular matrix  and the strictly lower triangular part of
C           A is not referenced.
C           Before entry  with  UPLO = 'L' or 'l',  the  leading  k by k
C           lower triangular part of the array  A must contain the lower
C           triangular matrix  and the strictly upper triangular part of
C           A is not referenced.
C           Note that when  DIAG = 'U' or 'u',  the diagonal elements of
C           A  are not referenced either,  but are assumed to be  unity.
C           Unchanged on exit.
C
C  LDA    - INTEGER.
C           On entry, LDA specifies the first dimension of A as declared
C           in the calling (sub) program.  When  SIDE = 'L' or 'l'  then
C           LDA  must be at least  max( 1, m ),  when  SIDE = 'R' or 'r'
C           then LDA must be at least max( 1, n ).
C           Unchanged on exit.
C
C  B      - DOUBLE PRECISION array of DIMENSION ( LDB, n ).
C           Before entry,  the leading  m by n part of the array  B must
C           contain  the  right-hand  side  matrix  B,  and  on exit  is
C           overwritten by the solution matrix  X.
C
C  LDB    - INTEGER.
C           On entry, LDB specifies the first dimension of B as declared
C           in  the  calling  (sub)  program.   LDB  must  be  at  least
C           max( 1, m ).
C           Unchanged on exit.
C
C
C  Level 3 Blas routine.
C
C
C  -- Written on 8-February-1989.
C     Jack Dongarra, Argonne National Laboratory.
C     Iain Duff, AERE Harwell.
C     Jeremy Du Croz, Numerical Algorithms Group Ltd.
C     Sven Hammarling, Numerical Algorithms Group Ltd.
C
C
C     .. External Functions ..
C     ..
C     .. External Subroutines ..
C     ..
C     .. Intrinsic Functions ..
C     ..
C     .. Local Scalars ..
C     ..
C     .. Parameters ..
C     ..
C
C     Test the input parameters.
C
      lside = LSAME(side, 'L')
      IF (lside) THEN
        nrowa = m
      ELSE
        nrowa = n
      END IF
      nounit = LSAME(diag, 'N')
      upper = LSAME(uplo, 'U')
C
      info = 0
      result1 = LSAME(side, 'R')
      IF (.NOT.lside .AND. (.NOT.result1)) THEN
        info = 1
      ELSE
        result1 = LSAME(uplo, 'L')
        IF (.NOT.upper .AND. (.NOT.result1)) THEN
          info = 2
        ELSE
          result1 = LSAME(transa, 'N')
          result2 = LSAME(transa, 'T')
          result3 = LSAME(transa, 'C')
          IF (.NOT.result1 .AND. (.NOT.result2) .AND. (.NOT.result3))
     +    THEN
            info = 3
          ELSE
            result1 = LSAME(diag, 'U')
            result2 = LSAME(diag, 'N')
            IF (.NOT.result1 .AND. (.NOT.result2)) THEN
              info = 4
            ELSE IF (m .LT. 0) THEN
              info = 5
            ELSE IF (n .LT. 0) THEN
              info = 6
            ELSE
              IF (1 .LT. nrowa) THEN
                max1 = nrowa
              ELSE
                max1 = 1
              END IF
              IF (lda .LT. max1) THEN
                info = 9
              ELSE
                IF (1 .LT. m) THEN
                  max2 = m
                ELSE
                  max2 = 1
                END IF
                IF (ldb .LT. max2) info = 11
              END IF
            END IF
          END IF
        END IF
      END IF
      IF (info .NE. 0) THEN
        CALL XERBLA('DTRSM ', info)
        RETURN
      ELSE IF (n .EQ. 0) THEN
C
C     Quick return if possible.
C
        RETURN
      ELSE IF (alpha .EQ. zero) THEN
C
C     And when  alpha.eq.zero.
C
        DO j=1,n
          DO i=1,m
            DO nd=1,nbdirs
              bd(nd, i, j) = 0.D0
            ENDDO
            b(i, j) = zero
          ENDDO
        ENDDO
        RETURN
      ELSE
C
C     Start the operations.
C
        IF (lside) THEN
          result1 = LSAME(transa, 'N')
          IF (result1) THEN
C
C           Form  B := alpha*inv( A )*B.
C
            IF (upper) THEN
              DO j=1,n
                IF (alpha .NE. one) THEN
                  DO i=1,m
                    DO nd=1,nbdirs
                      bd(nd, i, j) = alpha*bd(nd, i, j)
                    ENDDO
                    b(i, j) = alpha*b(i, j)
                  ENDDO
                END IF
                DO k=m,1,-1
                  IF (b(k, j) .NE. zero) THEN
                    IF (nounit) THEN
                      DO nd=1,nbdirs
                        bd(nd, k, j) = (bd(nd, k, j)*a(k, k)-b(k, j)*ad(
     +                    nd, k, k))/a(k, k)**2
                      ENDDO
                      b(k, j) = b(k, j)/a(k, k)
                    END IF
                    DO i=1,k-1
                      DO nd=1,nbdirs
                        bd(nd, i, j) = bd(nd, i, j) - bd(nd, k, j)*a(i,
     +                    k) - b(k, j)*ad(nd, i, k)
                      ENDDO
                      b(i, j) = b(i, j) - b(k, j)*a(i, k)
                    ENDDO
                  END IF
                ENDDO
              ENDDO
            ELSE
              DO j=1,n
                IF (alpha .NE. one) THEN
                  DO i=1,m
                    DO nd=1,nbdirs
                      bd(nd, i, j) = alpha*bd(nd, i, j)
                    ENDDO
                    b(i, j) = alpha*b(i, j)
                  ENDDO
                END IF
                DO k=1,m
                  IF (b(k, j) .NE. zero) THEN
                    IF (nounit) THEN
                      DO nd=1,nbdirs
                        bd(nd, k, j) = (bd(nd, k, j)*a(k, k)-b(k, j)*ad(
     +                    nd, k, k))/a(k, k)**2
                      ENDDO
                      b(k, j) = b(k, j)/a(k, k)
                    END IF
                    DO i=k+1,m
                      DO nd=1,nbdirs
                        bd(nd, i, j) = bd(nd, i, j) - bd(nd, k, j)*a(i,
     +                    k) - b(k, j)*ad(nd, i, k)
                      ENDDO
                      b(i, j) = b(i, j) - b(k, j)*a(i, k)
                    ENDDO
                  END IF
                ENDDO
              ENDDO
            END IF
          ELSE IF (upper) THEN
C
C           Form  B := alpha*inv( A' )*B.
C
            DO j=1,n
              DO i=1,m
                DO nd=1,nbdirs
                  tempd(nd) = alpha*bd(nd, i, j)
                ENDDO
                temp = alpha*b(i, j)
                DO k=1,i-1
                  DO nd=1,nbdirs
                    tempd(nd) = tempd(nd) - ad(nd, k, i)*b(k, j) - a(k,
     +                i)*bd(nd, k, j)
                  ENDDO
                  temp = temp - a(k, i)*b(k, j)
                ENDDO
                IF (nounit) THEN
                  DO nd=1,nbdirs
                    tempd(nd) = (tempd(nd)*a(i, i)-temp*ad(nd, i, i))/a(
     +                i, i)**2
                  ENDDO
                  temp = temp/a(i, i)
                END IF
                DO nd=1,nbdirs
                  bd(nd, i, j) = tempd(nd)
                ENDDO
                b(i, j) = temp
              ENDDO
            ENDDO
          ELSE
            DO j=1,n
              DO i=m,1,-1
                DO nd=1,nbdirs
                  tempd(nd) = alpha*bd(nd, i, j)
                ENDDO
                temp = alpha*b(i, j)
                DO k=i+1,m
                  DO nd=1,nbdirs
                    tempd(nd) = tempd(nd) - ad(nd, k, i)*b(k, j) - a(k,
     +                i)*bd(nd, k, j)
                  ENDDO
                  temp = temp - a(k, i)*b(k, j)
                ENDDO
                IF (nounit) THEN
                  DO nd=1,nbdirs
                    tempd(nd) = (tempd(nd)*a(i, i)-temp*ad(nd, i, i))/a(
     +                i, i)**2
                  ENDDO
                  temp = temp/a(i, i)
                END IF
                DO nd=1,nbdirs
                  bd(nd, i, j) = tempd(nd)
                ENDDO
                b(i, j) = temp
              ENDDO
            ENDDO
          END IF
        ELSE
          result1 = LSAME(transa, 'N')
          IF (result1) THEN
C
C           Form  B := alpha*B*inv( A ).
C
            IF (upper) THEN
              DO j=1,n
                IF (alpha .NE. one) THEN
                  DO i=1,m
                    DO nd=1,nbdirs
                      bd(nd, i, j) = alpha*bd(nd, i, j)
                    ENDDO
                    b(i, j) = alpha*b(i, j)
                  ENDDO
                END IF
                DO k=1,j-1
                  IF (a(k, j) .NE. zero) THEN
                    DO i=1,m
                      DO nd=1,nbdirs
                        bd(nd, i, j) = bd(nd, i, j) - ad(nd, k, j)*b(i,
     +                    k) - a(k, j)*bd(nd, i, k)
                      ENDDO
                      b(i, j) = b(i, j) - a(k, j)*b(i, k)
                    ENDDO
                  END IF
                ENDDO
                IF (nounit) THEN
                  DO nd=1,nbdirs
                    tempd(nd) = -(one*ad(nd, j, j)/a(j, j)**2)
                  ENDDO
                  temp = one/a(j, j)
                  DO i=1,m
                    DO nd=1,nbdirs
                      bd(nd, i, j) = tempd(nd)*b(i, j) + temp*bd(nd, i,
     +                  j)
                    ENDDO
                    b(i, j) = temp*b(i, j)
                  ENDDO
                END IF
              ENDDO
            ELSE
              DO j=n,1,-1
                IF (alpha .NE. one) THEN
                  DO i=1,m
                    DO nd=1,nbdirs
                      bd(nd, i, j) = alpha*bd(nd, i, j)
                    ENDDO
                    b(i, j) = alpha*b(i, j)
                  ENDDO
                END IF
                DO k=j+1,n
                  IF (a(k, j) .NE. zero) THEN
                    DO i=1,m
                      DO nd=1,nbdirs
                        bd(nd, i, j) = bd(nd, i, j) - ad(nd, k, j)*b(i,
     +                    k) - a(k, j)*bd(nd, i, k)
                      ENDDO
                      b(i, j) = b(i, j) - a(k, j)*b(i, k)
                    ENDDO
                  END IF
                ENDDO
                IF (nounit) THEN
                  DO nd=1,nbdirs
                    tempd(nd) = -(one*ad(nd, j, j)/a(j, j)**2)
                  ENDDO
                  temp = one/a(j, j)
                  DO i=1,m
                    DO nd=1,nbdirs
                      bd(nd, i, j) = tempd(nd)*b(i, j) + temp*bd(nd, i,
     +                  j)
                    ENDDO
                    b(i, j) = temp*b(i, j)
                  ENDDO
                END IF
              ENDDO
            END IF
          ELSE IF (upper) THEN
C
C           Form  B := alpha*B*inv( A' ).
C
            DO k=n,1,-1
              IF (nounit) THEN
                DO nd=1,nbdirs
                  tempd(nd) = -(one*ad(nd, k, k)/a(k, k)**2)
                ENDDO
                temp = one/a(k, k)
                DO i=1,m
                  DO nd=1,nbdirs
                    bd(nd, i, k) = tempd(nd)*b(i, k) + temp*bd(nd, i, k)
                  ENDDO
                  b(i, k) = temp*b(i, k)
                ENDDO
              END IF
              DO j=1,k-1
                IF (a(j, k) .NE. zero) THEN
                  DO nd=1,nbdirs
                    tempd(nd) = ad(nd, j, k)
                  ENDDO
                  temp = a(j, k)
                  DO i=1,m
                    DO nd=1,nbdirs
                      bd(nd, i, j) = bd(nd, i, j) - tempd(nd)*b(i, k) -
     +                  temp*bd(nd, i, k)
                    ENDDO
                    b(i, j) = b(i, j) - temp*b(i, k)
                  ENDDO
                END IF
              ENDDO
              IF (alpha .NE. one) THEN
                DO i=1,m
                  DO nd=1,nbdirs
                    bd(nd, i, k) = alpha*bd(nd, i, k)
                  ENDDO
                  b(i, k) = alpha*b(i, k)
                ENDDO
              END IF
            ENDDO
          ELSE
            DO k=1,n
              IF (nounit) THEN
                DO nd=1,nbdirs
                  tempd(nd) = -(one*ad(nd, k, k)/a(k, k)**2)
                ENDDO
                temp = one/a(k, k)
                DO i=1,m
                  DO nd=1,nbdirs
                    bd(nd, i, k) = tempd(nd)*b(i, k) + temp*bd(nd, i, k)
                  ENDDO
                  b(i, k) = temp*b(i, k)
                ENDDO
              END IF
              DO j=k+1,n
                IF (a(j, k) .NE. zero) THEN
                  DO nd=1,nbdirs
                    tempd(nd) = ad(nd, j, k)
                  ENDDO
                  temp = a(j, k)
                  DO i=1,m
                    DO nd=1,nbdirs
                      bd(nd, i, j) = bd(nd, i, j) - tempd(nd)*b(i, k) -
     +                  temp*bd(nd, i, k)
                    ENDDO
                    b(i, j) = b(i, j) - temp*b(i, k)
                  ENDDO
                END IF
              ENDDO
              IF (alpha .NE. one) THEN
                DO i=1,m
                  DO nd=1,nbdirs
                    bd(nd, i, k) = alpha*bd(nd, i, k)
                  ENDDO
                  b(i, k) = alpha*b(i, k)
                ENDDO
              END IF
            ENDDO
          END IF
        END IF
C
        RETURN
      END IF
      END
