`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2022 21:58:38
// Design Name: 
// Module Name: TenHz_cnt
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


module TenHz_cnt
#(
    parameter IN_MHZ        = 100,
    parameter OUT_KHZ       = 0.01,
    parameter COUNTER_WIDTH = 25
)
(
    input  CLK,
    input  RESET,
    output CLK_OUT
);

// Internal signals
reg clk_out;
reg [COUNTER_WIDTH-1:0] count;
reg [COUNTER_WIDTH-1:0] bound=(1000*IN_MHZ/ OUT_KHZ / 2 - 1); //half of total output cycles

// *****************************
// Pulse counter
// *****************************
always @ (posedge CLK)
    if(RESET == 1'b1) count <= 0;
    else if( count == bound ) count <= 0;
    else count <= count + 1'b1;
// *****************************

// *****************************
// Output clock signal, 50% duty
// *****************************
always @ (posedge CLK)
    if(RESET == 1'b1) clk_out <= 0;
    else if( count == bound ) clk_out <= ~clk_out;      
    else clk_out <= clk_out;  
// *****************************
 
assign CLK_OUT = clk_out;

endmodule
