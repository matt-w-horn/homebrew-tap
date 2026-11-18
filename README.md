# matt-w-horn/tap

A Homebrew tap for Matt Horn's command line tools.

## Install

```bash
brew install matt-w-horn/tap/tex2gdoc
```

That one command also installs the tools the formula needs, so nothing else has
to be set up first.

Tapping separately works too, if you would rather type shorter names later:

```bash
brew tap matt-w-horn/tap
```

Or in a `Brewfile`:

```ruby
tap "matt-w-horn/tap"
brew "tex2gdoc"
```

## Formulae

| Formula | What it does | Pulls in |
|---|---|---|
| `tex2gdoc` | Converts a LaTeX paper to a `.docx` for review in Word or Google Docs, then checks the file it produced | pandoc, poppler, tectonic, python |
| `protonctl` | A local, read-only MCP server and command line tool for Proton Mail, Proton Drive and Proton Calendar. Unofficial: not affiliated with Proton AG | Rust, to build it |

Source and issues for `tex2gdoc` live at
[matt-w-horn/tex2gdoc](https://github.com/matt-w-horn/tex2gdoc), and for
`protonctl` at [matt-w-horn/protonctl](https://github.com/matt-w-horn/protonctl).
Report problems with a tool there. Report problems with the packaging here.

### protonctl needs one more command on a Mac

```bash
brew install matt-w-horn/tap/protonctl
```

```bash
protonctl-sign
```

`protonctl-sign` signs the installed binary with an identity made on your own
Mac, so that the Keychain trusts this binary and asks before it trusts
another. macOS asks to let `codesign` use the key: choose **Allow**, not
Always Allow. Run it again after each `brew upgrade protonctl`. Linux needs no
signing.

Then add protonctl to a host. Each command writes the path of the installed
protonctl into that host's settings. Quit Claude Desktop before the first:

```bash
protonctl connect claude-desktop
```

```bash
protonctl connect claude-code
```

The
[protonctl README](https://github.com/matt-w-horn/protonctl#install) has the
rest of the setup.

## Uninstall

```bash
brew uninstall tex2gdoc protonctl
```

```bash
brew untap matt-w-horn/tap
```

The dependencies stay installed. `brew autoremove` clears any that nothing else
needs.
