output "filenames" {
  description = "Список созданных файлов"
  value       = [for f in local_file.files : f.filename]
}

output "file_map" {
  description = "Карта: имя файла → полный путь"
  value       = { for k, f in local_file.files : k => f.filename }
}
