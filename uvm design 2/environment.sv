//`include "sequence_item.sv"
//`include "agent.sv"
//`include "scoreboard_2.sv"


class environment extends uvm_env;
  
  agent ag;
  scoreboard sb;
  coverage cov_obj;
  
    //coverage off
  `uvm_component_utils(environment)
  //coverage on  

  function new (string name = "environment", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    ag = agent::type_id::create("ag", this);
    sb = scoreboard::type_id::create("sb", this);
    cov_obj = coverage::type_id::create("cov_obj", this);
    
    //coverage off
    `uvm_info("CHECK", "Environment built.", UVM_LOW)
     //coverage on
  endfunction : build_phase
  
  virtual function void connect_phase (uvm_phase phase);
    ag.agent_port.connect(sb.sb_exp);
    ag.agent_port.connect(cov_obj.analysis_export);
  endfunction : connect_phase
  
endclass : environment
