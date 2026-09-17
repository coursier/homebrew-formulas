# This file is generated from https://github.com/coursier/coursier/blob/main/.github/scripts/coursier.rb.template
# DO NOT EDIT MANUALLY

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  version "2.1.25"
  on_intel do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25/cs-x86_64-apple-darwin.gz"
    sha256 "99e59ed3222a85d4d9ba64df890770b21bf37a3f0dfc039b99028c18f3322c9a"
  end
  on_arm do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25/cs-aarch64-apple-darwin.gz"
    sha256 "43a485b1bc5c8d13a4614b5a59211b6612d62b38b9b4166d6bddbdefb4ace4de"
  end

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25/coursier"
    sha256 "8be36418507c94f652a8631a8f79712b4a88f99c974fdb0046c911a7d131e719"
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
