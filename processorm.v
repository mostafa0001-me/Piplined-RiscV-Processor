`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2023 08:13:54 PM
// Design Name: 
// Module Name: Processor
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
edits done to the file processororm.v
1- ebreak and ecall are moved to the control unit and 
    will be sent with jal and jalr to the mux assigning the next instruciton of the pc
    opcodes for both instructions added to defines file.
    
2- adding two muxs before the alu module works perfectly 
    
3- control unit defines a 2bit output called JJEE 
    which defines jal, jalr, ebreak, and ecall instructions 
    all sent to the new module NextInst 

4- a new module is added called Next Inst



for the pipelined part: 

1- added all stages IF_ID, ID_EX, EX_MEM, MEM_WB, 
    Following design in Miro define all registers inputs and outputs and calc number of bits. 
    
2- Write address register needs modification for the new pipeline to follow its own instruction
    and edit the write register.    
*/

module Processor
(
    
    input clk, 
    input rst, 
    input [1:0] LedSel, 
    input [3:0] ssdSel,
    input ssdClk, 
    output reg[15:0] Leds, 
    output [6:0] LEDOut, 
    output[3:0] Anode
    
);

    // registers
    reg[12:0] SSD;
    reg[31:0] PC;
    
    //wires
    wire[31:0] PC4;
    wire[31:0] PCImm;
    wire[31:0] Inst;
    
    // control wires
    wire Branch;
    wire MemRead;
    wire MemWrite;
    wire ALUSrcA, ALUSrcB;
    wire RegWrite;
    wire[1:0] MemtoReg;
    wire[1:0] ALUOp;
    wire Jalr;
    wire Jal;
    wire[2:0] JJEE; // stands for jal (00), jalr (01), ebreak (10), ecall (11).
    
    
    wire[31:0] R1;
    wire[31:0] R2;
    wire[31:0] DatatoWrite;
    wire[31:0] ImmGen;
    //wire[31:0] offset;
    wire[31:0] DatatoALU, DatatoALU1;
    wire[4:0] ALUCont;
    wire[31:0] ALUOut;
    wire ZF, CF, VF, SF;
    wire AndOut;
    wire[31:0] DataMemOut;
    wire[31:0] OutputtoPC;
    
    
    // wires of Stages IF_ID, ID_EX, EX_MEM, MEM_WB
    wire [31:0] IF_ID_PC;
    wire [31:0] IF_ID_PC4;
    wire [31:0] IF_ID_Inst;
    wire        IF_ID_Load;
    
    // 
/**/wire [31:0] ID_EX_PC;
    wire [31:0] ID_EX_PC4;
    wire [31:0] ID_EX_PCImm;
/**/wire [1 :0] ID_EX_MemtoReg;
/**/wire        ID_EX_RegWrite;
    wire        ID_EX_MemRead;
    wire        ID_EX_MemWrite;
    wire        ID_EX_Branch;
    wire [2 :0] ID_EX_JJEE;
    wire        ID_EX_ALUSrcA;
    wire        ID_EX_ALUSrcB;
/**/wire [2 :0] ID_EX_Func3; 
    wire [31:0] ID_EX_R1; 
    wire [31:0] ID_EX_R2; 
    wire [31:0] ID_EX_ImmGen;
    wire [4 :0] ID_EX_ALUCont;
    wire [4 :0] ID_EX_RegisterRs1;
    wire [4 :0] ID_EX_RegisterRs2;
    wire [4 :0] ID_EX_RegisterRd;
    //
/**/wire [31:0] EX_MEM_PC4;
/**/wire [1 :0] EX_MEM_MemtoReg;
    wire        EX_MEM_RegWrite;
    wire        EX_MEM_MemRead;
    wire        EX_MEM_MemWrite;
/**/wire [2 :0] EX_MEM_Func3;
    wire [4 :0] EX_MEM_RegisterRd;
    wire [31:0] EX_MEM_ALUOut;
    wire [31:0] EX_MEM_R2;
    wire [31:0] EX_MEM_ImmGen;
    
    //
    wire [31:0] MEM_WB_PC4; 
    wire [1 :0] MEM_WB_MemtoReg; 
    wire        MEM_WB_RegWrite;
    wire [31:0] MEM_WB_DataMemOut; 
    wire [31:0] MEM_WB_ALUOut; 
    wire [31:0] MEM_WB_ImmGen; 
    wire [4 :0] MEM_WB_RegisterRd;
    
    // forwarding & hazard detection
    wire [1:0] ForwardingUnit_ForwardA;
    wire [1:0] ForwardingUnit_ForwardB;
    
    wire HazardDetectionUnit_Stall;
    
    //JUMPADDRESS
    wire [31:0] PCIn;
    wire NextInst_Jumpp;
    wire [31:0] InstOut;
    
    //MEM_Address Decide
    wire NOP;
    wire [7:0] MemAddress;
    wire [2:0] MemF3;
    wire IRMemRead, IRMemWrite;
    
    // hazard detection unit.
    wire IF_ID_Stall;
    assign IF_ID_Stall = HazardDetectionUnit_Stall ? 1'b0 : 1'b1; 
    HazardDetectionUnit hdu (   .ID_EX_MemRead(ID_EX_MemRead), 
                                .IF_ID_RegisterRs1(IF_ID_Inst[19:15]), 
                                .IF_ID_RegisterRs2(IF_ID_Inst[24:20]), 
                                .ID_EX_RegisterRd(ID_EX_RegisterRd),
                                .ALUSrcA(ALUSrcA), 
                                .stall(HazardDetectionUnit_Stall)
                            );
    
    
    // forwarding unit 
    ForwardingUnit fwd (    
                            .EX_MEM_RegisterRd(EX_MEM_RegisterRd),
                            .EX_MEM_RegWrite(EX_MEM_RegWrite),
                            .MEM_WB_RegisterRd(MEM_WB_RegisterRd),
                            .MEM_WB_RegWrite(MEM_WB_RegWrite),
                            .ID_EX_RegisterRs1(ID_EX_RegisterRs1),
                            .ID_EX_RegisterRs2(ID_EX_RegisterRs2),
                            .ForwardA(ForwardingUnit_ForwardA),
                            .ForwardB(ForwardingUnit_ForwardB),
                            .ALUSrcA(ID_EX_ALUSrcA)
                        );
    
    // stages of pipeline with clk
    StageRegister #(96) IF_ID ( .clk(clk), .rst(rst), .Load(IF_ID_Stall), 
                                .In({   PC,      // 32       
                                        PC4,        // 32 
                                        InstOut}),     // 32 = 96   
                                .Out({
                                        IF_ID_PC,
                                        IF_ID_PC4,
                                        IF_ID_Inst} )
                                );
                                
    StageRegister #(226) ID_EX ( .clk(clk), .rst(rst), .Load(1'b1), 
                                .In({   IF_ID_PC,           // 32 
                                        IF_ID_PC4,          // 32
                                        PCImm,              // 32
                                        MemtoReg,           // 2  
                                        RegWrite,           // 1           
                                        MemRead,            // 1
                                        MemWrite,           // 1
                                        Branch,             // 1
                                        JJEE,               // 3
                                        ALUSrcA,            // 1
                                        ALUSrcB,            // 1
                                        IF_ID_Inst[14:12],  // 3
                                        R1,                 // 32
                                        R2,                 // 32
                                        
                                        ImmGen,             // 32
                                        ALUCont,             // 5 
                                        
                                        IF_ID_Inst[19:15],   // 5
                                        IF_ID_Inst[24:20],   // 5
                                        IF_ID_Inst[11:7]    // 5 = 226
                                        }),     
                                .Out({  ID_EX_PC,         
                                        ID_EX_PC4,        
                                        ID_EX_PCImm,            
                                        ID_EX_MemtoReg,
                                        ID_EX_RegWrite,         
                                        ID_EX_MemRead,          
                                        ID_EX_MemWrite,         
                                        ID_EX_Branch,           
                                        ID_EX_JJEE,             
                                        ID_EX_ALUSrcA,          
                                        ID_EX_ALUSrcB,          
                                        ID_EX_Func3,
                                        ID_EX_R1,               
                                        ID_EX_R2,               
                                        ID_EX_ImmGen,           
                                        ID_EX_ALUCont,
                                        
                                        ID_EX_RegisterRs1,
                                        ID_EX_RegisterRs2,
                                        ID_EX_RegisterRd
                                                   
                                        } )
                                );
    StageRegister #(141) EX_Mem(.clk(clk), .rst(rst), .Load(1'b1), 
                                .In({   ID_EX_PC4,              // 32       
                                        ID_EX_MemtoReg,         // 2 
                                        ID_EX_RegWrite,          // 1
                                        ID_EX_MemRead,          // 1
                                        ID_EX_MemWrite,         // 1
                                        ID_EX_Func3,            // 3
                                        ALUOut,                 // 32
                                        ID_EX_R2,               // 32
                                        ID_EX_ImmGen,           // 32 
                                        ID_EX_RegisterRd  // 5 = 141
                                    }),     
                                .Out({  EX_MEM_PC4,     
                                        EX_MEM_MemtoReg,
                                        EX_MEM_RegWrite,
                                        EX_MEM_MemRead, 
                                        EX_MEM_MemWrite,
                                        EX_MEM_Func3,   
                                        EX_MEM_ALUOut,        
                                        EX_MEM_R2,      
                                        EX_MEM_ImmGen,
                                        EX_MEM_RegisterRd
                                    } )
                                    );
    StageRegister #(136) MEM_WB ( .clk(clk), .rst(rst), .Load(1'b1), 
                                .In({   EX_MEM_PC4,             // 32       
                                        EX_MEM_MemtoReg,        // 2 
                                        EX_MEM_RegWrite,        // 1
                                        DataMemOut,             // 32
                                        EX_MEM_ALUOut,          // 32
                                        EX_MEM_ImmGen,          // 32 
                                        EX_MEM_RegisterRd // 5 = 136
                                            
                                }),                       
                                .Out({  MEM_WB_PC4,        
                                        MEM_WB_MemtoReg, 
                                        MEM_WB_RegWrite,  
                                        MEM_WB_DataMemOut,        
                                        MEM_WB_ALUOut,     
                                        MEM_WB_ImmGen,
                                        MEM_WB_RegisterRd    
                                })
                                );
    
    //modules
//    assign Ebreak = (Inst[6:2] == 5'b11100) & Inst[20];
//    assign Ecall = (((Inst[6:2] == 5'b11100) & !Inst[20]) | (Inst[6:2] == 5'b00011));    
    //InstMem instout(.Addr(PC[7:2]), .DataOut(Inst));
    
    ControlUnit cont(.Instruction(IF_ID_Inst), .Jal(Jal), .Jalr(Jalr) ,.Branch(Branch), .MemtoReg(MemtoReg),
                     .MemRead(MemRead), .MemWrite(MemWrite), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .RegWrite(RegWrite), .ALUOp(ALUOp),
                     .JJEE(JJEE),
                     .Stall(HazardDetectionUnit_Stall),
                     .Jumpp(NextInst_Jumpp)
                     );
    
    RegisterFile#(32) rf(   .Write(MEM_WB_RegWrite), 
                            .WriteData(DatatoWrite), 
                            .WriteAddress(MEM_WB_RegisterRd), 
                            .ReadAddress1(IF_ID_Inst[19:15]), 
                            .ReadAddress2(IF_ID_Inst[24:20]), 
                            .R1(R1), .R2(R2), .rst(rst), .clk(~clk));
    
    ImmGen imm(.Imm(ImmGen), .IR(IF_ID_Inst));

//    MUX_2X1     mux2 (.In1(ID_EX_R1), .In2(ID_EX_PC), .Choose(ID_EX_ALUSrcB), .Out(DatatoALU1));
    MUX_8X3     mux2 (  .In1(ID_EX_R1), .In2(ID_EX_PC), 
                        .In3(DatatoWrite), .In4(EX_MEM_ALUOut), 
                        .In5(32'b0), .In6(32'b0), 
                        .In7(32'b0), .In8(32'b0), 
                        .Choose({ForwardingUnit_ForwardA,ID_EX_ALUSrcB}), 
                        .Out(DatatoALU1));
                           
//    MUX_2X1     mux1 (.In1(ID_EX_R2), .In2(ID_EX_ImmGen), .Choose(ID_EX_ALUSrcA), .Out(DatatoALU));
    MUX_8X3     mux1 (  .In1(ID_EX_R2), .In2(ID_EX_ImmGen), 
                        .In3(DatatoWrite), .In4(EX_MEM_ALUOut), 
                        .In5(32'b0), .In6(32'b0), 
                        .In7(32'b0), .In8(32'b0), 
                        .Choose({ForwardingUnit_ForwardB,ID_EX_ALUSrcA}), 
                        .Out(DatatoALU));
    
    
        
    ALUControlUnit contalu(.ALUOp(ALUOp), .ALUSrcA(ALUSrcA),.InReg(IF_ID_Inst),.Select(ALUCont));
    
    ALU aluu(       .A(DatatoALU1),.B(DatatoALU),
                    .ALUCont(ID_EX_ALUCont),.ZF(ZF), .VF(VF), .CF(CF), .SF(SF),.R(ALUOut));
    
    assign NOP = EX_MEM_MemRead || EX_MEM_MemWrite;
    assign MemAddress = NOP ? EX_MEM_ALUOut[7:0] : PC[7:0];
    assign MemF3 = NOP ? EX_MEM_Func3 : `F3_LW;
    assign IRMemRead = NOP ? EX_MEM_MemRead : 1'b1;
    assign IRMemWrite = NOP ? EX_MEM_MemWrite : 1'b0;
    Memory mem(.clk(clk), .MemRead(IRMemRead), .Choose(MemF3), .MemWrite(IRMemWrite),
                .Addr(MemAddress), .DataIn(EX_MEM_R2), .DataOut(DataMemOut));
    
    MUX_4X2 mm( .In1(MEM_WB_ALUOut), .In2(MEM_WB_DataMemOut), 
                .In3(MEM_WB_PC4), .In4(MEM_WB_ImmGen), 
                .Choose(MEM_WB_MemtoReg), .Out(DatatoWrite));
    
    
    
    Branches andd(.Branch(ID_EX_Branch), .CF(CF), .VF(VF), .ZF(ZF), .SF(SF), .AndOut(AndOut), .Inst(ID_EX_Func3));
//    Four_Digit_Seven_Segment_Driver ssddrive(.clk(ssdClk),.Num(SSD),.Anode(Anode),.LEDOut(LEDOut));
    
    // module that takes jal, jalr, ebreak, ecall, AndOut
    // ALUOut, PC, PC_Imm, PC4 
    // OutputtoPC
    
    
    // PC+4 & PC+Imm
    RCAdder #(32) rcadder1 (.A(PC), .B(3'b100), .Cin(1'b0), .Out(PC4)); 
    RCAdder #(32) rcadder2 (.A(IF_ID_PC), .B(ImmGen), .Cin(1'b0), .Out(PCImm)); 
    NextInst ni (   .JJEE(ID_EX_JJEE),
                    .AndOut(AndOut),
                    .PC(ID_EX_PC), .PC4(ID_EX_PC4), .PCImm(ID_EX_PCImm), 
                    .ALUOutput(ALUOut), .OutputtoPC(OutputtoPC), .Jumpp(NextInst_Jumpp));
    assign Inst = NOP ? 32'b00000000000000000000000000110011 : DataMemOut;
    MUX_2X1 PCMUX(.Choose(NextInst_Jumpp), .In1(PC4), .In2(OutputtoPC), .Out(PCIn));
    MUX_2X1 IF_ID_MUX(.Choose(NextInst_Jumpp), .In1(Inst), .In2(32'b00000000000000000000000000110011), .Out(InstOut));
//    assign JumpAddress = Jalr ? ALUOutput : (Ebreak ? PC : (Ecall? 32'b0 : (PCImm)));
//    assign OutputtoPC = (AndOut | Jal | Jalr | Ebreak | Ecall) ? JumpAddress: PC4;
    Four_Digit_Seven_Segment_Driver bcd (.clk(ssdClk), .Num(SSD), .Anode(Anode), .LEDOut(LEDOut));
    always @(posedge(clk) or posedge(rst))begin
        if(rst)
            PC = 0;
        else if (HazardDetectionUnit_Stall || NOP)
            PC = PC; 
        else
            PC = PCIn;
//        address = PC[5:0];
   end
    always @(*) begin   
        case(LedSel)
            2'b00: Leds = Inst[15:0];
            2'b01: Leds = Inst[31:16];
            2'b10: Leds = {2'b0, ALUOp,ALUCont,ZF,AndOut, Branch, MemRead, MemtoReg, MemWrite, ALUSrcA, RegWrite};
            default: Leds = 16'b0;
        endcase
        
        case(ssdSel)
            0: SSD = PC[12:0];
            1: SSD = PC4[12:0];
            2: SSD = InstOut[12:0];
            3: SSD = OutputtoPC[12:0];
            4: SSD = R1[12:0];
            5: SSD = R2[12:0];
            6: SSD = DatatoWrite[12:0];
            7: SSD = ImmGen[12:0];
            8: SSD = ImmGen[12:0];
            9: SSD = DatatoALU[12:0];
            10: SSD = ALUOut[12:0];
            11: SSD = DataMemOut[12:0];
            default SSD = 13'b0;           
        endcase
        
    end
endmodule