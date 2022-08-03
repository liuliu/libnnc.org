#!/usr/bin/env bash

set -euo pipefail

cd $(dirname $0)

for i in ../../s4nnc/nnc/*.swift ; do
    ../../SourceKitten/.build/release/sourcekitten doc --single-file $i -- ../../s4nnc/nnc/*.swift > _s4nnc/$(basename $i .swift).json
done

for i in $(find ../../s4nnc/gym -name '*.swift') ; do
    ../../SourceKitten/.build/release/sourcekitten doc --single-file $i -- ../../s4nnc/gym/*.swift ../../s4nnc/gym/envs/*.swift ../../s4nnc/gym/policies/*.swift ../../s4nnc/gym/renders/*.swift ../../s4nnc/gym/http/*.swift > _s4nnc/$(basename $i .swift).json
done

for i in $(find ../../s4nnc/tensorboard -name '*.swift') ; do
    ../../SourceKitten/.build/release/sourcekitten doc --single-file $i -- ../../s4nnc/tensorboard/*.swift ../../s4nnc/tensorboard/proto-generated/*.swift > _s4nnc/$(basename $i .swift).json
done

cp ../../s4nnc/README.md  _s4nnc/

cd _s4nnc

jq -s . *.json > s4nnc.json

jazzy --sourcekitten-sourcefile s4nnc.json --module "Swift for NNC"
