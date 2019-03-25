require 'formula'

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb

class Coursier < Formula
  desc "Coursier launcher."
  homepage "https://get-coursier.io"
  version "1.1.0-M13-2"
  url "https://github.com/coursier/coursier/releases/download/v1.1.0-M13-2/coursier"
  sha256 "9b3cc9df0d66d7ebc8ecfca193eb8d2df11e162a8c2560762d2b97c3ca35a9cb"
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
