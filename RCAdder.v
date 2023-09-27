`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 11:53:02 AM
// Design Name: 
// Module Name: RCAdder
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


module RCAdder
#(parameter n =32)
(
    input Cin, 
    input[n-1:0] A, 
    input[n-1:0] B, 
    output [n-1:0]Out
);

wire[n:0] Cout;

assign Cout[0] = Cin;
genvar i;
generate 
for( i = 0; i < n; i=i+1) 
    begin
    FullAdder test(A[i], B[i], Cout[i], Out[i], Cout[i+1]); 
    end
endgenerate

endmodule

