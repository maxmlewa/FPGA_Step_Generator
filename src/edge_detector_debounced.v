`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: edge_detector_debounced
// Project Name: Step Generator
// Target Devices: Basys 3 (Artix 7)
// Description: Synchronizes and debounces asynchronous external clock input.
//              Outputs a clean one-cycle pulse on the rising edge.
// 
// Dependencies: Requires the system clock (clk_sys)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Designed to handle noisy and glitch prone photo-isolated signals
// 
//////////////////////////////////////////////////////////////////////////////////


module edge_detector_debounced #(
    parameter STABLE_COUNT = 8  // number of stable samples required
)    
(
    input wire clk, rst, noisy_in,
    output reg tick      
);

    reg [STABLE_COUNT -1:0] shift_reg; // shift register for trackin stability
                                       // can be replaced with a simple integer variable
    reg debounced = 0;
    reg debounced_prev = 0;
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            shift_reg <= 0;
            debounced <= 0;
            debounced_prev <= 0;
            tick <= 0;
        end
        
        else
        begin
            shift_reg <= {shift_reg[STABLE_COUNT - 2:0], noisy_in};
            
            // stable case 1
            if (&shift_reg)
            begin
                debounced <= 1;
            end
            
            // stable case 0
            else if (~|shift_reg)
            begin
                debounced <= 0;
            end
            
            // Edge detection
            debounced_prev <= debounced;
            tick <= (debounced == 1) && (debounced_prev == 0); // rising edge
            
            
        end
        
    end
endmodule
