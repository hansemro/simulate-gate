SPICE=$(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
NAME=sky130_fd_sc_hd__nand2_1
PORT:=$(shell grep $(NAME) $(SPICE) | sed -E "s/.subckt [^ ]+ //")

all: sim

show_cells:
	klayout -l $(PDK_ROOT)/sky130A/libs.tech/klayout/sky130A.lyp $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds

magic:
	# for rcfile to work PDK_ROOT must be set correctly
	magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(NAME).mag
	# now in the command window type:
	# extract
	# ext2spice lvs
	# ext2spice cthresh 0
	# ext2spice

simulation.spice: pre.spice post.spice
	# build a simulation with pre and post.spice
	@cat pre.spice > $@
	@echo ".INC $(SPICE)" >> $@
	@echo "Xcell $(PORT) $(NAME)" >> $@
	@cat post.spice >> $@

sim: simulation.spice
	# run the simulation
	ngspice $^

clean:
	rm -f $(NAME).spice model.spice $(NAME).ext
	rm simulation.spice

phony: clean
