This is a set of patches for the C64 assembler Giga-Ass by Thomas
Dachsel, published in "Sonderheft 21" (Special Edition 21) of the
German magazine "64'er" in 1988. These patches enable Giga-Ass to emit
object code to GEOram (as opposed to C64 main memory). Also provided
is a routine to read from GEOram to C64 memory.

These patches are based on my previous work on [Profi-Ass GEOram](https://github.com/r-moeritz/profi-ass-GEOram).

Usage
---

1. Load file containing GEOram routines: `LOAD"GEORAM-ROUTINES",8,1`
2. Load patched version of Giga-Ass: `LOAD"GIGA-ASS GEORAM",8,1`
3. Start Giga-Ass: `SYS32768`
4. Assemble your code as normal, but instead of being emitted to C64
   memory the object code will be written to GEOram.
5. Read object code from GEOram to C64 memory: `SYS49252`

TODO
---
- [ ] Use Makefile to simplify build process
- [ ] Include routine to load PRG file to GEOram

Copying
---

Copyright (c) 2025 Ralph Moeritz. MIT license. See file COPYING for
details.
