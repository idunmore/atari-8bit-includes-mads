; OS.asm - OS level Registers/Shadow Registers, Values, Vectors, Bit-Settings,
;          MASKs, for the MADS Assembler.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE

; Do NOT try and apply these definitions if they are already defined.
.ifndef _OS_

; Sentinel to allow detection of prior INCLUSION
.def _OS_

; This file contains the definitions for the OS registers and values, as well as
; shadow registers for various ANTIC, GTIA, POKEY and other custom ICs, 
; 
; There is overlap between this file, and those for the custom ICs, but any
; conflicts are automatically excluded so these includes can safely be used
; in combination.

; Page Zero - "Zero Page" - OS Registers & Vectors

; The first half of page zero ($00-$7F) is reserved for the OS.

; The second half ($80-$FF) is reserved for ROM Cartridges and the
; floating-point package.  If these are not used, then their respective areas
; are available for other purposes (user programs).

LINZBS = $00 ; [WORD] LINBUG RAM, replaced by MONITOR RAM (see OS B Listing, P4)
CASINI = $02 ; [WORD] Cassette BOOT Initialization Vector
             ;        JSR through here if Cassette Boot is successful.
             ;        Bytes 5-6 of the Cassette Boot Header are loaded here.
RAMLO  = $04 ; [WORD] RAM pointer for power-on memory test. Also stores the disk
             ;        boot address for boot continuation routine

TRAMSZ = $06 ; [BYTE] Top Page of RAM (RAMTOP)
CTAFLG = $06 ; [BYTE] Cartridge A (Left) Flag - Non-zero if cartridge A present
TSTDAT = $07 ; [BYTE] RAM Test Data Register
CTBFLG = $07 ; [BYTE] Cartridge B (Right) Flag - Non-zero if cartridge B present

WARMST = $08 ; [BYTE] $FF = Warm Start (normal RESET),
             ;        $00 = Cold Start (power-up in progress)
BOOT =   $09 ; [BYTE] $00 = Boot unsuccessful
             ;        $01 = Disk book successful - reset via DOSVEC
             ;        $02 = Cassette boot successful - reset via CASINI
             ;        $03 = Both successful - reset via CASINI (trap reset)

DOSVEC = $0A ; [WORD] Start vector for DOS/disk (or non-cartridge) software
             ;        (also vector for DUP.SYS from BASIC)
DOSINI = $0C ; [WORD] Initialization vector for disk boot, DOS or cassette
             ;        RUN address (will be ZERO if no cass/disk boot succeeded)

APPMHI = $0E ; [WORD] Application Memory High Limit - Top of BASIC program area,
             ;        used by OS and BASIC.  This is also the LOWEST addess that
             ;        can be used for setting up screen memory or a Display List
             ;        in a BASIC program (allocation is top-down).

; Don't redefine POKEY shadow registers; the primary IC-specific files
; (e.g., POKEY.asm) have precedence.

.ifndef _POKEY_

POKMSK = $10 ; [BYTE] IRQEN - See POKEY.asm/IRQEN/IRQST for Bit-Settings

.endif ; _POKEY_

BRKKEY = $11 ; [BYTE] $00 = Break pressed, $80 Break pressed during I/O,
             ;        any other values = Break NOT pressed

; Real-Time Clock

RTCLOK = $12 ; [24bt] Real-Time Clock - a big-endian, 24-bit/3-byte counter
             ;        Unlike other Atari registers, RTCLOK stores the MSB
             ;        in the lowest address, and the LSB in the highest.
             ;             
             ;        $14 increments once per Vertical Blank (60 times a second
             ;        for NTSC, 50 times a second for PAL [aka a "jiffy"]).
             ;        When $14 = $FF, the next increment resets it to 0 and
             ;        increments $13. When $13 = $FF, the next increment resets
             ;        it to 0 and increments $12 (about every 18.2 minutes).
RTCLKH = $12 ; [BYTE] RTCLOK High (MSB) byte
RTCLKM = $13 ; [BYTE] RTCLOK Middle byte
RTCLKL = $14 ; [BYTE] RTCLOK Low (LSB) byte

; CIO (Central Input/Output) & IOCB (I/O Control Block)

BUFADR = $15 ; [WORD] Temporary address of the current disk buffer
ICCOMT = $17 ; [BYTE] CIO command (command for CIO vector/lookup table)
DSKFMS = $18 ; [WORD] Disk File Manager Management System vector (JMPTBL in DOS)
DSKUTL = $1A ; [WORD] Disk Utilities pointer (BUFADR in DOS)

PTIMOT = $1C ; [BYTE] Printer Timeout (~64 seconds per 60 counts)
PBPNT  = $1D ; [BYTE] Printer Buffer Pointer; byte index into print buffer
             ;        (values 0 to PBUFSZ
PBUFSZ = $1E ; [BYTE] Printer Buffer Size (typically 40 bytes for normal lines)
PTEMP =  $1F ; [BYTE] Temporary register used byt the printer handler for the
             ;        value of the character being output to the printer

.endif ; _OS_