# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  url "https://github.com/coursier/coursier/releases/download/v2.1.0-M6-26-gcec901e9a/cs-x86_64-apple-darwin.gz"
  version "2.1.0-M6-26-gcec901e9a"
  sha256 "0cd8b2e3ff49a9995dd543bff1185e8062e00d1ecbcf6599369edfe18ac35613"

  option "without-zsh-completions", "Disable zsh completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.0-M6-26-gcec901e9a/coursier"
    sha256 "a7bd9e47bde5962dc5e71d7204b742e48e6ca5135908aa44f41c9522ffde47c2"
  end

  depends_on "openjdk"

  def install
    bin.install "cs-x86_64-apple-darwin" => "cs"
    resource("jar-launcher").stage { bin.install "coursier" }

    unless build.without? "zsh-completions"
      chmod 0555, bin/"coursier"
      output = Utils.safe_popen_read("#{bin}/coursier", "completions", "zsh")
      (zsh_completion/"_coursier").write output
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
