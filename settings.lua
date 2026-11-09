data:extend({
  {
    type = "double-setting",
    name = "lre-efficiency",
    setting_type = "startup",
    default_value = 0.3,
    minimum_value = 0.01,
    maximum_value = 1.0,
    order = "a"
  },
  {
    type = "double-setting",
    name = "lre-range",
    setting_type = "startup",
    default_value = 64.0,
    minimum_value = 1.0,
    maximum_value = 64.0,
    order = "b"
  },
  {
    type = "int-setting",
    name = "lre-capture-buffer-mj",
    setting_type = "startup",
    default_value = 1000,
    minimum_value = 10,
    maximum_value = 100000,
    order = "c"
  }
})
