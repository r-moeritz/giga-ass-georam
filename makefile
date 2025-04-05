.PHONY: default clean

patch_src := $(wildcard src/georam-patch-*.asm)
patch_bin := $(patsubst src/%.asm,dist/%.bin,$(patch_src))
ga_org_bin := dist/giga-ass.bin
ga_georam_bin := dist/giga-ass-georam.bin
ga_georam_prg := dist/giga-ass-georam.prg
routines_src := $(wildcard src/georam-routines.asm)
routines_prg := $(patsubst src/%.asm,dist/%.prg,$(routines_src))
listings := dist/*.lst
d64 := dist/giga-ass-georam.d64

default: $(d64)

# Target to Create the patched Giga-Ass binary
$(ga_georam_bin): $(patch_bin)
	run6502 -l 8000 $(ga_org_bin) \
-l 8000 dist/georam-patch-1.bin \
-l 8AE2 dist/georam-patch-2.bin \
-l 91F0 dist/georam-patch-3.bin \
-s 8000 +2000 $@ -x

# Taret to prepend the start address to the patched GA binary
$(ga_georam_prg): $(ga_georam_bin)
	printf '\x00\x80' | cat - $^ > $@

# Target to create disk image
$(d64): $(ga_georam_prg) $(routines_prg)
	c1541 -format 'giga-ass georam',gg d64 $@ 8
	c1541 -attach $@ $(foreach prg,$^,-write $(prg) $(patsubst dist/%.prg,%,$(prg)))

clean:
	rm -f $(d64) $(ga_georam_prg) $(ga_georam_bin) $(patch_bin) \
$(routines_prg) $(listings)

# Implicit rules
dist/%.bin: src/%.asm
	vasm6502_oldstyle -Fbin -chklabels -nocase -dotdir $< -o $@ \
-L $(patsubst %.bin,%.lst,$@)

dist/%.prg: src/%.asm
	vasm6502_oldstyle -cbm-prg -Fbin -chklabels -nocase -dotdir $< \
-o $@ -L $(patsubst %.prg,%.lst,$@)
