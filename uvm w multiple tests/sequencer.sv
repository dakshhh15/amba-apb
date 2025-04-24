class sequencer extends uvm_sequencer #(seq_item);
  
  //coverage off
  `uvm_component_utils(sequencer)
  //coverage on
  
  function new (string name = "sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass : sequencer
