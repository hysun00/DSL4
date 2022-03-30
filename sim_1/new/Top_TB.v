`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 29.03.2022 11:44:12
// Design Name:
// Module Name: Top_TB
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


module Top_TB(

    );
    reg CLK=1;
    reg RESET=1;
    wire VGA_HS,VGA_VS;
    wire [7:0] VGA_COLOUR;

    TOP uut(
        .CLK(CLK),
        .RESET(RESET),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_COLOUR(VGA_COLOUR)
    );

    initial begin
               forever #5 CLK = ~CLK;
           end

       initial begin
           #10 RESET=0;
       end

endmodule
