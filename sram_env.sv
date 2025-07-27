`ifndef __SRAM_ENV_SV__
`define __SRAM_ENV_SV__

`include "sram_coverage.sv"
`include "sram_txn.sv"
`include "sram_driver.sv"
`include "sram_monitor.sv"
`include "sram_gen.sv"
`include "sram_scoreboard.sv"

class sram_env;

  // Interface handle
  virtual sram_if vif;

  // Components
  sram_driver     drv;
  sram_monitor    mon;
  sram_gen        gen;
  sram_scoreboard sb;
  sram_coverage   cov;

  // Mailboxes
  mailbox #(sram_txn) gen2drv;
  mailbox #(sram_txn) drv2sb;
  mailbox #(sram_txn) mon2sb;

  // Constructor
  function new(virtual sram_if vif);
    this.vif = vif;

    gen2drv = new();
    drv2sb  = new();
    mon2sb  = new();

    drv = new(vif, gen2drv, drv2sb);
    mon = new(vif, mon2sb);
    gen = new(gen2drv, 10);
    sb  = new(drv2sb, mon2sb);
    cov = new();
  endfunction

  // Run all components
  task run();
    fork
      gen.run();       // Renamed from generate()
      drv.drive();
      mon.monitor();
      sb.check();
      collect_coverage();
    join_none
  endtask

  // Coverage collection
  task collect_coverage();
    sram_txn txn;
    forever begin
      drv2sb.peek(txn);
      cov.sample(txn);
      @(posedge vif.clk);
    end
  endtask

endclass

`endif

