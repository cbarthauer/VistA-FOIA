PRCPRAL1 ;WISC/RFJ/DST-automatic level setter (print report)            ;28 Dec 93
 ;;5.1;IFCAP;**98**;Oct 20, 2000;Build 37
 ;Per VHA Directive 2004-038, this routine should not be modified.
 Q
 ;
 ;
PRINT ;  print report
 N %,AVERAGE,DATE,DESCR,GROUP,GROUPNM,ITEMDA,ITEMDATA,NOW,NSN,PAGE,PRCPFLAG,PRCPFNOT,PRCPNESL,PRCPNNSL,PRCPNORP,PRCPNSRP,PRCPSTDD,SCREEN,SORT,TOTAL,Y
 N ODI  ; On-Demand Item flag
 K ^TMP($J,"PRCPRALS")
 S ITEMDA=0 F  S ITEMDA=$O(^PRCP(445,PRCP("I"),1,ITEMDA)) Q:'ITEMDA  D
 .   I $G(PRCPFITM),'$D(^TMP($J,"PRCPURS4",ITEMDA)),'$G(PRCPALLI) Q
 .   S ITEMDATA=$G(^PRCP(445,PRCP("I"),1,ITEMDA,0))
 .   S GROUP=+$P(ITEMDATA,"^",21)
 .   S PRCPFLAG=0
 .   I '$G(PRCPFITM) D  Q:PRCPFLAG
 .   .   I 'GROUP,'$G(GROUPALL) S PRCPFLAG=1 Q
 .   .   I $G(GROUPALL),$D(^TMP($J,"PRCPURS1","NO",GROUP)) S PRCPFLAG=1 Q
 .   .   I '$G(GROUPALL),'$D(^TMP($J,"PRCPURS1","YES",GROUP)) S PRCPFLAG=1 Q
 .   S GROUPNM=$$GROUPNM^PRCPEGRP(GROUP)
 .   I GROUPNM'="" S GROUPNM=$E(GROUPNM,1,20)_" (#"_GROUP_")"
 .   S:GROUPNM="" GROUPNM=" "
 .   S SORT=$S(PRCP("DPTYPE")="W":$$NSN^PRCPUX1(ITEMDA),1:$E($$DESCR^PRCPUX1(PRCP("I"),ITEMDA),1,15)) S:SORT="" SORT=" "
 .   ;  calc daily usage
 .   S DATE=PRCPSTDT-1,TOTAL=0 F  S DATE=$O(^PRCP(445,PRCP("I"),1,ITEMDA,2,DATE)) Q:'DATE  S TOTAL=TOTAL+$P($G(^(DATE,0)),"^",2)
 .   S AVERAGE=$J(TOTAL/PRCPTDAY,0,5)
 .   S ^TMP($J,"PRCPRALS",GROUPNM,SORT,ITEMDA)=AVERAGE
 ;  print report
 K PRCPFLAG
 S Y=PRCPSTDT_"00" D DD^%DT S PRCPSTDD=Y
 D NOW^%DTC S Y=% D DD^%DT S NOW=Y,PAGE=1,SCREEN=$$SCRPAUSE^PRCPUREP U IO D H
 S GROUP="" F  S GROUP=$O(^TMP($J,"PRCPRALS",GROUP)) Q:GROUP=""!($G(PRCPFLAG))  D
 .   I $G(ZTQUEUED),$$S^%ZTLOAD S PRCPFLAG=1 W !?10,"<<< TASKMANAGER JOB TERMINATED BY USER >>>" Q
 .   I $Y>(IOSL-6) D:SCREEN P^PRCPUREP Q:$D(PRCPFLAG)  D H
 .   W !!?5,"GROUP: ",$S(GROUP=" ":"<<NONE>>",1:GROUP)
 .   S SORT="" F  S SORT=$O(^TMP($J,"PRCPRALS",GROUP,SORT)) Q:SORT=""!($G(PRCPFLAG))  S ITEMDA=0 F  S ITEMDA=$O(^TMP($J,"PRCPRALS",GROUP,SORT,ITEMDA)) Q:'ITEMDA!($G(PRCPFLAG))  S AVERAGE=^(ITEMDA) D
 .   .   I $Y>(IOSL-6) D:SCREEN P^PRCPUREP Q:$D(PRCPFLAG)  D H
 .   .   S ITEMDATA=$G(^PRCP(445,PRCP("I"),1,ITEMDA,0))
 .   .   S DESCR=$$DESCR^PRCPUX1(PRCP("I"),ITEMDA),NSN=$$NSN^PRCPUX1(ITEMDA)
 .   .   I PRCP("DPTYPE")="W" W !!,NSN,?18,$E(DESCR,1,18)
 .   .   ; On-Demand Item display
 .   .   S ODI=""
 .   .   I PRCP("DPTYPE")'="W" S ODI=$$ODITEM^PRCPUX2(PRCP("I"),ITEMDA)
 .   .   Q:PRCP("DPTYPE")'="W"&((($G(ODIS)=1)&(ODI="Y"))!(($G(ODIS)=2)&(ODI'="Y")))
 .   .   I PRCP("DPTYPE")'="W" W !!,$E(DESCR,1,18),?25,$S(ODI="Y":"D",1:"")
 .   .   ;
 .   .   W ?38,ITEMDA,?45,"OLD",$J(+$P(ITEMDATA,"^",9),8),$J(+$P(ITEMDATA,"^",11),8),$J(+$P(ITEMDATA,"^",10),8),$J(+$P(ITEMDATA,"^",4),8)
 .   .   I AVERAGE>.06,$G(PRCPFSET) K PRCPFNOT L +^PRCP(445,PRCP("I"),1,ITEMDA,0):5 I '$T S PRCPFNOT=1
 .   .   W !?3,"AVG USAGE: ",$J(AVERAGE,0,4)
 .   .   W ?22,$J($S('$G(PRCPFSET):"ESTIMATED VALUES",AVERAGE'>.06:"LOW USAGE (NOT UPDATED)",$G(PRCPFNOT):"UNABLE TO UPDATE (LOCKED)",1:"NEW VALUES"),26),?48
 .   .   ;  normal stock level
 .   .   S PRCPNNSL=AVERAGE*PRCPDNSL\1 S:PRCPNNSL>999999 PRCPNNSL=999999 W $J(PRCPNNSL,8)
 .   .   ;  emergency stock level
 .   .   S PRCPNESL=$J(PRCPNNSL*PRCPPESL/100,0,0) S:PRCPNESL>999999 PRCPNESL=999999 W $J(PRCPNESL,8)
 .   .   ;  standard reorder point
 .   .   S PRCPNSRP=$J(PRCPNNSL*PRCPPSRP/100,0,0) S:PRCPNSRP>999999 PRCPPSRP=999999 W $J(PRCPNSRP,8)
 .   .   ;  optional reorder point
 .   .   S PRCPNORP=$J(PRCPNNSL*PRCPPORP/100,0,0) S:PRCPNORP>999999 PRCPNORP=999999 W $J(PRCPNORP,8)
 .   .   I AVERAGE>.06,$G(PRCPFSET),'$G(PRCPFNOT) S $P(^PRCP(445,PRCP("I"),1,ITEMDA,0),"^",4)=PRCPNORP,$P(^(0),"^",9,11)=PRCPNNSL_"^"_PRCPNSRP_"^"_PRCPNESL L -^PRCP(445,PRCP("I"),1,ITEMDA,0)
 I '$G(PRCPFLAG) D END^PRCPUREP
 Q
 ;
 ;
H S %=NOW_"  PAGE "_PAGE,PAGE=PAGE+1 I PAGE'=2!(SCREEN) W @IOF
 W $C(13),"AUTOMATIC LEVEL SETTER FOR: ",$E(PRCP("IN"),1,20),?(80-$L(%)),%
 I PRCP("DPTYPE")'="W",('$D(^TMP($J,"PRCPURS4"))) W !?5,$S(ODIS=2:"ON-DEMAND ITEMS ONLY",ODIS=3:"ALL ITEMS (STANDARD AND ON-DEMAND)",1:"STANDARD ITEMS ONLY")
 W !?5,"AVG USAGE START DATE: ",PRCPSTDD," (",PRCPTDAY," TOTAL DAYS)"
 W !?5,"DAYS/PERCENTAGE USED FOR CALCULATION:",?48,$J(PRCPDNSL,8),$J(PRCPPESL_"%",8),$J(PRCPPSRP_"%",8),$J(PRCPPORP_"%",8)
 S %="",$P(%,"-",81)=""
 W !?48,$J("NORMAL",8),$J("EMERG",8),$J("STAND",8),$J("OPTION",8),!
 I PRCP("DPTYPE")="W" W "NSN",?18,"DESCRIPTION"
 E  W "DESCRIPTION",?25,"OD"
 W ?38,"IM#",?48,$J("STKLVL",8),$J("STKLVL",8),$J("REO PT",8),$J("REO PT",8),!,%
 Q