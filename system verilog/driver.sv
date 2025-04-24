class driver;
  
  transaction trans_driv;
  virtual int1 vint;
  mailbox gen2driv;
  int count1;
  
  function new (virtual int1 vint, mailbox gen2driv);
    this.vint = vint;
    this.gen2driv = gen2driv;
  endfunction
  
  task main;
    
    forever 
      begin
        
        trans_driv = new();
        gen2driv.get(trans_driv);
        
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
            
            trans_driv.display("DRIVER");
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
            @(posedge vint.PCLK);
          end
        join_any
      
      end
  endtask : main
  
endclass : driver
