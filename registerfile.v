`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2023 11:55:33 AM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile
#(parameter n = 32)
(
    input clk,
    input rst, 
    input Write, 
    input[n-1:0] WriteData, 
    input[4:0] WriteAddress, 
    input[4:0] ReadAddress1, 
    input[4:0] ReadAddress2, 
    output [n-1:0] R1, 
    output [n-1:0] R2
);

    
    reg[n-1:0] registers[31:0];
    integer i;
    // synchronous actions only with clk and rst
    always@(posedge(clk), posedge(rst)) begin
        registers[0] = 0;
        
        // trying to rst memory to zeros
        if(rst)begin
            for(i = 1; i < n; i = i + 1) begin
                  registers[i] = 0;
            end 
        end
        
        // condition: write signal from CU with a reasonable write address.
        else if(Write && (WriteAddress != 0)) begin
            registers[WriteAddress] = WriteData;
        end   
        
        // every if should have an else statement. 
        else begin end
    end
    assign R1 = registers[ReadAddress1];
    assign R2 = registers[ReadAddress2];
endmodule
