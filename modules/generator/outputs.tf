output "length_profiles" {
  value = length(var.profiles)
}

output profiles {
  value = var.profiles
}

output assoc-list {
  value = local.assoc-list
}