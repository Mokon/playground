# playground

playground is a simple build framework for testing code fragments. It compiles a
simple C++ 14 program in clang and gcc, in optimized, and non-optimized
versions, and in all stages of the build and puts all of these files organized
in output for the user to examine and compare. It will also compile a seperate
program with the ALTERNATIVE flag defined to you can use the pre-processor
macros to compare the results of two different coding techniques.
