; common.asm - Common values and macros used across files in this project for
;              the MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; NOTE: This file must be included BEFORE referencing any values herein, as
;       assignments from unassigned labels, that LATER get defined, yield ZERO
;       (rather than an error - which is possibly a MADS bug).

; Labels are case-insensitive in MADS.

; Do NOT try and apply these definitions if they are already defined.
.ifndef _COMMON_

; Sentinel to allow detection of prior INCLUSION
.def _COMMON_

; True (1) and False (0) labels per MADS values for these conditions.

TRUE = 1
FALSE = 0

; Common Atari alignment/boundaries.

PAGE_BOUNDARY = $100
BOUNDARY_1K   = $400
BOUNDARY_2K   = $800

CHBASE_BOUNDARY = BOUNDARY_1K ; 1K boundary for Character Sets (CHBASE)
PMBASE_BOUNDARY = BOUNDARY_2K ; 2K boundary for Player/Missile Graphics (PMBASE)

; TV/Color Standards (for "tv_standard" label)

NTSC = $00
PAL =  $01

.endif ; _COMMON_
