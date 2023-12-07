#Makefile 
RTL = ../rtl/*.v
LIB = coin 

COVOP = -coveropt 3 +cover +acc
TB1 = ../tb/tb_coincol1.v
TB2 = ../tb/tb_coincol2.v
TB3 = ../tb/tb_coincol3.v

VSIMOPT = -coverage -vopt coin.tb_coincol
VSIMCOV = coverage save -onexit -codeAll coincov
VSIMBATCH = -c -do "$(VSIMCOV); run -all; exit" 



lib:
	vlib $(LIB)
	vmap work $(LIB)

help:
	@echo ===========================================================================================================================
	@echo " USAGE   	--  make target"
	@echo " clean   	=>  clean the earlier log and intermediate files."
	@echo " lib             =>  Create library and logical mapping."									   
	@echo " run_tb1        	=>  To compile RTL, TB & simulate the RTL using TB in batch mode." 
	@echo " run_tb2        	=>  To compile RTL, TB & simulate the RTL using TB in batch mode." 
	@echo " run_tb3        	=>  To compile RTL, TB & simulate the RTL using TB in batch mode." 
	@echo " run1       	=>  To clean, create libray, logical mapping, compile the source codes & simulate the RTL in batch mode."        
	@echo " run2       	=>  To clean, create libray, logical mapping, compile the source codes & simulate the RTL in batch mode."        
	@echo " run3       	=>  To clean, create libray, logical mapping, compile the source codes & simulate the RTL in batch mode."        
	@echo " html       	=>  To display html report using browser"        
	@echo " report       	=>  To create the html coverage report from the coverage database file"        
	@echo ===========================================================================================================================


run_tb1:
	vlog -work coin $(COVOP) $(RTL) $(TB1)
	vsim $(VSIMOPT) $(VSIMBATCH)

run_tb2:
	vlog -work coin $(COVOP) $(RTL) $(TB2)
	vsim  $(VSIMOPT) $(VSIMBATCH)

run_tb3:
	vlog -work coin $(COVOP) $(RTL) $(TB3)
	vsim  $(VSIMOPT) $(VSIMBATCH)

report:
	vcover report  -details -codeAll -html coincov

run1: clean lib run_tb1 report html 
run2: clean lib run_tb2 report html
run3: clean lib run_tb3 report html

html:
	firefox covhtmlreport/index.html&

clean:
	rm -rf modelsim.ini transcript coincov
	rm -rf $(LIB)
	clear


