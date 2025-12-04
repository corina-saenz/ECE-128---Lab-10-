`timescale 1ns/1ps

module control_unit #(
    parameter ADDR_A   = 3'd1, // ROM address for first operand
    parameter ADDR_B   = 3'd2, // ROM address for second operand
    parameter ADDR_RAM = 3'd0  // RAM address to store product
)(
    input  wire       clk,
    input  wire       reset,
    input  wire       start,
    input  wire [3:0] rom_data,
    input  wire [7:0] product,
    output reg  [2:0] rom_addr,
    output reg  [2:0] ram_addr,
    output reg        ram_en,
    output reg        ram_we,
    output reg  [7:0] ram_din,
    output reg  [3:0] A,
    output reg  [3:0] B,
    output reg        done
);
    // State encoding
    localparam S_IDLE   = 3'd0;
    localparam S_READ_A = 3'd1;
    localparam S_READ_B = 3'd2;
    localparam S_MULT   = 3'd3;
    localparam S_WRITE  = 3'd4;
    localparam S_DONE   = 3'd5;

    reg [2:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state    <= S_IDLE;
            rom_addr <= 3'd0;
            ram_addr <= 3'd0;
            ram_en   <= 1'b0;
            ram_we   <= 1'b0;
            ram_din  <= 8'd0;
            A        <= 4'd0;
            B        <= 4'd0;
            done     <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    done   <= 1'b0;
                    ram_en <= 1'b0;
                    ram_we <= 1'b0;
                    if (start) begin
                        rom_addr <= ADDR_A;  // first operand address
                        state    <= S_READ_A;
                    end
                end

                S_READ_A: begin
                    A        <= rom_data;    // latch first operand
                    rom_addr <= ADDR_B;      // set address for second operand
                    state    <= S_READ_B;
                end

                S_READ_B: begin
                    B     <= rom_data;       // latch second operand
                    state <= S_MULT;
                end

                S_MULT: begin
                    state <= S_WRITE;
                end

                S_WRITE: begin
                    ram_en   <= 1'b1;
                    ram_we   <= 1'b1;
                    ram_addr <= ADDR_RAM;
                    ram_din  <= product;
                    state    <= S_DONE;
                end

                S_DONE: begin
                    ram_we <= 1'b0;
                    ram_en <= 1'b1;          // keep enabled so RAM dout shows the result
                    done   <= 1'b1;          // stay done until reset
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end
endmodule
