`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2023 08:30:33 AM
// Design Name: 
// Module Name: HazardDetectionUnit
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


module HazardDetectionUnit
(
    input ID_EX_MemRead,
    input ALUSrcA, 
    input [4:0] IF_ID_RegisterRs1, 
    input [4:0] IF_ID_RegisterRs2, 
    input [4:0] ID_EX_RegisterRd, 
    output stall
);
        assign stall = ((IF_ID_RegisterRs1 == ID_EX_RegisterRd) || ((IF_ID_RegisterRs2 == ID_EX_RegisterRd) && !ALUSrcA)) && ID_EX_MemRead && ID_EX_RegisterRd != 0;
endmodule
