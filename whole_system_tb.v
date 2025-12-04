`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 07:10:47 PM
// Design Name: 
// Module Name: whole_system_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module whole_system_tb;
    reg        clk;
    reg [15:0] sw;
    wire [15:0] led;

    whole_system DUT (
        .clk (clk),
        .sw  (sw),
        .led (led)
    );

    // 100 MHz clock
    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        // sw[1]=reset, sw[0]=start
        sw = 16'd0;

        // Assert reset
        sw[1] = 1'b1;
        #20;
        sw[1] = 1'b0;

        // Wait a bit
        #20;

        // Pulse start
        sw[0] = 1'b1;
        #10;
        sw[0] = 1'b0;

        // Let it run
        #200;

        $finish;
    end
endmodule
