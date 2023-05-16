NGX_VERSION=1.23.4
mv -vf ./nginx/conf/ ./nginx/conf.bak/ >> /dev/null

tmpdir=$(pwd)/../nginx
docker pull nginx:${NGX_VERSION}-alpine
docker run --rm -v $tmpdir/conf/:/out nginx:${NGX_VERSION}-alpine cp -Rf /etc/nginx/* /out