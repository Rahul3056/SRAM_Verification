`ifndef __SRAM_SCOREBOARD_SV__
`define __SRAM_SCOREBOARD_SV__

`include "sram_txn.sv"

class sram_scoreboard;

  mailbox #(sram_txn) drv2sb;
  mailbox #(sram_txn) mon2sb;

  bit [7:0] ref_mem [0:255];

  function new(mailbox #(sram_txn) drv2sb,
               mailbox #(sram_txn) mon2sb);
    this.drv2sb = drv2sb;
    this.mon2sb = mon2sb;
  endfunction

  task check();
    sram_txn drv_txn, mon_txn;
    bit [7:0] expected;

    forever begin
      drv2sb.get(drv_txn);

      if (drv_txn.en && drv_txn.we) begin
        // ? Write check
        assert (drv_txn.addr <= 8'hFF)
          else $error("[SB] WRITE: Invalid address %0h", drv_txn.addr);

        ref_mem[drv_txn.addr] = drv_txn.wdata;
        $display("[SB] WRITE  @ %0h = %0h", drv_txn.addr, drv_txn.wdata);
      end
      else if (drv_txn.en && !drv_txn.we) begin
        mon2sb.get(mon_txn);
        expected = ref_mem[drv_txn.addr];

        // ? Compare expected vs actual
        assert (mon_txn.rdata === expected)
          else $error("[SB][READ MISMATCH] Addr=%0h Expected=%0h Got=%0h",
                      drv_txn.addr, expected, mon_txn.rdata);

        $display("[SB] READ MATCH @ %0h = %0h", drv_txn.addr, expected);
      end
    end
  endtask

endclass

`endif

