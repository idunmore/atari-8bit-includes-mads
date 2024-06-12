; DOS.asm - DOS (Disk Operating System) Vectors and Values for the
;           MADS assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Includes

        icl 'common.asm'
        icl 'macro_debugging.asm'

; Do NOT try and apply these definitions if they are already defined.
.ifndef _DOS_

; Sentinel to allow detection of prior INCLUSION
.def _DOS_

; DOS Run & Initialization Vectors

RUNAD =   $02E0 ; [WORD] DOS uses this as the run-address read from either
                ;        disk sector 1 (boot sector) or a binary file.  If set,
                ;        the OS will jump to this address after loading/booting.
                
INITAD =  $02E2 ; [WORD] Initialization address read from the disk. An autoboot
                ;        file must load an address value into either RUNAD above
                ;        or INITAD. The code pointed to by INITAD will be run as
                ;        soon as that location is loaded. The code pointed to by
                ;        RUNAD will be executed only after the entire load
                ;        process has been completed. To return control to DOS
                ;        after the execution of your program, end your code with
                ;        an RTS instruction.

.endif ; _DOS_

