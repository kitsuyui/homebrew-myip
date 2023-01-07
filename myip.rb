require "formula"

class Myip < Formula
  homepage "https://github.com/kitsuyui/myip"
  head "https://github.com/kitsuyui/myip.git"
  version "v0.3.10"

  if Hardware::CPU.arm? and Hardware::CPU.is_64_bit?
    url "https://github.com/kitsuyui/myip/releases/download/v0.3.10/myip_Darwin_arm64.tar.gz"
    sha256 "9f849345ff0fae25f2deb429597db065435fb788c82acf14de3a4930786d83ec"
  elsif Hardware::CPU.intel? and Hardware::CPU.is_64_bit?
    url "https://github.com/kitsuyui/myip/releases/download/v0.3.10/myip_Darwin_x86_64.tar.gz"
    sha256 "30d8a30d0414e7077ef11d6d303239e3512473e3f6d73b22ecfcf3daa501bb01"
  end

  def install
    bin.install "myip" => "myip"
  end
end
