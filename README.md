# Hospital Management System - MIPS Assembly

![MIPS Assembly](https://img.shields.io/badge/Assembly-MIPS-blue)
![MARS Simulator](https://img.shields.io/badge/Simulator-MARS-green)

A simple yet functional Hospital Management System implemented in MIPS Assembly language, designed to run in the MARS simulator. This program demonstrates core assembly programming concepts while providing practical patient management functionality.

## Features

- **Patient Record Management**:
  - Add new patient records
  - View all patient records
  - Search for specific patients by ID

- **Patient Data Fields**:
  - Patient ID (unique identifier)
  - Full name
  - Age
  - Gender (M/F)
  - Medical diagnosis

- **User-Friendly Interface**:
  - Text-based menu system
  - Clear input prompts
  - Formatted output display

## Prerequisites

- [MARS MIPS Simulator](http://courses.missouristate.edu/KenVollmar/MARS/) (v4.5 or later)
- Basic understanding of MIPS assembly language

## Installation & Usage

1. **Download the Assembly File**:
   ```bash
   git clone https://github.com/yourusername/hospital-management-mips.git
   cd hospital-management-mips


2 Run in MARS:

  Launch MARS simulator

  Open hospital.asm (File → Open)

  Assemble (F3)

  Run (F5)


3 Usage the System

Hospital Management System

1. Add Patient
2. View All Patients
3. Search Patient
4. Exit
Choose option:



4 Code Structure

DATA SEGMENT
  patients       - Array for patient records (10 max)
  patient_count  - Current patient count
  menu_strings   - All interface text prompts
  temp_buffers   - Input buffers

TEXT SEGMENT
  main           - Program entry point, menu loop
  add_patient    - Patient creation logic
  view_patients  - Display all records
  search_patient - Find patient by ID
  exit_program   - Clean termination
  
HELPER FUNCTIONS
  remove_newline - String processing
  copy_string    - Memory operations
  compare_strings- Search functionality



5 Usage


Hospital Management System

1. Add Patient

2. View All Patients

3. Search Patient

4. Exit

Choose option: 1

Enter Patient ID: P1001

Enter Patient Name: John Doe

Enter Patient Age: 35

Enter Patient Gender (M/F): M

Enter Diagnosis: Influenza

Patient added successfully!

##



6  Technical Details

Memory Layout: Each patient record occupies 40 bytes:

  ID: 8 bytes

  Name: 20 bytes

  Age: 4 bytes (word)

  Gender: 1 byte

  Diagnosis: 7 bytes


Limitations:

  Volatile storage (data lost on exit)

  Maximum 10 patients

  No persistent storage

##

7  Future Enhancement

  Add file I/O for data persistence

  Implement patient record editing

  Add appointment scheduling

  Expand to 100+ patient capacity



8 Contributing

Contributions welcome! Please fork the repository and submit pull requests for:

  Bug fixes

  New features

  Documentation improvements



9 License

MIT License - Free for educational and personal use

Note: This project was developed for educational purposes to demonstrate MIPS assembly programming concepts in a practical application context.
