# SRAM_Verification
System Verilog style verification environment for SRAM using constrained random testing, coverage, and assertions.
This repository contains a SystemVerilog-based functional verification environment for a synchronous SRAM module.

## 📌 Features

- Class-based testbench
- Constrained random stimulus
- Functional coverage
- Scoreboard-based checking
- Assertions (optional)
- QuestaSim compatible

## 🧪 Testbench Components

- `sram_txn.sv`: Transaction class
- `sram_gen.sv`: Generator
- `sram_driver.sv`: Driver
- `sram_monitor.sv`: Monitor
- `sram_scoreboard.sv`: Scoreboard
- `sram_coverage.sv`: Functional coverage
- `sram_env.sv`: Environment
- `tb_sram.sv`: Top-level testbench

## ▶️ Simulation

To run with ModelSim/QuestaSim:
```sh
vlib work
vlog -sv rtl/sram.v tb/*.sv
vsim -coverage work.tb_sram
run -all

