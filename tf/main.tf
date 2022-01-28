terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "lendesk"

    workspaces {
      prefix = "agnes-poc-"
    }
  }
}
