# Piplined-RiscV-Processor

we have create a Piplined processor (DataPath)
that is capable for handling the whole 40 RV32I instructions including the path
for the ECALL and FENCE that resets the program and set the PC to zero,
and the path for EBREAK that halts the program. Moreover, Multiple test
files were included to test all the supported instructions. The outcome of those
tests turned out to be successful showing that the 40 instructions are handeled
correctly.

Here is the Data-Path
![image](https://github.com/mostafa0001-me/Piplined-RiscV-Processor/assets/57318849/2c586082-31ee-4661-8975-756fb8c8c5a5)
