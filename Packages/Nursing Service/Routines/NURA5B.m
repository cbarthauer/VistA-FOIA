NURA5B ;HIRMFO/PC,RM,JH,MD,FT-INDIVIDUAL SALARY REPORTS ;5/7/96  10:57
 ;;4.0;NURSING SERVICE;;Apr 25, 1997
 Q:'$D(^DIC(213.9,1,"OFF"))  Q:$P(^DIC(213.9,1,"OFF"),"^",1)=1
 W !
 S (NUROUT,NURQUEUE)=0
 D EN1^NURSAUTL G QUIT:NUROUT
 S DIC("S")="I +$$EN6^NURSUT3($G(Y))"
 D EN3^NURSAGP1 G QUIT:NUROUT
 W ! S ZTRTN="START^NURA5B" D EN7^NURSUT0 G:POP!($D(ZTSK)) QUIT
START ;
 K ^TMP($J)
 U IO S (NURPAGE,NURSW1,NUROUT)=0 D HEADER,PRINT
QUIT K ^TMP($J) D CLOSE^NURSUT1,^NURAKILL
 Q
 ; DETAIL LINE PRINT ROUTINE
PRINT I $D(^NURSF(210,N1,0)) D WRITE Q
 E  W !?5," NO RECORD FOUND FOR THIS EMPLOYEE " Q
WRITE I ($Y>(IOSL-6)) D HEADER Q:NUROUT
 S NURSW1=1
 W:N2'="" !,$E($P(^VA(200,N2,0),"^",1),1,20)
 I $D(^NURSF(210,N1,7)) S NDATA=^(7) I $D(^NURSF(211.1,+NDATA,0)) S NDATA(1)=^(0) W:$P(NDATA(1),"^")'="" ?40,$P(NDATA(1),"^")
 S DA=N1,NURSAL=+$$EN12^NURSUT0(DA) W:+$G(NURSAL) ?61,$J(NURSAL,6,2)
 Q
HEADER I 'NURQUEUE,$E(IOST)="C",NURSW1 D ENDPG^NURSUT1 Q:NUROUT
 S NURPAGE=NURPAGE+1 W:$E(IOST)="C"!(NURPAGE>1) @IOF
 W !!,"NURSING SERVICE STAFF SALARIES" S X="T" D ^%DT D:+Y D^DIQ W ?44,Y,?59,"PAGE: ",NURPAGE
 W !!,?40,"GRADE/STEP",?61,"GRADE/STEP" W !,"NAME",?40,"CODE",?61,"SALARY" W !,$$REPEAT^XLFSTR("-",80)
 W ! Q
