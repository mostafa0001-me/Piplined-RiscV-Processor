`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2023 12:25:04 PM
// Design Name: 
// Module Name: n_bit_register
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

// (input clk, input rst, input D, output reg Q);
module StageRegister#(parameter n=8)(
    input clk, 
    input rst,
    input Load, 
    input[n-1:0] In, 
    output reg[n-1:0] Out

    );

    always@ (posedge clk, posedge rst)
        begin
            if(rst)
                Out = 0;
            else
                if(Load)
                    Out = In;
                else
                    Out = Out;
        end
    
endmodule
