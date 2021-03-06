IBCOPV2 ;ALB/LDB - ROUTINE TO LIST PATIENT VISITS ;30 APR 90
 ;;2.0;INTEGRATED BILLING;**52,91,106**;21-MAR-94
 ;
 ;MAP TO DGCROPV2
 ;
ELIG N IBCODN
 Q:$D(DGNO)  S (DGCOD,IBCODN)=$S(DGFIL'=2.101:+$P(DGNOD,U,3),1:"ADMITTING/SCREENING") I $D(^DIC(40.7,+IBCODN,0)) S:IBCODN DGCOD=$P(^DIC(40.7,+IBCODN,0),U)
 I DGFIL=409.5,$P($G(^DIC(40.7,+IBCODN,0)),U,2)>899&($P($G(^DIC(40.7,+IBCODN,0)),U,2)<999) S DGCOD=$P(DGNOD,U,4) S:$D(^SC(+DGCOD,0)) DGCOD=$P(^(0),U,7) S:$D(^DIC(40.7,+DGCOD,0)) DGCOD=$P(^(0),U)
 I DGFIL'=2.101 S IBCODCL=$P(DGNOD,U,4) S IBCODCL=$P($G(^SC(+IBCODCL,0)),U,1)
 ;
 I (DGTYP="")!(DGTYP=9) S DGTYP=$S($D(^DPT(DFN,.36)):^(.36),1:"") S:DGTYP DGTYP=$E($G(^DIC(8,+DGTYP,0)),1,3)
 I DGTYP'="NSC" S DGMT="" Q
 S DGMT=$P($$LST^DGMTU(DFN,$P(I,".",1)),U,4)
 Q
 ;
CHG S IBCHG=+$$BILLCOST^IBCRCI(IBIFN,DGDT,"OUTPATIENT VISIT DATE")
 I +IBCHG S $P(^UTILITY($J,"OPV","AP",DGCNT),U,2)=IBCHG
 Q
 ;
PROD F P=2:1 S DGCPT2=$P(^UTILITY($J,"CPT1",I7,DGNO),U,P) Q:DGCPT2=""  D
 .I $P(^DGCR(399,IBIFN,0),U,9)=4 D
 ..F I8=1:1:3 I $P($G(^DGCR(399,IBIFN,"C")),U,I8)=$P(^UTILITY($J,"CPT1",I7,DGNO),U,P) S $P(^UTILITY($J,"CPT1",I7,DGNO),U,P)=$P(^UTILITY($J,"CPT1",I7,DGNO),U,P)_"~0"
 .I $D(^DGCR(399,IBIFN,"CP","B",DGCPT2_";ICPT(")) D
 ..F DGCPT0=0:0 S DGCPT0=$O(^DGCR(399,IBIFN,"CP","B",DGCPT2_";ICPT(",DGCPT0)) Q:'DGCPT0  D
 ...S $P(^UTILITY($J,"CPT1",I7,DGNO),U,P)=$S(^UTILITY($J,"CPT1",I7,DGNO)'[(DGCPT2_"~"_DGCPT0):(DGCPT2_"~"_DGCPT0),1:$P(^UTILITY($J,"CPT",I7,DGNO),U,P))
 Q
 ;
