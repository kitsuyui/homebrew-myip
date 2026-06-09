# homebrew-myip

Homebrew Installation of [myip](https://github.com/kitsuyui/myip).

## Installation

```console
$ brew tap kitsuyui/homebrew-myip
$ brew install myip
```

## Supported platforms

This formula installs prebuilt macOS binaries for Apple Silicon and 64-bit Intel Macs.
Other architectures are not supported by the binary formula.

## Update

```console
$ ./generate.sh
```

## Development

Install [lefthook](https://github.com/evilmartians/lefthook) and register the Git hooks:

```console
$ lefthook install
```

This sets up the following local hooks:

- **pre-commit / pre-push**: runs `shellcheck generate.sh` to catch shell script issues before committing or pushing.

> **Note:** CI also runs a full Homebrew install test on macOS runners, which is not mirrored locally because it requires a macOS environment with Homebrew.

## License

[BSD 2-clause "Simplified" License](https://spdx.org/licenses/BSD-2-Clause)
