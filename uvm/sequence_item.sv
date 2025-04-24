class seq_item extends uvm_sequence_item;
  
  bit psel, penable;
  rand bit pwrite;
  rand bit [31:0] paddr;
  rand bit [31:0] pwdata;
  bit pready;
  bit [31:0] prdata;
  bit presetn;
  
  `uvm_object_utils_begin(seq_item)
  `uvm_field_int(psel, UVM_DEFAULT)
  `uvm_field_int(penable,UVM_DEFAULT)
  `uvm_field_int(pwrite,UVM_DEFAULT)
  `uvm_field_int(paddr,UVM_DEFAULT)
  `uvm_field_int(pwdata,UVM_DEFAULT)
  `uvm_field_int(pready,UVM_DEFAULT)
  `uvm_field_int(prdata,UVM_DEFAULT)
  `uvm_field_int(presetn,UVM_DEFAULT)
  `uvm_object_utils_end
  
  function new (string name = "seq_item");
    super.new(name);
  endfunction
  
  constraint addr_range { paddr < 256; }
                    
endclass : seq_item
