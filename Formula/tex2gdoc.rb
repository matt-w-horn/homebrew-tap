class Tex2gdoc < Formula
  include Language::Python::Virtualenv

  desc "Convert a LaTeX paper to a .docx for review in Word or Google Docs"
  homepage "https://github.com/matt-w-horn/tex2gdoc"
  url "https://github.com/matt-w-horn/tex2gdoc/releases/download/v0.1.0/tex2gdoc-0.1.0.tar.gz"
  sha256 "f2fd1479b266e908a516df21cdf608fcd2f065ca8c9d850d1b5299c5c371d9d0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # pandoc does the conversion, tectonic renders the TikZ figures pandoc cannot,
  # and poppler supplies pdftocairo to rasterize them. All three are required at
  # run time, not build time.
  depends_on "pandoc"
  depends_on "poppler"
  depends_on "python@3.14"
  depends_on "tectonic"

  # No resource blocks: the package declares no runtime Python dependencies.
  def install
    virtualenv_install_with_resources
  end

  test do
    # The calibration suite builds a .docx in memory for each of the 18 checks
    # and asserts the check reports FAIL. It needs neither pandoc nor a TeX
    # engine, so it is the part that always runs.
    assert_match "Self-test passed", shell_output("#{bin}/tex2gdoc --self-test")

    # A real conversion, to prove the wiring. Deliberately figureless: a paper
    # with no TikZ never invokes the TeX engine, so this stays offline and does
    # not wait on tectonic fetching a bundle.
    (testpath/"paper.tex").write <<~TEX
      \\documentclass{article}
      \\begin{document}
      \\section{Introduction}
      Enough prose for the body-text check to have something to measure, plus
      some inline math $\\lambda K < C$ to convert.
      \\end{document}
    TEX
    system bin/"tex2gdoc", "paper.tex"
    assert_path_exists testpath/"paper.docx"
  end
end
