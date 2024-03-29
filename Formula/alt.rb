class Alt < Formula
  desc "Tool for switching between different versions of commands"
  homepage "https://github.com/dotboris/alt"
  url "https://github.com/dotboris/alt/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "95acf83b7e8bb2a7cae70a9925e87e3f370fb74c1c3c9de5c60edf63d344612e"
  head "https://github.com/dotboris/alt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/dotboris/alt"
    sha256 cellar: :any_skip_relocation, monterey:     "9d09d1a1111ca3e7f2a0ce6b39eec45c9725b9764fe281ff05fbedc36659cedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bceff217adc3bfa64065ba92fe433b982b7d3b8e80cd2e243c8264191cdf23ef"
  end

  depends_on "rust" => :build

  conflicts_with "alt-bin", because: "alt-bin is the binary distribution of alt"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    (prefix/"etc/profile.d").install "etc/profile.d/alt.sh"
    (prefix/"share/fish/vendor_conf.d").install "etc/fish/conf.d/alt.fish"

    (prefix/"share/man/man1").install Dir["target/release/man/*.1"]

    (prefix/"etc/bash_completion.d").install "target/release/completion/alt.bash"
    (prefix/"share/fish/vendor_completions.d").install "target/release/completion/alt.fish"
    (prefix/"share/zsh/site-functions").install "target/release/completion/_alt"
  end

  def caveats
    <<~EOS
      Add the following line to your ~/.bash_profile or ~/.zprofile:
        . "#{etc}/profile.d/alt.sh"
    EOS
  end

  test do
    ENV["ALT_HOME"] = testpath/"alt-home"
    ENV["ALT_SHIM_DIR"] = testpath/"alt-shims"
    ENV["PATH"] = "#{testpath}/alt-shims:#{ENV["PATH"]}"

    (testpath/"bin").mkpath
    (testpath/"bin/alt-testbin1").write "#!/bin/bash\necho v1"
    (testpath/"bin/alt-testbin1").chmod 0755
    (testpath/"bin/alt-testbin2").write "#!/bin/bash\necho v2"
    (testpath/"bin/alt-testbin2").chmod 0755
    system "#{bin}/alt", "def", "alt-testbin", "1", testpath/"bin/alt-testbin1"
    system "#{bin}/alt", "def", "alt-testbin", "2", testpath/"bin/alt-testbin2"

    (testpath/"project-1").mkpath
    Dir.chdir(testpath/"project-1") do
      system "#{bin}/alt", "use", "alt-testbin", "1"
      assert_match(/^v1$/, shell_output("alt-testbin"))
    end

    (testpath/"project-2").mkpath
    Dir.chdir(testpath/"project-2") do
      system "#{bin}/alt", "use", "alt-testbin", "2"
      assert_match(/^v2$/, shell_output("alt-testbin"))
    end
  end
end
