class SdccGbdk2020Patch < Formula
  # Cloned from official sdcc formula https://formulae.brew.sh/formula/sdcc
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://sourceforge.net/code-snapshots/svn/s/sd/sdcc/code/sdcc-code-r13350-trunk.zip"
  version "13350"
  sha256 "7af85953b03ba664509fcf1905e96ee9448a83feef224a607042f12e560e7040"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", :public_domain, "Zlib"]
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  livecheck do
    url :stable
    regex(%r{url=.*?/sdcc-src[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "gputils"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  patch do
    url "https://sourceforge.net/p/sdcc/patches/396/attachment/sdldz80-sms-virtual-address.patch"
    sha256 "a85a38c74306e1d2b0a67d260585c55bcb1bc00853d7ce751ba3ab429a813509"
    directory "sdcc"
  end

  def install
    cd "sdcc" do
      system "./configure", "--prefix=#{prefix}",
          "--enable-gbz80-port",
          "--enable-z80-port",
          "--disable-mcs51-port",
          "--disable-z180-port",
          "--disable-r2k-port",
          "--disable-r2ka-port",
          "--disable-r3ka-port",
          "--disable-tlcs90-port",
          "--disable-ez80_z80-port",
          "--disable-z80n-port",
          "--disable-ds390-port",
          "--disable-ds400-port",
          "--disable-pic14-port",
          "--disable-pic16-port",
          "--disable-hc08-port",
          "--disable-s08-port",
          "--disable-stm8-port",
          "--disable-pdk13-port",
          "--disable-pdk14-port",
          "--disable-pdk15-port",
          "--disable-ucsim",
          "--disable-doc"
      system "make", "all"
      system "make", "install"
      # rm Dir["#{bin}/*.el"]
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/sdcc", "-mz80", "#{testpath}/test.c"
    assert_predicate testpath/"test.ihx", :exist?
  end
end