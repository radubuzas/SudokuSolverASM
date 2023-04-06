# Sudoku Solver (Assembly x86)

This is a Sudoku solver implemented in assembly x86. It uses system interrupts to call the 'read' system function for reading input, and employs a simple backtracking algorithm to solve the Sudoku grid.

## Usage

1. Compile the program by typing `make` in the terminal.
2. Execute the program.
3. Input the Sudoku grid by following the specified convention (see below).
4. The completed Sudoku will be displayed in 'output.txt'.

To clean the executable and the output file, type `make clean`.

## Convention for Reading Input

- Insert digits with a single space character between them.
- Introduce a 'new line' character after completing a row.

## Example Input

5 3 0 0 7 0 0 0 0
6 0 0 1 9 5 0 0 0
0 9 8 0 0 0 0 6 0
8 0 0 0 6 0 0 0 3
4 0 0 8 0 3 0 0 1
7 0 0 0 2 0 0 0 6
0 6 0 0 0 0 2 8 0
0 0 0 4 1 9 0 0 5
0 0 0 0 8 0 0 7 9

Note: '0' represents an empty cell in the Sudoku grid.

Feel free to use and modify this Sudoku solver for your own projects! Contributions are welcome.

