`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench_step_counter
// Project Name: Step Generator
// Target Devices: Basys 3 (Artix 7)
// Tool Versions: Vivado 2025
// Description: Verifies the counter behavior
//              - incrementing on each rising edge
//              - wraps around after maxing (steps -1)
//              - holds at 0 when steps = 0
//              - resets when rst is asserted (active HIGH)
// 
// Dependencies: step_counter.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Edge triggered pulse simulation
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_step_counter(

    );
endmodule
