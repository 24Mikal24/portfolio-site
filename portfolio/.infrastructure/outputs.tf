output "send_email_endpoint" {
  value = "${aws_api_gateway_stage.prod.invoke_url}/contact"
}