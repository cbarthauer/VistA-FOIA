TIUEPRNT ; SLC/JER - Handle print following entry/edit ; 5/3/04
 ;;1.0;TEXT INTEGRATION UTILITIES;**20,100,182**;Jun 20, 1997
PRINT(TIUDA) ; Prompt and print
 N TIUDEV,TIUTYP,DFN,TIUPMTHD,TIUD0,TIUMSG,TIUPR,TIUDARR,TIUFLAG,TIUDPRM
 N TIUPGRP,TIUPFHDR,TIUPFNBR
 S TIUMSG="Print this note"
 S TIUPR=$$READ^TIUU("Y",TIUMSG,"No")
 I +TIUPR'>0 Q
 I +$$ISADDNDM^TIULC1(TIUDA) S TIUDA=$P($G(^TIU(8925,+TIUDA,0)),U,6)
 I $G(^TIU(8925,TIUDA,21)) S TIUDA=^TIU(8925,TIUDA,21)
 S TIUD0=$G(^TIU(8925,TIUDA,0))
 S TIUTYP=$P(TIUD0,U),DFN=$P(TIUD0,U,2)
 I +TIUTYP'>0 Q
 S TIUPMTHD=$$PRNTMTHD^TIULG(+TIUTYP)
 S TIUPGRP=$$PRNTGRP^TIULG(+TIUTYP)
 S TIUPFHDR=$$PRNTHDR^TIULG(+TIUTYP)
 S TIUPFNBR=$$PRNTNBR^TIULG(+TIUTYP)
 D DOCPRM^TIULC1(+TIUTYP,.TIUDPRM,TIUDA)
 I +$P($G(TIUDPRM(0)),U,9) S TIUFLAG=$$FLAG^TIUPRPN3
 ;I $G(TIUPMTHD)]"",+$G(TIUPGRP),($G(TIUPFHDR)]""),($G(TIUPFNBR)]"") S TIUDARR(TIUPMTHD,$G(TIUPGRP)_"$"_TIUPFHDR_";"_DFN,1,TIUDA)=TIUPFNBR
 ;E  S TIUDARR(TIUPMTHD,DFN,1,TIUDA)=""
 I $G(TIUPMTHD)']"" W !,$C(7),"No Print Method Defined for ",$P($G(^TIU(8925.1,+TIUTYP,0)),U) H 2 G PRINT1X
 ; -- P182: Set array same whether or not flds are defined, with
 ;    TIUPGRP piece possibly 0, TIUPFHDR piece possibly null, and
 ;    array value TIUPFNBR possibly null.
 S TIUDARR(TIUPMTHD,+$G(TIUPGRP)_"$"_$G(TIUPFHDR)_";"_DFN,1,TIUDA)=$G(TIUPFNBR)
 S TIUDEV=$$DEVICE^TIUDEV(.IO) ; Get Device/allow queueing
 I $S($G(IO)']"":1,TIUDEV']"":1,1:0) D ^%ZISC Q
 I $D(IO("Q")) D QUE^TIUDEV("PRINTQ^TIUEPRNT",TIUDEV) G PRINT1X
 D PRINTQ,^%ZISC
PRINT1X ; Exit single document print
 Q
PRINTQ ; Entry point for queued single document print
 D PRNTDOC(TIUPMTHD,.TIUDARR)
 Q
PRNTDOC(TIUPMTHD,TIUDARR) ; Print a single document type
 ; Receives TIUPMTHD & TIUDARR
 N TIUDA
 I '+$D(TIUDARR) W !,"No Documents selected." Q
 M ^TMP("TIUPR",$J)=TIUDARR(TIUPMTHD)
 I TIUPMTHD']"" D  G PRNTDOCX
 . W !!,"No Print Method Defined for ",$P(TIUTYP,U,2) H 2
 X TIUPMTHD
PRNTDOCX ; Exit single document type print
 K ^TMP("TIUPR",$J)
 Q