`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2026 21:29:41
// Design Name: 
// Module Name: programmable_delay_line_tb
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


module programmable_delay_line_tb;

    parameter int DATA_WIDTH = 8;
    parameter int MAX_DELAY  = 8;

    logic clk;
    logic rst_n;
    logic [DATA_WIDTH-1:0] din;
    logic [$clog2(MAX_DELAY+1)-1:0] delay_sel;
    logic [DATA_WIDTH-1:0] dout;

    programmable_delay_line #(
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_DELAY (MAX_DELAY)
    ) dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .din       (din),
        .delay_sel (delay_sel),
        .dout      (dout)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Reference model
    logic [DATA_WIDTH-1:0] ref_shift [0:MAX_DELAY];

    integer i;

    task check_output;
        begin
            if (dout !== ref_shift[delay_sel]) begin
                $error("Mismatch: delay_sel=%0d Expected=%0h Got=%0h",
                        delay_sel, ref_shift[delay_sel], dout);
            end
        end
    endtask

    initial begin
        $display("Starting Programmable Delay Line Test");

        clk       = 0;
        rst_n     = 0;
        din       = 0;
        delay_sel = 0;

        // Init reference model
        for (i = 0; i <= MAX_DELAY; i = i + 1)
            ref_shift[i] = '0;

        #20;
        rst_n = 1;

        // Apply stimulus
        repeat (20) begin
            @(posedge clk);

            // Random input and delay
            din       <= $random;
            delay_sel <= $urandom_range(0, MAX_DELAY);

            // Update reference model
            ref_shift[0] <= din;
            for (i = 1; i <= MAX_DELAY; i = i + 1)
                ref_shift[i] <= ref_shift[i-1];

            #1;
            check_output();
        end

        $display("All Programmable Delay Line tests PASSED");
        $finish;
    end

endmodule
