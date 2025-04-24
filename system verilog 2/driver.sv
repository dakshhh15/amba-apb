class driver;
  
  //instants and variables
  transaction trans_driv;
  virtual int1 vint;
  mailbox gen2driv;
  int count1;
  
  //constructor
  function new (virtual int1 vint, mailbox gen2driv);
    this.vint = vint;
    this.gen2driv = gen2driv;
  endfunction
  
  //driving task and reset task
  task main();
    forever
      begin
        trans_driv = new();
        gen2driv.get(trans_driv);
        
        if (!vint.PRESETn)
          begin
            vint.PSEL <= 0;
            vint.PENABLE <= 0;
            vint.PWRITE <= 0;
            vint.PADDR <= 0;
            vint.PWDATA <= 0;
            vint.PRDATA <= 0;
            $display("[%0t] Reset in driver", $time);
            wait (vint.PRESETn);
          end
        
        else
          begin
            vint.PADDR <= trans_driv.paddr;
            vint.PWDATA <= trans_driv.pwdata;
            vint.PWRITE <= trans_driv.pwrite;
            
            trans_driv.display("DRIVER");
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
          end
      end
  endtask : main
  
endclass : driver
