Config = {}

-- Pill Types and Effects
Config.Pills = {
    ['painkillers'] = {
        label = 'Painkillers',
        item = 'painkillers',
        duration = 600000, -- 10 minutes in ms
        effects = {
            health = 25,
            stamina = 15,
            pain_relief = true,
        },
        animation = 'mp_player_intcelebration_tomjack',
        animDict = 'mp_player_intcelebration_tojon',
        animFlag = 49,
        model = 'prop_cs_tablet_02',
        removeItem = true,
        description = 'Effective pain relief medication'
    },
    ['antibiotic'] = {
        label = 'Antibiotics',
        item = 'antibiotic',
        duration = 1200000, -- 20 minutes
        effects = {
            health = 40,
            stamina = 20,
            infection_cure = true,
        },
        animation = 'mp_player_intcelebration_tojon',
        animDict = 'mp_player_intcelebration_tojon',
        animFlag = 49,
        model = 'prop_cs_tablet_02',
        removeItem = true,
        description = 'Antibiotic medication for infections'
    },
    ['stimulant'] = {
        label = 'Stimulant Pills',
        item = 'stimulant',
        duration = 900000, -- 15 minutes
        effects = {
            stamina = 50,
            speed = 1.2, -- 20% speed boost
            focus = true,
        },
        animation = 'mp_player_intcelebration_tojon',
        animDict = 'mp_player_intcelebration_tojon',
        animFlag = 49,
        model = 'prop_cs_tablet_02',
        removeItem = true,
        description = 'Energy boost and focus enhancement'
    },
    ['sedative'] = {
        label = 'Sedative Pills',
        item = 'sedative',
        duration = 300000, -- 5 minutes
        effects = {
            stamina = -30,
            calm = true,
            drowsy = true,
        },
        animation = 'mp_player_intcelebration_tojon',
        animDict = 'mp_player_intcelebration_tojon',
        animFlag = 49,
        model = 'prop_cs_tablet_02',
        removeItem = true,
        description = 'Calming sedative medication'
    },
    ['vitamin'] = {
        label = 'Vitamins',
        item = 'vitamin',
        duration = 1800000, -- 30 minutes
        effects = {
            health = 15,
            stamina = 25,
            immunity = true,
        },
        animation = 'mp_player_intcelebration_tojon',
        animDict = 'mp_player_intcelebration_tojon',
        animFlag = 49,
        model = 'prop_cs_tablet_02',
        removeItem = true,
        description = 'Daily vitamin supplement'
    },
    ['aspirin'] = {
        label = 'Aspirin',
        item = 'aspirin',
        duration = 480000, -- 8 minutes
        effects = {
            health = 10,
            pain_relief = true,
        },
        animation = 'mp_player_intcelebration_tojon',
        animDict = 'mp_player_intcelebration_tojon',
        animFlag = 49,
        model = 'prop_cs_tablet_02',
        removeItem = true,
        description = 'Common aspirin for headaches'
    },
}

-- Side Effects Configuration
Config.SideEffects = {
    enabled = true,
    -- Chance of side effects (0-100)
    chance = 15,
    effects = {
        nausea = {
            duration = 60000,
            description = 'Feeling nauseous'
        },
        dizziness = {
            duration = 45000,
            description = 'Vision spinning'
        },
        headache = {
            duration = 120000,
            description = 'Sharp headache'
        },
        tremor = {
            duration = 90000,
            description = 'Hand tremors'
        },
    }
}

-- Visual Effects
Config.VisualEffects = {
    enabled = true,
    -- Particles and screen effects
    particleSet = 'core',
    particleName = 'mps_gunflash',
    screenEffects = true,
    -- Motion blur when taking stimulants
    motionBlur = true,
}

-- Notifications
Config.Notifications = {
    duration = 5000,
    position = 'top',
    -- Notification styles
    success = 'success',
    error = 'error',
    info = 'inform',
}

-- Audio Settings
Config.Audio = {
    enabled = true,
    -- Sound effects when taking pills
    swallowSound = 'CONFIRM_BEEP',
    effectStartSound = 'CONFIRM_BEEP',
    effectEndSound = 'CONFIRM_BEEP',
}

-- Addiction System (Optional)
Config.Addiction = {
    enabled = false,
    -- Pills that can cause addiction
    addictive = {'stimulant', 'sedative'},
    -- Addiction chance per use (0-100)
    chance = 5,
    -- Withdrawal duration
    withdrawalDuration = 600000,
}

-- Overdose System
Config.Overdose = {
    enabled = true,
    -- Maximum pills in 5 minutes before overdose
    maxPillsInTime = 4,
    timeWindow = 300000, -- 5 minutes
    -- Overdose effects
    damage = 20,
    duration = 180000,
    description = 'Overdose - severe side effects'
}

-- Commands
Config.Commands = {
    takepill = 'takepill',
    pillstatus = 'pillstatus',
    cleareffects = 'cleareffects',
}

-- Debug Mode
Config.Debug = false
