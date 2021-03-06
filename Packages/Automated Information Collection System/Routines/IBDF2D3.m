IBDF2D3 ;ALB/CJM - ENCOUNTER FORM - WRITE SELECTION LIST (cont'd) ;NOV 16,1992
 ;;3.0;AUTOMATED INFO COLLECTION SYS;**38**;APR 24, 1997
 ;
DISPLAY(SLCTN,COL,HEADER,SUBHDR) ;writes the selection to the list
 N J,K,DA,ENTRY,VALUE,TYPE,UNDRLINE,OFFSET,LEN,FIRST,IBROW,IBCOL,BBBLS,ID,DISPLAY,NODE,SUB,WRAP,QTY,ND2
 S UNDRLINE=$S(IBLIST("ULSLCTNS"):"U",1:"")
 S FIRST=1,(ID,HEADER,DISPLAY,NODE)=""
 ;
 ;get the 0 node of the selection & the selection identifier
 I SLCTN S:IBLIST("DYNAMIC") NODE=$G(@LOCATION@(SLCTN)) S:'IBLIST("DYNAMIC") NODE=$G(^IBE(357.3,SLCTN,0)),ND2=$G(^IBE(357.3,SLCTN,2)) S ID=$P(NODE,"^")
 ;
 ;if a place holder, determine its use as a subheader - dynamic lists don't have place holders
 I 'IBLIST("DYNAMIC") D
 .S QTY=$P(NODE,"^",9)
 .I $P(NODE,"^",2) D
 ..;turn of the use of any prior subhdr if it was used
 ..I $P(NODE,"^",8) S SUBHDR=""
 ..;determine if this is to be used as a subheader
 ..S $P(NODE,"^",6)=$P(NODE,"^",6)
 ..I $P(NODE,"^",7),$P(NODE,"^",6)]"" S SUBHDR=SUBHDR_" "_$$STRIP^IBDFU($P(NODE,"^",6))
 ;
 ;if place holder with text,just print the text and quit
 I 'IBLIST("DYNAMIC"),$P(NODE,"^",2),$P(NODE,"^",6)]"" D  Q
 .I IBLIST("ULSLCTNS") D
 ..D DRWSTR^IBDFU($$Y^IBDF2D,($$X^IBDF2D)+LINE,$P(IBLIST("SEP"),"|",2)_$P(NODE,"^",6),"U",CWIDTH-(2*LINE))
 ..I NEEDUPR D DRWSTR^IBDFU(($$Y^IBDF2D)-1,($$X^IBDF2D)+LINE,"","U",CWIDTH-(2*LINE)) S NEEDUPR=0
 .E  D DRWSTR^IBDFU($$Y^IBDF2D,($$X^IBDF2D)+$L(IBLIST("SEP2"))+LINE,$P(NODE,"^",6))
 .D DECREASE^IBDF2D(.COL)
 ;
 ;don't draw bubbles for place holders
 I 'IBLIST("DYNAMIC"),$P(NODE,"^",2) N DRWBBL S DRWBBL=0
 ;
 I SLCTN,(IBLIST("DYNAMIC")!('$P(NODE,"^",2))) S CNT=CNT+1
 ;
 I 'IBFORM("COMPILED") I 'SLCTN,IBLIST("DYNAMIC") D
 .S CNT=CNT+1
 .S DISPLAY="#"_CNT
 .S ID=""
 ;
 F K=1:1:(+IBLIST("BTWN")+1) D  Q:COL("ROWSLEFT")<1
 .S ENTRY=""
 .S OFFSET=LINE
 .F J=1-IBLIST("SC0"):1:8 S TYPE=IBLIST("SCTYPE",J) D:TYPE'=""
 ..;S VALUE=""
 ..S VALUE=$S(K=2:$G(WRAP(J)),1:"")
 ..I TYPE=1,K'>1,SLCTN D  S:(ID]"")&IBLIST("SCPIECE",J) DISPLAY=DISPLAY_$S(DISPLAY="":"",1:" :: ")_$E(VALUE,1,IBLIST("SCW",J)*(1+$S(IBLIST("BTWN"):1,1:0))) I IBLIST("BTWN"),$L(VALUE)>IBLIST("SCW",J) D WRAP
 ...I IBLIST("SCPIECE",J)=0 S:SLCTN&(IBLIST("DYNAMIC")!('$P(NODE,"^",2))) VALUE="#"_CNT Q
 ...I 'IBLIST("DYNAMIC") S DA=$O(^IBE(357.3,SLCTN,1,"B",J,"")) S:DA VALUE=$P($G(^IBE(357.3,SLCTN,1,DA,0)),"^",2) Q
 ...;dynamic lists
 ...S SUB=$$DATANODE^IBDFU1B(IBLIST("RTN"),IBLIST("SCPIECE",J))
 ...I SUB]"" S VALUE=$P($G(@IBLIST("DATA_LOCATION")@(SUB,SLCTN)),"^",IBLIST("SCPIECE",J))
 ...E  S VALUE=$P(NODE,"^",IBLIST("SCPIECE",J))
 ...;
 ..S:TYPE=2 VALUE=$S(K'>1:IBLIST("SCSYMBOL",J),1:$J("",IBLIST("SCW",J)))
 ..;I TYPE=1 I SLCTN,ID]"",K'>1,IBLIST("SCPIECE",J) S DISPLAY=DISPLAY_$S(DISPLAY="":"",1:" :: ")_$E(VALUE,1,(IBLIST("SCW",J))
 ..S:TYPE=1 VALUE=$$PADRIGHT^IBDFU(VALUE,IBLIST("SCW",J))
 ..I TYPE=2 I IBLIST("ROUTINE",J)]"",K'>1,DRWBBL S IBCOL=($$X^IBDF2D)+OFFSET+$L(IBLIST("SEP2"))+$L(ENTRY)+((IBLIST("SCW",J)-3)\2),IBROW=$$Y^IBDF2D+$S(IBLIST("BTWN"):.5,1:0),BBBLS(IBCOL)=J
 ..I (TYPE=1)!('IBLIST("NOUL",J))!(K'=(+IBLIST("BTWN")+1))!(UNDRLINE'="U") D 
 ...S ENTRY=ENTRY_IBLIST("SEP2")_VALUE_IBLIST("SEP1")
 ...S FIRST=0
 ..E  D
 ...S NEEDUPR=1
 ...S LEN=$S(FIRST:0,1:$L(ENTRY)-LINE)
 ...S ENTRY=ENTRY_IBLIST("SEP2")_VALUE_IBLIST("SEP1")
 ...I OFFSET+$L(ENTRY)=CWIDTH S ENTRY=$E(ENTRY,1,$L(ENTRY)-LINE)
 ...D DRWSTR^IBDFU($$Y^IBDF2D,($$X^IBDF2D)+OFFSET,ENTRY,"U",LEN)
 ...S OFFSET=OFFSET+$L(ENTRY),ENTRY="",FIRST=1
 .I ENTRY'="" S ENTRY=$E(ENTRY,1,$L(ENTRY)-$L(IBLIST("SEP1"))) D DRWSTR^IBDFU($$Y^IBDF2D,($$X^IBDF2D)+OFFSET,ENTRY,$S(K'=(+IBLIST("BTWN")+1):"",1:UNDRLINE),$L(ENTRY)+$L(IBLIST("SEP2")))
 .D DECREASE^IBDF2D(.COL)
 ;
 ;Writting bubbles to form tracking? Is the form NOT yet compiled? Otherwise, don't need to do anything with the bubbles
 I (TRACKBBL)!('IBFORM("COMPILED")) S IBCOL="" F  S IBCOL=$O(BBBLS(IBCOL)) Q:IBCOL=""  S J=BBBLS(IBCOL) I IBLIST("ROUTINE",J)="BUBBLE" D
 .;
 .D:'TRACKBBL DRWBBL^IBDFM1(IBROW,IBCOL,IBLIST("INPUT_RTN"),ID,IBLIST("NAME"),"S"_IBLIST_"("_J,IBLIST("RULE",J),DISPLAY,HEADER,IBLIST("QLFR",J),IBLIST("DYNAMIC"),CNT,SUBHDR,$G(QTY),$G(ND2),$G(SLCTN))
 .D:TRACKBBL TRACKBBL^IBDFM1("S"_IBLIST_"("_J,CNT,IBLIST("QLFR",J),IBLIST("INPUT_RTN"),DISPLAY,ID)
 Q
 ;
WRAP    ;
 Q:IBLIST("SCW",J)<8
 N FOUND,AT,I,CHAR S FOUND=0
 S AT=IBLIST("SCW",J)+2
 F I=0:1:IBLIST("SCW",J)\4 S AT=AT-1,CHAR=$E(VALUE,AT) I " /\-:;"[CHAR S FOUND=1 Q
 I FOUND D
 .S WRAP(J)=$E(VALUE,AT+$S(" -"[CHAR:1,1:0),AT+IBLIST("SCW",J))
 .F I=1:1:IBLIST("SCW",J) I $E(WRAP(J),I)'=" " D  Q
 ..I I>1 S WRAP(J)=$E(WRAP(J),I,$L(WRAP(J)))
 .S VALUE=$E(VALUE,1,AT-1)
 E  S WRAP(J)=$E(VALUE,IBLIST("SCW",J),2*IBLIST("SCW",J)-1),VALUE=$E(VALUE,1,IBLIST("SCW",J)-1)_"-"
 Q
