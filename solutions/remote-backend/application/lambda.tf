module "lambda_trump_quote" {
  source = "./lambda"

  project = local.project
  stage   = local.stage

  function_name = local.lambda_function_name
  memory_size   = 258
  timeout       = 5
}
