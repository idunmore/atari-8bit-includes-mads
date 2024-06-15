; colors.asm - Color Values, Masks, Bit-Settings and Macros for the
;              MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Includes

        icl 'common.asm'
        icl 'macro_debugging.asm'

; Do NOT try and apply these definitions if they are already defined.
.ifndef _COLORS_

; Sentinel to allow detection of prior INCLUSION
.def _COLORS_

; Atari 8-bit Colors are defined as a single byte, with the top 4 bytes (nybble)
; specifying the HUE and the bottom 4 bytes specifying the LUMINANCE.  Higher
; luminance values are brighter, lower values are darker.
;
; Excepting special GTIA modes, only even LUMINANCE values are used (bit 0 is
; ignored, so while odd values can be used they are effectively rounded down).
;
; Sixteen HUEs are available with 8 LUMINANCE valies each, for 128 total colors.

;COLOR (HUE) and LUMA Masks

HUE_BITS =   %11110000 ; And to preserve HUE and exclude LUMA
COLOR_BITS = %11110000 ; AND to preserve HUE and exclude LUMA
LUMA_BITS =  %00001111 ; AND to preserve LUMA and exclude HUE

;COLOR (HUE) Definitions/Names

; COLOR "NAMES" include those described in "Mapping the Atari (p.164) and from
; Ken Jennings' equates (https://github.com/kenjennings/Atari-Mads-Includes/)
; so those familiar with either can use their preferred names.

; Color values are shifted for NTSC vs. PAL.  Rather than make the user program
; have to deal with the difference, and potentiall use different color names
; (e.g., COLOR_RED vs. NTSC_COLOR_RED and PAL_COLOR_RED), we will use a common
; set of names (i.e., just  COLOR_xxxx) and adjust the values based on the
; definition of the tv_standard label.
;
; NOTE: The tv_standard label must be defined BEFORE including this file,
;       and common.asm must be included BEFORE defining tv_standard if using
;       the NTSC and PAL values.
;
;       The BEST way to use this feature, is to use MADS -d option to define
;       the tv_standard label as assembly time, with a value of 0 for NTSC or
;       1 for PAL.  This allows the color set to be BUILD specific, rather than
;       requiring the user to change the source code.

; If no TV standard (NTSC or PAL) is defined, we will default to NTSC.
.if [tv_standard == NTSC] .or [.not .def tv_standard]

;NTSC Color Values
        
; Per Mapping the Atari (p.164)
COLOR_BLACK =            $00
COLOR_RUST =             $10
COLOR_RED_ORANGE =       $20
COLOR_DARK_ORANGE =      $30
COLOR_RED =              $40
COLOR_DARK_LAVENDER =    $50
COLOR_COBALT_BLUE =      $60
COLOR_ULTRAMARINE_BLUE = $70
COLOR_MEDIUM_BLUE =      $80
COLOR_DARK_BLUE =        $90
COLOR_BLUE_GREY =        $A0
COLOR_OLIVE_GREEN =      $B0
COLOR_MEDIUM_GREEN =     $C0
COLOR_DARK_GREEN =       $D0
COLOR_ORANGE_GREEN =     $E0
COLOR_ORANGE =           $F0

; Per Ken Jennings (https://github.com/kenjennings/Atari-Mads-Includes/)

COLOR_GREY =         $00 ; Black is "Grey" at Luminance >= 2
COLOR_WHITE =        $0F ; White is "Black" at maximum Luminance ($0F/15)
COLOR_ORANGE1 =      $10
COLOR_ORANGE2 =      $20
COLOR_RED_ORANGE =   $30
COLOR_PINK =         $40
COLOR_PURPLE =       $50
COLOR_PURPLE_BLUE =  $60
COLOR_BLUE1 =        $70
COLOR_BLUE2 =        $80
COLOR_LITE_BLUE =    $90
COLOR_AQUA =         $A0
COLOR_BLUE_GREEN =   $B0
COLOR_GREEN =        $C0
COLOR_YELLOW_GREEN = $D0
COLOR_ORANGE_GREEN = $E0
COLOR_LITE_ORANGE =  $F0

.else ; .not .def tv_standard

;PAL Color Values

; Per Mapping the Atari (p.164)
COLOR_BLACK =            $00
COLOR_RUST =             $F0
COLOR_RED_ORANGE =       $10
COLOR_DARK_ORANGE =      $20
COLOR_RED =              $30
COLOR_DARK_LAVENDER =    $40
COLOR_COBALT_BLUE =      $50
COLOR_ULTRAMARINE_BLUE = $60
COLOR_MEDIUM_BLUE =      $70
COLOR_DARK_BLUE =        $80
COLOR_BLUE_GREY =        $90
COLOR_OLIVE_GREEN =      $A0
COLOR_MEDIUM_GREEN =     $B0
COLOR_DARK_GREEN =       $C0
COLOR_ORANGE_GREEN =     $D0
COLOR_ORANGE =           $E0

; Per Ken Jennings (https://github.com/kenjennings/Atari-Mads-Includes/)

COLOR_GREY =         $00 ; Black is "Grey" at Luminance >= 2
COLOR_WHITE =        $0F ; White is "Black" at maximum Luminance ($0F/15)
COLOR_ORANGE1 =      $F0
COLOR_ORANGE2 =      $10
COLOR_RED_ORANGE =   $20
COLOR_PINK =         $30
COLOR_PURPLE =       $40
COLOR_PURPLE_BLUE =  $50
COLOR_BLUE1 =        $60
COLOR_BLUE2 =        $70
COLOR_LITE_BLUE =    $80
COLOR_AQUA =         $90
COLOR_BLUE_GREEN =   $A0
COLOR_GREEN =        $B0
COLOR_YELLOW_GREEN = $C0
COLOR_ORANGE_GREEN = $D0
COLOR_LITE_ORANGE =  $E0

.endif ; [tv_standard == NTSC] .or [.not .def tv_standard]

.endif ; _COLORS_
