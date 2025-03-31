        ;; GEOram patch for Giga-Ass - Part 2
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
        
        ;; GEOram Routines
        ;; ---------------
wrdlen: .equ $c02d      ;write data length & starting address to GEOram
       
        ;; Routines Definitions
        ;; --------------------
        
        ;; Patch routine that prints assembly summary
        ;; to write data length and starting address to GEOram
        *= $8ae2
patch2: jsr wrdlen
        nop
        nop
        nop
        nop
