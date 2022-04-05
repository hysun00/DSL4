`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer:
//
// Create Date: 24.01.2022 00:01:18
// Design Name:
// Module Name: MouseMasterSM
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



module MouseMasterSM(input CLK,
                     input RESET,
                     output SEND_BYTE,
                     output [7:0] BYTE_TO_SEND,
                     input BYTE_SENT,
                     output READ_ENABLE,
                     input [7:0] BYTE_READ,
                     input [1:0] BYTE_ERROR_CODE,
                     input BYTE_READY,
                     output [7:0] MOUSE_DX,
                     output [7:0] MOUSE_DY,
                     output [7:0] MOUSE_DZ,
                     output [7:0] MOUSE_STATUS,
                     output SEND_INTERRUPT,
                     output [5:0] MasterStateCode);

    /*
    Main state machine - There is a setup sequence

    1) Send FF -- Reset command,
    2) Read FA -- Mouse Acknowledge,
    2) Read AA -- Self-Test Pass
    3) Read 00 -- Mouse ID
    4) Send F3 -- Set Sample Rate, Attempt to Enter Microsoft Mouse Scrolling Mouse mode
    5) Read FA -- Mouse Acknowledge,
    6) Send C8 -- Decimal 200 sample rate
    7) Read F4 -- Mouse Acknowledge,
    8) Send F3 -- Set Sample Rate, Attempt to Enter Microsoft Mouse Scrolling Mouse mode
    9) Read FA -- Mouse Acknowledge,
    10) Send 64 -- Decimal 100 sample rate
    11) Read F4 -- Mouse Acknowledge,
    12) Send F3 -- Set Sample Rate, Attempt to Enter Microsoft Mouse Scrolling Mouse mode
    13) Read FA -- Mouse Acknowledge,
    14) Send 50 -- Decimal 80 sample rate
    15) Read FA -- Mouse Acknowledge,
    16) Send F2 -- Read Device Type
    17) Read FA -- Mouse Acknowledge,
    18) Read 00 -- Mouse ID. Response 03 if microsoft scrolling mouse
    19) Send F4 -- Start transmitting command,
    20) Read F4 -- Mouse Acknowledge,

    If at any time this chain is broken, the SM will restart from
    the beginning. Once it has finished the set-up sequence, the read enable flag
    is raised.
    The host is then ready to read mouse information 4 bytes at a time:
    S1) Wait for first read, When it arrives, save it to Status. Goto S2.
    S2) Wait for second read, When it arrives, save it to DX. Goto S3.
    S3) Wait for third read, When it arrives, save it to DY. Goto S4.
    S4) Wait for third read, When it arrives, save it to DZ. Goto S1.
    Send interrupt.
    State Control
    */

    reg [5:0] Curr_State, Next_State;
    reg [23:0] Curr_Counter, Next_Counter;
    //Transmitter Control
    reg Curr_SendByte, Next_SendByte;
    reg [7:0] Curr_ByteToSend, Next_ByteToSend;
    //Receiver Control
    reg Curr_ReadEnable, Next_ReadEnable;
    //Data Registers
    reg [7:0] Curr_Status, Next_Status;
    reg [7:0] Curr_Dx, Next_Dx;
    reg [7:0] Curr_Dy, Next_Dy;
    reg [7:0] Curr_Dz, Next_Dz;
    reg Curr_SendInterrupt, Next_SendInterrupt;
    reg Curr_Scroll_Enable, Next_Scroll_Enable;

    //Sequential
    always@(posedge CLK) begin
        if (RESET) begin
            Curr_State         <= 6'h00;
            Curr_Counter       <= 0;
            Curr_SendByte      <= 1'b0;
            Curr_ByteToSend    <= 8'h00;
            Curr_ReadEnable    <= 1'b0;
            Curr_Status        <= 8'h00;
            Curr_Dx            <= 8'h00;
            Curr_Dy            <= 8'h00;
            Curr_Dz            <= 8'h00;
            Curr_SendInterrupt <= 1'b0;
            Curr_Scroll_Enable <= 1'b0;
        end
        else begin
            Curr_State         <= Next_State;
            Curr_Counter       <= Next_Counter;
            Curr_SendByte      <= Next_SendByte;
            Curr_ByteToSend    <= Next_ByteToSend;
            Curr_ReadEnable    <= Next_ReadEnable;
            Curr_Status        <= Next_Status;
            Curr_Dx            <= Next_Dx;
            Curr_Dy            <= Next_Dy;
            Curr_Dz            <= Next_Dz;
            Curr_SendInterrupt <= Next_SendInterrupt;
            Curr_Scroll_Enable <= Next_Scroll_Enable;
        end
    end


    //Combinatorial
    always@* begin
        Next_State         = Curr_State;
        Next_Counter       = Curr_Counter;
        Next_SendByte      = 1'b0;
        Next_ByteToSend    = Curr_ByteToSend;
        Next_ReadEnable    = 1'b0;
        Next_Status        = Curr_Status;
        Next_Dx            = Curr_Dx;
        Next_Dy            = Curr_Dy;
        Next_Dz            = Curr_Dz;
        Next_SendInterrupt = 1'b0;
        case(Curr_State)
            //Initialise State - Wait here for 10ms before trying to initialise the mouse.
            6'h00: begin
                if (Curr_Counter == 1000000) begin // 1/100th sec at 100MHz clock
                    Next_State   = 6'h01;
                    Next_Counter = 0;
                end
                else
                    Next_Counter = Curr_Counter + 1'b1;
            end

            //Start initialisation by sending FF
            6'h01: begin
                Next_State      = 6'h02;
                Next_SendByte   = 1'b1;
                Next_ByteToSend = 8'hFF;
            end

            //Wait for confirmation of the byte being sent
            6'h02: begin
                if (BYTE_SENT)
                    Next_State = 6'h03;
            end

            //Wait for confirmation of a byte being received
            //If the byte is FA goto next state, else re-initialise.
            6'h03: begin
                if (BYTE_READY) begin
                    if ((BYTE_READ == 8'hFA) & (BYTE_ERROR_CODE == 2'b00))
                        Next_State = 6'h04;
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

            //Wait for self-test pass confirmation
            //If the byte received is AA goto next state, else re-initialise
            6'h04: begin
                if (BYTE_READY) begin
                    if ((BYTE_READ == 8'hAA) & (BYTE_ERROR_CODE == 2'b00))
                        Next_State = 6'h05;
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

            //If the byte is 00 (MOUSE ID) goto next state  else re-initialise
            6'h05: begin
                if (BYTE_READY) begin
                    if ((BYTE_READ == 8'h00) & (BYTE_ERROR_CODE == 2'b00))
                        Next_State = 6'h06;
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

            // Start Set Sample Rate by sending F3
            // To enter "scrolling wheel" mode, the host sends the following command sequence:
            // Set sample rate 200
            // Set sample rate 100
            // Set sample rate 80
            6'h06: begin
                Next_State      = 6'h07;
                Next_SendByte   = 1'b1;
                Next_ByteToSend = 8'hF3;
            end

            // Wait for confirmation of the byte being sent
            6'h07: begin
                if (BYTE_SENT)
                    Next_State = 6'h08;
            end

            // Wait for confirmation of a byte being received
            6'h08: begin
                if (BYTE_READY) begin
                    if ((BYTE_READ == 8'hFA) & (BYTE_ERROR_CODE == 2'b00))
                        Next_State = 6'h09;
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

            // Set sample rate 8'd200
            6'h09: begin
                Next_State      = 6'h0A;
                Next_SendByte   = 1'b1;
                Next_ByteToSend = 8'd200;
            end

            //Wait for confirmation of the byte being sent
            6'h0A: begin
                if (BYTE_SENT)
                    Next_State = 6'h0B;
            end

            // Wait for confirmation of a byte being received
            6'h0B: begin
                if (BYTE_READY) begin
                    if (BYTE_READ == 8'hF4)
                        Next_State = 6'h0C;
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

            //Start Set Sample Rate by sending F3
            6'h0C: begin
                Next_State      = 6'h0D;
                Next_SendByte   = 1'b1;
                Next_ByteToSend = 8'hF3;
            end

            //Wait for confirmation of the byte being sent
            6'h0D: begin
                if (BYTE_SENT)
                    Next_State = 6'h0E;
            end

            //Wait for confirmation of a byte being received
            6'h0E: begin
                if (BYTE_READY) begin
                    if ((BYTE_READ == 8'hFA) & (BYTE_ERROR_CODE == 2'b00))
                        Next_State = 6'h0F;
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

            // Set sample rate 8'd100
            6'h0F: begin
                Next_State      = 6'h10;
                Next_SendByte   = 1'b1;
                Next_ByteToSend = 8'd100;
            end

            // Wait for confirmation of the byte being sent
            6'h10: begin
                if (BYTE_SENT)
                    Next_State = 6'h11;
            end

            // Wait for confirmation of a byte being received
            6'h11: begin
                if (BYTE_READY) begin
                    if (BYTE_READ == 8'hF4)
                        Next_State = 6'h12;
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

            //Start Set Sample Rate by sending F3
            6'h12: begin
                Next_State      = 6'h13;
                Next_SendByte   = 1'b1;
                Next_ByteToSend = 8'hF3;
            end

            // Wait for confirmation of the byte being sent
            6'h13: begin
                if (BYTE_SENT)
                    Next_State = 6'h14;
            end

            // Wait for confirmation of a byte being received
            6'h14: begin
                if (BYTE_READY) begin
                    if ((BYTE_READ == 8'hFA) & (BYTE_ERROR_CODE == 2'b00))
                        Next_State = 6'h15;
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

            // Set sample rate 8'd80
            6'h15: begin
                Next_State      = 6'h16;
                Next_SendByte   = 1'b1;
                Next_ByteToSend = 8'd80;
            end

            // Wait for confirmation of the byte being sent
            6'h16: begin
                if (BYTE_SENT)
                    Next_State = 6'h17;
            end

            // Wait for confirmation of a byte being received
            6'h17: begin
                if (BYTE_READY) begin
                    if ((BYTE_READ == 8'hFA) & (BYTE_ERROR_CODE == 2'b00))
                        Next_State = 6'h18;
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

             // Start Read Device Type by sending F2
            6'h18: begin
                Next_State      = 6'h19;
                Next_SendByte   = 1'b1;
                Next_ByteToSend = 8'hF2;
            end

            // Wait for confirmation of the byte being sent
            6'h19: begin
                if (BYTE_SENT)
                    Next_State = 6'h1A;
            end

            //Wait for confirmation of a byte being received
            6'h1A: begin
                if (BYTE_READY) begin
                    if (BYTE_READ == 8'hF4)
                        Next_State = 6'h1B;
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

            // Wait for confirmation of a byte being received
            // If the byte is 03 goto next state (MOUSE ID) else re-initialise
            // This tells the host that the attached pointing device has a scrolling wheel and the host will then expect the mouse to use the following 4-byte movement data packet
            6'h1B: begin
                if (BYTE_READY) begin
                    if (BYTE_READ == 8'h03) begin
                        Next_State = 6'h1C;
                        Next_Scroll_Enable = 1'b1;
                    end
                    else if (BYTE_READ == 8'h00) begin
                        Next_State = 6'h1C;
                        Next_Scroll_Enable = 1'b0;
                    end
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

            //Send F4 - to start mouse transmit
            6'h1C: begin
                Next_State      = 6'h1D;
                Next_SendByte   = 1'b1;
                Next_ByteToSend = 8'hF4;
            end

            //Wait for confirmation of the byte being sent
            6'h1D: begin
                if (BYTE_SENT)
                    Next_State = 6'h1E;
            end

            //Wait for confirmation of a byte being received
            //If the byte is F4 goto next state, else re-initialise
            6'h1E: begin
                if (BYTE_READY) begin
                    if (BYTE_READ == 8'hF4)
                        Next_State = 6'h1F;
                    else
                        Next_State = 6'h0;
                end

                Next_ReadEnable = 1'b1;
            end

            ///////////////////////////////////////////////////////////
            //At this point the SM has initialised the mouse.
            //Now we are constantly reading. If at any time
            //there is an error, we will re-initialise
            //the mouse - just in case.
            ///////////////////////////////////////////////////////////
            //Wait for the confirmation of a byte being received.
            //This byte will be the first of three, the status byte.
            //If a byte arrives, but is corrupted, then we re-initialise
            6'h1F: begin
                if (BYTE_READY) begin
                    if(BYTE_ERROR_CODE == 2'b00) begin
                        Next_State  = 6'h20;
                        Next_Status = BYTE_READ;
                    end
                    else
                        Next_State      = 6'h0;
                end

                Next_Counter    = 0;
                Next_ReadEnable = 1'b1;
            end

            //Wait for confirmation of a byte being received
            //This byte will be the second of four, the Dx byte.
            6'h20: begin
                if (BYTE_READY) begin
                    if(BYTE_ERROR_CODE == 2'b00) begin
                        Next_State  = 6'h21;
                        Next_Dx = BYTE_READ;
                    end
                    else
                        Next_State      = 6'h0;
                end

                Next_Counter    = 0;
                Next_ReadEnable = 1'b1;
            end

            //Wait for confirmation of a byte being received
            //This byte will be the third of four, the Dy byte.
            6'h21: begin
                if (BYTE_READY) begin
                    if(BYTE_ERROR_CODE == 2'b00) begin
                        if (Curr_Scroll_Enable)
                            Next_State  = 6'h22;
                        else
                            Next_State = 6'h23;

                        Next_Dy = BYTE_READ;
                    end
                    else
                        Next_State      = 6'h0;
                end

                Next_Counter    = 0;
                Next_ReadEnable = 1'b1;
            end

            //Wait for confirmation of a byte being received
            //This byte will be the fourth of four, the Dz byte.
            6'h22: begin
                if (BYTE_READY) begin
                    if(BYTE_ERROR_CODE == 2'b00) begin
                        Next_State  = 6'h23;
                        Next_Dz = BYTE_READ;
                    end
                    else
                        Next_State      = 6'h0;
                end

                Next_Counter    = 0;
                Next_ReadEnable = 1'b1;
            end

            //Send Interrupt State
            6'h23: begin
                Next_State         = 6'h1F;
                Next_SendInterrupt = 1'b1;
            end

            //Default State
            default: begin
                Next_State         = 6'h00;
                Next_Counter       = 0;
                Next_SendByte      = 1'b0;
                Next_ByteToSend    = 8'hFF;
                Next_ReadEnable    = 1'b0;
                Next_Status        = 8'h00;
                Next_Dx            = 8'h00;
                Next_Dy            = 8'h00;
                Next_SendInterrupt = 1'b0;
            end
        endcase
    end

    ///////////////////////////////////////////////////
    //Tie the SM signals to the IO
    //Transmitter
    assign SEND_BYTE = Curr_SendByte;
    assign BYTE_TO_SEND = Curr_ByteToSend;
    //Receiver
    assign READ_ENABLE = Curr_ReadEnable;
    //Output Mouse Data
    assign MOUSE_DX       = Curr_Dx;
    assign MOUSE_DY       = Curr_Dy;
    assign MOUSE_DZ       = Curr_Dz;
    assign MOUSE_STATUS   = Curr_Status;
    assign SEND_INTERRUPT = Curr_SendInterrupt;
    assign MasterStateCode = Curr_State;

endmodule
