`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2026 22:31:16
// Design Name: 
// Module Name: Gray_Code_Counter_with_Encoder
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

module Gray_Code_Counter_with_encoder_decoder#(
    parameter int WIDTH = 4
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 enable,
    output logic [WIDTH-1:0]     bin_count,
    output logic [WIDTH-1:0]     gray_count
);

    // Binary counter
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bin_count <= '0;
        else if (enable)
            bin_count <= bin_count + 1'b1;
    end

    // Binary to Gray conversion
    // gray = bin ^ (bin >> 1)
    always_comb begin
        gray_count = bin_count ^ (bin_count >> 1);
    end

endmodule


//gray_encoder.sv
module gray_encoder #(
    parameter int WIDTH = 4
)(
    input  logic [WIDTH-1:0] bin,
    output logic [WIDTH-1:0] gray
);
    always_comb begin
        gray = bin ^ (bin >> 1);
    end
endmodule


//gray_decoder.sv
module gray_decoder #(
    parameter int WIDTH = 4
)(
    input  logic [WIDTH-1:0] gray,
    output logic [WIDTH-1:0] bin
);

    integer i;

    always_comb begin
        bin[WIDTH-1] = gray[WIDTH-1];
        for (i = WIDTH-2; i >= 0; i = i - 1)
            bin[i] = bin[i+1] ^ gray[i];
    end

endmodule

