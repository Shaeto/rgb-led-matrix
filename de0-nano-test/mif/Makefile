all: 64_32_h1_v2.mif 64_32_h1_v1.mif 32_32_h1_v1.mif 32_16_h1_v1.mif 32_16_h1_v2.mif test.mif

64_32_h1_v1.mif: 32-32-smile-icon.png
	./png2mif.pl $< 64 32 1 1 > $@

64_32_h1_v2.mif: 64-64-smile-icon.png
	./png2mif.pl $< 64 32 1 2 > $@

32_32_h1_v1.mif: 32-32-smile-icon.png
	./png2mif.pl $< 32 32 1 1 > $@

32_16_h1_v1.mif: 16-16-smile-icon.png
	./png2mif.pl $< 32 16 1 1 > $@

32_16_h1_v2.mif: 32-32-smile-icon.png
	./png2mif.pl $< 32 16 1 2 > $@

clean:
	rm -f *.mif

test.mif: test.png
	./png2mif.pl $< 64 32 1 2 > $@
