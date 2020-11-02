require 'formula'

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb

class Coursier < Formula
  desc "Coursier launcher."
  homepage "https://get-coursier.io"
  version "2.0.6"
  url "https://github.com/coursier/coursier/releases/download/v2.0.6/cs-x86_64-apple-darwin"
  sha256 "236a4b1a7b05e2ad0152da6a7597bcef48bad98f3c70e896f3047836bad9c9aa"
  bottle :unneeded

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.0.6/coursier"
    sha256 "32728210563ad8b1f5f2ba836bdcef9fe7f465dd219ec3dc07b72842e23ae07d"
  end

  option "without-zsh-completions", "Disable zsh completion installation"

  depends_on :java => "1.8+"

  def install
    bin.install 'cs-x86_64-apple-darwin' => "cs"
    resource("jar-launcher").stage { bin.install "coursier" }

    unless build.without? "zsh-completions"
      chmod 0555, bin/"coursier"
      output = Utils.popen_read("#{bin}/coursier --completions zsh")
      (zsh_completion/"_coursier").write output
    end
  end

  test do
    ENV["COURSIER_CACHE"] = "#{testpath}/cache"

    output = shell_output("#{bin}/cs launch io.get-coursier:echo:1.0.2 -- foo")
    assert_equal ["foo\n"], output.lines

    jar_output = shell_output("#{bin}/coursier launch io.get-coursier:echo:1.0.2 -- foo")
    assert_equal ["foo\n"], jar_output.lines
  end
end
