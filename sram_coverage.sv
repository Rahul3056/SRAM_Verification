`ifndef _SRAM_COVERAGE_SV_
`define _SRAM_COVERAGE_SV_

`include "sram_txn.sv"

class sram_coverage;

  sram_txn txn;

  covergroup covgrp;
    option.per_instance = 1;

    // Control signal bins
    en_cp: coverpoint txn.en {
      bins en_low  = {0};
      bins en_high = {1};
    }

    we_cp: coverpoint txn.we {
      bins we_read  = {0}; // Read
      bins we_write = {1}; // Write
    }

  endgroup

  // Constructor
  function new();
    covgrp = new();
  endfunction

  // Coverage sampling method
  function void sample(sram_txn t);
    txn = t;
    covgrp.sample();
  endfunction

endclass

`endif
