-- ULX Module: Menus
-- Made For: RelentlessRP
-- Made By: Dr. Internet
-- Version: 1.0
-- Author Contact: Steam.
-- Description: ULX Module with stuff for menus.
-- Includes:
--		Convar Creation, allowing for the changing of variables.
--		Forums, MOTD and Player Reports Opening.

local catagory = "Menus"

if SERVER then
	CreateConVar("url_forums", "http://www.google.com")
	CreateConVar("url_motd", "http://www.google.com")
	CreateConVar("url_reports", "http://www.google.com")
end

function ulx.openForums(calling_ply)
	calling_ply:SendLua([[gui.OpenURL( "]] .. GetConVarString("url_forums") .. [[" )]])
end
forums = ulx.command(catagory, "ulx forums", ulx.openForums, "!forums")
forums:defaultAccess(ULib.ACCESS_ALL)
forums:help("Opens the Forums in the Steam Browser")

function ulx.openMotd(calling_ply)
	calling_ply:SendLua([[gui.OpenURL( "]] .. GetConVarString("url_motd") .. [[" )]])
end
motdsteam = ulx.command(catagory, "ulx motdsteam", ulx.openMotd, "!motdsteam")
motdsteam:defaultAccess(ULib.ACCESS_ALL)
motdsteam:help("Opens the MOTD in the Steam Browser")

function ulx.openReports(calling_ply)
	calling_ply:SendLua([[gui.OpenURL( "]] .. GetConVarString("url_reports") .. [[" )]])
end
forums = ulx.command(catagory, "ulx report", ulx.openReports, "!report")
forums:defaultAccess(ULib.ACCESS_ALL)
forums:help("Opens the Player Reports section of the forums.")