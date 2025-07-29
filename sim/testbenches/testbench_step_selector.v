`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: testbench_step_selector
// Project Name: Step Generator
// Target Devices: Basys 3 (Artix 7)
// Description: Verifies correct priority encoding of the 10-bit switch input.
//              Tests single active inputs and multiple simultaneous inputs,
//              and no input case. Outputs should reflect the highest active bit
// 
// Dependencies: step_selector.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  - All switches tested from highest to lowest priority.
//  - Multi-active input test ensures correcct priority encoding.
//  - Zero-input condition verified
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_step_selector( );

    // DUT input
    reg [9:0] sw;
    
    // DUT output
    wire [3:0] steps;
    
    // variable declarations
    integer errors;
    
    // DUT instantiation
    step_selector DUT_STEP_SELECTOR(
        .sw(sw),
        .steps(steps)
    );
    
    // task for a single test
    task check_steps;
        input [9:0] sw_input;
        input [3:0] expected;
        
        begin
            sw = sw_input;
            #5;
            if (steps !== expected)
            begin
                $display("FAIL: sw = %b | steps = %d | expected = %d", sw, steps, expected);
                errors = errors + 1;
            end
            else
                $display("PASS: sw = %b | steps = %d ", sw, steps);
        end
    endtask
    
    // task sequence
    initial
    begin
        $display("\n\n=== Step Selector Tests ===");
        errors = 0;
        
        // single switch active
        check_steps(10'b0000000001, 4'd1);
        check_steps(10'b0000000010, 4'd2);
        check_steps(10'b000000010x, 4'd3);
        check_steps(10'b00000010xz, 4'd4);
        check_steps(10'b0000010000, 4'd5);
        check_steps(10'b0000101010, 4'd6);
        check_steps(10'b00010000xx, 4'd7);
        check_steps(10'b0010000000, 4'd8);
        check_steps(10'b0100000000, 4'd9);
        check_steps(10'b1000000000, 4'd10);
        
        // multiple switches active
        check_steps(10'b1111111111, 4'd10);
        check_steps(10'b0001110000, 4'd7);
        check_steps(10'b0000001111, 4'd4);
        check_steps(10'b0000000001, 4'd1);
        
        // no switch active
        check_steps(10'b0000000000, 4'd0);
        
        $display("=== Step Selector Complete with %2d errors ===\n\n", errors);
    end
endmodule
