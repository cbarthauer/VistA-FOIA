DGENUPA2 ;ALB/CJM - Protocol Viewing Eligibility Upload Audit;16 JUN 1997 01:30 pm
 ;;5.3;Registration;**147**;08/13/93
 ;
EN(DFN) ;Entry point for DGENUP ELIGIBILITY UPLOAD AUDIT protocol
 N DGAUDIT
 D FULL^VALM1
 S DGAUDIT=$$SELECT(DFN)
 D:$G(DGAUDIT) EN^DGENLUP(DFN,DGAUDIT)
 ;D:DFN BLD^DGENL
 S VALMBCK="R"
 Q
 ;
SELECT(DFN) ;
 N DIC,D,X
 S DIC=27.14
 S DIC(0)="EMNQ"
 S X=DFN
 S D="C"
 D IX^DIC
 I $D(DTOUT)!$D(DUOUT) Q 0
 I +Y=-1 Q 0
 Q +Y