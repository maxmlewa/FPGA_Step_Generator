`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: top_module_step_gen
// Project Name: Step Generator
// Target Devices: Basys 3 (Artix 7)
// Description: Integrates all the modules to implement the step generator triggered
//              by an external clock signal. Output binary step count and displays the
//              step configuration.
// 
// Dependencies: step_selector, step_counter, edge_detector_debounced, seven_seg_display
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: The counter output will be routed to an external DAC
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module_step_gen(
    input wire clk,                 // 100 MHz system clock
    input wire rst,
    input wire pulse_in,
    
    input wire [9:0] sw,
    
    output wire [3:0] an,           // 7 segment anode control
    output wire [6:0] seg,          // 7 segments active LOW
    
    output wire [3:0] step_out      // output current step in binary 0-9  
);

    // internal signals
    wire tick;
    wire [3:0] max_steps;
    
    // debounce the external pulse train
    edge_detector_debounced #(.STABLE_COUNT(3)) DEBOUNCE_UNIT (
        .clk(clk),
        .rst(rst),
        .noisy_in(pulse_in),
        .tick(tick)
    );
    
    // step selector
    step_selector STEP_SELECTOR (
        .sw(sw),
        .steps(max_steps)
    );
    
    // step counter
    step_counter STEP_COUNTER (
        .clk(clk),
        .rst(rst),
        .tick(tick),
        .steps(max_steps),
        .count(step_out)
    );
    
    // 7 segment display driver
    seven_seg_display SEVEN_SEG_DISPLAY (
        .value(max_steps),
        .seg(seg),
        .an(an)
    );
endmodule
