dts: de0_nano_clock.dts

SOPC2DTS ?= sopc2dts
QSYS_GENERATE ?= $(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-generate

de0_nano_clock.sopcinfo: de0_nano_clock.qsys
	$(QSYS_GENERATE) $< --synthesis=VERILOG --simulation=VERILOG

de0_nano_clock.dts: de0_nano_clock.sopcinfo
	$(SOPC2DTS) -i $< -o $@ --bridge-removal all
