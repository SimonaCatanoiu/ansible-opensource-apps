#!/bin/bash

LETSENCRYPT_ROOT_DIR="/etc/letsencrypt/live";
NGINX_CONF_DIR="/etc/onlyoffice/documentserver/nginx";
CLOUDFLARE_CREDENTIALS="/etc/letsencrypt/cloudflare.ini";

if [ "$#" -ge "2" ]; then
    LETS_ENCRYPT_MAIL=$1
    LETS_ENCRYPT_DOMAIN=$2

    SSL_CERT="${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/fullchain.pem";
    SSL_KEY="${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/privkey.pem";

    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    echo certbot certonly --dns-cloudflare --dns-cloudflare-credentials ${CLOUDFLARE_CREDENTIALS} --noninteractive --agree-tos --email $LETS_ENCRYPT_MAIL -d $LETS_ENCRYPT_DOMAIN > /var/log/le-start.log

    certbot certonly --dns-cloudflare --dns-cloudflare-credentials ${CLOUDFLARE_CREDENTIALS} --noninteractive --agree-tos --email $LETS_ENCRYPT_MAIL -d $LETS_ENCRYPT_DOMAIN > /var/log/le-new.log

    if [ -f ${SSL_CERT} -a -f ${SSL_KEY} ]; then
        if [ -f ${NGINX_CONF_DIR}/ds-ssl.conf.tmpl ]; then
            SECURE_LINK_SECRET=$(grep -oP '(?<=secure_link_secret ).*(?=;)' ${NGINX_CONF_DIR}/ds.conf | head -1)
            cp -f ${NGINX_CONF_DIR}/ds-ssl.conf.tmpl ${NGINX_CONF_DIR}/ds.conf
            sed "s,\(set \+\$secure_link_secret\).*,\1 \"${SECURE_LINK_SECRET}\";," -i ${NGINX_CONF_DIR}/ds.conf
            sed 's,{{SSL_CERTIFICATE_PATH}},'"${SSL_CERT}"',' -i ${NGINX_CONF_DIR}/ds.conf
            sed 's,{{SSL_KEY_PATH}},'"${SSL_KEY}"',' -i ${NGINX_CONF_DIR}/ds.conf
        fi
    fi

    [ $(pgrep -x "systemd" | wc -l) -gt 0 ] && systemctl reload nginx || service nginx reload

    cat > ${DIR}/letsencrypt_cron.sh <<END
#!/bin/bash
certbot renew --dns-cloudflare --dns-cloudflare-credentials ${CLOUDFLARE_CREDENTIALS} >> /var/log/le-renew.log
[ \$(pgrep -x "systemd" | wc -l) -gt 0 ] && systemctl reload nginx || service nginx reload
END

    chmod a+x ${DIR}/letsencrypt_cron.sh

    cat > /etc/cron.d/letsencrypt <<END
@weekly root ${DIR}/letsencrypt_cron.sh
END

else
    echo "This script automatically gets Let's Encrypt SSL Certificates for Document Server"
    echo "usage:"
    echo "  documentserver-letsencrypt.sh EMAIL DOMAIN"
    echo "      EMAIL       Email used for registration and recovery contact."
    echo "      DOMAIN      Domain name to apply"
fi
