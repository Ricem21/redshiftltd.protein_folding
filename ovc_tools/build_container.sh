#!/bin/bash

set -e



while getopts ":f" opt; do

  case $opt in
    f)
      echo "-f [full build] was triggered"
      ../repo.sh build -c
      ../repo.sh build -r
      ../repo.sh precache_exts -u
      ../repo.sh package
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

VERSION="2.0"
APP="redshiftltd.protein_folding"

FAT_PACKAGE=$(find ../_build -name \*.zip)

cp $FAT_PACKAGE fat-pack.zip

# docker build . -t my_usd_explorer:106.0.2 --build-arg FAT_PACK=./kit-app-template-fat@106.0.2+main.0.70f7641d.local.linux-x86_64.release.zip --build-arg OVC_KIT=my_company.my_usd_explorer_streaming.kit

echo $APP"_streaming.kit"

docker build --build-arg OVC_KIT=$APP"_streaming.kit" \
    --build-arg FAT_PACK=./fat-pack.zip . -t $APP:$VERSION

docker images


rm fat-pack.zip
