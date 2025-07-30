`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench_edge_detector_debounced
// Project Name: Step Generator
// Target Devices: Basys 3 (Artix 7)
// Description: Simulates a noisy external clock signal as 250kHz with bounce/glitch 
//              behavior for each 4us clock cycle. The testbench verifies that the 
//              module outputs a single clean, one cycle pulse for each valid rising  
//              edge after debounce.
//
//              Includes two bounce simulation modes:
//              - Pseudorandom toggling during the transitions (default)
//              - Exponentially decaying toggles (optional)
//
//  System clock is 100MHz (10ns)
// 
// Dependencies: edge_detector_debounced.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// - Bounce period: 0-2667 ns
// - Designed for waveform-based verification - noisy signal, clean narrow high pulse
// - Occasional glitches between pulses in the idle state
//////////////////////////////////////////////////////////////////////////////////


module testbench_edge_detector_debounced( );

    // DUT input
    reg clk, rst, noisy_in;
   
    // DUT output
    wire tick;
    
    // declare other variables
    integer i;
    
    // DUT instantiation
    edge_detector_debounced #(.STABLE_COUNT(3)) DUT_EDGE_DET_DEBOUNCED (
        .clk(clk),
        .rst(rst),
        .noisy_in(noisy_in),
        .tick(tick)
    );
    
    // Clock generation
    initial
        clk = 0;
    always
        #5 clk = ~clk; // period = 10ns
        
        
    // task simulating a rising edge with bounce
    task noisy_rising_edge;
        begin
            $display("\n[Noisy Rising Edge Test]");
            
            noisy_in = 0;
            #(10*8); // 8 clock periods
            
            // bounce for half the time 
            for (i = 0; i<8; i = i + 1)
            begin
                noisy_in = ~noisy_in;
                #5;
            end
            
            // settle high
            noisy_in = 1;
            #(10*10);
            
            
            
        end
    endtask
    
    // task simulating glitch in between pulses
    task glitch_btwn_pulses;
        begin
            $display("\n [Glitch Between Pulses]");
            
            // real rising edge
            noisy_in = 0;
            #(10*8);
            noisy_in = 1;
            #(10*10);
            noisy_in = 0;
            #(10*10);
            
            // short glitch
            noisy_in = 1;
            #10;
            noisy_in = 0;
            #(10*10);
            
            // second valid pulse
            noisy_in = 1;
            #(10*10);
            
            // glitch down
            noisy_in = 0;
            #10;
            noisy_in = 1;
            #(10*10);
            
        end
    endtask
    
    // test sequence
    initial
    begin
        $display("\n\n=== Debounced Edge Detector Tests ===");
        
        // Reset
        rst = 1; noisy_in = 0;
        #20; rst = 0;
        
        // running test cases
        noisy_rising_edge();
        glitch_btwn_pulses();
        
        // Reset 2
        rst = 1; noisy_in = 0;
        #20; rst = 0;
        
        // iteration
        noisy_rising_edge();
        glitch_btwn_pulses();
        
        // Watch ticks
        repeat(60)
        begin
            @(posedge clk);
            $display("Time: %t | noisy_in: %b | tick: %b", $time, noisy_in, tick);
        end
        
        
        
        
        $display("=== Tests Complete ===\n\n");
        $finish;
    end
endmodule
