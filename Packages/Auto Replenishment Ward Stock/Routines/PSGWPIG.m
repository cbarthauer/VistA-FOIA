PSGWPIG ;BHAM ISC/CML-Print AOU Inventory Group List ; 19 Mar 93 / 8:33 AM
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 D NOW^%DTC S PSGWDT=$P(%,".")
 W !!!,"This report shows data stored for AOU Inventory Groups.",!!,"Right margin for this report is 80 columns.",!,"You may queue the report to print at a later time.",!!
 I '$O(^PSI(58.2,0)) W !,"You MUST create Inventory Groups before running this report!" K %,%I,%H Q
DEV K %ZIS,IOP S %ZIS="QM",%ZIS("B")="" D ^%ZIS I POP W !,"NO DEVICE SELECTED OR REPORT PRINTED!" G QUIT
 I $D(IO("Q")) K IO("Q") S PSGWIO=ION,ZTIO="" K ZTSAVE,ZTDTH,ZTSK S ZTRTN="ENQ^PSGWPIG",ZTDESC="Compile Data for AOU Inventory Groups",ZTSAVE("PSGWIO")="",ZTSAVE("PSGWDT")=""
 I  D ^%ZTLOAD,HOME^%ZIS K ZTSK G QUIT
 U IO
 ;
ENQ ;ENTRY POINT WHEN QUEUED
INVG K ^TMP("PSGWPIG",$J) F INVG=0:0 S INVG=$O(^PSI(58.2,INVG)) G:('INVG)&($D(ZTQUEUED)) PRTQUE G:'INVG PRINT D BUILD
 ;
BUILD ;BUILD DATA ELEMENTS
 I $S('$D(^PSI(58.2,INVG,0)):1,^(0)="":1,'$O(^(0)):1,1:0) S DIK="^PSI(58.2,",DA=INVG D ^DIK K DIK Q
 F AOU=0:0 S AOU=$O(^PSI(58.2,INVG,1,AOU)) Q:'AOU  I $D(^(AOU,0)) F TYPE=0:0 S TYPE=$O(^PSI(58.2,INVG,1,AOU,1,TYPE)) Q:'TYPE  I $D(^(TYPE,0)) D SETGL
 Q
SETGL ;
 S ANM=$S($D(^PSI(58.1,AOU,0)):$P(^(0),"^"),1:"AOU NAME MISSING"),TYPENM=$S($D(^PSI(58.16,TYPE,0)):$P(^(0),"^"),1:"TYPE NAME MISSING"),GNM=^PSI(58.2,INVG,0),INACT=""
 I $D(^PSI(58.1,AOU,"I")),^("I")]"",^("I")'>DT S INACT="I"
 S ^TMP("PSGWPIG",$J,GNM,ANM_"^"_INACT,TYPENM)=""
 Q
 ;
PRTQUE ;AFTER DATA IS COMPILED, QUEUE THE PRINT
 K ZTSAVE,ZTIO S ZTIO=PSGWIO,ZTRTN="PRINT^PSGWPIG",ZTDESC="Print Data for Inventory Group List",ZTDTH=$H,ZTSAVE("^TMP(""PSGWPIG"",$J,")=""
 D ^%ZTLOAD K ^TMP("PSGWPIG",$J) G QUIT
PRINT ;
 S $P(LN,"-",80)="",PG=0,%DT="",(GNM,ANM,TYPENM,QFLG)="",X="T" D ^%DT X ^DD("DD") S HDT=Y D HDR
 I '$D(^TMP("PSGWPIG",$J)) W !?17,"***** NO DATA AVAILABLE FOR THIS REPORT *****" G QUIT
 F LL=0:0 S GNM=$O(^TMP("PSGWPIG",$J,GNM)) Q:GNM=""!(QFLG)  D:$Y+4>IOSL PRTCHK Q:QFLG  W !!,"=> ",GNM F LL=0:0 S ANM=$O(^TMP("PSGWPIG",$J,GNM,ANM)) Q:ANM=""!(QFLG)  D:$Y+4>IOSL PRTCHK Q:QFLG  W !?13,$P(ANM,"^") D WRTDATA Q:QFLG
DONE I $E(IOST)'="C" W @IOF
 I $E(IOST)="C" D:'QFLG SS^PSGWUTL1
QUIT ;
 K %DT,AOU,ANM,HDT,INACT,INVG,GNM,LL,LN,PG,PSGWDT,TYPE,TYPENM,X,Y,PSGWIO,ZTSK,ZTIO,DA,IO("Q"),%,%I,%H,ANS,QFLG
 K ^TMP("PSGWPIG",$J) D ^%ZISC
 S:$D(ZTQUEUED) ZTREQ="@" Q
WRTDATA ;DATA LINES
 I $P(ANM,"^",2)="I" W "          *** INACTIVE ***"
 F LL=0:0 S TYPENM=$O(^TMP("PSGWPIG",$J,GNM,ANM,TYPENM)) Q:TYPENM=""!(QFLG)  D:$Y+4>IOSL PRTCHK Q:QFLG  W !?18,TYPENM
 Q
HDR ;HEADER
 W:$Y @IOF S PG=PG+1 W !?28,"AOU INVENTORY GROUP LIST",?71,"PAGE: ",PG,!?31,"PRINTED: ",HDT,!!,"=> INVENTORY GROUP",!?13,"AREA OF USE",!?18,"TYPE",!,LN
 Q
PRTCHK ;
 I $E(IOST)="C" W !!,"Press <RETURN> to Continue or ""^"" to Exit: " R ANS:DTIME S:'$T ANS="^" D:ANS?1."?" HELP^PSGWUTL1 I ANS="^" S QFLG=1 Q
 D HDR Q
