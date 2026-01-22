terraform {
  required_version = ">= 1.4.0"
  backend "local" { path = "terraform.tfstate" }

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.1"
    }
  }
}

resource "local_file" "example" {
  filename = "${path.module}/example.txt"
  content  = "Hello from Day 7\n"
}

output "file_path" {
  value = local_file.example.filename
}
