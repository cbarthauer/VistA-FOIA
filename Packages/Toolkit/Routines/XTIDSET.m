XTIDSET ;OAKCIOFO/JLG - SET OF CODES CONTEXT ;04/25/2005  15:12
 ;;7.3;TOOLKIT;**93**;Apr 25, 1995
 Q
 ; Context implementation for "set of codes"
 ; CTX and TERM are passed by ref in all calls
CONTEXT(TFILE,TFIELD,CTX) ; set up Context for "set of codes" type
 ; called from CONTEXT^XTIDCTX(TFILE,TFIELD,CTX)
 ; returns a valid new CTX array
 S TFILE=+$G(TFILE),TFIELD=$G(TFIELD)
 Q:'TFILE!($D(CTX))
 S CTX("TYPE")="SET"
 S CTX("TERM FILE#")=TFILE
 S CTX("TERM FIELD#")=TFIELD
 ; the default source file 
 S CTX("SOURCE FILE#")=8985.1
 ; TERMSTATUS 99.991, EFFECTIVE DATE/TIME subfile
 S CTX("TERMSTATUS SUBFILE#")=8985.11
 Q
 ;
VALIDREF(CTX,TIREF) ; validate the term, internal ref
 ; test TIREF is a valid value in set of codes
 Q:'$D(CTX)!($G(TIREF)']"") 0
 ; as requested by DS, no need for this restrictive validation 
 ; as some terms to be filed in "set of codes" kernel file
 ; may not yet exist in their original file.
 ;Q $$MEMBER(CTX("TERM FILE#"),CTX("TERM FIELD#"),TIREF)
 Q 1
 ;
FINDTERM(CTX,TIREF,TERM) ; find term in given context
 ; called from FINDTERM^XTIDCTX(CTX,TIREF,TERM)
 ; return TERM data as new TERM array
 N IENS
 Q:'$D(CTX)!($D(TERM))
 Q:'$$VALIDREF(.CTX,$G(TIREF))
 S IENS=$$GETIENS($G(TIREF))
 Q:IENS']""
 D GETTERM^XTIDCTX(.CTX,CTX("SOURCE FILE#"),IENS,.TERM)
 Q
 ;
NEWTERM(CTX,TIREF,VUID) ; create new term index entry
 ; called from NEWTERM^XTIDCTX(CTX,TIREF,VUID,TERM)
 ; D UPDATE^DIE(FLAGS,FDA_ROOT,IEN_ROOT,MSG_ROOT)
 N DIERR,FILE,SFILE,FLAGS,MASTER,MSG,MYFDA,MYIEN,SUCCESS
 S TIREF=$G(TIREF),VUID=+$G(VUID)
 Q:'$D(CTX)!($D(TERM))!('VUID) 0
 Q:'$$VALIDREF(.CTX,TIREF) 0
 S SUCCESS=0,FLAGS="KS"
 S MASTER=1
 I $$DUPLMSTR^XTIDTERM(CTX("TERM FILE#"),CTX("TERM FIELD#"),VUID) D
 . S MASTER=0
 S FILE=CTX("SOURCE FILE#")
 S SFILE=CTX("TERMSTATUS SUBFILE#")
 S MYFDA(FILE,"+1,",.01)=CTX("TERM FILE#")
 S MYFDA(FILE,"+1,",.02)=CTX("TERM FIELD#")
 S MYFDA(FILE,"+1,",.03)=TIREF
 S MYFDA(FILE,"+1,",99.99)=VUID
 S MYFDA(FILE,"+1,",99.98)=MASTER
 D UPDATE^DIE(FLAGS,"MYFDA","MYIEN","MSG")
 S:'$D(MSG("DIERR")) SUCCESS=1
 ; success, build TERM and return
 Q SUCCESS
 ;
SRCHTRMS(CTX,VUID,XTSARR,MASTER) ; search term index entries
 ; called from SEARCH^XTIDCTX(CTX,VUID,XTCARR,MASTER)
 N DIERR,FILE,XTC,FIELD
 S VUID=$G(VUID),MASTER=+$G(MASTER)
 Q:$G(CTX("TYPE"))'="SET"!('VUID)
 S FILE=$G(CTX("TERM FILE#"))
 S FIELD=$G(CTX("TERM FIELD#"))
 ; search in ^XTID(8985.1,"C",VUID,FILE,FIELD,FLAG,IEN)=""
 Q:'$D(^XTID(8985.1,"C",VUID))
 M XTC=^XTID(8985.1,"C",VUID)
 ; search everywhere
 I FILE="" D  Q
 . F  S FILE=$O(XTC(FILE)) Q:'FILE  D L1
 ;
 I FILE,FIELD="" D L1 Q
 I FILE,FIELD D L2 Q
 ;
 Q
 ;
L1 ;
 N FIELD
 S FIELD="" F  S FIELD=$O(XTC(FILE,FIELD)) Q:'FIELD  D L2
 Q
 ;
L2 ;
 N IEN,MSTR,IREF,STATUS
 S MSTR="" F  S MSTR=$O(XTC(FILE,FIELD,MSTR)) Q:MSTR=""  D
 . S IEN=0 F  S IEN=$O(XTC(FILE,FIELD,MSTR,IEN)) Q:'IEN  D
 . . I MASTER,MSTR=0 Q
 . . S IREF=$P($G(^XTID(8985.1,IEN,0)),"^",3)
 . . S STATUS=$$GETSTAT^XTID(FILE,FIELD,IREF,"")
 . . S STATUS=STATUS_"^"_MSTR
 . . D ADDTARRY^XTIDCTX(XTSARR,FILE,FIELD,IREF,STATUS)
 . ;
 ;
 Q
 ;
GETIENS(TIREF) ; find term's ien/IENS
 ; find term entry and return IENS
 ; $$FIND1^DIC(FILE,IENS,FLAGS,[.]VALUE,[.]INDEXES,.SCREEN,MSG_ROOT)
 N DIERR,FILE,FLAGS,INDEXES,MSG,RIEN,VALUE
 S FILE=CTX("SOURCE FILE#"),FLAGS="KQX",INDEXES="",RIEN=""
 S VALUE(1)=CTX("TERM FILE#")
 S VALUE(2)=CTX("TERM FIELD#")
 S VALUE(3)=TIREF
 ; get record IEN
 ;S RIEN=$$FIND1^DIC(FILE,"",FLAGS,.VALUE,INDEXES,"","MSG")
 S RIEN=$O(^XTID(FILE,"B",VALUE(1),VALUE(2),VALUE(3),0))
 Q:RIEN RIEN_","
 Q RIEN
 ;
MEMBER(FILE,FIELD,VALUE) ; valid member in "set of codes"?
 ; validate VALUE for this FIELD
 ; for validation purposes only, RESULT not used
 ; D VAL^DIE(FILE,IENS,FIELD,FLAGS,VALUE,.RESULT,FDA_ROOT,MSG_ROOT)
 N DIERR,FLAGS,IENS,MSG,RESULT,SUCCESS
 S SUCCESS=0
 S FLAGS="U",IENS="+1,"
 D VAL^DIE(CTX("TERM FILE#"),IENS,CTX("TERM FIELD#"),FLAGS,VALUE,.RESULT,"","MSG")
 S:'$D(MSG("DIERR")) SUCCESS=1
 Q SUCCESS
 ;
