module note_player_tb();

    reg clk, reset, play_enable, generate_next_sample;
    reg [5:0] note_to_load;
    reg [5:0] duration_to_load;
    reg load_new_note;
    wire done_with_note, new_sample_ready, beat;
    wire [15:0] sample_out;

    note_player np(
        .clk(clk),
        .reset(reset),

        .play_enable(play_enable),
        .note_to_load(note_to_load),
        .duration_to_load(duration_to_load),
        .load_new_note(load_new_note),
        .done_with_note(done_with_note),

        .beat(beat),
        .generate_next_sample(generate_next_sample),
        .sample_out(sample_out),
        .new_sample_ready(new_sample_ready)
    );

    beat_generator #(.WIDTH(17), .STOP(1500)) beat_generator(
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .beat(beat)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end
    
    reg exp_done;
    reg exp_ready;

   // Tests
   initial begin
        reset = 1'b1;
        play_enable = 1'b0;
        generate_next_sample = 1'b0;
        load_new_note = 1'b0;
        note_to_load = 6'd0;
        duration_to_load = 6'd0;

        #10;
        #10;
        #10;
        #10;
        reset = 1'b0;
        #10;
        
        $display("Test 1: Load Note 35, Duration 8");
        note_to_load = 6'd35;
        duration_to_load = 6'd8;
        load_new_note = 1'b1;
        #10;
        load_new_note = 1'b0;
        #10;

        exp_done = 1'b0;
        $display("First check: After loading note");
        $display("Expected done_with_note: %b", exp_done);
        $display("Actual done_with_note: %b", done_with_note);
        if (done_with_note == exp_done)
            $display("PASS");
        else
            $display("FAIL");
        
        play_enable = 1'b1;
        #10;
        $display("Second check: Generate first sample");
        generate_next_sample = 1'b1;
        #10;
        generate_next_sample = 1'b0;
        #10;
   
        exp_ready = 1'b1;
        $display("After 1 cycle (cycle 2 from pulse):");
        $display("Expected new_sample_ready: %b", exp_ready);
        $display("Actual new_sample_ready: %b", new_sample_ready);
        if (new_sample_ready == exp_ready)
            $display("PASS");
        else
            $display("FAIL");
        
        #10;
        exp_ready = 1'b0;
        $display("After 2 cycles (cycle 3 from pulse):");
        $display("Expected new_sample_ready: %b", exp_ready);
        $display("Actual new_sample_ready:   %b", new_sample_ready);
        $display("Sample value: %h", sample_out);
        if (new_sample_ready == exp_ready)
            $display("PASS");
        else
            $display("FAIL");
        
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        
        generate_next_sample = 1'b1;
        #10;
        generate_next_sample = 1'b0;
        #10;
        #10;
        $display("Third check: Second sample");
        $display("Sample value: %h", sample_out);
        $display("Should be non-zero for note 35");
        if (sample_out != 16'h0000)
            $display("PASS");
        else
            $display("FAIL");
        
        #10;
        #10;
        #10;
        #10;
        #10;
        
        // Generate third sample
        generate_next_sample = 1'b1;
        #10;
        generate_next_sample = 1'b0;
        #10;
        #10;
        #10;
        #10;

        $display("Test 2: Load Note 50, Duration 56");
        
        note_to_load = 6'd50;
        duration_to_load = 6'd56;
        load_new_note = 1'b1;
        #10;
        load_new_note = 1'b0;
        #10;
        
        $display("Second check: After loading new note");
        $display("Actual note: %d", np.current_note);
        if (np.current_note == 6'd50)
            $display("PASS");
        else
            $display("FAIL");
        
        // Generate samples
        generate_next_sample = 1'b1;
        #10;
        generate_next_sample = 1'b0;
        #10;
        #10;
        #10;
        #10;
        #10;
        
        generate_next_sample = 1'b1;
        #10;
        generate_next_sample = 1'b0;
        #10;
        #10;
        
        $display("Second check: Sample for note 50:");
        $display("Sample value: %h", sample_out);
        if (sample_out != 16'h0000)
            $display("PAS");
        else
            $display("FAIL");
        
        #10;
        #10;
        #10;
        
        $display("Test 3: Pause");
        
        $display("First check: Pausing");
        play_enable = 1'b0;
        #10;
        #10;
        
        // Generate sample while paused
        generate_next_sample = 1'b1;
        #10;
        generate_next_sample = 1'b0;
        #10;
        #10;
        
        $display("Paused, samples still generated");
        $display("Sample value: %h", sample_out);
        if (sample_out != 16'h0000)
            $display("PASS");
        else
            $display("FAIL");
        
        #10;
        #10;
        
        $display("Second check: Resume");
        play_enable = 1'b1;
        #10;
        
        generate_next_sample = 1'b1;
        #10;
        generate_next_sample = 1'b0;
        #10;
        #10;
        
        $display("After resume");
        $display("Sample value: %h", sample_out);
        if (sample_out != 16'h0000)
            $display("PASS");
        else
            $display("FAIL");
        
        #10;

        $display("Test 4: Rest Note 0");
        note_to_load = 6'd0;
        duration_to_load = 6'd10;
        load_new_note = 1'b1;
        #10;
        load_new_note = 1'b0;
        #10;
        
        generate_next_sample = 1'b1;
        #10;
        generate_next_sample = 1'b0;
        #10;
        #10;
        
        $display("First check: Rest note:");
        $display("Sample value: %h", sample_out);
        
        #100;
        
        $display("Test 5: Done Signal");    
        note_to_load = 6'd40;
        duration_to_load = 6'd1;
        load_new_note = 1'b1;
        #10;
        load_new_note = 1'b0;
        #10;
        
        $display("First check: Initially not done:");
        exp_done = 1'b0;
        $display("Expected done_with_note: %b", exp_done);
        $display("Actual done_with_note:   %b", done_with_note);
        if (done_with_note == exp_done)
            $display("PASS");
        else
            $display("FAIL");
        
        $display("Second check: Wait for beat");
        $display("Duration: 1");
        $display("Time remaining: %d", np.time_remaining);
        
        #20000;
        
        $display("After wait:");
        $display("Time remaining: %d", np.time_remaining);
        $display("Done: %b", done_with_note);
        if (done_with_note == 1'b1 && np.time_remaining == 6'd0)
            $display("PASS");
        else
            $display("FAIL");
        
        #100;

        $display("All tests done!");
    end
    
endmodule
