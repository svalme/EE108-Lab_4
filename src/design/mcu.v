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
    wire [1:0] curr_song;
    reg [1:0] next_song;
    wire curr_play;
    reg reset_play;
    reg next_play;
    
    dffr #(.WIDTH(2)) song_instance(.clk(clk), .r(reset), .d(next_song), .q(curr_song));
    dffr play_instance(.clk(clk), .r(reset), .d(next_play), .q(curr_play));
    
    always @(*) begin
        casex ({song_done, next_button, play_button})
            3'bx1x: begin // if next_button = 1 we skip to next song
                next_song = curr_song + 1;
                next_play = 0;
                reset_play = 1;
            end
            3'b10x: begin // if song_done = 1 then next_button = 0
                next_song = curr_song + 1;
                next_play = 0;
                reset_play = 1;
            end
            3'b001: begin //if play_button = 1, no next/done
                next_song = curr_song;
                next_play = ~curr_play;
                reset_play = 0;
            end
            default: begin // if nothing is pressed keep state
                next_song = curr_song;
                next_play = curr_play;
                reset_play = 0;
            end
        endcase
    end
    
    // outputs
    assign play = curr_play;
    assign song = curr_song;
    assign reset_player = reset_play;
    
endmodule
