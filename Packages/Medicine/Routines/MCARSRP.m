MCARSRP ;WISC/TJK,RMP-CATH SURGICAL RISK REPORT ;5/10/96  14:36
 ;;2.3;Medicine;;09/13/1996
LOOK S DIC="^MCAR(694.5,",DIC(0)="AEZMQ",DIC("A")="Select Patient:" D ^DIC G EXIT:Y<0 S MCARGDA=+Y
DEV K IO("Q") S %ZIS="MQ" D ^%ZIS G EXIT:POP
 I $D(IO("Q")) S ZTRTN="PRINT^MCARSRP",ZTSAVE("MCARGDA")="",ZTDESC="SURGICAL RISK ANALYSIS REPORT" D ^%ZTLOAD K ZTSK G EXIT
 U IO
PRINT K DXS,DIOT(2),^UTILITY($J),MCOUT S PG=0,D0=MCARGDA
 S ^UTILITY($J,1)="S MCY="""" I $Y>(IOSL-3) R:$E(IOST,1,2)=""C-"" !!,""Press RETURN to continue"",MCY:DTIME S:'$T MCY=U S:MCY=U DN=0,MCOUT=1 D:DN HEAD^MCARSRP K MCY"
 S Y0=^MCAR(694.5,D0,0),DFN=$P(Y0,U,2),MCARHOS=$P(Y0,U,3) K Y0 I $D(^(10)) S MCARGDT=$P(^(10),U),MCARGDT=$E(MCARGDT,4,5)_"/"_$E(MCARGDT,6,7)_"/"_$E(MCARGDT,2,3) K Y0
 I MCARHOS,$D(^DIC(4,MCARHOS,99)) S MCARHOS=$P(^(99),U)
 ; ------------------------
 ; SSN = Enternal Format of the patients SSN.
 ; ------------------------
 D DEM^VADPT S MCARGNM=VADM(1),SSN=$P(VADM(2),U,2) D KVAR^VADPT
 ; ^MCAROS0 below was ^MCAROS; changed to eliminate possibility
 ;   of overwrite of compiled routine ^MCAROS1 that shares subnamespace
 D HEAD,^MCAROS0 K DXS G EXIT:$D(MCOUT) D ^MCAROS1 K DXS G EXIT:$D(MCOUT) D ^MCAROS2
 K DXS G EXIT:$D(MCOUT) D ^MCAROS3
EXIT I IOST'?1"P-".E,'$D(MCOUT) R !!,"PRESS RETURN TO CONTINUE",X:DTIME
 S:$D(ZTQUEUED) ZTREQ="@" K ZTSK,^UTILITY($J),IO("Q"),MCARGDA,MCARGDT,SSN
 K MCARGNM,X,DFN,SSN,MCARHOS,DN,D0,FLDS,M1,M2,M3,M4,II,IJ,PC,ND,MCARLC
 K DIOEND,DIOBEG,DI,DICS,DJ,BY,A,DICSS,MCOUT
 K DIEDT,DIQ,DIWF,DIPZ,DIL,DXS,DALL,DSC,DCL,DPP,DPQ,DIC,DU,DQI,DY,S,DC
 K DL,DV,DE,DA,DK,Y,R,C,D,I,J,Q,M,P,N,D1,DIW,DIWL,DIWR,DIWT,PG,Z,L,VA
 W:IOST?1"P-".E @IOF D ^%ZISC Q
HEAD S PG=PG+1 W @IOF,!!,?25,"CARDIAC SURGERY RISK ASSESSMENT",?72,"Pg ",PG
 W !,?2,"PATIENT NAME:  ",MCARGNM,?45,"HOSPITAL: ",MCARHOS,!,?2,"SSN: ",SSN,?45,"DATE OF SURGERY: ",$S($D(MCARGDT):MCARGDT,1:"NONE ENTERED")
 W ! Q
