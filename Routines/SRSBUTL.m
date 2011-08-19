SRSBUTL ;B'HAM ISC/MAM - BLOCK OUT TIME ON OR SCHEDULE UTILITY; [ 08/14/09  11:36 AM ]
 ;;3.0; Surgery ;**165**;24 Jun 93;Build 6
BLOCKED ; find blocked OPERATING ROOMS
 S SRBDT=DT,SRBCNT=0,SRBOR=SRSOR,SRBDAY=SRSDAY
 S X1=SRBDT,X2=-1 D C^%DTC S SRBDT=X
 F  S SRBDT=$O(^SRS(SRBOR,"S",SRBDT)) Q:SRBDT=""  D
 .S SRBCNT=SRBCNT+1
 .Q:'$D(^SRS(SRBOR,"S",SRBDT,1))
 .S SRBST=""
 .F  S SRBST=$O(^SRS("R",SRBDAY,SRBOR,SRBST)) Q:SRBST=""  D
 ..S SRBN=""
 ..F  S SRBN=$O(^SRS("R",SRBDAY,SRBOR,SRBST,SRBN)) Q:SRBN=""  D
 ...S SRBET=$P(^SRS("R",SRBDAY,SRBOR,SRBST,SRBN),"^",4)
 ...S SRBSERV=$P(^SRS("R",SRBDAY,SRBOR,SRBST,SRBN),"^",5)
 ...S SRB1=+SRBST,SRB2=+SRBET
 ...D PTRNALG  ; algorithm for setting start and end of pattern
 ...S SRBNUM=$S(SRBN=0:3,SRBN>7&(SRBN<10):2,1:1)
 ...I $G(^SRS(SRBOR,"S",SRBDT,1))[SRBS S ^TMP($J,"SRSBOUT",SRBDT,SRBNUM,SRBST)=SRBSERV_"^"_SRBN_"^"_SRBET
 K SRB1,SRB2,SRBCNT,SRBDAY,SRBDT,SRBET,SRBI,SRBNUM,SRBN,SRBS,SRBSERV,SRBST,X,X1,X2
 Q
CHK ;; CHECK FOR EXISTING BLOCKS
 S SRBOR=SRSOR,SRBDT=SRSDATE,SRBTIME=SRSTIME,SRBNUM=SRSNUM
 S SRB1=$P(SRBTIME,"^"),SRB2=$P(SRBTIME,"^",2),SRB1=$E(SRB1,1,2)_"."_$E(SRB1,4,5),SRB2=$E(SRB2,1,2)_"."_$E(SRB2,4,5)
 S SRBEN1=SRB1,SRBEN2=SRB2,SRBFLG=1,X=0 D CHKD
CK1 I SRBNUM=0 S X=7 D CHKD G:X CK1
CK2 I SRBNUM>7 S X=14 D CHKD G:X CK2
CK0 I SRBNUM>0,(SRBNUM<5) S X5=$E(SRBDT,4,5),X1=SRBDT,X2=7 D C^%DTC S SRBDT=X G:$E(X,4,5)=X5 CK0
CK3 I SRBNUM>0,(SRBNUM<5) S X=SRBNUM-1*7 D CHKD G:X CK0
CK5 I SRBNUM=5 S X1=SRBDT,X2=21 D C^%DTC S SRBDT=X
CK4 I SRBNUM=5 S X1=SRBDT,X2=7,X5=$E(SRBDT,4,5) D C^%DTC S SRBDT=X G:$E(SRBDT,4,5)=X5 CK4 S X=-7 D CHKD G:X CK5
END S SRBDT="" F  S SRBDT=$O(SRBCHK(SRBDT)) Q:'SRBDT  S:SRBCHK(SRBDT)=0 SRBFLG=0
 K SRB1,SRB2,SRBDT,SRBEN1,SRBEN2,SRBNMB,SRBNUM,SRBST,SRBET,SRBTIME,X5
 Q
CHKD S X1=SRBDT,X2=X D C^%DTC S SRBDT=X
 S:'$G(^SRS(SRBOR,"S",SRBDT,0)) X=0
 S SRBCHK(SRBDT)=0
 I $D(^TMP($J,"SRSBOUT",SRBDT))  D
 .S SRBNMB=""
 .F  S SRBNMB=$O(^TMP($J,"SRSBOUT",SRBDT,SRBNMB)) Q:'SRBNMB  D
 ..S (SRBST,SRBET)=""
 ..F  S SRBST=$O(^TMP($J,"SRSBOUT",SRBDT,SRBNMB,SRBST)) Q:'SRBST  D
 ...S SRBET=$P(^TMP($J,"SRSBOUT",SRBDT,SRBNMB,SRBST),"^",3)
 ...I (SRBST'<SRBEN1)&(SRBST<SRBEN2)!((SRBET>SRBEN1)&(SRBET'>SRBEN2))!((SRBEN1'<SRBST)&(SRBEN1<SRBET)) S SRBCHK(SRBDT)=1
 Q
DIS1 ;CHECK AND SET NEW SERVICE BLOCK
 S SRBOR=SROR,SRBDT=SRSDATE
 S X1=SRBDT,X2=2830103 D ^%DTC S SRBDAY=$P("MO^TU^WE^TH^FR^SA^SU","^",X#7+1),X3=X#2+8 S X1=SRBDT,X2=$E(SRBDT,1,5)_"01" D ^%DTC S SRBDY=X\7+1
 S:'$G(SRBSER1) SRBSER1=""
 S SRBCNTR=0
 S SRBST=0 F  S SRBST=$O(^SRS("R",SRBDAY,SRBOR,SRBST)) Q:SRBST=""  D
 .S SRBN="" F  S SRBN=$O(^SRS("R",SRBDAY,SRBOR,SRBST,SRBN)) Q:SRBN=""  D
 ..S SRBET=$P(^SRS("R",SRBDAY,SRBOR,SRBST,SRBN),"^",4),SRBSER=$P(^SRS("R",SRBDAY,SRBOR,SRBST,SRBN),"^",5)
 ..S:SRBSER1'=SRBSER SRBCNTR=SRBCNTR+1,SRBSTM(SRBCNTR)=SRBST,SRBETM(SRBCNTR)=SRBET,SRBS1(SRBCNTR)=$P(^SRS("R",SRBDAY,SRBOR,SRBST,SRBN),"^",2)
 S SRBCTR3=0,SRB=0
 F SRBCTR1=1:1:3 D
 .F SRBCTR2=1:1:SRBCNTR D
 ..S SRBNUMB=$E(SRBS1(SRBCTR2),3)
 ..I SRBCTR1=3,SRBNUMB=0 D UPDATE
 ..I SRBCTR1=2,SRBNUMB=X3 D UPDATE
 ..I SRBCTR1=1,SRBNUMB=SRBDY D UPDATE
 I '$G(SRBPRG) K SRBCNT,SRBDT,SRBOR,SRBPRG,SRBSER1
 K SRB,SRBCNTR,SRBCTR1,SRBCTR2,SRBCTR3,SRBDAY,SRBDY,SRBET,SRBET1,X3
 K SRBARRY,SRBETM,SRBN,SRBNUMB,SRBS,SRBS1,SRBS2,SRBSER,SRBSERV,SRBST,SRBST1,SRBSTM
 Q
UPDATE ;CHECK AND SET SERVICE BLOCK
 I $D(^SRS(SRBOR,"S",SRBDT)),$G(^SRS(SRBOR,"S",SRBDT,1))["X" S SRBCTR3=1,SRB=1
 I '$G(SRBCTR3),'$D(^SRS(SRBOR,"S",SRBDT)) D S^SRSBOUT
 S SRBST1=SRBSTM(SRBCTR2),SRBET1=SRBETM(SRBCTR2),SRSNUM=SRBNUMB,(SRBCTR3,SRBFLG)=1
 S SRBSERV=$P(^SRS("R",SRBDAY,SRBOR,SRBST1,SRBNUMB),"^",5)
 S SRBARRY(SRBDT,SRBSERV)=SRBST1_"^"_SRBET1
 D CHECK I 'SRB D SET
 I SRBFLG,SRB S SRB1=SRBST1,SRB2=SRBET1 D PATRN
 Q
SET ;SET SERVICE BLOCK GRAPH
 I 'SRBFLG Q
 S SRB1=SRBST1,SRB2=SRBET1,SRBI=""
 D PTRNALG  ;; algorithm for setting start and end of pattern
 S SRBX1=^SRS(SROR,"S",SRSDATE,1),^(1)=$E(SRBX1,1,SRB1)_SRBS_$E(SRBX1,SRB2+1,200),^SRS(SROR,"SS",SRSDATE,1)=^(1),^SRS(SROR,"S",SRSDATE,0)=SRSDATE,^SRS(SROR,"SS",SRSDATE,0)=SRSDATE
 K SRB1,SRB2,SRBI,SRBX1
 Q
CHECK ;CHECK FOR TIME COLLISION
 S SRBSER2="" F  S SRBSER2=$O(SRBARRY(SRBDT,SRBSER2)) Q:SRBSER2=""  D
 .S SRBS1=$P(SRBARRY(SRBDT,SRBSER2),"^",1),SRBS2=$P(SRBARRY(SRBDT,SRBSER2),"^",2)
 .Q:SRBSER2=SRBSERV
 .I (SRBS1'<SRBST1)&(SRBS1<SRBET1)!((SRBS2>SRBST1)&(SRBS2'>SRBET1))!((SRBST1'<SRBS1)&(SRBST1<SRBS2)) S SRBFLG=0
 K SRBSER2
 Q
DELCHK(SRBDAY) ; CHECK FOR OVERLAPING BLOCK FOR THE DELETED DAY
 S SRBDT=SRSDATE,SRBOR=SRSOR,SRBNUM=SRSNUM,SRBST=""
 F  S SRBST=$O(^SRS("R",SRBDAY,SRBOR,SRBST)) Q:SRBST=""  D
 .Q:'$D(^SRS("R",SRBDAY,SRBOR,SRBST,SRBNUM))
 .S SRBSERV=$P(^SRS("R",SRBDAY,SRBOR,SRBST,SRBNUM),"^",5),SRBET=$P(^SRS("R",SRBDAY,SRBOR,SRBST,SRBNUM),"^",4)
 .S SRB1=+SRBST,SRB2=+SRBET
 .D PTRNALG
 .I SRBS'=SRBCKH,$G(^SRS(SRBOR,"S",SRBDT,1))'[SRBS S SRB1=+SRBST,SRB2=+SRBET D PATRN
 K SRB1,SRB2,SRBDAY,SRBDT,SRBNUM,SRBOR,SRBET,SRBST,SRBSERV,SRBS,SRBI,SRBTS,SRBTE,X,X0,X1
 Q
PATRN ; set pattern in OPERATING ROOM file
 D PTRNALG  ;; algorithm for setting start and end of pattern
 S SRBX0=^SRS(SRBOR,"SS",SRBDT,1),(SRBX0,^(1))=$E(SRBX0,1,SRB1)_SRBS_$E(SRBX0,SRB2+1,200),^SRS(SRBOR,"SS",SRBDT,0)=SRBDT
 S SRBX1=^SRS(SRBOR,"S",SRBDT,1) F SRBI=SRB1:1:SRB2 I "X="'[$E(SRBX1,SRBI) S SRBX1=$E(SRBX1,1,SRBI-1)_$E(SRBX0,SRBI)_$E(SRBX1,SRBI+1,200)
 S ^SRS(SRBOR,"S",SRBDT,1)=SRBX1,^SRS(SRBOR,"S",SRBDT,0)=SRBDT
 K SRB1,SRB2,SRBX0,SRBX1
 Q
PTRNALG ; set pattern in OPERATING ROOM file
 ; algorithm for setting start and end of pattern
 S SRB1=11+((SRB1\1)*5)+(SRB1-(SRB1\1)*100\15),SRB2=11+((SRB2\1)*5)+(SRB2-(SRB2\1)*100\15)
 S SRBS="" F SRBI=SRB1:1:SRB2-1 S SRBS=SRBS_$S('(SRBI#5):"|",$E(SRBSERV,SRBI#5)'="":$E(SRBSERV,SRBI#5),1:".")
 Q
CURRENT ; ENSURE SERVICE BLOCK GRAPH IS UP TO DATE
 S SRBOR=0 F  S SRBOR=$O(^SRS(SRBOR)) Q:'SRBOR  D
 .Q:$P(^SRS(SRBOR,0),"^",6)=1
 .S SRBCNT=0 F SRBCNT=0:1:90 S X1=DT,X2=SRBCNT D C^%DTC S SRBDT=X D:'$D(^SRS(SRBOR,"S",SRBDT,1)) GRAPH^SRSDIS1(SRBDT,SRBOR)
 K SRBCNT,SRBDT,SRBOR,X,X1,X
 Q