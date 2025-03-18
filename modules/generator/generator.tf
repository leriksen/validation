resource  local_file "this" {
  content = jsonencode(var.profiles)
  filename = "here.json"
}