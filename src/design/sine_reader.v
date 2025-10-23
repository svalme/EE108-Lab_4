module sine_reader(
    input clk,
    input reset,
    input [19:0] step_size,
    input generate_next,

    output sample_ready,
    output wire [15:0] sample
);

    wire [9:0] raw_addr;
    wire [9:0] rom_addr;    

    reg [21:0] next_addr;
    wire [21:0] current_addr;

    wire [1:0] quadrant;

    wire [15:0] rom_sample;
    reg [15:0] modified_sample;

    always @(*) begin
        next_addr = current_addr;
        if (generate_next) 
            next_addr = current_addr + {2'b00, step_size}; // align step size to 22 bits
    end

    // store current address
    dffre #(22) sine_addr (.clk(clk), .r(reset), .en(generate_next), .d(next_addr), .q(current_addr));  

    assign quadrant = current_addr[21:20];
    assign raw_addr = current_addr[19:10]; 

    // determine ROM address based on quadrant; quadrant 1: 01, quadrant 3: 11 need address inversion
    assign rom_addr = ((quadrant == 2'b01) || (quadrant == 2'b11)) ? ~raw_addr : raw_addr;

    // retrieve sample from sine ROM
    sine_rom sin (.clk(clk), .addr(rom_addr), .dout(rom_sample)); 

    
    always @(*) begin
        // flip the sine wave vertically; adjusts for negative y values
        case (current_addr[21:20])
            2'b10, 2'b11: modified_sample = 0 - rom_sample;  // Q2: 10, Q3: 11 → negative half
            default:      modified_sample = rom_sample;       // Q0: 00, Q1: 01 → positive half
        endcase
    end


    assign sample = modified_sample;

    // todo: signal if sample is ready

endmodule
