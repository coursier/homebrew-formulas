require 'formula'

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb

class Coursier < Formula
  desc "Coursier launcher."
  homepage "https://get-coursier.io"
  version "2.0.4"
  url "https://github.com/coursier/coursier/releases/download/v2.0.4/cs-x86_64-apple-darwin"
  sha256 "c72923bde83fe02eca380b843762edb79e2f9e853005bfbd826e1ef9470a9120"
  bottle :unneeded

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.0.4/coursier"
    sha256 "9fcf4f3f904d4d5f3be15e1a75c871fdc6428ae79ab3800cf752e44495f05211"
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
