class driver extends uvm_driver #(seq_item);
  
  seq_item trans_driv;
  virtual apb_int vint;
  
  //coverage off
  `uvm_component_utils(driver)
  //coverage on
  
  function new (string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    trans_driv = seq_item::type_id::create("trans_mon", this);

    //coverage off    
    if (!(uvm_config_db #(virtual apb_int)::get(this, "", "vint", vint)))
      begin
        `uvm_error("DRIVER", "No interface.")
      end
    else
      begin
        `uvm_info("DRIVER", "Interface found.", UVM_LOW)
      end
    
    `uvm_info("CHECK", "Driver built.", UVM_LOW)
    //coverage on  
  
  endfunction : build_phase
  
  virtual task run_phase(uvm_phase phase);
    forever
      begin
        seq_item_port.get_next_item(trans_driv);
        
        if (!trans_driv.rst_n)
          begin
            vint.master_out <= 0;
            vint.slave_out <= 0;
            vint.PREADY <= 0;
            vint.PRDATA <= 0;
            vint.rst_n <= trans_driv.rst_n;
          end
        else 
          begin
            vint.master_in <= trans_driv.master_in;
            vint.slave_in <= trans_driv.slave_in;
            vint.address <= trans_driv.address;
            //vint.address <= 4000;
            vint.processs <= trans_driv.processs;
            //vint.processs <= 7'b0000011;
            vint.data_size <= trans_driv.data_size;
            vint.rst_n <= trans_driv.rst_n;
            vint.valid <= trans_driv.valid;
          end
        @(negedge vint.clk);
        //@(posedge vint.clk);
        //@(posedge vint.clk);
 
      //coverage off       
        `uvm_info("DRIVER", $sformatf("master_in = %0d | slave_in = %0d | address = %0d | process = %0d | data_size = %0d  | rst = %b | valid = %b", vint.master_in, vint.slave_in, vint.address, vint.processs, vint.data_size, vint.rst_n, vint.valid), UVM_LOW)
         //coverage on    
    
        seq_item_port.item_done();
        
      end
  endtask : run_phase
  
endclass : driver
