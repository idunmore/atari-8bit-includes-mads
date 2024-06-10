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
PTEMP =  $1F ; [BYTE] Temporary register used by the printer handler for the
             ;        value of the character being output to the printer

; ZIOCB - Page Zero - "Zero Page" copy of CIO IOCB (at $340-$3BF)

; Values here follow the structure of the IODB at $340-$3BF.  On initiation,
; CIO operations copy the IOCB to the ZIOCB (here), and when the operation
; completes, they are copied back to the IOCB (user area).

ICHIDZ = $20 ; [BYTE] Handler Index (into Device Name Table, $FF if nothing open)
ICDNOZ = $21 ; [BYTE] Device or drive number (MAXDEV in DOS); max number of devices
ICCOMZ = $22 ; [BYTE] Command (sets what I/O command to perform, and how the
             ;        IOCB is formatted for that command)
ICSTAZ = $23 ; [BYTE] IOCB LAST status result
ICBALZ = $24 ; [BYTE] Buffer address for data transfer (Low byte) OR the address
             ;        of the file name for commands such as OPEN, STATUS, etc.
ICBAHZ = $25 ; [BYTE] Buffer address for data transfer (High byte); see ICBALZ
ICPTLZ = $26 ; [BYTE] Put Byte routine address (Low byte) - the address -1 byte
             ;        of the the device's "put one byte" routine.  It points to
             ;        CIO's "IOCB not open" on a CLOSE statement
ICPTHZ = $27 ; [BYTE] Put Byte routine address (High byte); see ICPTLZ
ICBLLZ = $28 ; [BYTE] Buffer length byte count for PUT/GET oeprations (Low byte)
ICBLHZ = $29 ; [BYTE] Buffer length byte count for PUT/GET operations (High byte)
ICAX1Z = $2A ; [BYTE] Aux Info - Byte 1 - Used by OPEN to specify file access type)
ICAX2Z = $2B ; [BYTE] Aux Info - Byte 2 - CIO working variable; also used by
             ;        some serial port functions
ICAX3Z = $2C ; [BYTE] Aux Info - Byte 3 - Used by BASIC NOTE/POINT commands for
             ;        transfer of disk sector numbers.
ICAX4Z = $2D ; [BYTE] Aux Info - Byte 4 - see ICAX3Z
ICAX5Z = $2E ; [BYTE] Aux Info - Byte 5 - The byte being access with the sector
             ;        inidcated in ICAZ3Z/4Z.  Also used for hte IOCB * 16
             ;        (each ICOB is 16 bytes long)
ICAX6Z = $2F ; [BYTE] Aux Info - Byte 6 - Spare byte; also labelled CIOCHR -
             ;        temporary storage for the character byte in the current
             ;        PUT operation

; SIO (Serial Input/Output) and DCB (Device Control Block)

STATUS = $30 ; [BYTE] SIO status value for current/last operation; also used
             ;        as storage register for timeout, BREAK abort and error
             ;        values during SIO routines:
             ;        $01 = Operation complete (no errors)
             ;        $8A = Device timeout (doesn't respond)
             ;        $8B = Device NAK (Negative/Non Acknowledgement)
             ;        $8C = Serial bus input rraming error
             ;        $8E = Serial bus data frame overrun error
             ;        $8F = Serial bus data frame checksum error
             ;        $90 = Device done error
CHKSUM = $31 ; [BYTE] SIO/DCB data frame checsum (single byte sum w/ carry to LSB)

; SIO/DCB Buffers - BUFRLO/BUFRHI - BFENLO/BFENHI = buffer length, in bytes

BUFRLO = $32 ; [BYTE] SIO/DCB buffer address for data transfer (Low byte)
BUFRHI = $33 ; [BYTE] SIO/DCB buffer address for data transfer (High byte)
BFENLO = $34 ; [BYTE] SIO/DCB first address after BUFRLO/BUFRHI (Low byte)
BFENHI = $35 ; [BYTE] SIO/DCB first address after BUFRLO/BUFRHI (High byte)

CRETRY = $36 ; [BYTE] Command frame retries; default $0D (13)
DRETRY = $37 ; [BYTE] Device retries; default $01 (1)

BUFRFL = $38 ; [BYTE] Flag: Data buffer full - $FF = FULL (flag set)
RECVDN = $39 ; [BYTE] Flag: Recieve done - $FF = DONE (flag set)
XMTDON = $3A ; [BYTE] Flag: Transmit done - $FF = DONE (flag set)
CHKSNT = $3B ; [BYTE] Flag: Checksum sent - $FF = SENT (flag set)
NOCKSM = $3C ; [BYTE] Non-zero: No Checksum, Zero: Checksum follows

; Cassette I/O

BPTR =   $3D ; [BYTE] Cassette Buffer Pointer; byte index into cassette buffer
             ;        (values 0 to value in BLIM/$028A).  If BPTR value = BLIM
             ;        value is EMPTY if READING or FULL if WRITING.  Default $80
FTYPE =  $3E ; [BYTE] Cassette Inter-Record Gap - $01-$7F (Positive) = Normal,
             ;        $80-$00 (Negative) = Short (continuous)
FEOF =   $3F ; [BYTE] Flag: End of File - $00 = Not EOF, Non-zero = EOF
FREQ =   $40 ; [BYTE] Number of beeps for cassette start - $01 = Play, $02 = Record
SOUNDR = $41 ; [BYTE] Enable I/O sounds via speaker - $00 = OFF, Non-$00 = ON

; Critical I/O

CRITIC = $42 ; [BYTE] Flag: Critical I/O - $00 = Normal I/O, !$00 = Critical I/O
             ;        When CRITIC is SET (non-zero):
             ;           - Deferred VBI is disabled
             ;             (Immediate VBI is still active)
             ;           - Software Timers 2, 3, 4 and 5 stop
             ;           - Keyboard repeat is disabled

; Disk FMS (File Management System) Registers

FMZSPG = $43 ; Byte 1 of 7-byte block of Disk File Management System registers:
ZBUFP =  $43 ; [WORD] Pointer to the filename for disk I/O
ZDRVA =  $45 ; [WORD] Drive pointer/sector temporary value
ZSBA =   $47 ; [WORD] Sector buffer pointer/address
ERRNO =  $49 ; [BYTE] Disk I/O Error number, FMS default = $9F

; Cassette Boot Flags

CKEY =   $4A ; [BYTE] Cassette Boot Key - Set by holding START during Cold Start
CASSBT = $4B ; [BYTE] Flag: Cassette Boot - $00 = Cassette boot unsuccessful
             ;        (See BOOT / $09)

; S: Device Status

DSTAT =  $4C ; [BYTE] S: Device (Screen) Status; used by display handler, and
             ;        to indicate memory too small for requested screen mode,
             ;        cursor out of range and BREAK abort status

; Attract Mode - Timers, Flags & Masks

ATRACT = $4D ; [BYTE] Attract Mode Flag - $00 = Attract Mode OFF
             ;        After no keyboard input for several minutes (about 9,
             ;        varies with NTSC/PAL) the OS enters Attract Mode (reduces
             ;        luminance and cycles colors) to prevent CRT burn-in.
             ;        Set to $00 periodically to defeat attract mode.

DRKMSK = $4E ; [BYTE] Attract Mode Dark Mask - ANDed w/ COLOR values to yield
             ;        50% luminance (darken the screen) during Attract Mode
             ;        (see ATRACT).  $FE by default, $F6 in Attract Mode.
             ;        The LOW NYBBLE of a color byte is the Luminance Value.

COLRSH = $4F ; [BYTE] Attract Mode Color Shift - EORed [XORed] w/ COLOR values to
             ;        cycle colors during Attract Mode (see ATRACT).  Follows
             ;        value of RTCLKM ($19), which changes every ~4.27 seconds
             ;        resulting in a color cycle on that interval.

.endif ; _OS_