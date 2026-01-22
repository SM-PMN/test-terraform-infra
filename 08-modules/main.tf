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

module "app_configs" {
  # Подключаются дочерние модули
  source   = "./modules/fileset"
  # Передается директория в подключаемый модуль 
  base_dir = "app"

  # В переменную files файла modules/fileset/variables.tf загружаем данные
  files = {
    "app.conf" = {
      content         = "app_name=demo\nport=8080\n"
      file_permission = "0644"
    }
    "db.conf" = {
      content         = "db_host=localhost\ndb_port=5432\n"
      file_permission = "0600"
    }
    "logger.conf" = {
      content         = "level=info\nformat=json\n"
      file_permission = "0644"
    }
  }
}

output "app_config_files" {
  value = module.app_configs.filenames
}
