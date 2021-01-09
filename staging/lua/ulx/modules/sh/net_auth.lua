local meta = FindMetaTable("Player")

if SERVER then
	ULib.ucl.registerAccess("isSuperAdmin", ULib.ACCESS_SUPERADMIN, "Grants Rank Super-Administrator Status.", "Group Authentication")
	ULib.ucl.registerAccess("isAdmin", ULib.ACCESS_ADMIN, "Grants Rank Administrator Status.", "Group Authentication")
	ULib.ucl.registerAccess("isMod", ULib.ACCESS_NONE, "Grants Rank Moderator Status.", "Group Authentication")
	ULib.ucl.registerAccess("isDev", ULib.ACCESS_NONE, "Grants Rank Developer Status.", "Group Authentication")
end

local oldSuper = meta.IsSuperAdmin
function meta:IsSuperAdmin()
	if ULib.ucl.authed[self:UniqueID()] then
		return self:query("isSuperAdmin")
	else
		return oldSuper(self)
	end
end

function meta:IsSuperDev()
	if ULib.ucl.authed[self:UniqueID()] then
		return (self:query("isSuperAdmin") and self:query("isDev"))
	else
		return false
	end
end

local oldAdmin = meta.IsAdmin
function meta:IsAdmin()
	if ULib.ucl.authed[self:UniqueID()] then
		return self:query("isAdmin")
	else
		return oldAdmin(self)
	end
end

function meta:IsDeveloper()
	if ULib.ucl.authed[self:UniqueID()] then
		return self:query("isDev")
	else
		return false
	end
end

function meta:IsModerator()
	if ULib.ucl.authed[self:UniqueID()] then
		return self:query("isMod")
	else
		return false
	end
end

function meta:IsMod()
	return self:IsModerator()
end

function meta:IsDev()
	return self:IsDeveloper()
end