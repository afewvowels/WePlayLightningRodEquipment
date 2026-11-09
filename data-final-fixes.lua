-- Unlock the recipe with a Fulgora technology if one exists; otherwise make
-- it available from the start so the mod never fails to load.
local recipe = data.raw["recipe"]["lre-lightning-rod-equipment"]
local candidates = { "planet-discovery-fulgora", "lightning-collector", "electromagnetic-science-pack" }

local unlocked = false
for _, tech_name in ipairs(candidates) do
  local tech = data.raw["technology"][tech_name]
  if tech then
    tech.effects = tech.effects or {}
    table.insert(tech.effects, { type = "unlock-recipe", recipe = "lre-lightning-rod-equipment" })
    unlocked = true
    break
  end
end

if not unlocked then
  recipe.enabled = true
end
