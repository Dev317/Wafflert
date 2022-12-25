output "mysql_endpoint" {
  value = aws_db_instance.g1t3-sharedmysql.endpoint
}

output "telegram_repo_ecr" {
  value = aws_ecr_repository.telegram_repo.repository_url
}

output "user_interface_repo_ecr" {
  value = aws_ecr_repository.user_interface_repo.repository_url
}

output "users_repo_ecr" {
  value = aws_ecr_repository.users_repo.repository_url
}

output "payments_repo_ecr" {
  value = aws_ecr_repository.payments_repo.repository_url
}

output "user_management_repo_ecr" {
  value = aws_ecr_repository.user_management_repo.repository_url
}

output "orders_repo_ecr" {
  value = aws_ecr_repository.orders_repo.repository_url
}

output "orders_management_repo_ecr" {
  value = aws_ecr_repository.orders_management_repo.repository_url
}

output "notifications_repo_ecr" {
  value = aws_ecr_repository.notifications_repo.repository_url
}

output "bidding_repo_ecr" {
  value = aws_ecr_repository.bidding_repo.repository_url
}

output "user_register_url" {
  value = "${aws_api_gateway_deployment.user_register_api_deployment.invoke_url}/user/register"
}

output "user_login_url" {
  value = "${aws_api_gateway_deployment.user_login_api_deployment.invoke_url}/user/login"
}

output "user_update_password_url" {
  value = "${aws_api_gateway_deployment.user_update_password_api_deployment.invoke_url}/user/update-password/{id}"
}

output "user_retrieve_url" {
  value = "${aws_api_gateway_deployment.user_retrieve_api_deployment.invoke_url}/user/retrieve/{id}"
}

output "user_update_telegram_id_url" {
  value = "${aws_api_gateway_deployment.user_update_telegram_id_api_deployment.invoke_url}/user/update-telegram-id/{id}"
}

output "user_delete_url" {
  value = "${aws_api_gateway_deployment.user_delete_api_deployment.invoke_url}/delete-waffle-user/{id}"
}

output "payments_get_all_url" {
  value = "${aws_api_gateway_deployment.payments_api_deployment.invoke_url}/payments"
}

output "payments_get_specific_url" {
  value = "${aws_api_gateway_deployment.specific_payments_get_api_deployment.invoke_url}/payments/{id}"
}

output "payments_delete_specific_url" {
  value = "${aws_api_gateway_deployment.specific_payments_delete_api_deployment.invoke_url}/payments/{id}"
}

output "payments_post_url" {
  value = "${aws_api_gateway_deployment.payments_post_api_deployment.invoke_url}/payments"
}

output "payments_patch_url" {
  value = "${aws_api_gateway_deployment.payments_patch_api_deployment.invoke_url}/payments"
}

output "payments_accounts_get_url" {
  value = "${aws_api_gateway_deployment.payments_accounts_get_api_deployment.invoke_url}/payments/accounts"
}

output "payments_accounts_post_url" {
  value = "${aws_api_gateway_deployment.payments_accounts_post_api_deployment.invoke_url}/payments/accounts"
}

output "payments_accounts_setup_link_get_url" {
  value = "${aws_api_gateway_deployment.payments_accounts_setup_link_get_api_deployment.invoke_url}/payments/accounts/setup-link/{id}"
}


output "payments_accounts_setup_secret_get_url" {
  value = "${aws_api_gateway_deployment.payments_accounts_setup_secret_get_api_deployment.invoke_url}/payments/accounts/setup-secret/{id}"
}

output "payments_accounts_payment_methods_get_url" {
  value = "${aws_api_gateway_deployment.payments_accounts_payment_methods_get_api_deployment.invoke_url}/payments/accounts/payment-methods/{id}"
}

output "payments_accounts_connected_account_verified_get_url" {
  value = "${aws_api_gateway_deployment.connected-account-verified_get_api_deployment.invoke_url}/payments/accounts/connected-account-verified/{id}"
}

output "orders_get_all_url" {
  value = "${aws_api_gateway_deployment.get_all_orders_api_deployment.invoke_url}/orders"
}

output "get_specific_order_url" {
  value = "${aws_api_gateway_deployment.get_specific_order_api_deployment.invoke_url}/orders/{id}"
}

output "patch_specific_order_url" {
  value = "${aws_api_gateway_deployment.patch_specific_order_api_deployment.invoke_url}/orders/{id}"
}

output "order_post_url" {
  value = "${aws_api_gateway_deployment.post_order_api_deployment.invoke_url}/order"
}

output "get_order_by_username_url" {
  value = "${aws_api_gateway_deployment.get_orders-by-username_proxy_api_deployment.invoke_url}/orders/orders-by-username/{id}"
}

output "get_run_by_username_url" {
  value = "${aws_api_gateway_deployment.get_runs-by-username_proxy_api_deployment.invoke_url}/orders/runs-by-username/{id}"
}

output "get_past_orders_url" {
  value = "${aws_api_gateway_deployment.get_past_orders_proxy_api_deployment.invoke_url}/past_orders/{id}"
}

output "get_past_runs_url" {
  value = "${aws_api_gateway_deployment.get_past_runs_proxy_api_deployment.invoke_url}/past_runs/{id}"
}

output "user_mgmt_register_url" {
  value = "${aws_api_gateway_deployment.user-mgmt-register_api_deployment.invoke_url}/user-mgmt/register"
}

output "user_mgmt_telegram_url" {
  value = "${aws_api_gateway_deployment.user-mgmt-register_api_deployment.invoke_url}/user-mgmt/telegram"
}

output "user_mgmt_onboarding_url" {
  value = "${aws_api_gateway_deployment.user-mgmt-onboarding-status-proxy_api_deployment.invoke_url}/user-mgmt/onboarding-status/{id}"
}

output "place_order_url" {
  value = "${aws_api_gateway_deployment.place_order_api_deployment.invoke_url}/place-order"
}

output "rabbitmq_endpoint" {
  value = aws_mq_broker.rabbitmq_broker.instances.0.endpoints.0
}

output "get_all_bids_url" {
  value = "${aws_api_gateway_deployment.get_all_bids_api_deployment.invoke_url}/bids"
}

output "get_specific_bid_url" {
  value = "${aws_api_gateway_deployment.get_specific_bid_api_deployment.invoke_url}/bids/{id}"
}

output "patch_specific_bid_url" {
  value = "${aws_api_gateway_deployment.patch_specific_bid_api_deployment.invoke_url}/bids/{id}"
}

output "delete_specific_bid_url" {
  value = "${aws_api_gateway_deployment.delete_specific_bid_api_deployment.invoke_url}/bids/{id}"
}

output "post_bid_url" {
  value = "${aws_api_gateway_deployment.post_bid_api_deployment.invoke_url}/bids"
}

output "patch_fufilled_bid_url" {
  value = "${aws_api_gateway_deployment.patch_fufill_bid_proxy_api_deployment.invoke_url}/bids/fufill-bid/{id}"
}
