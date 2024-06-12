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

; Audio Registers
;
; These values overlap with those for the paddles, but are listed first since
; POKEY is best known for its SOUND capabilities.
;
; Register WRITES affect audio; READs return paddle values.

AUDF1 =  $D200 ; Audio Channel 1 Frequency
AUDF2 =  $D202 ; Audio Channel 2 Frequency
AUDF3 =  $D204 ; Audio Channel 3 Frequency
AUDF4 =  $D206 ; Audio Channel 4 Frequency

AUDC1 =  $D201 ; Audio Channel 1 Control
AUDC2 =  $D203 ; Audio Channel 2 Control
AUDC3 =  $D205 ; Audio Channel 3 Control
AUDC4 =  $D207 ; Audio Channel 4 Control

AUDCTL = $D208 ; Audio Control

; Paddle Potentiometer (Dial) Registers

POT0 =   $D200 ; (Read) Paddle (potentiometer) 0 
POT1 =   $D201 ; (Read) Paddle (potentiometer) 1 
POT2 =   $D202 ; (Read) Paddle (potentiometer) 2 
POT3 =   $D203 ; (Read) Paddle (potentiometer) 3
POT4 =   $D204 ; (Read) Paddle (potentiometer) 4
POT5 =   $D205 ; (Read) Paddle (potentiometer) 5
POT6 =   $D206 ; (Read) Paddle (potentiometer) 6
POT7 =   $D207 ; (Read) Paddle (potentiometer) 7  

ALLPOT = $D208 ; (Read) Read 8 line POT port state
POTGO =  $D20B ; Start the POT scan sequence

STIMER = $D209 ; Start timers

KBCODE = $D209 ; (Read) Keyboard code - This is NOT the ATASCII nor INTERNAL
               ;        keyboard code. It is the raw code from the keyboard
               ;        matrix (see table on page 50 of the OS Users Manual
               ;        for ATASCII/INTERNAL translations, also keyboard.asm)

RANDOM = $D20A ; (Read) Random number

SKREST = $D20A ; Reset Serial Status (SKSTAT)
SEROUT = $D20D ; Serial port data output
SERIN =  $D20D ; (Read) Serial port data input
SKSTAT = $D20F ; (Read) Serial port status (SKCTL write)

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

; IRQEN - Interrupt Request Enable

IRQEN = $D20E ; Interrupt Request Enable
IRQST = $D20E ; (Read) IRQ Status

; POKEY Shadow Registers & Vectors

POKMSK = $10 ; IRQEN/IRQST

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

; Paddle Potentiometer (Dial) Shadow Registers

PADDL0 = $0270 ; POT0
PADDL1 = $0271 ; POT1
PADDL2 = $0272 ; POT2
PADDL3 = $0273 ; POT3
PADDL4 = $0274 ; POT4
PADDL5 = $0275 ; POT5
PADDL6 = $0276 ; POT6
PADDL7 = $0277 ; POT7

; Keyboard Shadow Register

CH = $02FC ; KBCODE

.endif ; _POKEY_
