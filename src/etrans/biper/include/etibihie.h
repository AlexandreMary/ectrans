INTERFACE
SUBROUTINE ETIBIHIE(KDLON,KDGL,KNUBI,KDLUX,KDGUX,&
 & KSTART,KDLSM,PGPBI,LDBIX,LDBIY,KDADD)  

USE PARKIND1  ,ONLY : JPIM     ,JPRB

IMPLICIT NONE

INTEGER(KIND=JPIM),INTENT(IN)               :: KNUBI
INTEGER(KIND=JPIM),INTENT(IN)               :: KSTART
INTEGER(KIND=JPIM),INTENT(IN)               :: KDLSM 
INTEGER(KIND=JPIM),INTENT(IN)               :: KDLON 
INTEGER(KIND=JPIM),INTENT(IN)               :: KDGL 
INTEGER(KIND=JPIM),INTENT(IN)               :: KDLUX 
INTEGER(KIND=JPIM),INTENT(IN)               :: KDGUX 
INTEGER(KIND=JPIM),INTENT(IN)               :: KDADD
REAL(KIND=JPRB),INTENT(INOUT)               :: PGPBI(KSTART:KDLSM+KDADD,KNUBI,1:KDGL+KDADD) 
LOGICAL,INTENT(IN)                          :: LDBIX 
LOGICAL,INTENT(IN)                          :: LDBIY 

END SUBROUTINE ETIBIHIE
END INTERFACE