module mcu(
    input clk,
    input reset,
    input play_button,
    input next_button,
    output play,
    output reset_player,
    output [1:0] song,
    input song_done
);

    // Implementation goes here!
    wire [1:0] curr_song;
    reg [1:0] next_song;
    wire curr_play;
    reg reset_play;
    reg next_play;
    
    dffr #(.WIDTH(2)) song_instance(.clk(clk), .r(reset), .d(next_song), .q(curr_song));
    dffr play_instance(.clk(clk), .r(reset), .d(next_play), .q(curr_play));
    
    always @(*) begin
        if (song_done || next_button == 1) begin //playing the next song
            next_song = curr_song + 1;
            next_play = 0;
            reset_play = 1;
        end
        if (next_button == 0 && play_button == 1 && song_done == 0) begin //pausing and continuing the song
            next_song = curr_song;
            next_play = ~curr_play;
            reset_play = 0;
        end
        if (song_done == 0 && next_button == 0 && play_button == 0) begin //nothing happens - song keeps playing
            next_song = curr_song;
            next_play = curr_play;
            reset_play = 0;
        end
    end
    
    //set outputs according to the situation
    assign play = curr_play;
    assign song = curr_song;
    assign reset_player = reset_play;
    
endmodule
