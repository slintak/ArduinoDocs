INKSCAPE = /Applications/Inkscape.app/Contents/Resources/bin/inkscape
IMGWIDTH = 400

%.png: %.svg
	$(INKSCAPE) -z -w $(IMGWIDTH) -e $@ $<

all: $(addsuffix .png, $(basename $(wildcard *.svg)))
