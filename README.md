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

Source and issues for `tex2gdoc` live at
[matt-w-horn/tex2gdoc](https://github.com/matt-w-horn/tex2gdoc). Report problems
with the tool there. Report problems with the packaging here.

## Uninstall

```bash
brew uninstall tex2gdoc
```

```bash
brew untap matt-w-horn/tap
```

The dependencies stay installed. `brew autoremove` clears any that nothing else
needs.
