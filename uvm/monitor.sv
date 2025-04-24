class monitor extends uvm_monitor;
  
  virtual int1 vint;
  seq_item trans_mon;
  uvm_analysis_port #(seq_item) send;
  
  `uvm_component_utils(monitor)
  
  function new (string name = "monitor", uvm_component parent);
    super.new(name, parent);
    trans_mon = seq_item::type_id::create("trans_mon");
    send = new("send", this);
  endfunction 
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    if (!(uvm_config_db #(virtual int1)::get(this, "", "vint", vint)))
      begin
        `uvm_error("MONITOR", "Interface not found")
      end
    
    `uvm_info("CHECK", "Monitor built.", UVM_LOW)
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
            $display("[%0t] reset came", $time);
            send.write(trans_mon);
            wait (vint.PRESETn);
            $display("[%0t] reset deasserted", $time);
          end
        
          begin : loop1
            //wait (vint.PRESETn);
            $display("[%0t] start loop1", $time);
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            $display("[%0t] loop1 after 4 pos edges", $time);

        
        	trans_mon.paddr = vint.PADDR;
        	trans_mon.pwdata = vint.PWDATA;
        	trans_mon.pwrite = vint.PWRITE;
        	trans_mon.prdata = vint.PRDATA;
        	trans_mon.presetn = vint.PRESETn;
        
        	`uvm_info("MONITOR", $sformatf("[%0t] paddr = %0d | pwrite = %0d | pwdata = %0d | prdata = %0d ", $time, trans_mon.paddr, trans_mon.pwrite, trans_mon.pwdata, trans_mon.prdata), UVM_LOW)
            send.write(trans_mon);
          end
        join_any
        
        //send.write(trans_mon);
        
      end
  endtask : run_phase
  
endclass : monitor
