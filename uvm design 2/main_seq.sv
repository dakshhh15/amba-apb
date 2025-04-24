class main_seq extends uvm_sequence #(seq_item);
  
  seq_item trans_seq;
  
  //coverage off
  `uvm_object_utils(main_seq)
  //coverage on  

  function new (string name = "main_seq");
    super.new(name);
  endfunction
  
  virtual task body ();
    repeat (400)
      begin
        trans_seq = seq_item::type_id::create("trans_seq");
        start_item(trans_seq);
        assert(trans_seq.randomize());
        finish_item(trans_seq);
      end
  endtask : body
  
endclass : main_seq
