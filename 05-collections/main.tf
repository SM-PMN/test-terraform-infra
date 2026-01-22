terraform {
  required_version = ">= 1.4.0"
  backend "local" { path = "terraform.tfstate" }

  required_providers {
    local = { source = "hashicorp/local", version = "~> 2.5.1" }
  }
}

# Карта "логических" файлов
# Делает 
variable "files" {
  description = "Набор логических файлов: ключ = имя, значение = содержимое"
  # Создаем ассоциативный массив
  type = map(string)
  # Наполняем ассоциативный массив
  default = {
    "app"    = "app config"
    "db"     = "db config"
    "logger" = "logger config"
  }
}

# Делаем из map (ассоциативный массив) список структур через for-выражение
# { name = "app", content = "app config", path = "./app.txt" } и т.д.
# Получается local.files_list = [{nam="app"...}, {name="db"...}, {name="logger"}...]
locals {
  files_list = [
    for name, content in var.files : {
      name    = name
      content = content
      path    = "${path.module}/${name}.txt"
    }
  ]
}

# Создаём реальные файлы через for_each
# Здесь создаются файлы с именем f.name, т.е. app.txt, db.txt, logger.txt
# Ранее подобное делалось через count, можно и циклом "для каждого"
# each специальный объект Terraform, существует только для ТЕКУЩЕГО ресурса
# each.value - содержит структуру в данном примере {name, path, content}
resource "local_file" "configs" {
  for_each = {
    for f in local.files_list :
    f.name => f
  }
  # each.value.path - берет каждый путь (path) из структуры в locals.files_list
  filename = each.value.path
  content  = "name=${each.value.name}\ncontent=${each.value.content}\n"
}

output "created_files" {
  value = [for f in local_file.configs : f.filename]
}
