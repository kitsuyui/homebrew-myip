#!/usr/bin/env bash
set -euo pipefail

version="$(curl -fsSL --connect-timeout 30 --max-time 60 https://api.github.com/repos/kitsuyui/myip/releases/latest | jq -er .tag_name)"
if ! [[ "${version}" =~ ^v?[0-9]+\.[0-9]+\.[0-9]+[a-zA-Z0-9.+_-]*$ ]]; then
  echo "unexpected version tag: '${version}'" >&2
  exit 1
fi
homepage='https://github.com/kitsuyui/myip'

ruby_literal() {
  ruby -e 'print ARGV[0].dump' "$1"
}

gethash() {
  local file="$1"
  local tmpfile
  local checksum
  local attestation_output

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

  if ! attestation_output="$(gh attestation verify "$tmpfile" --repo kitsuyui/myip --format json 2>&1 > /dev/null)"; then
    if [[ "$attestation_output" == *"HTTP 404: Not Found"* ]]; then
      echo "warning: build provenance attestation not available for ${file}; continuing with SHA256 only" >&2
    else
      rm -f "$tmpfile"
      printf 'failed to verify build provenance attestation: %s\n' "$file" >&2
      printf '%s\n' "$attestation_output" >&2
      return 1
    fi
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

homepage_literal="$(ruby_literal "$homepage")"
head_literal="$(ruby_literal "${homepage}.git")"
version_literal="$(ruby_literal "$version")"
arm64_url_literal="$(ruby_literal "${homepage}/releases/download/${version}/${arm64_file}")"
amd64_url_literal="$(ruby_literal "${homepage}/releases/download/${version}/${amd64_file}")"
sha256_arm64_literal="$(ruby_literal "$sha256_arm64")"
sha256_amd64_literal="$(ruby_literal "$sha256_amd64")"

cd "${0%/*}"
tmpfile="$(mktemp myip.rb.XXXXXX)"
cat <<EOF > "$tmpfile"
class Myip < Formula
  homepage ${homepage_literal}

  stable do
    version ${version_literal}

    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url ${arm64_url_literal}
      sha256 ${sha256_arm64_literal}
    elsif Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url ${amd64_url_literal}
      sha256 ${sha256_amd64_literal}
    else
      odie "myip binary releases are only available for Apple Silicon and 64-bit Intel macOS"
    end
  end

  head do
    url ${head_literal}, branch: "main"
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
EOF
mv "$tmpfile" myip.rb
