local MOD = "__WePlayLightningRodEquipment__"

local efficiency = settings.startup["lre-efficiency"].value
local range = settings.startup["lre-range"].value
local capture_mj = settings.startup["lre-capture-buffer-mj"].value

-- Hidden lightning attractor. control.lua keeps one of these on top of every
-- wearer, so lightning on Fulgora is pulled towards them. It is cloned from
-- the base-game lightning rod so every required field is already valid.
local attractor = table.deepcopy(data.raw["lightning-attractor"]["lightning-rod"])
attractor.name = "lre-hidden-attractor"
attractor.hidden = true
attractor.hidden_in_factoriopedia = true
attractor.minable = nil
attractor.placeable_by = nil
attractor.fast_replaceable_group = nil
attractor.next_upgrade = nil
attractor.corpse = nil
attractor.dying_explosion = nil
attractor.surface_conditions = nil
attractor.selectable_in_game = false
attractor.collision_mask = { layers = {} }
attractor.flags = {
  "placeable-neutral", "placeable-off-grid", "not-on-map", "not-blueprintable",
  "not-deconstructable", "not-repairable", "not-flammable", "not-rotatable",
  "not-upgradable", "hide-alt-info", "not-selectable-in-game"
}
attractor.chargable_graphics = {}          -- invisible
attractor.efficiency = efficiency
attractor.range_elongation = range
attractor.energy_source = {
  type = "electric",
  usage_priority = "primary-output",
  buffer_capacity = capture_mj .. "MJ",
}

-- Personal equipment. It is a battery itself, so the energy it captures is
-- stored in the grid and discharged to other equipment as needed.
local equipment = {
  type = "battery-equipment",
  name = "lre-lightning-rod-equipment",
  take_result = "lre-lightning-rod-equipment",
  sprite = {
    filename = MOD .. "/graphics/equipment/lightning-rod-equipment.png",
    width = 256, height = 512, priority = "medium", scale = 0.5,
  },
  shape = { width = 1, height = 2, type = "full" },
  energy_source = {
    type = "electric",
    usage_priority = "tertiary",
    buffer_capacity = "0MJ",
    input_flow_limit = "0MW",
    output_flow_limit = "0MW",
  },
  categories = { "armor" },
}

local item = {
  type = "item",
  name = "lre-lightning-rod-equipment",
  icon = MOD .. "/graphics/icons/lightning-rod-equipment.png",
  icon_size = 512,
  place_as_equipment_result = "lre-lightning-rod-equipment",
  subgroup = "military-equipment",
  order = "a[energy-source]-d[lre-lightning-rod-equipment]",
  inventory_move_sound = data.raw["item"]["battery-equipment"] and data.raw["item"]["battery-equipment"].inventory_move_sound or nil,
  pick_sound = data.raw["item"]["battery-equipment"] and data.raw["item"]["battery-equipment"].pick_sound or nil,
  drop_sound = data.raw["item"]["battery-equipment"] and data.raw["item"]["battery-equipment"].drop_sound or nil,
  stack_size = 20,
}

local recipe = {
  type = "recipe",
  name = "lre-lightning-rod-equipment",
  enabled = false,
  energy_required = 10,
  ingredients = {
    { type = "item", name = "lightning-rod", amount = 1 },
    { type = "item", name = "battery", amount = 10 },
    { type = "item", name = "battery-equipment", amount = 1 },
    { type = "item", name = "processing-unit", amount = 4 },
  },
  results = { { type = "item", name = "lre-lightning-rod-equipment", amount = 1 } },
}

data:extend({ attractor, equipment, item, recipe })
