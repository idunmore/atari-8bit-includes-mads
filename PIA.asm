; PIA.asm - PIA (Peripheral Interface Adapter) Registers, Values, MASKs and
;           Bit-Settings for the MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; (Many "CONSTANT" names/IDs and commentary per Ken Jennings:
; https://github.com/kenjennings/Atari-Mads-Includes/)

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
;                     \ 15  /
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

; Shadow Register Joystick Positions

; These are the "direct", one-per-position, values for reading joystick
; positions via STICKn (vs. the bit-position masks below).
;
; Use the "STICK_RIGHT", "STICK_LEFT", "STICK_UP", "STICK_DOWN" masks if you
; want to test for, say, "all UP" positions in a single comparison.  Use the
; direct values if you want to test for a specific position.

STICK_POS_CENTER =     $0F
STICK_POS_UP =         $0E
STICK_POS_DOWN =       $0D
STICK_POS_LEFT =       $0B
STICK_POS_RIGHT =      $07
STICK_POS_UP_LEFT =    $0A
STICK_POS_UP_RIGHT =   $06
STICK_POS_DOWN_LEFT =  $09
STICK_POS_DOWN_RIGHT = $05

; (Many "CONSTANT" names/IDs and commentary per Ken Jennings:
; https://github.com/kenjennings/Atari-Mads-Includes/)

; MASK_JACK is about referencing the actual hardware registers. You can do this
; if you want to, however the OS already separates the joysticks into individual
; OS registers and value (STICKn), so there's not a lot of reason to read the
; joystick hardware directly.

MASK_JACK_1 = %00001111 ; Keeps bits from 1st controller in pair.
MASK_JACK_2 = %11110000 ; Inverse mask; keeps bits from 2nd controller in pair.
MASK_JACK_3 = %00001111 ; Keeps bits from 1st controller in pair.
MASK_JACK_4 = %11110000 ; Inverse mask; keeps bits from 2nd controller in pair.

; Note that 0 bit is pressed.  1 bit is not pressed.

; Reading "JACK" (PORTA, PORTB) registers gives two joystick values. The
; joystick's bits in the high nybble should be right shifted into the low nybble
; for testing. Or just use the STICKn shadow register as that is its purpose.

; Bits for STICKn Shadow Registers

MASK_STICK_RIGHT = %11110111
MASK_STICK_LEFT =  %11111011
MASK_SITCK_UP =    %11111101
MASK_STICK_DOWN =  %11111110

; AND with STICKn; If $00, then pressed. If $01, then not pressed.

STICK_RIGHT = %00001000 
STICK_LEFT =  %00000100
SITCK_UP =    %00000010
STICK_DOWN =  %00000001

; PACTL and PBCTL

MASK_PORT_SERIAL_IRQ =   %01111111 ; (Read)
MASK_MOTOR_CONTROL =     %11110111 ; PACTL Peripheral motor control (cassette)
MASK_COMMAND_IDENT =     %11110111 ; PBCTL Peripheral command identification
MASK_PORT_ADDRESSING =   %11111011 ; PACTL #00 = Port direction control,
                                   ; $01 = Read port.
MASK_SERIAL_IRQ_ENABLE = %11111110

PORT_SERIAL_IRQ =   %10000000 ; (Read)
MOTOR_CONTROL =     %00001000 ; PACTL
COMMAND_IDENT =     %00001000 ; PBCTL
PORT_ADDRESSING =   %00000100
SERIAL_IRQ_ENABLE = %00000001

; PBCTL for the XL

MASK_SELECT_OS_ROM =      %11111110 ; Turn OS ROM on and off
MASK_SELECT_BASIC_ROM =   %11111101 ; Turn BASIC ROM on and off
MASK_LED_1_KEYBOARD =     %11111011 ; 1200XL LED 1, enable/disable keyboard
MASK_LED_2_INTL_CHARSET = %11110111 ; 1200XL LED 2, enable international character set
MASK_SELF_TEST_ROM =      %01111111 ; Expose Self Test at $5000

SELECT_OS_ROM =      %00000001
SELECT_BASIC_ROM =   %00000010
LED_1_KEYBOARD =     %00000100
LED_2_INTL_CHARSET = %00001000
SELF_TEST_ROM =      %10000000

.endif ; _PIA_
