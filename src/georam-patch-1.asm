        ;; GEOram patch for Giga-Ass - Part 1
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
inigeo: .equ $c000      ;initialize GEOram variables

        ;; Giga-Ass Routines
        ;; -----------------
initga: .equ $84aa      ;initialize Giga-Ass

        ;; Routines Definitions
        ;; --------------------

        ;; Patch out module header
        *= $8000
patch1: jsr inigeo
        jmp initga
        .blk 3          ;erase "CBM80"
