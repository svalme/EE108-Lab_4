`timescale 1ns/1ps
module sine_reader_tb();

    reg clk, reset, generate_next;
    reg [19:0] step_size;
    wire sample_ready;
    wire [15:0] sample;
    sine_reader reader(
        .clk(clk),
        .reset(reset),
        .step_size(step_size),
        .generate_next(generate_next),
        .sample_ready(sample_ready),
        .sample(sample)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end

    // Tests
    reg exp_sample_ready;
    initial begin

        generate_next = 1'b0;
        step_size = 20'd1000;

        #30; // wait one cycle

        // Test #1
        generate_next = 1'b1;
        #10;  // 1 clock high
        generate_next = 1'b0;
        #10;  // 2-cycle wait for output
        
        exp_sample_ready = 1'b1;
        $display("[%0t] step_size=%0d sample_ready=%b sample=%0d", $time, step_size, sample_ready, sample);
        $display("Expected sample_ready=%b, Actual sample_ready=%b", exp_sample_ready, sample_ready);
        if (sample_ready == exp_sample_ready)
            $display("PASS");
        else
            $display("FAIL");

        // Wait a few idle cycles before next pulse
        #20;

        // Test #2 (new step size)
        step_size = 20'd1500;
        generate_next = 1'b1;
        #10;
        generate_next = 1'b0;
        #10; // 2-cycle wait for output
        
        exp_sample_ready = 1'b1;
        $display("[%0t] step_size=%0d sample_ready=%b sample=%0d", $time, step_size, sample_ready, sample);
        $display("Expected sample_ready=%b, Actual sample_ready=%b", exp_sample_ready, sample_ready);
        if (sample_ready == exp_sample_ready)
            $display("PASS");
        else
            $display("FAIL");

        #20; 

        // Test #3 (new step size)
        step_size = 20'd2000;
        generate_next = 1'b1;
        #10;
        generate_next = 1'b0;
        #10; // 2-cycle wait for output
        
        exp_sample_ready = 1'b1;
        $display("[%0t] step_size=%0d sample_ready=%b sample=%0d", $time, step_size, sample_ready, sample);
        $display("Expected sample_ready=%b, Actual sample_ready=%b", exp_sample_ready, sample_ready);
        if (sample_ready == exp_sample_ready)
            $display("PASS");
        else
            $display("FAIL");

        #20;

        // Test #4 (new step size)
        step_size = 20'd2500;
        generate_next = 1'b1;
        #10;
        generate_next = 1'b0;
        #10;
        
        exp_sample_ready = 1'b1;
        $display("[%0t] step_size=%0d sample_ready=%b sample=%0d", $time, step_size, sample_ready, sample);
        $display("Expected sample_ready=%b, Actual sample_ready=%b", exp_sample_ready, sample_ready);
        if (sample_ready == exp_sample_ready)
            $display("PASS");
        else
            $display("FAIL");

    end

endmodule


