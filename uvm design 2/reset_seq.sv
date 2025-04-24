class reset_seq extends uvm_sequence #(seq_item);
  
  seq_item trans_seq;
  
  //coverage off
  `uvm_object_utils(reset_seq)
  //coverage on
  
  function new (string name = "base_seq");
    super.new(name);
  endfunction
  
  virtual task body ();
    trans_seq = seq_item::type_id::create("trans_seq");
    start_item(trans_seq);
    trans_seq.rst_n = 0;
    finish_item(trans_seq);
  endtask : body
  
endclass : reset_seq
