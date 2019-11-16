class Alt < Formula
  desc "Tool for switching between different versions of commands"
  homepage "https://github.com/dotboris/alt"
  url "https://github.com/dotboris/alt/archive/v1.1.1.tar.gz"
  sha256 "6b3f12f0b24a81ac7948d73e69b817fc1d45fd848d7f422032f006c93c7b9030"
  head "https://github.com/dotboris/alt.git"

  depends_on "rust" => :build

  conflicts_with "alt-bin", :because => "alt-bin is the binary distribution of alt"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    (prefix/"etc/profile.d").install "etc/profile.d/alt.sh"
    (prefix/"share/fish/vendor_conf.d").install "etc/fish/conf.d/alt.fish"

    (prefix/"etc/bash_completion.d").install "target/release/completion/alt.bash"
    (prefix/"share/fish/vendor_completions.d").install "target/release/completion/alt.fish"
    (prefix/"share/zsh/site-functions").install "target/release/completion/_alt"
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
