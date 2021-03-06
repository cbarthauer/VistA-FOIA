GMVCAQU ;HOIFO/YH,FT-DISPLAY CATEGORY/QUALIFIER/SYNONYM TABLE FOR VITAL TYPE ;10/25/02  10:04
 ;;5.0;GEN. MED. REC. - VITALS;;Oct 31, 2002
 ;
 ; This routine uses the following IAs:
 ; #10103 - ^XLFDT calls           (supported)
 ; #10104 - ^XLFSTR calls          (supported)
 ;
EN1(RESULTS,GMVDATA) ; GMV QUALIFIER TABLE [RPC entry point]
 ; Display Vitals Category/Qualifier/Synonym Table
 ; GMVDEV - device name (File 3.5)
 ; GMVIEN - device internal entry number
 ; GMVPDT - date/time to print report
 ;
 N GMVDEV,GMVIEN,GMVPDT
 S RESULTS=$NA(^TMP($J)) K @RESULTS
 S GMVDEV=$P(GMVDATA,U,5),GMVIEN=+$P(GMVDATA,U,6),GMVPDT=$P(GMVDATA,U,7)
 S ZTIO=GMVDEV ;device
 S ZTDTH=$S($G(GMVPDT)>0:GMVPDT,1:$$NOW^XLFDT()) ;date/time to print
 S ZTDESC="Vitals Category/Qualifier/Synonym Table"
 S ZTRTN="START^GMVCAQU"
 D ^%ZTLOAD
 I $G(ZTSK)>0 S @RESULTS@(0)="1^Report Queued. Task #:"_ZTSK
 E  S @RESULTS@(0)="-1^Unable to queue report."
 K ZTSK,ZTIO,ZTDTH,ZTSAVE,ZTDESC,ZTRTN
 Q
START ; Start the report
 U IO
 S:$D(ZTQUEUED) ZTREQ="@"
 S (GMROUT,GMRPG)=0
 S GMVNOW=$$NOW^XLFDT() ;get current date/time
 S GMVNOW=$$FMTE^XLFDT(GMVNOW) ;format current date/time
 D HDR
 F GMRVIT(1)="BLOOD PRESSURE","PULSE","RESPIRATION","TEMPERATURE","WEIGHT","CIRCUMFERENCE/GIRTH","HEIGHT","PULSE OXIMETRY" Q:GMROUT  D
 .S GMRVIT=$O(^GMRD(120.51,"B",GMRVIT(1),0)) Q:GMRVIT'>0!GMROUT  D
 ..S GMRVITY=$P(^GMRD(120.51,GMRVIT,0),"^",2) Q:GMRVITY=""!GMROUT  S GLVL=8 D LISTQ^GMVQUAL Q:GMROUT  D OTHERQ D CLEAR
 ..Q
 .Q
Q1 ; Kill variables and quit
 K GMRVIT,GMRVITY,GLVL,GMROUT,GMRPG,GSYNO,I,J,POP
 D CLEAR
 D ^%ZISC
 Q
HDR ; Header
 W:$Y>0 @IOF
 S GMRPG=GMRPG+1
 W !,"Vitals/Measurements Category/Qualifier/Synonym Table",?65,"Page ",GMRPG
 W !,"Run Date: ",GMVNOW
 W !,$$RJ^XLFSTR(" ",75,"-")
 W:GMRPG>1 !,GLABEL,!,GLABEL(1)
 Q
CLEAR ; Clean up variables
 K GCHART,GCHART1,GQUAL,GMRVDFLT,GORDER,GLABEL,GFLAG,GMAX,GMIN,GMRLAST,GMRINF,GCAT,GCHA,GCOL,GDA,GENTR,GTXT,GBLNK,GCOUNT,GLN,GMRENTR,GMRVODR,GSIDE,GTYPE,GDASH
 Q
OTHERQ ;
 Q:'$D(GCHART)&('$D(GCHART1))
 S GCOL=1,GFLAG=0,$P(GLABEL," ",80)="",$P(GBLNK," ",80)="",$P(GLABEL(1)," ",80)="",$P(GDASH,"-",20)=""
 S (GMAX,GMAX(1))=0
 F  S GMAX(1)=$O(GCOUNT(GMAX(1))) Q:GMAX(1)'>0  S GMAX(2)="" F  S GMAX(2)=$O(GCOUNT(GMAX(1),GMAX(2))) Q:GMAX(2)=""  I GCOUNT(GMAX(1),GMAX(2))>GMAX S GMAX=GCOUNT(GMAX(1),GMAX(2))
 Q:+$G(GMAX)=0
 F I=1:1:GMAX S $P(GTXT(I)," ",80)=""
 S GMRVODR=0
 F  S GMRVODR=$O(GCOUNT(GMRVODR)) Q:GMRVODR'>0  S GCAT=$O(GCOUNT(GMRVODR,"")) Q:GCAT=""  D
 . S GCOL=$S(GMRVODR=1:1,GMRVODR=2:18,GMRVODR=3:39,GMRVODR=4:58,1:70)
 . I GMRVODR=2,GMRVIT(1)="PULSE" S GCOL=28
 . I GMRVODR=2,GMRVIT(1)="RESPIRATION" S GCOL=32
 . S GLABEL=$S(GMRVODR=1:$E(GCAT_GBLNK,1,80),1:$E($E(GLABEL,1,GCOL)_GCAT_GBLNK,1,80))
 . S GCAT(1)=$E(GDASH,1,$L(GCAT))
 . S GLABEL(1)=$S(GMRVODR=1:$E(GCAT(1)_GBLNK,1,80),1:$E($E(GLABEL(1),1,GCOL)_GCAT(1)_GBLNK,1,80))
 . S I=0,GCHA="" F  S GCHA=$O(GQUAL(GMRVODR,GCHA)) Q:GCHA=""  D
 . . S GSYNO(1)=$O(^GMRD(120.52,"B",GCHA,0)) Q:GSYNO(1)'>0  S GSYNO=$P($G(^GMRD(120.52,GSYNO(1),0)),"^",2)
 . . S I=I+1,GTXT(I)=$S(GMRVODR=1:$E(GCHA_": "_GSYNO_GBLNK,1,80),1:$E($E(GTXT(I),1,GCOL)_GCHA_": "_GSYNO_GBLNK,1,80))
 . . Q
 . Q
 W !!,"Qualifiers for "_GMRVIT(1)_": ",!!,GLABEL,!,GLABEL(1)
 F I=1:1:GMAX D:IOSL<($Y+6) HDR Q:GMROUT  W !,GTXT(I)
 Q
