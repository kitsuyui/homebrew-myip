#!/usr/bin/env bash
version="$1"
homepage='https://github.com/kitsuyui/go-myip'

gethash() {
  curl -fsSL "${homepage}/releases/download/${version}/$1" 2>/dev/null \
  | shasum -a 256 \
  | awk '{print $1}'
}

sha256_amd64=$(gethash myip_darwin_amd64)
sha256_386=$(gethash myip_darwin_386)

cat <<EOF > myip.rb
require "formula"

class Myip < Formula
  homepage "${homepage}"

  if Hardware::CPU.is_64_bit?
    url "${homepage}/releases/download/${version}/myip_darwin_amd64"
    sha256 "${sha256_amd64}"
  else
    url "${homepage}/releases/download/${version}/myip_darwin_386"
    sha256 "${sha256_386}"
  end

  head "${homepage}.git"
  version "${version}"

  def install
    if Hardware::CPU.is_64_bit?
      bin.install "myip_darwin_amd64" => "myip"
    else
      bin.install "myip_darwin_386" => "myip"
    end
  end
end
EOF
