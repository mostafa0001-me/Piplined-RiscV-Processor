
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 10:21:23 PM
// Design Name: 
// Module Name: ALU module
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

module ALU
(	
	input   wire [31:0] A, B,	// in1, in2
	output  reg  [31:0] R,		// ALU_out 
	output  wire        CF, 	// CARRY FLAG
	output ZF, 			// ZERO FLAG
	output VF, 			// OVERFLOW FLAG
	output SF,			// SIGN FLAG
	input   wire [4:0]  ALUCont	// ALUOP
);
    wire[4:0] ShAmt;
	wire [31:0] add, sub, op_b;	// no need for sub because we check for add and sub at the same formula.
    wire cfa, cfs;
    wire signed [63:0] MUL, MULH; 
    wire [63:0] MULHU;
    wire signed [63:0] MULHSU;
    wire signed [31:0] DIV, REM;  
    wire [31:0] DIVU, REMU;
    assign ShAmt = B[4:0];
	assign op_b = (~B);
    	//assign shamt = B[4:0];
	assign {CF, add} = ALUCont[0] ? (A + op_b + 1'b1) : (A + B);
    	assign ZF = (add == 0);
    	assign SF = add[31];
	assign VF = (A[31] ^ (op_b[31]) ^ add[31] ^ CF);
    assign MUL = $signed(A) * $signed(B);      
    assign MULH = $signed(A) * $signed(B);     //leads to a problem
    assign MULHU = $unsigned(A) * $unsigned(B);     
    assign MULHSU = $signed(A) * $unsigned(B);     //leads to a problem
    assign DIV = $signed(A) / $signed(B);                           
    assign DIVU = $unsigned(A) / $unsigned(B);    
    assign REM = $signed(A) % $signed(B);       
    assign REMU = $unsigned(A) % $unsigned(B);     
    wire[31:0] sh;
	shifter shifter0(.A(A), .ShAmt(ShAmt), .Type(ALUCont[1:0]),  .R(sh));
    
    always @ * begin
        R = 0;
        (* parallel_case *)
	    case (ALUCont)
            	// arithmetic
            	`ALU_ADD : R = add;
            	`ALU_SUB : R = add; // supposedly sub, already managed to be equal
            	`ALU_PASS : R = B;
            	// logic
            	`ALU_OR:  R = A | B;
            	`ALU_AND:  R = A & B;
            	`ALU_XOR:  R = A ^ B;
            	// shift
            	`ALU_SRL:  R=sh;
            	`ALU_SLL:  R=sh;
            	`ALU_SRA:  R=sh;
            	// slt & sltu
		        `ALU_SLT:  R = {31'b0,(SF != VF)}; 
		        `ALU_SLTU:  R = {31'b0,(~CF)};
		        //MUL
		        `ALU_MUL   : R = MUL[31:0];
                `ALU_MULH  : R = MULH[63:32]; 
                `ALU_MULHSU: R = MULHSU[63:32];
                `ALU_MULHU : R = MULHU[63:32];
                `ALU_DIV   : R = DIV;
                `ALU_DIVU  : R = DIVU;
                `ALU_REM   : R = REM;
                `ALU_REMU  : R = REMU;		        
		default: R=R;
        endcase
    end
endmodule
