
all: $(PROJ).bin

%.blif: %$(TOP_V_SUFFIX).v $(ADD_SRC) $(ADD_DEPS)
	yosys -ql $*.log $(if $(USE_ARACHNEPNR),-DUSE_ARACHNEPNR) -p 'synth_ice40 -top top -blif $@' $(YOSYS_READ_ARGS) $< $(ADD_SRC)

%.json: %$(TOP_V_SUFFIX).v $(ADD_SRC) $(ADD_DEPS)
	yosys -ql $*.log $(if $(USE_ARACHNEPNR),-DUSE_ARACHNEPNR) -p 'synth_ice40 -top top -json $@' $(YOSYS_READ_ARGS) $< $(ADD_SRC)

ifeq ($(USE_ARACHNEPNR),)
%.asc: $(PIN_DEF) %.json
	nextpnr-ice40 --$(DEVICE) $(if $(PACKAGE),--package $(PACKAGE)) $(if $(FREQ),--freq $(FREQ)) --json $(filter-out $<,$^) --pcf $< --asc $@
else
%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst up,,$(subst hx,,$(subst lp,,$(DEVICE)))) $(if $(PACKAGE),-P $(PACKAGE)) -o $@ -p $^
endif

%.bin: %.asc
	icepack $< $@

%_tb: %_tb.v %$(TOP_V_SUFFIX).v
	iverilog -g2012 -o $@ $^

%_tb.vcd: %_tb
	vvp -N $< +vcd=$@

%_syn.v: %.blif
	yosys -p 'read_blif -wideports $^; write_verilog $@'

%_syntb: %_tb.v %_syn.v
	iverilog -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

%_syntb.vcd: %_syntb
	vvp -N $< +vcd=$@

ifeq ($(MAKECMDGOALS), prog)
prog: $(PROJ).bin
ifeq ($(PROG),iceprog)
	iceprog $<
else ifeq ($(PROG), dfu)
	dfu-util -a 0 -D $< -R
else
$(error The PROG setting is not correct, choose either "iceprog" or "dfu")
endif
endif

ifeq ($(MAKECMDGOALS), sudo-prog)
sudo-prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
ifeq ($(PROG),iceprog)
	sudo iceprog $<
else ifeq ($(PROG), dfu)
	sudo dfu-util -a 0 -D $< -R
else
$(error The PROG setting is not correct, choose either "iceprog" or "dfu")
endif
endif

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).bin $(PROJ).json $(PROJ).log $(ADD_CLEAN)

.SECONDARY:
.PHONY: all prog clean
