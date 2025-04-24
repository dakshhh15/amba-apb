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

compile: 
	$(VLOG) -sv -cover sbcef -l compilelog.txt $(INCDIR) $(SRC)

run_cov: clean compile 
	$(VSIM) $(VSIM_OPT) \
	-do "add wave -r /$(TOP)/apb_if/*; add wave -r /$(TOP)/u_master/state; run -all; coverage save $(COV_DB); coverage report -excluded -pragma; $(VCOVER) report $(COV_DB) -details"

run: clean compile 
	$(VSIM) $(VSIM_OPT) \
	-do "add wave -r /$(TOP)/apb_if/*; add wave -r /$(TOP)/u_master/state; run -all"

coverage: clean compile
	$(VSIM) $(VSIM_OPT) \
	-do "run -all; coverage save $(COV_DB); coverage report -excluded -pragma; $(VCOVER) report $(COV_DB) -details"

report_txt:  clean compile
	$(VSIM) $(VSIM_OPT) \
	-do "run -all; coverage save $(COV_DB); coverage report -excluded -pragma; $(VCOVER) report $(COV_DB) -details; $(VCOVER) report $(COV_DB) -file "cov_log.txt""

report_html: clean compile
	$(VSIM) $(VSIM_OPT) \
	-do "run -all; coverage save $(COV_DB); coverage report -excluded -pragma; $(VCOVER) report $(COV_DB) -details; $(VCOVER) report $(COV_DB) -html"

coverage_1: compile
	$(VSIM) $(VSIM_OPT) \
	-do "run -all; coverage save coverage_1.ucdb; coverage report -excluded -pragma; $(VCOVER) report coverage_1.ucdb -details"

coverage_2: compile
	$(VSIM) $(VSIM_OPT) \
	-do "run -all; coverage save coverage_2.ucdb; coverage report -excluded -pragma; $(VCOVER) report coverage_2.ucdb -details"

coverage_3: compile
	$(VSIM) $(VSIM_OPT) \
	-do "run -all; coverage save coverage_3.ucdb; coverage report -excluded -pragma; $(VCOVER) report coverage_3.ucdb -details"

coverage_4: compile
	$(VSIM) $(VSIM_OPT) \
	-do "run -all; coverage save coverage_4.ucdb; coverage report -excluded -pragma; $(VCOVER) report coverage_4.ucdb -details"
