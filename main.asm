; main.asm - Notional "main" program; provides entry point/reference for
;            the project, to allow pre-defined Run/Debug behavior in IDEs.
;
;            This file should NOT be INCLUDED in actual projects.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Include files, to be assembled (and tested).

	icl 'ANTIC.asm'
	icl 'BASIC.asm'
	icl 'character_set.asm'
	icl 'character_set.asm'
	icl 'common.asm'
	icl 'display_list.asm'	
	icl 'macro_debugging.asm'
	icl 'OS.asm'

;.def macro_debugging

; A simple assembly program, that provides a valid org and entry point for
; the assembler, can execute in an emulator, and can be used to test the
; various aspects of other files in a transient manner.

	org $2000 ; We'll start here.

	DL_TOP_OVERSCAN
	DL_BLANK_LINES 18, 1

	; We'll do nothing, then loop!

start	jmp start