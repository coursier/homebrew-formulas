# This file is generated from https://github.com/coursier/coursier/blob/main/.github/scripts/coursier.rb.template
# DO NOT EDIT MANUALLY

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  version "2.1.25-M24"
  on_intel do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M24/cs-x86_64-apple-darwin.gz"
    sha256 "92d00573619fd2490bebd284d227358338183ff2d2c18ab34a195e9bff2ae225"
  end
  on_arm do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M24/cs-aarch64-apple-darwin.gz"
    sha256 "fde4e1a7be04d826f50eed4ecc227c0bd92a61944f3cb25b4e819fd9585e044b"
  end

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M24/coursier"
    sha256 "1da1d049977d3f1c76166cad9211f52eef48c2712641e976c59c21d3ab7a3154"
  end

  depends_on "openjdk"

  def install
    on_intel do
      bin.install "cs-x86_64-apple-darwin" => "cs"
    end
    on_arm do
      bin.install "cs-aarch64-apple-darwin" => "cs"
    end
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
