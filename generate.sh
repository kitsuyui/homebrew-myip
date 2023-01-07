#!/usr/bin/env bash
version="$(curl https://api.github.com/repos/kitsuyui/myip/releases/latest | jq -r .tag_name)"
homepage='https://github.com/kitsuyui/myip'

gethash() {
  curl -fsSL "${homepage}/releases/download/${version}/$1" 2>/dev/null \
  | shasum -a 256 \
  | awk '{print $1}'
}

arm64_file=myip_Darwin_arm64.tar.gz
amd64_file=myip_Darwin_x86_64.tar.gz
sha256_arm64=$(gethash "$arm64_file")
sha256_amd64=$(gethash "$amd64_file")

cd "${0%/*}"
cat <<EOF > myip.rb
require "formula"

class Myip < Formula
  homepage "${homepage}"
  head "${homepage}.git"
  version "${version}"

  if Hardware::CPU.arm? and Hardware::CPU.is_64_bit?
    url "https://github.com/kitsuyui/myip/releases/download/${version}/${arm64_file}"
    sha256 "${sha256_arm64}"
  elsif Hardware::CPU.intel? and Hardware::CPU.is_64_bit?
    url "https://github.com/kitsuyui/myip/releases/download/${version}/${amd64_file}"
    sha256 "${sha256_amd64}"
  end

  def install
    bin.install "myip" => "myip"
  end
end
EOF
