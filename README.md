# dotfiles

personal configuration files

## install

Run script below:

```sh
bash -c "$(curl -L bit.ly/kawarimidots)"
```

This link leads to
`https://raw.githubusercontent.com/kawarimidoll/dotfiles/master/install.sh`

### note

When you first run on macOS, run `git --version` first to make sure command line
tools are installed.

Run `container system kernel set --recommended` after `container` CLI is
installed using nix because it doesn't configure guest Linux kernel.
