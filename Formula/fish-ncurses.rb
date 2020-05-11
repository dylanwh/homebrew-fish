class FishNcurses < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems (linked with brew ncurses)"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.1.2/fish-3.1.2.tar.gz"
  sha256 "d5b927203b5ca95da16f514969e2a91a537b2f75bec9b21a584c4cd1c7aa74ed"

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "pcre2"
  depends_on "ncurses"


  def install
    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    ncurses_ver = Dir.children("#{HOMEBREW_PREFIX}/Cellar/ncurses").sort.last
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
      -DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX}/Cellar/ncurses/#{ncurses_ver}
      -DSED=/usr/bin/sed
    ]
    system "sed", '-i', '-e', '/CODESIGN_ON_MAC(${target})/ d', 'CMakeLists.txt'
    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
