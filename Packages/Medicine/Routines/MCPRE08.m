MCPRE08 ;HIRMFO/DAD-PFT PREDICTED VALUES FILE (700.1) CLEANUP ;8/5/96  08:42
 ;;2.3;Medicine;;09/13/1996
 ;
 N DA,DIE,DR,MCD0,MCOFFSET,MCPIECE,MCTYPE
 S MCDATA(1)=""
 S MCDATA(2)="Cleaning-up the PFT PREDICTED VALUES file (#700.1)."
 D MES^XPDUTL(.MCDATA)
 ;
 F MCOFFSET=1:1 S MCDATA=$P($T(TYPFLD+MCOFFSET),";",3) Q:MCDATA=""  D
 . S MCTYPE=$P(MCDATA,U),MCD0=0
 . F  S MCD0=$O(^MCAR(700.1,"AC",MCTYPE,MCD0)) Q:MCD0'>0  D
 .. F MCPIECE=2:1 S MCFLD=$P(MCDATA,U,MCPIECE) Q:MCFLD=""  D
 ... S MCOLDVAL=$P(MCFLD,";",2),MCFLD=$P(MCFLD,";")
 ... I $$GET1^DIQ(700.1,MCD0,MCFLD)'=MCOLDVAL Q
 ... S DIE="^MCAR(700.1,",DA=MCD0,DR=MCFLD_"///@"
 ... D ^DIE
 ... Q
 .. Q
 . Q
 Q
TYPFLD ;; Sex_Type ^ Field1 ; Old_Value ^ Field2 ; Old_Value ^ ...
 ;;M^10;ACT-(.132*ACT)^12;ACT-(.132*ACT)^13;ACT-(.132*ACT)
 ;;F^10;ACT-(.132*ACT)^12;ACT-(.132*ACT)^13;ACT-(.132*ACT)