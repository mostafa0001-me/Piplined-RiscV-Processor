`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2023 09:53:32 PM
// Design Name: 
// Module Name: Processor_tb
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
/*
    input clk, 
    input rst, 
    input [1:0] LedSel, 
    input [3:0] ssdSel,
    input ssdClk, 
    output reg[15:0] Leds, 
    output [6:0] LED_out, 
    output[3:0] Anode
*/

module Processor_tb;

//input clk, input reset, input [1:0] LedSel, input [3:0] ssdSel,
//    input ssdClk, output reg[15:0] Leds, output reg[12:0] ssd

reg clk;
reg rst;
reg[1:0] LedSel;
reg[3:0] ssdSel;
reg ssdClk;
wire[15:0] Leds;
//wire[12:0] ssd;
wire[6:0] LEDOut;
wire[3:0] Anode;

Processor init1(.clk(clk), .rst(rst), .LedSel(LedSel), .ssdSel(ssdSel), .ssdClk(ssdClk), .Leds(Leds), .LEDOut(LEDOut), .Anode(Anode));

   parameter PERIOD = 20;
initial begin
    clk = 1'b0;
    forever #(PERIOD/2) clk = ~clk;
end

//initial begin
//   always begin
//      clk = 1'b0;
//      #(PERIOD/2) clk = 1'b1;
//      #(PERIOD/2);
//   end
//end   
			
				
initial begin
    clk = 0;
    rst = 1;
//    LedSel = 1'b0;
//    ssdSel = 1'b0;
//    ssdClk = 1'b0;
    #40
    rst = 0;
//    clk = 0;
//    #10
//    clk = 0;
//    LedSel = 2'b00;
//    ssdSel = 4'b0000;
//    #10
//    LedSel = 2'b01;
//    ssdSel = 4'b0001;
//    #10
//    LedSel = 2'b10;
//    ssdSel = 4'b0010;
//    #10
//    ssdSel = 4'b0011;
//    #10
//    ssdSel = 4'b0100;
//    #10
//    ssdSel = 4'b0101;
//    #10
//    ssdSel = 4'b0110;
//    #10
//    ssdSel = 4'b0111;
//    #10
//    ssdSel = 4'b1000;
//    #10
//    ssdSel = 4'b1001;
//    #10
//    ssdSel = 4'b1010;
//    #10
//    ssdSel = 4'b1011;
    #1200;
    $finish;
end


endmodule
