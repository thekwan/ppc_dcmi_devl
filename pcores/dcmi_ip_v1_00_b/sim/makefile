all:
	@echo "Makefile to do RTL simulation with iSim tool"
	@echo "Run make with any of the following targets."
	@echo " "
	@echo " run      : Runs the HDL simulation models."
	@echo " clean    : Deletes all generated files and directories."
	@echo " "

EXE_FILE_NAME = isim.exe
#PRJ_FILE = design.prj
#TB_NAME = testbench
PRJ_FILE = frame_gen.prj
TB_NAME = frame_gen_tb

fuse: $(PRJ_FILE)
	@echo "**********************************************"
	@echo "* Generating HDL simulation models (fuse)    *"
	@echo "**********************************************"
	@fuse -incremental work.$(TB_NAME) work.glbl -prj $(PRJ_FILE) -o $(EXE_FILE_NAME)


run: fuse 
	@echo "**********************************************"
	@echo "* Runs HDL simulation models (isim)          *"
	@echo "**********************************************"
	@xterm -e ./$(EXE_FILE_NAME) -gui 

clean:
	@rm -rf *.log *.cmd *.wdb isim.exe isim *.xmsgs
	@echo "CLEAR ALL"
