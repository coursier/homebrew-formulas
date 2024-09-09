# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  url "https://github.com/coursier/coursier/releases/download/v2.1.11/cs-x86_64-apple-darwin.gz"
  version "2.1.11"
  sha256 "e55823b2e593ccc644af80570536a24fde85b5629bc3de7322372c25430950f3"

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.11/coursier"
    sha256 "19de5133b41d15499a7ebe9c79012f1636d0b16a281c288c0ec946d4c60572b2"
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
