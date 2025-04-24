class scoreboard extends uvm_scoreboard;
  
  uvm_analysis_export #(seq_item) sb_exp;
  uvm_tlm_analysis_fifo #(seq_item) recieve;
  
  //uvm_analysis_imp #(seq_item, scoreboard) recieve;
  seq_item pkt;
  int right = 0;
  int wrong = 0;
 
  //coverage off 
  `uvm_component_utils(scoreboard)
  //coverage on
  
  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;
  parameter STRB_WIDTH = DATA_WIDTH / 8;
  parameter IDLE_PHASE = 2'b00;
  parameter SETUP_PHASE = 2'b01;
  parameter ACCESS_PHASE = 2'b10;
  
  logic [ADDR_WIDTH-1:0] master_out_ref;
  logic [DATA_WIDTH-1:0] slave_out_ref;
  logic [DATA_WIDTH-1:0] PRDATA_ref;
  logic [ADDR_WIDTH-1:0] PADDR_ref;
  logic [DATA_WIDTH-1:0] PWDATA_ref;
  logic [STRB_WIDTH-1:0] PSTRB_ref;     
  logic [2:0] PPROT_ref;            
  logic PSEL1_ref;                             
  logic PSEL0_ref;                             
  logic PENABLE_ref;                  
  logic PWRITE_ref;                          
  logic PREADY_ref;                    
  logic end_access;                          
  logic setup_rst_ideal;
  
  logic [1:0] current_state;
  logic [1:0] next_state;
  
  function new (string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    pkt = seq_item::type_id::create("pkt");
    recieve = new("recieve", this);
    sb_exp = new("sb_exp", this);
  
    //coverage off   
    `uvm_info("CHECK", "Scoreboard built.", UVM_LOW)
    //coverage on  

  endfunction 
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_exp.connect(recieve.analysis_export);
  endfunction : connect_phase
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever
      begin
        
        recieve.get(pkt);
        sb_logic(pkt);
        
        if (!pkt.rst_n) begin
          //coverage off
          `uvm_info("SCOREBOARD", "Reset match", UVM_LOW) end
          //coverage on
        else begin
        
        if ((master_out_ref === pkt.master_out) &&
            (slave_out_ref === pkt.slave_out) &&
            (PRDATA_ref === pkt.PRDATA) &&
            (PADDR_ref === pkt.PADDR) &&
            (PWDATA_ref === pkt.PWDATA) &&
            (PSTRB_ref === pkt.PSTRB) &&
            (PPROT_ref === pkt.PPROT) &&
            (PSEL0_ref === pkt.PSEL0) &&
            (PSEL1_ref === pkt.PSEL1) &&
            (PENABLE_ref === pkt.PENABLE) &&
            (PWRITE_ref === pkt.PWRITE) &&
            (PREADY_ref === pkt.PREADY))
          begin
            right++;
             //coverage off
            `uvm_info("SCOREBOARD", $sformatf("Scoreboard match. Right count = %0d | Wrong count = %0d", right, wrong), UVM_LOW)
            $display("SC: [%0t] master_out = %0d | slave_out = %0d | PWDATA = %0d, %0d | PSTRB = %0d | PRDATA = %0d | PADDR = %0d | PPROT = %0d | PSEL1 = %0d | PSEL0 = %0d | PENABLE = %0d | PWRITE = %0d | PREADY = %0d", $time, master_out_ref, slave_out_ref, PWDATA_ref, pkt.PWDATA, PSTRB_ref, PRDATA_ref, PADDR_ref, PPROT_ref, PSEL1_ref, PSEL0_ref, PENABLE_ref, PWRITE_ref, PREADY_ref);
             //coverage on
          end
        else
          begin
            wrong++;
            //coverage off
            `uvm_error("SCOREBOARD", $sformatf("Scoreboard mismatch. Right count = %0d | Wrong count = %0d", right, wrong))
            $display("SC: [%0t] master_out = %0d | slave_out = %0d, PWDATA = %0d | PSTRB = %0d | PRDATA = %0d | PADDR = %0d | PPROT = %0d | PSEL1 = %0d | PSEL0 = %0d | PENABLE = %0d | PWRITE = %0d | PREADY = %0d", $time, master_out_ref, slave_out_ref, PWDATA_ref, PSTRB_ref, PRDATA_ref, PADDR_ref, PPROT_ref, PSEL1_ref, PSEL0_ref, PENABLE_ref, PWRITE_ref, PREADY_ref);
             //coverage on
          end end
      
      end
  endtask : run_phase
  
  task sb_logic (seq_item pkt);
    
    if (!pkt.rst_n)
      begin
        //current_state = IDLE_PHASE;
        $display("[%0t] current idle sc %0d", $time, current_state);
        PREADY_ref = 0;
        master_out_ref = 0;
        slave_out_ref = 0;
        PRDATA_ref = 0;
        PREADY_ref = 0;
        
        //if (current_state == SETUP_PHASE) begin
          //setup_rst_ideal = 1;
          //current_state = IDLE_PHASE;
        //end
        //else begin
          //current_state = IDLE_PHASE; end
        
        current_state = IDLE_PHASE;
      end
    
    else
      begin
        //current_state = next_state;
        $display("state = %0d", current_state);
        
        case (current_state)
          IDLE_PHASE : begin
            idle_phase();
            if (pkt.processs == (7'b0000011) || pkt.processs == (7'b0100011)) begin
              current_state = SETUP_PHASE;
              $display("[%0t] idle to setup sc", $time);
            end
            else begin
              current_state = IDLE_PHASE;
              $display("[%0t] idle to idle sc", $time);
            end          
          end
          
          SETUP_PHASE : begin
            setup_phase();
            //if (!PSEL0_ref && !PSEL1_ref) begin
              //current_state = IDLE_PHASE;
              //$display("[%0t] setup to idle sc", $time);
            //end
            //else begin
              current_state = ACCESS_PHASE;
              $display("[%0t] setup to access sc", $time);
            //end
          end
          
          ACCESS_PHASE : begin
            access_phase();
            if (PREADY_ref && ((pkt.processs == (7'b0000011)) || (pkt.processs == (7'b0100011)))) begin
              current_state = SETUP_PHASE;
              $display("[%0t] access to setup sc", $time);
              end_access = 1; end
            else if (PREADY_ref) begin
              current_state = IDLE_PHASE;
              $display("[%0t] access to idle sc", $time);
              end_access = 1; end
            else begin
              current_state = ACCESS_PHASE;
              $display("[%0t] access to access sc", $time);
            end
          end
          
          default : begin current_state = IDLE_PHASE;
            $display("[%0t] def idle sc", $time); end
        endcase
      end
    
    case (current_state)
      IDLE_PHASE : idle_phase();
      SETUP_PHASE : setup_phase();
      ACCESS_PHASE : access_phase();
      default : begin
        PADDR_ref = 0;
        PWDATA_ref = 0;
        PSTRB_ref = 0;
        PPROT_ref = 0;
        PSEL1_ref = 0;
        PSEL0_ref = 0;
        PENABLE_ref = 0;
        PWRITE_ref = 0; end
    endcase
    
  endtask : sb_logic
  
  function void idle_phase;
    $display("idle phase running");
    end_of_access();
    end_access = 0;
    PSEL0_ref = 0;
    PSEL1_ref = 0;
    PENABLE_ref = 0;
    PREADY_ref = 0;
    //end_of_access();
  endfunction : idle_phase
  
  function void setup_phase;
    end_of_access();
    PADDR_ref = pkt.address;
    PWDATA_ref = pkt.master_in;
    PENABLE_ref = 0;
    PPROT_ref = 0;
    //PREADY_ref = 0;
    
    if (pkt.address == 4000) begin
      PSEL0_ref = 1;
      PSEL1_ref = 0; end
    else if (pkt.address == 4001) begin
      PSEL0_ref = 0;
      PSEL1_ref = 1; end
    else begin
      PSEL0_ref = 0;
      PSEL1_ref = 0; end
    
    if (pkt.processs == 7'b0000011) begin
      PWRITE_ref = 0;
      PSTRB_ref = 0; end
    else if (pkt.processs == 7'b0100011) begin
      PWRITE_ref = 1;
      case (pkt.data_size)
        2'b00 : PSTRB_ref = (4'b0001 << pkt.address[1:0]);
        2'b01 : PSTRB_ref = (4'b0011 << { pkt.address[1], 1'b0 });
        2'b10 : PSTRB_ref = 4'b1111;
        default : PSTRB_ref = 4'b1111;
      endcase end
    PREADY_ref = ((pkt.valid) && (PENABLE_ref) && (pkt.rst_n) && (PSEL0_ref || PSEL1_ref));
    
  endfunction : setup_phase
  
  function void access_phase;
    PENABLE_ref = 1;
    
    PREADY_ref = ((pkt.valid) && (PENABLE_ref) && (pkt.rst_n) && (PSEL0_ref || PSEL1_ref));
    
    if (pkt.valid && PREADY_ref) begin
      PRDATA_ref = pkt.slave_in; end
    
  endfunction : access_phase
  
  function void end_of_access;
    if (end_access && PWRITE_ref) begin
      slave_out_ref = PWDATA_ref & ({ {8{PSTRB_ref[3]}}, {8{PSTRB_ref[2]}}, {8{PSTRB_ref[1]}}, {8{PSTRB_ref[0]}} }); end
    else if (end_access && !PWRITE_ref) begin
      master_out_ref = pkt.PRDATA; end
    
    end_access = 0;
  endfunction : end_of_access
  
endclass : scoreboard
