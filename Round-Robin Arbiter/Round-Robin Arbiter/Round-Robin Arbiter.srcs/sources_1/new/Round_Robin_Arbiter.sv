`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2026 19:19:39
// Design Name: 
// Module Name: Round_Robin_Arbiter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: provides fair arbitration by rotating priority among requesters after each successful grant
//                •	Prevents starvation
//                •	Guarantees bounded service latency
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module round_robin_arbiter #(
    parameter int N = 4
)(
    input  logic           clk,
    input  logic           rst_n,
    input  logic [N-1:0]   req,
    output logic [N-1:0]   grant
);

    logic [$clog2(N)-1:0] last_grant;
    logic [$clog2(N)-1:0] next_grant;
    logic                 grant_valid;

    integer i;
    logic [N-1:0] grant_comb;

    // Combinational arbitration logic
    always_comb begin
        grant_comb  = '0;
        next_grant  = last_grant;
        grant_valid = 1'b0;

        // Search requests starting after last_grant
        for (i = 1; i <= N; i = i + 1) begin
            int idx;
            idx = (last_grant + i) % N;
            if (req[idx]) begin
                grant_comb[idx] = 1'b1;
                next_grant      = idx[$clog2(N)-1:0];
                grant_valid     = 1'b1;
                break;
            end
        end
    end

    // Sequential state update
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            last_grant <= '0;
            grant      <= '0;
        end else begin
            grant <= grant_comb;
            if (grant_valid) begin
                last_grant <= next_grant;
            end
        end
    end

endmodule
