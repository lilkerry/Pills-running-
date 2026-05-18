local QBCore = exports['qb-core']:GetCoreObject()

-- Remove item from player inventory
RegisterServerEvent('Pills:RemoveItem')
AddEventHandler('Pills:RemoveItem', function(itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        Player.Functions.RemoveItem(itemName, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')
    end
end)

-- Log pill usage
RegisterServerEvent('Pills:LogPillUsage')
AddEventHandler('Pills:LogPillUsage', function(pillType, pillLabel)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        local citizenId = Player.PlayerData.citizenid
        
        print('^2[PILLS SYSTEM]^7 ' .. name .. ' (' .. citizenId .. ') took ' .. pillLabel)
        
        -- You can add database logging here
        -- TriggerEvent('your-logs-event', 'pills', name, 'Used pill: ' .. pillLabel)
    end
end)

-- Add pill items to player (for testing)
RegisterCommand('givepill', function(source, args, rawCommand)
    if args[1] == nil then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {'Pills', 'Usage: /givepill [pill_type] [amount]'}
        })
        return
    end
    
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pillType = string.lower(args[1])
    local amount = tonumber(args[2]) or 1
    
    if Player then
        if Config.Pills[pillType] then
            Player.Functions.AddItem(Config.Pills[pillType].item, amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Pills[pillType].item], 'add')
        else
            TriggerClientEvent('chat:addMessage', src, {
                color = {255, 0, 0},
                multiline = true,
                args = {'Pills', 'Invalid pill type!'}
            })
        end
    end
end, false)

-- Check player has item
RegisterServerEvent('Pills:CheckItem')
AddEventHandler('Pills:CheckItem', function(itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        local hasItem = Player.Functions.GetItemByName(itemName)
        TriggerClientEvent('Pills:ItemCheckResult', src, hasItem ~= nil)
    end
end)

-- Player joined - initialize
AddEventHandler('playerJoining', function()
    print('Player joining...')
end)
