; PIA.asm - PIA (Peripheral Interface Adapter) Registers, Values, MASKs and
;           Bit-Settings for the MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Includes

        icl 'common.asm'
        icl 'macro_debugging.asm'

; Do NOT try and apply these definitions if they are already defined.
.ifndef _PIA_

; Sentinel to allow detection of prior INCLUSION
.def _PIA_

; PIA Hardware Registers

; These registers support multiple devices per register (BYTE), and require
; decoding via various MASKs and Bit-Settings to interpret.  This decoding
; is done during the VBI (Vertical Blank Interrupt) and the extracted,values
; are refelected in the PIA Shadow Registers (one per device).

PORTA = $D300 ; Joystick ports 1 and 2, STICK0 and STICK1
PORTB = $D301 ; Joystick ports 3 and 4, STICK2 and STICK3
PACTL = $D302 ; Port A Control
PBCTL = $D303 ; Port B Control

; PIA Shadow Registers

; Joystick Positions

; These values are extracted from the PORTA and PORTB registers, as described
; above.  Each joystick position yields one of 9 values: $0F (%1111) for
; centered, then 8 values for each of the 45-degree increments [(dec) binary]:
;
;                    (14/$0E)
;                      1110
;      (10/$0A) 1010     |     0110 (6/$06)
;                   \    |    /
;                    \   |   /
;                     \  |  /
; (11/$0B) 1011 ------ 1111  ------ 0111 (7/$07)
;                     /($0F)\
;                    /   |   \
;                   /    |    \
;       (9/$09) 1001     |     0101 (5/$05)
;                      1101
;                    (13/$0D)

STICK0 = $0278 ; Joystick 1 (decoded from PORTA)
STICK1 = $0279 ; Joystick 2 (decoded from PORTA)
STICK2 = $027A ; Joystick 3 (decoded from PORTB)
STICK3 = $027B ; Joystick 4 (decoded from PORTB)

; Paddle Triggers (Button) - $00 = Pressed, $01 = Not Pressed

PTRIG0 = $027C ; Paddle 1 Trigger
PTRIG1 = $027D ; Paddle 2 Trigger
PTRIG2 = $027E ; Paddle 3 Trigger
PTRIG3 = $027F ; Paddle 4 Trigger
PTRIG4 = $0280 ; Paddle 5 Trigger
PTRIG5 = $0281 ; Paddle 6 Trigger
PTRIG6 = $0282 ; Paddle 7 Trigger
PTRIG7 = $0283 ; Paddle 8 Trigger

.endif ; _PIA_

