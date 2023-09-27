`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 08:31:18 PM
// Design Name: 
// Module Name: shifter
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


module shifter(
    input [31:0] A,
    input [4:0] ShAmt,
    input [1:0] Type,
    output reg [31:0] R
    );
    /*always @(*) begin
        if(ShAmt == 32) R = 32'b0;
        else if(ShAmt == 0) R = A;
        else begin
        
            case(Type)
                2'b00: R = A << ShAmt;
                2'b01: R = A >> ShAmt;
                2'b10: R = A >>> ShAmt;
            endcase
            
        end
    end
    */
    integer i;
        always@(*) begin
            R  = A;
            for(i = 0 ; i < ShAmt ; i = i + 1)
            begin
            case(Type)
                  2'b00:  R = {R[30:0], 1'b0};
                  2'b01:  R = {1'b0, R[31:1]};
                  2'b10:  R = {R[31], R[31:1]};
            endcase
            end
        end
endmodule
