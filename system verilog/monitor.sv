class monitor;
  
  transaction trans_mon;
  virtual int1 vint;
  mailbox mon2sb;
  int count3;
  
  function new (virtual int1 vint, mailbox mon2sb);
    this.vint = vint;
    this.mon2sb = mon2sb;
  endfunction
  
  task main;
    forever
      begin
        trans_mon = new();
        fork
          begin
            wait (!vint.PRESETn);
            disable loop1;
            trans_mon.presetn = vint.PRESETn;
            trans_mon.paddr = vint.PADDR;
            trans_mon.pwdata = vint.PWDATA;
            trans_mon.pwrite = vint.PWRITE;
            $display("[%0t] reset came", $time);
            mon2sb.put(trans_mon);
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
            
            trans_mon.display("MONITOR");
            mon2sb.put(trans_mon);
          end
        join_any
        
      end
 
  endtask : main
  
endclass : monitor
