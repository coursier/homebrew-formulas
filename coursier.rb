require 'formula'

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb

class Coursier < Formula
  desc "Coursier launcher."
  homepage "https://get-coursier.io"
  version "2.0.0-RC1"
  url "https://github.com/coursier/coursier/releases/download/v2.0.0-RC1/coursier"
  sha256 "01f38ca118eb197e1c4d2038a55bcdaea7065358a6aa8c102053114cc153c9cd"
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
