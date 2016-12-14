require "formula"

class Myip < Formula
  homepage "https://github.com/kitsuyui/go-myip"

  if Hardware::CPU.is_64_bit?
    url "https://github.com/kitsuyui/go-myip/releases/download/0.0.1/myip_darwin_amd64"
    sha256 "17dac2a8d0904acfb3f250bffe30539bb8dc0fb674ab3492d764413425ad0166"
  else
    url "https://github.com/kitsuyui/go-myip/releases/download/0.0.1/myip_darwin_386"
    sha256 "c95cbdc713a47232c40534021547f540ce538fb7ae51667162e2c4ab4659870d"
  end

  head "https://github.com/kitsuyui/go-myip.git"
  version "0.0.1"

  def install
    if Hardware::CPU.is_64_bit?
      bin.install "myip_darwin_amd64" => "myip"
    else
      bin.install "myip_darwin_386" => "myip"
    end
  end
end
