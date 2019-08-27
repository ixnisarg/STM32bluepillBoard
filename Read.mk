############################################################################
#Intial Reads
############################################################################
#1]Lazy Set
#VARIABLE = value
#Normal setting of a variable - values within it are recursively expanded when the variable is used, not when it's declared

#2]Immediate Set
#VARIABLE := value
#Setting of a variable with simple expansion of the values inside - values within it #are expanded at declaration time.

#3]Set If Absent
#VARIABLE ?= value
#Setting of a variable only if it doesn't have a value

#Append
#VARIABLE += value
############################################################################

############################################################################
#Automatic Variables
#Automatic variables are set by make after a rule is matched. There include:

#$@: the target filename.
#$*: the target filename without the file extension.
#$<: the first prerequisite filename.
#$^: the filenames of all the prerequisites, separated by spaces, discard duplicates.
#$+: similar to $^, but includes duplicates.
#$?: the names of all prerequisites that are newer than the target, separated by spaces.
############################################################################


#Virtual Path - VPATH & vpath
#You can use VPATH (uppercase) to specify the directory to search for dependencies and target files. For example,        

# Search for dependencies and targets from "src" and "include" directories
# The directories are separated by space
#$VPATH = src include
#You can also use vpath (lowercase) to be more precise about the file type and its search directory. For example,

# Search for .c files in "src" directory; .h files in "include" directory
# The pattern matching character '%' matches filename without the extension
#vpath %.c src
#vpath %.h include


#GCC compiles a C/C++ program into executable in 4 steps as shown in the above diagram. For example, a "gcc -o hello.exe hello.c" is carried out as follows:

#Pre-processing: via the GNU C Preprocessor (cpp.exe), which includes the headers (#include) and expands the macros (#define).
> cpp hello.c > hello.i
The resultant intermediate file "hello.i" contains the expanded source code.
#Compilation: The compiler compiles the pre-processed source code into assembly code for a specific processor.
> gcc -S hello.i
The -S option specifies to produce assembly code, instead of object code. The resultant assembly file is "hello.s".
#Assembly: The assembler (as.exe) converts the assembly code into machine code in the object file "hello.o".
> as -o hello.o hello.s
#Linker: Finally, the linker (ld.exe) links the object code with the library code to produce an executable file "hello.exe".
> ld -o hello.exe hello.o ...libraries...