`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2023 08:03:45 AM
// Design Name: 
// Module Name: MUX_8X3
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


module MUX_8X3
#(parameter n = 32)
(
    input [n-1:0] In1,
    input [n-1:0] In2, 
    input [n-1:0] In3,
    input [n-1:0] In4,
    input [n-1:0] In5,
    input [n-1:0] In6,
    input [n-1:0] In7,
    input [n-1:0] In8,
    input [2:0] Choose, 
    output reg [n-1:0] Out
);

    always @(*)
    begin
        case(Choose)
            // first 2 bits for forwarding + old bit for the mux.
            3'b00_0: Out = In1;  // no forwarding 
            3'b00_1: Out = In2;  // no forwarding
            3'b01_0: Out = In3;  // forwarding 01 (from aluoutput)
            3'b01_1: Out = In3;  // forwarding 01 (from aluoutput)
            3'b10_0: Out = In4;  // forwarding 10 (from mux write back)
            3'b10_1: Out = In4;  // forwarding 10 (from mux write back)
            3'b11_0: Out = In5;  // 32'b0
            3'b11_1: Out = In5;  // 32'b0
            default: Out = In5;           
        endcase
    end
endmodule
