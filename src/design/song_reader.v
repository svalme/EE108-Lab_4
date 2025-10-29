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
    wire [5:0] note_counter;
    wire done;
    reg [5:0] next_note_counter;
    reg next_done;
    
    wire [6:0] rom_addr = {song, note_counter[4:0]};
    wire [11:0] rom_data;
    assign note = rom_data[11:6];
    assign duration = rom_data[5:0];
    
    song_rom rom_instance (.clk(clk), .addr(rom_addr), .dout(rom_data));
    dffr #(.WIDTH(6)) counter_dff (.clk(clk), .r(reset), .d(next_note_counter), .q(note_counter));
    dffr done_dff (.clk(clk), .r(reset), .d(next_done), .q(done));
    
    always @(*) begin
    case (play)
        1'b0: begin
            next_note_counter = note_counter;
            next_done = done;
        end
        1'b1: begin
            next_note_counter =
            	done ? note_counter :                                  
                (note_counter == 6'd0) ? 6'd1 :                        
                (note_done && note_counter == 6'd32) ? note_counter :  
                (note_done) ? note_counter + 1 :                       
                note_counter;                                          
            next_done =
                done ? done :                                          
                (note_counter == 6'd0) ? 1'b0 :                        
                (note_done && note_counter == 6'd32) ? 1'b1 :          
                1'b0;                                                  
        end
        default: begin
            next_note_counter = note_counter;
            next_done = done;
        end
    endcase
end
    
    assign song_done = done;
    assign new_note = (play && !done && ((note_counter == 6'd0) || (note_done && note_counter > 6'd0 && note_counter <= 6'd32)));
endmodule
