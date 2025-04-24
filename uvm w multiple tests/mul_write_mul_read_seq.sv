`ifndef MUL_WRITE_MUL_READ_SV
`define MUL_WRITE_MUL_READ_SV

class mul_write_mul_read extends uvm_sequence #(seq_item);
  seq_item trans_seq;
  int count;
  
  //coverage off
  `uvm_object_utils(mul_write_mul_read)
  //coverage on  

  function new (string name = "mul_write_mul_read");
    super.new(name);
  endfunction 
  
  virtual task pre_body;
    assert(uvm_config_db#(int)::get(null, "", "count", count));
  endtask : pre_body
  
  virtual task body();
    repeat(count) begin 
      trans_seq = seq_item::type_id::create("trans_seq");
      start_item(trans_seq);
      void'(trans_seq.randomize() with { trans_seq.pwrite == 1; });
      finish_item(trans_seq);
    end
    repeat(count) begin 
      trans_seq = seq_item::type_id::create("trans_seq");
      start_item(trans_seq);
      void'(trans_seq.randomize() with { trans_seq.pwrite == 0; });
      finish_item(trans_seq);
    end
  endtask
endclass
`endif
