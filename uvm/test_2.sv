class test_2 extends uvm_test;
  
  environment env;
  sequences seq;
  mul_write_mul_read seq_mul;
  rand_seq seq_rand;
  
  `uvm_component_utils(test_2)
  
  function new (string name = "test_2", uvm_component parent);
    super.new(name, parent);
  endfunction 
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    env = environment::type_id::create("env", this);
    seq = sequences::type_id::create("seq", this);
    seq_mul = mul_write_mul_read::type_id::create("seq_mul", this);
    seq_rand = rand_seq::type_id::create("seq_rand", this);
    
    `uvm_info("CHECK", "Test built.", UVM_LOW)
  endfunction : build_phase
  
  virtual function void end_of_elaboration_phase (uvm_phase phase);
    print();
  endfunction : end_of_elaboration_phase
  
  virtual task run_phase (uvm_phase phase);
    phase.raise_objection(this);
     seq.start(env.ag.seqr);
     `uvm_info("SEQ", "Ended seq", UVM_LOW)
     seq_mul.start(env.ag.seqr);
     `uvm_info("SEQ", "Ended seq_mul", UVM_LOW)
     seq_rand.start(env.ag.seqr);
     `uvm_info("SEQ", "Ended seq_rand", UVM_LOW)
    phase.drop_objection(this);
  endtask : run_phase
  
endclass : test_2
