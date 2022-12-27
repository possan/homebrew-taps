class Gbdk2020 < Formula
  desc "GBDK is a cross-platform development kit for sm83 and z80 based gaming consoles."
  homepage "https://github.com/gbdk-2020/gbdk-2020"
  url "https://github.com/gbdk-2020/gbdk-2020/archive/refs/tags/4.1.1.tar.gz"
  sha256 "70f30b3ea00dd827013dd731cc1dff4e0003fa1e884f8908ccffd025c2a1d19b"
  license ""

  depends_on "sdcc-gbdk2020-patch"

  def install
    ENV["SDCCDIR"] = Formula["sdcc-gbdk2020-patch"].prefix

    system "make gbdk-build"
    system "make gbdk-install"

    bin.install Dir["build/gbdk/bin/*"]

    # cd "gbdk-lib/examples" do
    #   system "make"
    # end
    # system "ls -la"

    share.install Dir["gbdk-lib"]
    share.install Dir["gbdk-support"]
  end

  test do
    system "false"
  end
end
