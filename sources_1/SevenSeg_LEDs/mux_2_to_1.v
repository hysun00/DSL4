`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2022 16:45:41
// Design Name: 
// Module Name: mux_2_to_1
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


module mux_2_to_1
#(
    WIDTH = 8
)
(
    input  [WIDTH-1 : 0] IN0,
    input  [WIDTH-1 : 0] IN1,
    input  MUX_SEL,
    output [WIDTH-1 : 0] OUT
);

assign OUT = MUX_SEL ? IN1 : IN0;

endmodule
