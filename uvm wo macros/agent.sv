class agent extends uvm_agent;
  
  sequencer seqr;
  driver driv;
  monitor mon;
  uvm_analysis_port #(seq_item) agent_port;
  
  //coverage off
  `uvm_component_utils(agent)
  //coverage on
  
  function new (string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    seqr = sequencer::type_id::create("seqr", this);
    driv = driver::type_id::create("driv", this);
    mon = monitor::type_id::create("mon", this);
    agent_port = new("agent_port", this);
    
  endfunction : build_phase
  
  virtual function void connect_phase (uvm_phase phase);
    driv.seq_item_port.connect(seqr.seq_item_export);
    mon.send.connect(agent_port);
  endfunction : connect_phase
  
endclass : agent
