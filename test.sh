#!/bin/bash
set -xe
test -e reproducible-apk-tools || \
  git clone -b v0.3.0 https://github.com/obfusk/reproducible-apk-tools.git
for dir in *; do
  test -e "$dir"/*-signed.apk || continue
  pushd "$dir"
  if [ "$dir" = com.starry.myne ]; then
    ../reproducible-apk-tools/zipalign.py --page-size 16 --pad-like-apksigner --replace \
      Myne-4.3.0-unsigned-FIXME.apk Myne-4.3.0-unsigned.apk
  fi
  apksigcopier compare ./*-signed.apk --unsigned ./*-unsigned.apk
  apksigcopier compare ./*-signed.apk{,}
  popd
done
