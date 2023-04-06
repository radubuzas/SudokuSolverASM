.data
	trei: .long 3
	noua: .long 9
	lineIndex: .long 0
	columnIndex: .long 0
	x1: .space 4
	y1: .space 4
	formatPrintf: .asciz "%d %d %d\n"
	fileInput: .asciz "input.txt"
	fileOutput: .asciz "output.txt"
	space: .asciz " "
	endl: .asciz "\n"
	temp: .space 4
	fileDescriptor: .space 4
	inputBuffer: .space 162
	justInCase: .space 4
	matrix: .space 324
.text

	read:
	pushl %ebp
	movl %esp, %ebp
	
	pushl %ebx					# se pregateste restaurarea lui ebx
	pushl %esi					# se pregateste restaurarea lui esi
	pushl %edi					# se pregateste restaurarea lui edi
	
	lea inputBuffer, %esi
	lea matrix, %edi
	
		forLines:
		cmp $9, lineIndex			# if(i == 9)
		je fin
		
		movl $0, columnIndex			# j = 0;
			forColumns:
			xorl %edx, %edx
			xorl %eax, %eax
			
			movl lineIndex, %eax
			mull noua
			addl columnIndex, %eax
			
			pushl %eax			# se pregateste restaurarea lui eax; eax retine indexul curent
			
			lea (%esi, %eax, 2), %ebx
			
			pushl %ebx
			call atoi
			popl %ebx
			
			popl %edx			# eax este restaurat in edx
			
			movl %eax, (%edi, %edx, 4)
			
			incl columnIndex
			cmp $9, columnIndex
			jl forColumns
			
			incl lineIndex
			jmp forLines
			
		
	fin:
	popl %edi					# edi este restaurat
	popl %esi					# esi este restaurat
	popl %ebx					# ebx este restaurat
	
	popl %ebp
	ret
	
	#-------------------------------------------------------------------------------------------------
	
	out:
	pushl %ebp
	movl %esp, %ebp
	
	pushl %ebx					# se pregateste restaurarea lui ebx
	pushl %esi					# se pregateste restaurarea lui esi
	pushl %edi					# se pregateste restaurarea lui edi
	
	lea matrix, %edi
	
	movl $0, lineIndex
	movl $0, columnIndex
	
	cmp $0, lineIndex
	je forColumnsOut
	
		forLinesOut:

		movl $4, %eax					# se efectueaza afisare in output.txt
		movl fileDescriptor, %ebx			# output.txt file descripter in ebx
		lea endl, %ecx
		movl $1, %edx		
		int $0x80
		
		cmp $9, lineIndex			# if(i == 9)
		je finOut
		
		movl $0, columnIndex			# j = 0;
			forColumnsOut:
			xorl %edx, %edx
			xorl %eax, %eax
			
			movl lineIndex, %eax
			mull noua
			addl columnIndex, %eax
			
			movl $48, %ecx
			addl %ecx, (%edi, %eax, 4)
			lea (%edi, %eax, 4), %ecx
			
			pushl %eax

			movl $4, %eax					# se efectueaza afisare in output.txt
			movl fileDescriptor, %ebx			# output.txt file descripter in ebx
			# ecx este deja bun
			movl $1, %edx
			int $0x80
			
			popl %eax
			
			movl $48, %ecx
			subl %ecx, (%edi, %eax, 4)
			
			movl $4, %eax					# se efectueaza afisare in output.txt
			movl fileDescriptor, %ebx			# output.txt file descripter in ebx
			lea space, %ecx
			movl $1, %edx
			int $0x80
			
			incl columnIndex
			cmp $9, columnIndex
			jl forColumnsOut
			
			incl lineIndex
			jmp forLinesOut
			
		
	finOut:
	
	movl $4, %eax					# se efectueaza afisare in output.txt
	movl fileDescriptor, %ebx			# output.txt file descripter in ebx
	lea endl, %ecx
	movl $1, %edx		
	int $0x80
	
	popl %edi					# edi este restaurat
	popl %esi					# esi este restaurat
	popl %ebx					# ebx este restaurat
	
	popl %ebp
	ret
	
	#-------------------------------------------------------------------------------------------------
	
	sudoku:					# sudoku(int i, int j)
	pushl %ebp
	movl %esp, %ebp
	
	pushl %ebx					# se pregateste restaurarea lui ebx
	pushl %esi					# se pregateste restaurarea lui esi
	pushl %edi					# se pregateste restaurarea lui edi
	
	lea matrix, %edi
	
	cmp $9, 12(%ebp)				# if(j == 9)
	jne if1
	
	incl 8(%ebp)					# ++i;
	movl $0, 12(%ebp)				# j = 0;
	
	if1:
	cmp $9, 8(%ebp)				# if(i == 9)
	jne else
	
	call out
	jmp return
	
	else:
	
	xorl %edx, %edx
	movl 8(%ebp), %eax				# eax = i
	mull noua					# eax = i * 9
	addl 12(%ebp), %eax				# eax = i * 9 + j = a[i][j]
	
	cmp $0, (%edi, %eax, 4)
	jne else1
	
			movl $1, %ecx					# k = 1;
			for_k_loop:					# for
			
			pushl %eax					# se pregateste restaurarea
			
			pushl %ecx					# k bagat pe stiva
			pushl 12(%ebp)					# j bagat pe stiva
			pushl 8(%ebp)					# i bagat pe stiva
			
				call OK					# OK(i, j, k);
				
			popl %ebx
			popl %ebx
			popl %ecx
			
			movl %eax, temp
			
			popl %eax					# eax este restaurat
			
			cmp $1, temp					# if(OK(i, j, k))
			jne finFor
			
			movl %ecx, (%edi, %eax, 4)			# a[i][j] = k;
			
			movl 12(%ebp), %edx				# edx = j
			incl %edx					# edx = j + 1
			
			pushl %eax
			pushl %ecx
			
			pushl %edx					# j + 1
			pushl 8(%ebp)					# i
			
				call sudoku					# sudoku(i, j+1);
			
			popl %ebx
			popl %ebx
			
			popl %ecx
			popl %eax	
			
			movl $0, (%edi, %eax, 4)			# a[i][j] = 0;
			
			finFor:
			incl %ecx					# ++i;
			cmp $9, %ecx					# if(i <= 9)
			jle for_k_loop
			
			jmp return
			
		else1:
		
		movl 12(%ebp), %edx
		incl %edx
		
		pushl %edx				# j + 1
		pushl 8(%ebp)				# i
		
		call sudoku				# sudoku(i, j+1);
		
		popl %ebx
		popl %ebx
	
	return:
	popl %edi					# edi este restaurat
	popl %esi					# esi este restaurat
	popl %ebx					# ebx este restaurat
	
	popl %ebp
	ret
	
	#-------------------------------------------------------------------------------------------------
	
	OK:						# OK(int i, int j, int r)
	pushl %ebp					#	8	12	16
	movl %esp, %ebp
	
	pushl %ebx					# se pregateste restaurarea lui ebx
	pushl %esi					# se pregateste restaurarea lui esi
	pushl %edi					# se pregateste restaurarea lui edi

	
	lea matrix, %edi
	
	xorl %ecx, %ecx				# i = 0;
	movl 12(%ebp), %ebx				# ebx = x = columnIndex = j
	
		forOK:
		
		cmp $8, %ecx				# if(i == 9)
		jg forOK1Prep
		
		xorl %edx, %edx
		
		movl %ecx, %eax			
		mull noua				# lineIndex * 9
		
		addl %ebx, %eax			# lineIndex * 9 + columnLine; a[i][j]
		
		movl (%edi, %eax, 4), %esi
		
		
		cmp 16(%ebp), %esi			# if(a[i][x] == r)
		je returnFalse
		
		incl %ecx
		jmp forOK
		
	forOK1Prep:
	
	xorl %ecx, %ecx				# i = 0;
	
		forOK1:
		movl 8(%ebp), %ebx				# ebx = y = lineIndex
		
		cmp $8, %ecx				# if(i == 9)
		jg scrierePatrat
		
		xorl %edx, %edx
		
		movl %ebx, %eax			# 
		mull noua				# lineIndex * 9 = y * 9
		addl %ecx, %eax			# lineIndex * 9 + columnIndex = y * 9 + i
		
		movl (%edi, %eax, 4), %esi
		
		cmp 16(%ebp), %esi			# if(a[y][i] == r)
		je returnFalse
		
		incl %ecx
		jmp forOK1
		
	scrierePatrat:
	xorl %edx, %edx
	
	movl 8(%ebp), %eax				# eax = y = i = lineIndex
	divl trei					# eax = y/3 
	mull trei					# eax = y/3*3
	
	movl %eax, %ebx				# ebx = y1 
	
	movl 12(%ebp), %eax				# eax = x = j
	divl trei					# eax = x/3
	mull trei					# eax = x/3*3
	
	movl %eax, %edx				# edx = x1 = columnIndex
	
	movl $0, lineIndex
		
	movl %edx, x1					# x1
	movl %ebx, y1					# y1
	
	forLinesOK:
	
		cmp $3, lineIndex			# if(i == 3)
		je returnTrue
		
		movl $0, columnIndex
		
			forColumnsOK:	
			
			movl x1, %edx
			movl y1, %ebx
			
			addl columnIndex, %edx
			addl lineIndex, %ebx
			
			pushl %edx
			xorl %edx, %edx
			
			movl %ebx, %eax
			mull noua
			
			popl %edx
			addl %edx, %eax
			
			movl (%edi, %eax, 4), %esi
			
			
			cmp 16(%ebp), %esi
			je returnFalse
			
			incl columnIndex
			cmp $3, columnIndex
			jl forColumnsOK
			
			
			incl lineIndex
			jmp forLinesOK
	
			
	returnFalse:
	
	popl %edi					# edi este restaurat
	popl %esi					# esi este restaurat
	popl %ebx					# ebx este restaurat
	
	xorl %eax, %eax
	
	popl %ebp
	ret
		
	returnTrue:

	pushl %eax
	pushl %ebx
	pushl %ecx
	pushl %edx
	
	pushl 16(%ebp)
	pushl 12(%ebp)
	pushl 8(%ebp)
	pushl $formatPrintf
	#call printf
	popl %ebx
	popl %ebx
	popl %ebx
	popl %ebx
	
	popl %edx
	popl %ecx
	popl %ebx
	popl %eax
	
	
	popl %edi					# edi este restaurat
	popl %esi					# esi este restaurat
	popl %ebx					# ebx este restaurat
	
	movl $1, %eax
	
	popl %ebp
	ret

.global main

main:
	movl $5, %eax					# input.txt is oppened
	lea fileInput, %ebx
	xorl %ecx, %ecx
	movl $4, %edx
	int $0x80
	
	movl %eax, %esi
	
	movl $5, %eax					# output.txt is oppened
   	lea fileOutput, %ebx
   	movl $0x42, %ecx				# O_CREAT | O_RDWR
   	mov $0664, %edx       				# write permissions
   	int $0x80            				# call kernel
	
	movl %eax, fileDescriptor
	
	movl %esi, %ebx				# se efectueaza citirea din input.txt
	movl $3, %eax
	lea inputBuffer, %ecx
	movl $162, %edx
	int $0x80
	
	movl $6, %eax					# input.txt is closed
	movl %esi, %ebx
	int $0x80
	
	call read					# read();
	
	pushl $0
	pushl $0
	
	call sudoku					# sudoku(i, j);
	
	popl %ebx
	popl %ebx
	
	movl $6, %eax
	movl fileDescriptor, %ebx
	int $0x80
	

et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
