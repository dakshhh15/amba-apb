class seq_item extends uvm_sequence_item;
  
  bit psel, penable;
  rand bit pwrite;
  rand bit [31:0] paddr;
  rand bit [31:0] pwdata;
  bit pready;
  bit [31:0] prdata;
  bit presetn;
  
  //coverage off
  `uvm_object_utils(seq_item)
  //coverage on
  
  function new (string name = "seq_item");
    super.new(name);
  endfunction
  
  constraint addr_range { paddr < 256; }

                    
endclass : seq_item
