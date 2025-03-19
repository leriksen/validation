module "generator" {
  source = "./modules/generator"

  profiles = {
    profile1 = {
      capacity = {
        default = 1
        minimum = 1
        maximum = 1
      }
      rules = [
        {
          metric_trigger = {
            metric_name        = "CPUXNS"
            metric_resource_id = "module.servicebus.id"
            time_grain         = "PT1M"
            statistic          = "Max"
            time_window        = "PT5M"
            time_aggregation   = "Maximum"
            operator           = "GreaterThan"
            threshold          = 90
            metric_namespace   = "Microsoft.ServiceBus/Namespaces"
          }
          scale_action = {
            direction = "Increase"
            type      = "ChangeCount"
            value     = "1"
            cooldown  = "PT5M"
          }
        },
        {
          metric_trigger = {
            metric_name        = "CPUXNS"
            metric_resource_id = "module.servicebus.id"
            time_grain         = "PT1M"
            statistic          = "Min"
            time_window        = "PT5M"
            time_aggregation   = "Minimum"
            operator           = "LessThan"
            threshold          = 10
            metric_namespace   = "Microsoft.ServiceBus/Namespaces"
          }
          scale_action = {
            direction = "Decrease"
            type      = "ChangeCount"
            value     = "1"
            cooldown  = "PT5M"
          }
        }
      ]
    }
  }
}