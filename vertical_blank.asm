; vertical_blank.asm - Vertical Blank Interrupt Macros, Related Registers and
;                      Values for the MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Includes

        icl 'common.asm'
        icl 'macro_debugging.asm'

; Do NOT try and apply these definitions if they are already defined.
.ifndef _VERTICAL_BLANK_

; Sentinel to allow detection of prior INCLUSION
.def _VERTICAL_BLANK_

.ifndef _OS_

; Vertical Blank Interrupt Vectors

VVBLKI = $0222 ; [WORD] VBLANK Immediate (Stage 1) interrupt vector
VVBLKD = $0224 ; [WORD] VBLANK Deferred  (Stage 2) interrupt vector

.endif ; _OS_

.endif ; _VERTICAL_BLANK_
