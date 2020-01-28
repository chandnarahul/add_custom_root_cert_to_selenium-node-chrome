FROM selenium/node-chrome

USER root

COPY ./certs/* /etc/ssl/certs/

RUN apt-get -yqq update && \
    apt-get -yqq install --no-install-recommends ca-certificates && \
    apt-get -yqq install --no-install-recommends libnss3-tools && \
    update-ca-certificates 2>/dev/null || true && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER seluser

RUN mkdir -p $HOME/.pki/nssdb && \
    ls -lrt /etc/ssl/certs/ && \
    certutil -d $HOME/.pki/nssdb -N && \
    for f in /etc/ssl/certs/*.pem; do if [ ! -h "$f" ]; then echo "$f"; certutil -A -t "C,," -d sql:$HOME/.pki/nssdb -n "$(basename "$f")" -i "$f"; fi; done
