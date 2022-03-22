`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10.03.2022 22:37:38
// Design Name:
// Module Name: ROM_TB
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


module ROM_TB();

    reg CLK        = 0;
    reg [7:0] ADDR = 0;
    wire [7:0] DATA;

        ROM uut(
            .CLK(CLK),
            .DATA(DATA),
            .ADDR(ADDR)
        );

        initial begin
            forever #5 CLK = ~CLK;
        end

        initial begin
            forever #10 ADDR = ADDR + 1;
        end
endmodule
