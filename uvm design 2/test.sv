//`include "environment.sv"
//`include "reset_seq.sv"
//`include "main_seq.sv"

class test extends uvm_test;
  
  environment env;
  reset_seq r_seq;
  main_seq m_seq;
  
  //coverage off
  `uvm_component_utils(test)
  //coverage on
  
  function new (string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction 
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    env = environment::type_id::create("env", this);
    r_seq = reset_seq::type_id::create("r_seq", this);
    m_seq = main_seq::type_id::create("m_seq", this);
    
    `uvm_info("CHECK", "Test built.", UVM_LOW)
  endfunction : build_phase
  
  virtual function void end_of_elaboration_phase (uvm_phase phase);
    print();
  endfunction : end_of_elaboration_phase
  
  virtual task run_phase (uvm_phase phase);
    phase.raise_objection(this);
    r_seq.start(env.ag.seqr);
    #10;
    m_seq.start(env.ag.seqr);
    phase.drop_objection(this);
  endtask : run_phase
  
endclass : test
