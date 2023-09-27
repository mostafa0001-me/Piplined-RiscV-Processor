`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 09:57:26 AM
// Design Name: 
// Module Name: DataMem
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

module Memory
(
    input clk, 
    input[2:0] Choose,
    input MemRead, 
    input MemWrite,
    input [7:0] Addr,
    input [31:0] DataIn,
    output reg [31:0] DataOut
);
//    $readmemh("C:\Users\monee\Downloads\MileStone2\MileStone2\RISCV-Processor-Tests\testChat2.hex", mem);

    reg [7:0] mem [0:255];
    initial begin
        {mem[0 ], mem[1 ], mem[2 ], mem[3 ]}= 32'h05800093; 
        {mem[4 ], mem[5 ], mem[6 ], mem[7 ]}= 32'h02108133;                               
        {mem[8 ], mem[9 ], mem[10], mem[11]}= 32'h021091b3;                               
        {mem[12], mem[13], mem[14], mem[15]}= 32'h0210b233;                                
        {mem[16], mem[17], mem[18], mem[19]}= 32'h0210a2b3;                               
        {mem[20], mem[21], mem[22], mem[23]}= 32'h01000313;                               
        {mem[24], mem[25], mem[26], mem[27]}= 32'h00800393;
        {mem[28], mem[29], mem[30], mem[31]}= 32'h00700413;
        {mem[32], mem[33], mem[34], mem[35]}= 32'h027344b3;
        {mem[36], mem[37], mem[38], mem[39]}= 32'h02735533;
        {mem[40], mem[41], mem[42], mem[43]}= 32'h028365b3;
        {mem[44], mem[45], mem[46], mem[47]}= 32'h028375b3;
       
        
        {mem[244], mem[245], mem[246], mem[247]}=32'd218300416;
        {mem[248], mem[249], mem[250], mem[251]}=32'd9;
        {mem[252], mem[253], mem[254], mem[255]}=32'd25;
    end 

        always@ (*) begin
        if(MemRead)
            case(Choose)
                `F3_LB :   DataOut = {{24{mem[Addr][7]}},mem[Addr]};                     // lb
                `F3_LH :   DataOut = {{16{mem[Addr][7]}}, mem[Addr], mem[Addr+1]};       // lh
                `F3_LW :   DataOut = {mem[Addr], mem[Addr+1], mem[Addr+2], mem[Addr+3]}; // lw
                `F3_LBU:   DataOut = {24'b0, mem[Addr]};                                 // lbu
                `F3_LHU:   DataOut = {16'b0, mem[Addr], mem[Addr+1]};                    // lhu
                default:  DataOut = 32'b0;                                              // zero
            endcase
        else
            DataOut = 32'b0;
    end

    always @(posedge(clk)) begin
        if(MemWrite)
                case(Choose)
                    `F3_SB:  mem[Addr] = DataIn[7:0];                                    // sb
                    `F3_SH:  {mem[Addr], mem[Addr+1]} = DataIn[15:0];                    // sh
                    `F3_SW:  {mem[Addr], mem[Addr+1], mem[Addr+2], mem[Addr+3]} = DataIn;// sw
                    default: mem[Addr] = mem[Addr];
                endcase
         else
            mem[Addr] = mem[Addr];
    end 


endmodule
