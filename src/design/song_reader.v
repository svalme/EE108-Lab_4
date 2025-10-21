module song_reader(
    input clk,
    input reset,
    input play,
    input [1:0] song,
    input note_done,
    output song_done,
    output [5:0] note,
    output [5:0] duration,
    output new_note
);     
    // Internal wires and regs
    wire [5:0] note_counter;
    wire done;
    reg [5:0] next_note_counter;
    reg next_done;
    
    wire [6:0] rom_addr = {song, note_counter};
    wire [11:0] rom_data;
    assign note = rom_data[11:6];
    assign duration = rom_data[5:0];
    
    song_rom rom_instance (.clk(clk), .addr(rom_addr), .dout(rom_data));
    dffr #(.WIDTH(6)) counter_dff (.clk(clk), .r(reset), .d(next_note_counter), .q(note_counter));
    dffr done_dff (.clk(clk), .r(reset), .d(next_done), .q(done));
    
    always @(*) begin
        next_note_counter = note_counter;
        next_done = done;
        
        if (done || !play) begin
            next_note_counter = note_counter;
            next_done = done;
        end else if (note_counter == 6'd0) begin
            next_note_counter = 6'd1;
            next_done = 0;
        end else if (note_done) begin
            // end of song
            if (note_counter == 6'd32) begin
                next_note_counter = note_counter;
                next_done = 1'b1;
            end else begin
                next_note_counter = note_counter + 1;
                next_done = 0;
            end    
        end
    end
    
    assign song_done = done;
    assign new_note = (play && note_done && !done && note_counter > 0 && note_counter < 6'd32);
endmodule
