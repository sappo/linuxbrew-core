require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.12.1.tgz"
  sha256 "ffc04ccd8f62cb29c8ab6ead10cc2254716aac6df3c2f63632d80b6b27137b67"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "87d99aa8d29a652aa610745e95579274cd854b301eb1044ac972e4489748f349" => :catalina
    sha256 "b78ab95ea6f544a0c2a3325ad4d89cbd5196b78d46bed549c815cf01d24b4c86" => :mojave
    sha256 "cf805d8ade32058695247a80f8a669ecfc21bdf4a85087c979b7a364a9f4808a" => :high_sierra
    sha256 "c4205a7d9391c96b41f2edc7aeba25cc833db53ad12d84d6573c140befd88bce" => :x86_64_linux
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.11.5.tgz"
    sha256 "753dac0c168274369d18cb7c2d90326173aa15639aa843d81b29ca2ac64926e5"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundledDependencies"] = ["@babel/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
