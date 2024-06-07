; macro_debugging.asm - Macros, etc. to assist in creating debuggable macros
;                       and providing logging and debugging information on a
;                       centrally controllable basis for the MADs assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Usage:
;
;   .icl "macro_debugging.asm"
;
;   To enable macro debugging, define the label MACRO_DEBUGGING, either in
;   source code (.define MACRO_DEBUGGING or MACRO_DEBUGGING = 1) or on the MADS
;   command line (via -d:MACRO_DEBUGGING).

; NOTE: Macros in THIS file are intended to be specific to MACRO debugging and
; logging, hence the "Macro" prefix for macros that may have a more general
; use (e.g. MacroDebugPrint vs. DebugPrint).  This allows different levels of
; debugging and control to be specified independently for Macros vs.
; general assembly code.

; Do NOT try and apply these definitions if they are already defined.
.ifndef _MACRO_DEBUGGING_

; Sentinel to allow detection of prior INCLUSION
.def _MACRO_DEBUGGING_

; Macros

; MacroDebugPrint - Prints the specified message if MACRO DEBUGGING is enabled.
;
; Avoids every macro debugging print statement having to be surrounded by:
; .ifdef macro_debugging/.endif blocks or commenting out .print statements.

; Can be called with either '' or "" enclosed strings.  Using '' will result
; in the enclosing quotes being included in the output.

; The string argument can be passed with embedded MACRO arguments in the form:
;
;     MacroDebugPrint "Output DL_BLANK_LINES :value"
;
; where ":value" is an argument to the *calling* macro.

.macro MacroDebugPrint string value
	.ifdef macro_debugging
		; We use the "" form of .print, as it will accept values with
		; and without both '' or "" ("" strings are passed without
		; enclosing quotes), since there is no way (I know of) to
		; test partial contents of a string argument in MADS.
		.if :0 == 2
			; If a value is passed, print it.
			.print ":string ", :value
		.else
			.print ":string"
		.endif
	.endif
.endm

.endif ; _MACRO_DEBUGGING_