locals {
  assoc-list = flatten(
    [
      for name, profile in var.profiles: [
        for rule in profile.rules : [
          contains(["Equals", "NotEquals", "GreaterThan", "GreaterThanOrEqual", "LessThan", "LessThanOrEqual"], rule.metric_trigger.operator)
        ]
      ]
    ]
  )
}