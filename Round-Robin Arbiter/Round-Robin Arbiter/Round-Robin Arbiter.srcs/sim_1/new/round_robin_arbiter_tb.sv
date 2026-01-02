`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2026 19:38:58
// Design Name: 
// Module Name: round_robin_arbiter_tb
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


module round_robin_arbiter_tb;

    parameter int N = 4;

    logic clk;
    logic rst_n;
    logic [N-1:0] req;
    logic [N-1:0] grant;

    round_robin_arbiter #(
        .N(N)
    ) dut (
        .clk   (clk),
        .rst_n (rst_n),
        .req   (req),
        .grant (grant)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Count grants for fairness checking
    int grant_count [N-1:0];

    function int onehot_to_index(input logic [N-1:0] onehot);
        int j;
        begin
            onehot_to_index = -1;
            for (j = 0; j < N; j++) begin
                if (onehot[j])
                    onehot_to_index = j;
            end
        end
    endfunction

    task check_onehot;
        int ones;
        begin
            ones = $countones(grant);
            if (ones > 1) begin
                $error("Grant is not one-hot: %b", grant);
            end
        end
    endtask

    initial begin
        int idx;

        $display("Starting Round-Robin Arbiter Test");

        // Init
        clk   = 0;
        rst_n = 0;
        req   = '0;

        for (int i = 0; i < N; i++)
            grant_count[i] = 0;

        #20;
        rst_n = 1;

        // Case 1: Single request rotating
        req = 4'b0001;
        repeat (4) begin
            @(posedge clk);
            check_onehot();
            idx = onehot_to_index(grant);
            if (idx != 0)
                $error("Expected grant 0, got %0d", idx);
        end

        // Case 2: All requesters active (fairness test)
        req = 4'b1111;
        repeat (16) begin
            @(posedge clk);
            check_onehot();
            idx = onehot_to_index(grant);
            if (idx >= 0)
                grant_count[idx]++;
        end

        for (int i = 0; i < N; i++) begin
            if (grant_count[i] == 0) begin
                $error("Starvation detected: requester %0d never granted", i);
            end
        end

        // Case 3: Sparse requests
        req = 4'b1010;
        repeat (8) begin
            @(posedge clk);
            check_onehot();
            idx = onehot_to_index(grant);
            if (!(idx == 1 || idx == 3))
                $error("Invalid grant for sparse requests: %0d", idx);
        end

        $display("All Round-Robin Arbiter tests PASSED");
        $finish;
    end

endmodule









