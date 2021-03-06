#!/bin/sh
set -e

cat <<EOF > /srv/accounts/config.js
// IAM
const IAM_BASE_URL = '$IAM_BASE_URL';
const IAM_LOGIN_URL = IAM_BASE_URL + '$IAM_LOGIN_URL'
const IAM_VERIFY_URL = IAM_BASE_URL + '$IAM_VERIFY_URL'
const IAM_CREATE_ACCOUNT_URL = IAM_BASE_URL + '$IAM_CREATE_ACCOUNT_URL'
const IAM_GET_USER_DATA_URL = IAM_BASE_URL + '$IAM_GET_USER_DATA_URL'
const IAM_UPDATE_USER_DATA_URL = IAM_BASE_URL + '$IAM_UPDATE_USER_DATA_URL'

// Payments Service
const PAYMENT_BASE_URL = '$PAYMENT_BASE_URL'
const PAYMENT_CREATE_SESSION_URL = PAYMENT_BASE_URL + '$PAYMENT_CREATE_SESSION_URL'

// Stripe
const STRIPE_PUBLIC_KEY = '$STRIPE_PUBLIC_KEY';

// Website
const SUPPORT_EMAIL = '$SUPPORT_EMAIL';
const MAIN_WEBSITE_URL = '$MAIN_WEBSITE_URL';
const BLURB = '$BLURB';
EOF

exec /docker-entrypoint.sh "$@"
