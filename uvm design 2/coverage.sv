class coverage extends uvm_subscriber #(seq_item);
  
  seq_item trans_cov = seq_item::type_id::create("trans_cov");;
  
  //coverage off
  `uvm_component_utils(coverage)
  //coverage on
  
  covergroup cov;
    paddr_cp : coverpoint trans_cov.PADDR { bins valid[] = {4000, 4001};
                                            bins others = default;}
    
    process_cp : coverpoint trans_cov.processs { bins proc[] = {7'b0000011, 7'b0100011};
                                                 bins other = default;}
    
    read_wr : cross paddr_cp, trans_cov.PWRITE; 
    proc_addr : cross paddr_cp, process_cp;
    
    option.per_instance = 1;
  endgroup : cov 
  
  function new (string name = "coverage", uvm_component parent = null);
    super.new(name, parent);
    cov = new();
  endfunction
  
  virtual function void write (seq_item t);
    trans_cov.PADDR = t.PADDR;
    trans_cov.PWRITE = t.PWRITE;
    trans_cov.processs = t.processs;
    cov.sample();
  endfunction : write
  
  virtual function void report_phase (uvm_phase phase);
    super.report_phase (phase);
    //coverage off
    `uvm_info("COVERAGE", $sformatf("addr coverage = %0.2f %%", cov.paddr_cp.get_inst_coverage()), UVM_LOW)
    `uvm_info("COVERAGE", $sformatf("process on each address coverage = %0.2f %%", cov.proc_addr.get_inst_coverage()), UVM_LOW)
    `uvm_info("COVERAGE", $sformatf("read/write on each address coverage = %0.2f %%", cov.read_wr.get_inst_coverage()), UVM_LOW)
    //coverage on
  endfunction : report_phase
  
endclass : coverage
