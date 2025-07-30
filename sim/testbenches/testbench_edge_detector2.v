`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench_edge_detector2
// Project Name: Step Generator
// Target Devices: Basys 3 (Artix 7)
// Description: Simulates realistic 250kHz pulse train with low duty cycle
//              Inserts short glitches between the pulses
// 
// Dependencies: esge_detector_debounced
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_edge_detector2( );

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
        
    
    // task to generate the clean 250kHz pulse train with 
    task generate_valid_pulse;
        begin
            noisy_in = 1;
            #150;
            noisy_in = 0;
            #(4000 - 150); // remainder of the 4us period of the pulse train
        end
    endtask
    
    
    // Task to inject short glitch
    task inject_glitch;
        begin
            noisy_in = 1;
            #20;
            noisy_in = 0;
            #(3000); // delay before the next event
        end
    endtask
    
    
    // task for full waveform simulation
    task run_wave_simulation;
        begin
            $display("\n Realistic 250kHz Pulse Train with Glitches");
            
            for(i = 0; i <3; i = i + 1)
            begin
                generate_valid_pulse();
                inject_glitch();
            end
            
            generate_valid_pulse();
        end
    endtask
    
    
    // test sequence
    initial
    begin
        $display("\n\n=== Edge Detector Debounced Test ===");
        
        // Reset
        rst = 1;
        noisy_in = 0;
        #20;
        rst = 0;
        
        run_wave_simulation();
        
        $display("=== Simulation complete, observe waveform ===\n\n");
        $finish;
        
    end
endmodule
