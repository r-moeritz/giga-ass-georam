        ;; GEOram patch for Giga-Ass - Standalone routines
        ;; ===============================================
        ;; 
        ;; Copyright (c) 2025 Ralph Moeritz. MIT license. See file
        ;; COPYING for details.
        ;; ________________________________________________________

        ;; Constants
        ;; ---------
MAXPAG: .equ 64         ;last GEOram page +1

        ;; Zero Page
        ;; ---------
ptr:    .ezp $22        ;word: general-purpose pointer
offset: .ezp $96        ;byte: offset within GEOram page ($00-$ff)
curblk: .ezp $97        ;byte: current GEOram block (0-31)
curpag: .ezp $98        ;byte: current GEOram page (0-63)
pc:     .ezp $fb        ;word: program counter value

        ;; OS Routines
        ;; -----------
newlin: .equ $aad7      ;print CRLF
strout: .equ $ab1e      ;print zero-terminated string in A (lo) and Y (hi)        
linprt: .equ $bdcd      ;print 16-bit integer in X (lo) and A (hi)
        
        
        ;; GEOram Registers
        ;; ----------------
geoblk: .equ $dfff      ;byte: 16K GEOram block selection register
geopag: .equ $dffe      ;byte: GEOram page selection register
georam: .equ $de00      ;page: 1st address of page mapped to GEOram
        
        ;; Giga-Ass Tables
        ;; ---------------
prgadr: .equ $02ec      ;word: starting address
objmsg: .equ $840e      ;text: "object code uses "
        
        ;; Routines Definitions
        ;; --------------------
        
        ;; Routine to initialize GEOram registers & working memory
        ;; Call from BASIC via:
        ;;   SYS49152
        *= $c000
inigeo: lda #0
        sta curblk
        sta curpag
        sta geoblk
        sta geopag
        lda #4
        sta offset
        rts

        ;; Routine to increment offset, curpage, and geopage
        ;; as well as curblock & geoblock, if necessary.
        ;; NB. Assumes X contains offset.
        ;; Called by Giga-Ass
incoff: inx
        bne done
        ldx #0
        inc curpag
        lda curpag
        cmp #MAXPAG
        bne setpag
        inc curblk
        sta geoblk
        lda #0
        sta curpag
setpag: sta geopag
done:   stx offset
        rts

        ;; Routine to write data length and starting address to
        ;; first 4 bytes of GEOram and print "object code uses " message.
        ;; Called by Giga-Ass
wrdlen: lda #0
        sta geoblk
        sta geopag
        lda pc
        sec
        sbc prgadr
        sta georam
        lda pc+1
        sbc prgadr+1
        sta georam+1
        ;; Write starting address to GEOram
        lda prgadr
        sta georam+2
        lda prgadr+1
        sta georam+3
        lda curblk
        sta geoblk
        lda curpag
        sta geopag
        ;; Print "object code uses "
        lda #<objmsg
        ldy #>objmsg
        jsr strout
        rts

        ;; Routine to read object code from GEOram.
        ;; Call from BASIC via:
        ;;     SYS49252
rdgeo:  jsr rdghdr
        lda prgadr
        sta ptr
        lda prgadr+1
        sta ptr+1
        ldx offset
        ldy #0
rdloop: lda georam,x
        sta (ptr),y
        jsr decpc       ;decrement remaining bytes
        lda pc+1
        bne nxtbyt
        lda pc
        beq rdfin       ;exit if remaining bytes == 0
nxtbyt: jsr incoff
        iny
        beq nxtpag
        jmp rdloop
nxtpag: inc ptr+1
        lda #0
        sta ptr
        jmp rdloop
rdfin:  jsr rdghdr
        jsr prrmsg
        rts

        ;; Routine to print summary of data copied
prrmsg: jsr newlin
        ldx pc
        lda pc+1
        jsr linprt
        lda #<rdmsg
        ldy #>rdmsg
        jsr strout
        ldx prgadr
        lda prgadr+1
        jsr linprt
        rts

        ;; Routine to read data length & C64 address from GEOram
rdghdr: jsr inigeo
        ;; Read data length
        lda georam
        sta pc
        lda georam+1
        sta pc+1
        ;; Read C64 address
        lda georam+2
        sta prgadr
        lda georam+3
        sta prgadr+1
        rts

        ;; Routine to decrement program counter
decpc:  dec pc
        lda pc
        cmp #$ff
        bne :+
        dec pc+1
:       rts

        ;; Message for read operation
rdmsg:  .string " BYTES READ FROM GEORAM TO "        
