variable "servidores" {
  description = "Servers name"

  type = map(object({
    name = string
  }))

  default = {
    "class_master"  = { name = "master" }
    "class_worker1" = { name = "worker1" }
    "class_worker2" = { name = "worker2" }
  }

}