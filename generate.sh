#!/usr/bin/env bash
set -euo pipefail

version="$(curl -fsSL --connect-timeout 30 --max-time 60 https://api.github.com/repos/kitsuyui/myip/releases/latest | jq -er .tag_name)"
if ! [[ "${version}" =~ ^v?[0-9]+\.[0-9]+\.[0-9]+[a-zA-Z0-9.+_-]*$ ]]; then
  echo "unexpected version tag: '${version}'" >&2
  exit 1
fi
homepage='https://github.com/kitsuyui/myip'

gethash() {
  local file="$1"
  local tmpfile
  local checksum

  tmpfile="$(mktemp)"
  if ! curl -fsSL --connect-timeout 30 --max-time 120 "${homepage}/releases/download/${version}/${file}" -o "$tmpfile"; then
    rm -f "$tmpfile"
    echo "failed to download release archive: ${file}" >&2
    return 1
  fi

  if [[ ! -s "$tmpfile" ]]; then
    rm -f "$tmpfile"
    echo "release archive is empty: ${file}" >&2
    return 1
  fi

  if ! gh attestation verify "$tmpfile" --repo kitsuyui/myip --format json > /dev/null; then
    rm -f "$tmpfile"
    echo "failed to verify build provenance attestation: ${file}" >&2
    return 1
  fi

  if ! checksum="$(shasum -a 256 "$tmpfile" | awk '{print $1}')"; then
    rm -f "$tmpfile"
    echo "failed to calculate checksum: ${file}" >&2
    return 1
  fi

  rm -f "$tmpfile"
  printf '%s\n' "$checksum"
}

arm64_file=myip_Darwin_arm64.tar.gz
amd64_file=myip_Darwin_x86_64.tar.gz
sha256_arm64=$(gethash "$arm64_file")
sha256_amd64=$(gethash "$amd64_file")

if [[ -z "$sha256_arm64" || -z "$sha256_amd64" ]]; then
  echo "failed to resolve release checksums" >&2
  exit 1
fi

cd "${0%/*}"
tmpfile="$(mktemp myip.rb.XXXXXX)"
cat <<EOF > "$tmpfile"
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
  else
    odie "myip binary releases are only available for Apple Silicon and 64-bit Intel macOS"
  end

  def install
    bin.install "myip" => "myip"
  end
end
EOF
mv "$tmpfile" myip.rb
