#!/bin/bash -e

#env NEURO must be set to NeuroMatrix sdk 
# 
#Build dir:
BUILDDIR=./lib/

# --- Defining build tools ---
# nm c/cpp compiler
NMCPP  = $(NEURO)/bin/nmcpp
# nm assembler		
ASM    = $(NEURO)/bin/asm
# nm linker		
LINKER = $(NEURO)/bin/linker
# nm exec file decoder 
NMDUMP = $(NEURO)/bin/nmdump
# nm exec file decoder 
NMLIBRARIAN = $(NEURO)/bin/libr

OPT_LEVEL = 2 #optimization level (0-2)

DIRS=$(sort $(dir $(wildcard ./*/)))
CPP_SOURCES= $(foreach dir,$(DIRS),$(wildcard $(dir)*.cpp))
ASM_SOURCES=$(foreach dir,$(DIRS),$(wildcard $(dir)*.asm) )
#ASM_SOURCES= $(foreach dir,$(DIRS),$(wildcard $(dir)mc7601_*.asm) )
		 
ELFS=$(CPP_SOURCES:.cpp=.elf) $(ASM_SOURCES:.asm=.elf)

LIBRARY =$(BUILDDIR)liblls.lib

all: info $(LIBRARY) clean_elf

info: #for Makefile debug
	@echo " ------------------------------------------------------------- "
	@echo "-- Found directories: $(DIRS)                                  "
	@echo "-- Found cpp sources: $(CPP_SOURCES)                           "
	@echo "-- Found asm sources: $(ASM_SOURCES)                           "
	@echo " ------------------------------------------------------------- "
	@echo "-- Building library: $(LIBRARY) from Intermediate ELF's:       "
	@echo "		{ $(ELFS) }                                               "
	@echo " ------------------------------------------------------------- "

	
$(LIBRARY): $(ELFS)
	mkdir $(BUILDDIR) -p
	@echo "*** Creating library $@ ***"
	libr -c $@ $(ELFS)
	
%.elf: %.asm
	@echo "*** Building object $@ ***"
	$(ASM) -soc $< -o$@	
				
%.asm: %.cpp
	@echo "*** Compiling $@ ****"
	$(NMCPP) $< -O$@ -soc -OPT$(OPT_LEVEL) $(INCLUDE_PATH)

clean_elf:
	@echo "*** Clean intermediate ELF's ***"
	$(foreach dir,$(DIRS),rm -f $(dir)*.elf);
	

clean: 
	@echo "*** Cleaning $(BUILDDIR) folder ***"
	rm $(BUILDDIR)* -f; 
	




