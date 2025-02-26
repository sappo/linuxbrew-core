class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.32.0.tar.gz"
  sha256 "27a40690e69a76c7887b1a4456d96493cb46a2d3298b243db2e3ce0669f3aeeb"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d64f44aeeffee13008cc6fb8f8aafc4277f1fa032b8da12e5e484f44db10cee" => :catalina
    sha256 "248c78453c196fc4b821c9e9b5a94d12e38795c80a94c863aaccb22a0c109278" => :mojave
    sha256 "5da5b46d7f8b6eb4902696cdaaddfde84d81e3d4267f2242fd5691ef699778b5" => :high_sierra
    sha256 "d53026a051d4c6458f5993bd2c464b31dc0641b5ca2ae3daf19c8b1bfe40722c" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
