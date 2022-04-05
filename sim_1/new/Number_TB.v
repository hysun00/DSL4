`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 30.03.2022 00:32:23
// Design Name:
// Module Name: Number_TB
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


module Number_TB();

    reg [10:0] Time_RAM [44*31:0];
    initial $readmemb("Numbers_VGA_RAM.txt", Time_RAM);

    reg CLK   = 1;
    reg RESET = 1;
    wire [9:0] ADDRH,ADDRV;
    wire HorzCountTriggOut;
    reg [9:0] out;
    Generic_counter # (.COUNTER_WIDTH(6),
    .COUNTER_MAX(44)
    )
    HorzCounter(
    .CLK(CLK),
    .RESET(RESET),
    .ENABLE(1'b1),
    .TRIG_OUT(HorzCountTriggOut),
    .COUNT(ADDRH)
    );

    Generic_counter # (.COUNTER_WIDTH(5),
    .COUNTER_MAX(31)
    )
    VertCounter(
    .CLK(CLK),
    .RESET(RESET),
    .ENABLE(HorzCountTriggOut),
    .COUNT(ADDRV)
    );
    reg [12:0] ADDR = 0;
    always@(posedge CLK) begin
        ADDR = ADDRV[8:0]*10'd44+ADDRH;
        out  = Time_RAM[ADDR][0];
    end

    initial begin
        forever #5 CLK = ~CLK;
    end

    initial begin
        #10 RESET = 0;
    end
endmodule
