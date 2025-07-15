# This file is generated from https://github.com/coursier/coursier/blob/main/.github/scripts/coursier.rb.template
# DO NOT EDIT MANUALLY

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  version "2.1.25-M16"
  on_intel do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M16/cs-x86_64-apple-darwin.gz"
    sha256 "1df65ffc5a659cb5a241ce2a31dd6671d5596af0d260239ab7039d59fbf0e46b"
  end
  on_arm do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M16/cs-aarch64-apple-darwin.gz"
    sha256 "bb86be2337fa7e58d1908307777899d01b36535c8a3e32a6d6be05e6865b48ad"
  end

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M16/coursier"
    sha256 "4a4204244ae18978ffaa32708a43df5523ce0edc35f1015224afee18811efabd"
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
