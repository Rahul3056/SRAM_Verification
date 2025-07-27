`ifndef __SRAM_MONITOR_SV__
`define __SRAM_MONITOR_SV__

`include "sram_if.sv"
`include "sram_txn.sv"

class sram_monitor;

  virtual sram_if vif;
  mailbox #(sram_txn) mon2sb;

  function new(virtual sram_if vif, mailbox #(sram_txn) mon2sb);
    this.vif = vif;
    this.mon2sb = mon2sb;
  endfunction

  task monitor();
    sram_txn txn;
    forever begin
      @(vif.mon_cb);
      txn = new();
      txn.en    = vif.mon_cb.en;
      txn.we    = vif.mon_cb.we;
      txn.addr  = vif.mon_cb.addr;
      txn.wdata = vif.mon_cb.wdata;
      txn.rdata = vif.mon_cb.rdata;
      txn.display("MON");
      mon2sb.put(txn);
    end
  endtask

endclass

`endif  // <-- MISSING IN YOUR CODE

