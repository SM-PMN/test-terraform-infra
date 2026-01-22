terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.1"
    }
  }
}

locals {
  base_path = var.base_dir != "" ? "${var.base_dir}/" : ""
}

resource "local_file" "files" {
  for_each = var.files

  filename = "${path.module}/${local.base_path}${each.key}"
  content  = each.value
}
