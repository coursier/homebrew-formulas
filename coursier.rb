class Coursier < Formula
  desc "Coursier launcher."
  homepage "http://get-coursier.io"
  url "https://repo1.maven.org/maven2/io/get-coursier/coursier-cli_2.11/1.0.0-M15-5/coursier-cli_2.11-1.0.0-M15-5-standalone.jar", :using => :nounzip
  sha1 "bc797678fa4cadde0beada92d58d75bd3e79fc22"
  version "1.0.0-M15-5"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    bin.install Dir["*"].shift => "coursier"
  end

  test do
    ENV["COURSIER_CACHE"] = "#{testpath}/cache"
    output = shell_output("#{bin}/coursier launch io.get-coursier::echo:1.0.0-M15-5 -- foo")
    assert_equal "foo", output.lines
  end
end
