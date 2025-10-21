module mcu_tb();
    reg clk, reset, play_button, next_button, song_done;
    wire play, reset_player;
    wire [1:0] song;

    mcu dut(
        .clk(clk),
        .reset(reset),
        .play_button(play_button),
        .next_button(next_button),
        .play(play),
        .reset_player(reset_player),
        .song(song),
        .song_done(song_done)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end
    
    reg [3:0] errors;
    reg [1:0] expected_song;
    reg expected_play;
    reg expected_reset_player;
        
    // Tests
    initial begin
        errors = 4'd0;
        //initializing inputs of module
        play_button = 0;
        next_button = 0;
        song_done = 0;
        #25;
        
        //Test 1
        $display("Test 1: Checking correct initial state");
        expected_song = 2'd0;
        expected_play = 1'b0;
        expected_reset_player = 1'b0;
        $display("Expected: song = 0, play = 0, reset_player = 0");
        #10;
        $display("Output: song=%d, play=%b, reset_player=%b", song, play, reset_player);
        if (song !== expected_song || play !== expected_play || reset_player !== expected_reset_player) begin
            $display("FAIL: Test 1\n");
            errors = errors + 4'd1;
        end else begin
            $display("PASS: Test 1\n");
        end
        
        //Test 2
        $display("Test 2: press play button to start playing a song");
        play_button = 1;
        #10;
        play_button = 0;
        expected_song = 2'd0;
        expected_play = 1'b1;
        expected_reset_player = 1'b0;
        $display("Expected: song = 0, play = 1, reset_player = 0");
        #10;
        $display("Output: song=%d, play=%b, reset_player=%b", song, play, reset_player);
        if (song !== expected_song || play !== expected_play || reset_player !== expected_reset_player) begin
            $display("FAIL: Test 2\n");
            errors = errors + 4'd1;
        end else begin
            $display("PASS: Test 2\n");
        end
        
        //Test 3
        $display("Test 3: press play button again to pause the song");
        play_button = 1;
        #10;
        play_button = 0;
        expected_song = 2'd0;
        expected_play = 1'b0;
        expected_reset_player = 1'b0;
        $display("Expected: song = 0, play = 0, reset_player = 0");
        #10;
        $display("Output: song=%d, play=%b, reset_player=%b", song, play, reset_player);
        if (song !== expected_song || play !== expected_play || reset_player !== expected_reset_player) begin
            $display("FAIL: Test 3\n");
            errors = errors + 4'd1;
        end else begin
            $display("PASS: Test 3\n");
        end
        
        //Test 4
        $display("Test 4: press play button again to un-pause the song");
        play_button = 1;
        #10;
        play_button = 0;
        expected_song = 2'd0;
        expected_play = 1'b1;
        expected_reset_player = 1'b0;
        $display("Expected: song = 0, play = 1, reset_player = 0");
        #10;
        $display("Output: song=%d, play=%b, reset_player=%b", song, play, reset_player);
        if (song !== expected_song || play !== expected_play || reset_player !== expected_reset_player) begin
            $display("FAIL: Test 4\n");
            errors = errors + 4'd1;
        end else begin
            $display("PASS: Test 4\n");
        end
        
        //Test 5
        $display("Test 5: press next button to play the next song");
        next_button = 1;
        #10;
        next_button = 0;
        expected_song = 2'd1;
        expected_play = 1'b0;
        expected_reset_player = 1'b0;
        $display("Expected: song = 1, play = 0, reset_player = 0");
        #10;
        $display("Output: song=%d, play=%b, reset_player=%b", song, play, reset_player);
        if (song !== expected_song || play !== expected_play || reset_player !== expected_reset_player) begin
            $display("FAIL: Test 5\n");
            errors = errors + 4'd1;
        end else begin
            $display("PASS: Test 5\n");
        end
    
        //Test 6
        $display("Test 6: keep pressing next until getting to song 0 again");
        next_button = 1;
        #10;
        next_button = 0;
        #10;
        $display("After 1st next: song=%d (should be 2)", song);
        next_button = 1;
        #10;
        next_button = 0;
        #10;
        $display("After 2nd next: song=%d (should be 3)", song);
        next_button = 1;
        #10;
        next_button = 0;
        expected_song = 2'd0;
        expected_play = 1'b0;
        expected_reset_player = 1'b0;
        $display("Expected: song = 0 (wraparound), play = 0, reset_player = 0");
        #10;
        $display("Output: song=%d, play=%b, reset_player=%b", song, play, reset_player);
        if (song !== expected_song || play !== expected_play || reset_player !== expected_reset_player) begin
            $display("FAIL: Test 6\n");
            errors = errors + 4'd1;
        end else begin
            $display("PASS: Test 6\n");
        end
        
        //Test 7
        $display("Test 7: test song completion (done signal)");
        play_button = 1;
        #10;
        play_button = 0;
        #20;
        $display("Currently playing song %d", song);
        $display("Now triggering song_done signal");
        song_done = 1;
        #10;
        song_done = 0;
        expected_song = 2'd1;
        expected_play = 1'b0;
        expected_reset_player = 1'b0;
        $display("Expected: song = 1, play = 0, reset_player = 0");
        #10;
        $display("Output: song=%d, play=%b, reset_player=%b", song, play, reset_player);
        if (song !== expected_song || play !== expected_play || reset_player !== expected_reset_player) begin
            $display("FAIL: Test 7\n");
            errors = errors + 4'd1;
        end else begin
            $display("PASS: Test 7\n");
        end
    
        
        //Test 8
        $display("Test 8: full cycle through all songs");
        next_button = 1;
        #10;
        next_button = 0;
        #10;
        $display("Song %d", song);
        next_button = 1;
        #10;
        next_button = 0;
        #10;
        $display("Song %d", song);
        next_button = 1;
        #10;
        next_button = 0;
        #10;
        $display("Song %d", song);
        next_button = 1;
        #10;
        next_button = 0;
        expected_song = 2'd1;
        expected_play = 1'b0;
        expected_reset_player = 1'b0;
        $display("Expected: back to song 1, play = 0, reset_player = 0");
        #10;
        $display("Output: song=%d, play=%b, reset_player=%b", song, play, reset_player);
        if (song !== expected_song || play !== expected_play || reset_player !== expected_reset_player) begin
            $display("FAIL: Test 8\n");
            errors = errors + 4'd1;
        end else begin
            $display("PASS: Test 8\n");
        end
        
        if (errors == 4'd0) begin
            $display("Yay!! All tests passed :D");
        end else begin
            $display("%0d test(s) failed :((", errors);
        end
        
    end
endmodule
