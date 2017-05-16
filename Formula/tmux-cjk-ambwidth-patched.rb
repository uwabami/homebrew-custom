class TmuxCJKAmbwidthPatched < Formula
  desc "Terminal multiplexer with CJK Ambwidth Patched"
  homepage "https://tmux.github.io/"

  stable do
    url "https://github.com/tmux/tmux/releases/download/2.4/tmux-2.4.tar.gz"
    sha256 "757d6b13231d0d9dd48404968fc114ac09e005d475705ad0cd4b7166f799b349"
  end

  def patches
    [
      "https://gist.githubusercontent.com/uwabami/55feca5bdbe8042b3441cafa738a63c9/raw/6264b85608655f89d0d0b06c26677b5574ac435e/0002-Use-box-drawing-DECSP-or-ASCII-with-option-pane-bord.patch",
      "https://gist.githubusercontent.com/uwabami/5f0122a72f253af0bca2df2501e3a8dd/raw/4a3e2eb0839cc7f8f7f300b401328154e3a73c9b/0003-Unset-locale-as-en_US.UTF-8.patch"
    ]
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "utf8proc" => :optional

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    args = %W[
      --disable-Dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    args << "--enable-utf8proc" if build.with?("utf8proc")

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats; <<-EOS.undent
    Example configuration has been installed to:
      #{opt_pkgshare}
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
