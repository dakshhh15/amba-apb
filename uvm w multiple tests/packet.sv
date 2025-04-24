package pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  //`include "design.sv"
  `include "sequence_item.sv"
  `include "sequencer.sv"
  `include "sequence.sv"
  `include "mul_write_mul_read_seq.sv"
  `include "rand_seq.sv"
  `include "driver.sv"
  `include "coverage.sv"
  `include "monitor.sv"
  `include "agent.sv"
  `include "scoreboard.sv"
  `include "environment.sv"
  `include "test_1.sv" //all sequences
  `include "test_2.sv" //read write on same address
  `include "test_3.sv" //multiple write then multiple read
  `include "test_4.sv" //randomized

endpackage : pkg
