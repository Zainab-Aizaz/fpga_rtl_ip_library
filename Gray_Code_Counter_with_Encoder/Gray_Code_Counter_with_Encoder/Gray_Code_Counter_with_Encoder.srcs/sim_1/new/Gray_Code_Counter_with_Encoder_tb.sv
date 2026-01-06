`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2026 22:33:44
// Design Name: 
// Module Name: Gray_Code_Counter_with_Encoder_tb
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


module Gray_Code_Counter_with_encoder_decoder_tb;

    parameter int WIDTH = 4;

    logic clk;
    logic rst_n;
    logic enable;

    logic [WIDTH-1:0] bin_count;
    logic [WIDTH-1:0] gray_count;
    logic [WIDTH-1:0] decoded_bin;

    Gray_Code_Counter_with_encoder_decoder #(
        .WIDTH(WIDTH)
    ) dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .enable     (enable),
        .bin_count  (bin_count),
        .gray_count (gray_count)
    );

    gray_decoder #(
        .WIDTH(WIDTH)
    ) u_decoder (
        .gray(gray_count),
        .bin (decoded_bin)
    );

    // Clock generation
    always #5 clk = ~clk;

    function int count_bit_changes(input logic [WIDTH-1:0] a,
                                   input logic [WIDTH-1:0] b);
        return $countones(a ^ b);
    endfunction

    logic [WIDTH-1:0] prev_gray;

    initial begin
        $display("Starting Gray-Code Counter Test");

        clk       = 0;
        rst_n     = 0;
        enable    = 0;
        prev_gray = '0;

        #20;
        rst_n  = 1;
        enable = 1;

        repeat (20) begin
            @(posedge clk);

            // Check Gray-to-binary correctness
            if (decoded_bin !== bin_count) begin
                $error("Gray decode mismatch: gray=%b bin=%b decoded=%b",
                        gray_count, bin_count, decoded_bin);
            end

            // Check single-bit Gray transition
            if (count_bit_changes(prev_gray, gray_count) > 1) begin
                $error("Invalid Gray transition: %b -> %b",
                        prev_gray, gray_count);
            end

            prev_gray = gray_count;
        end

        // Disable counting
        enable = 0;
        @(posedge clk);
        if (bin_count !== decoded_bin)
            $error("Mismatch when disabled");

        $display("All Gray-Code Counter tests PASSED");
        $finish;
    end

endmodule




