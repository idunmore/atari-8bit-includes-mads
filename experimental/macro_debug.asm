; macro_debug - MACRO Debugging - Experimental
;
; Due to the high number of anticpated, complex, macros we need a way to enable
; debugging THOSE, independent of any debugging context for the assembled code
; or other MADS constructs that are involved.
;
; This is test for using a sentinel with an associated TRUE/FALSE value
; with the sentinel bound to an enumeration and some global definitions.
;

; Labels are CASE INSENSITIVE!

; Some global labels to work with;
.def :true = 1
.def :false = 0

; Values for different macro_debugging behavior.
;
; Initially these are just ON and OFF, but additional states may be added
; later.
.enum macro_debugging
 	on = true
	off = false
.ende

; Set our debugging mode.
;
; Here it is set as a local value.
.def m_debug = macro_debugging.on

; Verify behavior of labels and assigned enumerated values
.macro debug_test
	.if m_debug 
		.print m_debug
	.endif
.endm

; dbg_print - Prints the specified message if macro debugging is enabled.
;
; Can be called with either '' or "" enclosed strings.  Using '' will result
; in the enclosing quotes being included in the output.
;
; Saves having every debug message having to be surrounded by:
; .if m_debug/.endif blocks.
.macro dbg_print msg
	.if m_debug
		; We use the "" form of print, as it will accept values with
		; and without both '' or "" ("" strings are passed without
		; enclosing quotes), since there is no way (I know of) to
		; test partial contents of a string argument in MADS.
		.print ":msg"
	.endif
.endm

; Some test code to excercise our macros - so we can see there behavior and
; output on the console.

	org $2000 ; We'll start here.

	debug_test
	
	dbg_print "Are we debugging?"
	
start	jmp start