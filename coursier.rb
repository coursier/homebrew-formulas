# This file is generated from https://github.com/coursier/coursier/blob/main/.github/scripts/coursier.rb.template
# DO NOT EDIT MANUALLY

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  version "2.1.25-M26"
  on_intel do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M26/cs-x86_64-apple-darwin.gz"
    sha256 "e061ec985562e9b21d75975cb6d60cac3c8874df19e3c6e007d935bc68aaf6b0"
  end
  on_arm do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M26/cs-aarch64-apple-darwin.gz"
    sha256 "4ebc84fa2fd767dffca3b4e63ed1cd7bc0f55870f98f14207e46e00512043bc4"
  end

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M26/coursier"
    sha256 "d6fdd69e7337b0cbe8f27deab038775621128d9500e19de1cdb16091985489d2"
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
      with_env("COURSIER_MIRRORS": ENV["HOMEBREW_COURSIER_MIRRORS"]) do
        chmod 0555, bin/"coursier"
        generate_completions_from_executable(bin/"coursier", "completions", shells: [:bash, :zsh])
      end
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
