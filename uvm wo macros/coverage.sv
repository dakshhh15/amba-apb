class coverage extends uvm_subscriber #(seq_item);
  
  seq_item trans_cov = seq_item::type_id::create("trans_cov");;
  
  //coverage off
  `uvm_component_utils(coverage)
  //coverage on
  
  covergroup cov;
    paddr_cp : coverpoint trans_cov.paddr { bins valid[] = {[0:255]}; }
    
    read_wr : cross paddr_cp, trans_cov.pwrite; 
    
    option.per_instance = 1;
  endgroup : cov 
  
  function new (string name = "coverage", uvm_component parent = null);
    super.new(name, parent);
    //trans_cov = seq_item::type_id::create("trans_cov");
    cov = new();
  endfunction
  
  virtual function void write (seq_item t);
    trans_cov.paddr = t.paddr;
    trans_cov.pwrite = t.pwrite;
    cov.sample();
  endfunction : write
  
  virtual function void check_phase (uvm_phase phase);
    super.check_phase (phase);
    $display("addr coverage = %0.2f %%", cov.paddr_cp.get_inst_coverage());
    $display("cross coverage = %0.2f %%", cov.read_wr.get_inst_coverage());
  endfunction : check_phase
  
endclass : coverage
