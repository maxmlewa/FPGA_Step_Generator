`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: testbench_top_module
// Project Name: Step Generator
// Target Devices: Basys 3 (Artix 7)
// Tool Versions: Vivado 2025
// Description: End-to-end system testbench integrating all the submodules.
// 
// Dependencies: top_module_step_gen.v (also dependent on other sub-modules)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// - System clock: 100MHz
// - External pulse: ~250 kHz w/ simulated glitches(bounce)
//////////////////////////////////////////////////////////////////////////////////


module testbench_top_module( );

    // DUT input
    reg clk;                 
    reg rst;
    reg pulse_in; 
    reg [9:0] sw;
    
    // DUT output
    wire [3:0] an;
    wire [6:0] seg;          
    wire [3:0] step_out;
    
    // other declarations
    localparam BASE_PERIOD = 4000; // 4us base period
    integer jitter;
    
    // Instantiate DUT
    top_module_step_gen STEP_GEN(
        .clk(clk),
        .rst(rst),
        .pulse_in(pulse_in),
        .sw(sw),
        .an(an),
        .seg(seg),
        .step_out(step_out)    
    );
    
    // Generate clock
    initial
        clk = 0;
    always
        #5 clk = ~clk;
    
    
    // task to generate pulse train with bounce and jitter
    task generate_pulse;
        begin
            // Rising edge with bounce
            #2 pulse_in = 1; #3 pulse_in = 0;
            #3 pulse_in = 1; #2 pulse_in = 0;
            #2 pulse_in = 1;
            #30 pulse_in = 0;
            
            // inject glitch
            #1000;
            pulse_in = 1;
            #10;
            pulse_in = 0;
            
            // jitter 
            jitter = $urandom_range(-400,400);
            #(BASE_PERIOD - 1040 + jitter ); // adjusting for the time already spent in pulse
        end
    endtask
    
    // test sequence
    initial
    begin
        $display("\n\n=== System Level Testbench ===");
        
        // reset DUT
        rst = 1; #20; rst = 0;
        $display("\n5 steps selected\n");
        // select 5 steps
        sw = 10'b0000010000;
        #50;
        
        // 8 pulses
        repeat(10)
        begin
            generate_pulse();
            $display("T = %0t ns | step_out = %0d", $time, step_out);
            
        end
        
        // reset DUT
        rst = 1; #20; rst = 0;
        
        $display("\n3 steps selected, no reset\n");
        // select 3 steps
        sw = 10'b0000000110;
        #50;
        
        // 6 pulses
        repeat(6)
        begin
            generate_pulse();
            $display("T = %0t ns | step_out = %0d", $time, step_out);
            
        end
        
        
        
        $display("\n10 steps selected, no reset\n");
        // select 10 steps
        sw = 10'b1111111111;
        #50;
        
        // 12 pulses
        repeat(12)
        begin
            generate_pulse();
            $display("T = %0t ns | step_out = %0d", $time, step_out);
            
        end
        
        $display("=== System Test Complete. Observe waveforms ===\n\n");
        $finish;
    end
endmodule
