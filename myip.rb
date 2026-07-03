class Myip < Formula
  homepage "https://github.com/kitsuyui/myip"

  stable do
    version "v0.3.10"

    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/kitsuyui/myip/releases/download/v0.3.10/myip_Darwin_arm64.tar.gz"
      sha256 "9f849345ff0fae25f2deb429597db065435fb788c82acf14de3a4930786d83ec"
    elsif Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/kitsuyui/myip/releases/download/v0.3.10/myip_Darwin_x86_64.tar.gz"
      sha256 "30d8a30d0414e7077ef11d6d303239e3512473e3f6d73b22ecfcf3daa501bb01"
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

  test do
    system bin/"myip", "--help"
  end
end
