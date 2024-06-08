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

; Do NOT try and apply these definitions if they are already defined.
.ifndef _DISPLAY_LIST_

; Sentinel to allow detection of prior INCLUSION
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

; Jumps/End of Display List

DL_JUMP =    $01 ; JMP to new address (reloads ANTIC's program counter)
DL_JUMP_VB = $41 ; JMP to top of dislplay list and wait for Vertical Blank

; Options and Masks
;
; MASKs (e.g., MASK_DL_DLI) are ANDed with the DL opcode to DISABLE the option.

MASK_DL_DLI     = %01111111 ; Display List Interrupt on last scan line of graphics line
MASK_DL_LMS     = %10111111 ; Load Memory Scan address for this graphics line
MASK_DL_VSCROLL = %11011111 ; Vertical scrolling for this graphics line
MASK_DL_HSCROLL = %11101111 ; Horizontal scrolling for this graphics line

; BIT FLAGs (e.g., DL_DLI) are ORed with the DL opcode to ENABLE the option.

DL_DLI     = %10000000 ; Display List Interrupt on last scan line of graphics line
DL_LMS     = %01000000 ; Load Memory Scan address for this graphics line
DL_VSCROLL = %00100000 ; Vertical scrolling for this graphics line
DL_HSCROLL = %00010000 ; Horizontal scrolling for this graphics line

; ANTIC Graphics Modes

; Number of columns/pixels assumes PLAYFIELD WIDTH is NORMAL.  If NARROW, then
; reduce by 20% (e.g., 40 cols becomes 32 cols, 20 cols becomes 16 cols).  If
; WIDE, then increase by 20% (e.g., 160 pixels becomes 192 pixels).
;
; Display limitations/overscan will result in less VISIBLE columns/pixels in
; WIDE mode than the theoretical maximum.

; ANTIC Text Modes

DL_TEXT_2 = $02 ; 1.5 colors, 40 cols x 8 scan Lines - 40 bytes/line
DL_TEXT_3 = $03 ; 1.5 colors, 40 cols x 10 scan Lines - 40 bytes/line
DL_TEXT_4 = $04 ; 4/5 colors, 40 cols x 8 scan lines - 40 bytes/line
DL_TEXT_5 = $05 ; 4/5 colors, 40 cols x 16 scan lines - 40 bytes/line
DL_TEXT_6 = $06 ; 5 colors, 20 cols x 8 scan lines - 20 bytes/line
DL_TEXT_7 = $07 ; 5 colors, 20 cols x 16 scan lines - 20 bytes/line

; ANTIC Bit-Mapped Modes
DL_BITMAP_8 = $08 ; 4 color, 40 pixels x 8 scan lines - 10 bytes/line
DL_BITMAP_9 = $09 ; 2 color, 80 pixels x 4 scan lines - 10 bytes/line
DL_BITMAP_A = $0A ; 4 color, 80 pixels x 4 scan lines - 20 bytes/line
DL_BITMAP_B = $0B ; 2 color, 160 pixels x 2 scan lines - 20 bytes/line
DL_BITMAP_C = $0C ; 2 color, 160 pixels x 1 scan lines - 20 bytes/line
DL_BITMAP_D = $0D ; 4 color, 160 pixels x 2 scan lines - 40 bytes/line
DL_BITMAP_E = $0E ; 4 color, 160 pixels x 1 scan lines - 40 bytes/line
DL_BITMAP_F = $0F ; 1.5 color, 320 pixels x 1 scan lines - 40 bytes/line
                  ; also used for GTIA modes, with GTIA priority setting.

; BASIC Graphics Modes

; The various labels here are referenced to the Atari BASIC "GRAPHICS" command,
; and mapped to the ANTIC mode values as used by the actual display list.

DL_BASIC_0 = DL_TEXT_2
DL_BASIC_1 = DL_TEXT_6
DL_BASIC_2 = DL_TEST_7
DL_BASIC_3 = DL_BITMAP_8
DL_BASIC_4 = DL_BITMAP_9
DL_BASIC_5 = DL_BITMAP_A
DL_BASIC_6 = DL_BITMAP_B
DL_BASIC_7 = DL_BITMAP_D
DL_BASIC_8 = DL_BITMAP_F
DL_BASIC_9 = DL_BITMAP_9 ; Requires GTIA priority mode 
DL_BASIC_A = DL_BITMAP_A ; Graphics 10 - Requires GTIA priority mode
DL_BASIC_B = DL_BITMAP_B ; Graphics 11 - Requires GTIA priority mode

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

; Display List MODE Macros/Instructions

; DL_MODE - Sets the ANTIC display mode for the current graphics line.
;
; Allows raw MODE values, as well as modes with DL_DLI, DL_LMS, DL_VSCROLL and
; DL_HSCROLL options applied (e.g., DL_TEXT_2 | DL_DLI | DL_LMS).

.macro DL_MODE mode
        ; Sanity/error checking.
	.if :0 != 1
		.error "ERROR: DL_MODE requires a mode value"
	.endif

        ; Valid modes are $02-$0F, so mask off the high nybble ... so we can
        ; validate the range of modes, without worrying about other mode options
        ; (i.e., DL_DLI, DL_LMS, DL_VSCROLL and DL_HSCROLL)
        ?value = [:mode & $0F]
        .if ?value < DL_TEXT_2 || ?value > DL_BITMAP_F
                .error "ERROR: DL_MODE invalid mode (must be $02-$0F): ", :1
        .endif
        
        ; :mode is now undisturbed, but validated, so outputting mode as passed
        ; preserves other options.
        MacroDebugPrint "DL_MODE: ", :mode

	.byte	:mode   ; Output a BYTE for the Display list mode instruction
.endm

; Display List MODE and LMS Macros/Instructions

; These macros all deal with MODES that have the DL_LMS bit set.  These require
; both a MODE instruction/value and the new address for screen memory to be read
; from (the Memory Scan Address).

; DL_LMS_MODE_ADDR - Creates a MODE line with its LMS bit set, and an LMS
;                    address WORD following it.
;
; This is used when you don't need to manipulate the LMS Address after building
; the MODE line (or don't care about have to do math on labels to do so; see
; DL_LMS_MODE and DL_LMS_ADDR for details).

.macro DL_LMS_MODE_ADDR mode, address
        ; Sanity/error checking.
        .if :0 != 2
                .error "ERROR: DL_LMS_MODE_ADDR requires a mode and address"
        .endif
        
        MacroDebugPrint "DL_LMS_MODE_ADDR: mode:", :mode
        MacroDebugPrint "DL_LMS_MODE_ADDR: address:", :address

        ; Use DL_LMS_MODE and DL_LMS_ADDR to output the MODE and address.
	DL_LMS_MODE :mode
        DL_LMS_ADDR :address
.endm

; DL_LMS_MODE - Creates a MODE line with its LMS bit set.
;
; Outputs JUST an ANTIC mode instruction with its LMS bit set.  This is used
; when you want to manipulate the LMS Address after building the MODE line,
; (e.g., for scrolling).  Follow this instruction with a DL_LMS_ADDR call.

; Example Usage:
;
;       DL_LMS_MODE DL_TEXT_2
; scrollAddress
;       DL_LMS_ADDR scroll_data
;
; Referencing scroll_address can now be done *directly* vs. using:
;
; scrollAddress
;      DL_LMS_MODE_ADDR DL_TEXT_2, scroll_data
;      ...
;      scrollAddress + 1 = lowAddress
;      scrollAddress + 2 = highAddress

.macro DL_LMS_MODE mode
        ; Sanity/error checking.
	.if :0<>1
		.error "ERROR: DL_LMS_MODE requires graphics mode"
	.endif
       
        MacroDebugPrint "DL_LMS_MODE: ", [:mode | DL_LMS]

        ; Output the DL_MODE instruction with the DL_LMS bit set.  Doesn't
        ; matter if the mode already has the DL_LMS bit set.	
	DL_MODE [:mode | DL_LMS]
.endm


; DL_LMS_ADDR - Write an ADDRESS WORD for a preceding DL_LMS_MODE (MODE line
;               with its LMS bit set.)
;
; See DL_LMS_MODE for details on how to use this macro.

.macro DL_LMS_ADDR address
        ; Sanity/error checking.
	.if :0<>1
		.error "ERROR: DL_LMS_ADDR requires LMS address"
	.endif
       
        MacroDebugPrint "DL_LMS_ADDR: ", :address

	.word :address ; Ouput a WORD for the Memory Scan Address
.endm

; Display List JUMP Macros/Instructions

; Both JUMP instructions should be followed by a 2-byte address.  

; DL_JMP - Jump to new address (over a 1KB boundary) and reload ANTIC's
;          program counter.
;
; DL_JMP is usually used to allow splitting a display list across a 1KB boundary
; as ANTIC's address regiser is only 10 bits wide (1KB or 1024 byts).  Thus,
; this typically points to a continuation of a display lists.  Use is uncommon,
; as display lists are usually very short.  Usually the product of very tight
; memory constraints.

.macro DL_JMP displayListAddress
        ; Sanity/error checking.
        .if 0: != 1
                .error "DL_JMP: Display List address required"
        .endif
        
        MacroDebugPrint "DL_JMP: ", :displayListAddress

        ; Output DL_JUMP instruction and operand

	.byte DL_JUMP             ; ANTIC JMP instruction
	.word :displayListAddress ; Address to jump to
.endm

; DL_JVB - Jump to top of dislplay list and wait for Vertical Blank.
;
; This is the most common way to end a display list.  It reloads ANTIC's
; program counter with the address of the top of the display list, and waits
; for the next Vertical Blank.

.macro DL_JVB displayListAddress
	; Sanity/error checking.
        .if 0: != 1
                .error "DL_JVB: Display List address required"
        .endif
        
        MacroDebugPrint "DL_JVB: ", :displayListAddress

        ; Output DL_JVB instruction and operand

	.byte DL_JVB              ; ANTIC JVB instruction
	.word :displayListAddress ; Address to jump to
.endm

.endif ; _DISPLAY_LIST_
