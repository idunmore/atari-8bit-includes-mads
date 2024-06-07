; display_list.asm - Display List Macros, Related ANTIC Registers & Values
;                    for the MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Includes

        icl 'common.asm'
        icl 'macro_debugging.asm'

; Sentinel to allow other files to detect if this file is already INCLUDED.
.def _DISPLAY_LIST_

; Contains a subset of ANTIC registers and values (as defined in ANTIC.asm)
; that relate specifically to display lists.
;
; Do NOT define these labels if ANTIC.asm is already included.
.ifndef _ANTIC_

; Hardware Registers - Display List Specific

DLISTL = $D402 ; Display List (Low Byte)
DLISTH = $D403 ; Display List (High Byte)

; Shadow Registers - Display List Specific

SDLSTL = $0230 ; DLISTL
SDLSTH = $0231 ; DLISTH

.endif ; _ANTIC_

; DISPLAY LIST INSTRUCTIONS
;
; Options and Masks
;
; MASKs (e.g., MASK_DL_DLI) are ANDed with the DL opcode to DISABLE the option.
MASK_DL_DLI = %01111111 ; Display List Interrupt on last scan line of graphics line

; BIT FLAGs (e.g., DL_DLI) are ORed with the DL opcode to ENABLE the option.
DL_DLI = %10000000 ; Display List Interrupt on last scan line of graphics line


; ANTIC Graphics Modes

DL_TEXT_2 = $02 ; 1.5 colors, 40 cols x 8 scan Lines - 40 bytes/line

; BASIC Graphics Modes

; The various labels here are referenced to the Atari BASIC "GRAPHICS" command,
; and mapped to the ANTIC mode values as used by the actual display list.

DL_BASIC_0 = DL_TEXT_2

; BLANK scan lines - DL opcode is: (number of blank scan lines - 1) * $10

DL_BLANK_1 = $00 ; 1 Blank scan line
DL_BLANK_2 = $10 ; 2 Blank scan lines
DL_BLANK_3 = $20 ; 3 Blank scan lines
DL_BLANK_4 = $30 ; 4 Blank scan lines
DL_BLANK_5 = $40 ; 5 Blank scan lines
DL_BLANK_6 = $50 ; 6 Blank scan lines
DL_BLANK_7 = $60 ; 7 Blank scan lines
DL_BLANK_8 = $70 ; 8 Blank scan lines


; Display List Macros

; DL_TOP_OVERSCAN - Creates 24 initial blank lines, to defeat vertical overscan.
;
; Generally, display lists should start with 24 blank scan lines, implemented
; as 3x DL_BLANK_8 instructions.  This is to defeat the vertical overscan, and
; ensure what is displayed is visible on the screen, by bringing the start of
; the display down by 24 scan lines.
.macro DL_TOP_OVERSCAN
        DL_BLANK_LINES 24, 0 ; 24 blank scan lines, with DLIs disabled
.endm

; DL_BLANK_LINES - Creates a specified number of blank scan lines.
;
; Creates the specified number of blank scanlines, using the minimum number
; of ANTIC instructions possible.
;
; If :withDLI is true (1), then the DL_DLI bit is set in the DL opcode,
; otherwise it is cleared (disabled).
;
; If DLIs are required for EVERY scan line, rather than every blank scanline
; *instruction* then do NOT use this macro, and instead use individual
; DL_BLANK_n instructions.

.macro DL_BLANK_LINES numLines, withDLI
        ; Sanity/error checking.
        .if :numLines < 1 || :numLines > 240
                .error "ERROR: Invalid number of lines (1-240/$F0): ", :numLines
        .endif

        MacroDebugPrint "Total BLANK lines:", :numLines

        ; Division is integer/floor division, so if numLines is not an exact
        ; multiple of 8, the remaining lines will be handled separately.  So,
        ; we first handle the lines in multiples of 8 via DL_BLANK_8 opcodes.
        .rept [:numLines / 8]
                ; Handle the DL_DLI setting    
                .if :withDLI == TRUE
                        ?value = [DL_BLANK_8 | DL_DLI]
                .else
                        ?value = [DL_BLANK_8 & MASK_DL_DLI]
                .endif

                .byte ?value ; Output the DL opcode

                MacroDebugPrint "DL_BLANK_8:     ", ?value        
        .endr

        ; Handle any remaining lines
        ?remainingLines = :numLines - [[:numLines / 8] * 8]        
        .if ?remainingLines > 0
                .if :withDLI == TRUE
                        ?value = [[$10 * [?remainingLines - 1]] | DL_DLI]
                .else
                        ?value = [[$10 * [?remainingLines - 1]] & MASK_DL_DLI]
                .endif

                .byte ?value ; Output the DL opcode                
               
                MacroDebugPrint "DL_BLANK_OpCode:", ?value                
        .endif        
.endm
