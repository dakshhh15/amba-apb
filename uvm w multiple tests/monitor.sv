class monitor extends uvm_monitor;
  
  virtual int1 vint;
  seq_item trans_mon;
  uvm_analysis_port #(seq_item) send;
  
  //coverage off
  `uvm_component_utils(monitor)
  //coverage on
  
  function new (string name = "monitor", uvm_component parent);
    super.new(name, parent);
    trans_mon = seq_item::type_id::create("trans_mon");
    send = new("send", this);
  endfunction 
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    assert(uvm_config_db #(virtual int1)::get(this, "", "vint", vint));
  endfunction : build_phase
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    
    forever
      begin
        
        fork
          begin
            wait (!vint.PRESETn);
            disable loop1;
            trans_mon.presetn = vint.PRESETn;
            trans_mon.paddr = vint.PADDR;
            trans_mon.pwdata = vint.PWDATA;
            trans_mon.pwrite = vint.PWRITE;
            
            send.write(trans_mon);
            wait (vint.PRESETn);
            
          end
        
          begin : loop1
            
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            

        
        	trans_mon.paddr = vint.PADDR;
        	trans_mon.pwdata = vint.PWDATA;
        	trans_mon.pwrite = vint.PWRITE;
        	trans_mon.prdata = vint.PRDATA;
        	trans_mon.presetn = vint.PRESETn;
        
        	
            send.write(trans_mon);
          end
        join_any
        
      end
  endtask : run_phase
  
endclass : monitor
