`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2026 20:39:07
// Design Name: 
// Module Name: Clock Divider Glitch-Free En_tb
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


module Clock_Divider_Glitch_Free_En_tb;

    parameter int DIVIDE_BY = 4;

    logic clk_in;
    logic rst_n;
    logic enable;
    logic clk_out;

    clock_divider_glitch_free #(
        .DIVIDE_BY(DIVIDE_BY)
    ) dut (
        .clk_in (clk_in),
        .rst_n  (rst_n),
        .enable (enable),
        .clk_out(clk_out)
    );

    // Input clock: 100 MHz equivalent
    always #5 clk_in = ~clk_in;

    int clk_out_edges;
    logic clk_out_d;

    initial begin
        $display("Starting Clock Divider Test");

        clk_in  = 0;
        rst_n   = 0;
        enable  = 0;
        clk_out_d = 0;
        clk_out_edges = 0;

        #20;
        rst_n = 1;

        // Enable divider
        enable = 1;

        // Count clk_out edges
        repeat (40) begin
            @(posedge clk_in);
            if (clk_out && !clk_out_d)
                clk_out_edges++;
            clk_out_d = clk_out;
        end

        if (clk_out_edges < 4)
            $error("Clock division incorrect: too few output edges");

        // Disable divider (check glitch-free behavior)
        enable = 0;
        repeat (10) begin
            @(posedge clk_in);
            if (clk_out !== 1'b0)
                $error("clk_out not held low when disabled");
        end

        // Re-enable divider
        enable = 1;
        repeat (20) begin
            @(posedge clk_in);
            if (clk_out !== clk_out_d && clk_out_d !== 0 && clk_out !== 1)
                $error("Glitch detected on clk_out");
            clk_out_d = clk_out;
        end

        $display("All Clock Divider tests PASSED");
        $finish;
    end

endmodule

