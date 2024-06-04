# Atari 8-bit Computer "Includes" for MADS
## Overview
These files are a combination of MADS definitions and macros, and 6502 assembly language (specifically for the Atari 8-bit line of computers), providing common (annotated) memory-map definitions and entry-points, for the custom ICs used in these machines, it's OS, as well as, eventually DOS and BASIC.

Where appropriate in-file commentary will denote physical and shadow locations/registers, usage, references to source material etc.

**Custom IC Coverage:**

 - ANTIC
 - GTIA
 - PIA
 - POKEY

**OS (etc.) Coverage:**

 - OS
 - DOS
 - SIO
 - BASIC (Atari)

Additionally, there will be macros and definitions to make it easier to create/define/setup (and tear-down) specific Atari 8-bit features such as Display Lists, Display List Interrupts, Vertical Blank Interrupts, Player/Missile Graphics and so on. 

See individual **.asm** files for notes on their level of completeness.

### Usage

Use the "icl" directive in MADS to ins

### Repository Intent
In my own projects, I consume these files as a Git submodule within each parent project's repository.  Thus the file organization is flat (intended to clone to an /includes sub-directory/repository within the consuming project(s)).  This has no direct implications on *this* repository; you can copy the files directly to your own repository in a structure you wish.

### Work in Progress (WIP)
I am primarily creating, and expanding, these definitions and macros on an as-needed basis in support of other Atari 8-bit Computer projects I am exploring.  Over time, it is my intent to make them as comprehensive as possible.  

## MADS Syntax & Macro Language
The syntax and functionality in these "include" files is that of the [Mad-Assembler](https://mads.atari8.info) ([MADS](https://github.com/tebe6502/Mad-Assembler/releases)).  While MADS' syntax and macro language is derived from QA and XASM, among others, *these* files have only been tested with MADS (currently v2.1.5).
