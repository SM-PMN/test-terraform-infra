output "file_map" {
  description = "Карта: имя файла → полный путь"
  value       = { for k, f in local_file.files : k => f.filename }
}

output "filenames" {
  description = "Список путей (отсортирован по ключу)"
  value       = [for k in sort(keys(local_file.files)) : local_file.files[k].filename]
}
