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

COLRSH = $4F ; [BYTE] Attract Mode Color Shift - EORed [XORed] w/ COLOR values
             ;        to cycle colors during Attract Mode (see ATRACT).  Follows
             ;        value of RTCLKM ($19), which changes every ~4.27 seconds
             ;        resulting in a color cycle on that interval.

TEMP =   $50 ; [BYTE] Temporary register for display handler (used in moving
             ;        data to/from the screen).
TMPCHR = $50 ; [BYTE] Alias for TEMP
HOLD1 =  $51 ; [BYTE] Temporary register for display handler (number of display
             ;        list entries).

; Text Editor/Text Window Values

LMARGN = $52 ; [BYTE] E: Left column margin for text mode (GR.0/ANTIC 2)
             ;           SCREEN left = 0; DEFAULT margin = 2
RMARGN = $53 ; [BYTE] E: Right column margin for text mode (GR.0/ANTIC 2)
             ;           DEFAULT margin = 39 ($27)
ROWCRS = $54 ; [BYTE] S: Cursor ROW (Y) position for TEXT and GRAPHICS modes
COLCRS = $55 ; [WORD] S: Cursor COLUMN (X) position for TEXT and GRAPHICS modes

DINDEX = $57 ; [BYTE] S: Current Display/Screen mode
SAVMSC = $58 ; [WORD] Address of start (top left corner) of screen memory

OLDROW = $5A ; [BYTE] Previous CURSOR ROW (Y) from ROWCRS ($54);
             ; used for DRAWTO and FILL
OLDCOL = $5B ; [WORD]Previous CURSOR COLUMN (X) from  COLCRS ($55/$56);
             ; ysed for DRAWTO and FILL
OLDCHR = $5D ; [BYTE] Prior value of character at cursor; used to restore
             ;        character under the cursor after cursor movement
OLDADR = $5E ; [WORD] Memory location of cursor, used with OLDCHR to restore
             ;        character under the cursor after cursor movement

; NEWROW & NEWCOL are initialized to the vales in ROWCRS and COLCRS, which
; represent the destination for DRAWTO and FILL operations.  This is done so
; that ROWCRS and COLCRS can be modified during these routines:

NEWROW = $60 ; [BYTE] Destination POINT (ROW/Y) for DRAWTO and FILL
NEWCOL = $62 ; [WORD] Destination POINT (COLUMN/X) for DRAWTO and FILL

LOGCOL = $64 ; [BYTE] Position of CURSOR within a Logical Line, an offset from
             ;        the first character.  Logical lines can be THREE screen
             ;        lines (120 characters - 0-119 or $00-$77).

ADRESS = $65 ; [WORD] Temporary storage for display handler for Display List
             ;        address, line buffer, ROW/COL address, SAVMSC, etc.

MLTTMP = $66 ; [WORD] Multi-use temporary storage; first byte used by OPEN,
             ;        also used by display hander as temporary storage.
SAVADR = $68 ; [WORD] Temporary storage, used with ADRESS (above), for saving
             ;        values during manipulation; used for data under cursor
             ;        and moving line data on screen.

RAMTOP = $6A ; [BYTE] RAM size, in Pages (of 256/$100 bytes).  Last available
             ;        RAM location is (RAMTOP * 256) - 1.

BUFCNT = $6B ; [BYTE] E: Buffer Count - current logical line size
BUFSTR = $6C ; [WORD] Temporary storage; returns character pointed to by 
             ;        BUFCNT.  Editor GETCH pointer.  Editor Low byte.

BITMSK = $6E ; [BYTE] Bit Mask - in OS bit-mapping routines, also used as a
             ;        temporary storage register for the display handler.

SHFAMT = $6F ; [BYTE] Pixel justification: the amount to shift the right
             ;        justified pixel data on output or the amount to shift the
             ;        input data to right justify it.

ROWAC  = $70 ; [WORD] Row Accumulator - working accumulator for ROW point
             ;        plotting and ROWINC inc/dec operations
COLAC  = $72 ; [WORD] Column Accumulator - working accumulator for COLUMN point
             ;        plotting and COLINC inc/dec operations

ENDPT  = $74 ; [WORD] End point of the line to be drawn.  Contains larger value
             ;        of DELTAR or DELTAC (below) and used with ROWAC/COLAC
             ;        when plotting line points.
DELTAR = $76 ; [BYTE] Delta Row - the ABS value of NEWROW - ROWCRS, used to
             ;        define the slope of the line to be drawn.
DELTAC = $77 ; [WORD] Delta Column - the ABS value of NEWCOL - COLCRS, used to
             ;        define the slope of the line to be drawn.

; ROWINC and COLINC control the direction of the line drawing routine. The
; values represent the signs derived from the value in NEWROW, minus the value
; in ROWCRS and the value in NEWCOL minus the value in COLCRS.

ROWINC = $79 ; [BYTE] Row INCrecemet or DECrement value (plus, or minus, 1)
COLINC = $7A ; [BYTE] Column INCrecemet or DECrement value (plus, or minus, 1)

; SWPFLG - S: text window swap control. Is equal to 255 ($FF) if the text
; window RAM and regular RAM are swapped; otherwise, it is equal to zero.
; In split-screen modes, the graphics cursor data and the text window data are
; frequently swapped in order to get the values associated with the area being
; accessed into the OS data base locations 84 to 95 ($54 to $5F). SWPFLG helps
; to keep track of which data set is in these locations.

SWPFLG = $7B ; [BYTE] S: Text window Swap control - $00 = Graphics, $FF = Text 
HOLDCH = $7C ; [BYTE] S: Character value for shifting - Character is moved here
             ;        before CTRL or SHIT logic are processed for it.
INSDAT = $7D ; [BYTE] S: Temporary storage byte used by the display handler for
             ; the character under the cursor and end of line detection.
COUNTR = $7E ; [WORD] S: Loop control for line drawing.  Starts out containing
             ;        the larger value of either DELTAR or DELTAC. This is the
             ;        number of iterations required to draw a line. As each
             ;        point on a line is drawn, this value is decremented. When
             ;        COUNTR equals zero, the line is complete.

; The second half ($80-$FF) is reserved for ROM Cartridges and the
; floating-point package.  If these are not used, then their respective areas
; are available for other purposes (user programs).

; Floating-Point Package Registers and Values

; Floating point register zero; holds a six-byte internal form of the FP number.
;
; The value at locations 212 ($D4) and 213 ($D5) are used to return a two-byte
; value in the range of zero to 65536($FFFF) to the BASIC program from USR calls
; (LSB in 212, MSB in 213).
;
; The floating point package, if used, requires all locations from 212 ($D4) to
; 255 ($FF).
;
; All six bytes of FRO can be used by a machine language routine, provided FRO
; isn't used and no FP functions are used by that routine . To use 16 bit values
; in FP, you would place the two bytes of the number into the least two bytes of
; FRO (212,213; $D4, $D5), and then do a JSR to $D9AA (55722), which will
; convert the integer to its FP representation, leaving the result in FRO.
;
; To reverse this operation, do a JSR to $D9D2 (55762).

FR0 =    $D4 ; [FLOAT] Floating point register and USR return value to BASIC.
FRE =    $DA ; [FLOAT] Floating point register (extra) ($DA-$DF)
FR1 =    $E0 ; [FLOAT] Floating point register 1 ($E0-$E5)
FR2 =    $E6 ; [FLOAT] Floating point register 2 ($E6-$EB)
FRX =    $EC ; [BYTE] Spare floating point register
EEXP =   $ED ; [BYTE] Exponent (E)
NSIGN =  $EE ; [BYTE] Sign of the floating point NUMBER
ESIGN =  $EF ; [BYTE] Sign of the floating point EXPONENT

FCHRFL = $F0 ; [BYTE] First Character flag
DIGRT =  $F1 ; [BYTE] Number of digits to the right of the decimal point
CIX =    $F2 ; [BYTE] Character index; offset to the input text buffer (INBUFF)
INBUFF = $F3 ; [WORD] Input for text to BCD conversion, w/ output at LBUFF
ZTEMP1 = $F5 ; [WORD] Floating point temporary register
ZTEMP4 = $F7 ; [WORD] Floating point temporary register
ZTEMP3 = $F9 ; [WORD] Floating point temporary register
RADFLG = $FB ; [BYTE] 0 = Radians (Default), 6 = degrees (also DEGFLG)
DEGFLG = $FB ; [BYTE] 0 = Radians (Default), 6 = degrees (also RADFLG)
FLPTR =  $FC ; [WORD] Pointer to first Floating Point number for operation
FPTR2 =  $FE ; [WORD] Pointer to second Floating Point number for operation

; PAGE ONE ($100-$1FF) Is the STACK area for the OS, DOS and BASIC.
;
; The STACK pushes down from $1FF to $100.
;
; STACK overflow results in it wrapping around to $1FF.

; PAGE TWO ($200-$2FF) Various Shadow Registers, Bit Fields, etc.

VDSLST =  $200 ; [WORD] Display List Interrupt Service Routine Vector
VDSLSTL = $200 ; [BYTE] Display List Interrupt Service Routine Vector (Low Byte)
VDSLSTH = $201 ; [BYTE] Display List Interrupt Service Routine Vector (High Byte)


.endif ; _OS_