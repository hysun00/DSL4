`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2022 12:42:23
// Design Name: 
// Module Name: RAM
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


module RAM
(
 //standard signals
    input CLK,
//BUS signals
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE
 );
parameter RAMBaseAddr  = 0;
parameter RAMAddrWidth = 7; // 128 x 8-bits memory

//Tristate
wire [7:0] BufferedBusData;
reg  [7:0] Out;
reg  RAMBusWE;
//Memory
reg [7:0] Mem [2**RAMAddrWidth-1:0];
// Initialise the memory for data preloading, initialising variables, and declaring constants
initial $readmemh("Complete_Demo_RAM.txt", Mem);
//single port ram
always@(posedge CLK) begin
// Brute-force RAM address decoding. Think of a simpler way...
    if((BUS_ADDR >= RAMBaseAddr) & (BUS_ADDR < RAMBaseAddr + 128)) 
        if(BUS_WE) begin
            Mem[BUS_ADDR[6:0]] <= BufferedBusData;
            RAMBusWE <= 1'b0;
        end 
        else RAMBusWE <= 1'b1;
    else RAMBusWE <= 1'b0;
    Out <= Mem[BUS_ADDR[6:0]];
end

//Only place data on the bus if the processor is NOT writing, and it is addressing this memory
assign BUS_DATA = (RAMBusWE) ? Out : 8'hZZ;
assign BufferedBusData = BUS_DATA;

endmodule