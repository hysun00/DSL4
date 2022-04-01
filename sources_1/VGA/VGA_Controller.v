`timescale 1ns / 1ps

module VGA_Controller(
    input CLK, //100 MHz
    input RESET,
    input [7:0] BUS_ADDR,
    inout [7:0] BUS_DATA,
    input BUS_WE,
    input BACKFORE,
    output VGA_HS,
    output VGA_VS,
    output [7:0] VGA_COLOUR
    );

    parameter [7:0] VGABaseAddress = 8'hB0;
    parameter [6:0] MouseLimitY = 7'd120;

    reg [15:0] CONFIG_COLOUR = 16'b0000111111000000;
    reg [14:0] A_ADDR;
    reg A_DATA_IN, A_WE;
    wire A_DATA_OUT;

    wire [9:0] ADDRH,ADDRV;

    wire DPR_CLK;
    wire [14:0] VGA_ADDR;
    wire B_DATA,VGA_DATA;


    Frame_Buffer frame_buffer(
                         /// Port A - Read/Write
                         .A_CLK(CLK),
                         .RESET(RESET),
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
                     .ADDRH(ADDRH),
                     .ADDRV(ADDRV),
                     .VGA_COLOUR(VGA_COLOUR)
                 );

    VGA_Time vga_time(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .ADDRH(ADDRH),
        .ADDRV(ADDRV),
        .B_DATA(B_DATA),
        .VGA_DATA(VGA_DATA)
    );

    reg VGABusWE;
    reg [7:0] pre_colour = 8'h01;
    reg [7:0] Out;

    // Tristate
    assign BUS_DATA = (VGABusWE) ? Out : 8'hZZ;

    always@(posedge CLK) begin
        if(RESET) begin
            CONFIG_COLOUR <= 16'b0000111111000000;
            pre_colour <= 8'h01;
        end
        else if (BUS_WE) begin
            VGABusWE <= 1'b0;

            // X coordinate
            case (BUS_ADDR)
                8'hB0: begin
                    A_WE <= 1'b0;
                    A_ADDR[7:0] <= BUS_DATA;
                end

                8'hB1: begin
                    A_WE <= 1'b0;
                    // A_ADDR[14:8] <= MouseLimitY - BUS_DATA[6:0] -1;
                    A_ADDR[14:8] <= BUS_DATA[6:0];
                end

                8'hB2: begin
                    A_WE <= 1'b1;
                    A_DATA_IN <= BUS_DATA[0];
                end

                8'hB3: begin
                    A_WE <= 1'b0;
                    if(pre_colour != BUS_DATA) begin
                        pre_colour <= BUS_DATA;
                        if(BACKFORE) begin
                            CONFIG_COLOUR[7:0] <= CONFIG_COLOUR[7:0] + 1;
                        end
                        else begin
                            CONFIG_COLOUR[15:8] <= CONFIG_COLOUR[15:8] + 1;
                        end
                    end
                end

                default: A_WE <= 1'b0;
            endcase
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