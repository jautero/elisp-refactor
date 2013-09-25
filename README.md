elisp-refactor
==============

These tools make refactoring (C++) code easier by implementing useful functions
for refactoring the code. First tools to be implemented are `switch-between-header-and-code` 
and `run-build`. First function switches from current buffer containing code to corresponding
header file and vice versa. Second one runs build command. They are based on idea that source
code is organized into a hierarchy that allows finding corresponding files and directories by
simply replacing elements in the file path.

