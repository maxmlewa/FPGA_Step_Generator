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


module testbench_step_counter( );

    // DUT input
    reg clk;
    reg rst;
    reg tick;
    reg [3:0] steps;
    
    // DUT output
    wire [3:0] count;
    
    // variable declarations
    integer i;
    integer errors;
    
    // DUT instantiation
    step_counter DUT_STEP_COUNTER(
        .clk(clk),
        .rst(rst),
        .tick(tick),
        .steps(steps),
        .count(count)
    );
    
    // Clock generation
    initial
        clk = 1'b0;
    always
        #5 clk = ~clk; // simulate the 10ns period
    
    // task for tick pulses
    task pulse_tick;
        begin
            tick = 1'b1;
            #10;
            tick = 1'b0;
        end
    endtask
    
    // task for count value validation
    task check_count;
        input [3:0] expected;
        begin
            #1;
            if(count !== expected)
            begin
                $display("FAIL: count = %d | expected = %d", count, expected);
                errors = errors + 1;
            end
            
            else
            begin
                $display("PASS: count = %d", count);
            end
        end
    endtask
    
    // test sequence
    initial
    begin
        errors = 0;
        $display("\n\n=== Step Counter Tests ===");
        
        // initial system reset
        rst = 1; tick = 0; steps = 4'd5; #20;
        rst = 0;
        
        $display("Step size 5");
        // step size = 5, expect count : 0,1,2,3,4,0
        for (i =0; i<6; i = i+1)
        begin
            pulse_tick();
            check_count((i+1) % 5); // expected value after wrap
        end
        
        $display("Step size 3");
        // step size 3
        steps = 4'd3; #10;
        pulse_tick(); check_count(2);
        pulse_tick(); check_count(0);
        pulse_tick(); check_count(1); // wrap
        pulse_tick(); check_count(2);
        pulse_tick(); check_count(0);
        
        $display("Step size 0");
        // step size = 0
        steps = 4'b0;
        rst = 1; #10; rst = 0;
        check_count(0);
        
        repeat(3)
        begin
            pulse_tick();
            check_count(0);
        end
        
        $display("Final reset");
        // final reset
        rst = 1; #10; rst = 0;
        check_count(0);
        
        $display("=== Step counter Complete with %2d errors ===\n\n", errors);
        $finish;
    end
    
endmodule
