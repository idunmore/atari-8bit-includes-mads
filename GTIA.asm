; GTIA.asm - GTIA (Graphics Television Interface Adapter) Registers, Values,
;            MASKs and Bit-Settings for the MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE
;
; (Many "CONSTANT" names/IDs and commentary per Ken Jennings:
; https://github.com/kenjennings/Atari-Mads-Includes/)

; Includes

        icl 'common.asm'
        icl 'macro_debugging.asm'

; Do NOT try and apply these definitions if they are already defined.
.ifndef _GTIA_

; Sentinel to allow detection of prior INCLUSION
.def _GTIA_

; GTIA Hardware Registers

; Player/Missile Horizontal Position Registers

HPOSP0 = $D000 ; Player 0 Horizontal Position
HPOSP1 = $D001 ; Player 1 Horizontal Position
HPOSP2 = $D002 ; Player 2 Horizontal Position
HPOSP3 = $D003 ; Player 3 Horizontal Position

HPOSM0 = $D004 ; Missile 0 Horizontal Position
HPOSM1 = $D005 ; Missile 1 Horizontal Position
HPOSM2 = $D006 ; Missile 2 Horizontal Position
HPOSM3 = $D007 ; Missile 3 Horizontal Position

; Player/Missile Size Registers

SIZEP0 = $D008 ; Player 0 Size
SIZEP1 = $D009 ; Player 1 Size
SIZEP2 = $D00A ; Player 2 Size
SIZEP3 = $D00B ; Player 3 Size
SIZEM =  $D00C ; Missiles Sizes (2 bits per Missile)

; Player/Missile Graphics Pattern Registers

GRAFP0 = $D00D ; Player 0 Graphics Pattern
GRAFP1 = $D00E ; Player 1 Graphics Pattern
GRAFP2 = $D00F ; Player 2 Graphics Pattern
GRAFP3 = $D010 ; Player 3 Graphics Pattern
GRAFM =  $D011 ; Missile Graphics Pattern (2 bits per Missile)

; Player/Missile Collition Detection Registers

M0PF = $D000 ; (Read) Missile 0 to Playfield collisions
M1PF = $D001 ; (Read) Missile 1 to Playfield collisions
M2PF = $D002 ; (Read) Missile 2 to Playfield collisions
M3PF = $D003 ; (Read) Missile 3 to Playfield collisions
;
P0PF = $D004 ; (Read) Player 0 to Playfield collisions
P1PF = $D005 ; (Read) Player 1 to Playfield collisions
P2PF = $D006 ; (Read) Player 2 to Playfield collisions
P3PF = $D007 ; (Read) Player 3 to Playfield collisions
;
M0PL = $D008 ; (Read) Missile 0 to Player collisions
M1PL = $D009 ; (Read) Missile 1 to Player collisions
M2PL = $D00A ; (Read) Missile 2 to Player collisions
M3PL = $D00B ; (Read) Missile 3 to Player collisions
;
P0PL = $D00C ; (Read) Player 0 to Player collisions
P1PL = $D00D ; (Read) Player 1 to Player collisions
P2PL = $D00E ; (Read) Player 2 to Player collisions
P3PL = $D00F ; (Read) Player 3 to Player collisions

; Joystick Triggers (Button) - $00 = Pressed, $01 = Not Pressed

TRIG0 =  $D010 ; (Read) Joystick 0 trigger
TRIG1 =  $D011 ; (Read) Joystick 1 trigger
TRIG2 =  $D012 ; (Read) Joystick 2 trigger
TRIG3 =  $D013 ; (Read) Joystick 3 trigger

; Player/Missile Graphics & GTIA Color Registers

COLPM0 = $D012 ; Player/Missile 0 color, GTIA 9-color playfield color 0 for Background
COLPM1 = $D013 ; Player/Missile 1 color, GTIA 9-color playfield color 1
COLPM2 = $D014 ; Player/Missile 2 color, GTIA 9-color playfield color 2
COLPM3 = $D015 ; Player/Missile 3 color, GTIA 9-color playfield color 3

; Playfield Color Registers

COLPF0 = $D016 ; Playfield 0 color
COLPF1 = $D017 ; Playfield 1 color
COLPF2 = $D018 ; Playfield 2 color
COLPF3 = $D019 ; Playfield 3 color (and fifth Player color)
COLBK =  $D01A ; Playfield Background color

; GTIA Control Registers

PAL =    $D014 ; (Read) PAL Flag - Bits 1-3:
               ;        Clear (xxxx000x) = PAL/SECAM, Set (xxxx111x) = NTSC
PRIOR =  $D01B ; Control Priority, Fifth Player and GTIA modes
VDELAY = $D01C ; Player Missile Vertical Delay
GRACTL = $D01D ; Graphics Control, P/M DMA and joystick trigger latches
HITCLR = $D01E ; Clear Player/Missile Collisions

CONSOL = $D01F ; (Read) [Start], [Select], [Option] console keys
CONSPK = $D01F ; Console speaker

; GTIA Shadow Registers

GPRIOR = $026F ; PRIOR - Control Priority, Fifth Player and GTIA modes

; Joystick Triggers (Button) - $00 = Pressed, $01 = Not Pressed

STRIG0 = $0284 ; TRIG0
STRIG1 = $0285 ; TRIG1
STRIG2 = $0286 ; TRIG2
STRIG3 = $0287 ; TRIG3

; Playfield and Player/Missile Graphics Shadow Registers

PCOLOR0 = $02C0 ; COLPM0
PCOLOR1 = $02C1 ; COLPM1
PCOLOR2 = $02C2 ; COLPM2
PCOLOR3 = $02C3 ; COLPM3

COLOR0 =  $02C4 ; COLPF0
COLOR1 =  $02C5 ; COLPF1
COLOR2 =  $02C6 ; COLPF2
COLOR3 =  $02C7 ; COLPF3
COLOR4 =  $02C8 ; COLBK

; (Many "CONSTANT" names/IDs and commentary per Ken Jennings:
; https://github.com/kenjennings/Atari-Mads-Includes/)

; MASKs and Bit-Settings for GTIA Registers, Functions and Interrupts

; Don't redefine COLOR/LUMA masks/bit settings; the specific files
; (e.g., color.asm) have precedence and more details.
.ifndef _COLORS_

;COLOR (HUE) and LUMA Masks

HUE_BITS =   %11110000 ; And to preserve HUE and exclude LUMA
COLOR_BITS = %11110000 ; AND to preserve HUE and exclude LUMA
LUMA_BITS =  %00001111 ; AND to preserve LUMA and exclude HUE

.endif ; _COLORS_

; Detect NTSC/PAL

MASK_NTSCPAL_BITS =%00001110 ; Clear (xxxx000x) = PAL/SECAM,
                             ; Set (xxxx111x) = NTSC

; SIZEP0 - SIZEP3

PLAYER_SIZE_BITS = %00000011
PM_SIZE_NORMAL =   %00000000 ; One color clock per Player/Missile pixel
PM_SIZE_DOUBLE =   %00000001 ; Two color clocks per Player/Missile pixel
PM_SIZE_QUAD =     %00000011 ; Four color clocks per Player/Missile pixel

; SIZEM and GRAFM (and missile memory)

MASK_MISSILE0_BITS = %11111100
MASK_MISSILE1_BITS = %11110011
MASK_MISSILE2_BITS = %11001111
MASK_MISSILE3_BITS = %00111111

MISSILE0_BITS =      %00000011
MISSILE1_BITS =      %00001100
MISSILE2_BITS =      %00110000
MISSILE3_BITS =      %11000000

; Collisions MxPF, MxPL, PxPF, PxPL
; COLPMx or COLPFx where X is bits 0 through 3

MASK_COLPMF0_BIT = %11111110 ; Player or Missile v Player or Playfield color 0
MASK_COLPMF1_BIT = %11111101 ; Player or Missile v Player or Playfield color 1
MASK_COLPMF2_BIT = %11111011 ; Player or Missile v Player or Playfield color 2
MASK_COLPMF3_BIT = %11110111 ; Player or Missile v Player or Playfield color 3

COLPMF0_BIT =      %00000001 ; Player or Missile v Player or Playfield color 0
COLPMF1_BIT =      %00000010 ; Player or Missile v Player or Playfield color 1
COLPMF2_BIT =      %00000100 ; Player or Missile v Player or Playfield color 2
COLPMF3_BIT =      %00001000 ; Player or Missile v Player or Playfield color 3


; PRIOR and GPRIOR - Control Priority, Fifth Player and GTIA modes

MASK_PRIORITY =      %11110000 ; Player/Missile, Playfield priority
MASK_FIFTH_PLAYER =  %11101111 ; Enable/Disable Fifth Player
MASK_MULTICOLOR_PM = %11011111 ; Enable/Disable Player color mixing
MASK_GTIA_MODE =     %00111111 ; Enable/Disable GTIA playfield modes
;
PRIORITY_BITS =      %00001111 ; Player/Missile, Playfield priority
FIFTH_PLAYER =       %00010000 ; Enable Fifth Player
MULTICOLOR_PM =      %00100000 ; Enable Player color mixing
;
GTIA_MODE_DEFAULT =  %00000000 ; Normal CTIA color interpretation
GTIA_MODE_16_SHADE = %01000000 ; 16 shades of background color (COLBK)
GTIA_MODE_9_COLOR =  %10000000 ; 9 colors from registers, COLPM0 is background
GTIA_MODE_16_COLOR = %11000000 ; 16 hues of brightness of background color (COLBK)

; Player/Missile to Playfield priority values:

;+============+=========+=========+=========+=========+=========+
;| Priority   | 0 0 0 1 | 0 0 1 0 | 0 1 0 0 | 1 0 0 0 | 0 0 0 0 |
;| Bits [3:0] |  = $1   |  = $2   |  = $4   |  = $8   |  = $0*  |
;+============+=========+=========+=========+=========+=========+
;|        Top | PM0     | PM0     | P5/PF0  | P5/PF0  | PM0     |
;|            | PM1     | PM1     |    PF1  |    PF1  | PM1     |
;|            | PM2     | P5/PF0  |    PF2  | PM0     | P5/PF0  |
;|            | PM3     |    PF1  |    PF3  | PM1     |    PF1  |
;|            | P5/PF0  |    PF2  | PM0     | PM2     | PM2     |
;|            |    PF1  |    PF3  | PM1     | PM3     | PM3     |
;|            |    PF2  |  PM2    | PM2     |    PF2  |    PF2  |
;|            |    PF3  |  PM3    | PM3     |    PF3  |    PF3  |
;|     Bottom |  COLBK  |  COLBK  |  COLBK  |  COLBK  |  COLBK  |
;+============+=========+=========+=========+=========+=========+
;
; * $0 is Special - Priority 0 results in color merging:
;
;     PM0/PM1 + PF0/PF1 OR together to generate different colors.
;     PM2/PM3 + PF2/PF3 OR together to generate different colors.


; VDELAY - Delay PM DMA to render 2 scan line Player data one scan line lower 

MASK_VD_MISSILE0 = %11111110
MASK_VD_MISSILE1 = %11111101
MASK_VD_MISSILE2 = %11111011
MASK_VD_MISSILE3 = %11110111
MASK_VD_PLAYER0 =  %11101111
MASK_VD_PLAYER1 =  %11011111
MASK_VD_PLAYER2 =  %10111111
MASK_VD_PLAYER3 =  %01111111

VD_MISSILE0 =      %00000001
VD_MISSILE1 =      %00000010
VD_MISSILE2 =      %00000100
VD_MISSILE3 =      %00001000
VD_PLAYER0 =       %00010000
VD_PLAYER1 =       %00100000
VD_PLAYER2 =       %01000000
VD_PLAYER3 =       %10000000

; GRACTL - Enable/Disable Player/Missile DMA to GRAFxx registers.
;          And latch triggers.

MASK_ENABLE_MISSILES = %11111110 ; Enable/Disable Missile DMA to GRAFM register
MASK_ENABLE_PLAYERS =  %11111101 ; Enable/Disable Player DMA to GRAFPx registers
MASK_TRIGGER_LATCH =   %11111011 ; Enable/Disable jostick trigger latching

ENABLE_MISSILES =      %00000001 ; Enable Missile DMA to GRAFM register
ENABLE_PLAYERS =       %00000010 ; Enable Player DMA to GRAFPx registers
TRIGGER_LATCH =        %00000100 ; Enable joystick trigger latching

; CONSOL and CONSPK

; 0 bit is key pressed, so AND "masking" is not really useful.
; Better to just AND with the single bit for each of the 3 keys.

MASK_CONSOLE_KEYS =    %11111000
MASK_CONSOLE_START =   %11111110 ; Start button
MASK_CONSOLE_SELECT =  %11111101 ; Select button
MASK_CONSOLE_OPTION =  %11111011 ; Option button
MASK_CONSOLE_SPEAKER = %11110111 ; (Write) Keyboard speaker

CONSOLE_KEYS =         %00000111 ; Capture only the function keys.
CONSOLE_START =        %00000001 ; Start button
CONSOLE_SELECT =       %00000010 ; Select button
CONSOLE_OPTION =       %00000100 ; Option button
CONSOLE_SPEAKER =      %00001000 ; (Write) Keyboard speaker

; Sizes in horizontal color clocks and vertical scan lines

PLAYFIELD_COLORCLOCKS_NARROW = $80 ; Color Clocks Narrow Width = 128 ($80)
PLAYFIELD_COLORCLOCKS_NORMAL = $A0 ; Color Clocks Normal Width = 160 ($A0)
PLAYFIELD_COLORCLOCKS_WIDE =   $B0 ; Color Clocks Wide Width   = 176 ($B0)

PLAYFIELD_LEFT_EDGE_NARROW = $40 ; First/left-most color clock horizontal position
PLAYFIELD_LEFT_EDGE_NORMAL = $30
PLAYFIELD_LEFT_EDGE_WIDE =   $28

PLAYFIELD_RIGHT_EDGE_NARROW = $BF ; Last/right-most color clock horizontal position
PLAYFIELD_RIGHT_EDGE_NORMAL = $CF
PLAYFIELD_RIGHT_EDGE_WIDE =   $D7

; PMBASE offsets to Player or Missile addresses

PMADR_2LINE_MISSILES = $180 
PMADR_2LINE_PLAYER0 =  $200
PMADR_2LINE_PLAYER1 =  $280
PMADR_2LINE_PLAYER2 =  $300
PMADR_2LINE_PLAYER3 =  $380

PMADR_1LINE_MISSILES = $300
PMADR_1LINE_PLAYER0 =  $400
PMADR_1LINE_PLAYER1 =  $500
PMADR_1LINE_PLAYER2 =  $600
PMADR_1LINE_PLAYER3 =  $700

; Vertical Alignments - screen scanlines are offsets into PMADR memory locations

PM_2LINE_OVERSCAN_TOP =    $04
PM_2LINE_NORMAL_TOP =      $10 ; For default OS 192 scan line display
PM_2LINE_NORMAL_BOTTOM =   $6F ; For default OS 192 scan line display
PM_2LINE_OVERSCAN_BOTTOM = $7B

PM_1LINE_OVERSCAN_TOP =    $08
PM_1LINE_NORMAL_TOP =      $20 ; For default OS 192 scan line display
PM_1LINE_NORMAL_BOTTOM =   $DF ; For default OS 192 scan line display
PM_1LINE_OVERSCAN_BOTTOM = $F7

.endif ; _GTIA_
