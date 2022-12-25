#!/usr/bin/env sh
set -eu

envsubst '${nginx_user_composite_service_url} ${nginx_user_service_url} ${nginx_order_service_url} ${nginx_payments_service_url} ${nginx_order_composite_service_url} ${nginx_telegram_service_url} ${nginx_bidding_service_url}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"