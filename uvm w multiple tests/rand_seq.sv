`ifndef RAND_SEQ_SV
`define RAND_SEQ_SV

class rand_seq extends uvm_sequence #(seq_item);
  seq_item trans_seq;
  int count;
  
  //coverage off
  `uvm_object_utils(rand_seq)
  //coverage on
  
  function new(string name = "rand_seq");
    super.new(name);
  endfunction 
  
  virtual task pre_body;
    assert(uvm_config_db#(int)::get(null, "", "count", count));
  endtask : pre_body

  
  virtual task body();
    repeat(count) begin
      trans_seq = seq_item::type_id::create("trans_seq");
      start_item(trans_seq);
      void'(trans_seq.randomize());
      finish_item(trans_seq);
    end
  endtask
endclass
`endif
