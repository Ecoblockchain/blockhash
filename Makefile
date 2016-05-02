#
# Perceptual image hash calculation library based on algorithm descibed in
# Block Mean Value Based Image Perceptual Hashing by Bian Yang, Fan Gu and Xiamu Niu
#
# Copyright 2014-2015 Commons Machinery http://commonsmachinery.se/
# Distributed under an MIT license, please see LICENSE in the top dir.
#

CC=g++
LD=g++

ifeq ("$(DEBUG)","1")
CFLAGS:=-g3 -ggdb
else
CFLAGS:=-O3
endif

CFLAGS+=-fno-common -fmax-errors=2 -DHAVE_MACHINE_ENDIAN_H

CFLAGS+=$(shell pkg-config MagickWand --cflags) $(shell pkg-config pHash --cflags)
CFLAGS+=$(shell pkg-config libavformat-ffmpeg --cflags)
CFLAGS+=$(shell pkg-config libavcodec-ffmpeg --cflags)
CFLAGS+=$(shell pkg-config libavutil-ffmpeg --cflags)
CFLAGS+=$(shell pkg-config libswscale-ffmpeg --cflags)

LDFLAGS:=-L. -L/usr/lib

LIBS:= 	-lblockhash \
	$(shell pkg-config MagickWand --libs) \
	$(shell pkg-config libavformat-ffmpeg --libs) \
	$(shell pkg-config libavcodec-ffmpeg --libs) \
	$(shell pkg-config libavutil-ffmpeg --libs) \
	$(shell pkg-config libswscale-ffmpeg --libs) \
	$(shell pkg-config pHash --libs)

ARFLAGS:=

.PHONY: all build clean rebuild install

all: build

build: blockhash

clean:
	-rm -f *.o
	-rm -f libblockhash.a
	-rm -f blockhash

rebuild: clean build
	
install: blockhash
	install -c -t /usr/local/bin blockhash
	
blockhash: libblockhash.a main.o misc.o process_image.o process_video.o
	$(LD) -o $@ $(LDFLAGS)  $^ $(LIBS)
	
libblockhash.a : blockhash.o
	$(AR) rvs $(ARFLAGS) $@ $^
	
%.o: %.c
	$(CC) -o $@ $(CFLAGS)-c $<

