#!/usr/bin/make -f
# The MIT License (MIT)
#
# Copyright (c) 2015 David Bond
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
SRCS = main

OPTS=-std=c++1y -O3 -DNDEBUG -Wall -Wshadow -Wstrict-aliasing -pedantic \
		 -Wextra -Werror
OPTIMIZE_OPTS+=-fstack-protector-all -g -ggdb3

all: clean \
	output/gcc/def/exe output/gcc/alt/exe \
	output/gcc/def_opt/exe output/gcc/alt_opt/exe \
	output/clang/def/exe output/clang/alt/exe \
	output/clang/def_opt/exe output/clang/alt_opt/exe

output/gcc/def/%.pre: %.cpp
	mkdir -p output/gcc/def 
	g++ $(OPTS) -E $*.cpp -o output/gcc/def/$*.pre
output/gcc/def_opt/%.pre: %.cpp
	mkdir -p output/gcc/def_opt
	g++ $(OPTS) $(OPTIMIZE_OPTS) -E $*.cpp -o output/gcc/def_opt/$*.pre
output/gcc/alt/%.pre: %.cpp
	mkdir -p output/gcc/alt
	g++ $(OPTS) -DALTERNATIVE -E $*.cpp -o output/gcc/alt/$*.pre
output/gcc/alt_opt/%.pre: %.cpp
	mkdir -p output/gcc/alt_opt
	g++ $(OPTS) $(OPTIMIZE_OPTS) -DALTERNATIVE -E $*.cpp -o output/gcc/alt_opt/$*.pre

output/gcc/def/%.s: output/gcc/def/%.pre
	g++ $(OPTS) -S $*.cpp -o output/gcc/def/$*.s
output/gcc/def_opt/%.s: output/gcc/def_opt/%.pre
	g++ $(OPTS) $(OPTIMIZE_OPTS) -S $*.cpp -o output/gcc/def_opt/$*.s
output/gcc/alt/%.s: output/gcc/alt/%.pre
	g++ $(OPTS) -DALTERNATIVE -S $*.cpp -o output/gcc/alt/$*.s
output/gcc/alt_opt/%.s: output/gcc/alt_opt/%.pre
	g++ $(OPTS) $(OPTIMIZE_OPTS) -DALTERNATIVE -S $*.cpp -o output/gcc/alt_opt/$*.s

output/gcc/def/%.o: output/gcc/def/%.s
	g++ $(OPTS) -c output/gcc/def/$*.s -o output/gcc/def/$*.o
output/gcc/def_opt/%.o: output/gcc/def_opt/%.s
	g++ $(OPTS) $(OPTIMIZE_OPTS) -c output/gcc/def_opt/$*.s -o output/gcc/def_opt/$*.o
output/gcc/alt/%.o: output/gcc/alt/%.s
	g++ $(OPTS) -DALTERNATIVE -c output/gcc/alt/$*.s -o output/gcc/alt/$*.o
output/gcc/alt_opt/%.o: output/gcc/alt_opt/%.s
	g++ $(OPTS) $(OPTIMIZE_OPTS) -DALTERNATIVE -c output/gcc/alt_opt/$*.s -o output/gcc/alt_opt/$*.o

output/gcc/def/exe: output/gcc/def/${SRCS}.o output/gcc/def/${SRCS}.objdump
	g++ $(OPTS) output/gcc/def/${SRCS}.o -o output/gcc/def/exe
output/gcc/def_opt/exe: output/gcc/def_opt/${SRCS}.o output/gcc/def_opt/${SRCS}.objdump
	g++ $(OPTS) $(OPTIMIZE_OPTS) output/gcc/def_opt/${SRCS}.o -o output/gcc/def_opt/exe
output/gcc/alt/exe: output/gcc/alt/${SRCS}.o output/gcc/alt/${SRCS}.objdump
	g++ $(OPTS) -DALTERNATIVE output/gcc/alt/${SRCS}.o -o output/gcc/alt/exe
output/gcc/alt_opt/exe: output/gcc/alt_opt/${SRCS}.o output/gcc/alt_opt/${SRCS}.objdump
	g++ $(OPTS) $(OPTIMIZE_OPTS) -DALTERNATIVE output/gcc/alt_opt/${SRCS}.o -o output/gcc/alt_opt/exe

output/gcc/def/%.objdump: output/gcc/def/%.o
	objdump -S -l output/gcc/def/$*.o &> output/gcc/def/$*.objdump
output/gcc/def_opt/%.objdump: output/gcc/def_opt/%.o
	objdump -S -l output/gcc/def_opt/$*.o &> output/gcc/def_opt/$*.objdump
output/gcc/alt/%.objdump: output/gcc/alt/%.o
	objdump -S -l output/gcc/alt/$*.o &> output/gcc/alt/$*.objdump
output/gcc/alt_opt/%.objdump: output/gcc/alt_opt/%.o
	objdump -S -l output/gcc/alt_opt/$*.o &> output/gcc/alt_opt/$*.objdump



output/clang/def/%.pre: %.cpp
	mkdir -p output/clang/def 
	clang++ $(OPTS) -E $*.cpp -o output/clang/def/$*.pre
output/clang/def_opt/%.pre: %.cpp
	mkdir -p output/clang/def_opt
	clang++ $(OPTS) $(OPTIMIZE_OPTS) -E $*.cpp -o output/clang/def_opt/$*.pre
output/clang/alt/%.pre: %.cpp
	mkdir -p output/clang/alt
	clang++ $(OPTS) -DALTERNATIVE -E $*.cpp -o output/clang/alt/$*.pre
output/clang/alt_opt/%.pre: %.cpp
	mkdir -p output/clang/alt_opt
	clang++ $(OPTS) $(OPTIMIZE_OPTS) -DALTERNATIVE -E $*.cpp -o output/clang/alt_opt/$*.pre

output/clang/def/%.s: output/clang/def/%.pre
	clang++ $(OPTS) -S $*.cpp -o output/clang/def/$*.s
output/clang/def_opt/%.s: output/clang/def_opt/%.pre
	clang++ $(OPTS) $(OPTIMIZE_OPTS) -S $*.cpp -o output/clang/def_opt/$*.s
output/clang/alt/%.s: output/clang/alt/%.pre
	clang++ $(OPTS) -DALTERNATIVE -S $*.cpp -o output/clang/alt/$*.s
output/clang/alt_opt/%.s: output/clang/alt_opt/%.pre
	clang++ $(OPTS) $(OPTIMIZE_OPTS) -DALTERNATIVE -S $*.cpp -o output/clang/alt_opt/$*.s

# clang requires -Wno-error=unused-command-line-argument and to start from $*.cpp
output/clang/def/%.o: output/clang/def/%.s
	clang++ $(OPTS) -Wno-error=unused-command-line-argument -c $*.cpp -o output/clang/def/$*.o
output/clang/def_opt/%.o: output/clang/def_opt/%.s
	clang++ $(OPTS) -Wno-error=unused-command-line-argument $(OPTIMIZE_OPTS) -c $*.cpp -o output/clang/def_opt/$*.o
output/clang/alt/%.o: output/clang/alt/%.s
	clang++ $(OPTS) -Wno-error=unused-command-line-argument -DALTERNATIVE -c $*.cpp -o output/clang/alt/$*.o
output/clang/alt_opt/%.o: output/clang/alt_opt/%.s
	clang++ $(OPTS) -Wno-error=unused-command-line-argument $(OPTIMIZE_OPTS) -DALTERNATIVE -c $*.cpp -o output/clang/alt_opt/$*.o

output/clang/def/exe: output/clang/def/${SRCS}.o output/clang/def/${SRCS}.objdump
	clang++ $(OPTS) output/clang/def/${SRCS}.o -o output/clang/def/exe
output/clang/def_opt/exe: output/clang/def_opt/${SRCS}.o output/clang/def_opt/${SRCS}.objdump
	clang++ $(OPTS) $(OPTIMIZE_OPTS) output/clang/def_opt/${SRCS}.o -o output/clang/def_opt/exe
output/clang/alt/exe: output/clang/alt/${SRCS}.o output/clang/alt/${SRCS}.objdump
	clang++ $(OPTS) -DALTERNATIVE output/clang/alt/${SRCS}.o -o output/clang/alt/exe
output/clang/alt_opt/exe: output/clang/alt_opt/${SRCS}.o output/clang/alt_opt/${SRCS}.objdump
	clang++ $(OPTS) $(OPTIMIZE_OPTS) -DALTERNATIVE output/clang/alt_opt/${SRCS}.o -o output/clang/alt_opt/exe

output/clang/def/%.objdump: output/clang/def/%.o
	objdump -S -l output/clang/def/$*.o &> output/clang/def/$*.objdump
output/clang/def_opt/%.objdump: output/clang/def_opt/%.o
	objdump -S -l output/clang/def_opt/$*.o &> output/clang/def_opt/$*.objdump
output/clang/alt/%.objdump: output/clang/alt/%.o
	objdump -S -l output/clang/alt/$*.o &> output/clang/alt/$*.objdump
output/clang/alt_opt/%.objdump: output/clang/alt_opt/%.o
	objdump -S -l output/clang/alt_opt/$*.o &> output/clang/alt_opt/$*.objdump

clean:
	rm -rf output

.PRECIOUS: \
	output/gcc/def/${SRCS}.s output/gcc/def/${SRCS}.pre \
	output/gcc/def_opt/${SRCS}.s output/gcc/def_opt/${SRCS}.pre \
	output/gcc/alt/${SRCS}.s output/gcc/alt/${SRCS}.pre \
	output/gcc/alt_opt/${SRCS}.s output/gcc/alt_opt/${SRCS}.pre \
	output/clang/def/${SRCS}.s output/clang/def/${SRCS}.pre \
	output/clang/def_opt/${SRCS}.s output/clang/def_opt/${SRCS}.pre \
	output/clang/alt/${SRCS}.s output/clang/alt/${SRCS}.pre \
	output/clang/alt_opt/${SRCS}.s output/clang/alt_opt/${SRCS}.pre
