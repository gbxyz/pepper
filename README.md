# NAME

Pepper - A command line EPP client

# DESCRIPTION

Pepper is a command-line client for the EPP protocol. It's written in Perl and uses the Net::EPP module.

# USAGE

        pepper [OPTIONS]

Available command-line options:

- `--host=HOST` - sets the host to connect to.
- `--port=PORT` - sets the port. Defaults to 700.
- `--timeout=TIMEOUT` - sets the timeout. Defaults to 3.
- `--user=USER` - sets the client ID.
- `--pass=PASS` - sets the client password.
- `--cert=FILE` - specify the client certificate to use to connect.
- `--key=FILE` - specify the private key for the client certificate.
- `--exec=COMMAND` - specify a command to execute. If not provided, pepper goes into interactive mode.
- `--insecure` - disable SSL certificate checks.
- `--lang=LANG` - set the language when logging in.
- `--debug` - debug mode, makes `Net::EPP::Simple` verbose.

# SYNTAX

Once running, Pepper provides a simple command line interface. The available commands are listed below.

## Getting Help

Use `help COMMAND` at any time to get information about that command. Where a command supports different object types (ie domain, host, contact), use `help command-type`, ie `help create-domain`.

## Connection Management

- `host HOST` - sets the host to connect to.
- `port PORT` - sets the port. Defaults to 700.
- `ssl on|off` - enable/disable SSL (default is on)
- `key FILE` - sets the private key
- `cert FILE` - sets the client certificate.
- `timeout TIMEOUT` - sets the timeout
- `connect` - connect to the server.
- `hello` - gets the greeting from server.
- `exit` - quit the program (logging out if necessary)

## Session Management

- `id USER` - sets the client ID.
- `pw PASS` - sets the client password.
- `login` - log in.
- `logout` - log out.
- `poll req` - requests the most recent poll message.
- `poll ack ID` - acknowledge the poll message with ID `ID`.

## Query Commands

- `check TYPE OBJECT` - checks the availability of an object. `TYPE` is one of `domain`, `host`, `contact`, `claims` or `fee`. See ["Claims and fee Checks"](#claims-and-fee-checks) for more information about the latter two.
- `info TYPE OBJECT` - get object information. `TYPE` is one of `domain`, `host`, `contact`.

## Transform Commands

- `create domain PARAMS` - create a domain object. See ["Creating Domain Objects"](#creating-domain-objects) for more information.
- `create host PARAMS` - create a host object. See ["Creating Host Objects"](#creating-host-objects) for more information.
- `clone TYPE OLD NEW` - clone a domain or contact object `OLD` into a new object identified by `NEW`. `TYPE` is one of `domain` or `contact`.
- `update TYPE CHANGES` - update an object. `TYPE` is one of `domain`, `host`, or `contact`. See ["Object Updates"](#object-updates) for further information.
- `renew DOMAIN PERIOD [EXDATE]` - renew a domain (1 year by default). If you do not provide the `EXDATE` argument, pepper will perform an `<info>` command to get it from the server.
- `transfer PARAMS` - object transfer management See ["Object Transfers"](#object-transfers) for more information.
- `delete TYPE ID` - delete an object. `TYPE` is one of `domain`, `host`, or `contact`.
- `restore DOMAIN` - submit an RGP restore request for a domain.

## Miscellaneous Commands

- `send FILE` - send the contents of `FILE`.
- `BEGIN` - begin inputting a frame to send to the server, end with "`END`".
- `edit` - Invoke `$EDITOR` and send the resulting file.

## Claims and fee Checks

Pepper provides limited support for the the launch and fee extensions:

### Claims Check

The following command will extend the standard &lt;check> command to perform
a claims check as per Section 3.1.1. of [draft-ietf-eppext-launchphase](https://metacpan.org/pod/draft-ietf-eppext-launchphase).

        pepper> check claims example.xyz

### Fee Check

The following command will extend the standard &lt;check> command to perform
a fee check as per Section 3.1.1. of [draft-brown-epp-fees-02](https://metacpan.org/pod/draft-brown-epp-fees-02).

        pepper> check fee example.xyz COMMAND [CURRENCY [PERIOD]]

`COMMAND` must be one of: `create`, `renew`, `transfer`, or `restore`.
`CURRENCY` is OPTIONAL but if provided, must be a three-character currency code.
`PERIOD` is also OPTIONAL but if provided, must be an integer between 1 and 99.

## Creating Objects

### Creating Domain Objects

There are two ways of creating a domain:

        clone domain OLD NEW

This command creates the domain `NEW` using the same contacts and nameservers as `OLD`.

        create domain DOMAIN PARAMS

This command creates a domain according to the parameters specified after the domain. `PARAMS` consists of pairs of name and value pairs as follows:

- `period PERIOD` - the registration period. Defaults to 1 year.
- `registrant ID` - the registrant.
- `(admin|tech|billing) ID` - the admin contact
- `ns HOST` - add a nameserver
- `authInfo pw` - authInfo code. A random string will be used if not provided.

### Creating Host Objects

Syntax:

        create host HOSTNAME [IP [IP [IP [...]]]]

Create a host object with the specified `HOSTNAME`. IP address may also be
specified: IPv4 and IPv6 addresses are automatically detected.

### Creating Contact Objects

Contact objects can currently only be created using the `clone` command.

## Object Updates

Objects may be updated using the `update` command.

### Domain Updates

        update domain DOMAIN CHANGES

The `CHANGES` argument consists of groups of three values: an action (ie `add`, `rem` or `chg`), followed by a property name (e.g. `ns`, a contact type (such as `admin`, `tech` or `billing`) or `status`), followed by a value.

Example:

        update domain example.com add ns ns0.example.com

        update domain example.com rem ns ns0.example.com

        update domain example.com add status clientUpdateProhibited

        update domain example.com rem status clientHold

        update domain example.com add admin H12345

        update domain example.com rem tech H54321

        update domain example.com chg registrant H54321

        update domain example.cm chg authinfo foo2bar

Multiple changes can be combined in a single command:

        update domain example.com add status clientUpdateProhibited rem ns ns0.example.com chg registrant H54321

### Host Updates

Syntax:

        update host HOSTNAME CHANGES

The `CHANGES` argument consists of groups of three values: an action (ie `add`, `rem` or `chg`), followed by a property name (ie `addr`, `status` or `name`), followed by a value.

Examples:

        update host ns0.example.com add status clientUpdateProhibited

        update host ns0.example.com rem addr 10.0.0.1

        update host ns0.example.com chg name ns0.example.net

Multiple changes can be combined in a single command:

        update host ns0.example.com add status clientUpdateProhibited rem addr 10.0.0.1 add addr 1::1 chg name ns0.example.net

### Contact Updates

Not currently implemented.

## OBJECT TRANSFERS

Object transfers may be managed with the `transfer` command. Usage:

        transfer TYPE OBJECT CMD [AUTHINFO [PERIOD]]

where:

- `TYPE` - `domain` or `contact`
- `OBJECT` - domain name or contact ID
- `CMD` - one of (`request`, `query`, `approve`, `reject`, or `cancel`)
- `AUTHINFO` - authInfo code (used with `request` only)
- `PERIOD` - additional validity period (used with domain `request` only)

# INSTALLATION

Pepper uses these modules:

- [Term::ANSIColor](https://metacpan.org/pod/Term::ANSIColor)
- [Term::ReadLine::Gnu](https://metacpan.org/pod/Term::ReadLine::Gnu) (and [Term::ReadLine](https://metacpan.org/pod/Term::ReadLine))
- [Net::EPP::Simple](https://metacpan.org/pod/Net::EPP::Simple) (from [Net::EPP](https://metacpan.org/pod/Net::EPP), which in turn uses [IO::Socket::SSL](https://metacpan.org/pod/IO::Socket::SSL) and [XML::LibXML](https://metacpan.org/pod/XML::LibXML)). Pepper usually requires the most recent "unstable" version which can be obtained from [https://gitlab.centralnic.com/centralnic/perl-net-epp](https://gitlab.centralnic.com/centralnic/perl-net-epp).
- [Text::ParseWords](https://metacpan.org/pod/Text::ParseWords)
- [Mozilla::CA](https://metacpan.org/pod/Mozilla::CA)

They can be installed using one of the various CPAN clients, or as packages from your operating system vendor.

# LICENSE

Copyright CentralNic Group plc.

This program is Free Software; you can use it and/or modify it under the same terms as Perl itself.
