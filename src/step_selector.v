`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: step_selector
// Project Name: Step Generator
// Target Devices: Basys 3 (Artix 7)
// Description: Encodes active switch input (SW[9:0]) into a 4-bit number (range 1-10)
//              using priority encoding logic, with descending priority
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: If no switches are active, outputs 0.
// 
//////////////////////////////////////////////////////////////////////////////////


module step_selector(
    input wire [9:0] sw,
    output reg [3:0] steps
    );
    
    always@(*)
    begin
        casex(sw)                          // priority encoding for the step selection operation
            10'b1xxxxxxxxx: steps = 4'd10; // SW9
            10'b01xxxxxxxx: steps = 4'd9;
            10'b001xxxxxxx: steps = 4'd8;
            10'b0001xxxxxx: steps = 4'd7;
            10'b00001xxxxx: steps = 4'd6;
            10'b000001xxxx: steps = 4'd5;
            10'b0000001xxx: steps = 4'd4;
            10'b00000001xx: steps = 4'd3;
            10'b000000001x: steps = 4'd2;
            10'b0000000001: steps = 4'd1;
            default:        steps = 4'd0; // no switches on
        endcase
    end
endmodule
