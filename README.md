This is a set of patches for the C64 assembler Giga-Ass by Thomas
Dachsel, published in "Sonderheft 21" (Special Edition 21) of the
German magazine "64'er" in 1988. These patches enable Giga-Ass to emit
object code to GEOram (as opposed to C64 main memory). Also provided
is a routine to read from GEOram to C64 memory.

These patches are based on my previous work on [Profi-Ass GEOram](https://github.com/r-moeritz/profi-ass-GEOram).

Building
---

The build process depends on the `run6502` command-line utility. Clone
[its repository](https://github.com/mrdudz/run6502.git) and follow the
included instructions to build and install, after which it should be
in your path (verify via `which run6502`).

Now you can build the GEOram routines & a patched version of Giga-Ass via:

    make

Running
---

1. Load file containing GEOram routines: `LOAD"GEORAM-ROUTINES",8,1`
2. Load patched version of Giga-Ass: `LOAD"GIGA-ASS-GEORAM",8,1`
3. Start Giga-Ass: `SYS32768`
4. Assemble your code as normal. Instead of being emitted to C64
   memory the object code will be written to GEOram.
5. To read object code from GEOram to C64 memory (e.g. after a reset):
   `SYS49252`

TODO
---
- [x] Use Makefile to simplify build process
- [ ] Include routine to load PRG file to GEOram

Copying
---

Copyright (c) 2025 Ralph Moeritz. MIT license. See file COPYING for
details.
