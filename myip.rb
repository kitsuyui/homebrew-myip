require "formula"

class Myip < Formula
  homepage "https://github.com/kitsuyui/go-myip"

  if Hardware::CPU.is_64_bit?
    url "https://github.com/kitsuyui/go-myip/releases/download/v0.3.3/myip_darwin_amd64"
    sha256 "c4ee79e55aa206033a76e1cafb46e766c14307652886eb02bfa6dd0d56968e77"
  else
    url "https://github.com/kitsuyui/go-myip/releases/download/v0.3.3/myip_darwin_386"
    sha256 "108b3cab0b23d10bfa765b40bf5fc8a35f18c478798d548bb414549f87019169"
  end

  head "https://github.com/kitsuyui/go-myip.git"
  version "v0.3.3"

  def install
    if Hardware::CPU.is_64_bit?
      bin.install "myip_darwin_amd64" => "myip"
    else
      bin.install "myip_darwin_386" => "myip"
    end
  end
end
