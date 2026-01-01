`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.01.2026 20:52:53
// Design Name: 
// Module Name: fixed_priority_arbiter
// Project Name: Fixed-Priority Arbiter (Parameterized)
// Target Devices: kria kv260
// Tool Versions: 
// Description: //Features
                //Parameterized number of requesters (N)
                //One-hot grant output
                //Fully combinational
                //Synthesizable
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module fixed_priority_arbiter #(
    parameter int N = 4   // Number of requesters
)(
    input  logic [N-1:0] req,    // Request signals
    output logic [N-1:0] grant    // One-hot grant
);

    integer i;

    always_comb begin
        grant = '0;
        for (i = 0; i < N; i = i + 1) begin
            if (req[i]) begin
                grant[i] = 1'b1;
                break; // Highest-priority request wins
            end
        end
    end

endmodule