# $1 自定义域名 $2 是否使用自己的ca（0是 1不是）
docker run --rm  -v "$PWD"/ca:/ngrok/ca -v "$PWD"/bin:/ngrok/bin --env NGROK_DOMAIN=$1 --env USE_CUSTMER_CA=$2 go-ngrok:latest sh -c  \
'echo "--------------------- 公网 NGROK_DOMAIN : $NGROK_DOMAIN  ---------------------" \
&& if [ $USE_CUSTMER_CA == 1 ];then \
echo "--------------------- 使用自己证书 ... 生成中 ---------------------" \
&& if [ ! -e ca/rootCA.key ]; then
echo "--------------------- rootCA.key不存在,生成中 ---------------------" \
&& openssl genrsa -out ca/rootCA.key 2048; fi  \
&& if [ ! -e ca/rootCA.pem ]; then \
echo "--------------------- rootCA.pem不存在,生成中 ---------------------" \
&& openssl req -x509 -new -nodes -key ca/rootCA.key -subj "/CN=$NGROK_DOMAIN" -days 5000 -out ca/rootCA.pem; fi  \
&& if [ ! -e ca/device.key ]; then  \
echo "--------------------- device.key不存在,生成中 ---------------------" \
&& openssl genrsa -out ca/device.key 2048; fi  \
&& if [ ! -e ca/device.crt ]; then \
echo "--------------------- device.crt不存在,生成中 ---------------------" \
&& openssl req -new -key ca/device.key -subj "/CN=$NGROK_DOMAIN" -out ca/device.csr; fi  \
&& if [ ! -e ca/device.crt ]; then  openssl x509 -req -in ca/device.csr -CA ca/rootCA.pem -CAkey ca/rootCA.key -CAcreateserial -out ca/device.crt -days 5000; fi \
&& echo "--------------------- 证书生成完毕 ... 替换旧证书 ---------------------" \
&& cp ca/rootCA.pem assets/client/tls/ngrokroot.crt \
&& cp ca/device.crt assets/server/tls/snakeoil.crt \
&& cp ca/device.key assets/server/tls/snakeoil.key; fi \
&& echo "--------------------- $NGROK_DOMAIN证书就绪 ...编译中 ---------------------" \
&& make release-server \
&& make release-client \
&& CGO_ENABLED=0 GOOS=linux GOARCH=arm make release-client  \
&& CGO_ENABLED=0 GOOS=linux GOARCH=amd64 make release-client \
&& CGO_ENABLED=0 GOOS=windows GOARCH=amd64 make release-client \
&& CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 make release-client \
&& echo "--------------------- 编译完成 ---------------------" '

