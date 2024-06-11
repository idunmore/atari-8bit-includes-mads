; BASIC.asm - Definitions for Atari BASIC cartridge Vectors, Pointers,
;             variables tables, procedure stack and flags.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Do NOT try and apply these definitions if they are already defined.
.ifndef _BASIC_

; Sentinel to allow detection of prior INCLUSION
.def _BASIC_

; Atari BASIC makes use of the top half of page zero, which is reserved for
; cartridge usage (with some locations for the floating-point package, which
; are provided in OS.asm).

LOMEM  = $80 ; [WORD] Start of BASIC memory; first 256 bytes are reserved for
             ;        the token output buffer.  (See MEMLO, OS.asm).

; VNTP [WORD] Variable NAME Table pointer:
;
; Start address of the variable NAME table.  Variables NAMES are stored in the
; *order they are input* (first created) in your program, in ATASCII format.
;
; Upto 128 variable names are available, which are stored as tokens representing
; the variable NUMBER in the tokenized BASIC program, numbered from $80 to $FF
; (128 to 255).  Once created, unused variable names are NOT removed from this
; table; to remove them you can LIST the program to a file, do a NEW, then use
; ENTER to reload it.  Unlike LOAD/SAVE, LIST/ENTER only store the tokenized
; program, not all the associated tables (which are recreated upon ENTER) - so
; they get recreated with only the variables that are actually used.
;
; Variable names, in the tokenized program are represented as:
;
;   Scalar (numeric) - The MSB is set on the last character in the name.
;   Strings          - The last character is a $, with the MSB set.
;   Arrays           - The last character is a (, with the MSB set.
;
; Setting the MSB causes the character to display in inverse video, and thus
; makes it easy to see the start/end of variables in the tokenized program.

VNTP   = $82 ; [WORD] Variable NAME Table pointer.
VNTD   = $84 ; [WORD] Variable NAME Table End pointer (points to a zero/dummy
             ;        byte, that's byte AFTER the last byte of the VNTP table).

; VVTP [WORD] Variable VALUE Table pointer:
;
; Each variable is allocated 8 bytes in the table, which are used as follows:
;
;                Byte # 1     2     3     4     5     6     7     8
; Variable Type:
;------------------------------------------------------------------
; Numeric (Scalar)    $00  Var#     Six-byte BCD value
; Array;  DIMed       $41  Var#     Offset      first       second                             
;       unDIMed       $40           from        DIM + 1     DIM + 1
;                                   STARP
; String; DIMed       $81  Var#     Offset      length      DIM
;       unDIMed       $80           from
;                                   STARP
; 
; For Scalar (undimensioned numeric) variables, bytes three to eight are the
; FP number; byte three is the exponent; byte four contains the least
; significant two decimal digits, and byte eight contains the most significant
; two decimal digits.
;
; For array and string variables, bytes three and four contain the offset
; (LSB/MSB) into the string/array table (see STARP) for the array/string data.
; 
; In array variables, bytes five and six contain the size plus one of the first
; dimension of the array (DIM + 1; LSB/MSB), and bytes seven and eight contain
; the size plus one of the second dimension (the second DIM + 1; LSB/MSB).
;
; In string variables, bytes five and six contain the current length of the
; variable (LSBIMSB), and bytes seven and eight contain the actual dimension
; (up to 32767).

VVTP   = $86 ; [WORD] Variable VALUE Table pointer.

; STMTAB - [WORD] BASIC statement table pointer.
;
; The beginning of the user's BASIC program, containing all the tokenized lines
; of code plus the immediate mode lines entered by the user.
; 
; Line numbers are stored as two-byte integers, and immediate mode lines are
; given the default value of line 32768 ($8000). The first two bytes of a
; tokenized line are the line number, and the next is a dummy byte reserved for
; the byte count (or offset) from the start of this line to the start of the
; next line .  Following that is another count byte for the start of this line
; to the start of the next statement. These count values are set only when
; tokenization for the line and statement are complete.
; 
; Tokenization takes place in a 256 byte ($100) buffer that resides at the end
; of the reserved OS RAM at LOMEM.

STMTAB = $88 ; [WORD] BASIC Statement Table pointer; start of user's program.
STMCUR = $8A ; [WORD] Current Statement pointer; tokens currently being
             ;        processed within a line in the Statement Table (STMTAB).

; STARP - [WORD] String/Array Table pointer.
;
; The address for the string and array table and a pointer to the end of the
; BASIC program.
;
; Arrays are stored as six-byte binary-coded decimal numbers (BCD) while string
; characters use one byte each. String addresses in this table are the
; same as those returned by the BASIC ADR function.

STARP  = $8C ; [WORD] String/Array Table pointer.

; RUNSTK - [WORD] Runtime Stack pointer; holds entries for GOSUB and FOR/NEXT.
;
; As a STACK, entries are added in the order they occur, allowing for nested
; statements, and POPPED off the stack as they are completed.
;
; GOSUB entires are four bytes long.  The first byte is a ZERO ($00) to indicate
; a GOSUB.  The the next bytes form a two-byte integer of the line number on
; which the GOSUB occured.  The fourth byte is the offset INTO that line, so
; that the program can return to the correct point in the line upon RETURN.
;
; FOR/NEXT entries are 16 bytes long.
;
; Bytes 1-6 are the LIMIT value for the loop (the TO value in the FOR statement)
; in 6-byte BCD format.  Bytes 7-13 are the STEP value in 6-byte BCD format.
; Byte 13 is the counter VARIABLE number (index into VNTP). Bytes 14-15 are the
; line number of the FOR statement. Byte 16 is the offset into that line for
; the FOR statement.

RUNSTK = $8E ; [WORD] Runtime Stack pointer; holds entries for GOSUB & FOR/NEXT.

; MEMTP is officially called MEMTOP in Atari BASIC, however this conflicts with
; MEMTOP which is the OS variable that holds the top of system memory, so MEMTP
; is used as an alias.

MEMTP = $90 ; [WORD] End of memory used by the BASIC program area.

.ifndef _OS_

; If OS.asm is NOT included, we can also define MEMTOP for BASIC.
MEMTOP = $90 ; [WORD] End of memory used by the BASIC program area.

.endif ; _OS_

STOPLN = $BA ; [WORD] Line number where program execution stopped either due to
             ;        the BREAK key, a STOP or TRAP statement or an error.

PROMPT = $C2 ; [BYTE] Input Prompt Character (ATASCII)
ERSAVE = $C3 ; [BYTE] Error Code for STOP or TRAP
COLOR  = $C8 ; [BYTE] Color for PLOT or DRAWTO
PTABW  = $C9 ; [BYTE] TAB width in characters

; $CB-$CF are unused by Atari BASIC or the Atari Assembler/Editor
; $D0-$D1 are unused by Atari BASIC
; $D2-$D3 are RESERVED for BASIC or other cartridges

.endif ; _BASIC_
