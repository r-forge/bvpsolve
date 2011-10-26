c-----------------------------------------------------------------------
c-----------------------------------------------------------------------
c
c     This file is part of the Test Set for IVP solvers
c     http://www.dm.uniba.it/~testset/
c
c        Two bit adding unit
c        index 1 DAE of dimension 350
c
c     DISCLAIMER: see
c     http://www.dm.uniba.it/~testset/disclaimer.php
c
c     The most recent version of this source file can be found at
c     http://www.dm.uniba.it/~testset/src/problems/tba.f
c
c     This is revision
c     $Id: tba.F,v 1.2 2006/10/02 10:29:14 testset Exp $
c
c-----------------------------------------------------------------------
c-----------------------------------------------------------------------

c----------------------------------------------------------------------
c     residual function
c----------------------------------------------------------------------

      SUBROUTINE twobres(t,Y,YPRIME,CJ,DF,IERR,RPAR,IPAR)
      IMPLICIT NONE
	    INTEGER I, N
	    parameter(N=350)
      DOUBLE PRECISION T,CJ,Y(N), YPRIME(N), DF(N),RPAR(*)
      INTEGER ierr, IPAR(*)

      CALL twobfunc(N,T,Y,DF,RPAR,IPAR)
C
      DO I=1, 175
         DF(I) =  YPRIME(I) - DF(I)
      ENDDO
      DO I= 176,N
         DF(I) = -DF(I)
      ENDDO

      RETURN
      END
c-----------------------------------------------------------------------
      SUBROUTINE twobFunc(NEQN,T,Y,DY,RPAR,IPAR)
      IMPLICIT NONE
      INTEGER NEQN, I,IPAR(*), IERR
      double precision t,y(*),dy(*),rpar(*)
      double precision x(175),res(175)
      external FCN,GCN
      CHARACTER(LEN=80) MSG

      do 10 i=1,175
 10      x(i)=y(i+175)
      CALL FCN(175,t,x,res, ierr)

      IF ( IERR .EQ. -1 ) THEN
         WRITE(MSG, *)"AN ERROR OCCURRED in TWOBIT, at time", T
         call rexit(MSG)
        RETURN
      ENDIF
      do 20 i=1,175
 20      dy(i)=res(i)
      call GCN(175,x,res)
      do 30 i=1,175
 30      dy(i+175)=y(i)-res(i)

      RETURN
      END

c----------------------------------------------------------------------
c     initialisation function
c----------------------------------------------------------------------

      SUBROUTINE twobinit(NEQN,T,Y,YPRIME)
      IMPLICIT NONE
      DOUBLE PRECISION Y(NEQN),T,YPRIME(NEQN), U(175)
      integer neqn,incon,i,j
      double precision RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
       COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

      external GCN

C     y{0}=(g(U), U), where U is the vector of voltage variables
C     g(u) is computed by GCN

C --- Scaling of time axis
      CTIME=1.d4
C --- Stiffness factor for the voltage courses
      STIFF=5.d0
C --- The MOS-Parameters
      RGS=.4D2/(CTIME*STIFF)
      RGD=.4D2/(CTIME*STIFF)
      RBS=.1D3/(CTIME*STIFF)
      RBD=.1D3/(CTIME*STIFF)
      CGS=.6D-4*CTIME
      CGD=.6D-4*CTIME
      CBD=2.4D-5*CTIME
      CBS=2.4D-5*CTIME
      DELTA=0.2D-1
      CURIS=1.D-15*CTIME*STIFF
      VTH=25.85d0
      VDD=5.d0
      VBB=-2.5d0
C --- Load capacitance for the logical subciruits
C     CLOAD=.5D-4*CTIME
C     No artificial load capacitances
      CLOAD=0.0d0
C --- Load capacitance for the output nodes
      COUT=2.D-4*CTIME-CLOAD
      U(  1) =    4.999999999996544d0
      U(  2) =    4.999999999999970d0
      U(  3) =   -2.499999999999975d0
      U(  4) =   -2.499999999999975d0
      U(  5) =    4.999999999996514d0
      U(  6) =    0.000000000000000d0
      U(  7) =    4.999999999996514d0
      U(  8) =   -2.499999999999991d0
      U(  9) =   -2.499999999999975d0
      U( 10) =    0.000000000000000d0
      U( 11) =    4.999999999996514d0
      U( 12) =   -2.499999999999991d0
      U( 13) =   -2.499999999999975d0
      U( 14) =    0.215858486765796d0
      U( 15) =    4.988182208251953d0
      U( 16) =   -2.499999999999990d0
      U( 17) =   -2.499999999999975d0
      U( 18) =    0.204040695017748d0
      U( 19) =    0.011817791748026d0
      U( 20) =    0.192222903269723d0
      U( 21) =   -2.499999999999991d0
      U( 22) =   -2.499999999999990d0
      U( 23) =   -0.228160951881239d0
      U( 24) =    0.204040695017748d0
      U( 25) =   -2.499999999999992d0
      U( 26) =   -2.499999999999990d0
      U( 27) =   -0.228160951881241d0
      U( 28) =    0.000000000000000d0
      U( 29) =   -0.228160951881239d0
      U( 30) =   -2.499999999999991d0
      U( 31) =   -2.499999999999992d0
      U( 32) =    4.999999999996547d0
      U( 33) =    4.999999999999970d0
      U( 34) =   -2.499999999999975d0
      U( 35) =   -2.499999999999975d0
      U( 36) =    4.999999999996517d0
      U( 37) =    0.000000000000000d0
      U( 38) =    4.999999999996517d0
      U( 39) =   -2.499999999999991d0
      U( 40) =   -2.499999999999975d0
      U( 41) =    0.000000000000000d0
      U( 42) =    4.999999999996517d0
      U( 43) =   -2.499999999999991d0
      U( 44) =   -2.499999999999975d0
      U( 45) =    0.215858484247529d0
      U( 46) =    4.988182208251953d0
      U( 47) =   -2.499999999999990d0
      U( 48) =   -2.499999999999975d0
      U( 49) =    0.204040692499482d0
      U( 50) =    0.011817791748035d0
      U( 51) =    0.192222900751447d0
      U( 52) =   -2.499999999999991d0
      U( 53) =   -2.499999999999990d0
      U( 54) =   -0.026041071738432d0
      U( 55) =    0.204040692499482d0
      U( 56) =   -2.499999999999992d0
      U( 57) =   -2.499999999999990d0
      U( 58) =   -0.026041071738434d0
      U( 59) =    0.000000000000000d0
      U( 60) =   -0.026041071738432d0
      U( 61) =   -2.499999999999991d0
      U( 62) =   -2.499999999999992d0
      U( 63) =    0.215858484880918d0
      U( 64) =    4.988182208251953d0
      U( 65) =   -2.499999999999990d0
      U( 66) =   -2.499999999999975d0
      U( 67) =    0.204040693132870d0
      U( 68) =    0.011817791748026d0
      U( 69) =    0.192222901384845d0
      U( 70) =   -2.499999999999991d0
      U( 71) =   -2.499999999999990d0
      U( 72) =   -0.026041071737961d0
      U( 73) =    0.204040693132870d0
      U( 74) =   -2.499999999999992d0
      U( 75) =   -2.499999999999990d0
      U( 76) =   -0.026041071737963d0
      U( 77) =    0.000000000000000d0
      U( 78) =   -0.026041071737961d0
      U( 79) =   -2.499999999999991d0
      U( 80) =   -2.499999999999992d0
      U( 81) =    4.999999999996546d0
      U( 82) =    4.999999999999970d0
      U( 83) =   -2.499999999999975d0
      U( 84) =   -2.499999999999975d0
      U( 85) =    4.999999999996516d0
      U( 86) =    0.000000000000000d0
      U( 87) =    4.999999999996516d0
      U( 88) =   -2.499999999999991d0
      U( 89) =   -2.499999999999975d0
      U( 90) =    0.000000000000000d0
      U( 91) =    4.999999999996516d0
      U( 92) =   -2.499999999999991d0
      U( 93) =   -2.499999999999975d0
      U( 94) =    0.215858481060569d0
      U( 95) =    4.988182208251953d0
      U( 96) =   -2.499999999999990d0
      U( 97) =   -2.499999999999975d0
      U( 98) =    0.204040689312522d0
      U( 99) =    0.011817791748023d0
      U(100) =    0.192222897564498d0
      U(101) =   -2.499999999999991d0
      U(102) =   -2.499999999999990d0
      U(103) =    4.734672533390068d0
      U(104) =    0.204040689312522d0
      U(105) =   -2.499999999999977d0
      U(106) =   -2.499999999999990d0
      U(107) =    4.734672533390062d0
      U(108) =    0.000000000000000d0
      U(109) =    4.734672533390068d0
      U(110) =   -2.499999999999991d0
      U(111) =   -2.499999999999977d0
      U(112) =    4.999999999996870d0
      U(113) =    4.999999999999972d0
      U(114) =   -2.499999999999975d0
      U(115) =   -2.499999999999975d0
      U(116) =    4.999999999996843d0
      U(117) =   -0.025968303070038d0
      U(118) =    4.999999999996843d0
      U(119) =   -2.499999999999992d0
      U(120) =   -2.499999999999975d0
      U(121) =   -0.025968303070040d0
      U(122) =    0.000000000000000d0
      U(123) =   -0.025968303070038d0
      U(124) =   -2.499999999999991d0
      U(125) =   -2.499999999999992d0
      U(126) =    4.999999999997699d0
      U(127) =    4.999999999999980d0
      U(128) =   -2.499999999999975d0
      U(129) =   -2.499999999999975d0
      U(130) =    4.999999999997678d0
      U(131) =    4.744923533081106d0
      U(132) =    4.999999999997678d0
      U(133) =   -2.499999999999977d0
      U(134) =   -2.499999999999975d0
      U(135) =    4.744923533081098d0
      U(136) =    0.000000000000000d0
      U(137) =    4.744923533081106d0
      U(138) =   -2.499999999999991d0
      U(139) =   -2.499999999999977d0
      U(140) =    0.000000000000000d0
      U(141) =    4.744923533081106d0
      U(142) =   -2.499999999999991d0
      U(143) =   -2.499999999999977d0
      U(144) =    0.215858484844162d0
      U(145) =    4.988182208251953d0
      U(146) =   -2.499999999999990d0
      U(147) =   -2.499999999999975d0
      U(148) =    0.204040693096114d0
      U(149) =    0.011817791748023d0
      U(150) =    0.192222901348091d0
      U(151) =   -2.499999999999991d0
      U(152) =   -2.499999999999990d0
      U(153) =    0.204040693096045d0
      U(154) =    0.204040693096107d0
      U(155) =   -2.499999999999990d0
      U(156) =   -2.499999999999990d0
      U(157) =    0.204040693096037d0
      U(158) =    0.000000000000000d0
      U(159) =    0.204040693096037d0
      U(160) =   -2.499999999999991d0
      U(161) =   -2.499999999999990d0
      U(162) =   -0.026017361873565d0
      U(163) =    0.204040693096114d0
      U(164) =   -2.499999999999992d0
      U(165) =   -2.499999999999990d0
      U(166) =   -0.026017361873568d0
      U(167) =   -0.026017590106916d0
      U(168) =   -0.026017361873565d0
      U(169) =   -2.499999999999992d0
      U(170) =   -2.499999999999992d0
      U(171) =   -0.026017590106918d0
      U(172) =    0.000000000000000d0
      U(173) =   -0.026017590106916d0
      U(174) =   -2.499999999999991d0
      U(175) =   -2.499999999999992d0

      call GCN(175,U,y)

      do 20 i=1,175
         y(i+175)=U(i)
 20   continue
C
      do 30 j=1,neqn
         yprime(j)=0.0d0
 30   continue

      return
      end


c----------------------------------------------------------------------
c     solution at default settings
c----------------------------------------------------------------------

      SUBROUTINE twobsoln(NEQN,Y)
      IMPLICIT NONE
      INTEGER NEQN 
      DOUBLE PRECISION  Y(NEQN)

C ----------------------------------------------------------------------
C
C     the reference solution was computed with RADAU5,
C     atol=rtol=1d-5, h0=4d-5
C
C     # steps                2518
C     # steps accepted       2044
C     # f-eval              21762
C     # Jac-eval             1742
C     # LU-decomp            2508
C
C     The scd values reported in the section "Numerical solution of the
C     problem" were computed by considering only the output signals.
C     They are given by:
C
C          x(49)  = y(49+175)  = y(224)
C          x(130) = y(130+175) = y(305)
C          x(148) = y(148+175) = y(323)
C---------------------------------------------------------------------------
      y(  1) =   0.5329676348348893d-05
      y(  2) =   0.6083199215822746d-03
      y(  3) =  -0.5802788414936773d+00
      y(  4) =  -0.1934408303298687d+00
      y(  5) =   0.1924683208304517d+02
      y(  6) =  -0.5143798198402260d-61
      y(  7) =   0.2999386350402069d+01
      y(  8) =  -0.3048568278060051d+00
      y(  9) =  -0.5802788414936773d+00
      y( 10) =  -0.5143798198402260d-61
      y( 11) =   0.2999386350402069d+01
      y( 12) =  -0.3048568278060051d+00
      y( 13) =  -0.5794434527225972d+00
      y( 14) =   0.7090602915275927d-02
      y( 15) =   0.2870386839346849d+01
      y( 16) =  -0.3201995162025645d+00
      y( 17) =  -0.1934408303298687d+00
      y( 18) =  -0.3831797456449475d+01
      y( 19) =  -0.2992291455828521d+01
      y( 20) =  -0.2883958687237743d+01
      y( 21) =  -0.3048568278060051d+00
      y( 22) =  -0.3201995162025645d+00
      y( 23) =  -0.1408045046739925d+00
      y( 24) =   0.1225221993879181d+00
      y( 25) =  -0.2863915327854759d+00
      y( 26) =  -0.3201995162025645d+00
      y( 27) =   0.5727830655709517d+00
      y( 28) =  -0.3568994249538271d-06
      y( 29) =  -0.1408045061245250d+00
      y( 30) =  -0.3048568278060051d+00
      y( 31) =  -0.2863915327854759d+00
      y( 32) =   0.1046493633015554d-06
      y( 33) =   0.1194233059399546d-04
      y( 34) =  -0.5803216340894781d+00
      y( 35) =  -0.1934408303298687d+00
      y( 36) =   0.7618503612049611d+01
      y( 37) =  -0.1225225577378757d+00
      y( 38) =   0.2877465395282166d+01
      y( 39) =  -0.3048568278060051d+00
      y( 40) =  -0.5803216340894781d+00
      y( 41) =  -0.5144043562440774d-61
      y( 42) =   0.2999987953020043d+01
      y( 43) =  -0.3048568278060051d+00
      y( 44) =  -0.5794087680278276d+00
      y( 45) =   0.7090674536833933d-02
      y( 46) =   0.2870484175935613d+01
      y( 47) =  -0.3201875688249403d+00
      y( 48) =  -0.1934408303298687d+00
      y( 49) =  -0.1508928314544720d+01
      y( 50) =  -0.2992897263001197d+01
      y( 51) =  -0.2884653493511335d+01
      y( 52) =  -0.3048568278060051d+00
      y( 53) =  -0.3201875688249403d+00
      y( 54) =  -0.2207815941707912d-01
      y( 55) =   0.1224251495275525d+00
      y( 56) =  -0.3020231631441768d+00
      y( 57) =  -0.3201875688249403d+00
      y( 58) =   0.6040463262883536d+00
      y( 59) =  -0.1225235639587947d+00
      y( 60) =  -0.1445997109340358d+00
      y( 61) =  -0.3048568278060051d+00
      y( 62) =  -0.3020231631441768d+00
      y( 63) =   0.7090617704627438d-02
      y( 64) =   0.2870406940405611d+01
      y( 65) =  -0.3201970487035549d+00
      y( 66) =  -0.1934408303298687d+00
      y( 67) =  -0.7839517558869167d+01
      y( 68) =  -0.2992292602180288d+01
      y( 69) =  -0.2883977656734086d+01
      y( 70) =  -0.3048568278060051d+00
      y( 71) =  -0.3201970487035549d+00
      y( 72) =  -0.2207815941706669d-01
      y( 73) =   0.1225024418897568d+00
      y( 74) =  -0.3020231631441784d+00
      y( 75) =  -0.3201970487035548d+00
      y( 76) =   0.6040463262883567d+00
      y( 77) =  -0.1225235639587947d+00
      y( 78) =  -0.1445997109340232d+00
      y( 79) =  -0.3048568278060051d+00
      y( 80) =  -0.3020231631441784d+00
      y( 81) =   0.2827557455215537d-06
      y( 82) =   0.3226083665770413d-04
      y( 83) =  -0.5803201765692529d+00
      y( 84) =  -0.1934408303298687d+00
      y( 85) =   0.1349596894124011d+02
      y( 86) =  -0.5144029989944615d-61
      y( 87) =   0.2999967456407596d+01
      y( 88) =  -0.3048568278060051d+00
      y( 89) =  -0.5803201765692529d+00
      y( 90) =  -0.5144029989944615d-61
      y( 91) =   0.2999967456407596d+01
      y( 92) =  -0.3048568278060051d+00
      y( 93) =  -0.5794099530682210d+00
      y( 94) =   0.7090627069218701d-02
      y( 95) =   0.2870419659132725d+01
      y( 96) =  -0.3201954889813194d+00
      y( 97) =  -0.1934408303298687d+00
      y( 98) =  -0.4564991969572258d+01
      y( 99) =  -0.2992873132356891d+01
      y(100) =  -0.2884572066660236d+01
      y(101) =  -0.3048568278060051d+00
      y(102) =  -0.3201954889813193d+00
      y(103) =  -0.1408098389641259d+00
      y(104) =   0.1224893544588554d+00
      y(105) =  -0.2863908148025885d+00
      y(106) =  -0.3201954889813194d+00
      y(107) =   0.5727816296051769d+00
      y(108) =  -0.3578850567906977d-06
      y(109) =  -0.1408098404182732d+00
      y(110) =  -0.3048568278060051d+00
      y(111) =  -0.2863908148025885d+00
      y(112) =  -0.5030971301117276d-05
      y(113) =  -0.5741341370739308d-03
      y(114) =  -0.5803636949068757d+00
      y(115) =  -0.1934408303298687d+00
      y(116) =   0.1342161027531811d+01
      y(117) =   0.4675775943965132d+00
      y(118) =   0.2878076723218615d+01
      y(119) =  -0.3737359865057522d+00
      y(120) =  -0.5803636949068773d+00
      y(121) =   0.7474719730115046d+00
      y(122) =  -0.1224897137980597d+00
      y(123) =   0.4675903224882113d+00
      y(124) =  -0.3048568278060051d+00
      y(125) =  -0.3737359865057511d+00
      y(126) =   0.1438859667693932d-04
      y(127) =   0.1643466830238340d-02
      y(128) =  -0.5802045234551009d+00
      y(129) =  -0.1934408303298687d+00
      y(130) =   0.1115322810290722d+02
      y(131) =  -0.1786085072486350d+00
      y(132) =  -0.2245965361045817d-02
      y(133) =  -0.5675131482652329d+00
      y(134) =  -0.5802045234550925d+00
      y(135) =   0.1702539444795697d+01
      y(136) =  -0.1225024418897565d+00
      y(137) =   0.2699459271144151d+01
      y(138) =  -0.3048568278060051d+00
      y(139) =  -0.5675131482652329d+00
      y(140) =  -0.1224897137980597d+00
      y(141) =   0.2699471999235856d+01
      y(142) =  -0.3048568278060051d+00
      y(143) =  -0.5675131482652517d+00
      y(144) =   0.7090737749608171d-02
      y(145) =   0.2870570104712901d+01
      y(146) =  -0.3201770176390597d+00
      y(147) =  -0.1934408303298687d+00
      y(148) =  -0.1189155590887148d+01
      y(149) =  -0.2992881712346612d+01
      y(150) =  -0.2884714042931089d+01
      y(151) =  -0.3048568278060051d+00
      y(152) =  -0.3201770176390597d+00
      y(153) =  -0.2877042169326476d+01
      y(154) =  -0.2877046623845863d+01
      y(155) =  -0.3201777033645129d+00
      y(156) =  -0.3201770176390597d+00
      y(157) =   0.6403554067290257d+00
      y(158) =  -0.1224897137980597d+00
      y(159) =  -0.1449637037525297d-03
      y(160) =  -0.3048568278060051d+00
      y(161) =  -0.3201777033645128d+00
      y(162) =  -0.1512233366530073d+00
      y(163) =  -0.1567296590745326d-03
      y(164) =  -0.3011638803836413d+00
      y(165) =  -0.3201770176390597d+00
      y(166) =   0.6023277607672893d+00
      y(167) =  -0.1545119766856435d+00
      y(168) =  -0.1512657482779617d+00
      y(169) =  -0.3007435275083740d+00
      y(170) =  -0.3011638803836447d+00
      y(171) =   0.6014870550167479d+00
      y(172) =  -0.5144056888603891d-61
      y(173) =  -0.3199281323439955d-01
      y(174) =  -0.3048568278060051d+00
      y(175) =  -0.3007435275083740d+00
      y(176) =   0.4998987079433206d+01
      y(177) =   0.4999992063175263d+01
      y(178) =  -0.2499999831773528d+01
      y(179) =  -0.2499999999999975d+01
      y(180) =   0.4998978196639293d+01
      y(181) =  -0.8572996997335921d-61
      y(182) =   0.4998977250670116d+01
      y(183) =  -0.2499999999999991d+01
      y(184) =  -0.2499999831773528d+01
      y(185) =  -0.8572996997335921d-61
      y(186) =   0.4998977250670116d+01
      y(187) =  -0.2499999999999991d+01
      y(188) =  -0.2500000136347459d+01
      y(189) =   0.2160218554281297d+00
      y(190) =   0.4988182249480750d+01
      y(191) =  -0.2500000024216612d+01
      y(192) =  -0.2499999999999975d+01
      y(193) =   0.2042041839026698d+00
      y(194) =   0.1182577025842485d-01
      y(195) =   0.1923803845763885d+00
      y(196) =  -0.2499999999999991d+01
      y(197) =  -0.2500000024216612d+01
      y(198) =  -0.2346741744566541d+00
      y(199) =   0.2042036656465303d+00
      y(200) =  -0.2499999823257662d+01
      y(201) =  -0.2500000024216613d+01
      y(202) =  -0.2346742463623664d+00
      y(203) =  -0.5948323749230453d-06
      y(204) =  -0.2346741768742084d+00
      y(205) =  -0.2499999999999991d+01
      y(206) =  -0.2499999823257662d+01
      y(207) =   0.4999980114197910d+01
      y(208) =   0.4999999843666627d+01
      y(209) =  -0.2499999996784775d+01
      y(210) =  -0.2499999999999975d+01
      y(211) =   0.4999979939782303d+01
      y(212) =  -0.7899378970256425d-07
      y(213) =   0.4999979842706281d+01
      y(214) =  -0.2499999999999991d+01
      y(215) =  -0.2499999996784775d+01
      y(216) =  -0.8573405937400700d-61
      y(217) =   0.4999979921700072d+01
      y(218) =  -0.2499999999999991d+01
      y(219) =  -0.2500000002605499d+01
      y(220) =   0.2158597056211766d+00
      y(221) =   0.4988182207952476d+01
      y(222) =  -0.2500000000353345d+01
      y(223) =  -0.2499999999999975d+01
      y(224) =   0.2040419147264534d+00
      y(225) =   0.1181783478030806d-01
      y(226) =   0.1922241172634104d+00
      y(227) =  -0.2499999999999991d+01
      y(228) =  -0.2500000000353345d+01
      y(229) =  -0.3679693236179853d-01
      y(230) =   0.2040419158792541d+00
      y(231) =  -0.2499999772012851d+01
      y(232) =  -0.2500000000353345d+01
      y(233) =  -0.3679622453612054d-01
      y(234) =  -0.1756028654736632d-05
      y(235) =  -0.3679533432072315d-01
      y(236) =  -0.2499999999999991d+01
      y(237) =  -0.2499999772012851d+01
      y(238) =   0.2159883644910842d+00
      y(239) =   0.4988182235659396d+01
      y(240) =  -0.2500000020901020d+01
      y(241) =  -0.2499999999999975d+01
      y(242) =   0.2041706683167043d+00
      y(243) =   0.1182385967214655d-01
      y(244) =   0.1923487687491322d+00
      y(245) =  -0.2499999999999991d+01
      y(246) =  -0.2500000020901020d+01
      y(247) =  -0.3679693236177788d-01
      y(248) =   0.2041707364829278d+00
      y(249) =  -0.2499999772012851d+01
      y(250) =  -0.2500000020901019d+01
      y(251) =  -0.3679622453609997d-01
      y(252) =  -0.1756028654731466d-05
      y(253) =  -0.3679533432070254d-01
      y(254) =  -0.2499999999999991d+01
      y(255) =  -0.2499999772012850d+01
      y(256) =   0.4999946292289309d+01
      y(257) =   0.4999999589090829d+01
      y(258) =  -0.2499999989270124d+01
      y(259) =  -0.2499999999999975d+01
      y(260) =   0.4999945821029733d+01
      y(261) =  -0.8573383316572590d-61
      y(262) =   0.4999945760679328d+01
      y(263) =  -0.2499999999999991d+01
      y(264) =  -0.2499999989270124d+01
      y(265) =  -0.8573383316572590d-61
      y(266) =   0.4999945760679329d+01
      y(267) =  -0.2499999999999991d+01
      y(268) =  -0.2500000008700431d+01
      y(269) =   0.2159672042326096d+00
      y(270) =   0.4988182257671780d+01
      y(271) =  -0.2500000009368004d+01
      y(272) =  -0.2499999999999975d+01
      y(273) =   0.2041494924505785d+00
      y(274) =   0.1182393376824584d-01
      y(275) =   0.1923257099293294d+00
      y(276) =  -0.2499999999999991d+01
      y(277) =  -0.2500000009368003d+01
      y(278) =  -0.2346830649402098d+00
      y(279) =   0.2041489240980933d+00
      y(280) =  -0.2499999822769364d+01
      y(281) =  -0.2500000009368002d+01
      y(282) =  -0.2346831370442538d+00
      y(283) =  -0.5964750946511629d-06
      y(284) =  -0.2346830673637887d+00
      y(285) =  -0.2499999999999991d+01
      y(286) =  -0.2499999822769363d+01
      y(287) =   0.5000956289101704d+01
      y(288) =   0.5000007783825420d+01
      y(289) =  -0.2500000106879903d+01
      y(290) =  -0.2499999999999975d+01
      y(291) =   0.5000964674053872d+01
      y(292) =   0.9834666589775638d+00
      y(293) =   0.5000965207014408d+01
      y(294) =  -0.2500000011950726d+01
      y(295) =  -0.2500000106879903d+01
      y(296) =   0.9834666825678713d+00
      y(297) =  -0.3054618845645094d-07
      y(298) =   0.9834666965975977d+00
      y(299) =  -0.2499999999999991d+01
      y(300) =  -0.2500000011950726d+01
      y(301) =   0.4997262436706446d+01
      y(302) =   0.4999977567095746d+01
      y(303) =  -0.2499999724698131d+01
      y(304) =  -0.2499999999999975d+01
      y(305) =   0.4997238455712048d+01
      y(306) =   0.4703283828639512d+01
      y(307) =   0.4997221398452132d+01
      y(308) =  -0.2499999197373328d+01
      y(309) =  -0.2499999724698136d+01
      y(310) =   0.4703273936740555d+01
      y(311) =  -0.6816622292221013d-07
      y(312) =   0.4703269453557049d+01
      y(313) =  -0.2499999999999991d+01
      y(314) =  -0.2499999197373328d+01
      y(315) =  -0.3054618845625812d-07
      y(316) =   0.4703269491177070d+01
      y(317) =  -0.2499999999999991d+01
      y(318) =  -0.2499999197373338d+01
      y(319) =   0.2157164867589083d+00
      y(320) =   0.4988182098364394d+01
      y(321) =  -0.2500000001646564d+01
      y(322) =  -0.2499999999999975d+01
      y(323) =   0.2038985905095614d+00
      y(324) =   0.1180963378537931d-01
      y(325) =   0.1920890828112512d+00
      y(326) =  -0.2499999999999991d+01
      y(327) =  -0.2500000001646564d+01
      y(328) =   0.2039079144284985d+00
      y(329) =   0.2039004902295213d+00
      y(330) =  -0.2500000004493590d+01
      y(331) =  -0.2500000001646564d+01
      y(332) =   0.2039079021505135d+00
      y(333) =  -0.3054618845623932d-07
      y(334) =   0.2039078862776569d+00
      y(335) =  -0.2499999999999991d+01
      y(336) =  -0.2500000004493590d+01
      y(337) =  -0.4788940197110148d-01
      y(338) =   0.2038882763521206d+00
      y(339) =  -0.2499999353490320d+01
      y(340) =  -0.2500000001646564d+01
      y(341) =  -0.4789765786972171d-01
      y(342) =  -0.5331577724007001d-01
      y(343) =  -0.4790539656059958d-01
      y(344) =  -0.2499999201728321d+01
      y(345) =  -0.2499999353490320d+01
      y(346) =  -0.5331888562403928d-01
      y(347) =  -0.8573428147674035d-61
      y(348) =  -0.5332135539066590d-01
      y(349) =  -0.2499999999999991d+01
      y(350) =  -0.2499999201728321d+01
      return
      end

C-----------------------------------------------------------------------------
      SUBROUTINE FCN(N,X,Y,F,ierr)
C ---------------------------------------------------------------------------
C
C Right-hand side (static currents) of the two-bit adder
C computing the sum of two two-bit numbers and one carry-in:
C
C   A1*2+A0 + B1*2+B0 + CIN = C*2^2 + S1*2 + S0
C
C Input signals: V1  === A0_INV
C                V2  === B0_INV
C                V3  === A1_INV
C                V4  === B1_INV
C                CIN === CARRY_IN
C
C Output signals: SO === AT NODE 49
C                 S1 === AT NODE 130
C                  C  === AT NODE 148
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   N    Dimension of the system
C   X    Time-point at which FCN evaluated
C   Y    State-vector (only node potentials in reduced model)
C
C Output parameter:
C   F    Computed right-hand side
C
C External references: Currents of MOS-model due to Shichman and Hodges
C IDS      Function evaluating the drain current
C IBS, IBD Currents of pn-junction
C
C ---------------------------------------------------------------------------

      IMPLICIT NONE ! double precision (A-H,O-Z)
      integer N,ierr
      double precision X,Y,F,IDS,IBS,IBD
      DIMENSION Y(N),F(N)
      DOUBLE PRECISION CIN,CIND,V1,V1D,V2,V2D,V3,V3D,V4,V4D 
      DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
      COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
      EXTERNAL IDS, IBS, IBD

C
C --- Evaluating the input signals at time point X
C
c      print *,X,Y(176)
      CALL PULSE(X,V1,V1D,0.d0,5.d0,0.d0,5.d0,5.d0,5.d0,20.d0)
      CALL PULSE(X,V2,V2D,0.d0,5.d0,10.d0,5.d0,15.d0,5.d0,40.d0)
      CALL PULSE(X,V3,V3D,0.d0,5.d0,30.d0,5.d0,35.d0,5.d0,80.d0)
      CALL PULSE(X,V4,V4D,0.d0,5.d0,70.d0,5.d0,75.d0,5.d0,160.d0)
      CALL PULSE(X,CIN,CIND,0.d0,5.d0,150.d0,5.d0,155.d0,5.d0,320.d0)

C
C ---
C --- Right-hand side of the two-bit adder: The ten logical subcircuits
C ---
C

C
C --- NOR-gate 1: nodes 1 -- 13
C
      CALL NOR(N,1,V1,V2,V1D,V2D,Y,F,ierr)

C
C --- ANDOI-gate 1: nodes 14 -- 31
C

      CALL ANDOI(N,14,Y(5),V2,V1,0.d0,V2D,V1D,Y,F,ierr)

C
C --- NOR-gate 2: nodes 32 -- 44
C

      CALL NOR(N,32,Y(18),CIN,0.d0,CIND,Y,F,ierr)

C
C --- ANDOI-gate 2: nodes 45-- 62
C

      CALL ANDOI(N,45,Y(36),CIN,Y(18),0.d0,CIND,0.d0,Y,F,ierr)

C
C --- ANDOI-gate 3: nodes 63-- 80
C

      CALL ANDOI(N,63,Y(5),CIN,Y(18),0.d0,CIND,0.d0,Y,F,ierr)

C
C --- NOR-gate 3: nodes 81 -- 93
C

      CALL NOR(N,81,V3,V4,V3D,V4D,Y,F,ierr)

C
C --- ANDOI-gate 4: nodes 94 -- 111
C

      CALL ANDOI(N,94,Y(85),V4,V3,0.d0,V4D,V3D,Y,F,ierr)

C
C --- NAND-gate: nodes 112 -- 125
C

      CALL NAND(N,112,Y(67),Y(98),0.d0,0.d0,Y,F,ierr)

C
C --- ORANI-gate 1: nodes 126 -- 143
C

      CALL ORANI(N,126,Y(116),Y(67),Y(98),0.d0,0.d0,0.d0,Y,F,ierr)

C
C --- ANDOI-gate 5 (ANDOI-gate with capacitive coupling
C ---               of result node): nodes 144 -- 161
C

      CALL ANDOIP(N,144,Y(85),Y(5),Y(98),0.d0,0.d0,0.d0,Y,F,ierr)

C
C --- Three additional enhancement transistors in series
C --- First transistor:  Internal nodes 162 -- 165
C ---                    DRAIN = node 148 (First node of ANDOI-gate 5)
C ---                    GATE = node 98 (First node of ANDOI-gate 4)
C ---                    SOURCE = node  166
C --- Second transistor: Internal nodes 167 -- 171
C ---                    DRAIN = node 166
C ---                    GATE = node 18 (First node of ANDOI-gate 1)
C ---                    SOURCE = node 171
C --- Third transistor:  Internal nodes 172 -- 175
C ---                    DRAIN = node 171
C ---                    GATE = CIN (carry_in voltage)
C ---                    Source = MASS
C
      F(162)=-(Y(162)-Y(166))/RGS - IDS(3,Y(163)-Y(162),Y(98)-Y(162),
     *         Y(164)-Y(166),Y(98)-Y(163),Y(165)-Y(148),ierr)
      F(163)=-(Y(163)-Y(148))/RGD + IDS(3,Y(163)-Y(162),Y(98)-Y(162),
     *         Y(164)-Y(166),Y(98)-Y(163),Y(165)-Y(148),ierr)
      F(164)=-(Y(164)-VBB)/RBS +IBS(Y(164)-Y(166))
      F(165)=-(Y(165)-VBB)/RBD +IBD(Y(165)-Y(148))
      F(166)=-IBS(Y(164)-Y(166))-(Y(166)-Y(162))/RGS-
     *        IBD(Y(170)-Y(166))-(Y(166)-Y(168))/RGD
      F(167)=-(Y(167)-Y(171))/RGS-IDS(3,Y(168)-Y(167),Y(18)-Y(167),
     *         Y(169)-Y(171),Y(18)-Y(168),Y(170)-Y(166),ierr)
      F(168)=-(Y(168)-Y(166))/RGD+IDS(3,Y(168)-Y(167),Y(18)-Y(167),
     *         Y(169)-Y(171),Y(18)-Y(168),Y(170)-Y(166),ierr)
      F(169)=-(Y(169)-VBB)/RBS + IBS(Y(169)-Y(171))
      F(170)=-(Y(170)-VBB)/RBD + IBD(Y(170)-Y(166))
      F(171)=-IBS(Y(169)-Y(171))-(Y(171)-Y(167))/RGS-
     *        IBD(Y(175)-Y(171))-(Y(171)-Y(173))/RGD
      F(172)= CGS*CIND-Y(172)/RGS - IDS(3,Y(173)-Y(172),
     *        CIN-Y(172),Y(174),CIN-Y(173),Y(175)-Y(171),ierr)
      F(173)= CGD*CIND-(Y(173)-Y(171))/RGD + IDS(3,Y(173)-Y(172),
     *        CIN-Y(172),Y(174),CIN-Y(173),Y(175)-Y(171),ierr)
      F(174)=-(Y(174)-VBB)/RBS + IBS(Y(174))
      F(175)=-(Y(175)-VBB)/RBD + IBD(Y(175)-Y(171))

       if(ierr.eq.-1)return

       RETURN
       END

      SUBROUTINE PULSE(X,VIN,VIND,LOW,HIGH,DELAY,T1,T2,T3,PERIOD)
C ---------------------------------------------------------------------------
C
C Evaluating input signal at time point X
C
C Structure of input signal:
C
C                -----------------------                       HIGH
C               /                       \
C              /                         \
C             /                           \
C            /                             \
C           /                               \
C          /                                 \
C         /                                   \
C        /                                     \
C  ------                                       ---------      LOW
C
C |DELAY|   T1  |         T2           |   T3  |
C |          P     E     R     I     O     D            |
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   X                      Time-point at which input signal is evaluated
C   LOW                    Low-level of input signal
C   HIGH                   High-level of input signal
C   DELAY,T1,T2,T3, PERIOD Parameters to specify signal structure
C
C Output parameter:
C   VIN    Voltage of input signal at time point X
C   VIND   Derivative of VIN at time point X
C
C ---------------------------------------------------------------------------
      IMPLICIT NONE
      double precision X,VIN,VIND,LOW,HIGH,DELAY,T1,T2,T3,PERIOD,TIME

      TIME = DMOD(X,PERIOD)

      IF (TIME.GT.(DELAY+T1+T2+T3)) THEN
        VIN = LOW
        VIND= 0.d0
      ELSE IF (TIME.GT.(DELAY+T1+T2)) THEN
        VIN = ((HIGH-LOW)/T3)*(DELAY+T1+T2+T3-TIME) + LOW
        VIND= -((HIGH-LOW)/T3)
      ELSE IF (TIME.GT.(DELAY+T1)) THEN
        VIN = HIGH
        VIND= 0.d0
      ELSE IF (TIME.GT.DELAY) THEN
        VIN = ((HIGH-LOW)/T1)*(TIME-DELAY) + LOW
        VIND= ((HIGH-LOW)/T1)
      ELSE
        VIN = LOW
        VIND=0.d0
      END IF

      RETURN
      END

      SUBROUTINE NOR(N,I,U1,U2,U1D,U2D,Y,F,ierr)
C ---------------------------------------------------------------------------
C
C Right-hand side (static currents) of the NOR-gate:
C                   NOT (U1 OR U2)
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   N    Dimension of the system
C   I    Number of first node
C   U1   Voltage of first input signal
C   U2   Voltage of second input signal
C   U1D  Derivative of U1
C   U2D  Derivative of U2
C   Y    State-vector (only node potentials in reduced model)
C
C Output parameter:
C   F    Computed right-hand side of NOR-gate
C
C External references: Currents of MOS-model due to Shichman and Hodges
C IDS      Function evaluating the drain current
C IBS, IBD Currents of pn-junction
C
C ---------------------------------------------------------------------------

        IMPLICIT NONE ! double precision (A-H,O-Z)
        integer N,I,ierr
        
        double precision IDS,IBS,IBD,U1,U2,U1D,U2D,Y,F
        DIMENSION Y(N),F(N)
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
        COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
        EXTERNAL IDS, IBS, IBD

        F(I)=-(Y(I)-Y(I+4))/RGS-IDS(0,Y(I+1)-Y(I),Y(I+4)-Y(I),
     *        Y(I+2)-Y(I+4),Y(I+4)-Y(I+1),Y(I+3)-VDD,ierr)
        F(I+1)=-(Y(I+1)-VDD)/RGD+IDS(0,Y(I+1)-Y(I),Y(I+4)-Y(I),
     *         Y(I+2)-Y(I+4),Y(I+4)-Y(I+1),Y(I+3)-VDD,ierr)
        F(I+2)=-(Y(I+2)-VBB)/RBS + IBS(Y(I+2)-Y(I+4))
        F(I+3)=-(Y(I+3)-VBB)/RBD + IBD(Y(I+3)-VDD)
C
C --- Result node of NOR-gate: Node I+4
C
        F(I+4)=-(Y(I+4)-Y(I))/RGS-IBS(Y(I+2)-Y(I+4))-
     *         (Y(I+4)-Y(I+6))/RGD-IBD(Y(I+8)-Y(I+4))-
     *         (Y(I+4)-Y(I+10))/RGD-IBD(Y(I+12)-Y(I+4))
        F(I+5)=CGS*U1D-Y(I+5)/RGS-IDS(1,Y(I+6)-Y(I+5),
     *         U1-Y(I+5),Y(I+7),U1-Y(I+6),Y(I+8)-Y(I+4),ierr)
        F(I+6)=CGD*U1D-(Y(I+6)-Y(I+4))/RGD+IDS(1,Y(I+6)-Y(I+5),
     *         U1-Y(I+5),Y(I+7),U1-Y(I+6),Y(I+8)-Y(I+4),ierr)
        F(I+7)=-(Y(I+7)-VBB)/RBS + IBS(Y(I+7))
        F(I+8)=-(Y(I+8)-VBB)/RBD + IBD(Y(I+8)-Y(I+4))
        F(I+9)=CGS*U2D-Y(I+9)/RGS-IDS(1,Y(I+10)-Y(I+9),
     *         U2-Y(I+9),Y(I+11),U2-Y(I+10),Y(I+12)-Y(I+4),ierr)
        F(I+10)=CGD*U2D-(Y(I+10)-Y(I+4))/RGD+IDS(1,Y(I+10)-Y(I+9),
     *          U2-Y(I+9),Y(I+11),U2-Y(I+10),Y(I+12)-Y(I+4),ierr)
        F(I+11)=-(Y(I+11)-VBB)/RBS + IBS(Y(I+11))
        F(I+12)=-(Y(I+12)-VBB)/RBD + IBD(Y(I+12)-Y(I+4))

        if(ierr.eq.-1)return

        RETURN
        END

      SUBROUTINE ANDOIP(N,I,U1,U2,U3,U1D,U2D,U3D,Y,F,ierr)
C ---------------------------------------------------------------------------
C
C Right-hand side (static currents) of the ANDOI-gate with capacitive
C coupling at result node (used for two-bit adder)
C                   NOT ( U1 OR ( U2 AND U3) )
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   N    Dimension of the system
C   I    Number of first node
C   U1   Voltage of first input signal
C   U2   Voltage of second input signal
C   U3   Voltage of third input signal
C   U1D  Derivative of U1
C   U2D  Derivative of U2
C   U3D  Derivative of U3
C   Y    State-vector (only node potentials in reduced model)
C
C Output parameter:
C   F    Computed right-hand side of ANDOI-gate
C
C External references: Currents of MOS-model due to Shichman and Hodges
C IDS      Function evaluating the drain current
C IBS, IBD Currents of pn-junction
C
C ---------------------------------------------------------------------------

        IMPLICIT NONE ! double precision (A-H,O-Z)
        integer N,I,ierr
        double precision IDS,IBS,IBD,U1,U2,U3,U1D,U2D,U3D,Y,F
        DIMENSION Y(N),F(N)
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

        COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
        EXTERNAL IDS, IBS, IBD

        F(I)=-(Y(I)-Y(I+4))/RGS-IDS(0,Y(I+1)-Y(I),Y(I+4)-Y(I),
     *       Y(I+2)-Y(I+4),Y(I+4)-Y(I+1),Y(I+3)-VDD,ierr)
        F(I+1)=-(Y(I+1)-VDD)/RGD+IDS(0,Y(I+1)-Y(I),Y(I+4)-Y(I),
     *         Y(I+2)-Y(I+4),Y(I+4)-Y(I+1),Y(I+3)-VDD,ierr)
        F(I+2)=-(Y(I+2)-VBB)/RBS + IBS(Y(I+2)-Y(I+4))
        F(I+3)=-(Y(I+3)-VBB)/RBD + IBD(Y(I+3)-VDD)
C
C --- Result node of ANDOI-gate: Node I+4
C
        F(I+4)=-(Y(I+4)-Y(I))/RGS-IBS(Y(I+2)-Y(I+4))-
     *         (Y(I+4)-Y(I+6))/RGD-IBD(Y(I+8)-Y(I+4))-
     *         (Y(I+4)-Y(I+10))/RGD-IBD(Y(I+12)-Y(I+4))-
     *         (Y(I+4)-Y(163))/RGD-IBD(Y(165)-Y(I+4))
        F(I+5)=CGS*U1D-Y(I+5)/RGS-IDS(1,Y(I+6)-Y(I+5),U1-Y(I+5),
     *         Y(I+7),U1-Y(I+6),Y(I+8)-Y(I+4),ierr)
        F(I+6)=CGD*U1D-(Y(I+6)-Y(I+4))/RGD+IDS(1,Y(I+6)-Y(I+5),
     *         U1-Y(I+5),Y(I+7),U1-Y(I+6),Y(I+8)-Y(I+4),ierr)
        F(I+7)=-(Y(I+7)-VBB)/RBS + IBS(Y(I+7))
        F(I+8)=-(Y(I+8)-VBB)/RBD + IBD(Y(I+8)-Y(I+4))
        F(I+9)=CGS*U2D-(Y(I+9)-Y(I+13))/RGS-IDS(2,Y(I+10)-Y(I+9),
     *         U2-Y(I+9),Y(I+11)-Y(I+13),U2-Y(I+10),Y(I+12)-Y(I+4),ierr)
        F(I+10)=CGD*U2D-(Y(I+10)-Y(I+4))/RGD+IDS(2,Y(I+10)-Y(I+9),
     *         U2-Y(I+9),Y(I+11)-Y(I+13),U2-Y(I+10),Y(I+12)-Y(I+4),ierr)
        F(I+11)=-(Y(I+11)-VBB)/RBS + IBS(Y(I+11)-Y(I+13))
        F(I+12)=-(Y(I+12)-VBB)/RBD + IBD(Y(I+12)-Y(I+4))
C
C --- Coupling node of ANDOI-gate: Node I+13
C
        F(I+13)=-(Y(I+13)-Y(I+9))/RGS-IBS(Y(I+11)-Y(I+13))-
     *           (Y(I+13)-Y(I+15))/RGD-IBD(Y(I+17)-Y(I+13))
        F(I+14)=CGS*U3D-Y(I+14)/RGS-IDS(2,Y(I+15)-Y(I+14),
     *          U3-Y(I+14),Y(I+16),U3-Y(I+15),Y(I+17)-Y(I+13),ierr)
        F(I+15)=CGD*U3D-(Y(I+15)-Y(I+13))/RGD+IDS(2,Y(I+15)-Y(I+14),
     *          U3-Y(I+14),Y(I+16),U3-Y(I+15),Y(I+17)-Y(I+13),ierr)
        F(I+16)=-(Y(I+16)-VBB)/RBS+IBS(Y(I+16))
        F(I+17)=-(Y(I+17)-VBB)/RBD+IBD(Y(I+17)-Y(I+13))

        if(ierr.eq.-1)return

        RETURN
        END

       SUBROUTINE ANDOI(N,I,U1,U2,U3,U1D,U2D,U3D,Y,F,ierr)
C ---------------------------------------------------------------------------
C
C Right-hand side (static currents) of the ANDOI-gate
C                   NOT ( U1 OR ( U2 AND U3) )
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   N    Dimension of the system
C   I    Number of first node
C   U1   Voltage of first input signal
C   U2   Voltage of second input signal
C   U3   Voltage of third input signal
C   U1D  Derivative of U1
C   U2D  Derivative of U2
C   U3D  Derivative of U3
C   Y    State-vector (only node potentials in reduced model)
C
C Output parameter:
C   F    Computed right-hand side of ANDOI-gate
C
C External references: Currents of MOS-model due to Shichman and Hodges
C IDS      Function evaluating the drain current
C IBS, IBD Currents of pn-junction
C
C ---------------------------------------------------------------------------

        IMPLICIT NONE !double precision (A-H,O-Z)
        double precision IDS,IBS,IBD,U1,U2,U3,U1D,U2D,U3D,Y,F
        integer N,I,ierr
        DIMENSION Y(N),F(N)
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

        COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
        EXTERNAL IDS, IBS, IBD

        F(I)=-(Y(I)-Y(I+4))/RGS-IDS(0,Y(I+1)-Y(I),Y(I+4)-Y(I),
     *       Y(I+2)-Y(I+4),Y(I+4)-Y(I+1),Y(I+3)-VDD,ierr)
        F(I+1)=-(Y(I+1)-VDD)/RGD+IDS(0,Y(I+1)-Y(I),Y(I+4)-Y(I),
     *         Y(I+2)-Y(I+4),Y(I+4)-Y(I+1),Y(I+3)-VDD,ierr)
        F(I+2)=-(Y(I+2)-VBB)/RBS + IBS(Y(I+2)-Y(I+4))
        F(I+3)=-(Y(I+3)-VBB)/RBD + IBD(Y(I+3)-VDD)
C
C --- Result node of ANDOI-gate: Node I+4
C
        F(I+4)=-(Y(I+4)-Y(I))/RGS-IBS(Y(I+2)-Y(I+4))-
     *         (Y(I+4)-Y(I+6))/RGD-IBD(Y(I+8)-Y(I+4))-
     *         (Y(I+4)-Y(I+10))/RGD-IBD(Y(I+12)-Y(I+4))
        F(I+5)=CGS*U1D-Y(I+5)/RGS-IDS(1,Y(I+6)-Y(I+5),U1-Y(I+5),
     *         Y(I+7),U1-Y(I+6),Y(I+8)-Y(I+4),ierr)
        F(I+6)=CGD*U1D-(Y(I+6)-Y(I+4))/RGD+IDS(1,Y(I+6)-Y(I+5),
     *         U1-Y(I+5),Y(I+7),U1-Y(I+6),Y(I+8)-Y(I+4),ierr)
        F(I+7)=-(Y(I+7)-VBB)/RBS + IBS(Y(I+7))
        F(I+8)=-(Y(I+8)-VBB)/RBD + IBD(Y(I+8)-Y(I+4))
        F(I+9)=CGS*U2D-(Y(I+9)-Y(I+13))/RGS-IDS(2,Y(I+10)-Y(I+9),
     *         U2-Y(I+9),Y(I+11)-Y(I+13),U2-Y(I+10),Y(I+12)-Y(I+4),ierr)
        F(I+10)=CGD*U2D-(Y(I+10)-Y(I+4))/RGD+IDS(2,Y(I+10)-Y(I+9),
     *         U2-Y(I+9),Y(I+11)-Y(I+13),U2-Y(I+10),Y(I+12)-Y(I+4),ierr)
        F(I+11)=-(Y(I+11)-VBB)/RBS + IBS(Y(I+11)-Y(I+13))
        F(I+12)=-(Y(I+12)-VBB)/RBD + IBD(Y(I+12)-Y(I+4))
C
C --- Coupling node of ANDOI-gate: Node I+13
C
        F(I+13)=-(Y(I+13)-Y(I+9))/RGS-IBS(Y(I+11)-Y(I+13))-
     *           (Y(I+13)-Y(I+15))/RGD-IBD(Y(I+17)-Y(I+13))
        F(I+14)=CGS*U3D-Y(I+14)/RGS-IDS(2,Y(I+15)-Y(I+14),
     *          U3-Y(I+14),Y(I+16),U3-Y(I+15),Y(I+17)-Y(I+13),ierr)
        F(I+15)=CGD*U3D-(Y(I+15)-Y(I+13))/RGD+IDS(2,Y(I+15)-Y(I+14),
     *          U3-Y(I+14),Y(I+16),U3-Y(I+15),Y(I+17)-Y(I+13),ierr)
        F(I+16)=-(Y(I+16)-VBB)/RBS+IBS(Y(I+16))
        F(I+17)=-(Y(I+17)-VBB)/RBD+IBD(Y(I+17)-Y(I+13))

        if(ierr.eq.-1)return

        RETURN
        END

      SUBROUTINE NAND(N,I,U1,U2,U1D,U2D,Y,F,ierr)
C ---------------------------------------------------------------------------
C
C Right-hand side (static currents) of the NAND-gate:
C                   NOT (U1 AND U2)
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   N    Dimension of the system
C   I    Number of first node
C   U1   Voltage of first input signal
C   U2   Voltage of second input signal
C   U1D  Derivative of U1
C   U2D  Derivative of U2
C   Y    State-vector (only node potentials in reduced model)
C
C Output parameter:
C   F    Computed right-hand side of NAND-gate
C
C External references: Currents of MOS-model due to Shichman and Hodges
C IDS      Function evaluating the drain current
C IBS, IBD Currents of pn-junction
C
C ---------------------------------------------------------------------------

        IMPLICIT NONE !double precision (A-H,O-Z)
        double precision IDS,IBS,IBD,U1,U2,U1D,U2D,Y,F
        integer N,I,ierr
        DIMENSION Y(N),F(N)
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

        COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
        EXTERNAL IDS, IBS, IBD

        F(I)=-(Y(I)-Y(I+4))/RGS-IDS(0,Y(I+1)-Y(I),Y(I+4)-Y(I),
     *        Y(I+2)-Y(I+4),Y(I+4)-Y(I+1),Y(I+3)-VDD,ierr)
        F(I+1)=-(Y(I+1)-VDD)/RGD+IDS(0,Y(I+1)-Y(I),Y(I+4)-Y(I),
     *         Y(I+2)-Y(I+4),Y(I+4)-Y(I+1),Y(I+3)-VDD,ierr)
        F(I+2)=-(Y(I+2)-VBB)/RBS + IBS(Y(I+2)-Y(I+4))
        F(I+3)=-(Y(I+3)-VBB)/RBD + IBD(Y(I+3)-VDD)
C
C --- Result node of NAND-gate: Node I+4
C
        F(I+4)=-(Y(I+4)-Y(I))/RGS-IBS(Y(I+2)-Y(I+4))-
     *         (Y(I+4)-Y(I+6))/RGD-IBD(Y(I+8)-Y(I+4))
        F(I+5)=CGS*U1D-(Y(I+5)-Y(I+9))/RGS-IDS(2,Y(I+6)-Y(I+5),
     *         U1-Y(I+5),Y(I+7)-Y(I+9),U1-Y(I+6),Y(I+8)-Y(I+4),ierr)
        F(I+6)=CGD*U1D-(Y(I+6)-Y(I+4))/RGD+IDS(2,Y(I+6)-Y(I+5),
     *         U1-Y(I+5),Y(I+7)-Y(I+9),U1-Y(I+6),Y(I+8)-Y(I+4),ierr)
        F(I+7)=-(Y(I+7)-VBB)/RBS + IBS(Y(I+7)-Y(I+9))
        F(I+8)=-(Y(I+8)-VBB)/RBD + IBD(Y(I+8)-Y(I+4))
C
C --- Coupling node of NAND-gate: Node I+9
C
        F(I+9)=-(Y(I+9)-Y(I+5))/RGS-IBS(Y(I+7)-Y(I+9))-
     *         (Y(I+9)-Y(I+11))/RGD-IBD(Y(I+13)-Y(I+9))
        F(I+10)=CGS*U2D-Y(I+10)/RGS-IDS(2,Y(I+11)-Y(I+10),
     *          U2-Y(I+10),Y(I+12),U2-Y(I+11),Y(I+13)-Y(I+9),ierr)
        F(I+11)=CGD*U2D-(Y(I+11)-Y(I+9))/RGD+IDS(2,Y(I+11)-Y(I+10),
     *          U2-Y(I+10),Y(I+12),U2-Y(I+11),Y(I+13)-Y(I+9),ierr)
        F(I+12)=-(Y(I+12)-VBB)/RBS + IBS(Y(I+12))
        F(I+13)=-(Y(I+13)-VBB)/RBD + IBD(Y(I+13)-Y(I+9))

        if(ierr.eq.-1)return

        RETURN
        END

      SUBROUTINE ORANI(N,I,U1,U2,U3,U1D,U2D,U3D,Y,F,ierr)
C ---------------------------------------------------------------------------
C
C Right-hand side (static currents) of the ORANI-gate
C                   NOT ( U1 AND ( U2 OR U3) )
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   N    Dimension of the system
C   I    Number of first node
C   U1   Voltage of first input signal
C   U2   Voltage of second input signal
C   U3   Voltage of third input signal
C   U1D  Derivative of U1
C   U2D  Derivative of U2
C   U3D  Derivative of U3
C   Y    State-vector (only node potentials in reduced model)
C
C Output parameter:
C   F    Computed right-hand side of ORANI-gate
C
C External references: Currents of MOS-model due to Shichman and Hodges
C IDS      Function evaluating the drain current
C IBS, IBD Currents of pn-junction
C
C ---------------------------------------------------------------------------

        IMPLICIT NONE !double precision (A-H,O-Z)
        double precision IDS,IBS,IBD,U1,U2,U3,U1D,U2D,U3D,Y,F
        integer N,I,ierr
        DIMENSION Y(N),F(N)
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

        COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
        EXTERNAL IDS, IBS, IBD

        F(I)=-(Y(I)-Y(I+4))/RGS-IDS(0,Y(I+1)-Y(I),Y(I+4)-Y(I),
     *       Y(I+2)-Y(I+4),Y(I+4)-Y(I+1),Y(I+3)-VDD,ierr)
        F(I+1)=-(Y(I+1)-VDD)/RGD+IDS(0,Y(I+1)-Y(I),Y(I+4)-Y(I),
     *         Y(I+2)-Y(I+4),Y(I+4)-Y(I+1),Y(I+3)-VDD,ierr)
        F(I+2)=-(Y(I+2)-VBB)/RBS + IBS(Y(I+2)-Y(I+4))
        F(I+3)=-(Y(I+3)-VBB)/RBD + IBD(Y(I+3)-VDD)
C
C --- Result node of ORANI-gate: Node I+4
C
        F(I+4)=-(Y(I+4)-Y(I))/RGS-IBS(Y(I+2)-Y(I+4))-
     *         (Y(I+4)-Y(I+6))/RGD-IBD(Y(I+8)-Y(I+4))
        F(I+5)=CGS*U1D-(Y(I+5)-Y(I+9))/RGS-
     *         IDS(2,Y(I+6)-Y(I+5),U1-Y(I+5),Y(I+7)-Y(I+9),
     *         U1-Y(I+6),Y(I+8)-Y(I+4),ierr)
        F(I+6)=CGD*U1D-(Y(I+6)-Y(I+4))/RGD+IDS(2,Y(I+6)-Y(I+5),
     *         U1-Y(I+5),Y(I+7)-Y(I+9),U1-Y(I+6),Y(I+8)-Y(I+4),ierr)
        F(I+7)=-(Y(I+7)-VBB)/RBS + IBS(Y(I+7)-Y(I+9))
        F(I+8)=-(Y(I+8)-VBB)/RBD + IBD(Y(I+8)-Y(I+4))
C
C --- Coupling node of ORANI-gate: Node I+9
C
        F(I+9)=-(Y(I+9)-Y(I+5))/RGS-IBS(Y(I+7)-Y(I+9))-
     *         (Y(I+9)-Y(I+11))/RGD-IBD(Y(I+13)-Y(I+9))-
     *         (Y(I+9)-Y(I+15))/RGD-IBD(Y(I+17)-Y(I+9))
        F(I+10)=CGS*U2D-Y(I+10)/RGS-IDS(2,Y(I+11)-Y(I+10),
     *          U2-Y(I+10),Y(I+12),U2-Y(I+11),Y(I+13)-Y(I+9),ierr)
         F(I+11)=CGD*U2D-(Y(I+11)-Y(I+9))/RGD+IDS(2,Y(I+11)-Y(I+10),
     *          U2-Y(I+10),Y(I+12),U2-Y(I+11),Y(I+13)-Y(I+9),ierr)
        F(I+12)=-(Y(I+12)-VBB)/RBS + IBS(Y(I+12))
        F(I+13)=-(Y(I+13)-VBB)/RBD + IBD(Y(I+13)-Y(I+9))
        F(I+14)=CGS*U3D-Y(I+14)/RGS-IDS(2,Y(I+15)-Y(I+14),U3-Y(I+14),
     *          Y(I+16),U3-Y(I+15),Y(I+17)-Y(I+9),ierr)
        F(I+15)=CGD*U3D-(Y(I+15)-Y(I+9))/RGD+
     *        IDS(2,Y(I+15)-Y(I+14),U3-Y(I+14),Y(I+16),U3-Y(I+15),
     *        Y(I+17)-Y(I+9),ierr)
        F(I+16)=-(Y(I+16)-VBB)/RBS + IBS(Y(I+16))
        F(I+17)=-(Y(I+17)-VBB)/RBD + IBD(Y(I+17)-Y(I+9))

        if(ierr.eq.-1)return

        RETURN
        END

        SUBROUTINE GCN(N,U,G)
C ---------------------------------------------------------------------------
C
C Charge-function of two-bit adder
C computing the sum of two two-bit numbers and one carry-in:
C
C   A1*2+A0 + B1*2+B0 + CIN = C*2^2 + S1*2 + S0
C
C Input signals: V1  === A0_INV
C                V2  === B0_INV
C                V3  === A1_INV
C                V4  === B1_INV
C                CIN === CARRY_IN
C
C Output signals: SO === AT NODE 49
C                 S1 === AT NODE 130
C                  C  === AT NODE 148
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   N    Dimension of the system
C   U    State-vector (only node potentials in reduced model)
C
C Output parameter:
C   G    Computed charge function (only function of node potentials!)
C
C External reference:
C   CBDBS Function evaluating the voltage-dependent bulk-capacitance
C         in the MOS-model due to Shichman and Hodges
C
C ---------------------------------------------------------------------------

        IMPLICIT NONE ! double precision (A-H,O-Z)
        integer N,I
        DOUBLE PRECISION U, G, CBDBS
        DIMENSION U(N),G(N)
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

        COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

        EXTERNAL CBDBS

        DO 10 I=1,N
            G(I)=0.d0
 10     CONTINUE

C
C ---
C --- Charge-function of the two-bit adder: The ten logical subcircuits
C ---
C

C
C --- NOR-gate 1: nodes 1 -- 13
C
        CALL DNOR(N,U,1,G)

C
C --- ANDOI-gate 1: nodes 14 -- 31
C
        CALL DANDOI(N,U,14,G)

C
C --- NOR-gate 2: nodes 32 -- 44
C
        CALL DNOR(N,U,32,G)

C
C --- ANDOI-gate 2: nodes 45-- 62
C
        CALL DANDOI(N,U,45,G)

C
C --- ANDOI-gate 3: nodes 63-- 80
C
        CALL DANDOI(N,U,63,G)

C
C --- NOR-gate 3: nodes 81 -- 93
C
        CALL DNOR(N,U,81,G)

C
C --- ANDOI-gate 4: nodes 94 -- 111
C
        CALL DANDOI(N,U,94,G)
C
C --- NAND-gate: nodes 112 -- 125
C
        CALL DNAND(N,U,112,G)

C
C --- ORANI-gate 1: nodes 126 -- 143
C
        CALL DORANI(N,U,126,G)

C
C --- ANDOI-gate 5 (ANDOI-gate with capacitive coupling
C ---               of result node): nodes 144 -- 161
C
        CALL DANDOI(N,U,144,G)

C
C --- Capacitive coupling result node nor-gate 1
C
        G(5)=G(5)+CGS*(U(5)-U(19))+CGD*(U(5)-U(20))+
     *           CGS*(U(5)-U(68))+CGD*(U(5)-U(69))+
     *           CGS*(U(5)-U(153))+CGD*(U(5)-U(154))
        G(19)=G(19)-CGS*U(5)
        G(20)=G(20)-CGD*U(5)
        G(68)=G(68)-CGS*U(5)
        G(69)=G(69)-CGD*U(5)
        G(153)=G(153)-CGS*U(5)
        G(154)=G(154)-CGD*U(5)

C
C --- Capacitive coupling result node andoi-gate 1
C
        G(18)=G(18)+CGS*(U(18)-U(37))+CGD*(U(18)-U(38))+
     *             CGS*(U(18)-U(59))+CGD*(U(18)-U(60))+
     *             CGS*(U(18)-U(77))+CGD*(U(18)-U(78))+
     *             CGS*(U(18)-U(167))+CGD*(U(18)-U(168))
        G(37)=G(37)-CGS*U(18)
        G(38)=G(38)-CGD*U(18)
        G(59)=G(59)-CGS*U(18)
        G(60)=G(60)-CGD*U(18)
        G(77)=G(77)-CGS*U(18)
        G(78)=G(78)-CGD*U(18)

C
C --- Capacitive coupling result node nor-gate 2
C
        G(36)=G(36)+CGS*(U(36)-U(50))+CGD*(U(36)-U(51))
        G(50)=G(50)-CGS*U(36)
        G(51)=G(51)-CGD*U(36)

C
C --- Capacitive coupling result node andoi-gate 2 === s0
C
        G(49)=G(49)+COUT*U(49)

C
C --- Capacitive coupling result node andoi-gate 3
C
        G(67)=G(67)+CGS*(U(67)-U(117))+CGD*(U(67)-U(118))+
     *              CGS*(U(67)-U(136))+CGD*(U(67)-U(137))
        G(117)=G(117)-CGS*U(67)
        G(118)=G(118)-CGD*U(67)
        G(136)=G(136)-CGS*U(67)
        G(137)=G(137)-CGD*U(67)

C
C --- Capacitive coupling result node nor-gate 3
C
        G(85)=G(85)+CGS*(U(85)-U(99))+CGD*(U(85)-U(100))+
     *             CGS*(U(85)-U(149))+CGD*(U(85)-U(150))
        G(99)=G(99)-CGS*U(85)
        G(100)=G(100)-CGD*U(85)
        G(149)=G(149)-CGS*U(85)
        G(150)=G(150)-CGD*U(85)

C
C --- Capacitive coupling result node andoi-gate 4
C
        G(98)=G(98)+CGS*(U(98)-U(122))+CGD*(U(98)-U(123))+
     *              CGS*(U(98)-U(140))+CGD*(U(98)-U(141))+
     *              CGS*(U(98)-U(158))+CGD*(U(98)-U(159))+
     *              CGS*(U(98)-U(162))+CGD*(U(98)-U(163))
        G(122)=G(122)-CGS*U(98)
        G(123)=G(123)-CGD*U(98)
        G(140)=G(140)-CGS*U(98)
        G(141)=G(141)-CGD*U(98)
        G(158)=G(158)-CGS*U(98)
        G(159)=G(159)-CGD*U(98)

C
C --- Capacitive coupling result nand-gate
C
        G(116)=G(116)+CGS*(U(116)-U(131))+CGD*(U(116)-U(132))
        G(131)=G(131)-CGS*U(116)
        G(132)=G(132)-CGD*U(116)

C
C --- Capacitive coupling result node orani-gate === s1
C
        G(130)=G(130)+COUT*U(130)

C
C --- Capacitive coupling result andoi-gate 5 === Cinvers
C
        G(148)=G(148)+CBDBS(U(165)-U(148))*(U(148)-U(165))+COUT*U(148)

C
C --- Charge-function of three additional transistors
C
        G(162)=G(162)+CGS*(U(162)-U(98))
        G(163)=G(163)+CGD*(U(163)-U(98))
        G(164)=G(164)+CBDBS(U(164)-U(166))*(U(164)-U(166))
        G(165)=G(165)+CBDBS(U(165)-U(148))*(U(165)-U(148))
        G(166)=G(166)+CBDBS(U(164)-U(166))*(U(166)-U(164))+
     *                CBDBS(U(170)-U(166))*(U(166)-U(170))+
     *                CLOAD*U(166)
        G(167)=G(167)+CGS*(U(167)-U(18))
        G(168)=G(168)+CGD*(U(168)-U(18))
        G(169)=G(169)+CBDBS(U(169)-U(171))*(U(169)-U(171))
        G(170)=G(170)+CBDBS(U(170)-U(166))*(U(170)-U(166))
        G(171)=G(171)+CBDBS(U(169)-U(171))*(U(171)-U(169))+
     *                CBDBS(U(175)-U(171))*(U(171)-U(175))+
     *                CLOAD*U(171)
        G(172)=G(172)+CGS*U(172)
        G(173)=G(173)+CGD*U(173)
        G(174)=G(174)+CBDBS(U(174))*U(174)
        G(175)=G(175)+CBDBS(U(175)-U(171))*(U(175)-U(171))

        RETURN
        END

        SUBROUTINE DNOR(N,U,I,G)
C ---------------------------------------------------------------------------
C
C Charge-function of the NOR-gate:   NOT (U1 OR U2)
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   N    Dimension of the system
C   U    State-vector (only node potentials in reduced model)
C   I    Number of first node
C
C Output parameter:
C   G    Computed charge-function of theNOR-gate
C External reference:
C   CBDBS Function evaluating the voltage-dependent bulk-capacitance
C         in the MOS-model due to Shichman and Hodges
C
C ---------------------------------------------------------------------------

        IMPLICIT NONE !double precision (A-H,O-Z)
        integer N,I
        DOUBLE PRECISION U(N),G(N),CBDBS
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
        COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

        EXTERNAL CBDBS

        G(I)=G(I)+CGS*(U(I)-U(I+4))
        G(I+1)=G(I+1)+CGD*(U(I+1)-U(I+4))
        G(I+2)=G(I+2)+CBDBS(U(I+2)-U(I+4))*(U(I+2)-U(I+4))
        G(I+3)=G(I+3)+CBDBS(U(I+3)-VDD)*U(I+3)
        G(I+4)=G(I+4)+CGS*(U(I+4)-U(I))+CGD*(U(I+4)-U(I+1))
     *               + CBDBS(U(I+2)-U(I+4))*(U(I+4)-U(I+2))
     *               + CBDBS(U(I+8)-U(I+4))*(U(I+4)-U(I+8))
     *               + CBDBS(U(I+12)-U(I+4))*(U(I+4)-U(I+12))
     *               + CLOAD*U(I+4)
        G(I+5)=G(I+5)+CGS*U(I+5)
        G(I+6)=G(I+6)+CGD*U(I+6)
        G(I+7)=G(I+7)+CBDBS(U(I+7))*U(I+7)
        G(I+8)=G(I+8)+CBDBS(U(I+8)-U(I+4))*(U(I+8)-U(I+4))
        G(I+9)=G(I+9)+CGS*U(I+9)
        G(I+10)=G(I+10)+CGD*U(I+10)
        G(I+11)=G(I+11)+CBDBS(U(I+11))*U(I+11)
        G(I+12)=G(I+12)+CBDBS(U(I+12)-U(I+4))*(U(I+12)-U(I+14))

        RETURN
        END

        SUBROUTINE DANDOI(N,U,I,G)
C ---------------------------------------------------------------------------
C
C Charge-function of the ANDOI-gate:  NOT ( U1 OR ( U2 AND U3) )
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   N    Dimension of the system
C   U    State-vector (only node potentials in reduced model)
C   I    Number of first node
C
C Output parameter:
C   G    Computed charge-function of the ANDOI-gate
C External reference:
C   CBDBS Function evaluating the voltage-dependent bulk-capacitance
C         in the MOS-model due to Shichman and Hodges
C
C ---------------------------------------------------------------------------

        IMPLICIT NONE ! double precision (A-H,O-Z)
        integer N,I
        DOUBLE PRECISION U(N),G(N),CBDBS
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
        COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

        EXTERNAL CBDBS

        G(I)=G(I)+CGS*(U(I)-U(I+4))
        G(I+1)=G(I+1)+CGD*(U(I+1)-U(I+4))
        G(I+2)=G(I+2)+CBDBS(U(I+2)-U(I+4))*(U(I+2)-U(I+4))
        G(I+3)=G(I+3)+CBDBS(U(I+3)-VDD)*U(I+3)
        G(I+4)=G(I+4)+CGS*(U(I+4)-U(I))+CGD*(U(I+4)-U(I+1))
     *               + CBDBS(U(I+2)-U(I+4))*(U(I+4)-U(I+2))
     *               + CBDBS(U(I+8)-U(I+4))*(U(I+4)-U(I+8))
     *               + CBDBS(U(I+12)-U(I+4))*(U(I+4)-U(I+12))
     *               + CLOAD*U(I+4)
        G(I+5)=G(I+5)+CGS*U(I+5)
        G(I+6)=G(I+6)+CGD*U(I+6)
        G(I+7)=G(I+7)+CBDBS(U(I+7))*U(I+7)
        G(I+8)=G(I+8)+CBDBS(U(I+8)-U(I+4))*(U(I+8)-U(I+4))
        G(I+9)=G(I+9)+CGS*U(I+9)
        G(I+10)=G(I+10)+CGD*U(I+10)
        G(I+11)=G(I+11)+CBDBS(U(I+11)-U(I+13))*(U(I+11)-U(I+13))
        G(I+12)=G(I+12)+CBDBS(U(I+12)-U(I+4))*(U(I+12)-U(I+4))
        G(I+13)=G(I+13)+CBDBS(U(I+11)-U(I+13))*(U(I+13)-U(I+11))
     *                 +CBDBS(U(I+17)-U(I+13))*(U(I+13)-U(I+17))
     *                 +CLOAD*U(I+13)
        G(I+14)=G(I+14)+CGS*U(I+14)
        G(I+15)=G(I+15)+CGD*U(I+15)
        G(I+16)=G(I+16)+CBDBS(U(I+16))*U(I+16)
        G(I+17)=G(I+17)+CBDBS(U(I+17)-U(I+13))*(U(I+17)-U(I+13))

        RETURN
        END

        SUBROUTINE DNAND(N,U,I,G)
C ---------------------------------------------------------------------------
C
C Charge-function of the NAND-gate:  NOT (U1 AND U2)
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   N    Dimension of the system
C   U    State-vector (only node potentials in reduced model)
C   I    Number of first node
C
C Output parameter:
C   G    Computed charge-function of the NAND-gate
C External reference:
C   CBDBS Function evaluating the voltage-dependent bulk-capacitance
C         in the MOS-model due to Shichman and Hodges
C
C ---------------------------------------------------------------------------

        IMPLICIT NONE ! double precision (A-H,O-Z)
        integer N,I
        DOUBLE PRECISION U(N),G(N),CBDBS
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
        COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

        EXTERNAL CBDBS

        G(I)=G(I)+CGS*(U(I)-U(I+4))
        G(I+1)=G(I+1)+CGD*(U(I+1)-U(I+4))
        G(I+2)=G(I+2)+CBDBS(U(I+2)-U(I+4))*(U(I+2)-U(I+4))
        G(I+3)=G(I+3)+CBDBS(U(I+3)-VDD)*U(I+3)
        G(I+4)=G(I+4)+CGS*(U(I+4)-U(I))+CGD*(U(I+4)-U(I+1))
     *               + CBDBS(U(I+2)-U(I+4))*(U(I+4)-U(I+2))
     *               + CBDBS(U(I+8)-U(I+4))*(U(I+4)-U(I+8))
     *               + CLOAD*U(I+4)
        G(I+5)=G(I+5)+CGS*U(I+5)
        G(I+6)=G(I+6)+CGD*U(I+6)
        G(I+7)=G(I+7)+CBDBS(U(I+7)-U(I+9))*(U(I+7)-U(I+9))
        G(I+8)=G(I+8)+CBDBS(U(I+8)-U(I+4))*(U(I+8)-U(I+4))
        G(I+9)=G(I+9)+CBDBS(U(I+7)-U(I+9))*(U(I+9)-U(I+7))
     *               +CBDBS(U(I+13)-U(I+9))*(U(I+9)-U(I+13))
     *               +CLOAD*U(I+9)
        G(I+10)=G(I+10)+CGS*U(I+10)
        G(I+11)=G(I+11)+CGD*U(I+11)
        G(I+12)=G(I+12)+CBDBS(U(I+12))*U(I+12)
        G(I+13)=G(I+13)+CBDBS(U(I+13)-U(I+9))*(U(I+13)-U(I+9))

        RETURN
        END

        SUBROUTINE DORANI(N,U,I,G)
C ---------------------------------------------------------------------------
C
C Charge-function of the ORANI-gate:  NOT ( U1 AND ( U2 OR U3) )
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   N    Dimension of the system
C   U    State-vector (only node potentials in reduced model)
C   I    Number of first node
C
C Output parameter:
C   G    Computed charge-function of the ORANI-gate
C External reference:
C   CBDBS Function evaluating the voltage-dependent bulk-capacitance
C         in the MOS-model due to Shichman and Hodges
C
C ---------------------------------------------------------------------------

        IMPLICIT NONE !cdouble precision (A-H,O-Z)
        integer N,I
        DOUBLE PRECISION U(N),G(N),CBDBS
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
        COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

        EXTERNAL CBDBS

        G(I)=G(I)+CGS*(U(I)-U(I+4))
        G(I+1)=G(I+1)+CGD*(U(I+1)-U(I+4))
        G(I+2)=G(I+2)+CBDBS(U(I+2)-U(I+4))*(U(I+2)-U(I+4))
        G(I+3)=G(I+3)+CBDBS(U(I+3)-VDD)*U(I+3)
        G(I+4)=G(I+4)+CGS*(U(I+4)-U(I))+CGD*(U(I+4)-U(I+1))
     *               + CBDBS(U(I+2)-U(I+4))*(U(I+4)-U(I+2))
     *               + CBDBS(U(I+8)-U(I+4))*(U(I+4)-U(I+8))
     *               + CLOAD*U(I+4)
        G(I+5)=G(I+5)+CGS*U(I+5)
        G(I+6)=G(I+6)+CGD*U(I+6)
        G(I+7)=G(I+7)+CBDBS(U(I+7)-U(I+9))*(U(I+7)-U(I+9))
        G(I+8)=G(I+8)+CBDBS(U(I+8)-U(I+4))*(U(I+8)-U(I+4))
        G(I+9)=G(I+9)+CBDBS(U(I+7)-U(I+9))*(U(I+9)-U(I+7)) +
     *                 CBDBS(U(I+13)-U(I+9))*(U(I+9)-U(I+13)) +
     *                 CBDBS(U(I+17)-U(I+9))*(U(I+9)-U(I+17))+
     *                 CLOAD*U(I+9)
        G(I+10)=G(I+10)+CGS*U(I+10)
        G(I+11)=G(I+11)+CGD*U(I+11)
        G(I+12)=G(I+12)+CBDBS(U(I+12))*U(I+12)
        G(I+13)=G(I+13)+CBDBS(U(I+13)-U(I+9))*(U(I+13)-U(I+9))
        G(I+14)=G(I+14)+CGS*U(I+14)
        G(I+15)=G(I+15)+CGD*U(I+15)
        G(I+16)=G(I+16)+CBDBS(U(I+16))*U(I+16)
        G(I+17)=G(I+17)+CBDBS(U(I+17)-U(I+9))*(U(I+17)-U(I+9))

        RETURN
        END

      double precision FUNCTION IDS (NED,VDS, VGS, VBS, VGD, VBD, ierr)
C ---------------------------------------------------------------------------
C
C Function evaluating the drain-current due to the model of
C Shichman and Hodges
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   NED  Integer parameter for MOSFET-type
C   VDS  Voltage between drain and source
C   VGS  Voltage between gate and source
C   VGD  Voltage between gate and drain
C   VBD  Voltage between bulk and drain
C   I    Number of first node
C
C External reference:
C   GDSP, GDSM Drain function for VDS > 0 resp. VDS < 0
C
C ---------------------------------------------------------------------------

      IMPLICIT NONE ! double precision (A-H,O-Z)
      integer NED,ierr
      DOUBLE PRECISION VDS, VGS, VBS, VGD, VBD,GDSP,GDSM
      EXTERNAL GDSP, GDSM

      IF ( VDS .GT. 0.d0 ) THEN
         IDS = GDSP (NED,VDS, VGS, VBS,ierr)
      ELSE IF ( VDS .EQ. 0.d0) THEN
         IDS = 0.d0
      ELSE IF ( VDS .LT. 0.d0) THE N
         IDS = GDSM (NED,VDS, VGD, VBD,ierr)
      END IF

      if(ierr.eq.-1)return

      RETURN
      END

      double precision FUNCTION GDSP (NED,VDS, VGS, VBS,ierr)
      IMPLICIT NONE ! double precision (A-H,O-Z)
      DOUBLE PRECISION VDS, VGS, VBS, BETA, CGAMMA,PHI,VT0,VTE
      integer NED,ierr
      CHARACTER(LEN=80) MSG
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

      COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
C

      IF(NED.EQ.0) THEN
C --- Depletion-type
        VT0=-2.43d0
        CGAMMA=.2d0
        PHI=1.28d0
        BETA=53.5D-6*CTIME*STIFF
      ELSE IF (NED.EQ.1) THEN
C --- Enhancement-type
        VT0=.2d0
        CGAMMA=0.035d0
        PHI=1.01d0
        BETA=4*43.7D-6*CTIME*STIFF
      ELSE IF (NED.EQ.2) THEN
C --- Two enhancement-type transistors in series
        VT0=.2d0
        CGAMMA=0.035d0
        PHI=1.01d0
        BETA=8*43.7D-6*CTIME*STIFF
      ELSE
C --- Three enhancement-type transistors in series
        VT0=.2d0
        CGAMMA=0.035d0
        PHI=1.01d0
        BETA=12*43.7D-6*CTIME*STIFF
      END IF

      if(phi-vbs.lt.0d0.or.phi.lt.0d0)then
         ierr=-1
         WRITE(MSG, *)"Error due to Phi, vbs", phi, vbs
         call rwarn(MSG)
C         call rexit("Run aborted")
         return
      end if

      VTE = VT0 + CGAMMA * ( DSQRT(PHI-VBS) - DSQRT(PHI) )

      IF ( VGS-VTE .LE. 0.d0) THEN
         GDSP = 0.d0
      ELSE IF ( 0.d0 .LT. VGS-VTE .AND. VGS-VTE .LE. VDS ) THEN
         GDSP = - BETA * (VGS - VTE)**2.d0 * (1.d0 + DELTA*VDS)
      ELSE IF ( 0.d0 .LT. VDS .AND. VDS .LT. VGS-VTE ) THEN
         GDSP = - BETA * VDS * (2.d0*(VGS - VTE) - VDS) *
     *          (1.d0 + DELTA*VDS)
      END IF

      RETURN
      END

      double precision FUNCTION GDSM (NED,VDS, VGD, VBD, ierr)
      IMPLICIT NONE ! double precision (A-H,O-Z)
      DOUBLE PRECISION VDS,VGD,VBD,BETA,CGAMMA,PHI,VT0,VTE
      integer NED,ierr
      CHARACTER(LEN=80) MSG

        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
      COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

      IF(NED.EQ.0) THEN
C --- Depletion-type
        VT0=-2.43d0
        CGAMMA=.2d0
        PHI=1.28d0
        BETA=53.5D-6*CTIME*STIFF
      ELSE IF (NED.EQ.1) THEN
C --- Enhancement-type
        VT0=.2d0
        CGAMMA=0.035d0
        PHI=1.01d0
        BETA=4*43.7D-6*CTIME*STIFF
      ELSE IF (NED.EQ.2) THEN
C --- Two enhancement-type transistors in series
        VT0=.2d0
        CGAMMA=0.035d0
        PHI=1.01d0
        BETA=8*43.7D-6*CTIME*STIFF
      ELSE
C --- Three enhancement-type transistors in series
        VT0=.2d0
        CGAMMA=0.035d0
        PHI=1.01d0
        BETA=12*43.7D-6*CTIME*STIFF
      END IF

      if(phi-vbd.lt.0d0.or.phi.lt.0d0)then
         ierr=-1
         WRITE(MSG, *)"Error due to Phi, vbd", phi, vbd
         call rwarn(MSG)
C         call rexit("Run aborted")
         return
      end if

      VTE = VT0 + CGAMMA * ( DSQRT(PHI-VBD) - DSQRT(PHI) )

      IF ( VGD-VTE .LE. 0.d0) THEN
         GDSM = 0.d0
      ELSE IF ( 0.d0 .LT. VGD-VTE .AND. VGD-VTE .LE. -VDS ) THEN
         GDSM = BETA * (VGD - VTE)*(VGD - VTE) * (1.d0 - DELTA*VDS)
      ELSE IF ( 0.d0 .LT. -VDS .AND. -VDS .LT. VGD-VTE ) THEN
         GDSM = - BETA * VDS * (2.0d0*(VGD - VTE) + VDS) *
     *          (1.d0 - DELTA*VDS)
      END IF

      RETURN
      END

      double precision FUNCTION IBS (VBS)
C ---------------------------------------------------------------------------
C
C Function evaluating the current of the pn-junction between bulk and
C source due to the model of Shichman and Hodges
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   VBS  Voltage between bulk and source
C
C ---------------------------------------------------------------------------

      IMPLICIT NONE ! double precision (A-H,O-Z)
      DOUBLE PRECISION VBS
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
      COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

C

C
C     IBS = GBS (VBS)
C
      IF ( VBS .LE. 0.d0 ) THEN
         IBS = - CURIS * ( DEXP( VBS/VTH ) - 1.d0 )
C         IBS = - CURIS * ( DEXP(MAX(8., VBS/VTH )) - 1.d0 )
      ELSE
         IBS = 0.d0
      END IF

      RETURN
      END

      double precision FUNCTION IBD (VBD)
C ---------------------------------------------------------------------------
C
C Function evaluating the current of the pn-junction between bulk and
C drain  due to the model of Shichman and Hodges
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   VBD  Voltage between bulk and drain
C
C ---------------------------------------------------------------------------

      IMPLICIT NONE ! double precision (A-H,O-Z)
      DOUBLE PRECISION VBD
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
      COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

C

C
C     IBD = GBD (VBD)
C
      IF ( VBD .LE. 0.d0 ) THEN
         IBD = - CURIS * ( DEXP( VBD/VTH ) - 1.d0 )
      ELSE
         IBD = 0.d0
      END IF
      RETURN
      END

      double precision FUNCTION CBDBS (V)
C ---------------------------------------------------------------------------
C
C Function evaluating the voltage-dependent capacitance between bulk and
C drain resp. source  due to the model of Shichman and Hodges
C
C ---------------------------------------------------------------------------
C
C The input parameters are:
C   V    Voltage between bulk and drain resp. source
C
C ---------------------------------------------------------------------------

      IMPLICIT NONE ! double precision (A-H,O-Z)
      DOUBLE PRECISION V,PHIB
        DOUBLE PRECISION RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT
      COMMON /CONST/ RGS, RGD, RBS, RBD, CGS, CGD, CBD, CBS,
     *               DELTA, CTIME, STIFF,
     *               CURIS, VTH, VDD, VBB, CLOAD, COUT

      PHIB=0.87d0

      IF ( V .LE. 0.d0 ) THEN
         CBDBS = CBD/DSQRT(1.d0-V/PHIB)
      ELSE
         CBDBS = CBD*(1.d0+V/(2.d0*PHIB))
      END IF


      RETURN
      END
C-----------------------------------------------------------------------------
