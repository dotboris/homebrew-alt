class AltBin < Formula
  desc "Tool for switching between different versions of commands"
  homepage "https://github.com/dotboris/alt"

  if OS.mac?
    url "https://github.com/dotboris/alt/releases/download/v1.3.0/alt_v1.3.0_x86_64-apple-darwin.tar.gz"
    sha256 "22513174f1d9ff52e92204cb5c6cabec5fb0f1e0e072ef2331e7dc077e0068a6"
  elsif OS.linux?
    url "https://github.com/dotboris/alt/releases/download/v1.3.0/alt_v1.3.0_x86_64-unknown-linux-musl.tar.gz"
    sha256 "d81d9afc8ce21671f2dac0d547de9887d28b42ed9b16a0e3da9b1964f927c429"
  end

  conflicts_with "alt", because: "alt is the source distribution of alt-bin"

  def install
    (prefix/"bin").install "bin/alt"

    (prefix/"etc/profile.d").install "etc/profile.d/alt.sh"
    (prefix/"share/fish/vendor_conf.d").install "etc/fish/conf.d/alt.fish"

    (prefix/"share/man/man1").install Dir["man/*.1"]

    (prefix/"etc/bash_completion.d").install "completion/alt.bash"
    (prefix/"share/fish/vendor_completions.d").install "completion/alt.fish"
    (prefix/"share/zsh/site-functions").install "completion/_alt"
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
      assert_match /^v1$/, shell_output("alt-testbin")
    end

    (testpath/"project-2").mkpath
    Dir.chdir(testpath/"project-2") do
      system "#{bin}/alt", "use", "alt-testbin", "2"
      assert_match /^v2$/, shell_output("alt-testbin")
    end
  end
end
