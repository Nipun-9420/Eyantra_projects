# Makefile

RTL = ../rtl/dff.v 
work = dff #library name
TB = ../tb/tb_dff.v 

VSIMBATCH = -c -do "run -all; exit"

lib:
	vlib $(work)
	vmap work $(work)
cmp:
	vlog -work $(work) $(RTL) $(TB) 

help:
	@echo ===========================================================================================================================
	@echo " USAGE   	--  make target"
	@echo " clean   	=>  clean the earlier log and intermediate files."
	@echo " lib             =>  Create library and logical mapping."									   
	@echo " cmp             =>  To compile the RTL & TB in batch mode." 
	@echo " run_sim        	=>  To simulate the RTL using TB in batch mode." 
	@echo " comp       	=>  To create libray, logical mapping & compile the source codes in batch mode." 
	@echo " run_all       	=>  To clean, create libray, logical mapping, compile the source codes & simulate the RTL in batch mode."        
	@echo =========================================================================================================================== 
 
 
run_sim:
	vsim -vopt dff.tb_dff $(VSIMBATCH)


clean:
	rm -f modelsim.ini transcript 
	rm -rf $(work)
	clear

comp: lib cmp

run_all: clean lib cmp run_sim

