class Alt < Formula
  desc "Tool for switching between different versions of commands"
  homepage "https://github.com/dotboris/alt"
  url "https://github.com/dotboris/alt/archive/v1.0.5.tar.gz"
  sha256 "90986955183248882584ccfe4e558ca5f610c4bcc8da8d5fe13352522f8226c5"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    (etc/"profile.d").install "etc/profile.d/alt.sh"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won"t accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test alt`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
