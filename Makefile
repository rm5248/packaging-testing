all:
	$(CC) -o hi-app hi.c

install:
	mkdir -p $(DESTDIR)/usr/bin
	install --mode=755 hi-app $(DESTDIR)/usr/bin
