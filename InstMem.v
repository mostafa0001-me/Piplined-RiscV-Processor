//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 10:21:23 PM
// Design Name: 
// Module Name: instruction memory module 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: (containing all instruction in memory in order)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module InstMem 
(
    input [5:0] Addr, 
    output [31:0] DataOut
);

 reg [31:0] mem [0:63];
 
 assign DataOut = mem[Addr];
 
 initial begin
        mem[0 ]= 32'h00c00093; 
        mem[1 ]= 32'h00500113;                               
        mem[2 ]= 32'h00208863;                               
        mem[3 ]= 32'h0020c863;                                
        mem[4 ]= 32'h0020f863;                               
        mem[5 ]= 32'h0020e863;                               
        mem[6 ]= 32'h00500193;
        mem[7 ]= 32'h00500213;
        mem[8 ]= 32'h00500293;
        mem[9 ]= 32'h00500313;
        /*mem[10]= 32'h4020d513;
        mem[11]= 32'h4020d533;
        mem[12]= 32'h0024e5b3;
        mem[13]= 32'h00b57633;
        mem[14]= 32'h00000073;
        mem[15]= 32'h002086b3;
        mem[16]= 32'h40208733;
        mem[17]= 32'h00508793;
        mem[18]= 32'h00508793; 
        mem[19]= 32'h00508793;                               
        mem[20]= 32'h00f0da93;                               
        mem[21]= 32'h00300993;                                
        mem[22]= 32'hffc00a13;                               
        mem[23]= 32'h01000a93;                               
        mem[24]= 32'h0ff00c13;
        mem[25]= 32'h300a0c93;
        mem[26]= 32'h00bb8d37;
        mem[27]= 32'h00800c6f;
        mem[28]= 32'h00a08093;
        mem[29]= 32'h02208063;
        mem[30]= 32'h02209063;
        mem[31]= 32'h0220c063;
        mem[32]= 32'h0220d063;
        mem[33]= 32'h0220e063;
        mem[34]= 32'h0220f063;
        mem[35]= 32'h00008ce7;
        mem[36]= 32'h00bb8d97; 
        mem[37]= 32'h00910e13;                               
                               
        mem[38]= 32'h01310e13;           
        mem[39]= 32'h01d10e13;          
        mem[40]= 32'h02710e13;          
        mem[41]= 32'h03110e13;
        mem[42]= 32'h03b10e13;*/

             
        /*mem[6]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
        mem[7]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
        mem[8]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
        mem[9]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
        mem[10]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
        mem[11]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
        mem[12]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1*/
   end

endmodule