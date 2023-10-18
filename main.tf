module "mymod" {
  source = "./modules/serverless_lambda"
  req_id = var.req_id
  additional_tags = var.additional_tags
}