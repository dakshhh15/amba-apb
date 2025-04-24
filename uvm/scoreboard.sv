class scoreboard extends uvm_scoreboard;
  
  bit [31:0] sc_mem [0:255];
  
  uvm_analysis_imp #(seq_item, scoreboard) recieve;
  
  `uvm_component_utils_begin(scoreboard)
  `uvm_field_sarray_int(sc_mem, UVM_DEFAULT)
  `uvm_component_utils_end
  
  function new (string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    recieve = new("recieve", this);
    
    `uvm_info("CHECK", "Scoreboard built.", UVM_LOW)
  endfunction 
  
  virtual function void write (seq_item pkt);
    
    `uvm_info("SB", $sformatf("[%0t] paddr = %0d | pwrite = %0d | pwdata = %0d | prdata = %0d ", $time, pkt.paddr, pkt.pwrite, pkt.pwdata, pkt.prdata), UVM_LOW)
    
    if (pkt.presetn == 0)
      begin
            `uvm_info("SCOREBOARD", "Reset match.", UVM_LOW)
          end
    
    else if (pkt.presetn == 1)
      begin
        if (pkt.pwrite == 1)
          begin
            sc_mem[pkt.paddr] = pkt.pwdata;
            //$display("sc mem : %p", sc_mem);
            `uvm_info("SCOREBOARD", "Data written.", UVM_LOW)
          end
        else
          begin
            if (sc_mem[pkt.paddr] != pkt.prdata)
              begin
                `uvm_error("SCOREBOARD", {"Read Mismatch.", $sformatf("Expected = %0d | Actual = %0d | ad = %0d", sc_mem[pkt.paddr], pkt.prdata, pkt.paddr)})
              end
            else
              begin
                `uvm_info("SCOREBOARD", {"Read Match. ", $sformatf("Expected = %0d | Actual = %0d", sc_mem[pkt.paddr], pkt.prdata)}, UVM_LOW)
              end
          end
      end
   endfunction : write
        
endclass : scoreboard
