; main.asm - Notional "main" program; provides entry point/reference for
;            the project, to allow pre-defined Run/Debug behavior in IDEs.
;
;            This file should NOT be INCLUDED in actual projects.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; A simple assembly program, that provides a valid org and entry point for
; the assembler, can execute in an emulator, and can be used to test the
; various aspects of other files in a transient manner.

	org $2000 ; We'll start here.

	; We'll do nothing, then loop!

start	jmp start