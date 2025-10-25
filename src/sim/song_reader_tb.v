module song_reader_tb();

    reg clk, reset, play, note_done;
    reg [1:0] song;
    wire [5:0] note;
    wire [5:0] duration;
    wire song_done, new_note;

    song_reader dut(
        .clk(clk),
        .reset(reset),
        .play(play),
        .song(song),
        .song_done(song_done),
        .note(note),
        .duration(duration),
        .new_note(new_note),
        .note_done(note_done)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end
   
    reg expected_song;
    reg expected_note;

    // Tests
    initial begin
        play = 1'b0;
        note_done = 1'b0;
        song = 2'd0;
        
        #50;
        
        $display("Test 1: Start playing song 0");
        song = 2'd0;
        play = 1'b1;
        #10;
        #10;
        #10;
        
        expected_song = 1'b0;
        expected_note = 1'b0;
        $display("After starting play:");
        $display("Note: %d, Duration: %d", note, duration);
        $display("Expected song_done=%b, Actual song_done=%b", expected_song, song_done);
        $display("Expected new_note=%b, Actual new_note=%b", expected_note, new_note);
        if (song_done == expected_song && new_note == expected_note)
            $display("PASS");
        else
            $display("FAIL");
        
        #20;
        
        // Test #2: Advance to next note
        $display("Test 2: Advance to next note");
        note_done = 1'b1;
        #10;
 
        expected_song = 1'b0;
        expected_note = 1'b1;
        $display("After note_done pulse:");
        $display("Counter: %d", dut.note_counter);
        $display("Note: %d, Duration: %d", note, duration);
        $display("Expected song_done=%b, Actual song_done=%b", expected_song, song_done);
        $display("Expected new_note=%b, Actual new_note=%b", expected_note, new_note);
        if (song_done == expected_song && new_note == expected_note)
            $display("PASS");
        else
            $display("FAIL");
        
        note_done = 1'b0;
        #10;
        #10;
        
        #20;
        
        // Test #3: Pause in middle of song
        $display("Test 3: Pause during playback");
        play = 1'b0;
        #10;
        
        // Try to advance note while paused
        note_done = 1'b1;
        #10;
        note_done = 1'b0;
        #10;
        
        expected_note = 1'b0;
        $display("After pausing (note_done pulsed while paused):");
        $display("Counter: %d (should not change)", dut.note_counter);
        $display("Expected new_note=%b, Actual new_note=%b", expected_note, new_note);
        if (new_note == expected_note)
            $display("PASS");
        else
            $display("FAIL");
        
        #20;
        
        // Test #4: Resume from pause
        $display("Test 4: Resume from pause");
        play = 1'b1;
        #10;
        
        note_done = 1'b1;
        #10;
        
        expected_note = 1'b1;
        $display("After resuming and advancing:");
        $display("Counter: %d", dut.note_counter);
        $display("Expected new_note=%b, Actual new_note=%b", expected_note, new_note);
        if (new_note == expected_note)
            $display("PASS");
        else
            $display("FAIL");
        
        note_done = 1'b0;
        #10;
        #10;
        
        #20;
        
        // Test #5: Reach end of song
        
        // Test #5: Reach end of song
        $display("Test 5: Reach end of song");

        // Fast forward to note 32 - need 28 more pulses (currently at 3)
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;
        note_done = 1'b1; #10; note_done = 1'b0; #10;

        $display("Current counter: %d (should be 31)", dut.note_counter);

        // Advance to counter 32
        note_done = 1'b1;
        #10;
        note_done = 1'b0;
        #10;
        #10;

        $display("After advancing: Counter: %d (now playing note 32)", dut.note_counter);

        // Finish playing note 32 - pulse note_done one more time
        note_done = 1'b1;
        #10;
        note_done = 1'b0;
        #10;
        #10;

        expected_song = 1'b1;
        expected_note = 1'b0;
        $display("After finishing note 32:");
        $display("Counter: %d", dut.note_counter);
        $display("Expected song_done=%b, Actual song_done=%b", expected_song, song_done);
        $display("Expected new_note=%b, Actual new_note=%b", expected_note, new_note);
        if (song_done == expected_song && new_note == expected_note)
            $display("PASS");
        else
            $display("FAIL");

        // Try to advance after song is done
        #20;
        note_done = 1'b1;
        #10;
        note_done = 1'b0;
        #10;

        expected_song = 1'b1;
        $display("After trying to advance past end:");
        $display("Counter: %d (should stay at 32)", dut.note_counter);
        $display("Expected song_done=%b, Actual song_done=%b", expected_song, song_done);
        if (song_done == expected_song)
            $display("PASS");
        else
            $display("FAIL");
    end
endmodule
