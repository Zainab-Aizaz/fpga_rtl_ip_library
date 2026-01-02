`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2026 20:37:53
// Design Name: 
// Module Name: Clock Divider Glitch-Free En
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 	Divider implemented using a counter
                  // Output clock toggles only on counter terminal count
                  // Enable is synchronized and sampled only on clock edges
                       // When disabled:
                       // Output clock is held at a known value
                       // Internal counter is reset or frozen
                       // Fully synchronous, no glitches
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Clock_Divider_Glitch_Free_En #(
    parameter int DIVIDE_BY = 4   // Must be even and >= 2
)(
    input  logic clk_in,
    input  logic rst_n,
    input  logic enable,
    output logic clk_out
);

    // Counter width
    localparam int CNT_WIDTH = $clog2(DIVIDE_BY);

    logic [CNT_WIDTH-1:0] cnt;
    logic                 enable_q;

    // Synchronize enable (prevents glitches and metastability)
    always_ff @(posedge clk_in or negedge rst_n) begin
        if (!rst_n)
            enable_q <= 1'b0;
        else
            enable_q <= enable;
    end

    // Divider logic
    always_ff @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= '0;
            clk_out <= 1'b0;
        end else if (enable_q) begin
            if (cnt == (DIVIDE_BY/2 - 1)) begin
                cnt     <= '0;
                clk_out <= ~clk_out;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end else begin
            // Disabled: hold clock low and reset counter
            cnt     <= '0;
            clk_out <= 1'b0;
        end
    end

endmodule
