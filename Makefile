PREFIX=/usr/local/bin


trim:
	ghc trim.hs -O2

install : trim
	cp trim $(PREFIX)/.


clean: 
	rm trim *.o *.hi
