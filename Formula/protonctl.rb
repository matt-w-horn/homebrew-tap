class Protonctl < Formula
  desc "Local, read-only MCP server and CLI for Proton Mail, Drive and Calendar"
  homepage "https://github.com/matt-w-horn/protonctl"
  url "https://github.com/matt-w-horn/protonctl/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "dba04ab5c038bf3e5d19801b2b55cece266df1091d88a884529e6772dbbea4b9"
  license "Apache-2.0"
  head "https://github.com/matt-w-horn/protonctl.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # On a Mac the Keychain trusts protonctl by its signature. Homebrew's
    # build is signed ad hoc, so every upgrade would bring the Keychain's
    # prompts back, and a user who approves them from habit would also
    # approve a replaced binary. protonctl-sign signs the installed binary
    # with an identity made on the user's own Mac and with the hardened
    # runtime; it is protonctl's own scripts/sign.sh. It cannot run here: it
    # needs the login keychain, and macOS asks the user before the key signs.
    return unless OS.mac?

    libexec.install "scripts/sign.sh"
    (bin/"protonctl-sign").write <<~SH
      #!/bin/sh
      exec "#{libexec}/sign.sh" "#{bin}/protonctl"
    SH
    chmod 0755, bin/"protonctl-sign"
  end

  def caveats
    s = ""
    on_macos do
      s += <<~EOS
        Sign protonctl before you use it, and again after each upgrade:
          protonctl-sign
        macOS asks to let codesign use the key "protonctl": choose Allow,
        not Always Allow. Until it is signed, the Keychain asks again for
        every item after each upgrade, and protonctl runs without the
        hardened runtime.
      EOS
    end
    on_linux do
      s += <<~EOS
        Nothing is signed on Linux. To read PDF and Word files, protonctl
        runs /usr/bin/pdftotext, /usr/bin/pdftoppm and /usr/bin/pandoc:
        install poppler-utils and pandoc with your distribution's package
        manager. Homebrew's copies are not the ones it runs.
      EOS
    end
    s + <<~EOS
      protonctl is unofficial: it is not affiliated with, endorsed or
      sponsored by Proton AG. Setup: https://github.com/matt-w-horn/protonctl#readme
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/protonctl --version")

    # The server over stdio, as a host starts it: it answers initialize,
    # lists its tools, and stops when stdin closes. No Proton account, no
    # Keychain item and no network is needed for that.
    requests = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"brew-test","version":"0"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized"}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output("#{bin}/protonctl serve", requests, 0)
    assert_match "search_threads", output
    assert_match "read-only", output
  end
end
