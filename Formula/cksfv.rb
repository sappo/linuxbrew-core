class Cksfv < Formula
  desc "File verification utility"
  homepage "https://zakalwe.fi/~shd/foss/cksfv/"
  url "https://zakalwe.fi/~shd/foss/cksfv/files/cksfv-1.3.15.tar.bz2"
  sha256 "a173be5b6519e19169b6bb0b8a8530f04303fe3b17706927b9bd58461256064c"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e0b05988d3af7d666d08c8d3f4d8792f043f899a88e689d819e0b1dfd4bc2b4" => :catalina
    sha256 "6110de963cf29500583d02ac6629abc215ec85ce13de8855b251e2aaa67bf6d7" => :mojave
    sha256 "309816a8249a73a40760807ce0e5801a3ad223b21eb2a2e4b4a1d4d99859ff8a" => :high_sierra
    sha256 "8f49b7f252ae2c8add2aacd2beffd346f79e526809892848ae1adc01ab1937a8" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"foo"
    path.write "abcd"

    assert_match "#{path} ED82CD11", shell_output("#{bin}/cksfv #{path}")
  end
end
