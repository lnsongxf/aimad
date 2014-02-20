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
C  Differentiation of drot in forward (tangent) mode: (multi-directional mode)
C   variations  of output variables: dx dy
C   with respect to input variables: s dx dy c
      SUBROUTINE DROT_DV(n, dx, dxd, incx, dy, dyd, incy, c, cd, s, sd,
     +                   nbdirs)
      USE DIFFSIZES
      IMPLICIT NONE
      INTEGER incx, incy, n
      INTEGER nbdirs
      DOUBLE PRECISION c, cd(nbdirsmax), s, sd(nbdirsmax)
      DOUBLE PRECISION dx(*), dxd(nbdirsmax, *), dy(*), dyd(nbdirsmax, *
     +                 )
      DOUBLE PRECISION dtemp, dtempd(nbdirsmax)
      INTEGER i, ix, iy, nd
C     .. Scalar Arguments ..
C     ..
C     .. Array Arguments ..
C     ..
C
C  Purpose
C  =======
C
C     applies a plane rotation.
C     jack dongarra, linpack, 3/11/78.
C     modified 12/3/93, array(1) declarations changed to array(*)
C
C
C     .. Local Scalars ..
C     ..
      IF (n .LE. 0) THEN
        RETURN
      ELSE IF (incx .EQ. 1 .AND. incy .EQ. 1) THEN
C
C       code for both increments equal to 1
C
        DO i=1,n
          DO nd=1,nbdirs
            dtempd(nd) = cd(nd)*dx(i) + c*dxd(nd, i) + sd(nd)*dy(i) + s*
     +        dyd(nd, i)
            dyd(nd, i) = cd(nd)*dy(i) + c*dyd(nd, i) - sd(nd)*dx(i) - s*
     +        dxd(nd, i)
            dxd(nd, i) = dtempd(nd)
          ENDDO
          dtemp = c*dx(i) + s*dy(i)
          dy(i) = c*dy(i) - s*dx(i)
          dx(i) = dtemp
        ENDDO
        RETURN
      ELSE
C
C       code for unequal increments or equal increments not equal
C         to 1
C
        ix = 1
        iy = 1
        IF (incx .LT. 0) ix = (-n+1)*incx + 1
        IF (incy .LT. 0) iy = (-n+1)*incy + 1
        DO i=1,n
          DO nd=1,nbdirs
            dtempd(nd) = cd(nd)*dx(ix) + c*dxd(nd, ix) + sd(nd)*dy(iy) +
     +        s*dyd(nd, iy)
            dyd(nd, iy) = cd(nd)*dy(iy) + c*dyd(nd, iy) - sd(nd)*dx(ix)
     +        - s*dxd(nd, ix)
            dxd(nd, ix) = dtempd(nd)
          ENDDO
          dtemp = c*dx(ix) + s*dy(iy)
          dy(iy) = c*dy(iy) - s*dx(ix)
          dx(ix) = dtemp
          ix = ix + incx
          iy = iy + incy
        ENDDO
        RETURN
      END IF
      END