`ifndef __SRAM_GEN_SV__
`define __SRAM_GEN_SV__

`include "sram_txn.sv"

class sram_gen;

  mailbox #(sram_txn) gen2drv;
  int num_txns;

  // Constructor
  function new(mailbox #(sram_txn) gen2drv, int num_txns);
    this.gen2drv = gen2drv;
    this.num_txns = num_txns;
  endfunction

  // Task to generate transactions
  task run(); // <-- changed from generate() to run()
    sram_txn txn;
    repeat (num_txns) begin
      txn = new();
      if (!txn.randomize()) begin
        $display("Error: Randomization failed in generator");
      end
      gen2drv.put(txn);
    end
  endtask

endclass

`endif
