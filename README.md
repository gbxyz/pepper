# Pepper - A command line EPP client

Pepper is a command-line client for the EPP protocol. It's written in Perl and uses the Net::EPP module.

## Usage

`pepper [--host=HOST] [--user=USER] [--pass=PASS]`

## Command Line

Once running, Pepper provides a simple command line interface. The available commands are listed below:

Command | Description
--------|------------
host HOST | set hostname
port PORT | set port (defaults to 700)
ssl on|off | enable/disable SSL (defaults to on)
timeout TIMEOUT | set timeout (default 5 seconds)
credentials USER PASS | set login credentials
connect | connect to server
login | log in
logout | log out
hello | retrieve greeting from server
poll req | request most recent poll message
poll ack ID | acknowledge message ID
check TYPE OBJECT | check availability of object (TYPE is one of domain, host, contact)
info TYPE OBJECT | retrieve object information (TYPE is one of domain, host, contact)
send FILE | send the contents of FILE
BEGIN | begin inputting a frame to send to the server, end with "END"
 