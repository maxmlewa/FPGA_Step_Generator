`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: seven_seg_display
// Project Name: Step Generator
// Target Devices: Basys 3 (Artix 7)
// Description: Displays the current step configuration (1-10) on the rightmost
//              7-segment digit (an[0]). Supports digits 0-9 and 10 ("A").
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Display is active-low. Only an[0] is enabled.
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg_display(
    input wire [3:0] value,
    output reg [6:0] seg,
    output wire [3:0] an
    );
    
    assign an = 4'b1110; // Only make the rightmost section active (an[0] low)
    
    always@*
    begin
        case(value)
            4'd0: seg = 7'b0000001;
            4'd1: seg = 7'b1001111;
            4'd2: seg = 7'b0010010;
            4'd3: seg = 7'b0000110;
            4'd4: seg = 7'b1001100;
            4'd5: seg = 7'b0100100;
            4'd6: seg = 7'b0100000;
            4'd7: seg = 7'b0001111;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0000100;
            4'd10: seg = 7'b0001000; // using A for 10
            default: seg = 7'b1111111; // off
        endcase
        
    end
endmodule
