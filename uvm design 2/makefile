VLOG = vlog
VSIM = vsim
VLIB = vlib
VCOVER = vcover

TOP = tb
COV_DB = coverage.ucdb
 
VSIM_OPT = -coverage -l runlog.txt $(TOP)

UVM_VER = uvm-1.1b
UVM_HOME = /cadtools/questa/questa_sim/verilog_src/$(UVM_VER)/src

INCDIR = +incdir+$(UVM_HOME) \
	+incdir+../lib \
	+incdir+../rtl/ \
	+incdir+../sv

SRC = $(TOP).sv

LOGS = transcript vsim.wlf compilelog.txt runlog.txt coverage.ucdb cov_log.txt
 
clean:
	rm -rf work $(LOGS)

compile: clean
	$(VLOG) -sv -cover sbcef -l compilelog.txt $(INCDIR) $(SRC)

run_cov: clean compile 
	$(VSIM) $(VSIM_OPT) \
	-do "add wave -r /$(TOP)/intf/*; add wave -r /$(TOP)/dut/master_DUT/current_state; run -all; coverage save $(COV_DB); coverage report -excluded -pragma; $(VCOVER) report $(COV_DB) -details"

run: clean compile 
	$(VSIM) $(VSIM_OPT) \
	-do "add wave -r /$(TOP)/intf/*; add wave -r /$(TOP)/dut/master_DUT/current_state; run -all"

coverage: clean compile
	$(VSIM) $(VSIM_OPT) \
	-do "run -all; coverage save $(COV_DB); coverage report -excluded -pragma; $(VCOVER) report $(COV_DB) -details"

report_txt: clean compile
	$(VSIM) $(VSIM_OPT) \
	-do "run -all; coverage save $(COV_DB); coverage report -excluded -pragma; $(VCOVER) report $(COV_DB) -details; $(VCOVER) report $(COV_DB) -file "cov_log.txt""

report_html: clean compile
	$(VSIM) $(VSIM_OPT) \
	-do "run -all; coverage save $(COV_DB); coverage report -excluded -pragma; $(VCOVER) report $(COV_DB) -details; $(VCOVER) report $(COV_DB) -html"
