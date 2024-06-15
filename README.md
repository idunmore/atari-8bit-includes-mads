# Atari 8-bit Computer "Includes" for MADS
## Overview
These files are a combination of MADS definitions and macros, and 6502 assembly language (specifically for the Atari 8-bit line of computers), providing common (annotated) memory-map definitions and entry-points, for the custom ICs used in these machines, it's OS, as well as, eventually DOS and BASIC.

Where appropriate in-file commentary will denote physical and shadow locations/registers, usage, references to source material etc.

### Attributions
This work was heavily inspired by, and includes many definitions (various bit-fields/masks, symbol naming, type/level of commentary, explanations/examples, etc.) from, Ken Jenning's excellent "[Atari-Mads-Includes](https://github.com/kenjennings/Atari-Mads-Includes)" project.

### Structure & Contents

**Custom IC Coverage:**

 - ANTIC
 - GTIA
 - PIA
 - POKEY

**OS (etc.) Coverage:**

 - OS
 - DOS
 - BASIC (Atari)

Additionally, there will be macros and definitions to make it easier to create/define/setup (and tear-down) specific Atari 8-bit features such as Display Lists, Display List Interrupts, Vertical Blank Interrupts, Player/Missile Graphics and so on:

- **character_set** - Character values, equates and macros for managing character sets/fonts
- **colors** - Color definitions for NTSC and PAL (with assembly-time value substitution) and color handling macros
- **display_list** - Macros, equates, values, etc. for creating Display Lists and handling Display List Interrupts
- **vertical_blank** - Macros, equates, values, etc. for handling Vertical Blank Interrupts

### Usage

General usage is to simply include the appropriate files where relevant in your program.

- **common.asm** - ***IF*** you're referring to its values directly (e.g., setting "tv_standard"), then this should be included **before** of using any other files.  If you're not referencing its values specifically, then files with a dependency on common.asm will include it themselves.
- **tv_standard** - should ideally be defined on the MADS command line (with the `-d` option), to ensure its available instantly and visible to all subsequent code.
- **macro_debugging** - should ideally be defined on the MADS command line (with the `-d` option), to ensure its available instantly and visible to all subsequent code.

Use the "icl" directive in MADS to include these files in your progam:

	icl 'display_list.asm'

### Conventions & Standards

Naming conventions and other standards, including file content/organization, use of shadow/hardware registers, etc., can be found in the [Standards and Conventions](https://github.com/idunmore/atari-8bit-includes-mads/blob/main/docs/Standards%20and%20Conventions.md) document.

### Repository Intent
In my own projects, I consume these files as a Git submodule within each parent project's repository.  Thus the file organization is flat (intended to clone to an /includes sub-directory/repository within the consuming project(s)).  This has no direct implications on *this* repository; you can copy the files directly to your own repository in a structure you wish.

### Work in Progress (WIP) & Status
While substantially complete at this point, I am primarily still creating, and expanding, these definitions and macros on an as-needed basis in support of other Atari 8-bit Computer projects I am exploring.  

See [Development and Project Notes](https://github.com/idunmore/atari-8bit-includes-mads/blob/main/docs/Development%20and%20Project%20Notes.txt) for specific status, working issues, planned items, etc.

## MADS Syntax & Macro Language
The syntax and functionality in these "include" files is that of the [Mad-Assembler](https://mads.atari8.info) ([MADS](https://github.com/tebe6502/Mad-Assembler/releases)).  While MADS' syntax and macro language is derived from QA and XASM, among others, *these* files have only been tested with MADS (currently v2.1.5).
