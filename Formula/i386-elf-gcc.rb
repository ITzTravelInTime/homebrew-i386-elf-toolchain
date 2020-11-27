class I386ElfGcc < Formula
  desc "GNU Compiler Collection targetting i386-elf"
  homepage "https://gcc.gnu.org"
  url "http://ftpmirror.gnu.org/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz"
  version "10.2.0"
  #sha256 "71e197867611f6054aa1119b13a0c0abac12834765fe2d81f35ac57f84f742d1"


  depends_on "gmp" => :build
  depends_on "i386-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr" => :build

  def install
    mkdir "gcc-build" do
      system "../configure", "--prefix=#{prefix}",
                             "--target=i386-elf",
                             "--disable-multilib",
                             "--disable-nls",
                             "--disable-werror",
                             "--without-headers",
                             "--without-isl",
                             "--enable-languages=c,c++"

      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # GCC needs this folder in #{prefix} in order to see the binutils.
      # It doesn't look for i386-elf-as on $PREFIX/bin. Rather, it looks
      # for as on $PREFIX/$TARGET/bin/ ($PREFIX/i386-elf/bin/as).
      binutils = Formula["i386-elf-binutils"].prefix
      FileUtils.ln_sf "#{binutils}/i386-elf", "#{prefix}/i386-elf"
    end

  end

  test do
    system "i386-elf-gcc", "--version"
  end
end
