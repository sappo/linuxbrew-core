class DockerMachineParallels < Formula
  desc "Parallels Driver for Docker Machine"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v2.0.0.tar.gz"
  sha256 "3fdde5c55bd6118d5bd9382c611c779b9c64cc111721fc17e7711d63d52d7e57"
  license "MIT"
  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ac0584bc51d21b9e7af8bfa687df9a3c84a721945f85c100194a3a65ca1c17e" => :catalina
    sha256 "6fed2c425df4ab8f09292395d72f6521c67bafe50da7f12990e9f7a6186b1ffc" => :mojave
    sha256 "9db553f2eec8343adb8ea9fea7964388983e6e43fadab2101f78cd9abd6a878a" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  # Parallels Desktop is inherently Mac-only
  depends_on :macos

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/Parallels/docker-machine-parallels"
    path.install Dir["*"]

    cd path do
      system "make", "build"
      bin.install "bin/docker-machine-driver-parallels"
    end

    prefix.install_metafiles path
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
