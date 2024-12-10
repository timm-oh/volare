#!/bin/bash

# Input arguments
HEADER=$1
PAYLOAD=$2
PRIVATE_KEY_FILE=$3

# Base64 URL encode function
base64url_encode() {
    echo -n "$1" | openssl base64 -e | tr -d '=' | tr '/+' '_-' | tr -d '\n'
}

# Encode header and payload
HEADER_BASE64=$(base64url_encode "$HEADER")
PAYLOAD_BASE64=$(base64url_encode "$PAYLOAD")

# Create the data to be signed
DATA_TO_SIGN="${HEADER_BASE64}.${PAYLOAD_BASE64}"

# Generate the signature using the private key
SIGNATURE=$(echo -n "$DATA_TO_SIGN" | openssl dgst -sha256 -sign "$PRIVATE_KEY_FILE" -sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:-1 | openssl base64 -e | tr -d '=' | tr '/+' '_-' | tr -d '\n')

# Combine to form the JWS
JWS="${HEADER_BASE64}.${PAYLOAD_BASE64}.${SIGNATURE}"

# Output the JWS
echo -n "$JWS"
