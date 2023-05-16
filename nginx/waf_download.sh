NAME=ngx-$NGX_VERSION-module-current-musl
echo "$NAME"
docker pull "addsp/ngx_waf-prebuild:$NAME"
if [ $? -eq 0 ] ; then
    tmpdir=$(pwd)/../nginx
    docker run --rm -d -v "$tmpdir/modules/:/out" "addsp/ngx_waf-prebuild:$NAME" cp /modules/ngx_http_waf_module.so /out
    mv $tmpdir/modules/ngx_http_waf_module.so $tmpdir/modules/ngx_http_waf_module-$NGX_VERSION.so
    echo "please add \`load_module /modules/ngx_http_waf_module-$NGX_VERSION.so\` to first head of $tmpdir/conf/nginx.conf manualy"
    echo "Download complete!"
fi
