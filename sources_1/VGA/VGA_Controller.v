`timescale 1ns / 1ps

module VGA_Controller(
    input CLK, //100 MHz
    input RESET,
    input [7:0] BUS_ADDR,
    inout [7:0] BUS_DATA,
    input BUS_WE,
    output VGA_HS,
    output VGA_VS,
    output [7:0] VGA_COLOUR
    );

    parameter [7:0] VGABaseAddress = 8'hB0;
    parameter [7:0] MouseLimitY = 120;

    reg [15:0] CONFIG_COLOUR = 16'b0000111111000000;
    reg [14:0] A_ADDR;
    reg A_DATA_IN;
    reg A_WE;
    wire A_DATA_OUT;

    wire [9:0] ADDRX,ADDRY;
    reg VGA_DATA;

    wire DPR_CLK;
    wire [14:0] VGA_ADDR;
    wire B_DATA;

    //5 different backgrounds & foregrounds
    reg [15:0] colours [0:4];
    initial begin
        colours[0] <= 16'b0011111100000111;
        colours[1] <= 16'b1000011100000000;
        colours[2] <= 16'b0000011100110000;
        colours[3] <= 16'b0011111110000111;
        colours[4] <= 16'b0001111111010000;
    end

    Frame_Buffer frame_buffer(
                         /// Port A - Read/Write
                         .A_CLK(CLK),
                         .A_ADDR(A_ADDR), // 8 + 7 bits = 15 bits hence [14:0]
                         .A_DATA_IN(A_DATA_IN), // Pixel Data In
                         .A_DATA_OUT(A_DATA_OUT),
                         .A_WE(A_WE), // Write Enable
                         //Port B - Read Only
                         .B_CLK(DPR_CLK),
                         .B_ADDR(VGA_ADDR),
                         .B_DATA(B_DATA) // Pixel Data Out
                     );

    VGA_Sig_Gen vga(
                     .CLK(CLK),
                     .RESET(RESET),
                     //Colour Configuration Interface
                     .CONFIG_COLOURS(CONFIG_COLOUR),
                     //Frame Buffer (Dual Port memory) Interface
                     .DPR_CLK(DPR_CLK),
                     .VGA_ADDR(VGA_ADDR),
                     .VGA_DATA(VGA_DATA),
                     //VGA Port Interface
                     .VGA_HS(VGA_HS),
                     .VGA_VS(VGA_VS),
                     .ADDRX(ADDRX),
                     .ADDRY(ADDRY),
                     .VGA_COLOUR(VGA_COLOUR)
                 );

    always@(posedge CLK) begin
        if(ADDRX==10'd512 && ADDRY<10'd320)
            VGA_DATA<=1;
        else
            VGA_DATA<=B_DATA;
    end


    reg VGABusWE;
    reg [7:0] Out;

    // Tristate
    assign BUS_DATA = (VGABusWE) ? Out : 8'hZZ;

    always@(posedge CLK) begin
        if (BUS_WE) begin
            VGABusWE <= 1'b0;

            // X coordinate
            if (BUS_ADDR == VGABaseAddress) begin
                A_WE <= 1'b0;
                A_ADDR[7:0] <= BUS_DATA;
            end
            // Y coordinate
            else if (BUS_ADDR == VGABaseAddress + 1) begin
                A_WE <= 1'b0;
                A_ADDR[14:8] <= BUS_DATA[6:0];
            end
            // Pixel value to write
            else if (BUS_ADDR == VGABaseAddress + 2) begin
                A_WE <= 1'b1;
                A_DATA_IN <= BUS_DATA[0];
            end
            else
                A_WE <= 1'b0;
        end
        else begin
            // Enable the VGA module to write to bus (if the address is right)
            if (BUS_ADDR >= VGABaseAddress & BUS_ADDR < VGABaseAddress + 3)
                VGABusWE <= 1'b1;
            else
                VGABusWE <= 1'b0;

            // Processor is not writing, so disable writing to frame buffer
            A_WE <= 1'b0;
        end

        Out <= A_DATA_OUT;
    end

endmodule