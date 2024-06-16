# Examples
These are examples of, and in some cases tutorials for, usage of various macros and declarations, structures, enumerations, etc.  

### dlist_chars
This is a simple example of using the macros and equates from the **display_list.asm** and **character_set.asm** "include" files.

It sets up a custom display list, and a custom character set, to show all 128 characters in both Mode 2 and Mode 4, using just *one* direct 6502 instruction; everything else is handled via simple macros.
