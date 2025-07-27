`ifndef __SRAM_DRIVER_SV__
`define __SRAM_DRIVER_SV__

`include "sram_txn.sv"
`include "sram_if.sv"

class sram_driver;

  virtual sram_if vif;
  mailbox #(sram_txn) gen2drv;
  mailbox #(sram_txn) drv2sb;

  function new(virtual sram_if vif,
               mailbox #(sram_txn) gen2drv,
               mailbox #(sram_txn) drv2sb);
    this.vif = vif;
    this.gen2drv = gen2drv;
    this.drv2sb = drv2sb;
  endfunction

  task drive();
    sram_txn txn;

    forever begin
      gen2drv.get(txn);

      // Drive signals using clocking block
      @(vif.drv_cb);
      vif.drv_cb.en    <= txn.en;
      vif.drv_cb.we    <= txn.we;
      vif.drv_cb.addr  <= txn.addr;
      vif.drv_cb.wdata <= txn.wdata;

      // Forward to scoreboard
      drv2sb.put(txn);
      txn.display("DRV");
    end
  endtask

endclass

`endif

