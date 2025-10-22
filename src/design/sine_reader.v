module sine_reader(
    input clk,
    input reset,
    input [19:0] step_size,
    input generate_next,

    output sample_ready,
    output wire [15:0] sample
);

    wire [9:0] raw_addr;

    reg [21:0] next_addr;
    wire [21:0] current_addr;

    reg [15:0] modified_sample;

    always @(*) begin
        if (generate_next) begin
            next_addr = current_addr + {2'b00, step_size}; // align step size to 22 bits
        end 
    end

    // store current address
    dffr #(22) sine_addr (
        .clk(clk),
        .r(reset),
        .en(generate_next),
        .d(next_addr),
        .q(current_addr)
    );  

    assign raw_addr = current_addr[19:10]; 
    sine_rom sin (.clk(clk), .addr(raw_addr), .dout(modified_sample)); 

    // flip sample across axes if needed
    always @(*) begin
        case (current_addr[21:20])
            2'b00: modified_sample = modified_sample;          // 0 to 90 degrees
            2'b01: modified_sample = 16'h7FFF - modified_sample; // 90 to 180 degrees
            2'b10: modified_sample = 0 - modified_sample;         // 180 to 270 degrees
            2'b11: modified_sample = (0 - 16'h7FFF) + modified_sample; // 270 to 360 degrees
            default: modified_sample = modified_sample;
        endcase
    end

    assign sample = modified_sample;

    // todo: signal if sample is ready

endmodule
