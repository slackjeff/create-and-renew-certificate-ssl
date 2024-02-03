#!/usr/bin/env bash
#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#
set -e

#----------------------------------------------------------------------------#
# CONFIGURAÇÃO
#----------------------------------------------------------------------------#
COUNTRY="BR"
STATE=""
CITY=""
ORG=""
RSA_SIZE="4096"
EXPIRATE_DATE="365"

#----------------------------------------------------------------------------#
# DOMINIOS para renovaçaão
#----------------------------------------------------------------------------#
DOMAINS=(
    "pihole.local.lab"
    "dashboard.local.lab"
    "jeffe.local.lab"
    "wiki.local.lab"
    "cockpit.local.lab"
    )
for DOMAIN in "${DOMAINS[@]}"; do
    if [[ ! -e "/etc/ssl/certs/${DOMAIN}.crt" ]]; then
        MSG="++++++++++++++++++ Certificado para ${DOMAIN} criado."
    fi
    # Renovação do certificado
    openssl req -x509 -nodes -days $EXPIRATE_DATE -newkey rsa:$RSA_SIZE \
    -keyout "/etc/ssl/certs/${DOMAIN}.key"             \
    -out "/etc/ssl/certs/${DOMAIN}.crt"                \
    -subj "/C=${COUNTRY}/ST=${STATE}/L=${CITY}/O=${ORG}/OU=Unit/CN=$DOMAIN"
    printf "${MSG:="++++++++++++++++++ Certificado para ${DOMAIN} renovado."}"
    unset MSG
done
# Reiniciando apache
systemctl restart apache2
