SOPC2DTS ?= sopc2dts
QSYS_GENERATE ?= $(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-generate
QUARTUS_SH ?= $(QUARTUS_ROOTDIR)/bin/quartus_sh

dts: de0_nano_clock.dts
qsys: de0_nano_clock.sopcinfo
sof: buildstamp

buildstamp: de0-nano-clock.qpf de0-nano-clock.qsf de0-nano-clock.sv qsys
	$(QUARTUS_SH) --flow compile $<
	touch buildstamp

de0_nano_clock.sopcinfo: de0_nano_clock.qsys
	$(QSYS_GENERATE) $< --synthesis=VERILOG --simulation=VERILOG

de0_nano_clock.dts: de0_nano_clock.sopcinfo
	$(SOPC2DTS) -i $< -o $@ --bridge-removal all
