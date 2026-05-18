-- Visual and audio effects for pills system

-- Apply visual effects when taking a pill
function applyVisualEffects(pillType, pillData)
    local ped = PlayerPedId()
    
    if pillType == 'stimulant' then
        applyStimulantEffects()
    elseif pillType == 'sedative' then
        applySedativeEffects()
    elseif pillType == 'painkillers' then
        applyPainkillerEffects()
    elseif pillType == 'antibiotic' then
        applyAntibioticEffects()
    end
end

-- Stimulant visual effects
function applyStimulantEffects()
    if Config.VisualEffects.screenEffects then
        StartScreenEffect('DMT_fast', 30000, true)
    end
    
    if Config.Audio.enabled then
        PlaySoundFrontend(-1, Config.Audio.effectStartSound, 'CONFIRM_BEEP', true)
    end
    
    -- Visual feedback - slow motion effect briefly
    Wait(500)
    SetGameplayCamRelativeHeading(5.0)
    Wait(500)
end

-- Sedative visual effects
function applySedativeEffects()
    if Config.VisualEffects.screenEffects then
        StartScreenEffect('DeathFailOut', 20000, true)
    end
    
    local ped = PlayerPedId()
    RequestAnimDict('combat@damage@rb_writhe')
    while not HasAnimDictLoaded('combat@damage@rb_writhe') do
        Wait(10)
    end
    
    if not IsEntityPlayingAnim(ped, 'combat@damage@rb_writhe', 'rb_writhe_loop', 3) then
        TaskPlayAnim(ped, 'combat@damage@rb_writhe', 'rb_writhe_loop', 8.0, -8.0, 5000, 1, 0, false, false, false)
    end
end

-- Painkiller visual effects
function applyPainkillerEffects()
    if Config.VisualEffects.screenEffects then
        StartScreenEffect('RaceTurbo', 5000, true)
    end
    
    -- Subtle glow
    local ped = PlayerPedId()
    if GetEntityModel(ped) ~= nil then
        -- Can add shader effects here
    end
end

-- Antibiotic visual effects
function applyAntibioticEffects()
    if Config.VisualEffects.screenEffects then
        StartScreenEffect('Chop', 3000, true)
    end
end

-- Stop screen effects
function stopScreenEffect(effectName)
    StopScreenEffect(effectName)
end
