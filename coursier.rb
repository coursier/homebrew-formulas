require 'formula'

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb

class Coursier < Formula
  desc "Coursier launcher."
  homepage "https://get-coursier.io"
  version "2.0.0-RC2-6"
  url "https://github.com/coursier/coursier/releases/download/v2.0.0-RC2-6/coursier"
  sha256 "6ceb00953a9870d3d3c550cd4dd6b3ca53585990a01260c01ac07d007111d49a"
  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    FileUtils.mkdir_p "completions/zsh"
    system "bash", "-c", "bash ./coursier --completions zsh > completions/zsh/_coursier"
    zsh_completion.install "completions/zsh/_coursier"

    bin.install 'coursier'
  end

  test do
    ENV["COURSIER_CACHE"] = "#{testpath}/cache"
    output = shell_output("#{bin}/coursier launch io.get-coursier:echo:1.0.2 -- foo")
    assert_equal ["foo\n"], output.lines
  end
end
