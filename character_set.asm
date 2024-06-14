; character_set.asm - Complete Character Set values for Atari 8-bit Computers
;                     for the MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Includes

        icl 'common.asm'
        icl 'macro_debugging.asm'

; Do NOT try and apply these definitions if they are already defined.
.ifndef _CHARACTER_SET_

; Sentinel to allow detection of prior INCLUSION
.def _CHARACTER_SET_

; ANTIC is responsible for the display of characters on the screen, and defines
; the various registers and controls for its display.  This file duplicates
; some basic register and control bit definitions for ANTIC so it can be used
; in isolation for custom character sets etc. without requiring the full set of
; ANTIC definitions.

; Do not define these symbols if ANTIC.asm has alerady been included.
.ifndef _ANTIC_

; ANTIC Character-Related Hardware Registers

CHACTL = $D401 ; Character display control
CHBASE = $D409 ; Character Set Base Address (Page Number/High Byte) as CHBASE
               ; must be on a 1K (1024 byte)/$400 boundary.

; ANTIC Character-Related Shadow Registers

CHBAS = $02F4 ; CHBASE
CHART = $02F3 ; CHACTL

; CHACTL - Character Display Control

; MASKs (e.g., CHACTL_REFLECT) are ANDed with the CHACTL setting to DISABLE
; the option.

MASK_CHACTL_REFLECT = %11111011 ; Disable Vertical Reflect
MASK_CHACTL_INVERSE = %11111101 ; Disable characters with High bit set displayed as inverse 
MASK_CHACTL_BLANK =   %11111110 ; Disable characters with High bit set displayed as blank space

; BIT FLAGs (e.g., CHACTL_REFLECT) are ORed with CHACTL setting to ENABLE the
; option.

CHACTL_REFLECT = %00000100 ; Enable vertical reflect
CHACTL_INVERSE = %00000010 ; Enable inverse display for characters with High bit set
CHACTL_BLANK =   %00000001 ; Enable blank display for characters with High bit set

.endif _ANTIC_

; The Atari 8-bit Character Set is comprised of 128 characters, each 8-bits wide
; and 8 scan lines tall.  Thus 8 bytes comprise a single character, and a full
; 128 character set requires 1KB of space (128x8).  The data for each character
; is laid out linearly in memory, so bytes 0-7 are the first character,
; bytes 8-15 are the second character, and so on.

; The standard Atari character set is stored in ROM at $E000-$E3FF.

; You can create a custom character set by defining a new set of 128 characters
; and aligning them on a 1K boundary in memory (CHBASE_BOUNDARY or BOUNDARY_1K).
; You can then set the CHBASE to poiht to the page (High byte) of that memory
; and ANTIC will display the characters from your new character set.

; Layout here is in INTERNAL order, which differs from ATASCII as used by
; Atari BASIC.

; Inverse (reverse-field) versions of each character are available by setting
; the high bit of the character value.

CH_INVERSE = %10000000 ; OR/add to character to SET High Bit for INVERSE character
CH_NORMAL  = $01111111 ; AND with character to CLEAR High Bit NORMAL character

; Label/Value prefix of CI is used to denote an [C]haracter's [I]nternal value.
; This is to allow provision for a possible future ATASCII mapped version, which
; would use a CA or [C]haracter [A]TASCII prefix and ordering.

; The Atari 8-bit US Character Set, in INTERNAL order, organized as four blocks
; of 32 characters (per most Character Editor layouts), is as follows:

CI_SPACE          = $00
CI_EXCLAMATION    = $01
CI_DOUBLEQUOTE    = $02
CI_HASH           = $03
CI_DOLLAR         = $04
CI_PERCENT        = $05
CI_AMPERSAND      = $06
CI_SINGLEQUOTE    = $07
CI_LEFTPAREN      = $08
CI_RIGHTPAREN     = $09
CI_ASTERISK       = $0A
CI_PLUS           = $0B
CI_COMMA          = $0C
CI_MINUS          = $0D
CI_PERIOD         = $0E
CI_BACKSLASH      = $0F
CI_0              = $10
CI_1              = $11
CI_2              = $12
CI_3              = $13
CI_4              = $14
CI_5              = $15
CI_6              = $16
CI_7              = $17
CI_8              = $18
CI_9              = $19
CI_COLON          = $1A
CI_SEMICOLON      = $1B
CI_LESSTHAN       = $1C
CI_EQUAL          = $1D
CI_GREATERTHAN    = $1E
CI_QUESTION       = $1F

CI_AT             = $20
CI_UPPER_A        = $21
CI_UPPER_B        = $22
CI_UPPER_C        = $23
CI_UPPER_D        = $24
CI_UPPER_E        = $25
CI_UPPER_F        = $26
CI_UPPER_G        = $27
CI_UPPER_H        = $28
CI_UPPER_I        = $29
CI_UPPER_J        = $2A
CI_UPPER_K        = $2B
CI_UPPER_L        = $2C
CI_UPPER_M        = $2D
CI_UPPER_N        = $2E
CI_UPPER_O        = $2F
CI_UPPER_P        = $30
CI_UPPER_Q        = $31
CI_UPPER_R        = $32
CI_UPPER_S        = $33
CI_UPPER_T        = $34
CI_UPPER_U        = $35
CI_UPPER_V        = $36
CI_UPPER_W        = $37
CI_UPPER_X        = $38
CI_UPPER_Y        = $38
CI_UPPER_Z        = $3A
CI_LEFTBRACKET    = $3B
CI_FORWARDSLASH   = $3C
CI_RIGHTBRACKET   = $3E
CI_CARAT          = $3E
CI_UNDERSCORE     = $3F

CI_CTRL_COMMA     = $40
CI_CTRL_A         = $41
CI_CTRL_B         = $42
CI_CTRL_C         = $43
CI_CTRL_D         = $44
CI_CTRL_E         = $45
CI_CTRL_F         = $46
CI_CTRL_G         = $47
CI_CTRL_H         = $48
CI_CTRL_I         = $49
CI_CTRL_J         = $4A
CI_CTRL_K         = $4B
CI_CTRL_L         = $4C
CI_CTRL_M         = $4D
CI_CTRL_N         = $4E
CI_CTRL_O         = $4F
CI_CTRL_P         = $50
CI_CTRL_Q         = $51
CI_CTRL_R         = $52
CI_CTRL_S         = $53
CI_CTRL_T         = $54
CI_CTRL_U         = $55
CI_CTRL_V         = $56
CI_CTRL_W         = $57
CI_CTRL_X         = $58
CI_CTRL_Y         = $59
CI_CTRL_Z         = $5A
CI_ESCAPE         = $5B
CI_UPARROW        = $5C
CI_DOWNARROW      = $5D
CI_LEFTARROW      = $5E
CI_RIGHTARROW     = $5F

CI_CTRL_PERIOD    = $60
CI_LOWER_A        = $61
CI_LOWER_B        = $62
CI_LOWER_C        = $63
CI_LOWER_D        = $64
CI_LOWER_E        = $65
CI_LOWER_F        = $66
CI_LOWER_G        = $67
CI_LOWER_H        = $68
CI_LOWER_I        = $69
CI_LOWER_J        = $6A
CI_LOWER_K        = $6B
CI_LOWER_L        = $6C
CI_LOWER_M        = $6D
CI_LOWER_N        = $6E
CI_LOWER_O        = $6F
CI_LOWER_P        = $70
CI_LOWER_Q        = $71
CI_LOWER_R        = $72
CI_LOWER_S        = $73
CI_LOWER_T        = $74
CI_LOWER_U        = $75
CI_LOWER_V        = $76
CI_LOWER_W        = $77
CI_LOWER_X        = $78
CI_LOWER_Y        = $79
CI_LOWER_Z        = $7A
CI_CTRL_SEMICOLON = $7B
CI_TILDE          = $7C
CI_CLEARSCREEN    = $7D
CI_DELETE         = $7E
CI_TAB            = $7F

; Alternate Names/Labels for Some Characters

CI_POUND   = CI_HASH
CI_HEART   = CI_CTRL_COMMA
CI_CLUB    = CI_CTRL_P
CI_DIAMOND = CI_CTRL_PERIOD
CI_SPADE   = CI_CTRL_SEMICOLON

; Box Drawing Characters

; Position is where in the BOX the character would go, NOT where in the
; CHARACTER the graphic element is.
;
; BLOCK = THICK Characters (4 pixels/half the character cell)
; BOX = THIN Characters (2 pixels/quater of the character cell)
;
; TL = Top Left, TR = Top Right, BL = Bottom Left, BR = Bottom Right, T = Top,
; B = Bottom, L = Left, R = Right, M = Middle, S = Side, ANGLE = Diagonal
; with combinations permitted (LM = Left Middle, RS = Right Side, etc.)

CI_BOX_LM             = CI_CTRL_A
CI_BOX_RS             = CI_CTRL_B
CI_BOX_BR             = CI_CTRL_C
CI_BOX_RM             = CI_CTRL_D
CI_BOX_TR             = CI_CTRL_E
CI_BOX_ANGLE_TLBR     = CI_CTRL_F
CI_BOX_ANGLE_TRBL     = CI_CTRL_G
CI_BOX_ANGLE_SOLID_TL = CI_CTRL_H
CI_BLOCK_TR           = CI_CTRL_I
CI_BOX_ANGLE_SOLID_TR = CI_CTRL_J
CI_BLOCK_BL           = CI_CTRL_K
CI_BLOCK_BR           = CI_CTRL_L
CI_BOX_TOP            = CI_CTRL_M
CO_BOX_BOTTOM         = CI_CTRL_N
CI_BLOCK_TL           = CI_CTRL_O
CI_BOX_TL             = CI_CTRL_Q
CI_BOX_TM             = CI_CTRL_R
CI_BOX_CROSS          = CI_CTRL_S
CI_CIRCLE             = CI_CTRL_T
CI_BLOCK_BOTTOM       = CI_CTRL_U
CI_BOX_LEFT           = CI_CTRL_V
CI_BOX_TM             = CI_CTRL_W
CI_BOX_BM             = CI_CTRL_X
CI_BLOCK_LEFT         = CI_CTRL_Y
CI_BOX_BL             = CI_CTRL_Z
CI_BOX_MIDDLE         = CI_TILDE

; ANTIC TEXT Modes 6 and 7 - MASKs and BIT FLAGs for Character and Color Values

MODE67_CHAMASK = %00111111 ; AND mask to retain CHAracter value 
MODE67_COLMASK = %11000000 ; AND mask to retain COLor value

MODE67_COLPF0 = %00000000 ; Bits %00 to select color 0
MODE67_COLPF1 = %01000000 ; Bits %01 to select color 1
MODE67_COLPF2 = %10000000 ; Bits %10 to select color 2
MODE67_COLPF3 = %11000000 ; Bits %11 to select color 3

; Character Set Macros

; AlignCharacterSet - Aligns the current memory location to a 1K boundary.
;
; This is here primarily to support literate/lucid programming, reducing the
; need for the programmer to know what boundary is required.

.macro AlignCharacterSet
        .align BOUNDARY_1K
.endm

; SetCharacterSet - Sets the CHBAS to the specified character set address,
;                   setting the bit map memory location for the character set
;                   to be displayed.
;
; Character Sets must be aligned on a 1K boundary, which means the High byte
; of the address is a PAGE number, and the Low byte must be ZERO.  So, this is
; mostly a convenience macro to set the CHBAS register with a built-in sanity
; check so I don't do something silly.

.macro SetCharacterSet characterSetAddress
        ; Sanity/error checking.
        .if :0 != 1
                .error "ERROR: SetCharacterSet requires a Character Set address"
        .endif

        ; If the specified address has a Low byte other than ZERO, or the Page
        ; (High Byte) is not a mutliple of 4 then it is not aligned on a
        ; 1K boundary:

        ; Integer division will give us 0 for page multiples of 4 (4x256 = 1K)
        ?page = >:characterSetAddress - [[>:characterSetAddress / 4] * 4]
        .if <:characterSetAddress != 0 || ?page != 0
                .error "ERROR: SetCharacterSet address is not aligned on a 1K boundary"
        .endif        

        MacroDebugPrint "Setting CHBAS to:", >:characterSetAddress

        lda #>:characterSetAddress ; Get the High byte of the address
        sta CHBAS                  ; and put it into CHBAS
.endm

; SetFont - Contextual Alias for SetCharacterSet

; This is a convenience macro to allow the programmer to use SetFont instead
; of SetCharacterSet the programmer prefers to think in terms of FONTS.

.macro SetFont fontAddress
        ; Do the work using our existing SetCharacterSet macro
        SetCharacterSet :fontAddress
.endm

.endif ; _CHARACTER_SET_
