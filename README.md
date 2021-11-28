# go-ngrok
基于go1.16.10和ngrok1.7打包的镜像进行交叉编译

# 依赖
需要docker环境

# 目录结构
bin/     编译的客户端和服务端目录
ca/      证书挂载目录
build.sh 交叉编译脚本
script.sh 交叉编译例子

# 例子
build.sh
## 没有证书
```bash
# USE_CUSTMER_CA = 0
# NGROK_DOMAIN = 签发证书的域名
 ./script.sh NGROK_DOMAIN USE_CUSTMER_CA
```
## 有自己证书
```bash
# USE_CUSTMER_CA = 1 替换ca目录下的三个文件
cp yourrootCA.key ca/rootCA.key
cp yourrootCA.pem ca/rootCA.pem
cp yourdevice.crt ca/device.crt
# NGROK_DOMAIN = 签发证书的域名
 ./script.sh NGROK_DOMAIN USE_CUSTMER_CA
```
## 注意
*每次主域名修改需要修改证书*
*每次证书修改需要重新编译*