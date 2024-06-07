# Standards & Conventions
These are **provisional** standards and conventions for the label, symbol, macro, procedure, code and value/bits settings defined in this project.

## Files & Organization
Individual files are provided for each of the primary custom ICs (e.g., ANTIC, GTIA, POKEY, etc.) and various OS/DOS and Cartridges (e.g., Atari BASIC) contexts.

For example, ANTIC.asm contains hardware and shadow registers for the ANTIC chip, along with various bit setting/masking constants.

To improve compatibility with/each porting to other assemblers, macros are broken out into separate files.  This allows the register and memory maps, which are largely universal syntax, to be used directly without needing to edit them to exclude macros.

In some cases, a subset of capabilities provided by one IC might be broken out into a separate, smaller and more focused, file.  For example ANTIC.asm and display\_list.asm.  Where this is done, it is possible that the smaller file (display\_list.asm) requires definitions that are also present in the main file (ANTIC.asm); in which case they will be provided in **both** files, and will automatically disable one set to avoid duplicate declaration errors.

## Naming Conventions

**Register (shadow and hardware) LABELS:** UPPERCASE

`CHBASE = $D409`

**Regular labels and addresses:** snake\_case

`main_dlist`
 
or:

`loop    jmp loop`

**Macros & Procedures:** PascalCase

`MacroDebugPrint`

**Instructions:** lowercase

	clc
	lda $0600
	adc #$01
	sta $0600
	adc #$00
	sta $0601

**Directives**: lowercase

`.print “This is a directive.”`

**Macro arguments/parameters:** camelCase

`nextDisplayListInterrupt`

**Note**: that MADS labels are case-insensitive.

## Registers & Memory Map
Labels/Names for memory locations and registers are derived from the “[Atari 400/00 Operating System Source Listing](https://www.atarimania.com/documents/atari-400-800-operating-system-source-listing.pdf)”.  Descriptions/usage information are taken from commentary therein and/or from “[De Re Atari](https://www.atarimania.com/documents/De-Re-Atari.pdf)”, “[Mapping the Atari](https://www.atarimania.com/documents/Mapping-the-Atari.pdf)”, and the “[Altirra Hardware Reference Manual](https://www.virtualdub.org/downloads/Altirra%20Hardware%20Reference%20Manual.pdf)”.

- Register Labels and values are aligned;  = or EQU statements are floating.- 
- Unless otherwise noted, registers/locations are single bytes.
	- For non-byte values a .WORD or .FP designation will be present. 
- Organization is generally into related functional groups (there may be exceptions).
- Hardware registers are listed first.
	- Where a description or usage information is provide, it will be associated with the hardware register entries.
- Shadow registers are listed later, and will simply refer to their respective hardware register.

### Shadowing
A process whereby values are moved between memory (RAM) locations and the memory-mapped hardware registers for various ICs and hardware inputs/outputs.  This allows monitoring current values for what are otherwise write-only hardware registers and hold persistent values from transiently read-only hardware registers/interrupt triggers.

#### Shadow & Hardware Registers
Values in **Shadow Registers** are actually RAM locations (sometimes called a “RAM shadow”). 

They are copied to, or from, the memory-mapped hardware registers by a non-maskable interrupt called the “Vertical Blank Interrupt” (VBI), so called as it occurs during the “vertical blank” (sometimes called vertical-retrace) period.  This interrupt occurs once per video frame and is synchronized to the refresh rate of the local video output, which is:

- 60 Hz in NTSC regions
- 50 Hz in PAL regions

Writing a new value to a **shadow** register won’t take effect on the system hardware until the next VBI can copy its value to its corresponding **hardware** register.

If you do not need to updates to one of these registers to take effect instantly, write the value to the appropriate shadow register and let the OS/hardware update the hardware accordingly.
