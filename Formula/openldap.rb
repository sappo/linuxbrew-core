class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.54.tgz"
  sha256 "a7ac148143ccfb04ea7e28d91bf6f98f08088e524d35bf86c11882dce1fb1a8f"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "09b71b1cbf3f5f0d240fdb248e9231243aba88ebe309d2956c98b3dafe60cc44" => :catalina
    sha256 "453c37d05dfd6a1e3e00b8bb7f8eb6c46ce30120f15038bfc521b7ad47e133ed" => :mojave
    sha256 "0f60174af4c4589bd405fd3b4242174e70413cbac61055d8a61ec6afd590758e" => :high_sierra
    sha256 "c9a73a80ba3d865aa5089a319239dfd7eee66b77e8f6c8e767aa6b30097a1de0" => :x86_64_linux
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  on_linux do
    depends_on "groff" => :build
    depends_on "util-linux" # for libuuid.so.1
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-bdb=no
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-hdb=no
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-translucent
      --enable-unique
      --enable-valsort
    ]

    system "./configure", *args
    system "make", "install"
    (var/"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
