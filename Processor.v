`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2022 20:57:19
// Design Name: 
// Module Name: Processor
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

module Processor
(
    // Standard Signals
    input CLK,
    input RESET,
    // BUS Signals
    inout  [7:0] BUS_DATA,            // Exclusive data bus.
    output [7:0] BUS_ADDR,            // Address the data memory(i.e. RAM) and I/O devices.
    output BUS_WE,                    // Enable writing.
    // ROM signals
    input  [7:0] ROM_DATA,            // Exclusive instruction bus
    output [7:0] ROM_ADDRESS,         // Address the instruction memory(i.e. ROM)
    // INTERRUPT signals
    input  [1:0] BUS_INTERRUPTS_RAISE,
    output [1:0] BUS_INTERRUPTS_ACK
);
// Instantiate program memory here


/////////////////////////////////////////////////////////////////////////////////////Internal  Signals/////////////////////////////////////////////////////////////////////////////////////
wire [7:0] AluOut;          // ALU result
wire [7:0] ProgMemoryOut;   // Instruction register
wire [7:0] BusDataIn;       // Data read from data bus
reg  [7:0] CurrState;       // State variable
reg  [7:0] NextState;
reg  [7:0] CurrBusDataOut;  // Data written to data bus
reg  [7:0] NextBusDataOut;
reg  [7:0] CurrBusAddr;     // Data written to address bus
reg  [7:0] NextBusAddr;
reg  [7:0] CurrRegA;        // General-purpose register a
reg  [7:0] NextRegA;
reg  [7:0] CurrRegB;        // General-purpose register b
reg  [7:0] NextRegB;
reg  [7:0] CurrPC;          // Programme counter
reg  [7:0] NextPC;
reg  [7:0] CurrProgContext [7:0]; // Register recording the function call site
reg  [7:0] NextProgContext [7:0];
reg  [4:0] CurrStackTop;
reg  [4:0] NextStackTop;
reg  [1:0] CurrInterruptAck;// Dedicated Interrupt output lines - one for each interrupt line
reg  [1:0] NextInterruptAck;
reg  CurrRegSelect;         // Register selection bit
reg  NextRegSelect;
reg  CurrPCOffset;          // PC offset
reg  NextPCOffset;
reg  CurrBusDataOutWE;      // Write enable
reg  NextBusDataOutWE; 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////State  Code////////////////////////////////////////////////////////////////////////////////////////
// The microprocessor is essentially a state machine, with one sequential pipeline
// of states for each operation.
// The current list of operations is:
// 0:  Read from memory to A 
// 1:  Read from memory to B
// 2:  Write to memory from A
// 3:  Write to memory from B
// 4:  Do maths with the ALU, and save result in reg A
// 5:  Do maths with the ALU, and save result in reg B
// 6:  If A (== or < or > B) GoTo ADDR (conditional branch)
// 7:  Go to ADDR (unconditional branch)
// 8:  Go to IDLE. End thread, go to idle state and wait for interrupt
// 9:  Function call
// 10: Return from function call
// 11: Dereference A (addressing mode: register indirect)
// 12: Dereference B (addressing mode: register indirect)

// Operation selection.
localparam [7:0] CHOOSE_OPP              = 8'h00;// Decoding instruction
//Data transfer (direct addressing)
localparam [7:0] READ_FROM_MEM_TO_A      = 8'h10;// Wait for the address being read from ROM, select reg A.
localparam [7:0] READ_FROM_MEM_TO_B      = 8'h11;// Wait for the address being read from ROM, select reg B.
localparam [7:0] READ_FROM_MEM_0         = 8'h12;// Set BUS_ADDR to designated address.
localparam [7:0] READ_FROM_MEM_1         = 8'h13;// Wait for the data being read. Increment the PC by 2.
localparam [7:0] READ_FROM_MEM_2         = 8'h14;// Write the data to chosen register, end op.
localparam [7:0] WRITE_TO_MEM_FROM_A     = 8'h20;// Wait for the memory address being read from ROM.
localparam [7:0] WRITE_TO_MEM_FROM_B     = 8'h21;// Wait for the address being read from ROM.
localparam [7:0] WRITE_TO_MEM_0          = 8'h22;// Write data to data bus by the designated address
localparam [7:0] WRITE_TO_MEM_1          = 8'h23;// Write data to data bus by the designated address
//Data Manipulation
localparam [7:0] DO_MATHS_OPP_SAVE_IN_A  = 8'h30;// The result of maths op. is available, save it to Reg A.
localparam [7:0] DO_MATHS_OPP_SAVE_IN_B  = 8'h31;// The result of maths op. is available, save it to Reg B.
localparam [7:0] DO_MATHS_OPP_0          = 8'h32;// Wait for new prog address to settle.
// Unconditional branch A and B
localparam [7:0] IF_A_EQUALITY_B_GOTO    = 8'h40;// Wait for the branch address being read from ROM.
localparam [7:0] IF_A_EQUALITY_B_GOTO_0  = 8'h41;// Branch to the designated ROM address or go to the consecutive one based on the alu result. 
localparam [7:0] IF_A_EQUALITY_B_GOTO_1  = 8'h42;
// Conditional branch
localparam [7:0] GOTO                    = 8'h50;// Wait for branching address being read from ROM.
localparam [7:0] GOTO_0                  = 8'h51;// Branch to the designated ROM address.
localparam [7:0] GOTO_1                  = 8'h52;
// Unconditional branch to idle state
localparam [7:0] GOTO_IDLE               = 8'h60;// Go to idle state unconditionally.
// Function call and returning
localparam [7:0] FUNCTION_START          = 8'h70;// Wait for the branch address being read from ROM. Record the call site
localparam [7:0] FUNCTION_START_0        = 8'h71;// Branch to the designated ROM address.
localparam [7:0] FUNCTION_START_1        = 8'h72;
localparam [7:0] RETURN                  = 8'h80;// Branch to the call site.
localparam [7:0] RETURN_0                = 8'h81;// Wait for new prog address to settle.
//Data transfer (impilicit register indirect addressing)
localparam [7:0] DE_REFERENCE_A          = 8'h90;// Write memory address, which is the content of register A, to ROM 
localparam [7:0] DE_REFERENCE_B          = 8'h91;// Write memory address, which is the content of register B, to ROM 
localparam [7:0] DE_REFERENCE_0          = 8'h92;// Waiting for the data being read from ROM
localparam [7:0] DE_REFERENCE_1          = 8'h93;// Data already read. Write data to the selected register.
//Data transfer (immdiate)
localparam [7:0] READ_FROM_IMM_TO_A      = 8'hA0;// Wait for the imm being read from ROM, select reg A.
localparam [7:0] READ_FROM_IMM_TO_B      = 8'hA1;// Wait for the imm being read from ROM, select reg B.
localparam [7:0] READ_FROM_IMM_0         = 8'hA2;// Increment the PC by 2.
localparam [7:0] READ_FROM_IMM_1         = 8'hA3;// Wait for new prog address to settle.
//Program thread selection
localparam [7:0] IDLE                    = 8'hF0;// Wait until an interrupt wakes up the processor.
localparam [7:0] GET_THREAD_START_ADDR_0 = 8'hF1;// Wait for new instruction address to arrive.
localparam [7:0] GET_THREAD_START_ADDR_1 = 8'hF2;// Apply the new address to the program counter.
localparam [7:0] GET_THREAD_START_ADDR_2 = 8'hF3;// Wait for the new instruction to settle. Goto ChooseOp.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////ALU////////////////////////////////////////////////////////////////////////////////////////////
ALU 
ALU_0
(
    .CLK        (CLK),
    .RESET      (RESET),
    .IN_A       (CurrRegA),
    .IN_B       (CurrRegB),
    .ALU_Op_Code(ProgMemoryOut[7:4]),
    .OUT_RESULT (AluOut)
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////State Machine///////////////////////////////////////////////////////////////////////////////////////
//Sequential section
always@(posedge CLK) 
    if(RESET) begin
        CurrState        <= 8'h00;
        CurrPC           <= 8'h00;
        CurrPCOffset     <= 1'h0;
        CurrStackTop     <= 4'h0;
        CurrBusAddr      <= 8'hFF; 
        CurrBusDataOut   <= 8'h00;
        CurrBusDataOutWE <= 1'b0;
        CurrRegA         <= 8'h00;
        CurrRegB         <= 8'h00;
        CurrRegSelect    <= 1'b0;
        CurrProgContext[0]  <= 8'h00;
        CurrProgContext[1]  <= 8'h00;
        CurrProgContext[2]  <= 8'h00;
        CurrProgContext[3]  <= 8'h00;
        CurrProgContext[4]  <= 8'h00;
        CurrProgContext[5]  <= 8'h00;
        CurrProgContext[6]  <= 8'h00;
        CurrProgContext[7]  <= 8'h00;
        CurrInterruptAck    <= 2'b00;
    end 
    else begin
        CurrState        <= NextState;
        CurrPC           <= NextPC;
        CurrPCOffset     <= NextPCOffset;
        CurrStackTop     <= NextStackTop;
        CurrBusAddr      <= NextBusAddr;
        CurrBusDataOut   <= NextBusDataOut;
        CurrBusDataOutWE <= NextBusDataOutWE;
        CurrRegA         <= NextRegA;
        CurrRegB         <= NextRegB;
        CurrRegSelect    <= NextRegSelect;
        CurrProgContext[0]  <= NextProgContext[0];
        CurrProgContext[1]  <= NextProgContext[1];
        CurrProgContext[2]  <= NextProgContext[2];
        CurrProgContext[3]  <= NextProgContext[3];
        CurrProgContext[4]  <= NextProgContext[4];
        CurrProgContext[5]  <= NextProgContext[5];
        CurrProgContext[6]  <= NextProgContext[6];
        CurrProgContext[7]  <= NextProgContext[7];
        CurrInterruptAck <= NextInterruptAck;
    end

//Combinatorial section 
always@(*) begin
    // Default configuration.
    NextState        = CurrState;
    NextPC           = CurrPC;
    NextPCOffset     = 1'h0;
    NextBusAddr      = 8'hFF;
    NextBusDataOut   = CurrBusDataOut;
    NextBusDataOutWE = 1'b0;
    NextRegA         = CurrRegA;
    NextRegB         = CurrRegB;
    NextRegSelect    = CurrRegSelect;
    NextStackTop     = CurrStackTop;
    NextProgContext[0]  = CurrProgContext[0];
    NextProgContext[1]  = CurrProgContext[1];
    NextProgContext[2]  = CurrProgContext[2];
    NextProgContext[3]  = CurrProgContext[3];
    NextProgContext[4]  = CurrProgContext[4];
    NextProgContext[5]  = CurrProgContext[5];
    NextProgContext[6]  = CurrProgContext[6];
    NextProgContext[7]  = CurrProgContext[7];
    NextInterruptAck = 2'b00;
    case (CurrState)
////////////////////////////////////Thread states////////////////////////////////////
        IDLE: begin
            if(BUS_INTERRUPTS_RAISE[0]) begin      // Interrupt Request A.
                NextState        = GET_THREAD_START_ADDR_0;
                NextPC           = 8'hFF;
                NextInterruptAck = 2'b01;
            end 
            else if(BUS_INTERRUPTS_RAISE[1]) begin // Interrupt Request B.
                NextState        = GET_THREAD_START_ADDR_0;
                NextPC           = 8'hFE;
                NextInterruptAck = 2'b10;
            end 
            else begin
                NextState        = IDLE;
                NextPC           = 8'hFF; 
                NextInterruptAck = 2'b00;
            end
        end

        GET_THREAD_START_ADDR_0: NextState = GET_THREAD_START_ADDR_1;

        GET_THREAD_START_ADDR_1: begin
            NextState = GET_THREAD_START_ADDR_2;
            NextPC    = ProgMemoryOut;
        end

        GET_THREAD_START_ADDR_2: NextState = CHOOSE_OPP;
/////////////////////////////////Operation Selection/////////////////////////////////
        CHOOSE_OPP: begin
            case (ProgMemoryOut[3:0])
                4'h0:   NextState = READ_FROM_MEM_TO_A;
                4'h1:   NextState = READ_FROM_MEM_TO_B;
                4'h2:   NextState = WRITE_TO_MEM_FROM_A;
                4'h3:   NextState = WRITE_TO_MEM_FROM_B;
                4'h4:   NextState = DO_MATHS_OPP_SAVE_IN_A;
                4'h5:   NextState = DO_MATHS_OPP_SAVE_IN_B;
                4'h6:   NextState = IF_A_EQUALITY_B_GOTO;
                4'h7:   NextState = GOTO;
                4'h8:   NextState = GOTO_IDLE;
                4'h9:   NextState = FUNCTION_START;
                4'hA:   NextState = RETURN;
                4'hB:   NextState = DE_REFERENCE_A;
                4'hC:   NextState = DE_REFERENCE_B;
                4'hD:   begin
                    case(ProgMemoryOut[7:4]) 
                        4'b0: NextState = READ_FROM_IMM_TO_A;
                        4'b1: NextState = READ_FROM_IMM_TO_B;        
                        default:NextState = CurrState;
                    endcase
                end
                default:NextState = CurrState;
            endcase
            NextPCOffset = 1'h1;
        end
/////////////////////////////////Read from  Data Bus/////////////////////////////////
        READ_FROM_MEM_TO_A:begin
            NextState     = READ_FROM_MEM_0;
            NextRegSelect = 1'b0;
        end

        READ_FROM_MEM_TO_B:begin
            NextState     = READ_FROM_MEM_0;
            NextRegSelect = 1'b1;
        end

        READ_FROM_MEM_0: begin
            NextState   = READ_FROM_MEM_1;
            NextBusAddr = ProgMemoryOut;
        end

        READ_FROM_MEM_1: begin
            NextState = READ_FROM_MEM_2;
            NextPC    = CurrPC + 2;
        end

        READ_FROM_MEM_2: begin
            NextState = CHOOSE_OPP;
            if(!CurrRegSelect) 
                NextRegA = BusDataIn;
            else 
                NextRegB = BusDataIn;
        end
//////////////////////////////////Write to Data Bus//////////////////////////////////
        WRITE_TO_MEM_FROM_A:begin
            NextState     = WRITE_TO_MEM_0;
            NextRegSelect = 1'b0;
            NextPC        = CurrPC + 2;
        end

        WRITE_TO_MEM_FROM_B:begin
            NextState     = WRITE_TO_MEM_0;
            NextRegSelect = 1'b1;
            NextPC        = CurrPC + 2;
        end

        WRITE_TO_MEM_0: begin
            NextState        = WRITE_TO_MEM_1;
            NextBusAddr      = ProgMemoryOut;
            NextBusDataOutWE = 1'b1;
            if(!NextRegSelect) 
                NextBusDataOut = CurrRegA;
            else 
                NextBusDataOut = CurrRegB;           
        end    
        
        WRITE_TO_MEM_1: NextState = CHOOSE_OPP;
////////////////////////////Arithmetic & Logic Operations////////////////////////////
        DO_MATHS_OPP_SAVE_IN_A: begin
            NextState = DO_MATHS_OPP_0;
            NextRegA  = AluOut;
            NextPC    = CurrPC + 1;
        end

        DO_MATHS_OPP_SAVE_IN_B: begin
            NextState = DO_MATHS_OPP_0;
            NextRegB  = AluOut;
            NextPC    = CurrPC + 1;
        end

        DO_MATHS_OPP_0: NextState = CHOOSE_OPP;        
/////////////////////////////////Conditional  Branch/////////////////////////////////  
        IF_A_EQUALITY_B_GOTO: 
            if(AluOut) 
                NextState = IF_A_EQUALITY_B_GOTO_0;
            else begin       
                NextPC    = CurrPC + 2; 
                NextState = IF_A_EQUALITY_B_GOTO_1;
            end
        
        IF_A_EQUALITY_B_GOTO_0: begin
            NextState = IF_A_EQUALITY_B_GOTO_1;
            NextPC = ProgMemoryOut;        
        end
        
        IF_A_EQUALITY_B_GOTO_1: NextState = CHOOSE_OPP;
////////////////////////////////Unconditional  Branch////////////////////////////////
        GOTO: begin
            NextState = GOTO_0;
        end
        
        GOTO_0: begin
            NextPC    = ProgMemoryOut;
            NextState = GOTO_1;
        end
        
        GOTO_1: NextState = CHOOSE_OPP;
//////////////////////////////////Go  to Idle State//////////////////////////////////
        GOTO_IDLE: NextState = IDLE;
////////////////////////////////////Call Function////////////////////////////////////
        FUNCTION_START: begin
            NextProgContext[CurrStackTop] = CurrPC + 2;
            NextStackTop                  = CurrStackTop+1;
            NextState                     = FUNCTION_START_0;          
        end
        
        FUNCTION_START_0: begin
            NextPC    = ProgMemoryOut;
            NextState = FUNCTION_START_1;
        end
        
        FUNCTION_START_1: NextState = CHOOSE_OPP;
////////////////////////////////////////Return///////////////////////////////////////
        RETURN: begin
            NextPC       = CurrProgContext[CurrStackTop-1];
            NextStackTop = CurrStackTop-1;
            NextState    = RETURN_0;
        end
        
        RETURN_0: NextState = CHOOSE_OPP;
////////////////////////////////////De-reference///////////////////////////////////// 
        DE_REFERENCE_A: begin
            NextState     = DE_REFERENCE_0;
            NextBusAddr   = CurrRegA;
            NextRegSelect = 1'b0;
        end

        DE_REFERENCE_B: begin
            NextState     = DE_REFERENCE_0;
            NextBusAddr   = CurrRegB;
            NextRegSelect = 1'b1;
        end

        DE_REFERENCE_0: begin
            NextState = DE_REFERENCE_1;       
            NextPC    = CurrPC + 1;
        end

        DE_REFERENCE_1: begin
            NextState = CHOOSE_OPP;
            if(!CurrRegSelect) 
                NextRegA = BusDataIn;
            else 
                NextRegB = BusDataIn;        
        end
////////////////////////////////////Immdiate Data///////////////////////////////////// 
        READ_FROM_IMM_TO_A: begin
            NextState     = READ_FROM_IMM_0;
            NextRegSelect = 1'b0;
        end

        READ_FROM_IMM_TO_B: begin
            NextState     = READ_FROM_IMM_0;
            NextRegSelect = 1'b1;
        end
        
        READ_FROM_IMM_0:begin
            NextState = READ_FROM_IMM_1;
            NextPC    = CurrPC + 2;
            if(!CurrRegSelect) 
                NextRegA = ProgMemoryOut;
            else 
                NextRegB = ProgMemoryOut;                      
        end
        
        READ_FROM_IMM_1:begin
            NextState     = CHOOSE_OPP;                  
        end
/////////////////////////////////////////////////////////////////////////////////////       
    endcase
 end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Output(or inout) ports
assign BUS_INTERRUPTS_ACK = CurrInterruptAck;
assign BUS_WE             = CurrBusDataOutWE;
assign BUS_DATA           = CurrBusDataOutWE? CurrBusDataOut : 8'hZZ;
assign BUS_ADDR           = CurrBusAddr;
assign ROM_ADDRESS        = CurrPC + CurrPCOffset;
// Input(or inout) ports
assign BusDataIn          = BUS_DATA;
assign ProgMemoryOut      = ROM_DATA;

endmodule

