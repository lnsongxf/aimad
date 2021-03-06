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
C  Differentiation of dlarfg in forward (tangent) mode: (multi-directional mode)
C   variations  of output variables: tau alpha x
C   with respect to input variables: alpha x
      SUBROUTINE DLARFG_DV(n, alpha, alphad, x, xd, incx, tau, taud,
     +                     nbdirs)
      USE DIFFSIZES
      IMPLICIT NONE
C
C     End of DLARFG
C
      INTEGER incx, n
      INTEGER nbdirs
      DOUBLE PRECISION alpha, alphad(nbdirsmax), tau, taud(nbdirsmax)
      DOUBLE PRECISION x(*), xd(nbdirsmax, *)
      DOUBLE PRECISION one, zero
      PARAMETER (one=1.0d+0, zero=0.0d+0)
      DOUBLE PRECISION arg10, arg10d(nbdirsmax), DLAPY2
      DOUBLE PRECISION arg2, arg2d(nbdirsmax)
      DOUBLE PRECISION DNRM2
      INTEGER arg1, j, knt, nd
      DOUBLE PRECISION DLAMCH, result1, result2
      DOUBLE PRECISION abs1, abs2, beta, betad(nbdirsmax), rsafmn,
     +                 rsafmnd(nbdirsmax), safmin, xnorm, xnormd(
     +                 nbdirsmax)
      EXTERNAL DLAMCH
      INTRINSIC SIGN, ABS
C
C  -- LAPACK auxiliary routine (version 3.1) --
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
C  DLARFG generates a real elementary reflector H of order n, such
C  that
C
C        H * ( alpha ) = ( beta ),   H' * H = I.
C            (   x   )   (   0  )
C
C  where alpha and beta are scalars, and x is an (n-1)-element real
C  vector. H is represented in the form
C
C        H = I - tau * ( 1 ) * ( 1 v' ) ,
C                      ( v )
C
C  where tau is a real scalar and v is a real (n-1)-element
C  vector.
C
C  If the elements of x are all zero, then tau = 0 and H is taken to be
C  the unit matrix.
C
C  Otherwise  1 <= tau <= 2.
C
C  Arguments
C  =========
C
C  N       (input) INTEGER
C          The order of the elementary reflector.
C
C  ALPHA   (input/output) DOUBLE PRECISION
C          On entry, the value alpha.
C          On exit, it is overwritten with the value beta.
C
C  X       (input/output) DOUBLE PRECISION array, dimension
C                         (1+(N-2)*abs(INCX))
C          On entry, the vector x.
C          On exit, it is overwritten with the vector v.
C
C  INCX    (input) INTEGER
C          The increment between elements of X. INCX > 0.
C
C  TAU     (output) DOUBLE PRECISION
C          The value tau.
C
C  =====================================================================
C
C     .. Parameters ..
C     ..
C     .. Local Scalars ..
C     ..
C     .. External Functions ..
C     ..
C     .. Intrinsic Functions ..
C     ..
C     .. External Subroutines ..
C     ..
C     .. Executable Statements ..
C
      IF (n .LE. 1) THEN
        tau = zero
        DO nd=1,nbdirs
          taud(nd) = 0.D0
        ENDDO
        RETURN
      ELSE
C
        arg1 = n - 1
        CALL DNRM2_DV(arg1, x, xd, incx, xnorm, xnormd, nbdirs)
C
        IF (xnorm .EQ. zero) THEN
C
C        H  =  I
C
          tau = zero
          DO nd=1,nbdirs
            taud(nd) = 0.D0
          ENDDO
        ELSE
C
C        general case
C
          CALL DLAPY2_DV(alpha, alphad, xnorm, xnormd, arg10, arg10d,
     +                   nbdirs)
          DO nd=1,nbdirs
            betad(nd) = -SIGN(arg10d(nd), alpha)
          ENDDO
          beta = -SIGN(arg10, alpha)
          result1 = DLAMCH('S')
          result2 = DLAMCH('E')
          safmin = result1/result2
          IF (beta .GE. 0.) THEN
            abs1 = beta
          ELSE
            abs1 = -beta
          END IF
          IF (abs1 .LT. safmin) THEN
C
C           XNORM, BETA may be inaccurate; scale X and recompute them
C
            rsafmn = one/safmin
            knt = 0
 10         knt = knt + 1
            arg1 = n - 1
            DO nd=1,nbdirs
              rsafmnd(nd) = 0.D0
              alphad(nd) = rsafmn*alphad(nd)
            ENDDO
            CALL DSCAL_DV(arg1, rsafmn, rsafmnd, x, xd, incx, nbdirs)
            beta = beta*rsafmn
            alpha = alpha*rsafmn
            IF (beta .GE. 0.) THEN
              abs2 = beta
            ELSE
              abs2 = -beta
            END IF
            IF (abs2 .LT. safmin) GOTO 10
C
C           New BETA is at most 1, at least SAFMIN
C
            arg1 = n - 1
            CALL DNRM2_DV(arg1, x, xd, incx, xnorm, xnormd, nbdirs)
            CALL DLAPY2_DV(alpha, alphad, xnorm, xnormd, arg10, arg10d,
     +                     nbdirs)
            beta = -SIGN(arg10, alpha)
            DO nd=1,nbdirs
              betad(nd) = -SIGN(arg10d(nd), alpha)
              arg2d(nd) = -(one*(alphad(nd)-betad(nd))/(alpha-beta)**2)
              taud(nd) = ((betad(nd)-alphad(nd))*beta-(beta-alpha)*betad
     +          (nd))/beta**2
              alphad(nd) = betad(nd)
            ENDDO
            tau = (beta-alpha)/beta
            arg1 = n - 1
            arg2 = one/(alpha-beta)
            CALL DSCAL_DV(arg1, arg2, arg2d, x, xd, incx, nbdirs)
C
C           If ALPHA is subnormal, it may lose relative accuracy
C
            alpha = beta
            DO j=1,knt
              DO nd=1,nbdirs
                alphad(nd) = safmin*alphad(nd)
              ENDDO
              alpha = alpha*safmin
            ENDDO
          ELSE
            tau = (beta-alpha)/beta
            arg1 = n - 1
            DO nd=1,nbdirs
              arg2d(nd) = -(one*(alphad(nd)-betad(nd))/(alpha-beta)**2)
              taud(nd) = ((betad(nd)-alphad(nd))*beta-(beta-alpha)*betad
     +          (nd))/beta**2
              alphad(nd) = betad(nd)
            ENDDO
            arg2 = one/(alpha-beta)
            CALL DSCAL_DV(arg1, arg2, arg2d, x, xd, incx, nbdirs)
            alpha = beta
          END IF
        END IF
C
        RETURN
      END IF
      END
