# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  version "2.1.24"
  on_intel do
    url "https://github.com/coursier/coursier/releases/download/v2.1.24/cs-x86_64-apple-darwin.gz"
    sha256 "33913cd6b61658035d9e6fe971e919cb0ef1f659aa7bff7deeded963a2d36385"
  end
  on_arm do
    url "https://github.com/coursier/coursier/releases/download/v2.1.24/cs-aarch64-apple-darwin.gz"
    sha256 "53a5728c2016118c8296fa7d5678ddfe122e22dc6c36deb554d771b3b9295b4f"
  end

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.24/coursier"
    sha256 "7aa975f12469726d6bb87852107afe0b8d6f3c82b12a49ef43cc6647c4e057ca"
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
