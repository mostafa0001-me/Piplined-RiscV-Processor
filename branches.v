`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 10:21:23 PM
// Design Name: 
// Module Name: branches
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


module Branches
(
    input Branch,
    input [2:0] Inst,
    output reg AndOut,
    input ZF,
    input CF,
    input SF,
    input VF
 );
    
    always @(*) begin
        if(Branch)begin
            case(Inst)
                3'b000: AndOut = ZF;
                3'b001: AndOut = ~ZF;
                3'b100: AndOut = (SF != VF);
                3'b101: AndOut = (SF == VF);
                3'b110: AndOut = ~CF;
                3'b111: AndOut = CF;
                default: AndOut = 1'b0;
            endcase
        end
        else
            AndOut = 1'b0;
    end
    
endmodule
