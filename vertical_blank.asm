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

; OS Vertical Blank Setup and Exit Vectors

SETVBV = $E45C ; JSR Vector to set timers

; User Immediate VBI routine should end by a JMP to this address 
; to continue the OS Vertical Blank routine

SYSVBV = $E45F ; JMP to end user Immediate VBI

; User Deferred VBI routine should end by a JMP to this address 
; to continue the OS Vertical Blank routine

XITVBV = $E462 ; JMP Vector to end user Deferred VBI

; VBI Modes

VBI_IMMEDIATE = $06 ; Immediate VBI
VBI_DEFERRED  = $07 ; Deferred VBI

.endif ; _OS_

; SetVBI - Installs a VBI service routine at the specified address and mode.
;
; Main SetVBI Macro - works for both IMMEDIATE and DEFERRED VBIs, can be used
; directly, or via the SetVBIDeferred and SetVBIImmediate macros (which are
; just contextual/ syntactic sugar for more lucid/literate code).

.macro SetVBI vbiAddress, vbiMode
        ; Sanity/error checking.
        if :0 != 2
                .error "ERROR: SetVBI requires a VBI service routine address and mode"
        .endif

        if :vbiMode != VBI_IMMEDIATE && :vbiMode != VBI_DEFERRED
                .error "ERROR: Invalid VBI mode"
        .endif
        MacroDebugPrint "vbiAddress:", :vbiAddress
        MacroDebugPrint "vbiMode:   ", :vbiMode

        lda #:vbiMode     ; Set VBI mode
        ldy #<:vbiAddress ; Set low byte of VBI address
        ldx #>:vbiAddress ; Set high byte of VBI address
        jsr SETVBV        ; Set up the VBI
.endm

; SetDeferredVBI - Sets up a DEFERRED VBI service routine at the specified 
;                  address.
;
; This is a lucid/literate code wrapped that calls SetVBI with the VBI_DEFERRED
; mode.

.macro SetDeferredVBI vbiAddress
        ; Sanity/error checking.
        .if :0 != 1
                .error "ERROR: SetVBIDeferred requires a VBI service routine address"
        .endif
        
        ; Use SetVBI to do the actual work
        SetVBI :vbiAddress, VBI_DEFERRED
.endm

; SetImmediateVBI- Sets up an IMMEDIATE VBI service routine at the specified
;                  address.
;
; This is a lucid/literate code wrapped that calls SetVBI with the
; VBI_IMMEDIATE mode.

.macro SetImmediateVBI vbiAddress
        ; Sanity/error checking.
        .if :0 != 1
                .error "ERROR: SetImmediateVBI requires a VBI service routine address"
        .endif
        
        ; Use SetVBI to do the actual work
        SetVBI :vbiAddress, VBI_IMMEDIATE
.endm

; ExitImmediateVBI - Standard exit for an Immediate VBI routine.

.macro ExitImmediateVBI
        ; Nothing clever here; the macro exists purely to make code
        ; mode readable.

        jmp SYSVBV ; Exit the Immediate VBI
.endm

; ExitDeferredVBI - Standard exit for a Deferred VBI routine.
;
; Can also be used to exit an IMMEDIATE VBI routine, if you want to skip the
; usual deferred mode VBI processing.

.macro ExitDeferredVBI
        ; Nothing clever here; the macro exists purely to make code
        ; mode readable.

        jmp XITVBV ; Exit the Deferred VBI
.endm

.endif ; _VERTICAL_BLANK_
