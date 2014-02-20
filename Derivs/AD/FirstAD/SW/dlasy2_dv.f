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
C  Differentiation of dlasy2 in forward (tangent) mode: (multi-directional mode)
C   variations  of output variables: x scale
C   with respect to input variables: tl tr x scale b
      SUBROUTINE DLASY2_DV(ltranl, ltranr, isgn, n1, n2, tl, tld, ldtl,
     +                     tr, trd, ldtr, b, bd, ldb, scale, scaled, x,
     +                     xd, ldx, xnorm, info, nbdirs)
      USE DIFFSIZES
      IMPLICIT NONE
C
C     End of DLASY2
C
      INTEGER info, isgn, n1, n2
      INTEGER ldb, ldtl, ldtr, ldx, nbdirs
      DOUBLE PRECISION b(ldb, *), bd(nbdirsmax, ldb, *), tl(ldtl, *),
     +                 tld(nbdirsmax, ldtl, *), tr(ldtr, *), trd(
     +                 nbdirsmax, ldtr, *), x(ldx, *), xd(nbdirsmax, ldx
     +                 , *)
      LOGICAL ltranl, ltranr
      DOUBLE PRECISION scale, scaled(nbdirsmax), xnorm
      DOUBLE PRECISION eight, half, two
      PARAMETER (eight=8.0d+0, half=0.5d+0, two=2.0d+0)
      DOUBLE PRECISION one, zero
      PARAMETER (one=1.0d+0, zero=0.0d+0)
      DOUBLE PRECISION abs1, abs13, abs14, abs15, abs16, abs17, abs18,
     +                 abs19, abs2, abs20, abs21, abs3, abs34, abs35,
     +                 abs4, abs5, abs6, abs7, abs8
      DOUBLE PRECISION abs11, abs12, abs22, abs23, abs24, abs25, abs26,
     +                 abs27, abs28, abs29, abs30, abs31, abs33, abs36,
     +                 abs37, abs38, abs39, abs40, abs41, abs42, abs44,
     +                 abs45, abs46, abs47, abs48, abs49, btmp(4), btmpd
     +                 (nbdirsmax, 4), t16(4, 4), t16d(nbdirsmax, 4, 4)
     +                 , tmp(4), tmpd(nbdirsmax, 4), x2(2), x2d(
     +                 nbdirsmax, 2)
      DOUBLE PRECISION abs10, abs32, abs43, abs9, bet, eps, gam, gamd(
     +                 nbdirsmax), l21, l21d(nbdirsmax), sgn, smin,
     +                 smind(nbdirsmax), smlnum, tau1, tau1d(nbdirsmax)
     +                 , temp, tempd(nbdirsmax), u11, u11d(nbdirsmax),
     +                 u12, u12d(nbdirsmax), u22, u22d(nbdirsmax), xmax
      INTEGER i, IDAMAX, ii1, ip, ipiv, ipsv, j, jp, jpiv(4), jpsv, k,
     +        locl21(4), locu12(4), locu22(4), nd
      DOUBLE PRECISION DLAMCH, result1
      REAL tmpmax, tmpmaxd(nbdirsmax)
      LOGICAL bswap, bswpiv(4), xswap, xswpiv(4)
      EXTERNAL DLAMCH
      INTRINSIC MAX, ABS
      DATA locu12 /3, 4, 1, 2/
      DATA locl21 /2, 1, 4, 3/
      DATA locu22 /4, 3, 2, 1/
      DATA xswpiv /.false., .false., .true., .true./
      DATA bswpiv /.false., .true., .false., .true./
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
C  DLASY2 solves for the N1 by N2 matrix X, 1 <= N1,N2 <= 2, in
C
C         op(TL)*X + ISGN*X*op(TR) = SCALE*B,
C
C  where TL is N1 by N1, TR is N2 by N2, B is N1 by N2, and ISGN = 1 or
C  -1.  op(T) = T or T', where T' denotes the transpose of T.
C
C  Arguments
C  =========
C
C  LTRANL  (input) LOGICAL
C          On entry, LTRANL specifies the op(TL):
C             = .FALSE., op(TL) = TL,
C             = .TRUE., op(TL) = TL'.
C
C  LTRANR  (input) LOGICAL
C          On entry, LTRANR specifies the op(TR):
C            = .FALSE., op(TR) = TR,
C            = .TRUE., op(TR) = TR'.
C
C  ISGN    (input) INTEGER
C          On entry, ISGN specifies the sign of the equation
C          as described before. ISGN may only be 1 or -1.
C
C  N1      (input) INTEGER
C          On entry, N1 specifies the order of matrix TL.
C          N1 may only be 0, 1 or 2.
C
C  N2      (input) INTEGER
C          On entry, N2 specifies the order of matrix TR.
C          N2 may only be 0, 1 or 2.
C
C  TL      (input) DOUBLE PRECISION array, dimension (LDTL,2)
C          On entry, TL contains an N1 by N1 matrix.
C
C  LDTL    (input) INTEGER
C          The leading dimension of the matrix TL. LDTL >= max(1,N1).
C
C  TR      (input) DOUBLE PRECISION array, dimension (LDTR,2)
C          On entry, TR contains an N2 by N2 matrix.
C
C  LDTR    (input) INTEGER
C          The leading dimension of the matrix TR. LDTR >= max(1,N2).
C
C  B       (input) DOUBLE PRECISION array, dimension (LDB,2)
C          On entry, the N1 by N2 matrix B contains the right-hand
C          side of the equation.
C
C  LDB     (input) INTEGER
C          The leading dimension of the matrix B. LDB >= max(1,N1).
C
C  SCALE   (output) DOUBLE PRECISION
C          On exit, SCALE contains the scale factor. SCALE is chosen
C          less than or equal to 1 to prevent the solution overflowing.
C
C  X       (output) DOUBLE PRECISION array, dimension (LDX,2)
C          On exit, X contains the N1 by N2 solution.
C
C  LDX     (input) INTEGER
C          The leading dimension of the matrix X. LDX >= max(1,N1).
C
C  XNORM   (output) DOUBLE PRECISION
C          On exit, XNORM is the infinity-norm of the solution.
C
C  INFO    (output) INTEGER
C          On exit, INFO is set to
C             0: successful exit.
C             1: TL and TR have too close eigenvalues, so TL or
C                TR is perturbed to get a nonsingular equation.
C          NOTE: In the interests of speed, this routine does not
C                check the inputs for errors.
C
C =====================================================================
C
C     .. Parameters ..
C     ..
C     .. Local Scalars ..
C     ..
C     .. Local Arrays ..
C     ..
C     .. External Functions ..
C     ..
C     .. External Subroutines ..
C     ..
C     .. Intrinsic Functions ..
C     ..
C     .. Data statements ..
C     ..
C     .. Executable Statements ..
C
C     Do not check the input parameters for errors
C
      info = 0
C
C     Quick return if possible
C
      IF (n1 .EQ. 0 .OR. n2 .EQ. 0) THEN
        RETURN
      ELSE
C
C     Set constants to control overflow
C
        eps = DLAMCH('P')
        result1 = DLAMCH('S')
        smlnum = result1/eps
        sgn = isgn
C
        k = n1 + n1 + n2 - 2
        GOTO (10, 110, 140, 150) k
        GOTO 10
 10     DO nd=1,nbdirs
          tau1d(nd) = tld(nd, 1, 1) + sgn*trd(nd, 1, 1)
        ENDDO
C
C     1 by 1: TL11*X + SGN*X*TR11 = B11
C
        tau1 = tl(1, 1) + sgn*tr(1, 1)
        IF (tau1 .GE. 0.) THEN
          bet = tau1
        ELSE
          bet = -tau1
        END IF
        IF (bet .LE. smlnum) THEN
          tau1 = smlnum
          bet = smlnum
          info = 1
          DO nd=1,nbdirs
            tau1d(nd) = 0.D0
          ENDDO
        END IF
C
        scale = one
        IF (b(1, 1) .GE. 0.) THEN
          DO nd=1,nbdirs
            gamd(nd) = bd(nd, 1, 1)
          ENDDO
          gam = b(1, 1)
        ELSE
          DO nd=1,nbdirs
            gamd(nd) = -bd(nd, 1, 1)
          ENDDO
          gam = -b(1, 1)
        END IF
        IF (smlnum*gam .GT. bet) THEN
          DO nd=1,nbdirs
            scaled(nd) = -(one*gamd(nd)/gam**2)
          ENDDO
          scale = one/gam
        ELSE
          DO nd=1,nbdirs
            scaled(nd) = 0.D0
          ENDDO
        END IF
        DO nd=1,nbdirs
          xd(nd, 1, 1) = ((bd(nd, 1, 1)*scale+b(1, 1)*scaled(nd))*tau1-b
     +      (1, 1)*scale*tau1d(nd))/tau1**2
        ENDDO
C
        x(1, 1) = b(1, 1)*scale/tau1
        IF (x(1, 1) .GE. 0.) THEN
          xnorm = x(1, 1)
        ELSE
          xnorm = -x(1, 1)
        END IF
        RETURN
 110    IF (tl(1, 1) .GE. 0.) THEN
          DO nd=1,nbdirs
            tmpmaxd(nd) = tld(nd, 1, 1)
          ENDDO
          tmpmax = tl(1, 1)
        ELSE
          DO nd=1,nbdirs
            tmpmaxd(nd) = -tld(nd, 1, 1)
          ENDDO
          tmpmax = -tl(1, 1)
        END IF
        IF (tr(1, 1) .GE. 0.) THEN
          abs1 = tr(1, 1)
        ELSE
          abs1 = -tr(1, 1)
        END IF
        IF (abs1 .GT. tmpmax) THEN
          IF (tr(1, 1) .GE. 0.) THEN
            DO nd=1,nbdirs
              tmpmaxd(nd) = trd(nd, 1, 1)
            ENDDO
            tmpmax = tr(1, 1)
          ELSE
            DO nd=1,nbdirs
              tmpmaxd(nd) = -trd(nd, 1, 1)
            ENDDO
            tmpmax = -tr(1, 1)
          END IF
        END IF
        IF (tr(1, 2) .GE. 0.) THEN
          abs2 = tr(1, 2)
        ELSE
          abs2 = -tr(1, 2)
        END IF
C
        IF (abs2 .GT. tmpmax) THEN
          IF (tr(1, 2) .GE. 0.) THEN
            DO nd=1,nbdirs
              tmpmaxd(nd) = trd(nd, 1, 2)
            ENDDO
            tmpmax = tr(1, 2)
          ELSE
            DO nd=1,nbdirs
              tmpmaxd(nd) = -trd(nd, 1, 2)
            ENDDO
            tmpmax = -tr(1, 2)
          END IF
        END IF
        IF (tr(2, 1) .GE. 0.) THEN
          abs3 = tr(2, 1)
        ELSE
          abs3 = -tr(2, 1)
        END IF
C
        IF (abs3 .GT. tmpmax) THEN
          IF (tr(2, 1) .GE. 0.) THEN
            DO nd=1,nbdirs
              tmpmaxd(nd) = trd(nd, 2, 1)
            ENDDO
            tmpmax = tr(2, 1)
          ELSE
            DO nd=1,nbdirs
              tmpmaxd(nd) = -trd(nd, 2, 1)
            ENDDO
            tmpmax = -tr(2, 1)
          END IF
        END IF
        IF (tr(2, 2) .GE. 0.) THEN
          abs4 = tr(2, 2)
        ELSE
          abs4 = -tr(2, 2)
        END IF
C
        IF (abs4 .GT. tmpmax) THEN
          IF (tr(2, 2) .GE. 0.) THEN
            DO nd=1,nbdirs
              tmpmaxd(nd) = trd(nd, 2, 2)
            ENDDO
            tmpmax = tr(2, 2)
          ELSE
            DO nd=1,nbdirs
              tmpmaxd(nd) = -trd(nd, 2, 2)
            ENDDO
            tmpmax = -tr(2, 2)
          END IF
        END IF
C
        IF (eps*tmpmax .GT. smlnum) THEN
          DO nd=1,nbdirs
            smind(nd) = eps*tmpmaxd(nd)
          ENDDO
          smin = eps*tmpmax
        ELSE
          smin = smlnum
          DO nd=1,nbdirs
            smind(nd) = 0.D0
          ENDDO
        END IF
        DO nd=1,nbdirs
          tmpd(nd, 1) = tld(nd, 1, 1) + sgn*trd(nd, 1, 1)
          tmpd(nd, 4) = tld(nd, 1, 1) + sgn*trd(nd, 2, 2)
        ENDDO
C     END REWRITTEN FOR TAPENADE
C
        tmp(1) = tl(1, 1) + sgn*tr(1, 1)
        tmp(4) = tl(1, 1) + sgn*tr(2, 2)
        IF (ltranr) THEN
          DO nd=1,nbdirs
            tmpd(nd, 2) = sgn*trd(nd, 2, 1)
            tmpd(nd, 3) = sgn*trd(nd, 1, 2)
          ENDDO
          tmp(2) = sgn*tr(2, 1)
          tmp(3) = sgn*tr(1, 2)
        ELSE
          DO nd=1,nbdirs
            tmpd(nd, 2) = sgn*trd(nd, 1, 2)
            tmpd(nd, 3) = sgn*trd(nd, 2, 1)
          ENDDO
          tmp(2) = sgn*tr(1, 2)
          tmp(3) = sgn*tr(2, 1)
        END IF
        DO nd=1,nbdirs
          btmpd(nd, 1) = bd(nd, 1, 1)
          btmpd(nd, 2) = bd(nd, 1, 2)
        ENDDO
        btmp(1) = b(1, 1)
        btmp(2) = b(1, 2)
        GOTO 40
 140    IF (tr(1, 1) .GE. 0.) THEN
          DO nd=1,nbdirs
            tmpmaxd(nd) = trd(nd, 1, 1)
          ENDDO
          tmpmax = tr(1, 1)
        ELSE
          DO nd=1,nbdirs
            tmpmaxd(nd) = -trd(nd, 1, 1)
          ENDDO
          tmpmax = -tr(1, 1)
        END IF
        IF (tl(1, 1) .GE. 0.) THEN
          abs5 = tl(1, 1)
        ELSE
          abs5 = -tl(1, 1)
        END IF
        IF (abs5 .GT. tmpmax) THEN
          IF (tl(1, 1) .GE. 0.) THEN
            DO nd=1,nbdirs
              tmpmaxd(nd) = tld(nd, 1, 1)
            ENDDO
            tmpmax = tl(1, 1)
          ELSE
            DO nd=1,nbdirs
              tmpmaxd(nd) = -tld(nd, 1, 1)
            ENDDO
            tmpmax = -tl(1, 1)
          END IF
        END IF
        IF (tl(1, 2) .GE. 0.) THEN
          abs6 = tl(1, 2)
        ELSE
          abs6 = -tl(1, 2)
        END IF
        IF (abs6 .GT. tmpmax) THEN
          IF (tl(1, 2) .GE. 0.) THEN
            DO nd=1,nbdirs
              tmpmaxd(nd) = tld(nd, 1, 2)
            ENDDO
            tmpmax = tl(1, 2)
          ELSE
            DO nd=1,nbdirs
              tmpmaxd(nd) = -tld(nd, 1, 2)
            ENDDO
            tmpmax = -tl(1, 2)
          END IF
        END IF
        IF (tl(2, 1) .GE. 0.) THEN
          abs7 = tl(2, 1)
        ELSE
          abs7 = -tl(2, 1)
        END IF
        IF (abs7 .GT. tmpmax) THEN
          IF (tl(2, 1) .GE. 0.) THEN
            DO nd=1,nbdirs
              tmpmaxd(nd) = tld(nd, 2, 1)
            ENDDO
            tmpmax = tl(2, 1)
          ELSE
            DO nd=1,nbdirs
              tmpmaxd(nd) = -tld(nd, 2, 1)
            ENDDO
            tmpmax = -tl(2, 1)
          END IF
        END IF
        IF (tl(2, 2) .GE. 0.) THEN
          abs8 = tl(2, 2)
        ELSE
          abs8 = -tl(2, 2)
        END IF
        IF (abs8 .GT. tmpmax) THEN
          IF (tl(2, 2) .GE. 0.) THEN
            DO nd=1,nbdirs
              tmpmaxd(nd) = tld(nd, 2, 2)
            ENDDO
            tmpmax = tl(2, 2)
          ELSE
            DO nd=1,nbdirs
              tmpmaxd(nd) = -tld(nd, 2, 2)
            ENDDO
            tmpmax = -tl(2, 2)
          END IF
        END IF
C
        IF (eps*tmpmax .GT. smlnum) THEN
          DO nd=1,nbdirs
            smind(nd) = eps*tmpmaxd(nd)
          ENDDO
          smin = eps*tmpmax
        ELSE
          smin = smlnum
          DO nd=1,nbdirs
            smind(nd) = 0.D0
          ENDDO
        END IF
        DO nd=1,nbdirs
          tmpd(nd, 1) = tld(nd, 1, 1) + sgn*trd(nd, 1, 1)
          tmpd(nd, 4) = tld(nd, 2, 2) + sgn*trd(nd, 1, 1)
        ENDDO
C     END REWRITTEN FOR TAPENADE
C
C
        tmp(1) = tl(1, 1) + sgn*tr(1, 1)
        tmp(4) = tl(2, 2) + sgn*tr(1, 1)
        IF (ltranl) THEN
          DO nd=1,nbdirs
            tmpd(nd, 2) = tld(nd, 1, 2)
            tmpd(nd, 3) = tld(nd, 2, 1)
          ENDDO
          tmp(2) = tl(1, 2)
          tmp(3) = tl(2, 1)
        ELSE
          DO nd=1,nbdirs
            tmpd(nd, 2) = tld(nd, 2, 1)
            tmpd(nd, 3) = tld(nd, 1, 2)
          ENDDO
          tmp(2) = tl(2, 1)
          tmp(3) = tl(1, 2)
        END IF
        DO nd=1,nbdirs
          btmpd(nd, 1) = bd(nd, 1, 1)
          btmpd(nd, 2) = bd(nd, 2, 1)
        ENDDO
        btmp(1) = b(1, 1)
        btmp(2) = b(2, 1)
C
C     Solve 2 by 2 system using complete pivoting.
C     Set pivots less than SMIN to SMIN.
C
 40     ipiv = IDAMAX(4, tmp, 1)
        DO nd=1,nbdirs
          u11d(nd) = tmpd(nd, ipiv)
        ENDDO
        u11 = tmp(ipiv)
        IF (u11 .GE. 0.) THEN
          abs9 = u11
        ELSE
          abs9 = -u11
        END IF
        IF (abs9 .LE. smin) THEN
          info = 1
          DO nd=1,nbdirs
            u11d(nd) = smind(nd)
          ENDDO
          u11 = smin
        END IF
        u12 = tmp(locu12(ipiv))
        l21 = tmp(locl21(ipiv))/u11
        DO nd=1,nbdirs
          l21d(nd) = (tmpd(nd, locl21(ipiv))*u11-tmp(locl21(ipiv))*u11d(
     +      nd))/u11**2
          u12d(nd) = tmpd(nd, locu12(ipiv))
          u22d(nd) = tmpd(nd, locu22(ipiv)) - u12d(nd)*l21 - u12*l21d(nd
     +      )
        ENDDO
        u22 = tmp(locu22(ipiv)) - u12*l21
        xswap = xswpiv(ipiv)
        bswap = bswpiv(ipiv)
        IF (u22 .GE. 0.) THEN
          abs10 = u22
        ELSE
          abs10 = -u22
        END IF
        IF (abs10 .LE. smin) THEN
          info = 1
          DO nd=1,nbdirs
            u22d(nd) = smind(nd)
          ENDDO
          u22 = smin
        END IF
        IF (bswap) THEN
          temp = btmp(2)
          DO nd=1,nbdirs
            tempd(nd) = btmpd(nd, 2)
            btmpd(nd, 2) = btmpd(nd, 1) - l21d(nd)*temp - l21*tempd(nd)
            btmpd(nd, 1) = tempd(nd)
          ENDDO
          btmp(2) = btmp(1) - l21*temp
          btmp(1) = temp
        ELSE
          DO nd=1,nbdirs
            btmpd(nd, 2) = btmpd(nd, 2) - l21d(nd)*btmp(1) - l21*btmpd(
     +        nd, 1)
          ENDDO
          btmp(2) = btmp(2) - l21*btmp(1)
        END IF
        scale = one
        IF (btmp(2) .GE. 0.) THEN
          abs11 = btmp(2)
        ELSE
          abs11 = -btmp(2)
        END IF
        IF (u22 .GE. 0.) THEN
          abs32 = u22
        ELSE
          abs32 = -u22
        END IF
        IF (btmp(1) .GE. 0.) THEN
          abs40 = btmp(1)
        ELSE
          abs40 = -btmp(1)
        END IF
        IF (u11 .GE. 0.) THEN
          abs43 = u11
        ELSE
          abs43 = -u11
        END IF
        IF (two*smlnum*abs11 .GT. abs32 .OR. two*smlnum*abs40 .GT. abs43
     +  ) THEN
          IF (btmp(1) .GE. 0.) THEN
            abs12 = btmp(1)
          ELSE
            abs12 = -btmp(1)
          END IF
          IF (btmp(2) .GE. 0.) THEN
            abs33 = btmp(2)
          ELSE
            abs33 = -btmp(2)
          END IF
C     REWRITTEN FOR TAPENADE
C
C         SCALE = HALF / MAX( ABS( BTMP( 1 ) ), ABS( BTMP( 2 ) ) )
          IF (abs12 .GT. abs33) THEN
            IF (btmp(1) .GE. 0.) THEN
              DO nd=1,nbdirs
                tmpmaxd(nd) = btmpd(nd, 1)
              ENDDO
              tmpmax = btmp(1)
            ELSE
              DO nd=1,nbdirs
                tmpmaxd(nd) = -btmpd(nd, 1)
              ENDDO
              tmpmax = -btmp(1)
            END IF
          ELSE IF (btmp(2) .GE. 0.) THEN
            DO nd=1,nbdirs
              tmpmaxd(nd) = btmpd(nd, 2)
            ENDDO
            tmpmax = btmp(2)
          ELSE
            DO nd=1,nbdirs
              tmpmaxd(nd) = -btmpd(nd, 2)
            ENDDO
            tmpmax = -btmp(2)
          END IF
          scale = half/tmpmax
          DO nd=1,nbdirs
            scaled(nd) = -(half*tmpmaxd(nd)/tmpmax**2)
            btmpd(nd, 1) = btmpd(nd, 1)*scale + btmp(1)*scaled(nd)
          ENDDO
C     END REWRITTEN FOR TAPENADE
          btmp(1) = btmp(1)*scale
          DO nd=1,nbdirs
            btmpd(nd, 2) = btmpd(nd, 2)*scale + btmp(2)*scaled(nd)
          ENDDO
          btmp(2) = btmp(2)*scale
        ELSE
          DO nd=1,nbdirs
            scaled(nd) = 0.D0
          ENDDO
        END IF
        x2(2) = btmp(2)/u22
        DO nd=1,nbdirs
          x2d(nd, 2) = (btmpd(nd, 2)*u22-btmp(2)*u22d(nd))/u22**2
          x2d(nd, 1) = (btmpd(nd, 1)*u11-btmp(1)*u11d(nd))/u11**2 - (
     +      u12d(nd)*u11-u12*u11d(nd))*x2(2)/u11**2 - u12*x2d(nd, 2)/u11
        ENDDO
        x2(1) = btmp(1)/u11 - u12/u11*x2(2)
        IF (xswap) THEN
          DO nd=1,nbdirs
            tempd(nd) = x2d(nd, 2)
            x2d(nd, 2) = x2d(nd, 1)
            x2d(nd, 1) = tempd(nd)
          ENDDO
          temp = x2(2)
          x2(2) = x2(1)
          x2(1) = temp
        END IF
        DO nd=1,nbdirs
          xd(nd, 1, 1) = x2d(nd, 1)
        ENDDO
        x(1, 1) = x2(1)
        IF (n1 .EQ. 1) THEN
          DO nd=1,nbdirs
            xd(nd, 1, 2) = x2d(nd, 2)
          ENDDO
          x(1, 2) = x2(2)
          IF (x(1, 1) .GE. 0.) THEN
            abs13 = x(1, 1)
          ELSE
            abs13 = -x(1, 1)
          END IF
          IF (x(1, 2) .GE. 0.) THEN
            abs34 = x(1, 2)
          ELSE
            abs34 = -x(1, 2)
          END IF
          xnorm = abs13 + abs34
        ELSE
          DO nd=1,nbdirs
            xd(nd, 2, 1) = x2d(nd, 2)
          ENDDO
          x(2, 1) = x2(2)
          IF (x(1, 1) .GE. 0.) THEN
            abs14 = x(1, 1)
          ELSE
            abs14 = -x(1, 1)
          END IF
          IF (x(2, 1) .GE. 0.) THEN
            abs35 = x(2, 1)
          ELSE
            abs35 = -x(2, 1)
          END IF
C     REWRITTEN FOR TAPENADE
C
C         XNORM = MAX( ABS( X( 1, 1 ) ), ABS( X( 2, 1 ) ) )
          IF (abs14 .GT. abs35) THEN
            IF (x(1, 1) .GE. 0.) THEN
              xnorm = x(1, 1)
            ELSE
              xnorm = -x(1, 1)
            END IF
          ELSE IF (x(2, 1) .GE. 0.) THEN
            xnorm = x(2, 1)
          ELSE
            xnorm = -x(2, 1)
          END IF
        END IF
C     END REWRITTEN FOR TAPENADE
        RETURN
 150    IF (tr(1, 1) .GE. 0.) THEN
          DO nd=1,nbdirs
            smind(nd) = trd(nd, 1, 1)
          ENDDO
          smin = tr(1, 1)
        ELSE
          DO nd=1,nbdirs
            smind(nd) = -trd(nd, 1, 1)
          ENDDO
          smin = -tr(1, 1)
        END IF
        IF (tr(1, 2) .GE. 0.) THEN
          abs15 = tr(1, 2)
        ELSE
          abs15 = -tr(1, 2)
        END IF
        IF (abs15 .GT. smin) THEN
          IF (tr(1, 2) .GE. 0.) THEN
            DO nd=1,nbdirs
              smind(nd) = trd(nd, 1, 2)
            ENDDO
            smin = tr(1, 2)
          ELSE
            DO nd=1,nbdirs
              smind(nd) = -trd(nd, 1, 2)
            ENDDO
            smin = -tr(1, 2)
          END IF
        END IF
        IF (tr(2, 1) .GE. 0.) THEN
          abs16 = tr(2, 1)
        ELSE
          abs16 = -tr(2, 1)
        END IF
        IF (abs16 .GT. smin) THEN
          IF (tr(2, 1) .GE. 0.) THEN
            DO nd=1,nbdirs
              smind(nd) = trd(nd, 2, 1)
            ENDDO
            smin = tr(2, 1)
          ELSE
            DO nd=1,nbdirs
              smind(nd) = -trd(nd, 2, 1)
            ENDDO
            smin = -tr(2, 1)
          END IF
        END IF
        IF (tr(2, 2) .GE. 0.) THEN
          abs17 = tr(2, 2)
        ELSE
          abs17 = -tr(2, 2)
        END IF
C
        IF (abs17 .GT. smin) THEN
          IF (tr(2, 2) .GE. 0.) THEN
            DO nd=1,nbdirs
              smind(nd) = trd(nd, 2, 2)
            ENDDO
            smin = tr(2, 2)
          ELSE
            DO nd=1,nbdirs
              smind(nd) = -trd(nd, 2, 2)
            ENDDO
            smin = -tr(2, 2)
          END IF
        END IF
        IF (tl(1, 1) .GE. 0.) THEN
          abs18 = tl(1, 1)
        ELSE
          abs18 = -tl(1, 1)
        END IF
C
        IF (abs18 .GT. smin) THEN
          IF (tl(1, 1) .GE. 0.) THEN
            DO nd=1,nbdirs
              smind(nd) = tld(nd, 1, 1)
            ENDDO
            smin = tl(1, 1)
          ELSE
            DO nd=1,nbdirs
              smind(nd) = -tld(nd, 1, 1)
            ENDDO
            smin = -tl(1, 1)
          END IF
        END IF
        IF (tl(1, 2) .GE. 0.) THEN
          abs19 = tl(1, 2)
        ELSE
          abs19 = -tl(1, 2)
        END IF
C
        IF (abs19 .GT. smin) THEN
          IF (tl(1, 2) .GE. 0.) THEN
            DO nd=1,nbdirs
              smind(nd) = tld(nd, 1, 2)
            ENDDO
            smin = tl(1, 2)
          ELSE
            DO nd=1,nbdirs
              smind(nd) = -tld(nd, 1, 2)
            ENDDO
            smin = -tl(1, 2)
          END IF
        END IF
        IF (tl(2, 1) .GE. 0.) THEN
          abs20 = tl(2, 1)
        ELSE
          abs20 = -tl(2, 1)
        END IF
C
        IF (abs20 .GT. smin) THEN
          IF (tl(2, 1) .GE. 0.) THEN
            DO nd=1,nbdirs
              smind(nd) = tld(nd, 2, 1)
            ENDDO
            smin = tl(2, 1)
          ELSE
            DO nd=1,nbdirs
              smind(nd) = -tld(nd, 2, 1)
            ENDDO
            smin = -tl(2, 1)
          END IF
        END IF
        IF (tl(2, 2) .GE. 0.) THEN
          abs21 = tl(2, 2)
        ELSE
          abs21 = -tl(2, 2)
        END IF
C
        IF (abs21 .GT. smin) THEN
          IF (tl(2, 2) .GE. 0.) THEN
            DO nd=1,nbdirs
              smind(nd) = tld(nd, 2, 2)
            ENDDO
            smin = tl(2, 2)
          ELSE
            DO nd=1,nbdirs
              smind(nd) = -tld(nd, 2, 2)
            ENDDO
            smin = -tl(2, 2)
          END IF
        END IF
C
        IF (eps*smin .GT. smlnum) THEN
          DO nd=1,nbdirs
            smind(nd) = eps*smind(nd)
          ENDDO
          smin = eps*smin
        ELSE
          smin = smlnum
          DO nd=1,nbdirs
            smind(nd) = 0.D0
          ENDDO
        END IF
C     END REWRITTEN FOR TAPENADE
        btmp(1) = zero
        CALL DCOPY(16, btmp, 0, t16, 1)
        DO nd=1,nbdirs
          t16d(nd, 1, 1) = tld(nd, 1, 1) + sgn*trd(nd, 1, 1)
          t16d(nd, 2, 2) = tld(nd, 2, 2) + sgn*trd(nd, 1, 1)
          t16d(nd, 3, 3) = tld(nd, 1, 1) + sgn*trd(nd, 2, 2)
          btmpd(nd, 1) = 0.D0
          t16d(nd, 4, 4) = tld(nd, 2, 2) + sgn*trd(nd, 2, 2)
        ENDDO
        t16(1, 1) = tl(1, 1) + sgn*tr(1, 1)
        t16(2, 2) = tl(2, 2) + sgn*tr(1, 1)
        t16(3, 3) = tl(1, 1) + sgn*tr(2, 2)
        t16(4, 4) = tl(2, 2) + sgn*tr(2, 2)
        IF (ltranl) THEN
          DO nd=1,nbdirs
            t16d(nd, 1, 2) = tld(nd, 2, 1)
            t16d(nd, 2, 1) = tld(nd, 1, 2)
            t16d(nd, 3, 4) = tld(nd, 2, 1)
            t16d(nd, 4, 3) = tld(nd, 1, 2)
          ENDDO
          t16(1, 2) = tl(2, 1)
          t16(2, 1) = tl(1, 2)
          t16(3, 4) = tl(2, 1)
          t16(4, 3) = tl(1, 2)
        ELSE
          DO nd=1,nbdirs
            t16d(nd, 1, 2) = tld(nd, 1, 2)
            t16d(nd, 2, 1) = tld(nd, 2, 1)
            t16d(nd, 3, 4) = tld(nd, 1, 2)
            t16d(nd, 4, 3) = tld(nd, 2, 1)
          ENDDO
          t16(1, 2) = tl(1, 2)
          t16(2, 1) = tl(2, 1)
          t16(3, 4) = tl(1, 2)
          t16(4, 3) = tl(2, 1)
        END IF
        IF (ltranr) THEN
          DO nd=1,nbdirs
            t16d(nd, 1, 3) = sgn*trd(nd, 1, 2)
            t16d(nd, 2, 4) = sgn*trd(nd, 1, 2)
            t16d(nd, 3, 1) = sgn*trd(nd, 2, 1)
            t16d(nd, 4, 2) = sgn*trd(nd, 2, 1)
          ENDDO
          t16(1, 3) = sgn*tr(1, 2)
          t16(2, 4) = sgn*tr(1, 2)
          t16(3, 1) = sgn*tr(2, 1)
          t16(4, 2) = sgn*tr(2, 1)
        ELSE
          DO nd=1,nbdirs
            t16d(nd, 1, 3) = sgn*trd(nd, 2, 1)
            t16d(nd, 2, 4) = sgn*trd(nd, 2, 1)
            t16d(nd, 3, 1) = sgn*trd(nd, 1, 2)
            t16d(nd, 4, 2) = sgn*trd(nd, 1, 2)
          ENDDO
          t16(1, 3) = sgn*tr(2, 1)
          t16(2, 4) = sgn*tr(2, 1)
          t16(3, 1) = sgn*tr(1, 2)
          t16(4, 2) = sgn*tr(1, 2)
        END IF
        DO nd=1,nbdirs
          btmpd(nd, 1) = bd(nd, 1, 1)
          btmpd(nd, 2) = bd(nd, 2, 1)
          btmpd(nd, 3) = bd(nd, 1, 2)
          btmpd(nd, 4) = bd(nd, 2, 2)
        ENDDO
        btmp(1) = b(1, 1)
        btmp(2) = b(2, 1)
        btmp(3) = b(1, 2)
        btmp(4) = b(2, 2)
C
C     Perform elimination
C
        DO i=1,3
          xmax = zero
          DO ip=i,4
            DO jp=i,4
              IF (t16(ip, jp) .GE. 0.) THEN
                abs22 = t16(ip, jp)
              ELSE
                abs22 = -t16(ip, jp)
              END IF
              IF (abs22 .GE. xmax) THEN
                IF (t16(ip, jp) .GE. 0.) THEN
                  xmax = t16(ip, jp)
                ELSE
                  xmax = -t16(ip, jp)
                END IF
                ipsv = ip
                jpsv = jp
              END IF
            ENDDO
          ENDDO
          IF (ipsv .NE. i) THEN
            CALL DSWAP_DV(4, t16(ipsv, 1), t16d(1, ipsv, 1), 4, t16(i, 1
     +                    ), t16d(1, i, 1), 4, nbdirs)
            DO nd=1,nbdirs
              tempd(nd) = btmpd(nd, i)
              btmpd(nd, i) = btmpd(nd, ipsv)
              btmpd(nd, ipsv) = tempd(nd)
            ENDDO
            temp = btmp(i)
            btmp(i) = btmp(ipsv)
            btmp(ipsv) = temp
          END IF
          IF (jpsv .NE. i) CALL DSWAP_DV(4, t16(1, jpsv), t16d(1, 1,
     +                                   jpsv), 1, t16(1, i), t16d(1, 1
     +                                   , i), 1, nbdirs)
          jpiv(i) = jpsv
          IF (t16(i, i) .GE. 0.) THEN
            abs23 = t16(i, i)
          ELSE
            abs23 = -t16(i, i)
          END IF
          IF (abs23 .LT. smin) THEN
            info = 1
            DO nd=1,nbdirs
              t16d(nd, i, i) = smind(nd)
            ENDDO
            t16(i, i) = smin
          END IF
          DO j=i+1,4
            DO nd=1,nbdirs
              t16d(nd, j, i) = (t16d(nd, j, i)*t16(i, i)-t16(j, i)*t16d(
     +          nd, i, i))/t16(i, i)**2
            ENDDO
            t16(j, i) = t16(j, i)/t16(i, i)
            DO nd=1,nbdirs
              btmpd(nd, j) = btmpd(nd, j) - t16d(nd, j, i)*btmp(i) - t16
     +          (j, i)*btmpd(nd, i)
            ENDDO
            btmp(j) = btmp(j) - t16(j, i)*btmp(i)
            DO k=i+1,4
              DO nd=1,nbdirs
                t16d(nd, j, k) = t16d(nd, j, k) - t16d(nd, j, i)*t16(i,
     +            k) - t16(j, i)*t16d(nd, i, k)
              ENDDO
              t16(j, k) = t16(j, k) - t16(j, i)*t16(i, k)
            ENDDO
          ENDDO
        ENDDO
        IF (t16(4, 4) .GE. 0.) THEN
          abs24 = t16(4, 4)
        ELSE
          abs24 = -t16(4, 4)
        END IF
        IF (abs24 .LT. smin) THEN
          DO nd=1,nbdirs
            t16d(nd, 4, 4) = smind(nd)
          ENDDO
          t16(4, 4) = smin
        END IF
        scale = one
        IF (btmp(1) .GE. 0.) THEN
          abs25 = btmp(1)
        ELSE
          abs25 = -btmp(1)
        END IF
        IF (t16(1, 1) .GE. 0.) THEN
          abs36 = t16(1, 1)
        ELSE
          abs36 = -t16(1, 1)
        END IF
        IF (btmp(2) .GE. 0.) THEN
          abs41 = btmp(2)
        ELSE
          abs41 = -btmp(2)
        END IF
        IF (t16(2, 2) .GE. 0.) THEN
          abs44 = t16(2, 2)
        ELSE
          abs44 = -t16(2, 2)
        END IF
        IF (btmp(3) .GE. 0.) THEN
          abs46 = btmp(3)
        ELSE
          abs46 = -btmp(3)
        END IF
        IF (t16(3, 3) .GE. 0.) THEN
          abs47 = t16(3, 3)
        ELSE
          abs47 = -t16(3, 3)
        END IF
        IF (btmp(4) .GE. 0.) THEN
          abs48 = btmp(4)
        ELSE
          abs48 = -btmp(4)
        END IF
        IF (t16(4, 4) .GE. 0.) THEN
          abs49 = t16(4, 4)
        ELSE
          abs49 = -t16(4, 4)
        END IF
        IF (eight*smlnum*abs25 .GT. abs36 .OR. eight*smlnum*abs41 .GT.
     +      abs44 .OR. eight*smlnum*abs46 .GT. abs47 .OR. eight*smlnum*
     +      abs48 .GT. abs49) THEN
          IF (btmp(1) .GE. 0.) THEN
            DO nd=1,nbdirs
              tmpmaxd(nd) = btmpd(nd, 1)
            ENDDO
            tmpmax = btmp(1)
          ELSE
            DO nd=1,nbdirs
              tmpmaxd(nd) = -btmpd(nd, 1)
            ENDDO
            tmpmax = -btmp(1)
          END IF
          IF (btmp(2) .GE. 0.) THEN
            abs26 = btmp(2)
          ELSE
            abs26 = -btmp(2)
          END IF
          IF (abs26 .GT. tmpmax) THEN
            IF (btmp(2) .GE. 0.) THEN
              DO nd=1,nbdirs
                tmpmaxd(nd) = btmpd(nd, 2)
              ENDDO
              tmpmax = btmp(2)
            ELSE
              DO nd=1,nbdirs
                tmpmaxd(nd) = -btmpd(nd, 2)
              ENDDO
              tmpmax = -btmp(2)
            END IF
          END IF
          IF (btmp(3) .GE. 0.) THEN
            abs27 = btmp(3)
          ELSE
            abs27 = -btmp(3)
          END IF
C
          IF (abs27 .GT. tmpmax) THEN
            IF (btmp(3) .GE. 0.) THEN
              DO nd=1,nbdirs
                tmpmaxd(nd) = btmpd(nd, 3)
              ENDDO
              tmpmax = btmp(3)
            ELSE
              DO nd=1,nbdirs
                tmpmaxd(nd) = -btmpd(nd, 3)
              ENDDO
              tmpmax = -btmp(3)
            END IF
          END IF
          IF (btmp(4) .GE. 0.) THEN
            abs28 = btmp(4)
          ELSE
            abs28 = -btmp(4)
          END IF
C
          IF (abs28 .GT. tmpmax) THEN
            IF (btmp(4) .GE. 0.) THEN
              DO nd=1,nbdirs
                tmpmaxd(nd) = btmpd(nd, 4)
              ENDDO
              tmpmax = btmp(4)
            ELSE
              DO nd=1,nbdirs
                tmpmaxd(nd) = -btmpd(nd, 4)
              ENDDO
              tmpmax = -btmp(4)
            END IF
          END IF
          scale = one/eight/tmpmax
          DO nd=1,nbdirs
            scaled(nd) = -(one*tmpmaxd(nd)/eight/tmpmax**2)
            btmpd(nd, 1) = btmpd(nd, 1)*scale + btmp(1)*scaled(nd)
          ENDDO
C     END REWRITTEN FOR TAPENADE
          btmp(1) = btmp(1)*scale
          DO nd=1,nbdirs
            btmpd(nd, 2) = btmpd(nd, 2)*scale + btmp(2)*scaled(nd)
          ENDDO
          btmp(2) = btmp(2)*scale
          DO nd=1,nbdirs
            btmpd(nd, 3) = btmpd(nd, 3)*scale + btmp(3)*scaled(nd)
          ENDDO
          btmp(3) = btmp(3)*scale
          DO nd=1,nbdirs
            btmpd(nd, 4) = btmpd(nd, 4)*scale + btmp(4)*scaled(nd)
          ENDDO
          btmp(4) = btmp(4)*scale
          DO ii1=1,4
            DO nd=1,nbdirs
              tmpd(nd, ii1) = 0.D0
            ENDDO
          ENDDO
        ELSE
          DO nd=1,nbdirs
            scaled(nd) = 0.D0
          ENDDO
          DO ii1=1,4
            DO nd=1,nbdirs
              tmpd(nd, ii1) = 0.D0
            ENDDO
          ENDDO
        END IF
        DO i=1,4
          k = 5 - i
          temp = one/t16(k, k)
          DO nd=1,nbdirs
            tempd(nd) = -(one*t16d(nd, k, k)/t16(k, k)**2)
            tmpd(nd, k) = btmpd(nd, k)*temp + btmp(k)*tempd(nd)
          ENDDO
          tmp(k) = btmp(k)*temp
          DO j=k+1,4
            DO nd=1,nbdirs
              tmpd(nd, k) = tmpd(nd, k) - (tempd(nd)*tmp(j)+temp*tmpd(nd
     +          , j))*t16(k, j) - temp*tmp(j)*t16d(nd, k, j)
            ENDDO
            tmp(k) = tmp(k) - temp*t16(k, j)*tmp(j)
          ENDDO
        ENDDO
        DO i=1,3
          IF (jpiv(4-i) .NE. 4 - i) THEN
            DO nd=1,nbdirs
              tempd(nd) = tmpd(nd, 4-i)
              tmpd(nd, 4-i) = tmpd(nd, jpiv(4-i))
              tmpd(nd, jpiv(4-i)) = tempd(nd)
            ENDDO
            temp = tmp(4-i)
            tmp(4-i) = tmp(jpiv(4-i))
            tmp(jpiv(4-i)) = temp
          END IF
        ENDDO
        DO nd=1,nbdirs
          xd(nd, 1, 1) = tmpd(nd, 1)
          xd(nd, 2, 1) = tmpd(nd, 2)
          xd(nd, 1, 2) = tmpd(nd, 3)
          xd(nd, 2, 2) = tmpd(nd, 4)
        ENDDO
        x(1, 1) = tmp(1)
        x(2, 1) = tmp(2)
        x(1, 2) = tmp(3)
        x(2, 2) = tmp(4)
        IF (tmp(1) .GE. 0.) THEN
          abs29 = tmp(1)
        ELSE
          abs29 = -tmp(1)
        END IF
        IF (tmp(3) .GE. 0.) THEN
          abs37 = tmp(3)
        ELSE
          abs37 = -tmp(3)
        END IF
        IF (tmp(2) .GE. 0.) THEN
          abs42 = tmp(2)
        ELSE
          abs42 = -tmp(2)
        END IF
        IF (tmp(4) .GE. 0.) THEN
          abs45 = tmp(4)
        ELSE
          abs45 = -tmp(4)
        END IF
C     REWRITTEN FOR TAPENADE
C
C      XNORM = MAX( ABS( TMP( 1 ) )+ABS( TMP( 3 ) ),
C     $        ABS( TMP( 2 ) )+ABS( TMP( 4 ) ) )
        IF (abs29 + abs37 .GT. abs42 + abs45) THEN
          IF (tmp(1) .GE. 0.) THEN
            abs30 = tmp(1)
          ELSE
            abs30 = -tmp(1)
          END IF
          IF (tmp(3) .GE. 0.) THEN
            abs38 = tmp(3)
          ELSE
            abs38 = -tmp(3)
          END IF
          xnorm = abs30 + abs38
        ELSE
          IF (tmp(2) .GE. 0.) THEN
            abs31 = tmp(2)
          ELSE
            abs31 = -tmp(2)
          END IF
          IF (tmp(4) .GE. 0.) THEN
            abs39 = tmp(4)
          ELSE
            abs39 = -tmp(4)
          END IF
          xnorm = abs31 + abs39
        END IF
C     END REWRITTEN FOR TAPENADE
        RETURN
      END IF
      END
