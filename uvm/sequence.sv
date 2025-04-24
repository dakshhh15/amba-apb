class sequences extends uvm_sequence #(seq_item);
  
  int count;
  seq_item trans_seq;
  static bit [31:0] temp;
  static bit [31:0] temp_data;
  
  `uvm_object_utils_begin(sequences)
  `uvm_field_int(count, UVM_DEFAULT)
  `uvm_object_utils_end
  
  function new (string name = "sequences");
    super.new(name);
  endfunction
  
  virtual task pre_body;
    uvm_config_int::get(null, "test_1.seq", "count", count);
  endtask : pre_body
  
  virtual task body ();
    repeat (count)
      begin
        trans_seq = seq_item::type_id::create("trans_seq");
        `uvm_do_with(trans_seq, { trans_seq.pwrite == 1; })
        temp = trans_seq.paddr;
        temp_data = trans_seq.pwdata;
        `uvm_do_with(trans_seq, { trans_seq.pwrite == 0; trans_seq.paddr == temp; trans_seq.pwdata == temp_data; } )
      end
  endtask : body
  
endclass : sequences



class mul_write_mul_read extends uvm_sequence #(seq_item);
  seq_item trans_seq;
  `uvm_object_utils(mul_write_mul_read)
  
  function new (string name = "mul_write_mul_read");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(2) begin 
      trans_seq = seq_item::type_id::create("trans_seq");
      start_item(trans_seq);
      void'(trans_seq.randomize() with { trans_seq.pwrite == 1; });
      finish_item(trans_seq);
    end
    repeat(2) begin 
      trans_seq = seq_item::type_id::create("trans_seq");
      start_item(trans_seq);
      void'(trans_seq.randomize() with { trans_seq.pwrite == 0; });
      finish_item(trans_seq);
    end
  endtask
endclass

class rand_seq extends uvm_sequence #(seq_item);
  seq_item trans_seq;
  `uvm_object_utils(rand_seq)
  
  function new(string name = "rand_seq");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(2) begin
      trans_seq = seq_item::type_id::create("trans_seq");
      start_item(trans_seq);
      void'(trans_seq.randomize());
      finish_item(trans_seq);
    end
  endtask
endclass
