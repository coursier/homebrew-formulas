class Coursier < Formula
  desc "Coursier launcher."
  homepage "http://get-coursier.io"
  url "https://repo1.maven.org/maven2/io/get-coursier/coursier-cli_2.11/1.0.0-RC4/coursier-cli_2.11-1.0.0-RC4-standalone.jar", :using => :nounzip
  sha1 "332c97f6a0088d2d6ddad3087c88e103c417f9c1"
  version "1.0.0-RC4"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    bin.install Dir["*"].shift => "coursier"
  end

  test do
    ENV["COURSIER_CACHE"] = "#{testpath}/cache"
    output = shell_output("#{bin}/coursier launch io.get-coursier:echo:1.0.0-RC4 -- foo")
    assert_equal "foo", output.lines
  end
end
