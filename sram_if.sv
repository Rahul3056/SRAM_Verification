`ifndef __SRAM_IF_SV__
`define __SRAM_IF_SV__

interface sram_if(input logic clk);

  // -----------------------------
  // Interface Signals
  // -----------------------------
  logic        rst;
  logic        en;
  logic        we;
  logic [7:0]  addr;
  logic [7:0]  wdata;
  logic [7:0]  rdata;

  // -----------------------------
  // Clocking Block for Driver
  // -----------------------------
  clocking drv_cb @(posedge clk);
    default input #1 output #1;
    output en;
    output we;
    output addr;
    output wdata;
    input  rdata;
  endclocking

  // -----------------------------
  // Clocking Block for Monitor
  // -----------------------------
  clocking mon_cb @(posedge clk);
    default input #1 output #1;
    input en;
    input we;
    input addr;
    input wdata;
    input rdata;
  endclocking

  // -----------------------------
  // Modports
  // -----------------------------
  modport DRV (clocking drv_cb, output rst);
  modport MON (clocking mon_cb, input rst);

  // -----------------------------
  // Immediate Assertion (Combinational)
    // Immediate Assertion (Combinational)
  always @(posedge clk) begin
    if (!rst && we) begin
      assert (en == 1)
        else $error("Assertion Failed: WE is high but EN is low");
    end
  end

  always @(posedge clk) begin
    // Immediate version of: we |-> en
    if (!rst && we) begin
      assert (en == 1)
        else $error("Immediate Assertion Failed: WE is high but EN is low");
    end

    // Immediate version of: rdata !== X -> (en && !we)
    if (!rst && rdata !== 8'bx) begin
      assert (en && !we)
        else $error("Immediate Assertion Failed: rdata is valid without a valid read");
    end
  end

endinterface

`endif

