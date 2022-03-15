`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05.03.2022 23:04:54
// Design Name:
// Module Name: ROM
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


module ROM(input CLK,
           output reg [7:0] DATA,
           input [7:0] ADDR);

    parameter RAMAddrWidth = 8;

    //Memory
    reg [7:0] ROM [2**RAMAddrWidth-1:0];

    // Load program
    initial $readmemb("F:/FPGA/PS2_Microprocessor/PS2_Microprocessor.srcs/sources_1/new/Complete_Demo_ROM.txt", ROM);

    //single port ram
    always@(posedge CLK)
        DATA <= ROM[ADDR];

endmodule
