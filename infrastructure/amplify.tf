data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "amplify-gitlab" {
  name               = "AmplifyGitlab"
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
}

resource "aws_amplify_app" "Wafflert" {
  name                     = "Wafflert"
  description              = "User-interface for Wafflert"
  repository               = "https://gitlab.com/cs302-2022/g1-team3/user-interface/user-interface"
  access_token             = ""
  iam_service_role_arn     = aws_iam_role.amplify-gitlab.arn
  enable_branch_auto_build = true

  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - npm install
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  custom_rule {
    source = "/<*>"
    status = "404-200"
    target = "/index.html"
  }

  environment_variables = {
    REACT_APP_NODE_ENV = "production"
    REACT_APP_API_ENDPOINT = "https://mecowzaii5.execute-api.us-east-2.amazonaws.com/v1"
    REACT_APP_STRIPE_API_KEY = "pk_test_51LsLPgIxgWYWAssYYA6uBMFlJNcCMokvMpDyU72q7mn1TBAgD8iN6IjHxxXzUwgzKKfdFclsppEBEhtx3eDLeDiM00XNQdKKXm"
  }

}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.Wafflert.id
  branch_name = "main"
  framework   = "React"
  stage       = "PRODUCTION"
}
