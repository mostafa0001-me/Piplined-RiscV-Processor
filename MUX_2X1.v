`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2023 04:39:24 AM
// Design Name: 
// Module Name: MUX_4x2
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


module MUX_2X1
#(parameter n = 32)
(
    input [n-1:0] In1,
    input [n-1:0] In2, 
    input Choose, 
    output reg [n-1:0] Out
);

    always @(*)
    begin
        case(Choose)
            1'b0: Out = In1;
            1'b1: Out = In2;
        endcase
    end
endmodule
