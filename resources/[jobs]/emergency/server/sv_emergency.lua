--[[
################################################################
- Creator: Jyben
- Date: 02/05/2017
- Url: https://github.com/Jyben/emergency
- Licence: Apache 2.0
################################################################
--]]

require "resources/mysql-async/lib/MySQL"

RegisterServerEvent('es_em:sendEmergency')
AddEventHandler('es_em:sendEmergency',
function(reason, playerIDInComa, x, y, z)
  TriggerEvent("es:getPlayers", function(players)
    for i,v in pairs(players) do
      TriggerClientEvent('es_em:sendEmergencyToDocs', i, reason, playerIDInComa, x, y, z, source)
    end
  end)
end
)

RegisterServerEvent('es_em:getTheCall')
AddEventHandler('es_em:getTheCall', function(playerName, playerID, x, y, z, sourcePlayerInComa)
  local fullname = playerName
  TriggerEvent('es:getPlayerFromId', source, function(user)
    fullname = user:getPrenom() .. " " .. user:getNom()
  end)
  TriggerEvent("es:getPlayers", function(players)
    for i,v in pairs(players) do
      TriggerClientEvent('es_em:callTaken', i, fullname, playerID, x, y, z, sourcePlayerInComa)
    end
  end)
end
)

RegisterServerEvent('es_em:sv_resurectPlayer')
AddEventHandler('es_em:sv_resurectPlayer',
function(sourcePlayerInComa)
  TriggerClientEvent('es_em:cl_resurectPlayer', sourcePlayerInComa)
end
)

RegisterServerEvent('es_em:sv_getJobId')
AddEventHandler('es_em:sv_getJobId', function()
TriggerEvent('es:getPlayerFromId', source, function(user)
  local jobid = user:getJob()
  TriggerClientEvent('es_em:cl_setJobId', source, jobid)
end)
end)

RegisterServerEvent('es_em:sv_getDocConnected')
AddEventHandler('es_em:sv_getDocConnected',
function()
  TriggerEvent("es:getPlayers", function(players)
    local identifier
    local table = {}
    local isConnected = false

    for i,v in pairs(players) do
      identifier = GetPlayerIdentifiers(i)
      if (identifier ~= nil) then
        local isConnected = MySQL.Sync.fetchScalar("SELECT COUNT(1) FROM users LEFT JOIN jobs ON jobs.job_id = users.job WHERE users.identifier = @identifier AND job_id = 13", {['@identifier'] = identifier[1]})
		if isConnected ~= 0 then
			TriggerClientEvent('es_em:cl_getDocConnected', source, true)
		end
      end
    end
  end)
end
)

RegisterServerEvent('es_em:sv_setService')
AddEventHandler('es_em:sv_setService',
function(service)
  TriggerEvent('es:getPlayerFromId', source,
  function(user)
    user:setenService(2)
  end
)
end
)

RegisterServerEvent('es_em:sv_removeMoney')
AddEventHandler('es_em:sv_removeMoney',
function()
  TriggerEvent("es:getPlayerFromId", source,
  function(user)
    if(user)then
      if user.money > 0 then
        user:setMoney(0)
      end
      if user.dirtymoney > 0 then
        user:setDMoney(0)
      end
    end
  end
)
end
)

RegisterServerEvent('es_em:sv_sendMessageToPlayerInComa')
AddEventHandler('es_em:sv_sendMessageToPlayerInComa',
function(sourcePlayerInComa)
  TriggerClientEvent('es_em:cl_sendMessageToPlayerInComa', sourcePlayerInComa)
end
)

AddEventHandler('playerDropped', function()

end)

TriggerEvent('es:addCommand', 'respawn', function(source, args, user)
  TriggerClientEvent('es_em:cl_respawn', source)
end)
