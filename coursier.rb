# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  url "https://github.com/coursier/coursier/releases/download/v2.1.0-M7-18-g67daad6a9/cs-x86_64-apple-darwin.gz"
  version "2.1.0-M7-18-g67daad6a9"
  sha256 "8fd0c90fbc376233bde0c62cb92f23b46ab3108304f3adf47130326115b83354"

  option "without-zsh-completions", "Disable zsh completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.0-M7-18-g67daad6a9/coursier"
    sha256 "af2288c3cd347db54be67fa4698074713f5457457c189c58de2a0f09fcc6f19c"
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
