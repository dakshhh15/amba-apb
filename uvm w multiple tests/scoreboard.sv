class scoreboard extends uvm_scoreboard;
  
  bit [31:0] sc_mem [0:255];
  
  uvm_analysis_imp #(seq_item, scoreboard) recieve;
  
  //coverage off
  `uvm_component_utils_begin(scoreboard)
  `uvm_field_sarray_int(sc_mem, UVM_DEFAULT)
  `uvm_component_utils_end
  //coverage on  

  function new (string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    recieve = new("recieve", this);
    
    `uvm_info("CHECK", "Scoreboard built.", UVM_LOW)
  endfunction 
  
  virtual function void write (seq_item pkt);
    
    if (pkt.presetn == 0)
      begin
        foreach (sc_mem[i]) sc_mem[i] = 0;
        //if (pkt.pwrite == 0) begin
          //sc_mem[pkt.paddr] = pkt.pwdata; end
        $display("Reset match.");
      end
    
    else begin
    
      if (pkt.pwrite == 1)
        begin
          sc_mem[pkt.paddr] = pkt.pwdata;
          $display("Data written at %0d", pkt.paddr);
          //$display("[%0t] sc mem : %p", $time, sc_mem);
        end
      else
        begin
          if (sc_mem[pkt.paddr] != pkt.prdata)
            begin
              $error("[%0t] Read Mismatch: Expected = %0d | Actual = %0d | ad = %0d", $time, sc_mem[pkt.paddr], pkt.prdata, pkt.paddr);
            end
          else
            begin
              $display("[%0t] Read Match: Expected = %0d | Actual = %0d | ad = %0d", $time, sc_mem[pkt.paddr], pkt.prdata, pkt.paddr);
            end
        end
      
    end
    
   endfunction : write
  
endclass : scoreboard
