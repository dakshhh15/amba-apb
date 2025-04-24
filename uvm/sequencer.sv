class sequencer extends uvm_sequencer #(seq_item);
  
  `uvm_component_utils(sequencer)
  
  function new (string name = "sequencer", uvm_component parent = null);
    super.new(name, parent);
    
    `uvm_info("CHECK", "Sequencer built.", UVM_LOW)
  endfunction
  
endclass : sequencer
