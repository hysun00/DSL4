`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10.03.2022 22:56:00
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


module Micro_TB(

    );

    reg CLK=0;
    reg RESET=1;

    Micro uut(
        .CLK(CLK),
        .RESET(RESET)
    );

    initial begin
        forever #5 CLK = ~CLK;
    end

    initial begin
        #10 RESET = 0;
    end
endmodule
