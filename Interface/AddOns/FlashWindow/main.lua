local ADDON_NAME = ...

-- local caching
local event = event
local FlashWindow = FlashWindow

-- utils
eventName2CallbackName = setmetatable({}, {
    __index = function(self, eventName)
        assert(eventName and type(eventName) == "string", "Invalid argument")
        if callbackName then return callbackName end
        local callbackName = "On"..eventName:lower():gsub("^%a", string.upper):gsub("(_%a)", function(v) return v:sub(2, 2):upper() end)
        self[eventName] = callbackName
        return callbackName
    end,
})

-- main code
local frame = CreateFrame("frame")

do
    local PREFIX = ADDON_NAME..": "
    function frame:printf(format, ...)
        DEFAULT_CHAT_FRAME:AddMessage(PREFIX..tostring(format):format(...))
    end
end

hooksecurefunc("StaticPopup_Show", function(name)
    if name == "CONFIRM_BATTLEFIELD_ENTRY" or name == "FlashWindow" then
        FlashWindow()
    end
end)

function frame:OnPlayerRegenDisable()
    FlashWindow()
end

function frame:OnChatMsgWhisper()
    FlashWindow()
end

function frame:OnInitialize()
    self:RegisterEvent("PLAYER_REGEN_DISABLE")
    self:RegisterEvent("CHAT_MSG_WHISPER")
end

function frame:OnPlayerLogon()
    if not FlashWindow then
        self:printf("Wow.exe patch not applied!")
    else
        self:OnInitialize()
    end
end

function frame:OnEvent(event, ...)
    self[event](self, eventName2CallbackName[event], ...)
end

frame:RegisterEvent("PLAYER_LOGON")
frame:SetScript("OnEvent", frame.OnEvent)