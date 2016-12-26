require "formula"

class Myip < Formula
  homepage "https://github.com/kitsuyui/go-myip"

  if Hardware::CPU.is_64_bit?
    url "https://github.com/kitsuyui/go-myip/releases/download/0.1.0/myip_darwin_amd64"
    sha256 "cde6ab18dabf38e6011cd26a9b03a9d08c291c2d4d7381c20d6e7dcc5e17a832"
  else
    url "https://github.com/kitsuyui/go-myip/releases/download/0.1.0/myip_darwin_386"
    sha256 "478b289bee9ff676327d85bdd568b2e0f2387aebdd0ada88ebbf385f57d48b56"
  end

  head "https://github.com/kitsuyui/go-myip.git"
  version "0.1.0"

  def install
    if Hardware::CPU.is_64_bit?
      bin.install "myip_darwin_amd64" => "myip"
    else
      bin.install "myip_darwin_386" => "myip"
    end
  end
end
