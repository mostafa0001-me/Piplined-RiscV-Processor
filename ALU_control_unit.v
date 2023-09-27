`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2023 11:55:33 AM
// Design Name: 
// Module Name: ALU_control_unit
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


module ALUControlUnit
(
	input[1:0] ALUOp,
	input[31:0] InReg,
	input ALUSrcA, // only needed to differenciate between Arith-r and arith-i instructions
	output reg[4:0] Select
);

always@(*)
begin
	if (ALUOp == 2'b00) Select = `ALU_ADD; 	// add
 	else if (ALUOp == 2'b01) Select = `ALU_SUB;	// sub
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_ADD && (InReg[30] ==0 || ALUSrcA) && (InReg[25] == 0 || ALUSrcA))  Select = `ALU_ADD  ; // add
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_ADD && (InReg[30] ==1 && !ALUSrcA) && (InReg[25] == 0 || ALUSrcA)) Select = `ALU_SUB  ; // sub
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_AND && (InReg[30] ==0 || ALUSrcA) && (InReg[25] == 0 || ALUSrcA))  Select = `ALU_AND  ; // and
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_OR && (InReg[30] ==0 || ALUSrcA) && (InReg[25] == 0 || ALUSrcA))   Select = `ALU_OR   ; // or
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_SLL && InReg[30] ==0 && (InReg[25] == 0 || ALUSrcA))                                 Select = `ALU_SLL  ; // sll
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_SLT && (InReg[30] ==0 || ALUSrcA) && (InReg[25] == 0 || ALUSrcA))  Select = `ALU_SLT  ; // slt
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_SLTU && (InReg[30] ==0 || ALUSrcA) && (InReg[25] == 0 || ALUSrcA)) Select = `ALU_SLTU ; // sltu
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_XOR && (InReg[30] ==0 || ALUSrcA) && (InReg[25] == 0 || ALUSrcA))  Select = `ALU_XOR  ; // xor
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_SRL && InReg[30] ==0 && (InReg[25] == 0 || ALUSrcA))               Select = `ALU_SRL  ; // srl
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_SRL && InReg[30] ==1 && (InReg[25] == 0 || ALUSrcA))               Select = `ALU_SRA  ; // sra
	else if (ALUOp == 2'b11 ) Select = `ALU_PASS; // lui (no op)                                       
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_MUL    && InReg[25] == 1) Select = `ALU_MUL   ;
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_MULH   && InReg[25] == 1) Select = `ALU_MULH  ;
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_MULHSU && InReg[25] == 1) Select = `ALU_MULHSU;
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_MULHU  && InReg[25] == 1) Select = `ALU_MULHU ;
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_DIV    && InReg[25] == 1) Select = `ALU_DIV   ;
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_DIVU   && InReg[25] == 1) Select = `ALU_DIVU  ;
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_REM    && InReg[25] == 1) Select = `ALU_REM   ;
	else if (ALUOp == 2'b10 && InReg[`IR_funct3] == `F3_REMU   && InReg[25] == 1) Select = `ALU_REMU  ;
	// every if should have an else statement
	else Select = `ALU_PASS;
end

endmodule
