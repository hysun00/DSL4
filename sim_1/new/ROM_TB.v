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
//    reg [7:0] ROM [2**8-1:0];
//    integer index;
//    initial begin
//        $readmemb("F:/FPGA/PS2_Microprocessor/PS2_Microprocessor.srcs/sources_1/new\Complete_Demo_ROM.txt", ROM);
//        for(index = 0; index < 2**8; index = index + 1)
//        begin
//            $display("The Value is:%b and index in decimal %d",ROM[index],index);
//        end
//    end
endmodule
