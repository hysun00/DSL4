`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2022 21:04:01
// Design Name: 
// Module Name: Top_stim
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


module TOP_stim();

parameter CLOCK_PERIOD = 10;//100MHZ

reg CLK;
reg RESET;
reg[3:0] SW;

wire CLK_MOUSE;
wire DATA_MOUSE;

wire IR_LED;
wire [7:0] DIGIT;
wire [3:0] SEL;
wire[15:0] LEDS;
wire VGA_HS;
wire VGA_VS;
wire [7:0] VGA_COLOUR;
    

TOP uut
(
    .CLK(CLK),
    .RESET(RESET),
    .IR_LED(IR_LED),
    .DIGIT(DIGIT),
    .SEL(SEL),
    .SW(SW),
    .LEDS(LEDS),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .VGA_COLOUR(VGA_COLOUR)
);

initial begin
    RESET=1'b0;
    #10 RESET = 1'b1;
    #30 RESET = 1'b0;
end

initial begin
   CLK=1'b0;
   forever #(CLOCK_PERIOD/2) CLK = ~CLK;
end

initial begin
    SW = 4'b1100;
end

endmodule
