; math.asm - Basic MATH macros for multi-byte values for the MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Do NOT try and apply these definitions if they are already defined.
.ifndef _MATH_

; Sentinel to allow detection of prior INCLUSION
.def _MATH_

; IncWord - Increment a 16-bit value, stored at wordAddress, by 1

.macro IncWord wordAddress
        ; Use AddByteToWord to increment by 1
        AddByteToWord :wordAddress, 1
        
.endm ; IncWord

; AddByteToWord - Adds a byte value to the 16-bit value stored at wordAddress

.macro AddByteToWord wordAddress, value
        ; Sanity/error checking
        .if :0 != 2
                .error "AddByteToWord: Requires wordAddress and value"
        .endif

        .if :value < 0 || :value > 255
                .error "AddByteToWord: value must be between 0 and 255"
        .endif

        clc
        lda :wordAddress        
        adc #:value
        sta :wordAddress
        lda :wordAddress+1
        adc #$00
        sta :wordAddress+1

.endm ; AddByteToWord

; AddWordToWord - Adds a 16-bit value to the 16-bit value stored at wordAddress

.macro AddWordToWord wordAddress, value
        ; Sanity/error checking
        .if :0 != 2
                .error "AddByteToWord: Requires wordAddress and value"
        .endif

        .if :value < 0 || :value > 65536
                .error "AddByteToWord: value must be between 0 and 65535"
        .endif

        clc
        lda :wordAddress
        adc #<:value
        sta :wordAddress
        lda :wordAddress+1
        adc #>:value
        sta :wordAddress+1

.endm ; AddWordToWord

.endif ; _MATH_
