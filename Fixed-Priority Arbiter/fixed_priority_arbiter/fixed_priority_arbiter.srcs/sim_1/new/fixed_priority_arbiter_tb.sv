`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.01.2026 20:57:18
// Design Name: 
// Module Name: fixed_priority_arbiter_tb
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


module fixed_priority_arbiter_tb;

    parameter int N = 4;

    logic [N-1:0] req;
    logic [N-1:0] grant;

    fixed_priority_arbiter #(
        .N(N)
    ) dut (
        .req(req),
        .grant(grant)
    );

    task check_grant(input logic [N-1:0] expected);
        begin
            #1;
            if (grant !== expected) begin
                $error("REQ=%b | Expected GRANT=%b, Got=%b",
                        req, expected, grant);
            end
        end
    endtask

    initial begin
        $display("Starting Fixed-Priority Arbiter Test");

        // No request
        req = 4'b0000;
        check_grant(4'b0000);

        // Single requests
        req = 4'b0001; // req[0]
        check_grant(4'b0001);

        req = 4'b0010; // req[1]
        check_grant(4'b0010);

        req = 4'b0100; // req[2]
        check_grant(4'b0100);

        req = 4'b1000; // req[3]
        check_grant(4'b1000);

        // Multiple simultaneous requests
        req = 4'b1010; // req[1] and req[3]
        check_grant(4'b0010); // req[1] wins

        req = 4'b1111; // all request
        check_grant(4'b0001); // req[0] wins

        req = 4'b1100; // req[2] and req[3]
        check_grant(4'b0100); // req[2] wins

        $display("All tests passed");
        $finish;
    end

endmodule
