# Допускаем пустую строку, но валидируем формат.
# Опциональный ресурс. Куда складывать файлы. По умолчанию корень модуля
variable "base_dir" {
  description = "Подкаталог внутри модуля (относительный). Пусто = корень модуля."
  type        = string
  default     = ""
  
  validation {
    condition     = var.base_dir == "" || !startswith(var.base_dir, "/")
    error_message = "base_dir должен быть относительным путем (не начинаться с '/')."
  }
  
  validation {
    condition     = var.base_dir == "" || !strcontains(var.base_dir, "..")
    error_message = "base_dir не должен содержать '..'."
  }
}

# Данные ресурс ждет на вход словарь, как в описании
variable "files" {
  description = "Карта файлов: key=имя файла, value=объект (content, file_permission)."
  type        = map(object({
    content         = string
    # Установить полномочия на файл
    file_permission = optional(string, "0644")
  }))
  
  validation {
    condition     = length(var.files) > 0
    error_message = "files не должен быть пустым."
  }
}
