terraform {
  required_version = ">= 1.6"
  backend "local" { path = "terraform.tfstate" }
  required_providers {
    local  = { source = "hashicorp/local", version = "~> 2.5.1" }
    random = { source = "hashicorp/random", version = "~> 3.8.0" }
  }
}

variable "service_name" {
  type        = string
  description = "Имя сервиса"
  default     = "demo"
}

variable "env" {
  type        = string
  description = "Окружение"
  default     = "dev"
}

variable "replicas" {
  type        = number
  description = "Сколько инстансов описать"
  default     = 3
}

# Сначала проводится вычисление локальных значений
# Создаются временные, локальные переменные только для текущего модуля
# Доступ к ним осуществляется через locals.имя
locals {
  stamp     = formatdate("YYYYMMDD-hhmmss", timestamp())
  slug      = lower(replace(var.service_name, " ", "-"))
  env_slug  = "${local.slug}-${var.env}"
  filenames = [for i in range(var.replicas) : "${path.module}/app_${local.env_slug}_${i + 1}.cfg"]
  header    = format("# service=%s env=%s generated=%s", local.slug, var.env, local.stamp)
}

# После локальных значений, вычисляются ресурсы вроде random_string
resource "random_string" "token" {
  length  = 12
  upper   = false
  special = false
}

# И только потом создаются ресурсы вроде local_file, подставляя готовые значения
resource "local_file" "configs" {
  count    = length(local.filenames)      # создает количество файлов, сколько имен в списке
  filename = local.filenames[count.index] # путь к i-ому файлу
  content  = <<-EOF
    ${local.header}
    token=${random_string.token.result}
    instance=${count.index + 1}/${var.replicas}
  EOF
}

output "config_files" {
  value = local.filenames
}
