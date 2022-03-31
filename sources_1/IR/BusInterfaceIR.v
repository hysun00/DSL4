`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2022 22:01:53
// Design Name: 
// Module Name: BusInterfaceIR
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


module BusInterfaceIR
#(
    parameter IO_ADDRESS = 8'h90
)
(
    input  CLK,
    input  RESET,
    input  BUS_WE,
    input  [7:0] ADDR,
    input  [7:0] DATA_IN,
    output [7:0] DATA_OUT
);

reg [7:0] data_out;

always@(posedge CLK)
    if (RESET) 
        data_out <= 8'h0;
    else 
        if(BUS_WE & (ADDR == IO_ADDRESS) ) 
            data_out <= DATA_IN;
        else 
            data_out <= data_out;

assign DATA_OUT = data_out;

endmodule