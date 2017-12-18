dts: de0_nano_clock.dts

SOPC2DTS ?= sopc2dts

de0_nano_clock.dts: de0_nano_clock.sopcinfo
	$(SOPC2DTS) -i $< -o $@ --bridge-removal all
