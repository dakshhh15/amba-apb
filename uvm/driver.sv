class driver extends uvm_driver #(seq_item);
  
  seq_item trans_driv;
  virtual int1 vint;
  
  `uvm_component_utils(driver)
  
  function new (string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    trans_driv = seq_item::type_id::create("trans_driv");
    
    if (!(uvm_config_db #(virtual int1)::get(this, "", "vint", vint)))
      begin
        `uvm_error("DRIVER", "Interface not found")
      end
    
    `uvm_info("CHECK", "Driver built", UVM_LOW)
  endfunction : build_phase    
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    
    forever 
      begin
        
        seq_item_port.get_next_item(trans_driv);
        
        fork
          begin
            wait (!vint.PRESETn);
            begin
              vint.PSEL <= 0;
              vint.PENABLE <= 0;
              vint.PWRITE <= 0;
              vint.PADDR <= 0;
              vint.PWDATA <= 0;
              vint.PRDATA <= 0;
              $display("[%0t] Reset in driver", $time);
              wait (vint.PRESETn);
              //@(posedge vint.PCLK);
            end
          end
          
          begin
            wait (vint.PRESETn);
            vint.PADDR <= trans_driv.paddr;
            vint.PWDATA <= trans_driv.pwdata;
            vint.PWRITE <= trans_driv.pwrite;
            
            `uvm_info("DRIVER", $sformatf("[%0t] paddr = %0d | pwrite = %0d | pwdata = %0d | prdata = %0d ", $time, trans_driv.paddr, trans_driv.pwrite, trans_driv.pwdata, trans_driv.prdata), UVM_LOW)
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
          end
        join_any
        
        seq_item_port.item_done();
      
      end
  endtask : run_phase
  
endclass : driver
