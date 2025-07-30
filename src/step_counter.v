`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: step_counter
// Project Name: Step Generator
// Target Devices: Basys 3 (Artix 7)
// Description: Counter triggered by a clean pulse input. Counts from 0 to steps.
//              Wraps around to 0. Freezes at 0 if steps = 0
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Couner resets on rising edge of rst input.
// 
//////////////////////////////////////////////////////////////////////////////////


module step_counter(
    input wire clk, rst, tick,
    input wire [3:0] steps,
    output reg [3:0] count
    );
    // the tick decouples the counter from external pulse
    // the tick period is longer than the clk period
    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            count <= 4'b0;
        end
        
        else if(tick)
        begin
            if (steps == 4'b0)
                count <= 4'b0;
            else if(count >= steps)
                count <= 4'b0;
            else
                count <= count + 1;
        end
    end
endmodule
