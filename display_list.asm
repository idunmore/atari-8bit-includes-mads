; display_list.asm - Display List Macros, Related ANTIC Registers & Values
;                    for the MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Contains a subset of ANTIC registers and values (as defined in ANTIC.asm)
; that relate specifically to display lists.

; Sentinel to allow other files to detect if this file is already INCLUDEd.
DISPLAY_LIST = $01

; Do NOT define these labels if ANTIC.asm is already included.
.ifndef ANTIC

; Hardware Registers - Display List Specific

DLISTL = $D402 ; Display List (Low Byte)
DLISTH = $D403 ; Display List (High Byte)

; Shadow Registers - Display List Specific

SDLSTL = $0230 ; DLISTL
SDLSTH = $0231 ; DLISTH

.endif ; ANTIC
