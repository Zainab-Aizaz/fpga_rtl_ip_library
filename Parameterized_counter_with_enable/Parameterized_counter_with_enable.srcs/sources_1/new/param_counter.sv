`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2025 09:11:00
// Design Name: 
// Module Name: param_counter
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
module param_counter #(
    parameter int WIDTH = 8
)(
    input  logic                 clk,
    input  logic                 rst,    // synchronous active-high reset
    input  logic                 en,     // enable
    output logic [WIDTH-1:0]     count
);

    always_ff @(posedge clk) begin   // always_ff @(posedge clk or posedge rst) for active high asynch reset 
        if (rst) begin
            count <= '0;
        end
        else if (en) begin
            count <= count + 1'b1;
        end
    end

endmodule
