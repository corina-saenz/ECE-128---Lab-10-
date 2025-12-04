`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 06:50:23 PM
// Design Name: 
// Module Name: whole_system
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


module whole_system (
    input  wire        clk,      // 100 MHz clock from Basys3
    input  wire [15:0] sw,       // switches
    output wire [15:0] led       // LEDs
);
    // sw[0] = start, sw[1] = reset
    wire start = sw[0];
    wire reset = sw[1];

    wire [3:0] A;
    wire [3:0] B;
    wire [7:0] P;
    wire [7:0] ram_dout;
    wire       done;

    wire [2:0] rom_addr;
    wire [3:0] rom_data;

    rom8x4 U_ROM (
        .addr (rom_addr),
        .data (rom_data)
    );

    comb_multiplier #(.W(4)) U_MULT (
        .A (A),
        .B (B),
        .P (P)
    );

    wire [2:0] ram_addr;
    wire       ram_en;
    wire       ram_we;
    wire [7:0] ram_din;

    ram8x8 U_RAM (
        .clk  (clk),
        .en   (ram_en),
        .we   (ram_we),
        .addr (ram_addr),
        .din  (ram_din),
        .dout (ram_dout)
    );

    control_unit U_CTRL (
        .clk      (clk),
        .reset    (reset),
        .start    (start),
        .rom_data (rom_data),
        .product  (P),
        .rom_addr (rom_addr),
        .ram_addr (ram_addr),
        .ram_en   (ram_en),
        .ram_we   (ram_we),
        .ram_din  (ram_din),
        .A        (A),
        .B        (B),
        .done     (done)
    );

    // Show product stored in RAM 
    assign led[7:0]  = ram_dout;  // product 
    assign led[8]    = done;      
    assign led[15:9] = 7'b0;      

endmodule
