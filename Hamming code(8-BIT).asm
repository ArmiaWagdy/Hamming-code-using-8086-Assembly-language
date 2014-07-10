
                       ;***************************************;
                       ;*Name: Armia Wagdy Tawfik Badros Ghali*;
                       ;*Sec.: 2                              *;
                       ;*Seat number: 43                      *;
                       ;*Project no. 3                        *;
                       ;***************************************;
.MODEL SMALL
.STACK 64   
;*****************************************

            .DATA
DATA1  DB 'Enter your 8-BIT DATA in binary: ','$'  
DATA2  DB  9,?,9 DUP(?)   
DATA3  DB 'EROR:Your data must contain ONES and ZEROS ONLY','$'
DATA4  DB  00H                                                                                                                                 
DATA5  DB '---------------------------------------------------------------','$'
DATA6  DB 'EROR:THE Data must be 8-BIT BINARY','$'
DATA7  DB '0'              
DATA8  DB '1'
DATA9  DB  ?
DATA10 DB  ? 
DATA11 DB 'Your DATA including HAMMING CODE is : ','$'
DATA12 DB ?,?,?,?,?,?,?,?,?,?,?,?,?   
DATA13 DB 'Enter your DATA inculding HAMMING CODE in BINARY : ','$'
DATA14 DB  13,?,13 dup(?) 
DATA15 DB 'EROR:Your data must contain 0 or 1 only (BINARY NUMBERS)','$'
DATA16 DB 'EROR:Your data must be 12-bit binary','$'                      
DATA17 DB 00H                                     
DATA18 DB 00H,00H,24H                      
DATA19 DB 'YOUR DATA IS RIGHT, THERE IS NO EROR','$'
DATA20 DB 01H,00H,02H,00H,03H,00H,04H,00H,05H,00H,06H,00H,07H,00H,08H,00H,09H,00H,0AH,00H,0BH,00H,0CH,00H,30H,31H,30H,32H,30H,33H,30H,34H
DATA21 DB 30H,35H,30H,36H,30H,37H,30H,38H,30H,39H,31H,30H,31H,31H,31H,32H
DATA22 DB 'There is an eror in bit number: ','$'
DATA23 DB 'WHAT DO YOU WANT','$'
DATA24 DB '(1) Generate HAMMING CODE','$'
DATA25 DB '(2) Check your DATA including HAMMING CODE','$' 
DATA26 DB 2,?,2 DUP(?)  
DATA27 DB 'Your Choice is: ','$'
DATA28 DB 'EROR: You must choose 1 or 2','$' 
DATA29 DB 'Please,Wait a moment...','$'   
DATA30 DB 'EROR:The DATA must be 12-BIT BINARY','$'            
;*****************************************
             .CODE
MAIN         PROC FAR   
;*****************************************    
             MOV AX,@DATA
             MOV DS,AX
             MOV ES,AX                                     
             MOV BP,OFFSET DATA4
;*****************************************              
START:       CALL NEWLINE                ; Set cursor to new line
             CALL ENTRY                  ; What do you want?! (Generate/Check)
             CALL CHECKNO                ; Check the number if 1 or 2 --> correct, else -->eror1
             CALL WHICHCHOICE            ; If one is pressed --> GENERATR, If two --> CHECK
;*****************************************             
GENERATE:    CALL NEWLINE                ; Set cursor to new line
             CALL ENTRY1                 ; Enter your 8-bit data in binary
             CALL GET_INPUT              ; Get input from user
             CALL NO_LENGTH              ; Check if the data is smaller than 8bit, if it is true --> eror2
             CALL CHECK_BINARY           ; Check if the data ones and zeros only or not, if not --> eror3
             CALL PUTINAH                ; Handle data in AH
             CALL P1                     ; Generate P1
             CALL P2                     ; Generate P2
             CALL P3                     ; Generate P3
             CALL P4                     ; Generate P4
             CALL NEWLINE                ; Set cursor to new line
             CALL OUTPUT                 ; Handle data and hamming code in location in memory
             CALL PUTINMEMORY            ; Convert ones and zeros to ASCII (30,31) and put them in memory
             CALL DISPLAY                ; Display your data on screen
             CALL LINE                   ; Drow line  
             JMP START
;*****************************************
CHECK:       CALL NEWLINE
             CALL ENTRY2  
             CALL GETINPUT2   
             CALL NOLENGTH2
             CALL CHECKBINARY2
             CALL PUTINAX
             CALL HANDLING
             CALL P1 
             CALL CHECK1
             CALL P2
             CALL CHECK2 
             CALL P3
             CALL CHECK3 
             CALL P4
             CALL CHECK4  
             CALL IFRIGHT
             CALL DISPLAY2
             JMP START   
;*****************************************            
EROR_2:      CALL EROR2
RIGHT_:      CALL RIGHT
NOEROR2:     CALL EROR4 
;*****************************************        
HALT:        MOV AH,4CH                  ;Halt
             INT 21H
MAIN         ENDP
;***************************************** 
NEWLINE      PROC 
             MOV AH,02H
             MOV BH,00
             MOV DL,00
             MOV DH,DS:[BP]   ;coloumn   ;row
             INT 10H
             ADD DS:[BP],1
             RET
NEWLINE      ENDP
;*****************************************
ENTRY        PROC 
             MOV AH,09H
             MOV DX,OFFSET DATA23
             INT 21H
             CALL NEWLINE 
             MOV AH,09H
             MOV DX,OFFSET DATA24
             INT 21H
             CALL NEWLINE
             MOV AH,09H
             MOV DX,OFFSET DATA25
             INT 21H
             CALL NEWLINE  
             MOV AH,09H
             MOV DX,OFFSET DATA27
             INT 21H
             MOV AH,0AH
             MOV DX,OFFSET DATA26
             INT 21H  
             RET
ENTRY        ENDP                         
;***************************************** 
CHECKNO      PROC
             LEA BX,DATA26+2
             CMP [BX],31H
             JZ  RETURN2
             CMP [BX],32H
             JZ  RETURN2
             CALL EROR1
RETURN2:     CALL LINE
             RET
CHECKNO      ENDP
;****************************************** 
WHICHCHOICE  PROC 
             LEA BX,DATA26+2
             CMP [BX],31H
             JZ  GENERATE
             CMP [BX],32H
             JZ  CHECK
             JMP START
             RET
WHICHCHOICE  ENDP             
;******************************************
ENTRY1       PROC
             MOV AH,09H
             MOV DX,OFFSET DATA1
             INT 21H
             RET
ENTRY1       ENDP 
;*****************************************
GET_INPUT    PROC
             MOV AH,0AH
             MOV DX,OFFSET DATA2 
             INT 21H
             CALL WAITING
             RET
GET_INPUT    ENDP
;*****************************************
NO_LENGTH    PROC
             LEA SI,DATA2+1
             CMP [SI],08H
             JNZ EROR_2 
             RET       
NO_LENGTH    ENDP 
;*****************************************                                    
CHECK_BINARY PROC
             LEA SI,DATA2+2
             DEC SI  
             MOV CX,09H     
AGAIN2:      DEC CX
             INC SI 
             CMP CX,00H
             JZ RETURN
             CMP [SI],30H
             JZ AGAIN2
             CMP [SI],31H
             JZ AGAIN2                
             CALL EROR3
RETURN:      RET
CHECK_BINARY ENDP             
;*****************************************
PUTINAH      PROC   
             LEA SI,DATA2+2
             MOV CX,0008H
AGAIN:       SUB [SI],30H
             INC SI
             LOOPNZ AGAIN 
             SUB SI,08H
             SHL [SI],7
             SHL [SI+1],6
             SHL [SI+2],5
             SHL [SI+3],4
             SHL [SI+4],3
             SHL [SI+5],2
             SHL [SI+6],1            
             MOV AH,[SI]
             OR  AH,[SI+1]
             OR  AH,[SI+2]
             OR  AH,[SI+3]
             OR  AH,[SI+4]
             OR  AH,[SI+5]
             OR  AH,[SI+6]
             OR  AH,[SI+7]
             MOV BX,OFFSET DATA7
             MOV [BX],AH              
             RET
PUTINAH      ENDP         
;*****************************************
;generating the first bit of hamming code
P1           PROC
             MOV DH,AH
             MOV BH,AH
             MOV CH,AH
             MOV BL,AH
             MOV CL,AH
             SHR BH,1
             SHR CH,3
             SHR BL,4
             SHR CL,6
             AND AH,01H
             AND BH,01H
             AND CH,01H
             AND BL,01H
             AND CL,01H
             XOR AH,BH
             XOR AH,CH
             XOR AH,BL
             XOR AH,CL
             MOV AL,AH
;            CALL NEWLINE
;            CALL OUTPUT
             RET
P1           ENDP   
;*****************************************
;generating the second bit of hamming code  
P2           PROC 
             MOV AH,DH
             MOV BH,AH
             MOV CH,AH
             MOV BL,AH
             MOV CL,AH
             SHR BH,2
             SHR CH,3
             SHR BL,5
             SHR CL,6
             AND AH,01H
             AND BH,01H
             AND CH,01H
             AND BL,01H
             AND CL,01H
             XOR AH,BH
             XOR AH,CH
             XOR AH,BL
             XOR AH,CL
;            MOV AL,AH
;            CALL OUTPUT
             SHL AH,1
             OR  AL,AH 
             RET
P2           ENDP
;*****************************************
;generating the third bit of hamming code
P3           PROC          
             MOV AH,DH
             MOV BH,AH
             MOV CH,AH
             MOV BL,AH
             SHR AH,1
             SHR BH,2
             SHR CH,3
             SHR BL,7
             AND AH,01H
             AND BH,01H
             AND CH,01H
             AND BL,01H
             XOR AH,BH
             XOR AH,CH
             XOR AH,BL
;            MOV AL,AH
;            CALL OUTPUT
             SHL AH,2
             OR  AL,AH 
             RET
P3           ENDP
;*****************************************
P4           PROC 
             MOV AH,DH
             MOV BH,AH
             MOV CH,AH
             MOV BL,AH
             SHR AH,4
             SHR BH,5
             SHR CH,6
             SHR BL,7
             AND AH,01H
             AND BH,01H
             AND CH,01H
             AND BL,01H
             XOR AH,BH
             XOR AH,CH
             XOR AH,BL 
;            MOV AL,AH
;            CALL OUTPUT
             SHL AH,3
             OR  AL,AH     
             MOV BX,OFFSET DATA8
             MOV [BX],AL 
             RET    
P4           ENDP 
;***************************************** 
OUTPUT       PROC
             MOV DX,00H 
             MOV BX,OFFSET DATA7      ;DATA
             MOV CH,[BX]              ;DATA
             MOV BX,OFFSET DATA8      ;HAMMING CODE 
             MOV BL,[BX]              ;HAMMING CODE  
             AND BL,03H
             OR  DL,BL                ;P1,P2
             AND CH,01H
             SHL CH,2
             OR DL,CH                 ;X3
             MOV BX,OFFSET DATA8      ;HAMMING CODE 
             MOV BL,[BX]              ;HAMMING CODE
             AND BL,04H               
             SHL BL,1
             OR DL,BL                 ;P4  
             MOV BX,OFFSET DATA7      ;DATA
             MOV CH,[BX]              ;DATA
             AND CH,0EH
             SHL CH,3
             OR DL,CH                 ;X5,X6,X7 
             MOV BX,OFFSET DATA8      ;HAMMING CODE 
             MOV BL,[BX]              ;HAMMING CODE
             AND BL,08H 
             SHL BL,4
             OR DL,BL                 ;P8   
             MOV BX,OFFSET DATA7      ;DATA
             MOV CH,[BX]              ;DATA
             AND CH,0F0H  
             SHR CH,4
             OR DH,CH                 ;X9,X10,X11,X12        
;             ROR DX,8
;             ROR DH,4
;             ROR DL,4
             MOV BX,OFFSET DATA9
             MOV [BX],DL
             MOV BX,OFFSET DATA10
             MOV [BX],DH
             RET 
OUTPUT       ENDP
;*****************************************
PUTINMEMORY  PROC
             MOV AL,01H
             MOV BX,OFFSET DATA12+12
             MOV CH,12 
             ;DEC BX 
             MOV CL,00H
AGAIN4:      MOV DI,OFFSET DATA9
             MOV DX,[DI]
             ;SHL DX,4
             SHR DX,CL
             DEC BX
             AND DX,AX
             MOV [BX],DL
             ADD [BX],30H
             ADD CL,1
             DEC CH 
             CMP CH,00H
             JNZ AGAIN4 
             CMP CH,00H 
             MOV BX,OFFSET DATA12
             MOV [BX+12],24H
             RET
PUTINMEMORY  ENDP                           
;*****************************************  
DISPLAY      PROC
             MOV AH,09H
             MOV DX,OFFSET DATA10
             INT 21H
             MOV AH,09H
             MOV DX,OFFSET DATA12
             INT 21H
             RET
DISPLAY      ENDP
;***************************************** 
LINE         PROC                        ;----------------------------------------
             CALL NEWLINE
             MOV AH,09H
             MOV DX,OFFSET DATA5
             INT 21H
             RET
LINE         ENDP    
;*****************************************
WAITING      PROC
             CALL NEWLINE
             MOV AH,09H
             MOV DX,OFFSET DATA29
             INT 21H
             RET
WAITING      ENDP
;*****************************************
EROR1        PROC                        ;'EROR: You must enter just 1 or 2'
             CALL NEWLINE
             MOV AH,09H
             MOV DX,OFFSET DATA28
             INT 21H
             RET
EROR1        ENDP
;******************************************
EROR2        PROC                    ;EROR:THE DATA MUST BE 8-BIT BINARY
             CALL NEWLINE
             MOV AH,09H
             MOV DX,OFFSET DATA6
             INT 21H  
             CALL LINE
             JMP START
             RET
EROR2        ENDP 
;*****************************************
EROR3        PROC                    ;Your data must contain ones and zeros only
             CALL NEWLINE
             MOV AH,09H
             MOV DX,OFFSET DATA3
             INT 21H
             CALL LINE
             JMP START
             RET
EROR3        ENDP  
;***************************************** 
EROR4        PROC                    ;EROR:THE DATA MUST BE 12-BIT BINARY
             CALL NEWLINE
             MOV AH,09H
             MOV DX,OFFSET DATA30
             INT 21H  
             CALL LINE
             JMP START
             RET
EROR4        ENDP 
;*****************************************
EROR5        PROC 
             CALL NEWLINE
             MOV AH,09H
             MOV DX,OFFSET DATA15
             INT 21H
             CALL LINE
             JMP START
             RET
EROR5        ENDP
;*****************************************
;**************************************************************************************************
ENTRY2       PROC
             MOV AH,09H
             MOV DX,OFFSET DATA13
             INT 21H
             RET
ENTRY2       ENDP      
;*****************************************
GETINPUT2    PROC
             MOV AH,0AH
             MOV DX,OFFSET DATA14
             INT 21H 
             CALL WAITING
             RET
GETINPUT2    ENDP
;***************************************** 
NOLENGTH2    PROC
             LEA SI,DATA14+1
             CMP [SI],12
             JNZ NOEROR2 
             RET       
NOLENGTH2    ENDP 
;*****************************************                                    
CHECKBINARY2 PROC
             LEA SI,DATA14+2
             DEC SI  
             MOV CX,13     
AGAIN5:      DEC CX
             INC SI 
             CMP CX,00H
             JZ RETURN3
             CMP [SI],30H
             JZ AGAIN5
             CMP [SI],31H
             JZ AGAIN5                
             CALL EROR5
RETURN3:     RET
CHECKBINARY2 ENDP  
;*****************************************
HANDLING     PROC  
             MOV DX,00H
             MOV CX,AX
             AND CX,0040H
             SHR CX,6
             OR DX,CX
             MOV CX,AX
             AND CX,0700H
             SHR CX,7
             OR DX,CX
             MOV CX,AX
             AND CX,0F000H
             SHR CX,8
             OR DX,CX 
             MOV AH,DL
             RET  
HANDLING     ENDP
;;*****************************************
PUTINAX     PROC
            LEA SI,DATA14+2
            MOV CX,000CH
AGAIN6:     SUB [SI],30H
            INC SI
            LOOPNZ AGAIN6 
            SUB SI,0CH
            SHL [SI],7
            SHL [SI+1],6
            SHL [SI+2],5
            SHL [SI+3],4
            SHL [SI+4],3
            SHL [SI+5],2
            SHL [SI+6],1            
            MOV AH,[SI]
            OR  AH,[SI+1]
            OR  AH,[SI+2]
            OR  AH,[SI+3]
            OR  AH,[SI+4]
            OR  AH,[SI+5]
            OR  AH,[SI+6]
            OR  AH,[SI+7]  
            SHL [SI+8],7
            SHL [SI+9],6
            SHL [SI+10],5
            SHL [SI+11],4
            MOV AL,[SI+8]
            OR AL,[SI+9]
            OR AL,[SI+10]
            OR AL,[SI+11]
            MOV BX,OFFSET DATA17
            MOV [BX],AX              
            RET
PUTINAX     ENDP
;***************************************** 
;Checking: p1 xor x3 xor x5 xor x7 xor x9 xor x11         
CHECK1       PROC
             MOV BX,OFFSET DATA17
             MOV CX,[BX] 
             AND CX,0010H
END:         SHR CX,4
             XOR AL,CL 
             RET
CHECK1       ENDP   
;*****************************************
;Checking: p2 xor x3 xor x6 xor x7 xor x10 xor x11  
CHECK2       PROC         
             MOV BX,OFFSET DATA17
             MOV CX,[BX] 
             AND CX,0020H
             SHR CX,4
             XOR AL,CL 
             RET
CHECK2       ENDP
;*****************************************
;Checking: p3 xor x5 xor x6 xor x7 xor x12 
CHECK3       PROC
             MOV BX,OFFSET DATA17
             MOV CX,[BX] 
             AND CX,0080H
             SHR CX,5
             XOR AL,CL  
             RET
CHECK3       ENDP
;*****************************************
;Checking: p4 xor x9 xor x10 xor x11 xor x12 
CHECK4       PROC
             MOV BX,OFFSET DATA17
             MOV CX,[BX] 
             AND CX,0800H
             SHR CX,8
             XOR AL,CL  
             RET    
CHECK4       ENDP                          
;***************************************** 
IFRIGHT      PROC
             CMP AL,00H
             JZ  RIGHT_
             RET
IFRIGHT      ENDP       
;*****************************************
RIGHT        PROC 
             CALL NEWLINE
             MOV AH,09H
             MOV DX,OFFSET DATA19
             INT 21H
             CALL LINE
             JMP START
             RET
RIGHT        ENDP
;*****************************************
DISPLAY2     PROC   
             MOV AH,00H   
             CLD   
             MOV CX,12
             MOV DI,OFFSET DATA20
             REPNE SCASW
             MOV SI,OFFSET DATA18
             MOV BX,[DI+22]
             MOV [SI],BX 
             CALL NEWLINE
             MOV AH,09H
             MOV DX,OFFSET DATA22
             INT 21H
             MOV AH,09H
             MOV DX,OFFSET DATA18
             INT 21H
             CALL LINE
             RET
DISPLAY2     ENDP
;*****************************************

             END MAIN               
             