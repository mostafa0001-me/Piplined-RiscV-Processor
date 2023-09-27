`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2023 12:26:02 AM
// Design Name: 
// Module Name: NextInst
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// module that takes jal, jalr, ebreak, ecall, AndOut
    // ALUOutput, PC, PC_Imm, PC4 
    // OutputtoPC
module NextInst(
    input [2:0] JJEE, 
    input AndOut, 
    
    input [31:0] PC, 
    input [31:0] PC4, 
    input [31:0] PCImm, 
    input [31:0] ALUOutput,
    
    output [31:0] OutputtoPC, 
    output Jumpp
    );
    
    wire[31:0] JumpAddress; 
//    assign JumpAddress = Jalr ? ALUOutput : (Ebreak ? PC : (Ecall? 32'b0 : (PCImm)));
//    assign OutputtoPC = (AndOut | Jal | Jalr | Ebreak | Ecall) ? JumpAddress: PC4;
    
    assign JumpAddress = (JJEE == `INST_JALR) ? ALUOutput : ((JJEE == `INST_EBREAK) ? PC : ((JJEE == `INST_ECALL)? 32'b0 : (PCImm)));
    assign OutputtoPC = (AndOut | !JJEE[2]) ? JumpAddress: PC4;
    assign Jumpp = (JJEE == `INST_JALR) || (JJEE == `INST_EBREAK) || (JJEE == `INST_JAL) || (JJEE == `INST_ECALL) || (JJEE == `INST_JALR) || AndOut;
    
endmodule
