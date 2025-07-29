`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench_seven_seg_display
// Project Name: Step Generator
// Target Devices: Basys 3 (Atrix 7)
// Tool Versions: Vivado 2025
// Description: Verifies that each input maps to the LED pattern correctly
//              Ensure that inactive or  undefined values are disabled
// 
// Dependencies: seven_seg_display.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// - Segment outputs areactive-low
// - Rightmost display digit (an[0])is active, others off
//////////////////////////////////////////////////////////////////////////////////


module testbench_seven_seg_display( );
    
    // DUT input
    reg [3:0] value;

    // DUT output
    wire [6:0] seg;
    wire [3:0] an;
    
    // variable declarations
    integer i;
    integer errors;
    reg [6:0] expected [0:11]; // for automatic checking
    
    initial
    begin
        expected[0] = 7'b0000001;
        expected[1] = 7'b1001111;
        expected[2] = 7'b0010010;
        expected[3] = 7'b0000110;
        expected[4] = 7'b1001100;
        expected[5] = 7'b0100100;
        expected[6] = 7'b0100000;
        expected[7] = 7'b0001111;
        expected[8] = 7'b0000000;
        expected[9] = 7'b0000100;
        expected[10] = 7'b0001000;
        expected[11] = 7'b1111111;
    end
    
    // DUT instantiation
    seven_seg_display DUT_SEVEN_SEG_DISPLAY(
        .value(value),
        .seg(seg),
        .an(an)
    );
    
    // task for a single test
    task check_segments;
        input [3:0] val;
        input [6:0] actual;
        input [6:0] exp;
        begin
            if (actual !== exp)
            begin
                $display("FAIL: value = %2d | seg = %b | expected = %b", val, actual, exp);
                errors = errors +1;
            end
            
            else
            begin
                $display("PASS: value = %2d | seg = %b", val, actual);
            end
        end
    endtask
    
    // test sequence
    initial
    begin
        $display("\n\n=== Seven Segment Display Tests ===");
        
        errors = 0;
        for(i = 0; i <= 15; i = i +1)
        begin
            value = i[3:0];
            #10;
            if (i<= 10)
                check_segments(value, seg, expected[i]);
            else
                check_segments(value, seg, expected[11]);
        end
        
        $display("=== Seven Segment Display Tests Complete with %2d errors ===\n\n", errors);
        $finish;
    end
    
endmodule
