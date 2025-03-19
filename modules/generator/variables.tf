variable profiles {
  description = "Deploy an autoscaler for a resource, triggered from monitoring a metric condition"
  type = map(
    object({
      capacity = object({
        default = number
        minimum = number
        maximum = number
      })
      rules = list(
        object({
          metric_trigger = object({
            metric_name        = string
            metric_resource_id = string
            time_grain         = string
            statistic          = string
            time_window        = string
            time_aggregation   = string
            operator           = string
            threshold          = number
            metric_namespace   = string
          })
          scale_action = object({
            direction = string
            type      = string
            value     = string
            cooldown  = string
          })
        })
      )
    })
  )

  validation {
    condition     = length(var.profiles) > 0 && length(var.profiles) <= 20
    error_message = "profiles map must have between 1 and 20 entries"
  }

  validation {
    condition = (
      alltrue(
        [
          for name, profile in var.profiles : (
            profile.capacity.minimum >  0                        &&
            profile.capacity.maximum <= 16                       &&
            profile.capacity.default <= profile.capacity.maximum &&
            profile.capacity.default >= profile.capacity.minimum
          )
        ]
      )
    )
    error_message = "capacity in a profile must specify minimum, maximum and defaults beween 1 and 16 message units,\n and minumum <= default, and default <= maximum"
  }

  validation {
    condition = (
      alltrue(
        flatten(
          [
            for name, profile in var.profiles: [
              for rule in profile.rules : [
                contains(["Equals", "NotEquals", "GreaterThan", "GreaterThanOrEqual", "LessThan", "LessThanOrEqual"], rule.metric_trigger.operator)
              ]
            ]
          ]
        )
      )
    )
    error_message = "a rules metric trigger operator must come from value in [Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEqual]"
  }

  validation {
    condition = (
      alltrue(
        flatten(
          [
            for profile in keys(var.profiles): [
              for rule in var.profiles[profile].rules : (
                contains(["Equals", "NotEquals", "GreaterThan", "GreaterThanOrEqual", "LessThan", "LessThanOrEqual"], rule.metric_trigger.operator)
              )
            ]
          ]
        )
      )
    )
    error_message = "a rules metric trigger operator must come from value in [Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEqual]"
  }

  validation {
    condition = (
      alltrue(
        flatten(
          [
            for profile in keys(var.profiles): [
              for rule in var.profiles[profile].rules : (
                contains(["Average", "Max", "Min", "Sum"], rule.metric_trigger.statistic)
              )
            ]
          ]
        )
      )
    )
    error_message = "a rules metric trigger statistic must come from value in [Average, Max, Min, Sum]"
  }

  validation {
    condition = (
      alltrue(
        flatten(
          [
            for profile in keys(var.profiles) : [
              for rule in var.profiles[profile].rules : (
               contains(["Average", "Count", "Maximum", "Minimum", "Last", "Total"], rule.metric_trigger.time_aggregation)
              )
            ]
          ]
        )
      )
    )
    error_message = "a rules metric trigger time_aggregation must come from value in [Average, Maximum, Minimum, Last, Total]"
  }

  validation {
    condition = (
      alltrue(
        flatten(
          [
            for profile in keys(var.profiles) : [
              for rule in var.profiles[profile].rules : (
                contains(["Increase", "Decrease"], rule.scale_action.direction)
              )
            ]
          ]
        )
      )
    )
    error_message = "a rules scale action direction must come from value in [Increase, Decrease]"
  }

  validation {
    condition = (
      alltrue(
        flatten(
          [
            for profile in keys(var.profiles) : [
              for rule in var.profiles[profile].rules : (
                contains(["ChangeCount", "ExactCount", "PercentChangeCount", "ServiceAllowedNextValue"], rule.scale_action.type)
              )
            ]
          ]
        )
      )
    )
    error_message = "a rules scale action type must come from value in [ChangeCount, ExactCount, PercentChangeCount and ServiceAllowedNextValue]"
  }
}