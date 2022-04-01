`timescale 1ns / 1ps

module Frame_Buffer(
    /// Port A - Read/Write
    input A_CLK,
    input RESET,
    input [14:0] A_ADDR, // 8 + 7 bits = 15 bits hence [14:0]
    input A_DATA_IN, // Pixel Data In
    output reg A_DATA_OUT,
    input A_WE, // Write Enable
    //Port B - Read Only
    input B_CLK,
    input [14:0] B_ADDR, // Pixel Data Out
    output reg B_DATA
);
    // A 256 x 128 1-bit memory to hold frame data
    //The LSBs of the address correspond to the X axis, and the MSBs to the Y axis
    reg [0:0] Mem [2**15-1:0];

    initial $readmemh("VGA_INIT.txt", Mem);

    // Port A - Read/Write e.g. to be used by microprocessor
    always@(posedge A_CLK) begin
        if(A_WE)
            Mem[A_ADDR] <= A_DATA_IN;

        A_DATA_OUT <= Mem[A_ADDR];
    end

    //Port B - Read Only e.g. to be read from the VGA signal generator module for display
    always@(posedge B_CLK)
        B_DATA <= Mem[B_ADDR];

endmodule