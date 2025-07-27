`include "sram_if.sv"
`include "sram_env.sv"
 // Make sure this file exists in the same folder

module tb_sram;

  // Clock and reset
  logic clk;
  logic rst;

  // Interface instance
  sram_if intf(clk);

  // Environment instance
  sram_env env;

  // Clock generation
  always #5 clk = ~clk;

  // DUT instantiation
  sram dut (
    .clk   (clk),
    .rst   (rst),
    .en    (intf.en),
    .we    (intf.we),
    .addr  (intf.addr),
    .wdata (intf.wdata),
    .rdata (intf.rdata)
  );

  initial begin
    // Dump for waveform (optional for QuestaSim)
    $dumpfile("sram.vcd");
    $dumpvars(0, tb_sram);

    // Initialize signals
    clk = 0;
    rst = 1;
    #10 rst = 0;

    // Create and run environment
    env = new(intf);
    env.run();

    // Run simulation for a while
    #1000;
    $display("Simulation completed.");
    $finish;
  end

endmodule

