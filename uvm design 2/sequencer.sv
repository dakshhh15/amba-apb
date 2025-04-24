import uvm_pkg::*;
`include "uvm_macros.svh"

class sequencer extends uvm_sequencer #(seq_item);
  
  //coverage off
  `uvm_component_utils(sequencer)
  //coverage on
  
  function new (string name = "sequencer", uvm_component parent = null);
    super.new(name, parent);
  
    //coverage off  
    `uvm_info("CHECK", "Sequencer built.", UVM_LOW)
    //coverage on

  endfunction
  
endclass : sequencer
