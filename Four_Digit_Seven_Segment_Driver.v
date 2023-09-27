module Four_Digit_Seven_Segment_Driver (
 input clk,
 input [12:0] Num,
 output reg [3:0] Anode,
 output reg [6:0] LEDOut
 );

 reg [3:0] LED_BCD;
 reg [19:0] refresh_counter = 0; // 20-bit counter
 wire [1:0] LED_activating_counter;
 always @(posedge clk)
 begin
 refresh_counter <= refresh_counter + 1;
 end

 assign LED_activating_counter = refresh_counter[19:18];

 always @(*)
 begin
 case(LED_activating_counter)
 2'b00: begin
 Anode = 4'b0111;
 LED_BCD = Num/1000;
 end
 2'b01: begin
 Anode = 4'b1011;
 LED_BCD = (Num % 1000)/100;
 end
 2'b10: begin
 Anode = 4'b1101;
 LED_BCD = ((Num % 1000)%100)/10;
 end
 2'b11: begin
 Anode = 4'b1110;
 LED_BCD = ((Num % 1000)%100)%10;
 end
 endcase
 end
 always @(*)
 begin
 case(LED_BCD)
 4'b0000: LEDOut = 7'b0000001; // "0"
 4'b0001: LEDOut = 7'b1001111; // "1"
 4'b0010: LEDOut = 7'b0010010; // "2"
 4'b0011: LEDOut = 7'b0000110; // "3"
 4'b0100: LEDOut = 7'b1001100; // "4"
 4'b0101: LEDOut = 7'b0100100; // "5"
 4'b0110: LEDOut = 7'b0100000; // "6"
 4'b0111: LEDOut = 7'b0001111; // "7"
 4'b1000: LEDOut = 7'b0000000; // "8"
 4'b1001: LEDOut = 7'b0000100; // "9"
 default: LEDOut = 7'b0000001; // "0"
 endcase
 end
endmodule 