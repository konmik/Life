; Borland TASM 3.0 DOS .COM

IDEAL
P286
MODEL TINY

CODESEG
ORG 100h

@StartUp:
  MOV  AL,13h         ;AX = 0013h
  INT  10h            ;SET 320*200*256
  PUSH 0A000h
  POP  DS             ;DS = Video
  MOV  DX,319

@Editor:
  XCHG [BX],DL        ;Out Cursor
  XOR  AX,AX
  INT  16h            ;ReadKey
  XCHG [BX],DL        ;Restore Life
  MOV  AL,AH

  DEC  BX             ;Left for else

  CMP  AL,4Dh         ;CMP with Rigth
  JE   Rigth
  JNG  NoDown
    ADD  BX,DX
  Rigth:
    INC  BX
    INC  BX
  NoDown:

  CMP  AL,48h         ;CMP with Up
  JNE  NoUp
    SUB  BX,DX
  NoUp:

  CMP  AL,39h         ;CMP with Space
  JNE  NoSpace
    INC  BX           ;No Left (may be destroyed for optimizing by 1 byte)
    XOR  [BX],DH
  NoSpace:

  CMP  AL,1Ch         ;CMP with Enter
  JL   @Exit
  JG   @Editor

@Life:
  MOV  DI,offset Buf-321 ;Anti-musor :-321
  MOV  SI,-321           ;Anti-musor :-321
@RepLife:
  MOV  BP,-1605       ;Begin of offset
  MOV  CL,3
  XOR  AX,AX
  RepIncer:
    ADD  AL,[BP+DI]
    INC  BP
    ADD  AL,[BP+DI]
    ADD  AL,[BP+DI+1]
    ADD  BP,DX        ;Down on one stroke
;    ADD  AL,[BP+DI]  ;this method for 8086 processor!!!
;    INC  BP          ;it is optimizing for 1 (one) byte
;    ADD  AX,[BP+DI]
;    ADD  BP,DX
  LOOP RepIncer
;  ADD  AL,AH

  INC  CX             ;CX = 1
  CMP  AL,4
  JE   NoPr
    CMP  AL,3
    JE   Lifing
      DEC  CX         ;CX = 0
    Lifing:
    MOV  [SI-1284],CL ;Lifing OR Killing
  NoPr:

  MOVSB
  CMP  DI,BP          ;CMP DI,65536-1605 +320*3
  JNE  @RepLife

  MOV  AH,1
  INT  16h            ;Pressed the Key ?
  JNZ  @Editor        ;Yes
  JZ   @Life          ;No

@Exit:
  MOV  AX,3
  INT  10h            ;Restore TXT 80*25*16
  RET

DATASEG
  BufBuf DB 460 DUP(?)
  Buf DB 64000 DUP(?)
END @StartUp