//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 10:21:23 PM
// Design Name: 
// Module Name: CONTROL UNIT
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

//`include "defines.v"
/*
`define     OPCODE_Branch   5'b11_000
`define     OPCODE_Load     5'b00_000
`define     OPCODE_Store    5'b01_000
`define     OPCODE_JALR     5'b11_001
`define     OPCODE_JAL      5'b11_011
`define     OPCODE_Arith_I  5'b00_100
`define     OPCODE_Arith_R  5'b01_100
`define     OPCODE_AUIPC    5'b00_101
`define     OPCODE_LUI      5'b01_101
`define     OPCODE_BREAK_ECALL  5'b11_100
`define     OPCODE_ECALL    5'b00_011
*/

module ControlUnit
(
    input[31:0] Instruction,
    input Stall, 
    input Jumpp,
    output reg Branch, 
    output reg MemRead, 
    output reg[1:0]MemtoReg, 
    output reg MemWrite, 
    output reg ALUSrcA, 
    output reg ALUSrcB,
    output reg RegWrite,  
    output reg Jalr,    
    output reg Jal,
    output reg [1:0] ALUOp,
    output reg [2:0] JJEE   // stands for jal (000), jalr (001), ebreak (010), ecall (011).
);
//assign Ebreak = (Inst[6:2] == 5'b11100) & Inst[20];
//assign Ecall = (((Inst[6:2] == 5'b11100) & !Inst[20]) | (Inst[6:2] == 5'b00011));

    always @(Instruction, Stall, Jumpp) begin
        if (Stall || Jumpp) begin
            Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b10; MemWrite = 1'b0; ALUSrcA = 1'b0; RegWrite = 1'b0; 
            ALUSrcB = 1'b0; Jalr =1'b0; Jal = 1'b0; JJEE=`INST_NOJJEE;           
        end
        else
            begin
            case(Instruction[`IR_opcode])
                `OPCODE_Arith_R: begin
                    Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b10; MemWrite = 1'b0; ALUSrcA = 1'b0; RegWrite = 1'b1; 
                    ALUSrcB = 1'b0; Jalr =1'b0; Jal = 1'b0; JJEE=`INST_NOJJEE;
                end
                `OPCODE_Load: begin
                    Branch = 1'b0; MemRead = 1'b1; MemtoReg = 2'b01; ALUOp = 2'b00; MemWrite = 1'b0; ALUSrcA = 1'b1; RegWrite = 1'b1; 
                    ALUSrcB = 1'b0; Jalr =1'b0; Jal = 1'b0; JJEE=`INST_NOJJEE;
                end
                `OPCODE_Store: begin
                    Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b00; MemWrite = 1'b1; ALUSrcA = 1'b1; RegWrite = 1'b0; 
                    ALUSrcB = 1'b0; Jalr =1'b0; Jal = 1'b0; JJEE=`INST_NOJJEE;
                end                                           
                `OPCODE_Branch: begin                               
                    Branch = 1'b1; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b01; MemWrite = 1'b0; ALUSrcA = 1'b0; RegWrite = 1'b0; 
                    ALUSrcB = 1'b0; Jalr =1'b0; Jal = 1'b0; JJEE=`INST_NOJJEE;
                end                                           
                `OPCODE_AUIPC: begin                               
                    Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b00; MemWrite = 1'b0; ALUSrcA = 1'b1; RegWrite = 1'b1; 
                    ALUSrcB = 1'b1; Jalr =1'b0; Jal = 1'b0; JJEE=`INST_NOJJEE;
                end                                           
                `OPCODE_Arith_I: begin                               
                    Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b10; MemWrite = 1'b0; ALUSrcA = 1'b1; RegWrite = 1'b1; 
                    ALUSrcB = 1'b0; Jalr =1'b0; Jal = 1'b0; JJEE=`INST_NOJJEE;
                end                                           
                `OPCODE_JAL: begin                               
                    Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b10; ALUOp = 2'b00; MemWrite = 1'b0; ALUSrcA = 1'b1; RegWrite = 1'b1; 
                    ALUSrcB = 1'b0; Jalr =1'b0; Jal = 1'b1; JJEE=`INST_JAL;
                end                                           
                `OPCODE_JALR: begin                               
                    Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b10; ALUOp = 2'b00; MemWrite = 1'b0; ALUSrcA = 1'b1; RegWrite = 1'b1; 
                    ALUSrcB = 1'b0; Jalr =1'b1; Jal = 1'b0; JJEE=`INST_JALR;
                end
                `OPCODE_BREAK_ECALL: begin                                 
                    JJEE = !Instruction[20]? `INST_ECALL:`INST_EBREAK; Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b10; ALUOp = 2'b00; MemWrite = 1'b0; ALUSrcA = 1'b1; RegWrite = 1'b1; 
                    ALUSrcB = 1'b0; Jalr =1'b1; Jal = 1'b0;
                end         
                `OPCODE_ECALL: begin
                    Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b10; ALUOp = 2'b00; MemWrite = 1'b0; ALUSrcA = 1'b1; RegWrite = 1'b1; 
                    ALUSrcB = 1'b0; Jalr =1'b1; Jal = 1'b0;JJEE=`INST_ECALL;
                end                                   
                `OPCODE_LUI: begin                               
                    Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b11; ALUOp = 2'b11; MemWrite = 1'b0; ALUSrcA = 1'b1; RegWrite = 1'b1; 
                    ALUSrcB = 1'b0; Jalr =1'b0; Jal = 1'b0; JJEE=`INST_NOJJEE;
                end                                           
                default: begin                                
                    Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b10; MemWrite = 1'b0; ALUSrcA = 1'b0; RegWrite = 1'b0; 
                    ALUSrcB = 1'b0; Jalr =1'b0; Jal = 1'b0; JJEE=`INST_NOJJEE;
                end
            endcase
            end
        
    end
endmodule