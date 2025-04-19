# Simple Hospital Management System
# MIPS Assembly for MARS simulator
# Data section
.data
    patients:       .space  400     # Space for 10 patient records (40 bytes each)
    patient_count:  .word   0       # Current number of patients
    
    # Menu strings
    menu_title:     .asciiz "\nHospital Management System\n"
    menu_options:    .asciiz "\n1. Add Patient\n2. View All Patients\n3. Search Patient\n4. Exit\nChoose option: "
    
    # Patient input prompts
    prompt_id:      .asciiz "\nEnter Patient ID: "
    prompt_name:    .asciiz "Enter Patient Name: "
    prompt_age:     .asciiz "Enter Patient Age: "
    prompt_gender:  .asciiz "Enter Patient Gender (M/F): "
    prompt_diagnosis: .asciiz "Enter Diagnosis: "
    
    # Display headers
    header_id:      .asciiz "\nID\tName\t\tAge\tGender\tDiagnosis"
    divider:        .asciiz "\n--------------------------------------------"
    
    # Search prompt
    search_prompt:  .asciiz "\nEnter Patient ID to search: "
    not_found_msg:  .asciiz "\nPatient not found!"
    found_msg:      .asciiz "\nPatient found:"
    
    # Messages
    added_msg:      .asciiz "\nPatient added successfully!"
    full_msg:       .asciiz "\nDatabase full! Cannot add more patients."
    exit_msg:       .asciiz "\nExiting system. Goodbye!"
    
    # Newline
    newline:        .asciiz "\n"
    
    # Temporary buffers
    temp_id:        .space 8
    temp_name:      .space 20
    temp_diagnosis: .space 30

# Text section
.text
.globl main

main:
    # Display menu and handle options
    menu_loop:
        # Print menu
        li $v0, 4
        la $a0, menu_title
        syscall
        
        li $v0, 4
        la $a0, menu_options
        syscall
        
        # Get user choice
        li $v0, 5
        syscall
        move $t0, $v0
        
        # Process choice
        beq $t0, 1, add_patient
        beq $t0, 2, view_patients
        beq $t0, 3, search_patient
        beq $t0, 4, exit_program
        
        j menu_loop

add_patient:
    # Check if database is full
    lw $t1, patient_count
    li $t2, 10
    bge $t1, $t2, database_full
    
    # Calculate address for new patient (each patient = 40 bytes)
    la $t3, patients
    mul $t4, $t1, 40
    add $t3, $t3, $t4
    
    # Get patient ID
    li $v0, 4
    la $a0, prompt_id
    syscall
    
    li $v0, 8
    la $a0, temp_id
    li $a1, 8
    syscall
    
    # Store ID (remove newline)
    jal remove_newline
    la $a0, temp_id
    move $a1, $t3
    jal copy_string
    addi $t3, $t3, 8
    
    # Get patient name
    li $v0, 4
    la $a0, prompt_name
    syscall
    
    li $v0, 8
    la $a0, temp_name
    li $a1, 20
    syscall
    
    # Store name (remove newline)
    jal remove_newline
    la $a0, temp_name
    move $a1, $t3
    jal copy_string
    addi $t3, $t3, 20
    
    # Get patient age
    li $v0, 4
    la $a0, prompt_age
    syscall
    
    li $v0, 5
    syscall
    sw $v0, 0($t3)
    addi $t3, $t3, 4
    
    # Get patient gender
    li $v0, 4
    la $a0, prompt_gender
    syscall
    
    li $v0, 12
    syscall
    sb $v0, 0($t3)
    addi $t3, $t3, 1
    
    # Consume newline
    li $v0, 12
    syscall
    
    # Get diagnosis
    li $v0, 4
    la $a0, prompt_diagnosis
    syscall
    
    li $v0, 8
    la $a0, temp_diagnosis
    li $a1, 30
    syscall
    
    # Store diagnosis (remove newline)
    jal remove_newline
    la $a0, temp_diagnosis
    move $a1, $t3
    jal copy_string
    
    # Increment patient count
    lw $t1, patient_count
    addi $t1, $t1, 1
    sw $t1, patient_count
    
    # Success message
    li $v0, 4
    la $a0, added_msg
    syscall
    
    j menu_loop
    
    database_full:
        li $v0, 4
        la $a0, full_msg
        syscall
        j menu_loop

view_patients:
    # Print header
    li $v0, 4
    la $a0, header_id
    syscall
    
    li $v0, 4
    la $a0, divider
    syscall
    
    # Check if there are patients
    lw $t1, patient_count
    beqz $t1, no_patients
    
    # Initialize pointers
    la $t2, patients
    li $t3, 0
    
    view_loop:
        beq $t3, $t1, view_done
        
        # Print ID (8 bytes)
        li $v0, 4
        move $a0, $t2
        syscall
        addi $t2, $t2, 8
        
        li $v0, 11
        li $a0, '\t'
        syscall
        
        # Print Name (20 bytes)
        li $v0, 4
        move $a0, $t2
        syscall
        addi $t2, $t2, 20
        
        li $v0, 11
        li $a0, '\t'
        syscall
        
        # Print Age (4 bytes)
        li $v0, 1
        lw $a0, 0($t2)
        syscall
        addi $t2, $t2, 4
        
        li $v0, 11
        li $a0, '\t'
        syscall
        
        # Print Gender (1 byte)
        li $v0, 11
        lb $a0, 0($t2)
        syscall
        addi $t2, $t2, 1
        
        li $v0, 11
        li $a0, '\t'
        syscall
        
        # Print Diagnosis (7 bytes)
        li $v0, 4
        move $a0, $t2
        syscall
        addi $t2, $t2, 7
        
        # Newline
        li $v0, 4
        la $a0, newline
        syscall
        
        addi $t3, $t3, 1
        j view_loop
    
    no_patients:
        li $v0, 4
        la $a0, newline
        syscall
        la $a0, newline
        syscall
        
    view_done:
        j menu_loop

search_patient:
    # Check if there are patients
    lw $t1, patient_count
    beqz $t1, no_patients_search
    
    # Get ID to search
    li $v0, 4
    la $a0, search_prompt
    syscall
    
    li $v0, 8
    la $a0, temp_id
    li $a1, 8
    syscall
    
    # Remove newline
    jal remove_newline
    
    # Initialize search
    la $t2, patients
    li $t3, 0
    
    search_loop:
        beq $t3, $t1, not_found
        
        # Compare IDs
        move $a0, $t2
        la $a1, temp_id
        jal compare_strings
        
        beqz $v0, found
        
        # Move to next patient
        addi $t2, $t2, 40
        addi $t3, $t3, 1
        j search_loop
    
    found:
        li $v0, 4
        la $a0, found_msg
        syscall
        
        # Print header
        li $v0, 4
        la $a0, header_id
        syscall
        
        li $v0, 4
        la $a0, divider
        syscall
        
        # Print patient data
        # ID
        li $v0, 4
        move $a0, $t2
        syscall
        addi $t2, $t2, 8
        
        li $v0, 11
        li $a0, '\t'
        syscall
        
        # Name
        li $v0, 4
        move $a0, $t2
        syscall
        addi $t2, $t2, 20
        
        li $v0, 11
        li $a0, '\t'
        syscall
        
        # Age
        li $v0, 1
        lw $a0, 0($t2)
        syscall
        addi $t2, $t2, 4
        
        li $v0, 11
        li $a0, '\t'
        syscall
        
        # Gender
        li $v0, 11
        lb $a0, 0($t2)
        syscall
        addi $t2, $t2, 1
        
        li $v0, 11
        li $a0, '\t'
        syscall
        
        # Diagnosis
        li $v0, 4
        move $a0, $t2
        syscall
        
        j menu_loop
    
    not_found:
        li $v0, 4
        la $a0, not_found_msg
        syscall
        
    no_patients_search:
        li $v0, 4
        la $a0, newline
        syscall
        la $a0, newline
        syscall
        
        j menu_loop

exit_program:
    li $v0, 4
    la $a0, exit_msg
    syscall
    
    li $v0, 10
    syscall

# Helper functions

# Remove newline from string
remove_newline:
    lb $t5, newline
    la $t6, ($a0)
    
    remove_loop:
        lb $t7, 0($t6)
        beq $t7, $t5, replace_null
        beqz $t7, done_remove
        addi $t6, $t6, 1
        j remove_loop
    
    replace_null:
        sb $zero, 0($t6)
    
    done_remove:
        jr $ra

# Copy string from a0 to a1
copy_string:
    copy_loop:
        lb $t5, 0($a0)
        sb $t5, 0($a1)
        beqz $t5, done_copy
        addi $a0, $a0, 1
        addi $a1, $a1, 1
        j copy_loop
    
    done_copy:
        jr $ra

# Compare strings at a0 and a1
# Returns 0 if equal, 1 if not
compare_strings:
    compare_loop:
        lb $t5, 0($a0)
        lb $t6, 0($a1)
        bne $t5, $t6, not_equal
        beqz $t5, equal
        addi $a0, $a0, 1
        addi $a1, $a1, 1
        j compare_loop
    
    equal:
        li $v0, 0
        jr $ra
    
    not_equal:
        li $v0, 1
        jr $ra