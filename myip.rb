class Myip < Formula
  homepage "https://github.com/kitsuyui/myip"

  stable do
    version "v0.3.12"

    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/kitsuyui/myip/releases/download/v0.3.12/myip_Darwin_arm64.tar.gz"
      sha256 "77217f7a2ed9460657da68e05cc115c9604f3e88cb36fa819281cacf4ef8ed86"
    elsif Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/kitsuyui/myip/releases/download/v0.3.12/myip_Darwin_x86_64.tar.gz"
      sha256 "38c1518159a166ec70d2f2f5f59cf9a9c50ee347092d756039c6d7f336ae40fd"
    else
      odie "myip binary releases are only available for Apple Silicon and 64-bit Intel macOS"
    end
  end

  head do
    url "https://github.com/kitsuyui/myip.git", branch: "main"
    depends_on "go" => :build
  end

  def install
    if build.head?
      system "go", "build", "-trimpath", "-ldflags", "-s -w", "-o", bin/"myip", "./cmd"
    else
      bin.install "myip" => "myip"
    end
  end
end
