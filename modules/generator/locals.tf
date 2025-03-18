locals {
  assoc-list = flatten(
    [
      for profile in keys(var.profiles): [
        for rule in var.profiles[profile].rules : {
          profile = profile
          rule    = rule
        }
      ]
    ]
  )
}