all: clean compile run wave

clean:
	rm -rf obj_dir
	rm -rf dump.vcd

compile:
	verilator --binary -f design.f

run:
	./obj_dir/VTopTB_RV64I

wave:
	gtkwave dump.vcd &
