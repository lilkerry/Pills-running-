local QBCore = exports['qb-core']:GetCoreObject()
local pillTaken = {}
local activePillEffects = {}
local pillCount = 0
local lastPillTime = 0

-- Initialize
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    if Config.Debug then
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {'Pills System', 'Pills system initialized!'}
        })
    end
end)

-- Take Pill Command
RegisterCommand(Config.Commands.takepill, function(source, args, rawCommand)
    if #args < 1 then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {'Pills', 'Usage: /' .. Config.Commands.takepill .. ' [pill_type]'}
        })
        return
    end
    
    local pillType = string.lower(args[1])
    takePill(pillType)
end)

-- Status Command
RegisterCommand(Config.Commands.pillstatus, function(source, args, rawCommand)
    showPillStatus()
end)

-- Clear Effects Command (Admin)
RegisterCommand(Config.Commands.cleareffects, function(source, args, rawCommand)
    activePillEffects = {}
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {'Pills', 'All effects cleared!'}
    })
end)

-- Take Pill Function
function takePill(pillType)
    local playerPed = PlayerPedId()
    
    -- Check if pill type exists
    if not Config.Pills[pillType] then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {'Pills', 'Pill type not found: ' .. pillType}
        })
        return
    end
    
    local pillData = Config.Pills[pillType]
    
    -- Check inventory
    local hasItem = QBCore.Functions.HasItem(pillData.item)
    if not hasItem then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {'Pills', 'You don\'t have this pill!'}
        })
        return
    end
    
    -- Check for overdose
    if Config.Overdose.enabled then
        local currentTime = GetGameTimer()
        if currentTime - lastPillTime <= Config.Overdose.timeWindow then
            pillCount = pillCount + 1
        else
            pillCount = 1
        end
        lastPillTime = currentTime
        
        if pillCount > Config.Overdose.maxPillsInTime then
            triggerOverdose()
            return
        end
    end
    
    -- Animation
    playTakePillAnimation(playerPed, pillData)
    
    -- Remove item
    if pillData.removeItem then
        TriggerServerEvent('Pills:RemoveItem', pillData.item)
    end
    
    -- Apply effects
    applyPillEffects(pillType, pillData)
    
    -- Check for side effects
    if Config.SideEffects.enabled and math.random(100) <= Config.SideEffects.chance then
        applySideEffect()
    end
    
    -- Notification
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {'Pills', 'You took ' .. pillData.label .. '...'}
    })
    
    -- Server event for logging
    TriggerServerEvent('Pills:LogPillUsage', pillType, pillData.label)
end

-- Play Animation
function playTakePillAnimation(ped, pillData)
    RequestAnimDict(pillData.animDict)
    while not HasAnimDictLoaded(pillData.animDict) do
        Wait(10)
    end
    
    TaskPlayAnim(ped, pillData.animDict, pillData.animation, 8.0, -8.0, -1, pillData.animFlag, 0, false, false, false)
    Wait(2000)
    ClearPedTasks(ped)
end

-- Apply Effects
function applyPillEffects(pillType, pillData)
    local currentTime = GetGameTimer()
    
    -- Store effect data
    activePillEffects[pillType] = {
        startTime = currentTime,
        duration = pillData.duration,
        effects = pillData.effects
    }
    
    -- Health effect
    if pillData.effects.health and pillData.effects.health > 0 then
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        SetEntityHealth(ped, math.min(health + pillData.effects.health, 200))
    end
    
    -- Speed effect
    if pillData.effects.speed then
        applySpeedEffect(pillData.effects.speed, pillData.duration)
    end
    
    -- Visual effects
    if Config.VisualEffects.enabled then
        applyVisualEffects(pillType, pillData)
    end
    
    -- Audio
    if Config.Audio.enabled then
        PlaySoundFrontend(-1, Config.Audio.swallowSound, 'CONFIRM_BEEP', true)
    end
end

-- Apply Speed Effect
function applySpeedEffect(speedMultiplier, duration)
    local ped = PlayerPedId()
    local startTime = GetGameTimer()
    
    while GetGameTimer() - startTime < duration do
        if GetSelectedPedOnMission() == ped then
            SetRunSprintMultiplierForPlayer(PlayerId(), speedMultiplier)
        end
        Wait(100)
    end
    
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

-- Side Effects
function applySideEffect()
    local effectNames = {}
    for name, _ in pairs(Config.SideEffects.effects) do
        table.insert(effectNames, name)
    end
    
    local randomEffect = effectNames[math.random(#effectNames)]
    local effectData = Config.SideEffects.effects[randomEffect]
    
    TriggerEvent('chat:addMessage', {
        color = {255, 165, 0},
        multiline = true,
        args = {'Warning', 'Side Effect: ' .. effectData.description}
    })
    
    if randomEffect == 'dizziness' then
        applyDizziness(effectData.duration)
    elseif randomEffect == 'nausea' then
        applyNausea(effectData.duration)
    elseif randomEffect == 'tremor' then
        applyTremor(effectData.duration)
    end
end

-- Dizziness Effect
function applyDizziness(duration)
    local startTime = GetGameTimer()
    
    while GetGameTimer() - startTime < duration do
        ShakeGameplayCam(0.5, 0.1)
        Wait(100)
    end
end

-- Nausea Effect
function applyNausea(duration)
    local startTime = GetGameTimer()
    local ped = PlayerPedId()
    
    while GetGameTimer() - startTime < duration do
        if math.random(2) == 1 then
            ApplyDamageToPed(ped, 1, false)
        end
        Wait(500)
    end
end

-- Tremor Effect
function applyTremor(duration)
    local startTime = GetGameTimer()
    
    while GetGameTimer() - startTime < duration do
        if IsPlayerFreeAiming(PlayerId()) then
            ShakeGameplayCam(0.2, 0.05)
        end
        Wait(200)
    end
end

-- Overdose
function triggerOverdose()
    local ped = PlayerPedId()
    
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {'WARNING', 'OVERDOSE! Severe damage taken!'}
    })
    
    -- Screen effect
    StartScreenEffect('DrugsMichaelAliensFx', 10000, true)
    
    -- Damage
    ApplyDamageToPed(ped, Config.Overdose.damage, false)
    
    -- Camera shake
    for i = 1, 50 do
        ShakeGameplayCam(1.0, 0.5)
        Wait(100)
    end
end

-- Show Status
function showPillStatus()
    local status = 'Active Pills:\n'
    
    if next(activePillEffects) == nil then
        status = status .. 'None\n'
    else
        for pill, data in pairs(activePillEffects) do
            local elapsed = GetGameTimer() - data.startTime
            local remaining = math.max(0, data.duration - elapsed)
            local minutes = math.floor(remaining / 60000)
            local seconds = math.floor((remaining % 60000) / 1000)
            
            status = status .. pill .. ': ' .. string.format('%02d:%02d', minutes, seconds) .. '\n'
        end
    end
    
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {'Pills', status}
    })
end

-- Export functions
exports('TakePill', function(pillType)
    takePill(pillType)
end)

exports('GetActivePills', function()
    return activePillEffects
end)

exports('ClearEffects', function()
    activePillEffects = {}
end)
