CC=gcc
LD=ld

LDFLAGS=-levent -lrt -lcdb -lm
CFLAGS=-Wall -g -g 
#CFLAGS=-Wall -g -g

all: rum 

rum: rum.o socket.o default_callback.o mysql_callback.o stats_callback.o mysql_cdb.o mysql_mitm.o parse_arg.o mysql_password/sha1.o mysql_password.o
	$(CC) rum.o socket.o default_callback.o mysql_callback.o stats_callback.o mysql_cdb.o mysql_mitm.o mysql_password/sha1.o mysql_password.o parse_arg.o $(LDFLAGS) -o rum
	#strip rum

.PHONY : clean

clean: cleanrum
cleanall: cleanrum

cleanrum:
	-rm rum *.o mysql_password/*.o
