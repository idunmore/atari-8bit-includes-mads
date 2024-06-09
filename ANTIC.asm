; ANTIC.asm - ANTIC Registers, Values, MASKs and Bit-Settings for the
;             MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Includes

        icl 'common.asm'
        icl 'macro_debugging.asm'

; Do NOT try and apply these definitions if they are already defined.
.ifndef _ANTIC_

; Sentinel to allow detection of prior INCLUSION
.def _ANTIC_

; This file contains the definitions for the ANTIC registers and values.  For
; Display List, and Display List Interrupt *specific* definitions and macros,
; see the file 'display_list.asm'.
;
; There is overlap with pure ANTIC registers (etc.) here and in the Display
; List file, but any conflicts are automatically excluded, so both files
; can be safely INCLUDED as necessary.

; ANTIC Hardware Registers

DMACTL = $D400 ; DMA control for display and Player/Missile graphics
CHACTL = $D401 ; Character display control
DLISTL = $D402 ; Display List Address (Low Byte)
DLISTH = $D403 ; Display List Address (High Byte)
HSCROL = $D404 ; Horizontal Fine Scroll (0 to 16 color clocks).
VSCROL = $D405 ; Vertical Fine Scroll (0 to 16 scan lines).
PMBASE = $D407 ; Player/Missile Base Address (Page Number/High Byte) as PMBASE 
               ; must be on a 2K (2048 byte)/$800 boundary.
CHBASE = $D409 ; Character Set Base Address (Page Number/High Byte) as CHBASE
               ; must be on a 1K (1024 byte)/$400 boundary.
VSCROL = $D405 ; Vertical Fine Scroll (0 to 16 scan lines).
WSYNC =  $D40A ; Wait for Horizontal Sync/next scan line
VCOUNT = $D40B ; (Read) Vertical scan line Counter
PENH =   $D40C ; (Read) Light Pen Horizontal Position
PENV =   $D40D ; (Read) Light Pen Vertical Position
NMIEN =  $D40E ; Non-Maskable Interupt (NMI) Enable
NMIRES = $D40F ; Non-Maskable Interrupt (NMI) Reset
NMIST =  $D40F ; (Read) Non-Maskable Interrupt Status

; ANTIC Shadow Registers 

SDMCTL = $022F ; DMACTL
SDLSTL = $0230 ; DLISTL
SDLSTH = $0231 ; DLISTH
CHBAS =  $02F4 ; CHBASE
CHART =  $02F3 ; CHACTL
LPENH =  $0234 ; (Read) PENH
LPENV =  $0235 ; (Read) PENV

; DMACTL/SDMTCL - DMA control register for display and Player/Missile graphics

; MASKs (e.g., MASK_DL_DMA) are ANDed with the DMA setting to DISABLE the option.

MASK_DL_DMA =          %11011111 ; Disable DMA to read the Display List
MASK_PM_RESOLUTION =   %11101111 ; Set P/M graphics DMA to 1 or 2 scan lines  
MASK_PM_DMA =          %11110011 ; Enable/Disable DMA for Players/Missiles
MASK_PLAYFIELD_WIDTH = %11111100 ; Disable playfield display/set playfield width
DISABLE_DL_DMA =       %00000000 ; Disable DMA

; BIT FLAGs (e.g., DL_DLI) are ORed with DMA setting to ENABLE the option.

ENABLE_DL_DMA = %00100000 ; Enable DMA to read the Display List

PM_1LINE_RESOLUTION = %00010000 ; Set P/M graphics DMA to 1 scan line resolution
PM_2LINE_RESOLUTION = %00000000 ; Set P/M graphics DMA to 1 scan line resolution

ENABLE_PLAYER_DMA =  %00001000 ; Enable DMA for Players
ENABLE_MISSILE_DMA = %00000100 ; Enable DMA for Missiles
ENABLE_PM_DMA =      %00001100 ; Enable DMA for Players and Missiles

; DMACTL and SDMCTL - Playfield Settings (see ANTIC Graphics Modes, below)

PLAYFIELD_DISABLE =      %00000000 ; No width is the same as no display
PLAYFIELD_WIDTH_NARROW = %00000001 ; 32 characters/128 color clocks
PLAYFIELD_WIDTH_NORMAL = %00000010 ; 40 characters/160 color clocks
PLAYFIELD_WIDTH_WIDE =   %00000011 ; 48 characters/192 color clocks 

; CHACTL - Character Display Control

; MASKs (e.g., CHACTL_REFLECT) are ANDed with the CHACTL setting to DISABLE
; the option.

MASK_CHACTL_REFLECT = %11111011 ; Disable Vertical Reflect
MASK_CHACTL_INVERSE = %11111101 ; Disable characters with high bit set displayed as inverse 
MASK_CHACTL_BLANK =   %11111110 ; Disable characters with high bit set displayed as blank space

; BIT FLAGs (e.g., CHACTL_REFLECT) are ORed with CHACTL setting to ENABLE the
; option.

CHACTL_REFLECT = %00000100 ; Enable vertical reflect
CHACTL_INVERSE = %00000010 ; Enable inverse display for characters with high bit set
CHACTL_BLANK =   %00000001 ; Enable blank display for characters with high bit set

; NMIEN (NMIRES and NMIST) - Non-Maskable Interupt (NMI) Reset and Status;                            

MASK_NMIEN_DLI =   %01111111 ; Disable Display List Interrupts
MASK_NMIEN_VBI =   %10111111 ; Disable Vertical Blank Interrupt
MASK_NMIEN_RESET = %11011111 ; Disable Reset Key Interrupt

; NMIEN (NMIRES and NMIST) - Enable Non-Maskable Display List Interupts

NMIEN_DLI =   %10000000 ; Enable Display List Interrupts
NMIEN_VBI =   %01000000 ; Enable Vertical Blank Interrupt
NMIEN_RESET = %00100000 ; Enable Reset Key Interrupt

.endif ; _ANTIC_
