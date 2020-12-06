class AltBin < Formula
  desc "Tool for switching between different versions of commands"
  homepage "https://github.com/dotboris/alt"
  version "1.2.0"

  if OS.mac?
    url "https://github.com/dotboris/alt/releases/download/v1.2.0/alt_v1.2.0_x86_64-apple-darwin.tar.gz"
    sha256 "3ae065cf518932d0d3c2d483f33f2ba1508b615ce0fb81b11db728413b9b4c54"
  elsif OS.linux?
    url "https://github.com/dotboris/alt/releases/download/v1.2.0/alt_v1.2.0_x86_64-unknown-linux-musl.tar.gz"
    sha256 "581b08566124e555ffd180f8b56c91f0f67fc4d9b3624746cd45fc582c633d5d"
  end

  conflicts_with "alt", :because => "alt is the source distribution of alt-bin"

  def install
    (prefix/"bin").install "bin/alt"

    (prefix/"etc/profile.d").install "etc/profile.d/alt.sh"
    (prefix/"share/fish/vendor_conf.d").install "etc/fish/conf.d/alt.fish"

    (prefix/"etc/bash_completion.d").install "completion/alt.bash"
    (prefix/"share/fish/vendor_completions.d").install "completion/alt.fish"
    (prefix/"share/zsh/site-functions").install "completion/_alt"
  end

  def caveats; <<~EOS
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
