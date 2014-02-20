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
C  Differentiation of dlahqr in forward (tangent) mode: (multi-directional mode)
C   variations  of output variables: wr h z wi
C   with respect to input variables: wr h z wi
      SUBROUTINE DLAHQR_DV(wantt, wantz, n, ilo, ihi, h, hd, ldh, wr,
     +                     wrd, wi, wid, iloz, ihiz, z, zd, ldz, info,
     +                     nbdirs)


      USE DIFFSIZES
      IMPLICIT NONE
C
C     End of DLAHQR
C
      INTEGER ihi, ihiz, ilo, iloz, info, n
      INTEGER ldh, ldz, nbdirs
      LOGICAL wantt, wantz
      DOUBLE PRECISION h(ldh, *), hd(nbdirsmax, ldh, *), wi(*), wid(
     +                 nbdirsmax, *), wr(*), wrd(nbdirsmax, *), z(ldz, *
     +                 ), zd(nbdirsmax, ldz, *)
      DOUBLE PRECISION dat1, dat2
      PARAMETER (dat1=3.0d0/4.0d0, dat2=-0.4375d0)
      INTEGER itmax
      PARAMETER (itmax=30)
      DOUBLE PRECISION one, two, zero
      PARAMETER (one=1.0d0, two=2.0d0, zero=0.0d0)
      DOUBLE PRECISION aa, aad(nbdirsmax), ab, abd(nbdirsmax), abs13,
     +                 abs13d(nbdirsmax), abs14, abs15, abs15d(nbdirsmax
     +                 ), abs18, abs18d(nbdirsmax), abs19, abs19d(
     +                 nbdirsmax), abs22, abs22d(nbdirsmax), abs6, abs6d
     +                 (nbdirsmax), abs7, abs7d(nbdirsmax), abs8, ba, bb
     +                 , cs, csd(nbdirsmax), det, detd(nbdirsmax), h11,
     +                 h11d(nbdirsmax), h12, h12d(nbdirsmax), h21, h21d(
     +                 nbdirsmax), h21s, h21sd(nbdirsmax), h22, h22d(
     +                 nbdirsmax), max1, rt1i, rt1id(nbdirsmax), rt1r,
     +                 rt1rd(nbdirsmax), rt2i, rt2id(nbdirsmax), rt2r,
     +                 rt2rd(nbdirsmax), rtdisc, rtdiscd(nbdirsmax), s,
     +                 safmax, safmin, sd(nbdirsmax), smlnum, sn, snd(
     +                 nbdirsmax), sum, sumd(nbdirsmax), t1, t1d(
     +                 nbdirsmax), t2, t2d(nbdirsmax), t3, t3d(nbdirsmax
     +                 ), tr, trd(nbdirsmax), tst, ulp, v2, v2d(
     +                 nbdirsmax), v3, v3d(nbdirsmax), y5
      DOUBLE PRECISION abs10, abs10d(nbdirsmax), abs16, abs16d(nbdirsmax
     +                 ), abs17, abs20, abs20d(nbdirsmax), abs21, abs23
     +                 , v(3), vd(nbdirsmax, 3)
      DOUBLE PRECISION abs1, abs11, abs12, abs2, abs24, abs25, abs26,
     +                 abs3, abs4, abs5, abs9, abs9d(nbdirsmax), x1, x1d
     +                 (nbdirsmax), x2, x3, x3d(nbdirsmax), x4, y1, y1d(
     +                 nbdirsmax), y2, y3, y3d(nbdirsmax), y4
      DOUBLE PRECISION DLAMCH
      INTEGER arg1, i, i1, i2, ii1, its, j, k, l, m, min1, nd, nh, nr,
     +        nz
      EXTERNAL DLABAD, DLAMCH
      INTRINSIC MAX, ABS, DBLE, MIN, SQRT
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
C     Purpose
C     =======
C
C     DLAHQR is an auxiliary routine called by DHSEQR to update the
C     eigenvalues and Schur decomposition already computed by DHSEQR, by
C     dealing with the Hessenberg submatrix in rows and columns ILO to
C     IHI.
C
C     Arguments
C     =========
C
C     WANTT   (input) LOGICAL
C          = .TRUE. : the full Schur form T is required;
C          = .FALSE.: only eigenvalues are required.
C
C     WANTZ   (input) LOGICAL
C          = .TRUE. : the matrix of Schur vectors Z is required;
C          = .FALSE.: Schur vectors are not required.
C
C     N       (input) INTEGER
C          The order of the matrix H.  N >= 0.
C
C     ILO     (input) INTEGER
C     IHI     (input) INTEGER
C          It is assumed that H is already upper quasi-triangular in
C          rows and columns IHI+1:N, and that H(ILO,ILO-1) = 0 (unless
C          ILO = 1). DLAHQR works primarily with the Hessenberg
C          submatrix in rows and columns ILO to IHI, but applies
C          transformations to all of H if WANTT is .TRUE..
C          1 <= ILO <= max(1,IHI); IHI <= N.
C
C     H       (input/output) DOUBLE PRECISION array, dimension (LDH,N)
C          On entry, the upper Hessenberg matrix H.
C          On exit, if INFO is zero and if WANTT is .TRUE., H is upper
C          quasi-triangular in rows and columns ILO:IHI, with any
C          2-by-2 diagonal blocks in standard form. If INFO is zero
C          and WANTT is .FALSE., the contents of H are unspecified on
C          exit.  The output state of H if INFO is nonzero is given
C          below under the description of INFO.
C
C     LDH     (input) INTEGER
C          The leading dimension of the array H. LDH >= max(1,N).
C
C     WR      (output) DOUBLE PRECISION array, dimension (N)
C     WI      (output) DOUBLE PRECISION array, dimension (N)
C          The real and imaginary parts, respectively, of the computed
C          eigenvalues ILO to IHI are stored in the corresponding
C          elements of WR and WI. If two eigenvalues are computed as a
C          complex conjugate pair, they are stored in consecutive
C          elements of WR and WI, say the i-th and (i+1)th, with
C          WI(i) > 0 and WI(i+1) < 0. If WANTT is .TRUE., the
C          eigenvalues are stored in the same order as on the diagonal
C          of the Schur form returned in H, with WR(i) = H(i,i), and, if
C          H(i:i+1,i:i+1) is a 2-by-2 diagonal block,
C          WI(i) = sqrt(H(i+1,i)*H(i,i+1)) and WI(i+1) = -WI(i).
C
C     ILOZ    (input) INTEGER
C     IHIZ    (input) INTEGER
C          Specify the rows of Z to which transformations must be
C          applied if WANTZ is .TRUE..
C          1 <= ILOZ <= ILO; IHI <= IHIZ <= N.
C
C     Z       (input/output) DOUBLE PRECISION array, dimension (LDZ,N)
C          If WANTZ is .TRUE., on entry Z must contain the current
C          matrix Z of transformations accumulated by DHSEQR, and on
C          exit Z has been updated; transformations are applied only to
C          the submatrix Z(ILOZ:IHIZ,ILO:IHI).
C          If WANTZ is .FALSE., Z is not referenced.
C
C     LDZ     (input) INTEGER
C          The leading dimension of the array Z. LDZ >= max(1,N).
C
C     INFO    (output) INTEGER
C           =   0: successful exit
C          .GT. 0: If INFO = i, DLAHQR failed to compute all the
C                  eigenvalues ILO to IHI in a total of 30 iterations
C                  per eigenvalue; elements i+1:ihi of WR and WI
C                  contain those eigenvalues which have been
C                  successfully computed.
C
C                  If INFO .GT. 0 and WANTT is .FALSE., then on exit,
C                  the remaining unconverged eigenvalues are the
C                  eigenvalues of the upper Hessenberg matrix rows
C                  and columns ILO thorugh INFO of the final, output
C                  value of H.
C
C                  If INFO .GT. 0 and WANTT is .TRUE., then on exit
C          (*)       (initial value of H)*U  = U*(final value of H)
C                  where U is an orthognal matrix.    The final
C                  value of H is upper Hessenberg and triangular in
C                  rows and columns INFO+1 through IHI.
C
C                  If INFO .GT. 0 and WANTZ is .TRUE., then on exit
C                      (final value of Z)  = (initial value of Z)*U
C                  where U is the orthogonal matrix in (*)
C                  (regardless of the value of WANTT.)
C
C     Further Details
C     ===============
C
C     02-96 Based on modifications by
C     David Day, Sandia National Laboratory, USA
C
C     12-04 Further modifications by
C     Ralph Byers, University of Kansas, USA
C
C       This is a modified version of DLAHQR from LAPACK version 3.0.
C       It is (1) more robust against overflow and underflow and
C       (2) adopts the more conservative Ahues & Tisseur stopping
C       criterion (LAWN 122, 1997).
C
C     =========================================================
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
C     .. Executable Statements ..
C
      info = 0
C
C     Quick return if possible
C
      IF (n .EQ. 0) THEN
        RETURN
      ELSE IF (ilo .EQ. ihi) THEN
        DO nd=1,nbdirs
          wrd(nd, ilo) = hd(nd, ilo, ilo)
          wid(nd, ilo) = 0.D0
        ENDDO
        wr(ilo) = h(ilo, ilo)
        wi(ilo) = zero
        RETURN
      ELSE
C
C     ==== clear out the trash ====
        DO j=ilo,ihi-3
          DO nd=1,nbdirs
            hd(nd, j+2, j) = 0.D0
            hd(nd, j+3, j) = 0.D0
          ENDDO
          h(j+2, j) = zero
          h(j+3, j) = zero
        ENDDO
        IF (ilo .LE. ihi - 2) THEN
          DO nd=1,nbdirs
            hd(nd, ihi, ihi-2) = 0.D0
          ENDDO
          h(ihi, ihi-2) = zero
        END IF
C
        nh = ihi - ilo + 1
        nz = ihiz - iloz + 1
C
C     Set machine-dependent constants for the stopping criterion.
C
        safmin = DLAMCH('SAFE MINIMUM')
        safmax = one/safmin
        CALL DLABAD(safmin, safmax)
        ulp = DLAMCH('PRECISION')
        smlnum = safmin*(DBLE(nh)/ulp)
C
C     I1 and I2 are the indices of the first row and last column of H
C     to which transformations must be applied. If eigenvalues only are
C     being computed, I1 and I2 are set inside the main loop.
C
        IF (wantt) THEN
          i1 = 1
          i2 = n
        END IF
C
C     The main loop begins here. I is the loop index and decreases from
C     IHI to ILO in steps of 1 or 2. Each iteration of the loop works
C     with the active submatrix in rows and columns L to I.
C     Eigenvalues I+1 to IHI have already converged. Either L = ILO or
C     H(L,L-1) is negligible so that the matrix splits.
C
        i = ihi
        DO nd=1,nbdirs
          sd(nd) = 0.D0
        ENDDO
        DO ii1=1,3
          DO nd=1,nbdirs
            vd(nd, ii1) = 0.D0
          ENDDO
        ENDDO
 20     l = ilo
        IF (i .LT. ilo) THEN
          GOTO 160
        ELSE
C
C     Perform QR iterations on rows and columns ILO to I until a
C     submatrix of order 1 or 2 splits off at the bottom because a
C     subdiagonal element has become negligible.
C
          DO its=0,itmax
C
C        Look for a single small subdiagonal element.
C
            DO k=i,l+1,-1
              IF (h(k, k-1) .GE. 0.) THEN
                abs1 = h(k, k-1)
              ELSE
                abs1 = -h(k, k-1)
              END IF
              IF (abs1 .LE. smlnum) THEN
                GOTO 40
              ELSE
                IF (h(k-1, k-1) .GE. 0.) THEN
                  abs2 = h(k-1, k-1)
                ELSE
                  abs2 = -h(k-1, k-1)
                END IF
                IF (h(k, k) .GE. 0.) THEN
                  abs12 = h(k, k)
                ELSE
                  abs12 = -h(k, k)
                END IF
                tst = abs2 + abs12
                IF (tst .EQ. zero) THEN
                  IF (k - 2 .GE. ilo) THEN
                    IF (h(k-1, k-2) .GE. 0.) THEN
                      abs3 = h(k-1, k-2)
                    ELSE
                      abs3 = -h(k-1, k-2)
                    END IF
                    tst = tst + abs3
                  END IF
                  IF (k + 1 .LE. ihi) THEN
                    IF (h(k+1, k) .GE. 0.) THEN
                      abs4 = h(k+1, k)
                    ELSE
                      abs4 = -h(k+1, k)
                    END IF
                    tst = tst + abs4
                  END IF
                END IF
                IF (h(k, k-1) .GE. 0.) THEN
                  abs5 = h(k, k-1)
                ELSE
                  abs5 = -h(k, k-1)
                END IF
C           ==== The following is a conservative small subdiagonal
C           .    deflation  criterion due to Ahues & Tisseur (LAWN 122,
C           .    1997). It has better mathematical foundation and
C           .    improves accuracy in some cases.  ====
                IF (abs5 .LE. ulp*tst) THEN
                  IF (h(k, k-1) .GE. 0.) THEN
                    DO nd=1,nbdirs
                      x1d(nd) = hd(nd, k, k-1)
                    ENDDO
                    x1 = h(k, k-1)
                  ELSE
                    DO nd=1,nbdirs
                      x1d(nd) = -hd(nd, k, k-1)
                    ENDDO
                    x1 = -h(k, k-1)
                  END IF
                  IF (h(k-1, k) .GE. 0.) THEN
                    DO nd=1,nbdirs
                      y1d(nd) = hd(nd, k-1, k)
                    ENDDO
                    y1 = h(k-1, k)
                  ELSE
                    DO nd=1,nbdirs
                      y1d(nd) = -hd(nd, k-1, k)
                    ENDDO
                    y1 = -h(k-1, k)
                  END IF
                  IF (x1 .LT. y1) THEN
                    DO nd=1,nbdirs
                      abd(nd) = y1d(nd)
                    ENDDO
                    ab = y1
                  ELSE
                    DO nd=1,nbdirs
                      abd(nd) = x1d(nd)
                    ENDDO
                    ab = x1
                  END IF
                  IF (h(k, k-1) .GE. 0.) THEN
                    x2 = h(k, k-1)
                  ELSE
                    x2 = -h(k, k-1)
                  END IF
                  IF (h(k-1, k) .GE. 0.) THEN
                    y2 = h(k-1, k)
                  ELSE
                    y2 = -h(k-1, k)
                  END IF
                  IF (x2 .GT. y2) THEN
                    ba = y2
                  ELSE
                    ba = x2
                  END IF
                  IF (h(k, k) .GE. 0.) THEN
                    DO nd=1,nbdirs
                      x3d(nd) = hd(nd, k, k)
                    ENDDO
                    x3 = h(k, k)
                  ELSE
                    DO nd=1,nbdirs
                      x3d(nd) = -hd(nd, k, k)
                    ENDDO
                    x3 = -h(k, k)
                  END IF
                  IF (h(k-1, k-1) - h(k, k) .GE. 0.) THEN
                    DO nd=1,nbdirs
                      y3d(nd) = hd(nd, k-1, k-1) - hd(nd, k, k)
                    ENDDO
                    y3 = h(k-1, k-1) - h(k, k)
                  ELSE
                    DO nd=1,nbdirs
                      y3d(nd) = -(hd(nd, k-1, k-1)-hd(nd, k, k))
                    ENDDO
                    y3 = -(h(k-1, k-1)-h(k, k))
                  END IF
                  IF (x3 .LT. y3) THEN
                    DO nd=1,nbdirs
                      aad(nd) = y3d(nd)
                    ENDDO
                    aa = y3
                  ELSE
                    DO nd=1,nbdirs
                      aad(nd) = x3d(nd)
                    ENDDO
                    aa = x3
                  END IF
                  IF (h(k, k) .GE. 0.) THEN
                    x4 = h(k, k)
                  ELSE
                    x4 = -h(k, k)
                  END IF
                  IF (h(k-1, k-1) - h(k, k) .GE. 0.) THEN
                    y4 = h(k-1, k-1) - h(k, k)
                  ELSE
                    y4 = -(h(k-1, k-1)-h(k, k))
                  END IF
                  IF (x4 .GT. y4) THEN
                    bb = y4
                  ELSE
                    bb = x4
                  END IF
                  DO nd=1,nbdirs
                    sd(nd) = aad(nd) + abd(nd)
                  ENDDO
                  s = aa + ab
                  y5 = ulp*(bb*(aa/s))
                  IF (smlnum .LT. y5) THEN
                    max1 = y5
                  ELSE
                    max1 = smlnum
                  END IF
                  IF (ba*(ab/s) .LE. max1) GOTO 40
                END IF
              END IF
            ENDDO
 40         l = k
            IF (l .GT. ilo) THEN
              DO nd=1,nbdirs
                hd(nd, l, l-1) = 0.D0
              ENDDO
C
C           H(L,L-1) is negligible
C
              h(l, l-1) = zero
            END IF
C
C        Exit from loop if a submatrix of order 1 or 2 has split off.
C
            IF (l .GE. i - 1) THEN
              GOTO 150
            ELSE
C
C        Now the active submatrix is in rows and columns L to I. If
C        eigenvalues only are being computed, only the active submatrix
C        need be transformed.
C
              IF (.NOT.wantt) THEN
                i1 = l
                i2 = i
              END IF
C
              IF (its .EQ. 10 .OR. its .EQ. 20) THEN
                DO nd=1,nbdirs
                  h11d(nd) = dat1*sd(nd) + hd(nd, i, i)
                  h22d(nd) = h11d(nd)
                  h21d(nd) = sd(nd)
                  h12d(nd) = dat2*sd(nd)
                ENDDO
C
C           Exceptional shift.
C
                h11 = dat1*s + h(i, i)
                h12 = dat2*s
                h21 = s
                h22 = h11
              ELSE
                DO nd=1,nbdirs
                  h11d(nd) = hd(nd, i-1, i-1)
                  h22d(nd) = hd(nd, i, i)
                  h12d(nd) = hd(nd, i-1, i)
                  h21d(nd) = hd(nd, i, i-1)
                ENDDO
C
C           Prepare to use Francis' double shift
C           (i.e. 2nd degree generalized Rayleigh quotient)
C
                h11 = h(i-1, i-1)
                h21 = h(i, i-1)
                h12 = h(i-1, i)
                h22 = h(i, i)
              END IF
              IF (h11 .GE. 0.) THEN
                DO nd=1,nbdirs
                  abs6d(nd) = h11d(nd)
                ENDDO
                abs6 = h11
              ELSE
                DO nd=1,nbdirs
                  abs6d(nd) = -h11d(nd)
                ENDDO
                abs6 = -h11
              END IF
              IF (h12 .GE. 0.) THEN
                DO nd=1,nbdirs
                  abs13d(nd) = h12d(nd)
                ENDDO
                abs13 = h12
              ELSE
                DO nd=1,nbdirs
                  abs13d(nd) = -h12d(nd)
                ENDDO
                abs13 = -h12
              END IF
              IF (h21 .GE. 0.) THEN
                DO nd=1,nbdirs
                  abs18d(nd) = h21d(nd)
                ENDDO
                abs18 = h21
              ELSE
                DO nd=1,nbdirs
                  abs18d(nd) = -h21d(nd)
                ENDDO
                abs18 = -h21
              END IF
              IF (h22 .GE. 0.) THEN
                DO nd=1,nbdirs
                  abs22d(nd) = h22d(nd)
                ENDDO
                abs22 = h22
              ELSE
                DO nd=1,nbdirs
                  abs22d(nd) = -h22d(nd)
                ENDDO
                abs22 = -h22
              END IF
              DO nd=1,nbdirs
                sd(nd) = abs6d(nd) + abs13d(nd) + abs18d(nd) + abs22d(nd
     +            )
              ENDDO
              s = abs6 + abs13 + abs18 + abs22
              IF (s .EQ. zero) THEN
                rt1r = zero
                rt1i = zero
                rt2r = zero
                rt2i = zero
                DO nd=1,nbdirs
                  rt2id(nd) = 0.D0
                ENDDO
                DO nd=1,nbdirs
                  rt2rd(nd) = 0.D0
                ENDDO
                DO nd=1,nbdirs
                  rt1id(nd) = 0.D0
                ENDDO
                DO nd=1,nbdirs
                  rt1rd(nd) = 0.D0
                ENDDO
              ELSE
                DO nd=1,nbdirs
                  h22d(nd) = (h22d(nd)*s-h22*sd(nd))/s**2
                  h11d(nd) = (h11d(nd)*s-h11*sd(nd))/s**2
                  trd(nd) = (h11d(nd)+h22d(nd))/two
                  h12d(nd) = (h12d(nd)*s-h12*sd(nd))/s**2
                  h21d(nd) = (h21d(nd)*s-h21*sd(nd))/s**2
                ENDDO
                h11 = h11/s
                h21 = h21/s
                h12 = h12/s
                h22 = h22/s
                tr = (h11+h22)/two
                DO nd=1,nbdirs
                  detd(nd) = (h11d(nd)-trd(nd))*(h22-tr) + (h11-tr)*(
     +              h22d(nd)-trd(nd)) - h12d(nd)*h21 - h12*h21d(nd)
                ENDDO
                det = (h11-tr)*(h22-tr) - h12*h21
                IF (det .GE. 0.) THEN
                  DO nd=1,nbdirs
                    abs7d(nd) = detd(nd)
                  ENDDO
                  abs7 = det
                ELSE
                  DO nd=1,nbdirs
                    abs7d(nd) = -detd(nd)
                  ENDDO
                  abs7 = -det
                END IF
                DO nd=1,nbdirs
                  IF (abs7d(nd) .EQ. 0.0 .OR. abs7 .EQ. 0.0) THEN
                    rtdiscd(nd) = 0.D0
                  ELSE
                    rtdiscd(nd) = abs7d(nd)/(2.0*SQRT(abs7))
                  END IF
                ENDDO
                rtdisc = SQRT(abs7)
                IF (det .GE. zero) THEN
C
C              ==== complex conjugate shifts ====
C
                  rt1r = tr*s
                  rt2r = rt1r
                  DO nd=1,nbdirs
                    rt1id(nd) = rtdiscd(nd)*s + rtdisc*sd(nd)
                    rt1rd(nd) = trd(nd)*s + tr*sd(nd)
                    rt2id(nd) = -rt1id(nd)
                    rt2rd(nd) = rt1rd(nd)
                  ENDDO
                  rt1i = rtdisc*s
                  rt2i = -rt1i
                ELSE
                  DO nd=1,nbdirs
                    rt1rd(nd) = trd(nd) + rtdiscd(nd)
                    rt2rd(nd) = trd(nd) - rtdiscd(nd)
                  ENDDO
C
C              ==== real shifts (use only one of them)  ====
C
                  rt1r = tr + rtdisc
                  rt2r = tr - rtdisc
                  IF (rt1r - h22 .GE. 0.) THEN
                    abs8 = rt1r - h22
                  ELSE
                    abs8 = -(rt1r-h22)
                  END IF
                  IF (rt2r - h22 .GE. 0.) THEN
                    abs14 = rt2r - h22
                  ELSE
                    abs14 = -(rt2r-h22)
                  END IF
                  IF (abs8 .LE. abs14) THEN
                    DO nd=1,nbdirs
                      rt1rd(nd) = rt1rd(nd)*s + rt1r*sd(nd)
                      rt2rd(nd) = rt1rd(nd)
                    ENDDO
                    rt1r = rt1r*s
                    rt2r = rt1r
                  ELSE
                    DO nd=1,nbdirs
                      rt2rd(nd) = rt2rd(nd)*s + rt2r*sd(nd)
                      rt1rd(nd) = rt2rd(nd)
                    ENDDO
                    rt2r = rt2r*s
                    rt1r = rt2r
                  END IF
                  rt1i = zero
                  rt2i = zero
                  DO nd=1,nbdirs
                    rt2id(nd) = 0.D0
                  ENDDO
                  DO nd=1,nbdirs
                    rt1id(nd) = 0.D0
                  ENDDO
                END IF
              END IF
C
C        Look for two consecutive small subdiagonal elements.
C
              DO m=i-2,l,-1
                DO nd=1,nbdirs
                  h21sd(nd) = hd(nd, m+1, m)
                ENDDO
C           Determine the effect of starting the double-shift QR
C           iteration at row M, and see if this would make H(M,M-1)
C           negligible.  (The following uses scaling to avoid
C           overflows and most underflows.)
C
                h21s = h(m+1, m)
                IF (h(m, m) - rt2r .GE. 0.) THEN
                  DO nd=1,nbdirs
                    abs9d(nd) = hd(nd, m, m) - rt2rd(nd)
                  ENDDO
                  abs9 = h(m, m) - rt2r
                ELSE
                  DO nd=1,nbdirs
                    abs9d(nd) = -(hd(nd, m, m)-rt2rd(nd))
                  ENDDO
                  abs9 = -(h(m, m)-rt2r)
                END IF
                IF (rt2i .GE. 0.) THEN
                  DO nd=1,nbdirs
                    abs15d(nd) = rt2id(nd)
                  ENDDO
                  abs15 = rt2i
                ELSE
                  DO nd=1,nbdirs
                    abs15d(nd) = -rt2id(nd)
                  ENDDO
                  abs15 = -rt2i
                END IF
                IF (h21s .GE. 0.) THEN
                  DO nd=1,nbdirs
                    abs19d(nd) = h21sd(nd)
                  ENDDO
                  abs19 = h21s
                ELSE
                  DO nd=1,nbdirs
                    abs19d(nd) = -h21sd(nd)
                  ENDDO
                  abs19 = -h21s
                END IF
                s = abs9 + abs15 + abs19
                h21s = h(m+1, m)/s
                DO nd=1,nbdirs
                  sd(nd) = abs9d(nd) + abs15d(nd) + abs19d(nd)
                  h21sd(nd) = (hd(nd, m+1, m)*s-h(m+1, m)*sd(nd))/s**2
                  vd(nd, 1) = h21sd(nd)*h(m, m+1) + h21s*hd(nd, m, m+1)
     +              + (hd(nd, m, m)-rt1rd(nd))*(h(m, m)-rt2r)/s + (h(m,
     +              m)-rt1r)*((hd(nd, m, m)-rt2rd(nd))*s-(h(m, m)-rt2r)*
     +              sd(nd))/s**2 - rt1id(nd)*rt2i/s - rt1i*(rt2id(nd)*s-
     +              rt2i*sd(nd))/s**2
                  vd(nd, 2) = h21sd(nd)*(h(m, m)+h(m+1, m+1)-rt1r-rt2r)
     +              + h21s*(hd(nd, m, m)+hd(nd, m+1, m+1)-rt1rd(nd)-
     +              rt2rd(nd))
                  vd(nd, 3) = h21sd(nd)*h(m+2, m+1) + h21s*hd(nd, m+2, m
     +              +1)
                ENDDO
                v(1) = h21s*h(m, m+1) + (h(m, m)-rt1r)*((h(m, m)-rt2r)/s
     +            ) - rt1i*(rt2i/s)
                v(2) = h21s*(h(m, m)+h(m+1, m+1)-rt1r-rt2r)
                v(3) = h21s*h(m+2, m+1)
                IF (v(1) .GE. 0.) THEN
                  DO nd=1,nbdirs
                    abs10d(nd) = vd(nd, 1)
                  ENDDO
                  abs10 = v(1)
                ELSE
                  DO nd=1,nbdirs
                    abs10d(nd) = -vd(nd, 1)
                  ENDDO
                  abs10 = -v(1)
                END IF
                IF (v(2) .GE. 0.) THEN
                  DO nd=1,nbdirs
                    abs16d(nd) = vd(nd, 2)
                  ENDDO
                  abs16 = v(2)
                ELSE
                  DO nd=1,nbdirs
                    abs16d(nd) = -vd(nd, 2)
                  ENDDO
                  abs16 = -v(2)
                END IF
                IF (v(3) .GE. 0.) THEN
                  DO nd=1,nbdirs
                    abs20d(nd) = vd(nd, 3)
                  ENDDO
                  abs20 = v(3)
                ELSE
                  DO nd=1,nbdirs
                    abs20d(nd) = -vd(nd, 3)
                  ENDDO
                  abs20 = -v(3)
                END IF
                s = abs10 + abs16 + abs20
                DO nd=1,nbdirs
                  sd(nd) = abs10d(nd) + abs16d(nd) + abs20d(nd)
                  vd(nd, 1) = (vd(nd, 1)*s-v(1)*sd(nd))/s**2
                ENDDO
                v(1) = v(1)/s
                DO nd=1,nbdirs
                  vd(nd, 2) = (vd(nd, 2)*s-v(2)*sd(nd))/s**2
                ENDDO
                v(2) = v(2)/s
                DO nd=1,nbdirs
                  vd(nd, 3) = (vd(nd, 3)*s-v(3)*sd(nd))/s**2
                ENDDO
                v(3) = v(3)/s
                IF (m .EQ. l) THEN
                  GOTO 60
                ELSE
                  IF (h(m, m-1) .GE. 0.) THEN
                    abs11 = h(m, m-1)
                  ELSE
                    abs11 = -h(m, m-1)
                  END IF
                  IF (v(2) .GE. 0.) THEN
                    abs17 = v(2)
                  ELSE
                    abs17 = -v(2)
                  END IF
                  IF (v(3) .GE. 0.) THEN
                    abs21 = v(3)
                  ELSE
                    abs21 = -v(3)
                  END IF
                  IF (v(1) .GE. 0.) THEN
                    abs23 = v(1)
                  ELSE
                    abs23 = -v(1)
                  END IF
                  IF (h(m-1, m-1) .GE. 0.) THEN
                    abs24 = h(m-1, m-1)
                  ELSE
                    abs24 = -h(m-1, m-1)
                  END IF
                  IF (h(m, m) .GE. 0.) THEN
                    abs25 = h(m, m)
                  ELSE
                    abs25 = -h(m, m)
                  END IF
                  IF (h(m+1, m+1) .GE. 0.) THEN
                    abs26 = h(m+1, m+1)
                  ELSE
                    abs26 = -h(m+1, m+1)
                  END IF
                  IF (abs11*(abs17+abs21) .LE. ulp*abs23*(abs24+abs25+
     +                abs26)) GOTO 60
                END IF
              ENDDO
 60           CONTINUE
C
C        Double-shift QR step
C
              DO k=m,i-1
                IF (3 .GT. i - k + 1) THEN
                  nr = i - k + 1
                ELSE
                  nr = 3
                END IF
                IF (k .GT. m) CALL DCOPY_DV(nr, h(k, k-1), hd(1, k, k-1)
     +                                      , 1, v, vd, 1, nbdirs)
                CALL DLARFG_DV(nr, v(1), vd(1, 1), v(2), vd(1, 2), 1, t1
     +                         , t1d, nbdirs)
                IF (k .GT. m) THEN
                  DO nd=1,nbdirs
                    hd(nd, k, k-1) = vd(nd, 1)
                    hd(nd, k+1, k-1) = 0.D0
                  ENDDO
                  h(k, k-1) = v(1)
                  h(k+1, k-1) = zero
                  IF (k .LT. i - 1) THEN
                    DO nd=1,nbdirs
                      hd(nd, k+2, k-1) = 0.D0
                    ENDDO
                    h(k+2, k-1) = zero
                  END IF
                ELSE IF (m .GT. l) THEN
                  DO nd=1,nbdirs
                    hd(nd, k, k-1) = -hd(nd, k, k-1)
                  ENDDO
                  h(k, k-1) = -h(k, k-1)
                END IF
                v2 = v(2)
                DO nd=1,nbdirs
                  v2d(nd) = vd(nd, 2)
                  t2d(nd) = t1d(nd)*v2 + t1*v2d(nd)
                ENDDO
                t2 = t1*v2
                IF (nr .EQ. 3) THEN
                  v3 = v(3)
                  DO nd=1,nbdirs
                    v3d(nd) = vd(nd, 3)
                    t3d(nd) = t1d(nd)*v3 + t1*v3d(nd)
                  ENDDO
                  t3 = t1*v3
C
C              Apply G from the left to transform the rows of the matrix
C              in columns K to I2.
C
                  DO j=k,i2
                    sum = h(k, j) + v2*h(k+1, j) + v3*h(k+2, j)
                    DO nd=1,nbdirs
                      sumd(nd) = hd(nd, k, j) + v2d(nd)*h(k+1, j) + v2*
     +                  hd(nd, k+1, j) + v3d(nd)*h(k+2, j) + v3*hd(nd, k
     +                  +2, j)
                      hd(nd, k, j) = hd(nd, k, j) - sumd(nd)*t1 - sum*
     +                  t1d(nd)
                      hd(nd, k+1, j) = hd(nd, k+1, j) - sumd(nd)*t2 -
     +                  sum*t2d(nd)
                      hd(nd, k+2, j) = hd(nd, k+2, j) - sumd(nd)*t3 -
     +                  sum*t3d(nd)
                    ENDDO
                    h(k, j) = h(k, j) - sum*t1
                    h(k+1, j) = h(k+1, j) - sum*t2
                    h(k+2, j) = h(k+2, j) - sum*t3
                  ENDDO
                  IF (k + 3 .GT. i) THEN
                    min1 = i
                  ELSE
                    min1 = k + 3
                  END IF
C
C              Apply G from the right to transform the columns of the
C              matrix in rows I1 to min(K+3,I).
C
                  DO j=i1,min1
                    sum = h(j, k) + v2*h(j, k+1) + v3*h(j, k+2)
                    DO nd=1,nbdirs
                      sumd(nd) = hd(nd, j, k) + v2d(nd)*h(j, k+1) + v2*
     +                  hd(nd, j, k+1) + v3d(nd)*h(j, k+2) + v3*hd(nd, j
     +                  , k+2)
                      hd(nd, j, k) = hd(nd, j, k) - sumd(nd)*t1 - sum*
     +                  t1d(nd)
                      hd(nd, j, k+1) = hd(nd, j, k+1) - sumd(nd)*t2 -
     +                  sum*t2d(nd)
                      hd(nd, j, k+2) = hd(nd, j, k+2) - sumd(nd)*t3 -
     +                  sum*t3d(nd)
                    ENDDO
                    h(j, k) = h(j, k) - sum*t1
                    h(j, k+1) = h(j, k+1) - sum*t2
                    h(j, k+2) = h(j, k+2) - sum*t3
                  ENDDO
C
                  IF (wantz) THEN
C
C                 Accumulate transformations in the matrix Z
C
                    DO j=iloz,ihiz
                      sum = z(j, k) + v2*z(j, k+1) + v3*z(j, k+2)
                      DO nd=1,nbdirs
                        sumd(nd) = zd(nd, j, k) + v2d(nd)*z(j, k+1) + v2
     +                    *zd(nd, j, k+1) + v3d(nd)*z(j, k+2) + v3*zd(nd
     +                    , j, k+2)
                        zd(nd, j, k) = zd(nd, j, k) - sumd(nd)*t1 - sum*
     +                    t1d(nd)
                        zd(nd, j, k+1) = zd(nd, j, k+1) - sumd(nd)*t2 -
     +                    sum*t2d(nd)
                        zd(nd, j, k+2) = zd(nd, j, k+2) - sumd(nd)*t3 -
     +                    sum*t3d(nd)
                      ENDDO
                      z(j, k) = z(j, k) - sum*t1
                      z(j, k+1) = z(j, k+1) - sum*t2
                      z(j, k+2) = z(j, k+2) - sum*t3
                    ENDDO
                  END IF
                ELSE IF (nr .EQ. 2) THEN
C
C              Apply G from the left to transform the rows of the matrix
C              in columns K to I2.
C
                  DO j=k,i2
                    sum = h(k, j) + v2*h(k+1, j)
                    DO nd=1,nbdirs
                      sumd(nd) = hd(nd, k, j) + v2d(nd)*h(k+1, j) + v2*
     +                  hd(nd, k+1, j)
                      hd(nd, k, j) = hd(nd, k, j) - sumd(nd)*t1 - sum*
     +                  t1d(nd)
                      hd(nd, k+1, j) = hd(nd, k+1, j) - sumd(nd)*t2 -
     +                  sum*t2d(nd)
                    ENDDO
                    h(k, j) = h(k, j) - sum*t1
                    h(k+1, j) = h(k+1, j) - sum*t2
                  ENDDO
C
C              Apply G from the right to transform the columns of the
C              matrix in rows I1 to min(K+3,I).
C
                  DO j=i1,i
                    sum = h(j, k) + v2*h(j, k+1)
                    DO nd=1,nbdirs
                      sumd(nd) = hd(nd, j, k) + v2d(nd)*h(j, k+1) + v2*
     +                  hd(nd, j, k+1)
                      hd(nd, j, k) = hd(nd, j, k) - sumd(nd)*t1 - sum*
     +                  t1d(nd)
                      hd(nd, j, k+1) = hd(nd, j, k+1) - sumd(nd)*t2 -
     +                  sum*t2d(nd)
                    ENDDO
                    h(j, k) = h(j, k) - sum*t1
                    h(j, k+1) = h(j, k+1) - sum*t2
                  ENDDO
C
                  IF (wantz) THEN
C
C                 Accumulate transformations in the matrix Z
C
                    DO j=iloz,ihiz
                      sum = z(j, k) + v2*z(j, k+1)
                      DO nd=1,nbdirs
                        sumd(nd) = zd(nd, j, k) + v2d(nd)*z(j, k+1) + v2
     +                    *zd(nd, j, k+1)
                        zd(nd, j, k) = zd(nd, j, k) - sumd(nd)*t1 - sum*
     +                    t1d(nd)
                        zd(nd, j, k+1) = zd(nd, j, k+1) - sumd(nd)*t2 -
     +                    sum*t2d(nd)
                      ENDDO
                      z(j, k) = z(j, k) - sum*t1
                      z(j, k+1) = z(j, k+1) - sum*t2
                    ENDDO
                  END IF
                END IF
              ENDDO
            END IF
          ENDDO
          GOTO 100
C
C
 150      IF (l .EQ. i) THEN
            DO nd=1,nbdirs
              wrd(nd, i) = hd(nd, i, i)
              wid(nd, i) = 0.D0
            ENDDO
C
C        H(I,I-1) is negligible: one eigenvalue has converged.
C
            wr(i) = h(i, i)
            wi(i) = zero
          ELSE IF (l .EQ. i - 1) THEN
C
C        H(I-1,I-2) is negligible: a pair of eigenvalues have converged.
C
C        Transform the 2-by-2 submatrix to standard Schur form,
C        and compute and store the eigenvalues.
C
            CALL DLANV2_DV(h(i-1, i-1), hd(1, i-1, i-1), h(i-1, i), hd(1
     +                     , i-1, i), h(i, i-1), hd(1, i, i-1), h(i, i)
     +                     , hd(1, i, i), wr(i-1), wrd(1, i-1), wi(i-1)
     +                     , wid(1, i-1), wr(i), wrd(1, i), wi(i), wid(1
     +                     , i), cs, csd, sn, snd, nbdirs)
C
            IF (wantt) THEN
C
C           Apply the transformation to the rest of H.
C
              IF (i2 .GT. i) THEN
                arg1 = i2 - i
                CALL DROT_DV(arg1, h(i-1, i+1), hd(1, i-1, i+1), ldh, h(
     +                       i, i+1), hd(1, i, i+1), ldh, cs, csd, sn,
     +                       snd, nbdirs)
              END IF
              arg1 = i - i1 - 1
              CALL DROT_DV(arg1, h(i1, i-1), hd(1, i1, i-1), 1, h(i1, i)
     +                     , hd(1, i1, i), 1, cs, csd, sn, snd, nbdirs)
            END IF
            IF (wantz) CALL DROT_DV(nz, z(iloz, i-1), zd(1, iloz, i-1),
     +                              1, z(iloz, i), zd(1, iloz, i), 1, cs
     +                              , csd, sn, snd, nbdirs)
C
C           Apply the transformation to Z.
C
          END IF
C
C     return to start of the main loop with new value of I.
C
          i = l - 1
          GOTO 20
        END IF
C
C
C     Failure to converge in remaining number of iterations
C
 100    info = i
        RETURN
C
 160    RETURN
      END IF
      END