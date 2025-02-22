# adapted from https://github.com/paulp/homebrew-extras/blob/8184f9a962ce0758f4cf7a07b702bc1c3d16dfaa/coursier.rb
class Coursier < Formula
  desc "Launcher for Coursier"
  homepage "https://get-coursier.io"
  version "2.1.25-M2"
 
  on_intel do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M2/cs-x86_64-apple-darwin.gz"
    sha256 "0b51059d28338351e87374f34349d43a00dd445428ad09f0c5db1d8bc7c99997"
  end
  on_arm do 
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M2/cs-aarch64-apple-darwin.gz"
    sha256 "008e10f23ecf59e7a7ee51eeff6be5c971199a95ccc35a8099a451009f6adf0b"
  end

  option "without-shell-completions", "Disable shell completion installation"

  # https://stackoverflow.com/questions/10665072/homebrew-formula-download-two-url-packages/26744954#26744954
  resource "jar-launcher" do
    url "https://github.com/coursier/coursier/releases/download/v2.1.25-M2/coursier"
    sha256 "51ce0dea9dbc59a074b467b10c1dd64146a08211f2784832a41391df11f4efd3"
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
