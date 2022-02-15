local ADDON_NAME = ...

-- local caching
local event = event
local FlashWindow = FlashWindow

-- main code

local frame = CreateFrame("frame")

function frame:OnInitialize()
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("CHAT_MSG_WHISPER")
    self:RegisterEvent("LFG_PROPOSAL_SHOW")
    self:RegisterEvent("READY_CHECK")
    
    hooksecurefunc("StaticPopup_Show", function(name)
        if name == "CONFIRM_BATTLEFIELD_ENTRY" or name == "PARTY_INVITE" then
            FlashWindow()
        end
    end)
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not FlashWindow then
            DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME..": Wow.exe patch not applied!")
        else
            self:OnInitialize()
        end
    elseif event == "PLAYER_REGEN_DISABLED" or event == "CHAT_MSG_WHISPER" or event == "LFG_PROPOSAL_SHOW" or event == "READY_CHECK" then
        FlashWindow()
    end
end)

frame:RegisterEvent("PLAYER_LOGIN")
