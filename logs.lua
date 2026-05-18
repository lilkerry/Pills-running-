-- Logging system for pills usage

local function logToDatabase(citizenId, pillType, timestamp)
    -- Implement your database logging here
    -- Example with ox_mysql or similar:
    -- MySQL.insert('INSERT INTO pills_log (citizen_id, pill_type, used_at) VALUES (?, ?, ?)', {citizenId, pillType, timestamp})
end

local function logToFile(playerName, citizenId, pillType)
    local logFile = 'resources/Pills/logs/pills_usage.log'
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    local logEntry = string.format('[%s] %s (%s) - Used: %s\n', timestamp, playerName, citizenId, pillType)
    
    -- File logging can be implemented here if needed
end

-- Main logging function
function LogPillUsage(playerName, citizenId, pillType)
    logToFile(playerName, citizenId, pillType)
    logToDatabase(citizenId, pillType, os.time())
end
