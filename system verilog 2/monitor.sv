class monitor;
  
  //instants and handles
  transaction trans_mon;
  virtual int1 vint;
  mailbox mon2sb;
  int count3;

  //constructor  
  function new (virtual int1 vint, mailbox mon2sb);
    this.vint = vint;
    this.mon2sb = mon2sb;
  endfunction
  
  //task driving values from interface to object and then monitoring it
  task main;
    forever
      begin
        if (!vint.PRESETn)
          wait (vint.PRESETn);
          
        @(posedge vint.PCLK);
        @(posedge vint.PCLK);
        @(posedge vint.PCLK);
        @(posedge vint.PCLK);
        trans_mon = new ();

        trans_mon.paddr = vint.PADDR;
        trans_mon.pwdata = vint.PWDATA;
        trans_mon.pwrite = vint.PWRITE;
        trans_mon.prdata = vint.PRDATA;
        
        mon2sb.put(trans_mon);
        
        trans_mon.display("MONITOR");
        
      end
 
  endtask : main
  
endclass : monitor
