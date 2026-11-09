local ATTRACTOR = "lre-hidden-attractor"
local EQUIPMENT = "lre-lightning-rod-equipment"
local PLANET = "fulgora"
local UPDATE_INTERVAL = 6 -- ticks

local function init()
  storage.attractors = storage.attractors or {} -- [player_index] = LuaEntity
end

script.on_init(init)
script.on_configuration_changed(init)

local function on_fulgora(surface)
  return surface and surface.planet and surface.planet.name == PLANET
end

local function has_rod(grid)
  if not (grid and grid.valid) then return false end
  for _, eq in pairs(grid.equipment) do
    if eq.name == EQUIPMENT then return true end
  end
  return false
end

local function remove_attractor(player_index)
  local ent = storage.attractors[player_index]
  if ent and ent.valid then ent.destroy() end
  storage.attractors[player_index] = nil
end

-- Move energy captured by the attractor into the batteries of the wearer's
-- equipment grid. Whatever does not fit stays in the attractor's buffer and
-- is retried on the next update.
local function transfer_energy(attractor, grid)
  local available = attractor.energy
  if available <= 0 then return end

  for _, eq in pairs(grid.equipment) do
    if available <= 0 then break end
    if eq.type == "battery-equipment" then
      local room = eq.max_energy - eq.energy
      if room > 0 then
        local moved = math.min(room, available)
        eq.energy = eq.energy + moved
        available = available - moved
      end
    end
  end

  attractor.energy = available
end

local function update_player(player)
  local index = player.index
  local character = player.character
  local ent = storage.attractors[index]

  local active = player.connected
    and character and character.valid
    and on_fulgora(character.surface)
    and has_rod(character.grid)

  if not active then
    if ent then remove_attractor(index) end
    return
  end

  if not (ent and ent.valid) or ent.surface ~= character.surface then
    if ent then remove_attractor(index) end
    ent = character.surface.create_entity{
      name = ATTRACTOR,
      position = character.position,
      force = character.force,
      raise_built = false,
    }
    storage.attractors[index] = ent
  elseif ent.valid then
    ent.teleport(character.position)
  end

  if ent and ent.valid then
    transfer_energy(ent, character.grid)
  end
end

script.on_nth_tick(UPDATE_INTERVAL, function()
  for _, player in pairs(game.connected_players) do
    update_player(player)
  end
  -- Clean up attractors for players who disconnected or were removed.
  for index in pairs(storage.attractors) do
    local player = game.get_player(index)
    if not (player and player.valid and player.connected) then
      remove_attractor(index)
    end
  end
end)

script.on_event(defines.events.on_player_died, function(event)
  remove_attractor(event.player_index)
end)

script.on_event(defines.events.on_player_left_game, function(event)
  remove_attractor(event.player_index)
end)
