DDW4 ;SFISC/PD KELTZ-OTHER NAVIGATION, DEL ;2:54 PM  23 Aug 2000
 ;;22.0;VA FileMan;**18**;Mar 30, 1999
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
TAB N DDWX
 S DDWX=$F(DDWRUL,"T",DDWC+1) G:'DDWX ERR
 D POS(DDWRW,DDWX-1,"R")
 Q
 ;
DEOL S (DDWN,DDWL(DDWRW))=$E(DDWN,1,DDWC-1)
 W $P(DDGLCLR,DDGLDEL)
 Q
 ;
DELW N DDWI,DDWW
 I $D(DDWMARK),DDWRW+DDWA'>$P(DDWMARK,U,3) D UNMARK^DDW7
 I DDWC>$L(DDWN) D  Q
 . I DDWN?." " D
 .. D XLINE^DDW5()
 . E  D
 .. N DDWY,DDWX
 .. S DDWY=DDWRW+DDWA,DDWX=DDWC
 .. D JOIN^DDW6
 .. D POS(DDWY-DDWA,DDWX,"RN")
 ;
 S DDWI=$$WRPOS(DDWN)
 S DDWW=$E(DDWN,DDWC,DDWI-1)
 S $E(DDWN,DDWC,DDWI-1)="",DDWL(DDWRW)=DDWN
 I $P(DDGLED,DDGLDEL,6)]"" D
 . F DDWI=1:1:$L(DDWW) W $P(DDGLED,DDGLDEL,6)
 . S DDWI=$E(DDWN,IOM-$L(DDWW)+1+DDWOFS,IOM+DDWOFS)
 . I DDWI]"" D CUP(DDWRW,IOM-$L(DDWW)+1) W DDWI D CUP(DDWRW,DDWC-DDWOFS)
 E  D
 . W $E(DDWN_$J("",$L(DDWW)),DDWC,IOM+DDWOFS)
 . D CUP(DDWRW,DDWC-DDWOFS)
 Q
 ;
WORDR N DDWI
 S DDWI=$$WRPOS(DDWN)
 D POS(DDWRW,DDWI,"R")
 Q
 ;
WRPOS(DDWT) ;
 N DDWP,DDWS
 S DDWT=$$PUNC(DDWT)
 S DDWS=$F(DDWT," ",DDWC+1),DDWP=$F(DDWT,"!",DDWC+1)
 S:'DDWS DDWS=999 S:'DDWP DDWP=999
 ;
 I DDWC>$L(DDWT) D
 . I DDWRW+DDWA'<DDWCNT S DDWI=$L(DDWT)+1
 . E  D DN^DDWT1 S DDWI=1
 E  I DDWS=999,DDWP=999 D
 . S DDWI=$L(DDWT)+1
 E  I $E(DDWT,DDWC)="!" D
 . F DDWI=DDWC+1:1 Q:$E(DDWT,DDWI)'="!"
 . F DDWI=DDWI:1 Q:$E(DDWT,DDWI)'=" "
 E  I DDWS<DDWP D
 . F DDWI=DDWS:1 Q:$E(DDWT,DDWI)'=" "
 E  S DDWI=DDWP-1
 Q DDWI
 ;
WORDL N DDWD,DDWI,DDWT
 S DDWT=$$PUNC(DDWN)
 ;
 I DDWC=1 D
 . I DDWRW=1,'DDWA S DDWI=1
 . E  D UP^DDWT1 S DDWI=$L(DDWN)+1
 E  D
 . S DDWI=DDWC-1
 . S:$E(DDWT,DDWI)="" DDWI=$L(DDWT)
 . I $E(DDWT,DDWI)=" " F DDWI=DDWI-1:-1:0 Q:$E(DDWT,DDWI)'=" "
 . I $E(DDWT,DDWI)="!" D
 .. F DDWI=DDWI-1:-1:0 Q:$E(DDWT,DDWI)'="!"
 . E  I DDWI D
 .. F DDWI=DDWI-1:-1:0 Q:" !"[$E(DDWT,DDWI)
 . S DDWI=DDWI+1
 D POS(DDWRW,DDWI,"R")
 Q
 ;
PGDN N DDWX
 I DDWRW<DDWMR D
 . D POS($$MIN(DDWCNT-DDWA,DDWMR),DDWC,"RN")
 E  D
 . S DDWX=$$MIN(DDWSTB,DDWMR)
 . D:DDWX MVFWD^DDW3(DDWX)
 Q
 ;
PGUP N DDWX
 I DDWRW>1 D
 . D POS(1,DDWC,"RN")
 E  D
 . S DDWX=$$MIN(DDWA,DDWMR)
 . D:DDWX MVBCK^DDW3(DDWX)
 Q
 ;
JLEFT I DDWC=1,'DDWOFS Q
 N DDWX
 I DDWN?." " S DDWX=1
 E  F DDWX=1:1:$L(DDWN) Q:$E(DDWN,DDWX)'=" "
 I DDWC-DDWOFS=1,DDWC>1 D POS(DDWRW,DDWC-1,"R") Q:DDWC=DDWX
 S DDWC=$$MAX($S($$SCR(DDWX)=$$SCR(DDWC)&(DDWC'=DDWX):DDWX,1:0),1+DDWOFS)
 D POS(DDWRW,DDWC,"R")
 Q
JRIGHT N DDWX
 S DDWX=$L(DDWN)+1
 I DDWC-DDWOFS=IOM,DDWC<246 D POS(DDWRW,DDWC+1,"R") Q:DDWC=DDWX
 S DDWC=$$MIN($S($$SCR(DDWX)=$$SCR(DDWC)&(DDWC'=DDWX):DDWX,1:999),$$MIN(IOM+DDWOFS,246))
 D POS(DDWRW,DDWC,"R")
 Q
 ;
LBEG N DDWX
 I DDWN?." " D POS(DDWRW,1,"R") Q
 I $E(DDWN,1,DDWC-1)?." ",$E(DDWN,DDWC)'=" " D POS(DDWRW,1,"R") Q
 F DDWX=1:1:$L(DDWN) Q:$E(DDWN,DDWX)'=" "
 D POS(DDWRW,DDWX,"R")
 Q
LEND D POS(DDWRW,"E","R")
 Q
 ;
ERR ;Beep
 W $C(7)
 Q
 ;
CUP(Y,X) ;Cursor positioning
 S DY=IOTM+Y-2,DX=X-1 X IOXY
 Q
 ;
POS(R,C,F) ;Pos cursor based on char pos C
 N DDWX
 S:$G(C)="E" C=$L($G(DDWL(R)))+1
 S:$G(F)["N" DDWN=$G(DDWL(R))
 S:$G(F)["R" DDWRW=R,DDWC=C
 ;
 S DDWX=C-DDWOFS
 I DDWX>IOM!(DDWX<1) D SHIFT^DDW3(C,.DDWOFS)
 S DY=IOTM+R-2,DX=C-DDWOFS-1 X IOXY
 Q
 ;
SCR(C) ;Screen #
 Q C-$P(DDWOFS,U,2)-1\$P(DDWOFS,U,3)+1
 ;
MIN(X,Y) ;
 Q $S(X<Y:X,1:Y)
MAX(X,Y) ;
 Q $S(X>Y:X,1:Y)
PUNC(X) ;
 Q $TR(X,"`~!@#$%^&*()-_=+\|[{]};:'"",<.>/?",$TR($J("",32)," ","!"))