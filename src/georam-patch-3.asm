        ;; GEOram patch for Giga-Ass - Part 3
        ;; ==================================
        ;; 
        ;; Copyright (c) 2025 Ralph Moeritz. MIT license. See file
        ;; COPYING for details.
        ;; ________________________________________________________
        ;; 
        ;; A patch for Giga-Ass to emit object code to GEOram. 
        ;; 
        ;; Data Format
        ;; -----------
        ;;
        ;; +-------------+---------------+-------------+
        ;; |    $de00    |     $de02     |  $de04 ...  |
        ;; +-------------+---------------+-------------+
        ;; | data length | start address | object code |
        ;; +-------------+---------------+-------------+
        
        ;; Zero Page
        ;; ---------
bytes:  .ezp $3b        ;byte[3]: 1-3 bytes of object code
nbytes: .ezp $42        ;byte:    number of bytes assembled
offset: .ezp $96        ;byte:    offset within GEOram page ($00-$ff)

        ;; GEOram Registers
        ;; ----------------
georam: .equ $de00      ;page: 1st address of page mapped to GEOram
        
        ;; Giga-Ass Routines
        ;; -----------------
incpc:  .equ $9217      ;increment program counter

        ;; GEOram Routines
        ;; ---------------
incoff: .equ $c011      ;increment GEOram page offset & page+block, if necessary
       
        ;; Routines Definitions
        ;; --------------------
        
        ;; Patch routine that writes 1-3 bytes of object code to memory
        ;; to write to GEOram instead
        *= $91f0
patch3: ldx offset
        ldy nbytes
        lda bytes
        sta georam,x
        jsr incoff
        dey
        beq incpc
        lda bytes+1
        sta georam,x
        jsr incoff
        dey
        beq incpc
        lda bytes+2
        sta georam,x
        jsr incoff
        nop
        nop
        nop
        nop
        nop
