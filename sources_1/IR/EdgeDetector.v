`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.02.2022 13:56:06
// Design Name: 
// Module Name: edge_detector
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


module EdgeDetector
(
  input  CLK,
  input  RESET,
  input  ORIGINAL,
  output SAMPLED
);

//Internal signals
reg [1:0] delay;

always @ (posedge CLK)
  if(RESET == 1'b1) delay <= 0;
  else delay<={delay[0],ORIGINAL};

assign SAMPLED = delay[0] && ~delay[1];       

endmodule
