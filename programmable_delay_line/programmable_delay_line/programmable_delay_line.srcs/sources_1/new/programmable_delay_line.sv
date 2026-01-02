`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2026 21:27:19
// Design Name: 
// Module Name: programmable_delay_line
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


module programmable_delay_line #(
    parameter int DATA_WIDTH = 1,
    parameter int MAX_DELAY  = 8   // Maximum delay in cycles
)(
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic [DATA_WIDTH-1:0]    din,
    input  logic [$clog2(MAX_DELAY+1)-1:0] delay_sel,
    output logic [DATA_WIDTH-1:0]    dout
);

    // Shift register array
    logic [DATA_WIDTH-1:0] shift_reg [0:MAX_DELAY];

    integer i;

    // Shift register update
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= MAX_DELAY; i = i + 1)
                shift_reg[i] <= '0;
        end else begin
            shift_reg[0] <= din;
            for (i = 1; i <= MAX_DELAY; i = i + 1)
                shift_reg[i] <= shift_reg[i-1];
        end
    end

    // Tap selection (combinational)
    always_comb begin
        dout = shift_reg[delay_sel];
    end

endmodule
