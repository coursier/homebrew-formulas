# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  url "https://github.com/coursier/coursier/releases/download/v2.1.19/cs-x86_64-apple-darwin.gz"
  version "2.1.19"
  sha256 "1c48ebd9fe729c6bc2de96d81efac7013e8468d3fbd9053c99ce73626d7eff1c"

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.19/coursier"
    sha256 "13a2c48b69bf04c093f53e5463331b21ca23e3630a3f6388736ed718331423bc"
  end

  depends_on "openjdk"

  def install
    bin.install "cs-x86_64-apple-darwin" => "cs"
    resource("jar-launcher").stage { bin.install "coursier" }

    unless build.without? "shell-completions"
      chmod 0555, bin/"coursier"
      generate_completions_from_executable(bin/"coursier", "completions", shells: [:bash, :zsh])
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
