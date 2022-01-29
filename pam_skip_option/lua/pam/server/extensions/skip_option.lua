local name = "skip_option"
PAM_EXTENSION.name = name
PAM_EXTENSION.enabled = true

local setting_namespace = PAM.setting_namespace:AddChild(name)
local reset_percentage = setting_namespace:AddSetting("round_reset_percentage", pacoman.TYPE_PERCENTAGE, 1)
local round_limit

function PAM_EXTENSION:Initialize()
	round_limit = PAM.setting_namespace:GetChild("custom_round_counter"):GetSetting("round_limit")
end

function PAM_EXTENSION:RegisterSpecialOptions()
	if PAM.vote_type ~= "map" then return end

	PAM.RegisterOption("keep_playing", function()
		PAM.Cancel()
		local new_round_count = round_limit:GetActiveValue() * (1 - reset_percentage:GetActiveValue())
		PAM.extension_handler.RunEvent("SetRoundCounter", new_round_count)
	end)
end
