# This file is generated from https://github.com/coursier/coursier/blob/main/.github/scripts/coursier.rb.template
# DO NOT EDIT MANUALLY

# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  version "2.1.27"
  on_intel do
    url "https://github.com/coursier/coursier/releases/download/v2.1.27/cs-x86_64-apple-darwin.gz"
    sha256 "93ba2bf488a5b5d54fa4d3a3187334420a753fb6c752a54b1586a14a0c55ee6c"
  end
  on_arm do
    url "https://github.com/coursier/coursier/releases/download/v2.1.27/cs-aarch64-apple-darwin.gz"
    sha256 "468a4c08483d77f8896b33bcf474e303f716ad43a3f7fb9639cc1112fca9dc1f"
  end

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.27/coursier"
    sha256 "3ca246c74dd46225cc9c1e708a06a50529aa0b554cd5bff93324bf5e6fe065a6"
  end

  # No dependency on openjdk: its java would end up on the PATH, shadowing the JVMs
  # that coursier manages (https://github.com/coursier/coursier/issues/3763).
  # The native launcher "cs" doesn't need a JVM. The JAR-based launcher "coursier" uses the
  # JVM from JAVA_HOME or the PATH, such as the one "cs setup" installs.

  def install
    on_intel do
      bin.install "cs-x86_64-apple-darwin" => "cs"
    end
    on_arm do
      bin.install "cs-aarch64-apple-darwin" => "cs"
    end
    resource("jar-launcher").stage { bin.install "coursier" }
    chmod 0555, bin/"coursier"
    chmod 0555, bin/"cs"

    unless build.without? "shell-completions"
      # The native launcher writes its argv[0] in the completion scripts. Running it
      # through the PATH makes them refer to "cs" rather than to its path in the Cellar.
      ENV.prepend_path "PATH", bin
      generate_completions_from_executable("cs", "completions", base_name: "cs", shells: [:bash, :zsh])
    end
  end

  test do
    ENV["COURSIER_CACHE"] = "#{testpath}/cache"
    ENV["COURSIER_ARCHIVE_CACHE"] = "#{testpath}/arc"

    output = shell_output("#{bin}/cs launch io.get-coursier:echo:1.0.2 -- foo")
    assert_equal ["foo\n"], output.lines
  end
end
