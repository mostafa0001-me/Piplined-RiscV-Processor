`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2023 06:21:57 AM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
    input [4:0] EX_MEM_RegisterRd,//
    input       EX_MEM_RegWrite,        // control  EX_MEM_RegWrite
    input [4:0] MEM_WB_RegisterRd,
    input       MEM_WB_RegWrite,        // control  MEM_WB_RegWrite
    input       ALUSrcA,
    input [4:0] ID_EX_RegisterRs1,      //[4:0]ID_EX_RegisterRs1
    input [4:0] ID_EX_RegisterRs2,         // ID_EX_RegisterRs2
    
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
    );
    
//    module ForwardingUnit(input EX_MEM_RegWrite, MEM_WB_RegWrite, [4:0]ID_EX_RegisterRs1,ID_EX_RegisterRs2,
//    EX_MEM_WriteBackAddress, MEM_WB_WriteBackAddress, output reg [1:0] ForwardA, ForwardB);
    
        always@(*) begin
            if ( EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)
            && (EX_MEM_RegisterRd == ID_EX_RegisterRs1) )
                ForwardA = 2'b10;       // from alu output in the mem stage
            else if (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0)
            && (MEM_WB_RegisterRd == ID_EX_RegisterRs1) )
                ForwardA = 2'b01;       // from mux output in the wb stage
            else
                ForwardA = 2'b00;       // no forwarding
            
            
            if ( EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)
            && (EX_MEM_RegisterRd == ID_EX_RegisterRs2) && !ALUSrcA)
                ForwardB = 2'b10;       // from alu output in the mem stage
            else if (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0)
                && (MEM_WB_RegisterRd == ID_EX_RegisterRs2) && !ALUSrcA)
                ForwardB = 2'b01;       // from mux output in the wb stage
            else
                ForwardB = 2'b00;       // no forwarding
        end
    
endmodule
