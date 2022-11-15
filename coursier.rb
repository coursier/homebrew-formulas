# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  url "https://github.com/coursier/coursier/releases/download/v2.1.0-RC2/cs-x86_64-apple-darwin.gz"
  version "2.1.0-RC2"
  sha256 "5c099d31240dbc6a48a38232c14159b29d19bfda767f3bf848ebd1c250ffdda8"

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.0-RC2/coursier"
    sha256 "3fe5d221949a8cfeee20d487e31c656f00fe74ee876f581105d8b2594633387a"
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
