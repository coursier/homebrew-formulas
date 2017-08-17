require 'formula'

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb

class Coursier < Formula
  desc "Coursier launcher."
  homepage "http://get-coursier.io"
  head 'git://github.com/alexarchambault/coursier.git'

  depends_on :java => "1.8+"

  def install
    bin.install 'coursier'
  end

  test do
    ENV["COURSIER_CACHE"] = "#{testpath}/cache"
    output = shell_output("#{bin}/coursier launch io.get-coursier:echo:1.0.0-RC10 -- foo")
    assert_equal ["foo\n"], output.lines
  end
end
