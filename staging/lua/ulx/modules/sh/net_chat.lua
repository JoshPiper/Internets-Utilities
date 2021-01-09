-- ULX Module: Chat Commands
-- Made For: RelentlessRP
-- Made By: Dr. Internet
-- Version: 1.0
-- Author Contact: Steam.
-- Description: ULX Module with various functions for use with chat.
-- Includes:
--		Coloured TSay Chat - Both to players and globally.
--		Coloured CSay Chat - Both to players and globally.
--		Notifications - Sandbox style.
if not ulx then
	print("Attempted to Load Internet's Utilities - Chat Module, but ULX was not present.")
	return
end

local category = "Chat"

colourids = {"White", "Black", "Red", "Green", "Blue", "Cyan", "Pink", "Yellow", "Light Grey", "Grey", "Orange", "Purple"}
colours = {}
colours["White"] = Color(255, 255, 255)
colours["Black"] = Color(0, 0, 0)
colours["Red"] = Color(255, 0, 0)
colours["Green"] = Color(0, 255, 0)
colours["Blue"] = Color(0, 0, 255)
colours["Cyan"] = Color(0, 255, 255)
colours["Pink"] = Color(255, 0, 255)
colours["Yellow"] = Color(255, 255, 0)
colours["Light Grey"] = Color(100, 100, 100)
colours["Grey"] = Color(35, 35, 35)
colours["Orange"] = Color(255, 128, 0)
colours["Purple"] = Color(50, 0, 110)

notificationtypes = {"Generic", "Error", "Undo", "Question", "Cleanup", "Progress"}

------ Coloured TSay Chat ------
-- Single Player
function ulx.tsayColour(calling_ply, target_plys, message, colour)
	if colour == "Colour" then colour = "Black" end
	colour = colours[colour]
	if not target_plys then
		target_plys = Game.GetPlayers()
	end
	for i = 1, #target_plys do
		ULib.tsayColor(target_plys[i], true, colour, message)
	end
	if util.tobool(GetConVarNumber("ulx_logChat")) then
		ulx.logString(string.format("(tsay - %s) %s", calling_ply:IsValid() and calling_ply:Nick() or "Console", message))		
	end
end
tsaycolour = ulx.command(category, "ulx tsaycolour", ulx.tsayColour, "!tsaycolour")
tsaycolour:defaultAccess(ULib.ACCESS_ADMIN)
tsaycolour:addParam{type=ULib.cmds.PlayersArg, hint="Players to send a message to. None selected = Global Message"}
tsaycolour:addParam{type=ULib.cmds.StringArg, hint="Message" }
tsaycolour:addParam{type=ULib.cmds.StringArg, hint="Colour", completes=colourids, ULib.cmds.restrictToCompletes}

------ Coloured CSay Chat ------
-- Single Player
function ulx.csayColour(calling_ply, target_plys, message, colour, holdtime)
	colour = colours[colour]
	for i = 1, #target_plys do
		ULib.csay(target_plys[i], message, colour, holdtime)
	end
	if util.tobool(GetConVarNumber("ulx_logChat")) then
		ulx.logString(string.format("(csay from %s) %s", calling_ply:IsValid() and calling_ply:Nick() or "Console", message))		
	end
end
csaycolour = ulx.command(category, "ulx csaycolour", ulx.csayColour, "!csaycolour")
csaycolour:defaultAccess(ULib.ACCESS_ADMIN)
csaycolour:addParam{type=ULib.cmds.PlayersArg}
csaycolour:addParam{type=ULib.cmds.StringArg, hint="Message" }
csaycolour:addParam{type=ULib.cmds.StringArg, hint="Colour", completes=colourids, ULib.cmds.restrictToCompletes}
csaycolour:addParam{type=ULib.cmds.NumArg, hint="Display Time (Seconds)", min=1, max=20}
-- Global
function ulx.csayColourGlobal(calling_ply, message, colour, holdtime)
	colour = colours[colour]
	ULib.csay(nil, message, colour, holdtime)
	if util.tobool(GetConVarNumber("ulx_logChat")) then
		ulx.logString(string.format("(csay from %s) %s", calling_ply:IsValid() and calling_ply:Nick() or "Console", message))		
	end
end
csaycolourglobal = ulx.command(category, "ulx csaycolourglobal", ulx.csayColourGlobal, "!csaycolourglobal")
csaycolourglobal:defaultAccess(ULib.ACCESS_ADMIN)
csaycolourglobal:addParam{type=ULib.cmds.StringArg, hint="Message"}
csaycolourglobal:addParam{type=ULib.cmds.StringArg, hint="Colour", completes=colourids, ULib.cmds.restrictToCompletes}
csaycolourglobal:addParam{type=ULib.cmds.NumArg, hint="Display Time (Seconds)", min=1, max=20}


------ Notifications -------
function ulx.notify(calling_ply, target_plys, text, notetype, duration)
	for i = 1, #notificationtypes do
		if notetype == notificationtypes[i] then
			typeid = i
		end
	end
	for i = 1, #target_plys do
		if typeid == 1 then
			target_plys[i]:SendLua("notification.AddLegacy(\"" .. text .. "\", NOTIFY_GENERIC, " .. duration .. ")")
			target_plys[i]:SendLua([[surface.PlaySound("buttons/button15.wav")]])
		elseif typeid == 2 then
			target_plys[i]:SendLua("notification.AddLegacy(\"" .. text .. "\", NOTIFY_ERROR, " .. duration .. ")")
			target_plys[i]:SendLua([[surface.PlaySound("buttons/button15.wav")]])
		elseif typeid == 3 then
			target_plys[i]:SendLua("notification.AddLegacy(\"" .. text .. "\", NOTIFY_UNDO, " .. duration .. ")")
			target_plys[i]:SendLua([[surface.PlaySound("buttons/button15.wav")]])
		elseif typeid == 4 then
			target_plys[i]:SendLua("notification.AddLegacy(\"" .. text .. "\", NOTIFY_HINT, " .. duration .. ")")
			target_plys[i]:SendLua([[surface.PlaySound("buttons/button15.wav")]])
		elseif typeid == 5 then
			target_plys[i]:SendLua("notification.AddLegacy(\"" .. text .. "\", NOTIFY_CLEANUP, " .. duration .. ")")
			target_plys[i]:SendLua([[surface.PlaySound("buttons/button15.wav")]])
		elseif typeid == 6 then
			local x = math.random()
			target_plys[i]:SendLua("notification.AddProgress(" .. x .. ",\"" .. text .. "\")")
			target_plys[i]:SendLua([[surface.PlaySound("buttons/button15.wav")]])
			timer.Simple( duration, function()
				target_plys[i]:SendLua("notification.Kill(" .. x .. ")")
			end)
		end
	end
end
local notify = ulx.command(category, "ulx notify", ulx.notify, "!notify")
notify:addParam{type=ULib.cmds.PlayersArg}
notify:addParam{type=ULib.cmds.StringArg, hint="Message"}
notify:addParam{type=ULib.cmds.StringArg, hint="Notification Type", completes=notificationtypes, ULib.cmds.restrictToCompletes}
notify:addParam{type=ULib.cmds.NumArg, default=3, min=1, max=120, hint="duration", ULib.cmds.optional}
notify:defaultAccess(ULib.ACCESS_ADMIN)
notify:help("Send a sandbox style notification to targeted players.")