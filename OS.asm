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
;
; Note: By convention, the hardware registers, vectors and other values only
;       designate their "type" (length) if they are NOT bytes (e.g. they have
;       a [WORD] designation).  This is because most such registers have an
;       explicit L/H suffix register.  The OS memory map does not, so types
;       [BYTE], [WORD], [FLOAT], [XXbt] are used to clarify the register size.
;
;       Shadow Registers that are duplicated from custom IC files do not have
;       type/size designations and simply refer to their primary definition.

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
; (e.g., POKEY.asm) have precedence and more details.

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

VPRCED = $0202 ; [WORD] Peripheral proceed line vector
VINTER = $0204 ; [WORD] Peripheral interrupt vector.
VBREAK = $0206 ; [WORD] (6502) BRK instruction ($00) vector; used for setting
               ;        break points for assembly language debugging

; Don't redefine POKEY shadow registers; the primary IC-specific files
; (e.g., POKEY.asm) have precedence and more details.

.ifndef _POKEY_

VKEYBD = $0208 ; [WORD] POKEY Keyboard interrupt vector
VSERIN = $020A ; [WORD] POKEY Serial I/O receive data ready interrupt vector
VSEROR = $020C ; [WORD] POKEY Serial I/O transmit data ready interrupt vector
VSEROC = $020E ; [WORD] POKEY Serial bus transmit complete interrupt vector

VTIMR1 = $0210 ; [WORD] POKEY Timer 1 interrupt vector
VTIMR2 = $0212 ; [WORD] POKEY Timer 2 interrupt vector
VTIMR4 = $0214 ; [WORD] POKEY Timer 4 interrupt vector

.endif ; _POKEY_

VIMIRQ = $0216 ; [WORD] Immediate IRQ vector.   All IRQs vector through this
               ;        location. VIMIRQ normally points to the system IRQ
               ;        handler. You can steal this vector to do your own IRQ
               ;        Interrupt processing (see IRQEN/IRQST in POKEY.asm).


; System Countdown Timers

; (Table per Ken Jennings: https://github.com/kenjennings/Atari-Mads-Includes/)

; TIMER       CDMTV1       CDMTV2       CDMTV3       CDMTV4       CDMTV5
;---------------------------------------------------------------------------
; Decrement | Stage 1    | Stage 2    | Stage 2    | Stage 2    | Stage 2
; in VBI    | (Immediate)| (Deferred) | (Deferred) | (Deferred) | (Deferred)
;---------------------------------------------------------------------------
; Interrupt | CDTMA1     | CDTMA2     |            |            |
; Vector    |            |            |            |            |
;---------------------------------------------------------------------------
; Countdown |            |            | CDTMF3     | CDTMF4     | CDTMF5
; Flag      |            |            |            |            |
;---------------------------------------------------------------------------       
; OS Use?   | I/O Timing | No         | Cassette   | No         | No
;           |            |            | I/O        |            |
;---------------------------------------------------------------------------

CDTMV1 = $0218 ; [WORD] System Countdown Timer value 1
CDTMV2 = $021A ; [WORD] System Countdown Timer value 2
CDTMV3 = $021C ; [WORD] System Countdown Timer value 3
CDTMV4 = $021E ; [WORD] System Countdown Timer value 4
CDTMV5 = $0220 ; [WORD] System Countdown Timer value 5

; Vertical Blank Interrupt Vectors

VVBLKI = $0222 ; [WORD] VBLANK Immediate (Stage 1) interrupt vector
VVBLKD = $0224 ; [WORD] VBLANK Deferred  (Stage 2) interrupt vector

; System Countdown Timer Interrupt Vectors and Flags

CDTMA1 = $0226 ; [WORD] System Countdown Timer 1 vector
CDTMA2 = $0228 ; [WORD] System Countdown Timer 2 vector
CDTMF3 = $022A ; [BYTE] Set when CDTMV3 counts down to 0
SRTIMR = $022B ; [BYTE] keyboard software repeat timer
CDTMF4 = $022C ; [BYTE] Set when CDTMV4 counts down to 0
INTEMP = $022D ; [BYTE] Temporary value used by SETVBL
CDTMF5 = $022E ; [BYTE] Set when CDTMV5 counts down to 0

; Don't redefine ANTIC shadow registers; the primary IC-specific files
; (e.g., ANTIC.asm) have precedence and more details.

.ifndef _ANTIC_

SDMCTL = $022F ; DMACTL
SDLSTL = $0230 ; DLISTL
SDLSTH = $0231 ; DLISTH

LPENH =  $0234 ; (Read) PENH
LPENV =  $0235 ; (Read) PENV

.endif ; _ANTIC_

; Don't redefine POKEY shadow registers; the primary IC-specific files
; (e.g., POKEY.asm) have precedence and more details.

.ifndef _POKEY_

SSKCTL = $0232; SKCTL

.endif ; _POKEY_

SPARE  = $233 ; [BYTE] Spare byte (may be used by later OS revisions)
BRKKY  = $236 ; [WORD] BREAK Key interrupt vector (OS rev. B only)

;Two spare bytes at $238-$239 (may be used by later OS revisions)

; SIO Command Frame - Used during Serial I/O - Not Intended for User Access

CDEVIC = $023A ; [BYTE] SIO Bus ID number
CCOMND = $023B ; [BYTE] SIO Bus Command Code
CAUX1 =  $023C ; [BYTE] Command auxiliary byte 1
CAUX2 =  $023D ; [BYTE] Command auxiliary byte 2

TMPSIO = $023E ; [BYTE] SIO temporary RAM register
ERRFLG = $023F ; [BYTE] SIO Error flag (any device error, except timeout)
DFLAGS = $0240 ; [BYTE] Disk flags read from first byte of boot sector (sector 1)
DBSECT = $0241 ; [BYTE] Number of Boot sectors read (comes from first disk record)
BOOTAD = $0242 ; [WORD] Address where disk boot loader will be placed

COLDST = $0244 ; [BYTE] Coldstart Flag - $00 = pressing RESET will warmstart,
               ;                         $01 = pressing RESET will coldstart

DSKTIM = $0246 ; [BYTE] Disk I/O timeout register

LINBUF = $0247 ; [40 BYTES] ($0247-$26E) 40 byte character line buffer;
               ;            temporarily buffers one line of text for screen
               ;            editor when it is moving screen data

               ;$26E - Last byte of LINBUF buffer

; Don't redefine POKEY shadow registers; the primary IC-specific files
; (e.g., POKEY.asm) have precedence and more details.

.ifndef _POKEY_

; Paddle Potentiometer (Dial) Shadow Registers

PADDL0 = $0270 ; POT0
PADDL1 = $0271 ; POT1
PADDL2 = $0272 ; POT2
PADDL3 = $0273 ; POT3
PADDL4 = $0274 ; POT4
PADDL5 = $0275 ; POT5
PADDL6 = $0276 ; POT6
PADDL7 = $0277 ; POT7

.endif ; _POKEY_

; Don't redefine GTIA shadow registers; the primary IC-specific files
; (e.g., GTIA.asm) have precedence and more details.

.ifndef _GTIA_

GPRIOR = $026F ; PRIOR
STRIG0 = $0284 ; TRIG0
STRIG1 = $0285 ; TRIG1
STRIG2 = $0286 ; TRIG2
STRIG3 = $0287 ; TRIG3

.endif ; _GTIA_

; Don't redefine PIA shadow registers; the primary IC-specific files
; (e.g., PIA.asm) have precedence and more details.

.ifndef _PIA_

; Joystick Positions, decoded from PORTA, PORTB - see PIA.asm for position values

STICK0 = $0278 ; Joystick 1 
STICK1 = $0279 ; Joystick 2 
STICK2 = $027A ; Joystick 3 
STICK3 = $027B ; Joystick 4 

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

; Cassette I/O Shadow Registers

CSTAT =  $0288 ; [BYTE] Cassette Status register.
WMODE =  $0289 ; [BYTE] Cassette Write mode; $00 = read, $80 (128) = write
BLIM =   $028A ; [BYTE] Cassette Data Buffer Limit; Number of active bytes in
               ;        the buffer for the record currently being read/written
               ;        (see CASBUF and BPTR).  Range is from $00 to $80 (128).

;Five spare bytes at $28B-$28F (may be used by later OS revisions)

TXTROW = $0290 ; [BYTE] E: Text window cursor ROW ($00-$03, window has 4 rows)
TXTCOL = $0291 ; [WORD] E: Text window cursor COLUMN ($00-$27, window has 40
               ;        cols). MSB will always be $00
TINDEX = $0293 ; [BYTE] Split-screen Text Window graphics mode
TXTMSC = $0294 ; [WORD] Address of first byte of text window when split screen
               ;        is active (equivalent of SAVMSC for split-screen mode)
TXTOLD = $0296 ; [6 BYTES] $0296-$029B; Split screen versions of OLDROW [BYTE],
               ; OLDCOL [WORD], OLDCHR [BYTE], OLDADR [WORD]
TMPX1 =  $029C ; [BYTE] Temporary register; Scroll Loop Count record
HOLD3 =  $029D ; [BYTE] Temporary register
SUBTMP = $029E ; [BYTE] Temporary storage
HOLD2 =  $029F ; [BYTE] Temporary registers

; DMASK - Pixel Location Mask
;
; DMASK contains zereos for all bits in the current byte which do NOT correspond
; to the pixel to be operated on, and ones for all bits which do correspond.

; Mask     | Modes      | Pixels/Byte (or Bytes/Pixel)
; -------------------------------------------------------------
; 11111111 | 0, 1, 2    | One Pixel per Screen Display Byte
; -------------------------------------------------------------
; 11110000 | 9, 10, 11  | Two pixels per byte/4 bits per pixel
; 00001111 |            | (16-color modes)
; -------------------------------------------------------------
; 11000000 | 3, 5, 7    | Four pixels per byte/2 bits per pixel
; 00110000 |            | (4-color modes)
; 00001100 |            |
; 00000011 |            |
; -------------------------------------------------------------
; 10000000 | 4, 6, 8    | Eight pixels per byte/1 bit per pixel
; 01000000 |            | (4-color modes)
; .. to .. |            |
; 00000001 |            |

DMASK =  $02A0 ; [BYTE] Pixel Location Mask

TMPLBT = $02A1 ; [BYTE] Temporary value for DMASK bit mask
ESCFLG = $02A2 ; [BYTE] ESCAPE Flag; set to $80 when ESC key pressed,
               ;        $00 for other characters.
TABMAP = $02A3 ; [15 BYTES] This is a 120-bit value (one bit per Character for
               ;            a logical screen line), where a set bit (1) means a
               ;            TAB is SET for that position, unset (0) = NO TAB          

; LOGMAP - Logical Line Start Bit Map

; These locations map the beginning physical line number for each logical line
; on the screen (initially 24, for GR.O). Each bit in the first three bytes
; shows the start of a logical line if the bit equals one (three bytes equals
; eight bits * three equals 24 lines on the screen).
; 
; The map format is as follows:

; Bit      7    6    5    4    3    2    1    0     Byte
; ------------------------------------------------------
; Line     0    1    2    3    4    5    6    7      690
;          8    9   10   11   12   13   14   15      691
;         16   17   18   19   20   21   22   23      692
;          -    -    -    -    -    -    -    -      693
;
; The last byte is ignored.

LOGMAP = $02B2 ; [4 BYTES]. Logical line start bit map

INVFLG = $02B6 ; [BYTE] E: Inverse Flag - $00 = Normal, $80 = Inverse
               ;        Note this applies to INPUT (entering characters) NOT
               ;        the OUTPUT (setting to $80 does not result in PRINTED
               ;        characters being Inverse.
               
FILFLG = $02B7 ; [BYTE] Fill Flag; If operation is FILL, this is set (non-zero)
               ;        else this is a DRAW operation and this is unset/zero
TMPROW = $02B8 ; [BYTE] Temporary register for ROW used by ROWCRS
TMPCOL = $02B9 ; [WORD] Temporary register for COLUMN used by COLCRS
SCRFLG = $02BB ; [BYTE] Scroll Flag; set if a scroll occurs, contains the number
               ;        of physical lines within a logical line were removed
               ;        from the screen (logical lines are up to 3 physical lines
               ;        so this value ranges from $00-$02 (0-2)
HOLD4  = $02BC ; [BYTE] Temporary register used by the DRAW command; used to
               ;        safe/restore the vale in ATACHR during FILL operations
HOLD5  = $02BD ; [BYTE] Temporary register, same usage as HOLD4
SHFLOK = $02BE ; [BYTE] Shift and CTRL key flag; $00 for lowercase, $40 for
               ;        uppercase (SHIFT), $80 for control (CTRL) 
BOTSCR = $02BF ; [BYTE] Number of rows available for printing; $18 (24) for OS
               ;        Mode 0, 4 for text windows ands 0 for graphics modes	

; Don't redefine GTIA shadow registers; the primary IC-specific files
; (e.g., GTIA.asm) have precedence and more details.

.ifndef _GTIA_

; Playfield and Player/Missile Graphics Shadow Registers

PCOLOR0 = $02C0 ; COLPM0
PCOLOR1 = $02C1 ; COLPM1
PCOLOR2 = $02C2 ; COLPM2
PCOLOR3 = $02C3 ; COLPM3

COLOR0 =  $02C4 ; COLPF0
COLOR1 =  $02C5 ; COLPF1
COLOR2 =  $02C6 ; COLPF2
COLOR3 =  $02C7 ; COLPF3
COLOR4 =  $02C8 ; COLBK

.endif ; _GTIA_

GLBABS  = $02E0 ; [4 BYTES] Global variables, or four spare bytes if DOS is not
                ;           used (see RUNAD and INITAD below if DOS is present)

; Don't redefine DOS values; the primary system-specific files
; (e.g., DOS.asm) have precedence and more details.

.ifndef _DOS_

RUNAD =   $02E0 ; RUNAD (see DOS.asm) 
INITAD =  $02E2 ; INITAD (see DOS.asm)

.endif ; _DOS_

RAMSIZ = $02E4 ; [BYTE] Highest usable Page number (High byte) 
MEMTOP = $02E5 ; [WORD] Pointer to last byte usable by applications and DOS
MEMLO =  $02E7 ; [WORD] Pointer to start (bottom) of free memory; first free
               ;        byte available for program use

; Spare byte at $02E9 (may be used by later OS revisions)

; DVSTAT - Device Status Registers

; There are four device status registers (names for DVSTAB, DVSTTO and DVSTNB
; are not official).
;
; Values for DVSTAT:
;
; Bit   Decimal   Error
;  0       1      Invalid command frame received
;  1       2      Invalid data frame received
;  2       4      Output operation was unsuccessful
;  3       8      Disk is write-protected
;  4      16      System inactive (on standby)
;  7     128      Intelligent controller flag

DVSTAT = $02EA ; [BYTE] Command Status & Device ERROR Status
DVSTAB = $02EB ; [BYTE] Device Status Byte
DVSTTO = $02EC ; [BYTE] Device Maximum Timeout (in seconds)
DVSTNB = $02ED ; [BYTE] Number of Bytes (in output buffer)

; Cassette Baud Rate

; Defaults to 600 baud ($05CC), but is adjusted by POKEY in response to actual
; baud rate (varies due to drive motor speed variation, tape strectch, etc.)

CBAUDL = $02EE ; [BYTE] Cassette Baud (bps) rate (Low byte)
CBAUDH = $02EF ; [BYTE] Cassette Baud (bps) rate (Highbyte)

CRSINH = $02F0 ; [BYTE] Cursor Inhibit;  $00 = Cursor ON.  Not $00 = Cursor OFF
KEYDEL = $02F1 ; [BYTE] Key Delay Debounce/Delya Counter. Starts at 3,
               ; decremented each each frame until 0.
CH1 =    $02F2 ; [BYTE] Keyboard character code previously in CH -see POKEY.asm)

; Don't redefine ANTIC shadow registers; the primary IC-specific files
; (e.g., ANTIC.asm) have precedence and more details.

.ifndef _ANTIC_

CHACT  = $02F3 ; CHACT
CHBAS  = $02F4 ; CHBAS

.endif ; _ANTIC_

;Five spare bytes at $2F5-$2F9 (may be used by later OS revisions)

CHAR   = $02FA ; [BYTE] Internal code for last character value read or written
               ;        (internal code of ATACHR) 
ATACHR = $02FB ; [BYTE] Last value read or written at graphics cursor;
               ;        ATASCII in text modes. Color Number in others

; Don't redefine POKEY shadow registers; the primary IC-specific files
; (e.g., POKEY.asm) have precedence and more details.

.ifndef _POKEY_

CH = $02FC ; KBCODE

.endif ; _POKEY_

FILDAT = $02FD ; [BYTE] Color for the fill region in the XIO FILL command
DSPFLG = $02FE ; [BYTE] E: Display Flag, used in display control codes not
               ;        associated with an ESC character.
               ;        $00 = Normal operation, !$00 (non-zero) = Display cursor
               ;        controls instead of acting on them.
SSFLAG = $02FF ; [BYTE] Start/Stop Display Screen flag (scrolling stop/start
               ;        control. $00 = Normal scrolling, $FF = Stop scrolling

.endif ; _OS_