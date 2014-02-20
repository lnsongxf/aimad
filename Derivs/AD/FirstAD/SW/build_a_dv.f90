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

!        Generated by TAPENADE     (INRIA, Tropics team)
!  Tapenade - Version 2.2 (r1239) - Wed 28 Jun 2006 04:59:55 PM CEST
!
!  Differentiation of build_a in forward (tangent) mode: (multi-directional mode)
!   variations  of output variables: a
!   with respect to input variables: h
SUBROUTINE BUILD_A_DV(h, hd, qcols, neq, a, ad, ia, js, nbdirs)
  USE DIFFSIZES
  IMPLICIT NONE
  INTEGER, INTENT(OUT) :: ia
  INTEGER :: nbdirs
  INTEGER, INTENT(IN) :: neq
  DOUBLE PRECISION, DIMENSION(neq, 3*neq), INTENT(IN) :: h
  DOUBLE PRECISION, DIMENSION(nbdirsmax, neq, 3*neq), INTENT(IN) :: hd
  INTEGER, INTENT(IN) :: qcols
  DOUBLE PRECISION, DIMENSION(qcols, qcols), INTENT(OUT) :: a
  DOUBLE PRECISION, DIMENSION(nbdirsmax, qcols, qcols), INTENT(OUT) :: ad
  INTEGER, DIMENSION(qcols), INTENT(OUT) :: js
  DOUBLE PRECISION, DIMENSION(:, :), ALLOCATABLE :: ah
  DOUBLE PRECISION, DIMENSION(:, :, :), ALLOCATABLE :: ahd
  DOUBLE PRECISION, DIMENSION(:, :), ALLOCATABLE :: bh
  DOUBLE PRECISION, DIMENSION(:, :, :), ALLOCATABLE :: bhd
  DOUBLE PRECISION, DIMENSION(:, :), ALLOCATABLE :: c
  DOUBLE PRECISION, DIMENSION(:, :, :), ALLOCATABLE :: cd
  INTEGER, DIMENSION(:), ALLOCATABLE :: ipiv
  INTEGER :: indxi, indxj, info, lleft, lright, nd, newnz, nz, rleft, rright, status
  LOGICAL, DIMENSION(:), ALLOCATABLE :: zerocols
  DOUBLE PRECISION :: zerotol=0.000000001d0
! variables in calling structure
! Effective dimension of a AND js
! variables needed for call to get_zerocols
! local variables
  lleft = 1
  rleft = qcols
  lright = qcols + 1
  rright = qcols + neq
! construct hout
!
! hout = -h(:,right)\h(:,left) = bh\ah
! to construct this
! get the qr factorization of ah so that bh*P = Q*R
! then compute hout as P*(R\(Q'*ah))
! use DORMQR to construct Q'*ah
! use DTRTRS to construct R\(Q'*ah)
! finally get hout as P*((R\(Q'*ah))
! construct appropriate partitions of h

  ALLOCATE( ah(neq, qcols), ahd(nbdirsmax, neq, qcols), bh(neq, neq), bhd(nbdirsmax, neq, neq), &
            ipiv(neq), c(neq, qcols), cd(nbdirsmax, neq, qcols), STAT=status )
  IF (status .NE. 0) THEN
     WRITE(*, *) '**** COULD NOT ALLOCATE MEMORY ****'
     RETURN
  END IF

  info = 0
  ah = -h(:, lleft:rleft)
  bh = h(:, lright:rright)
  c(:, :) = 0.0d0
  DO nd=1,nbdirs
     ad(nd, :, :) = 0.D0
     cd(nd, :, :) = 0.D0
     ahd(nd, :, :) = -hd(nd, :, lleft:rleft)
     bhd(nd, :, :) = hd(nd, :, lright:rright)
  END DO

  CALL INVERT_DV(bh, bhd, neq, nbdirs)
  CALL DGEMM_DV('N', 'N', neq, qcols, neq, 1.0d0, bh, bhd, neq, ah, ahd, neq, 0.0d0, c, cd, neq, nbdirs)
  DO nd=1,nbdirs
     ahd(nd, :, :) = cd(nd, :, :)
  END DO
  ah = c

! build the big transition matrix
    a(:, :) = 0.0d0
    DO indxi=1,neq
      a(indxi, neq+indxi) = 1.d0
    END DO

    DO nd=1,nbdirs
      ad(nd, neq+1:qcols, :) = ahd(nd, :, :)
    END DO
    a(neq+1:qcols, :) = ah


    ALLOCATE(zerocols(qcols), STAT=status)
    IF (status .NE. 0) THEN
       WRITE(*, *) '**** IN BUILD_A():: COULD NOT ALLOCATE MEMORY ****'
       RETURN
    END IF


    DO indxi=1,qcols
      zerocols(indxi) = .false.
    END DO
! holds number of identified zero columns
    nz = 0
    newnz = nz




    CALL GET_ZEROCOLS(a, qcols, qcols, zerotol, zerocols, newnz)
    DO
      IF (newnz .GT. nz .AND. newnz .LT. qcols) THEN
        nz = newnz
        CALL GET_ZEROCOLS(a, qcols, qcols, zerotol, zerocols, newnz)
      ELSE
        GOTO 100
      END IF
    END DO


! define js so that the first entries hold the position
! of the essential lags (there will be ia = qcols-nz of them)
 100 indxj = 1
    DO indxi=1,qcols
      IF (.NOT.zerocols(indxi)) THEN
        js(indxj) = indxi
        indxj = indxj + 1
      END IF
    END DO
    ia = qcols - newnz
    DEALLOCATE(ah, ahd, bh, bhd, ipiv, zerocols, c, cd, STAT=status)
    IF (status .NE. 0) THEN
      WRITE(*, *) '**** IN BUILD_A(): COULD NOT DEALLOCATE MEMORY ****'
      RETURN
    END IF
END SUBROUTINE BUILD_A_DV
