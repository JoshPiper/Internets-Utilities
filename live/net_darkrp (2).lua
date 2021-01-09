ulx.darkrp = {}
function ulx.darkrp.findTeamByName(teamName)
	for id, team in pairs(RPExtraTeams) do
		if string.lower(team.name) == string.lower(teamName) then
			return id
		end
	end
	return false
end


function ulx.darkrp.setteam(calling_ply, target_plys, jobName)
	local effected = {}
	
	-- Find the Team we want.
	local teamToSet = ulx.darkrp.findTeamByName(jobName)
	if not teamToSet then
		ULib.tsayError(calling_ply, "Error - Team Not Found.")
		return false
	end
	
	-- Set the Target Player
	if not target_plys then
		target_plys = {calling_ply}
	end
	
	for _, ply in pairs(target_plys) do
		curTeam = ply:Team()
		newTeam = teamToSet
		if curTeam == newTeam then
			continue
		else
			local teamData = RPExtraTeams[newTeam]
			local teamDataOld = RPExtraTeams[curTeam]
			local wasMayor = teamDataOld.mayor
			
			if wasMayor then
				if GetGlobalBool("DarkRP_LockDown") then
					DarkRP.unLockdown(ply)
				end
				
				if GAMEMODE.Config.shouldResetLaws then
					DarkRP.resetLaws()
				end
				
				for _, ent in pairs(ply.lawboards or {}) do
					if IsValid(ent) then
						ent:Remove()
					end
				end
			end

			
			if ply:getDarkRPVar("HasGunlicense") and GAMEMODE.Config.revokeLicenseOnJobChange then
				ply:setDarkRPVar("HasGunlicense", nil)
			end
			if teamData.hasLicense then
				ply:setDarkRPVar("HasGunlicense", true)
			end
			
			ply:setDarkRPVar("job", teamData.name)
			ply:setDarkRPVar("salary", teamData.salary)
			ply:SetTeam(newTeam)
			
			if ply:InVehicle() then ply:ExitVehicle() end
			if GAMEMODE.Config.norespawn and ply:Alive() then
				ply:StripWeapons()
        
				player_manager.SetPlayerClass(ply, teamData.playerClass or "player_darkrp")
				ply:applyPlayerClassVars(false)
				gamemode.Call("PlayerSetModel", ply)
				gamemode.Call("PlayerLoadout", ply)
			else
				ply:KillSilent()
			end
			table.insert(effected, ply)
		end
	end
	ulx.fancyLogAdmin(calling_ply, "#A set team of #T to #s", effected, jobName)
end
local setteam = ulx.command("DarkRP", "ulx setteam", ulx.darkrp.setteam, "!setteam")
setteam:addParam{type=ULib.cmds.PlayersArg}
setteam:addParam{type=ULib.cmds.StringArg, hint="Team Name", ULib.cmds.takeRestOfLine}
setteam:defaultAccess(ULib.ACCESS_SUPERADMIN)
setteam:help("Sets a player's team.")


function ulx.darkrp.setjob(calling_ply, target_plys, jobTitle)
	for _, ply in pairs(target_plys) do
		if jobTitle == "" then
			jobSet = RPExtraTeams[ply:Team()].name
		else
			jobSet = jobTitle
		end
		ply:setDarkRPVar("job", jobSet)
	end
	if jobTitle == "" then
		ulx.fancyLogAdmin(calling_ply, "#A reset job title of #T", target_plys)
	else
		ulx.fancyLogAdmin(calling_ply, "#A set job title of #T to #s", target_plys, jobTitle)
	end
end
local setjob = ulx.command("DarkRP", "ulx setjob", ulx.darkrp.setjob, "!setjob")
setjob:addParam{type=ULib.cmds.PlayersArg}
setjob:addParam{type=ULib.cmds.StringArg, hint="Job Name", ULib.cmds.takeRestOfLine, ULib.cmds.optional}
setjob:defaultAccess(ULib.ACCESS_SUPERADMIN)
setjob:help("Sets a player's job title.")


function ulx.darkrp.demote(calling_ply, target_plys, reason)
	local effected = {}
	local resText = ((reason == "") and "no reason" or "reason")
	for _, ply in pairs(target_plys) do
		if not (ply:Team() == GAMEMODE.DefaultTeam) then
			ply:changeTeam(GAMEMODE.DefaultTeam, true, true)
			table.insert(effected, ply)
		else
			ULib.tsayError(calling_ply, "Unable to demote "..ply:Name())
		end
	end
	if reason == "" then
		ulx.fancyLogAdmin(calling_ply, "#A demoted #T", effected)
	else
		ulx.fancyLogAdmin(calling_ply, "#A demoted #T (#s)", effected, reason)
	end
end
local demote = ulx.command("DarkRP", "ulx demote", ulx.darkrp.demote, "!demote")
demote:addParam{type=ULib.cmds.PlayersArg, hint="Players to Demote"}
demote:addParam{type=ULib.cmds.StringArg, hint="Reason for Demotion", ULib.cmds.takeRestOfLine, ULib.cmds.optional}
demote:defaultAccess(ULib.ACCESS_ADMIN)
demote:help("Demote a player.")
