.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_files/test_input.bin"

.text
main:
    # Read matrix into memory
    
    # addi sp sp -8
    # sw s1 0(sp) # rows
    # sw s2 4(sp) # columns
    la a0 file_path # save string pointer
    mv a1 s1 
    mv a2 s2
    jal read_matrix
    mv s3 a0
    lw s4 0(s1)
    lw s5 0(s2)
    # add a1 sp x0 # a1 pointer to rows 
    # addi a2 sp 4 # a2 pointer to columns
    # jal read_matrix
    
    # lw s6, 0(s4)
    # lw s7, 0(s5) 
    # Print out elements of matrix
    # li s1 3 # set number of row
    # li s2 3 # set number of column
    mv a0 s3    
    mv a1 s4 
    mv a2 s5
    # add a1 sp x0 # a1 pointer to rows
    # addi a2 sp 4 # a2 pointer to columns
    jal print_int_array

    # addi sp sp 8
    
    # lw s1 0(sp)
    # lw s2 4(sp)
    # addi sp sp 8

    # Terminate the program
    addi a0, x0, 10
    ecall