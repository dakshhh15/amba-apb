class monitor extends uvm_monitor;
  
  seq_item trans_mon;
  virtual apb_int vint;
  uvm_analysis_port #(seq_item) send;

  //coverage off  
  `uvm_component_utils(monitor)
  //coverage on
  
  function new (string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    trans_mon = seq_item::type_id::create("trans_mon", this);
    send = new("send", this);
 
    //coverage off   
    if (!(uvm_config_db #(virtual apb_int)::get(this, "", "vint", vint)))
      begin
        `uvm_error("MONITOR", "No interface.")
      end
    else
      begin
        `uvm_info("MONITOR", "Interface found.", UVM_LOW)
      end
    
    `uvm_info("CHECK", "Monitor built.", UVM_LOW)
    //coverage on  
  
  endfunction : build_phase
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever
      begin
        
        @(negedge vint.clk);
        //@(posedge vint.clk);
        
        if (!vint.rst_n)
          begin
            trans_mon.master_out = vint.master_out;
            trans_mon.slave_out = vint.slave_out;
            trans_mon.PREADY = vint.PREADY;
            trans_mon.PRDATA = vint.PRDATA;
            trans_mon.rst_n = vint.rst_n;
          end
        else
          begin
            trans_mon.master_in = vint.master_in;
            trans_mon.slave_in = vint.slave_in;
            trans_mon.address = vint.address;  
            trans_mon.master_out = vint.master_out;
            trans_mon.slave_out = vint.slave_out;
            trans_mon.processs = vint.processs;
            trans_mon.data_size = vint.data_size;
            trans_mon.rst_n = vint.rst_n;      
            trans_mon.valid = vint.valid;   
            trans_mon.PWDATA = vint.PWDATA; 
            trans_mon.PSTRB = vint.PSTRB;   
            trans_mon.PRDATA = vint.PRDATA; 
            trans_mon.PADDR = vint.PADDR;
            trans_mon.PPROT = vint.PPROT; 
            trans_mon.PSEL1 = vint.PSEL1;     
            trans_mon.PSEL0 = vint.PSEL0;   
            trans_mon.PENABLE = vint.PENABLE;
            trans_mon.PWRITE = vint.PWRITE; 
            trans_mon.PREADY = vint.PREADY; 
            trans_mon.clk = vint.clk;
          end
        send.write(trans_mon);
        
        //coverage off
        `uvm_info("MONITOR", trans_mon.convert2string(), UVM_LOW)
        $display("MON : [%0t] master_out = %0d | slave_out = %0d, PWDATA = %0d | PSTRB = %0d | PRDATA = %0d | PADDR = %0d | PPROT = %0d | PSEL1 = %0d | PSEL0 = %0d | PENABLE = %0d | PWRITE = %0d | PREADY = %0d", $time, vint.master_out, vint.slave_out, vint.PWDATA, vint.PSTRB, vint.PRDATA, vint.PADDR, vint.PPROT, vint.PSEL1, vint.PSEL0, vint.PENABLE, vint.PWRITE, vint.PREADY);
       //coverage on      
  
      end
  endtask : run_phase
  
endclass : monitor
