.import ../matmul.s
.import ../utils.s
.import ../dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la s0 m0 # load m0
    la s1 m1 # load m1
    la s2 d # load d into register
    
    li s3 3 # set the row of m0
    li s4 3 # set the column of m0
    li s5 3 # set the row of m1
    li s6 3 # set the column of m1
    
    li s7 3 # set the row of d
    li s8 3 # set the column of d
    

    # Call matrix multiply, m0 * m1
    mv a0 s0 # save m0
    mv a1 s3 # save row of m0
    mv a2 s4 # save column of m0
    mv a3 s1 # save m1
    mv a4 s5 # save row of m1
    mv a5 s6 # save column of m1
    mv a6 s2 # save d
   
    jal ra matmul



    # Print the output (use print_int_array in utils.s)
    mv a0 s2
    mv a1 s7
    mv a2 s8
    
    jal print_int_array



    # Exit the program
    jal exit