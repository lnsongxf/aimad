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
C  Differentiation of dlapy2 in forward (tangent) mode: (multi-directional mode)
C   variations  of output variables: dlapy2
C   with respect to input variables: x y
      SUBROUTINE DLAPY2_DV(x, xd, y, yd, dlapy2, dlapy2d, nbdirs)
      USE DIFFSIZES
      IMPLICIT NONE
C
C     End of DLAPY2
C
      INTEGER nbdirs
      DOUBLE PRECISION dlapy2, dlapy2d(nbdirsmax)
      DOUBLE PRECISION x, xd(nbdirsmax), y, yd(nbdirsmax)
      DOUBLE PRECISION one
      PARAMETER (one=1.0d0)
      DOUBLE PRECISION zero
      PARAMETER (zero=0.0d0)
      INTEGER nd
      DOUBLE PRECISION arg1, arg1d(nbdirsmax), result1, result1d(
     +                 nbdirsmax)
      DOUBLE PRECISION w, wd(nbdirsmax), xabs, xabsd(nbdirsmax), yabs,
     +                 yabsd(nbdirsmax), z, zd(nbdirsmax)
      INTRINSIC MAX, ABS, MIN, SQRT
      IF (x .GE. 0.) THEN
        DO nd=1,nbdirs
          xabsd(nd) = xd(nd)
        ENDDO
        xabs = x
      ELSE
        DO nd=1,nbdirs
          xabsd(nd) = -xd(nd)
        ENDDO
        xabs = -x
      END IF
      IF (y .GE. 0.) THEN
        DO nd=1,nbdirs
          yabsd(nd) = yd(nd)
        ENDDO
        yabs = y
      ELSE
        DO nd=1,nbdirs
          yabsd(nd) = -yd(nd)
        ENDDO
        yabs = -y
      END IF
      IF (xabs .LT. yabs) THEN
        DO nd=1,nbdirs
          wd(nd) = yabsd(nd)
        ENDDO
        w = yabs
      ELSE
        DO nd=1,nbdirs
          wd(nd) = xabsd(nd)
        ENDDO
        w = xabs
      END IF
      IF (xabs .GT. yabs) THEN
        DO nd=1,nbdirs
          zd(nd) = yabsd(nd)
        ENDDO
        z = yabs
      ELSE
        DO nd=1,nbdirs
          zd(nd) = xabsd(nd)
        ENDDO
        z = xabs
      END IF
      IF (z .EQ. zero) THEN
        DO nd=1,nbdirs
          dlapy2d(nd) = wd(nd)
        ENDDO
        dlapy2 = w
      ELSE
        arg1 = one + (z/w)**2
        result1 = SQRT(arg1)
        DO nd=1,nbdirs
          arg1d(nd) = 2*z*(zd(nd)*w-z*wd(nd))/w**3
          IF (arg1d(nd) .EQ. 0.0 .OR. arg1 .EQ. 0.0) THEN
            result1d(nd) = 0.D0
          ELSE
            result1d(nd) = arg1d(nd)/(2.0*SQRT(arg1))
          END IF
          dlapy2d(nd) = wd(nd)*result1 + w*result1d(nd)
        ENDDO
        dlapy2 = w*result1
      END IF
      RETURN
      END
