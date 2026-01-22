terraform {
  required_version = ">= 1.4.0"
  backend "local" { path = "terraform.tfstate" }

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8.0"
    }
  }
}

variable "app_name" {
  type        = string
  default     = "demo"
  description = "Имя приложения"
}

# Генерируем ID приложения
resource "random_string" "app_id" {
  length  = 6
  upper   = false
  special = false
}

# Создаём директорию (через local_file с directory_permission)
resource "local_file" "app_dir" {
  filename        = "${path.module}/${var.app_name}-${random_string.app_id.result}/.gitkeep"
  content         = ""
  file_permission = "0644"
}

# Файл конфигурации, который ссылается на имя директории
resource "local_file" "app_config" {
  filename = "${path.module}/config.txt"
  content  = <<-EOF
    app_name=${var.app_name}
    app_id=${random_string.app_id.result}
    app_dir=${dirname(local_file.app_dir.filename)}
  EOF
}

# Лог-файл, который должен создаваться ПОСЛЕ конфига
resource "local_file" "app_log" {
  filename = "${path.module}/app.log"
  content  = "Started at ${timestamp()}\nConfig: ${local_file.app_config.filename}\n"
}

resource "local_file" "ready" {
  filename = "${path.module}/READY"
  content  = "All resources initialized at ${timestamp()}\n"

  depends_on = [
    local_file.app_config,
    local_file.app_log
  ]
}

output "app_directory" {
  value = dirname(local_file.app_dir.filename)
}

output "app_id" {
  value = random_string.app_id.result
}
