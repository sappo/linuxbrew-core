class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.22.tar.gz"
  sha256 "72ee9f70151835361c14a487abe641d0f36fa3184410b668d777b980a77290db"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9182465620514438ebc59d73701a93a5a34f257ca9d175194f319623d5984b14" => :catalina
    sha256 "bb76feb5d0c97e46bcbd9743d53070f96eb5fdafd0e38e104bb1b3d44f147439" => :mojave
    sha256 "6883004870027bc2e3b8e6ca7163b38e89f1a43376a5449a53e11d23c9f9cc8c" => :high_sierra
    sha256 "e14794b8920087bec0487c5abaab2a294174ed4c072ea33cc33cd9baa0ddb947" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  def caveats
    <<~EOS
      Before you can use these tools, you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_REGION="<Your AWS Region>"
    EOS
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
