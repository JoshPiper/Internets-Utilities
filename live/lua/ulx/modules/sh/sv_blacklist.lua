blacklistTypes = {}
blacklistTypes["P"] = "Props"

reverseBlacklists = {}
sortedBlacklists = {}
for k, v in pairs(blacklistTypes) do
	reverseBlacklists[v] = k
	table.insert(sortedBlacklists, v)
end
-- Blacklist Data Structure
-- [key = "type" = char] = num

hook.Add("PlayerInitialSpawn", "LoadPlayerBlacklists", function(ply)
	if ply:GetPData("hasBlacklist", false) then
		ply.blacklists = util.JSONToTable(ply:GetPData("plyBlacklists", ""))
		for k, v in pairs(ply.blacklists) do
			if ((v.length >= CurTime()) and (not v.length == 0)) or (not blacklists[v.type]) then
				ply.blacklists[v.type] = nil
			end
		end
	end
end)

hook.Add("PlayerDisconnected", function(ply)
	if not (util.TableToJSON(ply.blacklists) == "") then
		ply:SetPData("hasBlacklist", true)
		ply:SetPData("plyBlacklists", util.TableToJSON(ply.blacklists))
	else
		ply:SetPData("hasBlacklist", false)
		ply:SetPData("plyBlacklists", nil)
	end
end)

local function processBlacklists(ply)
	for k, v in pairs(ply.blacklists) do
		if v.length >= CurTime() then
			ply.blacklists[k] = nil
		end
	end
end
timer.Create("ProcessBlacklists", 30, 0, function()
	for k, v in pairs(player.GetAll()) do
		processBlacklists(v)
	end
end)

hook.Add("PlayerSpawnProp", "Blacklists_Prop", function(ply, model)
	if ply.blacklists["P"] then
		return false
	end
end)