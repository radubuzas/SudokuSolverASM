run: sudoku
	./sudoku
	cat output.txt
sudoku: sudoku.s
	gcc -m32 sudoku.s -o sudoku

.PHONY: clean
clean:
	rm sudoku output.txt
