# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  version "2.1.7"
  on_intel do
    url "https://github.com/coursier/coursier/releases/download/v2.1.7/cs-x86_64-apple-darwin.gz"
    sha256 "db49faf31b5ef824394530c4ba6b1d584604e98a546502b15b8a6f0488e78d26"
  end
  on_arm do
    url "https://github.com/VirtusLab/coursier-m1/releases/download/v2.1.7/cs-aarch64-apple-darwin.gz"
    sha256 "4da2fa206735017b31ff143e7ad1d23f695a8dc41361e9dd42f4a69136197742"
  end

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.7/coursier"
    sha256 "6a28788247d2153c99b70eb535f07625c3637e6c585a2d6458d1a8a08fb5d741"
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
