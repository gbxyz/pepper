# NAME

Pepper - A command line EPP client

# DESCRIPTION

Pepper is a command-line client for the EPP protocol. It's written in Perl and uses the Net::EPP module.

# USAGE

pepper \[--host=HOST\] \[--port=PORT\] \[--timeout=TIMEOUT\] \[--user=USER\] \[--pass=PASS\] \[--exec=COMMAND\]

- --host=HOST

    Specify the host name to connect to.

- --port=PORT

    Specify the port. Defaults to 700.

- --timeout=TIMEOUT

    Specify the timeout. Defaults to 3.

- --user=USER

    Specify user ID.

- --pass=PASS

    Specify password.

- --exec=COMMAND

    Specify command to execute. May be used multiple times. See [SYNTAX](https://metacpan.org/pod/SYNTAX) for more details.

# SYNTAX

Once running, Pepper provides a simple command line interface. The available commands are listed below:

- host HOST

    set hostname

- port PORT

    set port (defaults to 700)

- ssl on|off

    enable/disable SSL (defaults to on)

- timeout TIMEOUT

    set timeout (default 5 seconds)

- id USER

    set username

- pw PASS

    set password

- connect

    connect to server

- login

    log in

- logout

    log out

- hello

    retrieve greeting from server

- poll req

    request most recent poll message

- poll ack ID

    acknowledge message ID

- check TYPE OBJECT

    check availability of object (TYPE is one of domain, host, contact)

- info TYPE OBJECT

    retrieve object information (TYPE is one of domain, host, contact)

- send FILE

    send the contents of FILE

- BEGIN

    begin inputting a frame to send to the server, end with "END"

- keepalive SECS

    keep the session alive by pinging the server every SECS seconds. Use zero to cancel

- transfer PARAMS

    object transfer management (see below)

- clone TYPE OLD NEW

    clone a domain or contact object OLD into a new object identified by NEW

- delete TYPE ID

    delete an object

- renew DOMAIN PERIOD

    renew a domain (1 year by default)

- create host PARAMS

    create a host object (see below)

- exit

    quit the program (logging out if necessary)

## OBJECT TRANSFERS

Object transfers may be managed with the transfer command. Usage:

    transfer TYPE OBJECT CMD [AUTHINFO [PERIOD]]
    

where:

- TYPE

    one of (domain, contact)

- OBJECT

    domain name or contact ID

- CMD

    one of (request, query, approve, reject, cancel)

- AUTHINFO

    authInfo code (used with request only)

- PERIOD

    additional validity period (used with domain request only)

## CREATING DOMAIN AND CONTACT OBJECTS

Domains and contacts can be created using the "clone" command.

## CREATING HOST OBJECTS

Syntax:

    create host HOSTNAME [IP [IP [IP [...]]]]

Create a host object with the specified HOSTNAME. IP address may also be
specified: IPv4 and IPv6 addresses are automatically detected.

# LICENSE

Copyright CentralNic Group plc.

This program is Free Software; you can use it and/or modify it under the same terms as Perl itself.
