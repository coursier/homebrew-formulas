# This file is generated from https://github.com/coursier/coursier/blob/main/.github/scripts/coursier.rb.template
# DO NOT EDIT MANUALLY

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  version "2.1.25-M23"
  on_intel do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M23/cs-x86_64-apple-darwin.gz"
    sha256 "8d0a7c2a5053fde3431327d8f6b82a3dfc02e4334ebae340a8281728ae5bee35"
  end
  on_arm do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M23/cs-aarch64-apple-darwin.gz"
    sha256 "db6f64b382e15b636e43668ac7419230e255aa9a52f7acd2859b541ec4a9733b"
  end

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M23/coursier"
    sha256 "5924073323e27e88d0f5b994f712e6ad019495f2594c68750b2465f5b228f59e"
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
