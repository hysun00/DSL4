`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2022 19:07:21
// Design Name: 
// Module Name: ROM_tb
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


module ROM_tb();

reg CLK;
reg [7:0] BUS_ADDR;
wire [7:0] BUS_DATA;
    
ROM 
DUT_ROM
(
        .CLK(CLK),
        .DATA(BUS_DATA),
        .ADDR(BUS_ADDR)
);

    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        BUS_ADDR = 0;
        forever #10 BUS_ADDR = BUS_ADDR + 1;
    end
endmodule
