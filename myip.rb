require "formula"

class Myip < Formula
  homepage "https://github.com/kitsuyui/go-myip"

  if Hardware::CPU.is_64_bit?
    url "https://github.com/kitsuyui/go-myip/releases/download/v0.3.0/myip_darwin_amd64"
    sha256 "9508548c1451822b8934c857dc520da30541538721e0204f07f101fe16241d2f"
  else
    url "https://github.com/kitsuyui/go-myip/releases/download/v0.3.0/myip_darwin_386"
    sha256 "b3a4fa0d64b68206357781ca91601181d6960e878398faea302e81b1ed6398e2"
  end

  head "https://github.com/kitsuyui/go-myip.git"
  version "v0.3.0"

  def install
    if Hardware::CPU.is_64_bit?
      bin.install "myip_darwin_amd64" => "myip"
    else
      bin.install "myip_darwin_386" => "myip"
    end
  end
end
