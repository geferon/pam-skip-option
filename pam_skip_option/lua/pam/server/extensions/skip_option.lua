local name = "skip_option"
PAM_EXTENSION.name = name
PAM_EXTENSION.enabled = true

local setting_namespace = PAM.setting_namespace:AddChild(name)
local reset_percentage = setting_namespace:AddSetting("round_reset_percentage", pacoman.TYPE_PERCENTAGE, 1, "Determines which percentage of the round limit will need to be replayed before a vote starts again.")
local round_limit

function PAM_EXTENSION:CanEnable()
	round_limit = PAM.setting_namespace:GetChild("custom_round_counter"):GetSetting("round_limit")
end

function PAM_EXTENSION:RegisterSpecialOptions()
	if PAM.vote_type ~= "map" then return end

	local extensionSupported = PAM.extension_handler.RunReturningEvent("HasRoundLimitExtensionSupport")
	if !extensionSupported then return end

	PAM.RegisterOption("keep_playing", function()
		PAM.Cancel()
		local percentage = reset_percentage:GetActiveValue()
		local new_round_count = round_limit:GetActiveValue() * (1 - percentage)
		PAM.extension_handler.RunEvent("SetRoundCounter", new_round_count)
		PAM.extension_handler.RunEvent("RoundLimitExtended", new_round_count, percentage)
	end)
end
