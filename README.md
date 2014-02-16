# rum
===

## What is rum
..* event-based one process tcp redirector with socket file support and more listen ports/socket files, using libevent
..* mysql reverse proxy for more mysql servers (the key to select destination server is username send by client)

## Compilation
apt-get install libcdb-dev libevent-dev
make

## Usage
`./rum -s tcp:host:port [-s tcp:host:port [-s sock:path]] -d tcp:host:port [-b] [-m tcp:host:port] [-M /path/to/mysql.cdb]
    -s - listen host:port or sockfile (host muste be some ip address or 0.0.0.0 for all inerfaces)
    -d - destination host:port

    optional:
    -b - goto background
    -m - statistics port
    -M - enable handling of mysql connection with more destination servers, argument is path to cdb file
`

## Examples

redirect port 110 to pop3.example.net:110
`rum -s tcp:0.0.0.0:110 -d tcp:pop3.example.net:110 -b`

redirect port 3306 and /var/run/mysqld/mysqld.sock to 1.2.3.4:3306
`rum -s tcp:localhost:3306 -s sock:/var/run/mysqld/mysqld.sock -d tcp:1.2.3.4:3306 -b`

## Dns lookups
hostname -> ip resolving is done only once at start, it is not refreshed.

## MySQL reverse proxy feature
![alt text](https://github.com/websupport-sk/rum/raw/master/src/rum-mysql.png "this is how it works")
..* this feature is enabled when -M /path/to/cdb is used
..* cdb database is used for searching destination server from username send by client
..* hashed user passwords from every mysql server must be stored in cdb database to successfuly create connections - -d must be also used as default destination server (when user is not found in cdb database rum connect to this server, but auth always fails, we need to know user password)
..* in cdb file the format is:
    key -> value
    username -> password\0dst_server\0

Why is user password need ? there is explanation:
[http://forge.mysql.com/wiki/MySQL_Internals_ClientServer_Protocol#4.1_and_later]

## Creating cdb database for MySQL proxy
contrib/export_mysql_cdb.pl is perl script which can be run every 1 minute or so. cdb file is automatically regenerated from mysql server list and rum dont need restart.

## TODO
 global and per ip connetion limit
..* drop client connections if too many bufferevents are in connecting state and make it configurable from command line
..* change open fds by setrlimit after start
..* better log/debug messages
..* modularize mysql proxy feature as shared object and use flag for make to enable it at compile time
..* configurable dns refresh

