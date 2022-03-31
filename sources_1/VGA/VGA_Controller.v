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
    reg A_DATA_IN, A_WE, VGA_DATA;
    wire A_DATA_OUT;

    wire [9:0] ADDRH,ADDRV;

    wire DPR_CLK;
    wire [14:0] VGA_ADDR;
    wire B_DATA;

    reg [10:0] Time_RAM [number_height * number_width - 1:0];

    initial $readmemb("Numbers_VGA_RAM.txt", Time_RAM);


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

    reg [9:0] numberx, numbery;
    reg [12:0] number_addr;
    wire [3:0] min0,sec0;
    wire [2:0] min1,sec1;
    wire Bit27TriggerOut, SEC0, SEC1, MIN0;

    Generic_counter # (.COUNTER_WIDTH(27),
                        .COUNTER_MAX(99999999)
                        )
                        Bit27Counter (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(1'b1),
                        .TRIG_OUT(Bit27TriggerOut)
                        );

    Generic_counter # (.COUNTER_WIDTH(4),
                        .COUNTER_MAX(9)
                        )
                        Bit4Counter (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(Bit27TriggerOut),
                        .COUNT(sec0),
                        .TRIG_OUT(SEC0)
                        );
    Generic_counter # (.COUNTER_WIDTH(3),
                        .COUNTER_MAX(5)
                        )
                        Bit3Counter (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(SEC0),
                        .COUNT(sec1),
                        .TRIG_OUT(SEC1)
                        );
    Generic_counter # (.COUNTER_WIDTH(4),
                        .COUNTER_MAX(9)
                        )
                        Bit4Counter2 (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(SEC1),
                        .COUNT(min0),
                        .TRIG_OUT(MIN0)
                        );

    Generic_counter # (.COUNTER_WIDTH(3),
                        .COUNTER_MAX(5)
                        )
                        Bit3Counter2 (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(MIN0),
                        .COUNT(min1)
                        );

    localparam [9:0] number_height = 10'd44;
    localparam [9:0] number_width = 10'd31;
    localparam [9:0] number_startx = 10'd238;
    localparam [9:0] number_starty = 10'd218;

    always@(posedge CLK) begin
        if(ADDRH >= number_startx + number_width * 4 && ADDRH < number_startx + number_width * 5 && ADDRV >= number_starty && ADDRV < number_starty + number_height) begin
            numberx <= ADDRH - (number_startx + number_width * 4);
            numbery <= ADDRV - number_starty;
            number_addr = numbery * number_width + numberx;

            VGA_DATA=Time_RAM[number_addr][sec0];
        end
        else if(ADDRH >= number_startx + number_width * 3 && ADDRH < number_startx + number_width * 4 && ADDRV >= number_starty && ADDRV < number_starty + number_height) begin
            numberx<=ADDRH - (number_startx + number_width * 3);
            numbery<=ADDRV - number_starty;
            number_addr=numbery * number_width + numberx;

            VGA_DATA=Time_RAM[number_addr][sec1];
        end
        else if(ADDRH >= number_startx + number_width * 2 && ADDRH < number_startx + number_width * 3 && ADDRV >= number_starty && ADDRV < number_starty + number_height) begin
            numberx<=ADDRH-(number_startx + number_width * 2);
            numbery<=ADDRV - number_starty;
            number_addr=numbery * number_width + numberx;

            VGA_DATA=Time_RAM[number_addr][10];
        end
        else if(ADDRH >= number_startx + number_width * 1 && ADDRH < number_startx + number_width * 2 && ADDRV >= number_starty && ADDRV < number_starty + number_height) begin
            numberx<=ADDRH-(number_startx + number_width * 1);
            numbery<=ADDRV - number_starty;
            number_addr=numbery * number_width + numberx;

            VGA_DATA=Time_RAM[number_addr][min0];
        end
        else if(ADDRH >= number_startx + number_width * 0 && ADDRH < number_startx + number_width * 1 && ADDRV >= number_starty && ADDRV < number_starty + number_height) begin
            numberx<=ADDRH-(number_startx + number_width * 0);
            numbery<=ADDRV - number_starty;
            number_addr=numbery * number_width + numberx;

            VGA_DATA=Time_RAM[number_addr][min1];
        end
        else
            VGA_DATA<=B_DATA;
    end


    reg VGABusWE;
    reg [7:0] pre_colour = 8'h01;
    reg [7:0] Out;

    // Tristate
    assign BUS_DATA = (VGABusWE) ? Out : 8'hZZ;

    always@(posedge CLK) begin
        if(RESET) begin
            CONFIG_COLOUR <= 16'b0000111111000000;
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

                8'hB4: begin
                    A_WE <= 1'b0;

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