# Copyright 2010 Jose-Luis Lisani <joseluis.lisani@uib.es>
#
# Copying and distribution of this file, with or without
# modification, are permitted in any medium without royalty provided
# the copyright notice and this notice are preserved.  This file is
# offered as-is, without any warranty.
# 

# C source code
CSRC	= mt19937ar.c io_png.c
# C++ source code
CXXSRC	= libauxiliar.cpp libdenoising.cpp nlmeans_ipol.cpp img_diff_ipol.cpp img_mse_ipol.cpp 

# all source code
SRC	= $(CSRC) $(CXXSRC)

# C objects
COBJ	= $(CSRC:.c=.o)
# C++ objects
CXXOBJ	= $(CXXSRC:.cpp=.o)
# all objects
OBJ	= $(COBJ) $(CXXOBJ)
# binary target
BIN	= nlmeans_ipol img_diff_ipol img_mse_ipol

default	: $(BIN)

# Utilisez gcc pour le C et le C++, ou spécifiez le chemin vers clang avec OpenMP si installé
CC = /opt/homebrew/bin/gcc-13
CXX = /opt/homebrew/bin/g++-13

# C optimization flags
COPT    = -O3 -funroll-loops -fomit-frame-pointer -ffast-math -ftree-vectorize

# C++ optimization flags
CXXOPT	= $(COPT)

# C compilation flags
CFLAGS	= $(COPT) -Wall -Wextra  \
	-Wno-write-strings -ansi
# C++ compilation flags
CXXFLAGS	= $(CXXOPT) -Wall -Wextra  \
	-Wno-write-strings -Wno-deprecated -ansi -fopenmp
# link flags
LDFLAGS = -L/opt/homebrew/lib -fopenmp -lpng -lm -Wl,-ld_classic



# partial compilation of C source code
%.o: %.c %.h
	$(CC) -c -o $@  $< $(CFLAGS) -I/opt/homebrew/include/  
# partial compilation of C++ source code
%.o: %.cpp %.h
	$(CXX) -c -o $@  $< $(CXXFLAGS) -I/opt/homebrew/include/

# link all the object code
$(BIN) : % : %.o  io_png.o libauxiliar.o libdenoising.o mt19937ar.o
	$(CXX) -o $@  $^ $(LDFLAGS) 



# housekeeping
.PHONY	: clean distclean
clean	:
	$(RM) $(OBJ)
distclean	: clean
	$(RM) $(BIN)
