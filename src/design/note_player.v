module note_player(
    input clk,
    input reset,
    input play_enable,  // When high we play, when low we don't.
    input [5:0] note_to_load,  // The note to play
    input [5:0] duration_to_load,  // The duration of the note to play
    input load_new_note,  // Tells us when we have a new note to load
    output done_with_note,  // When we are done with the note this stays high.
    input beat,  // This is our 1/48th second beat
    input generate_next_sample,  // Tells us when the codec wants a new sample
    output [15:0] sample_out,  // Our sample output
    output new_sample_ready  // Tells the codec when we've got a sample
);
    wire [19:0] step_size;
    wire [5:0] current_note;
    wire [5:0] initial_duration;
    wire [5:0] time_remaining;
    wire [5:0] next_time_remaining_val;
    wire [15:0] sine_sample;
    wire sine_sample_ready;
    
    // storing a note
    dffre #(6) note_reg (.clk(clk), .r(reset), .en(load_new_note), .d(note_to_load), .q(current_note));
        
    // storing song duration
    dffre #(6) duration_reg (.clk(clk), .r(reset), .en(load_new_note), .d(duration_to_load), .q(initial_duration));
    
    // calculating time remaining for the note
    assign next_time_remaining_val = (time_remaining == 6'd0) ? 6'd0 : time_remaining - 6'd1;
    wire counter_enable = beat & play_enable & (time_remaining > 6'd0);
    wire [5:0] counter_data_in = load_new_note ? duration_to_load : next_time_remaining_val;
        
    // duration counter
    dffre #(6) duration_counter (.clk(clk), .r(reset), .en(counter_enable | load_new_note), .d(counter_data_in), .q(time_remaining));
    
    // looking up the note's step size in a frequency rom
    frequency_rom freq_rom (.clk(clk), .addr(current_note), .dout(step_size));
    
    // feeding the step size to the sine reader
    sine_reader sine_gen (.clk(clk), .reset(reset), .step_size(step_size), .generate_next(generate_next_sample), .sample_ready(sine_sample_ready), .sample(sine_sample));
    
    assign sample_out = sine_sample; 
    assign new_sample_ready = sine_sample_ready; 
    assign done_with_note = (time_remaining == 6'd0);
    
endmodule
