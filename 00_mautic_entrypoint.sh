#! /bin/sh
set -e
cd $ROOT
echo "Run nginx"
nginx

if [ "$PM2_RUN" != "decidim" ]; then
    sleep 20
fi