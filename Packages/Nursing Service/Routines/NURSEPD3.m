NURSEPD3   ;HIRMFO/MD-INCOMPLETE NURS M I REPORT (BY CLASS) PART 1 OF 2 ;8/19/97
 ;;4.0;NURSING SERVICE;**3,10**;Apr 25, 1997
 I $O(^TMP("NURE",$J,"SORT1",""))="" S NURFAC=$S($G(NURFAC)=0:$G(NURFAC(1)),1:""),NURPROG=$S($G(NURPROG)=0:$G(NURPROG(1)),1:"") D  Q
 .D HDR Q:NUROUT
 .I 'NONE W !,"NO DEFICIENCIES FOUND FOR THIS TIME PERIOD." Q
 .I NONE S NPWARD=$G(NWRD) D EN6^NURSAUTL W !,"Unit : "_$S($G(NPWARD)="":" ",1:NPWARD),!!,"NO GROUPS/CLASSES ARE ASSIGNED TO NURSING PERSONNEL",! Q
 S NURFAC=""
 F  S NURFAC=$O(^TMP("NURE",$J,"SORT1",NURFAC)) Q:NURFAC=""  S NURPROG="" F  S NURPROG=$O(^TMP("NURE",$J,"SORT1",NURFAC,NURPROG)) Q:NURPROG=""  S NURSPEC="" F  S NURSPEC=$O(^TMP("NURE",$J,"SORT1",NURFAC,NURPROG,NURSPEC)) Q:NURSPEC=""!(NUROUT)  D
 .D HDR Q:NUROUT  S TMP=$G(^TMP("NURE",$J,"%",NURFAC,NURPROG,NURSPEC)),COMPLIAN=""
 .S TOT=$P(TMP,U),DEF=$P(TMP,U,2)
 .S COMPLIAN=$S(TOT:100-(100*DEF/TOT),1:"")
 .I 'NURSW1!($Y>(IOSL-5)) D HDR W ! Q:NUROUT
 .D SUBHDR
 .S NURSPEC(1)="" F  S NURSPEC(1)=$O(^TMP("NURE",$J,"SORT1",NURFAC,NURPROG,NURSPEC,NURSPEC(1))) Q:NURSPEC(1)=""!(NUROUT)  S HOLD=1 D  S HOLD=1
 ..S CLASSNUM=+$G(^TMP("NURE",$J,"SORT1",NURFAC,NURPROG,NURSPEC,NURSPEC(1))) Q:CLASSNUM'>0
 ..S NAM=""  F  S NAM=$O(^TMP("NURE",$J,"SORT2",CLASSNUM,NAM)) Q:NAM=""!(NUROUT)  S HOLD2=1 D  W ! S HOLD2=1
 ...S CLASSTXT="" F  S CLASSTXT=$O(^TMP("NURE",$J,"SORT2",CLASSNUM,NAM,CLASSTXT)) Q:CLASSTXT=""!(NUROUT)  D
 ....I ($Y>(IOSL-5))!'(NURSW1) D HDR,SUBHDR W ! Q:NUROUT
 ....I HOLD S NSCT(1)=$$CAT^NURSUT2(NURSPEC(1)) S HOLD=0
 ....W:NAM'="  BLANK"&HOLD2=1 $S(NURS132:NAM,1:$E(NAM,1,25))_"  "_$S(NSCT(1)="  BLANK":" ",1:NSCT(1)) S HOLD2=0
 ....S DROPDEAD=$G(^TMP("NURE",$J,"SORT2",CLASSNUM,NAM,CLASSTXT))
 ....W:$G(DROPDEAD)>0 ?$S(NURS132:50,1:35),$$FMTE^XLFDT(DROPDEAD,2)
 ....W:CLASSTXT'="  BLANK" ?$S(NURS132:79,1:47),$S(NURS132:CLASSTXT,1:$E(CLASSTXT,1,33)),! S NURSW1=1
 ....Q
 ...Q
 ..Q
 .Q
 Q
HDR ; PRINT REPORT HEADER
 I NURSW1,$E(IOST)="C" D ENDPG^NURSUT1 Q:NUROUT
 S COUNT=COUNT+1,(NURSW1,HOLD,HOLD2)=1,NSW2=0
 W:$E(IOST)="C"!(COUNT>1) @IOF
 I NURMDSW,$G(NURFAC)'="" W !?$$CNTR^NURSUT2(NURFAC),$$FACL^NURSUT2(NURFAC)
 W !,"MANDATORY DEFICIENCY REPORT BY "_$S($G(NURSEL(1))=2:"SVC. CATEGORY",1:"UNIT")_" FOR "_$S(TYP="C":"CY ",TYP="F":"FY ",1:" ")
 W $S(TYP="C"!(TYP="F"):$G(NYR),1:$G(YRST(1))_" - "_$G(YREND(1)))
 W ?$S(NURS132:101,1:58)," ",$$FMTE^XLFDT(DT,2),?$S(NURS132:121,1:71),"PAGE: ",COUNT
 W !!,?$S(NURS132:50,1:35),"ANNIVERSARY"
 W !,"EMPLOYEE NAME",?$S(NURS132:50,1:35),"DATE",?$S(NURS132:79,1:47),"CLASS"
 W !,$$REPEAT^XLFSTR("_",$S(NURS132:132,1:80))
PROD I $G(NURPLSW),$G(NURPROG)'="" N Z S Z=$$PROD^NURSUT2(NURPROG) W !,?$$CNTR^NURSUT2(Z),Z,!,?$$CNTR^NURSUT2(NURPROG),$$REPEAT^XLFSTR("-",$L(Z)+1)
 Q
SUBHDR ;
 Q:NUROUT
 W !,$S($G(NURSEL(1))=2:"Service Category: ",1:"Unit: ")_$S(NURSPEC="  BLANK":" ",1:NURSPEC)
 ; %Compliance = 100% -( ( # of deficient persons on the unit/
 ;                         # of persons on the unit ) * 100%)
 W ?40,"% Compliance: ",$J(COMPLIAN,3,0) I COMPLIAN=100,$G(NSPC)]"" W ?$X+3,NSPC
 W !!
 Q