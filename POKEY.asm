; POKEY.asm - POKEY Registers, Values, MASKs and Bit-Settings for the
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
.ifndef _POKEY_

; Sentinel to allow detection of prior INCLUSION
.def _POKEY_

; POKEY Hardware Registers

; SSKCTL - Serial Port Control Register - Shadowed at SSKCTL
;
; Bit   Decimal   Function
;
;   0        1     Enable keyboard debounce circuit
;   1        2     Enable keyboard scanning circuit
;   2        4     POT counter completes a read within two scan lines instead
;                  of one frame.
;   3        8     Serial output transmitted as two-tones instead of logic
;                  true/false (POKEY "two tone" mode)
; 4-6    16-64     Serial port mode control
;   7      128     Force break; serial output to zero

SKCTL =  $D20F ; Serial Port Control


; POKEY Shadow Registers & Vectors

POKMSK = $10 ; IRQEN - See POKEY.asm/IRQEN/IRQST for Bit-Settings

; I/O Interrupt Vectors

VKEYBD = $0208 ; [WORD] POKEY Keyboard interrupt vector
VSERIN = $020A ; [WORD] POKEY Serial I/O receive data ready interrupt vector
VSEROR = $020C ; [WORD] POKEY Serial I/O transmit data ready interrupt vector
VSEROC = $020E ; [WORD] POKEY Serial bus transmit complete interrupt vector

; High Frequency Timers - Interrupt Vectors 

VTIMR1 = $0210 ; [WORD] POKEY Timer 1 interrupt vector
VTIMR2 = $0212 ; [WORD] POKEY Timer 2 interrupt vector
VTIMR4 = $0214 ; [WORD] POKEY Timer 4 interrupt vector

; SSKCTL - Serial Port Control Register Shadow Register

SSKCTL = $0232 ; SKCTL

.endif ; _POKEY_
