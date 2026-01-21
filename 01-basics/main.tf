terraform {
  required_version = ">= 1.6"

  backend "local" { path = "terraform.tfstate" }

  required_providers {
    random = { source = "hashicorp/random", version = "~> 3.8.0" }
    local  = { source = "hashicorp/local", version = "~> 2.5.1" }
  }
}

variable "message" {
  type        = string
  description = "Текст для файла"
  default     = "Hello from variables!"
}

variable "count_files" {
  type        = number
  description = "Сколько файлов создать"
  default     = 3
}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# Количество итераций (копий) для ресурса определяется в параметре count
# Номер итерации (копии) хранится в count.index
# local_file.files = массив ресурсов files[0], files[1], files[2]
resource "local_file" "files" {
  count    = var.count_files
  filename = "${path.module}/file_${count.index + 1}_${random_string.suffix.result}.txt"
  content  = "${var.message} (file ${count.index + 1})\n"
}

# Список путей к созданным файлам
output "created_files" {
  value = [for f in local_file.files : f.filename]
}
