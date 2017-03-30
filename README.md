# NAME

Pepper - A command line EPP client

# DESCRIPTION

Pepper is a command-line client for the EPP protocol. It's written in Perl and uses the Net::EPP module.

# USAGE

        pepper [--host=HOST] [--port=PORT] [--timeout=TIMEOUT] [--user=USER] [--pass=PASS] [--exec=COMMAND]

- `--host=HOST`

    Specify the host name to connect to.

- `--port=PORT`

    Specify the port. Defaults to 700.

- `--timeout=TIMEOUT`

    Specify the timeout. Defaults to 3.

- `--user=USER`

    Specify user ID.

- `--pass=PASS`

    Specify password.

- `--exec=COMMAND`

    Specify command to execute. May be used multiple times. See [SYNTAX](https://metacpan.org/pod/SYNTAX) for more details.

- `--insecure`

    Disable SSL certificate checks.

- `--lang=LANG`

    Specify language.

# SYNTAX

Once running, Pepper provides a simple command line interface. The available commands are listed below:

- `help`

    display manual

- `host HOST`

    set hostname

- `port PORT`

    set port (defaults to 700)

- `ssl on|off`

    enable/disable SSL (defaults to on)

- `timeout TIMEOUT`

    set timeout (default 5 seconds)

- `id USER`

    set username

- `pw PASS`

    set password

- `connect`

    connect to server

- `login`

    log in

- `logout`

    log out

- `hello`

    retrieve greeting from server

- `poll req`

    request most recent poll message

- `poll ack ID`

    acknowledge message `ID`

- `check TYPE OBJECT`

    check availability of object (`TYPE` is one of `domain`, `host`, `contact`, `claims`, `fee`). See ["CLAIMS AND FEE CHECKS"](#claims-and-fee-checks) for more information about the latter two.

- `info TYPE OBJECT`

    retrieve object information (`TYPE` is one of `domain`, `host`, `contact`)

- `send FILE`

    send the contents of `FILE`

- `BEGIN`

    begin inputting a frame to send to the server, end with "`END`"

- `edit`

    Invoke `$EDITOR` and send the resulting file

- `transfer PARAMS`

    object transfer management See ["OBJECT TRANSFERS"](#object-transfers) for more information.

- `clone TYPE OLD NEW`

    clone a domain or contact object `OLD` into a new object identified by `NEW` (`TYPE` is one of `domain`, `contact`)

- `delete TYPE ID`

    delete an object (`TYPE` is one of `domain`, `host`, `contact`)

- `renew DOMAIN PERIOD [EXPDATE]`

    renew a domain (1 year by default). If you do not provide the `CUREXPDATE` argument, pepper will perform an `<info>` command to get it from the server.

- `restore DOMAIN`

    submit an RGP restore request for a domain

- `create host PARAMS`

    create a host object. See ["CREATING HOST OBJECTS"](#creating-host-objects) for more information.

- `exit`

    quit the program (logging out if necessary)

## OBJECT UPDATES

Objects may be updated using the `update` command.

### Domain Updates

    update domain HOSTNAME CHANGES

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

- `TYPE`

    one of `domain`, `contact`

- `OBJECT`

    domain name or contact ID

- `CMD`

    one of (`request`, `query`, `approve`, `reject`, `cancel`)

- `AUTHINFO`

    authInfo code (used with `request` only)

- `PERIOD`

    additional validity period (used with domain `request` only)

## CLAIMS AND FEE CHECKS

Pepper provides limited support for the the launch and fee extensions:

### CLAIMS CHECK

The following command will extend the standard &lt;check> command to perform
a claims check as per Section 3.1.1. of [draft-ietf-eppext-launchphase](https://metacpan.org/pod/draft-ietf-eppext-launchphase).

        pepper> check claims example.xyz

### FEE CHECK

The following command will extend the standard &lt;check> command to perform
a fee check as per Section 3.1.1. of [draft-brown-epp-fees-02](https://metacpan.org/pod/draft-brown-epp-fees-02).

        pepper> check fee example.xyz COMMAND [CURRENCY [PERIOD]]

`COMMAND` must be one of: `create`, `renew`, `transfer`, `restore`.
`CURRENCY` is OPTIONAL but if provided, must be a three-character currency code.
`PERIOD` is also OPTIONAL but if provided, must be an integer between 1 and 99.

## CREATING DOMAIN AND CONTACT OBJECTS

Domains and contacts can be created using the `clone` command.

## CREATING HOST OBJECTS

Syntax:

    create host HOSTNAME [IP [IP [IP [...]]]]

Create a host object with the specified `HOSTNAME`. IP address may also be
specified: IPv4 and IPv6 addresses are automatically detected.

# INSTALLATION

Pepper requires that the following Perl modules be installed:

- `Term::ReadLine::Gnu` (and `Term::ReadLine`)
- `Net::EPP::Simple` (from `Net::EPP`, in turn requires `IO::Socket::SSL` and `XML::LibXML`)
- `Text::ParseWords`
- `Mozilla::CA`

This can be installed using one of the various CPAN clients, or as packages from your operating system vendor.

# LICENSE

Copyright CentralNic Group plc.

This program is Free Software; you can use it and/or modify it under the same terms as Perl itself.
