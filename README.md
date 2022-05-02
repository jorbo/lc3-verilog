# LC3 FPGA Interpreter

- [LC3 FPGA Interpreter](#lc3-fpga-interpreter)
  - [Preamble](#preamble)
  - [Goals](#goals)

## Preamble

Little Computer 3 (LC3) is educational assmebly language. The language only has a handful of instructions making is great for students.

## Goals

The goal of the project is to be able to use an FPGA to interpret and run LC3 Assembly binaries.  
For example given the following assmebly code:

```lc3
.ORIG x3000
    ADD R4, R4, #10
    ADD R3, R3, #8
    ADD R2, R4, R3
    HALT
.END
```

that produces the following binary output:

```binary
0011000000000000
0001100100101010
0001011011101000
0001010100000011
1111000000100101
```

The idea is that if you can supply the entire binary to an FPGA it would be able to run the code and hopefully match what would happen on a normal LC3 simulator. I'd like to be able to hand a student combination FPGA and Embeded OS to write and run the LC3 code on *real* hardware. The point of the FPGA is to simulate what a *real* LC3 CPU would be like if one existed.
