local ref_mindmg = ui.reference("RAGE", "Aimbot", "Minimum damage")
local ref_target = ui.reference("RAGE", "Aimbot", "Target selection")
local ref_hitchance = ui.reference("RAGE", "Aimbot", "Minimum hit chance")

local function get_damage(target)
    local enemy_health = entity.get_prop(target, "m_iHealth")
    local local_player = entity.get_local_player()
    local weapon = entity.get_player_weapon(local_player)
    local hitbox = 0 -- head
    local hitgroup = 0 -- generic

    local backtrack_ticks = ui.get(ref_target) == "Backtrack" and 12 or 0
    local spread, inaccuracy = weapon.get_spread(weapon)

    local local_pos = entity.get_abs_origin(local_player)
    local target_pos = entity.hitbox_position(target, hitbox, backtrack_ticks)

    local target_distance = (target_pos - local_pos):length()
    local damage = csgo.get_damage(weapon, hitbox, hitgroup, inaccuracy, spread, target_distance, false)

    return math.max(damage, enemy_health)
end

local function update_min_dmg()
    local local_player = entity.get_local_player()
    local enemies = entity.get_players(true)

    for i=1, #enemies do
        local enemy = enemies[i]
        if entity.is_enemy(enemy) and entity.is_alive(enemy) then
            local enemy_health = entity.get_prop(enemy, "m_iHealth")
            local target_pos = entity.hitbox_position(enemy, 0)

            if enemy_health <= 35 then
                ui.set(ref_mindmg, enemy_health + 1)
            elseif enemy_health <= 80 then
                ui.set(ref_mindmg, math.floor((enemy_health + 1) / 2))
            elseif enemy_health <= 90 then
                ui.set(ref_mindmg, math.floor((enemy_health + 1) / 3))
            elseif enemy_health <= 120 then
                ui.set(ref_mindmg, math.floor((enemy_health + 1) / 3.3))
            end
        end
    end
end

local function on_paint()
    update_min_dmg()
end

client.set_event_callback("paint", on_paint)
