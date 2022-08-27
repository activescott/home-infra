# mail-relay container

The goal here is to setup a way for other containers and infra to send notifications via email.

## Todo

- Postfix Container
- Set it up so any machine on trusted subnet can send mail:
  - [`"mynetworks_style = subnet"`](https://www.postfix.org/postconf.5.html#mynetworks_style) /might/ be enough
- Somehow can see logs?
  - Future: syslog
- Setup to use certs
- Creating SPF and DKIM: https://www.linuxbabe.com/mail-server/setting-up-dkim-and-spf
- Create DMARC: https://www.linuxbabe.com/mail-server/create-dmarc-record
- [+] Make sure SPF, DKIM, DMARC all work on a dynamic IP
  - use a:<hostname>

## References

- Simple postfix relay host: https://github.com/bokysan/docker-postfix
- DKIM tools:

  - DNS: https://mxtoolbox.com/dkim.aspx
  - Copy a message in: https://www.appmaildev.com/en/dkim

- Postfix Basic Configuration: https://www.postfix.org/BASIC_CONFIGURATION_README.html
- Postfix container: https://github.com/webdevops/Dockerfile
  - Container docs: https://dockerfile.readthedocs.io/en/latest/content/DockerImages/dockerfiles/postfix.html
- SPF: http://www.open-spf.org/SPF_Record_Syntax/

### Setup

- See Configuring Postfix at https://www.redhat.com/sysadmin/install-configure-postfix

### Testing

#### Testing DKIM:

Get into the container and run this:

```
opendkim-testkey -d activescott.com -s mail -k /etc/opendkim/keys/activescott.com.private
```

- See Testing Postfix at https://www.redhat.com/sysadmin/install-configure-postfix
- https://www.mail-tester.com/

```sh
telnet bitbox.activescott.com 587
```

```sh
HELO mail-relay.activescott.com
MAIL FROM: tester@activescott.com
RCPT TO: scott@willeke.com
DATA

Subject: This is a test!

Hello,

Testing my mail-relay.

.

QUIT
```

### ISP Blocking outgoing Port 25 Access

My internet provier (Ziply) does not allow connecting from a residential dynamic IP account to an outgoing port 25, but they do allow connecting to 587 (SMTP+TLS)[1](https://www.reddit.com/r/ZiplyFiber/comments/gt5usi/comment/fsc9uv3/?utm_source=share&utm_medium=web2x&context=3), [2](https://www.reddit.com/r/ZiplyFiber/comments/j2efkd/port_25_question_again_and_forever_probably/) (note that they say you can use static ip, but that requires paying for a business account [3](https://www.reddit.com/r/ZiplyFiber/comments/h8o87o/comment/hphwiky/?utm_source=share&utm_medium=web2x&context=3)). So I saw errors like this:

```
2022-08-26T21:21:21.212121-07:00 INFO    postfix/smtp[796]: connect to alt2.aspmx.l.google.com[64.233.171.26]:25: Operation timed out
```

### Amazon SES SMTP Relay

Amazon allows using SES for an SMTP Rely and has postfix specific setup guide at https://docs.aws.amazon.com/ses/latest/dg/postfix.html

SPF: https://docs.aws.amazon.com/ses/latest/dg/send-email-authentication-spf.html (tldr `v=spf1 include:amazonses.com ~all`)

There are several things to setup in Amazon SES, mostly DNS entries and to create an IAM user for SMTP creds.
More at https://github.com/bokysan/docker-postfix#relaying-messages-through-amazons-ses
