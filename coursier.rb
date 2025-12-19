# This file is generated from https://github.com/coursier/coursier/blob/main/.github/scripts/coursier.rb.template
# DO NOT EDIT MANUALLY

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  version "2.1.25-M22"
  on_intel do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M22/cs-x86_64-apple-darwin.gz"
    sha256 "646ab891e7f492b2a452cdd09cb8e476327ce2b1b220111be82cc1dcefbd93ff"
  end
  on_arm do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M22/cs-aarch64-apple-darwin.gz"
    sha256 "42a1ec29bfaa08618da443ef83a639ca2d6be7019bbd450ff0c27dfa2897ebef"
  end

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M22/coursier"
    sha256 "7cc3cf73a56f333aadd279fcb1c41030c3849ad09e73781f9af1325d802e2860"
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
