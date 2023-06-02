class Alt < Formula
  desc "Tool for switching between different versions of commands"
  homepage "https://github.com/dotboris/alt"
  url "https://github.com/dotboris/alt/archive/v1.4.0.tar.gz"
  sha256 "c334d22735ef780db2654ed50aa12336d0fa9e1ec61b5f2c30f5350a2805d7c9"
  head "https://github.com/dotboris/alt.git", branch: "main"

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
