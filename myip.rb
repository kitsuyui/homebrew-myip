require "formula"

class Myip < Formula
  homepage "https://github.com/kitsuyui/myip"

  if Hardware::CPU.is_64_bit?
    url "https://github.com/kitsuyui/myip/releases/download/v0.3.4/myip_darwin_amd64"
    sha256 "aeef1fccb763e4ddccc22bf6616063ac5a0c20d80c8db31b0cb13ca2cc48f85e"
  else
    url "https://github.com/kitsuyui/myip/releases/download/v0.3.4/myip_darwin_386"
    sha256 "57e37ca75d3c2ed45b735ade5f063a2715953b7990b60dcdf9599f2e3f58e1f8"
  end

  head "https://github.com/kitsuyui/myip.git"
  version "v0.3.4"

  def install
    if Hardware::CPU.is_64_bit?
      bin.install "myip_darwin_amd64" => "myip"
    else
      bin.install "myip_darwin_386" => "myip"
    end
  end
end
