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
  source = "./modules/fileset"

  # В переменную files модуля fileset загружаем данные
  files = {
    "app.conf"    = "app_name=demo\nport=8080\n"
    "db.conf"     = "db_host=localhost\ndb_port=5432\n"
    "logger.conf" = "level=info\nformat=json\n"
  }
}

output "app_config_files" {
  value = module.app_configs.filenames
}
