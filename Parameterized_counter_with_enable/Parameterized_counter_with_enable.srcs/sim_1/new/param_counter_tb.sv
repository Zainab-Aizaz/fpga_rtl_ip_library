`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2025 09:12:39
// Design Name: 
// Module Name: param_counter_tb
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


module param_counter_tb();
   // Parameters
    localparam int WIDTH = 4;

    // DUT signals
    logic clk;
    logic rst;
    logic en;
    logic [WIDTH-1:0] count;

    // Reference model
    logic [WIDTH-1:0] ref_count;

    // Instantiate DUT
    param_counter #(
        .WIDTH(WIDTH)
    ) dut (
        .clk   (clk),
        .rst   (rst),
        .en    (en),
        .count (count)
    );

    /// Clock generation  //100MHz
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle every 5 time units
  end

    // Reference model
    always_ff @(posedge clk) begin
        if (rst)
            ref_count <= '0;
        else if (en)
            ref_count <= ref_count + 1'b1;
    end

 
    // Stimulus
    initial begin
        #5     
        rst = 1;
        en  = 0;
   
        #10
        // Reset asserted        
        rst = 0;
        en = 1;
       
        #50
        rst = 0;
        en = 1;
        
        
        #200;   
        $finish;
        
       
    end

    // Self-check
    always_ff @(posedge clk) begin
    //    #1; // small delay to avoid race
        if (count !== ref_count) begin
            $error("Mismatch at time %0t: count=%0d ref=%0d",
                   $time, count, ref_count);
            $fatal;
        end else   $display("TEST PASSED");
       end

endmodule
    
