# Prosody Docker

Docker image for [Prosody](https://prosody.im/) XMPP server.

## Getting started

To build this image run the following command:

```bash
$ docker build -r prosody:latest
```

Once build, you can tag it with the name you want and publish it on the docker repo you want.

## Modules installed

Some additionnal modules are installed on this image. They are available in `/usr/share/prosody/modules`.
If you change the prosody config don't forget to include them if you want to use them: `plugin_paths = { "/usr/share/prosody/modules" }`

All modules developed for [jitsi](https://meet.jit.si/) are installed. Also the [mod_token_affiliation](https://raw.githubusercontent.com/emrahcom/emrah-buster-templates/6ae86bbff1459b669b311f3ec00946921cd683c9/machines/eb-jitsi/usr/share/jitsi-meet/prosody-plugins/mod_token_affiliation.lua) module is installed.



## License

This work is released under the MIT License (see [LICENSE](./LICENSE)).


