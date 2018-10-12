# rpi-cfssl
Raspberry Pi Docker Container for Cloudflare's PKI and TLS toolkit

# TODO
- Yubikey for Root and Intermediate private key storage
- Do the whole CRL / OCSP thing

# Root
```
mkdir config/root
docker run --rm -v /home/crash/rpi-cfssl/config:/etc/cfssl cfssl genkey -initca root-csr.json | \
docker run --rm -i -v /home/crash/rpi-cfssl/config:/etc/cfssl --entrypoint cfssljson cfssl -bare root/root
openssl x509 -in config/root/root.pem -text -noout
```

# Intermediate
```
mkdir config/intermediate
docker run --rm -v /home/crash/rpi-cfssl/config:/etc/cfssl cfssl gencert -ca=root/root.pem -ca-key=root/root-key.pem -config=config.json -profile=intermediate intermediate-csr.json | \
docker run --rm -i -v /home/crash/rpi-cfssl/config:/etc/cfssl --entrypoint cfssljson cfssl -bare intermediate/intermediate
openssl x509 -in config/intermediate/intermediate.pem -text -noout
cat config/root/root.pem config/intermediate/intermediate.pem > config/intermediate/ca-chain.pem
```

# Server
```
mkdir config/server
docker run --rm -v /home/crash/rpi-cfssl/config:/etc/cfssl cfssl gencert -ca=intermediate/intermediate.pem -ca-key=intermediate/intermediate-key.pem -config=config.json -profile=server server-csr.json | \
docker run --rm -i -v /home/crash/rpi-cfssl/config:/etc/cfssl --entrypoint cfssljson cfssl -bare server/server
openssl x509 -in config/server/server.pem -text -noout
openssl verify -CAfile config/intermediate/ca-chain.pem config/server/server.pem
```

# Client
```
mkdir config/user1
docker run --rm -v /home/crash/rpi-cfssl/config:/etc/cfssl cfssl gencert -ca=intermediate/intermediate.pem -ca-key=intermediate/intermediate-key.pem -config=config.json -profile=client client-csr.json | \
docker run --rm -i -v /home/crash/rpi-cfssl/config:/etc/cfssl --entrypoint cfssljson cfssl -bare user1/user1
openssl x509 -in config/user1/user1.pem -text -noout
openssl verify -CAfile config/intermediate/ca-chain.pem config/user1/user1.pem
```
