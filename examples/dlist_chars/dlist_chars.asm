; dlist_chars.asm - Demonstrates the use of the display_list.asm and
;                   character_set.asm includes to build a custom display list
;                   and show a custom character set/font in two different modes.
;
; Copyright (C) 2024, Ian Michael Dunmore
;
; Licensed Under: GNU Lesser Public License v3.0
; See: https://github.com/idunmore/atari-8bit-includes-mads/blob/main/LICENSE


; Includes

	icl '../../display_list.asm'
	icl '../../character_set.asm'
		
;.def macro_debugging
	
	; Initial Code
	
	org $2000
		
start
	SetCharacterSet char_set
	InstallDisplayList main_display_list
loop	
	jmp loop
	
	
; Data Areas

main_display_list
	DL_TOP_OVERSCAN
	DL_LMS_MODE_ADDR DL_TEXT_7, screen_data
	DL_BLANK 	 DL_BLANK_8
	DL_MODE 	 DL_TEXT_2
	DL_MODE 	 DL_TEXT_2
	DL_MODE 	 DL_TEXT_2
	DL_MODE 	 DL_TEXT_2
	DL_BLANK_LINES 	 $10
	DL_LMS_MODE_ADDR DL_TEXT_4, char_data ; Reload LMS to use the same data.
	DL_MODE 	 DL_TEXT_4
	DL_MODE 	 DL_TEXT_4
	DL_MODE 	 DL_TEXT_4
	DL_BLANK_LINES 	 $60
	DL_JVB 		 main_display_list		

; Text for the display.
screen_data
	dta	d' Antic Modes 4 vs 2 '
char_data
	.HE	00 00 00 00 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
	.HE	10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F 00 00 00 00
	.HE	00 00 00 00 20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F
	.HE	30 31 32 33 34 35 36 37 38 39 3A 3B 3C 3D 3E 3F 00 00 00 00
	.HE	00 00 00 00 40 41 42 43 44 45 46 47 48 49 4A 4B 4C 4D 4E 4F
	.HE	50 51 52 53 54 55 56 57 58 59 5A 5B 5C 5D 5E 5F 00 00 00 00
	.HE	00 00 00 00 60 61 62 63 64 65 66 67 68 69 6A 6B 6C 6D 6E 6F
	.HE     70 71 72 73 74 75 76 77 78 79 7A 7B 7C 7D 7E 7F 00 00 00 00
			
; Now load a custom character set
	AlignCharacterSet
char_set
	ins	'chunky.fnt'
			