-- ------------------------------------------------------------ --
-- Addon: ClassicUI                                             --
--                                                              --
-- Version: 2.0.0                                               --
-- Author: Millán - Sanguino                                    --
--                                                              --
-- License: GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007 --
-- ------------------------------------------------------------ --

ClassicUI = LibStub("AceAddon-3.0"):NewAddon("ClassicUI", "AceConsole-3.0")

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

ClassicUI.frame = ClassicUI.frame or CreateFrame("Frame", "ClassicUIFrame")

function ClassicUI:OnEvent(event, ...) -- functions created in "object:method"-style have an implicit first parameter of "self", which points to object
	ClassicUI[event](ClassicUI, ...) -- route event parameters to ClassicUI:event methods
end
ClassicUI.frame:SetScript("OnEvent", ClassicUI.OnEvent)

local L = LibStub("AceLocale-3.0"):GetLocale("ClassicUI")

local _G = _G
local _
local STANDARD_EPSILON = 0.001
local SCALE_EPSILON = 0.001
local tblinsert = table.insert
local tblsort = table.sort
local tblwipe = table.wipe
local mathabs = math.abs
local mathmin = math.min
local mathmax = math.max
local strformat = string.format
local type = type
local pairs = pairs
local ipairs = ipairs
local next = next
local SetPortraitTexture = SetPortraitTexture
local SetClampedTextureRotation = SetClampedTextureRotation
local InCombatLockdown = InCombatLockdown
local ActionBarController_GetCurrentActionBarState = ActionBarController_GetCurrentActionBarState
local BNConnected = BNConnected
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_GossipInfo_GetFriendshipReputation = C_GossipInfo.GetFriendshipReputation
local C_Club_IsEnabled = C_Club.IsEnabled
local C_Club_IsRestricted = C_Club.IsRestricted
local C_Container_GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
local ContainerFrame_IsReagentBag = ContainerFrame_IsReagentBag
local GetRestrictedAccountData = GetRestrictedAccountData
local GetWatchedFactionInfo = GetWatchedFactionInfo
local GameLimitedMode_IsActive = GameLimitedMode_IsActive
local Kiosk_IsEnabled = Kiosk.IsEnabled
local UIFrameFlashStop = UIFrameFlashStop
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax
local UnitFactionGroup = UnitFactionGroup
local GetXPExhaustion = GetXPExhaustion
local GetRestState = GetRestState
local GetFlyoutInfo = GetFlyoutInfo
local GetFlyoutSlotInfo = GetFlyoutSlotInfo
local GetCallPetSpellInfo = GetCallPetSpellInfo
local GetFileStreamingStatus = GetFileStreamingStatus
local GetBackgroundLoadingStatus = GetBackgroundLoadingStatus
local IsEquippedAction = IsEquippedAction
local IsCommunitiesUIDisabledByTrialAccount = IsCommunitiesUIDisabledByTrialAccount
local GetDifficultyInfo = GetDifficultyInfo
local GetInstanceInfo = GetInstanceInfo
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetGuildInfo = GetGuildInfo
local InGuildParty = InGuildParty

-- Global constants
ClassicUI.VERSION = "2.0.0"
ClassicUI.ACTIONBUTTON_NEWLAYOUT_SCALE = 0.826
ClassicUI.ACTION_BAR_OFFSET = 45
ClassicUI.SPELLFLYOUT_DEFAULT_SPACING = 4
ClassicUI.SPELLFLYOUT_INITIAL_SPACING = 7
ClassicUI.SPELLFLYOUT_FINAL_SPACING = 4

-- Global variables
ClassicUI.databaseCleaned = false

-- Cache variables
ClassicUI.cached_NumberVisibleBars = 0
ClassicUI.cached_NumberRealVisibleBars = 0
ClassicUI.cached_DoubleStatusBar_hide = nil
ClassicUI.cached_SingleStatusBar_hide = nil
ClassicUI.cached_ActionButtonInfo = {
	hooked_UpdateButtonArt = { },
	hooked_UpdateHotkeys = { },
	hooked_UpdateFlyout = { },
	currentScale = { },
	currLayout = { }
}
ClassicUI.cached_db_profile = { }
ClassicUI.queuePending_ActionButtonsLayout = { }
ClassicUI.queuePending_HookSetScale = { }

-- Default settings
ClassicUI.defaults = {
	profile = {
		enabled = true,
		barsConfig = {
			['**'] = {
				xOffset = 0,
				yOffset = 0
			},
			['LeftGargoyleFrame'] = {
				hide = false,
				alpha = 1,
				scale = 1,
				model = 0	-- 0 = Gryphon, 1 = Lion, 2 = New Gryphon, 3 = New Wyvern
			},
			['RightGargoyleFrame'] = {
				hide = false,
				alpha = 1,
				scale = 1,
				model = 0	-- 0 = Gryphon, 1 = Lion, 2 = New Gryphon, 3 = New Wyvern
			},
			['MainMenuBar'] = {
				scale = 1,
				hideLatencyBar = false,
				BLStyle = 0,	-- 0 = Classic, 1 = Dragonflight
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false,
			},
			['SpellFlyoutButtons'] = {
				BLStyle = 0,	-- 0 = Classic, 1 = Dragonflight
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false
			},
			['MicroButtons'] = {
				scale = 1,
				useClassicQuestIcon = false,
				useClassicGuildIcon = false,
				useBiggerGuildEmblem = false,
				useClassicMainMenuIcon = false
			},
			['BagsIcons'] = {
				iconBorderAlpha = 1,
				xOffsetReagentBag = 0,
				yOffsetReagentBag = 0
			},
			['OverrideActionBar'] = {
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Dragonflight
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false
			},
			['PetBattleFrameBar'] = {
				scale = 1
			},
			['BottomMultiActionBars'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Dragonflight
				BLStyle0NormalTextureAlpha = 0.5,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false
			},
			['RightMultiActionBars'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Dragonflight
				BLStyle0NormalTextureAlpha = 0.5,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false
			},
			['PetActionBarFrame'] = {
				normalizeButtonsSpacing = false,
				hideOnOverrideActionBar = false,
				hideOnPetBattleFrameBar = true,
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				xOffsetIfStanceBar = 0,
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Dragonflight
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false
			},
			['StanceBarFrame'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Dragonflight
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false
			},
			['PossessBarFrame'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Dragonflight
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false
			},
			['SingleStatusBar'] = {
				hide = {
					[0] = false,	-- ExpBar
					[1] = false,	-- HonorBar
					[2] = false,	-- AzeriteBar
					[3] = false,	-- ArtifactBar
					[4] = false		-- ReputationBar
				},
				alpha = 0.5,
				xSize = 0,
				ySize = 0,
				artHide = false,
				artAlpha = 1.0,
				xOffsetArt = 0,
				yOffsetArt = 0,
				xSizeArt = 0,
				ySizeArt = 0,
				overlayHide = false,
				overlayAlpha = 1.0,
				xOffsetOverlay = 0,
				yOffsetOverlay = 0,
				expBarAlwaysShowRestedBar = true
			},
			['DoubleUpperStatusBar'] = {
				hide = {
					[0] = false,	-- ExpBar+HonorBar
					[1] = false,	-- ExpBar+AzeriteBar
					[2] = false,	-- ExpBar+ArtifactBar
					[3] = false,	-- ExpBar+ReputationBar
					[4] = false,	-- HonorBar+AzeriteBar
					[5] = false,	-- HonorBar+ArtifactBar
					[6] = false,	-- HonorBar+ReputationBar
					[7] = false,	-- AzeriteBar+ArtifactBar
					[8] = false,	-- AzeriteBar+ReputationBar
					[9] = false		-- ArtifactBar+ReputationBar
				},
				alpha = 0.5,
				xSize = 0,
				ySize = 0,
				artHide = false,
				artAlpha = 1.0,
				xOffsetArt = 0,
				yOffsetArt = 0,
				xSizeArt = 0,
				ySizeArt = 0,
				overlayHide = false,
				overlayAlpha = 1.0,
				xOffsetOverlay = 0,
				yOffsetOverlay = 0,
				expBarAlwaysShowRestedBar = true
			},
			['DoubleLowerStatusBar'] = {
				alpha = 0.5,
				xSize = 0,
				ySize = 0,
				artHide = false,
				artAlpha = 1.0,
				xOffsetArt = 0,
				yOffsetArt = 0,
				xSizeArt = 0,
				ySizeArt = 0,
				overlayHide = false,
				overlayAlpha = 1.0,
				xOffsetOverlay = 0,
				yOffsetOverlay = 0,
				expBarAlwaysShowRestedBar = true
			}
		},
		extraFrames = {
			['Minimap'] = {
				enabled = true,
				xOffset = 0,
				yOffset = 0,
				scale = 1,
				anchorQueueButtonToMinimap = true,
				xOffsetQueueButton = 0,
				yOffsetQueueButton = 0,
				bigQueueButton = false
			},
			['Bags'] = {
				freeSlotCounterMod = 1,		-- 0 = AllItems (default), 1 = AllItems-ReagentItems (addon default), 2 = NormalItems and ReagentItems in two different numbers
				xOffsetFreeSlotsCounter = 0,
				yOffsetFreeSlotsCounter = 0
			},
			['BuffAndDebuffFrames'] = {
				hideCollapseAndExpandButton = true
			}
		},
		extraConfigs = {
			['forceExtraOptions'] = false,
			['GuildPanelMode'] = {
				defaultOpenOldMenu = false,
				leftClickMicroButtonOpenOldMenu = false,
				rightClickMicroButtonOpenOldMenu = false,
				middleClickMicroButtonOpenOldMenu = false
			},
			['KeybindsConfig'] = {
				hideKeybindsMode = 0,		-- 0 = Show keybinds, 1 = Hide keybinds, 2 = Show range dots on keybinds, 3 = Show permanent range dots on keybinds
				hideActionButtonName = false
			},
			['RedRangeConfig'] = {
				enabled = false
			},
			['GreyOnCooldownConfig'] = {
				enabled = false,
				minDuration = 1.51
			},
			['LossOfControlUIConfig'] = {
				enabled = false
			}
		}
	}
}

-- Create the frame and the flag variables needed to execute protected functions after leave combat.
-- If a protected function tries to running while the player is in combat, a flag for the funcion is
-- activated and when the player leaves the combat the function is executed.
local fclFrame = CreateFrame("Frame")
local delayFunc_MainFunction = false
local delayFunc_SetStrataForMainFrames = false
local delayFunc_ReloadMainFramesSettings = false
local delayFunc_UpdatedStatusBarsEvent = false
local delayFunc_CUI_PetActionBarFrame_RelocateBar_Update = false
local delayFunc_ActionButtonProtectedApplyLayout = false
local delayFunc_BarHookProtectedApplySetScale = false
fclFrame:SetScript("OnEvent",function(self,event)
	if event=="PLAYER_REGEN_ENABLED" then
		fclFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		if (delayFunc_MainFunction) then
			delayFunc_MainFunction = false
			ClassicUI:MainFunction()
		end
		if (delayFunc_SetStrataForMainFrames) then
			delayFunc_SetStrataForMainFrames = false
			ClassicUI:SetStrataForMainFrames()
		end
		if (delayFunc_ReloadMainFramesSettings) then
			delayFunc_ReloadMainFramesSettings = false
			ClassicUI:ReloadMainFramesSettings()
		end
		if (delayFunc_UpdatedStatusBarsEvent) then
			delayFunc_UpdatedStatusBarsEvent = false
			ClassicUI.UpdatedStatusBarsEvent()
		end
		if (delayFunc_CUI_PetActionBarFrame_RelocateBar_Update) then
			delayFunc_CUI_PetActionBarFrame_RelocateBar_Update = false
			CUI_PetActionBarFrame:RelocateBar()
		end
		if (delayFunc_ActionButtonProtectedApplyLayout) then
			delayFunc_ActionButtonProtectedApplyLayout = false
			ClassicUI:ActionButtonProtectedApplyLayout()
		end
		if (delayFunc_BarHookProtectedApplySetScale) then
			delayFunc_BarHookProtectedApplySetScale = true
			ClassicUI:BarHookProtectedApplySetScale()
		end
	end
end)

-- First function fired
function ClassicUI:OnInitialize()
	self.db = AceDB:New("ClassicUI_DB", self.defaults, true)
	self:UpdateDBValuesCache()
	
	self.optionsTable.args.profiles = AceDBOptions:GetOptionsTable(self.db)
	
	AceConfig:RegisterOptionsTable("ClassicUI", self.optionsTable)
	
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	self.db.RegisterCallback(self, "OnDatabaseShutdown", function()
		ClassicUI.databaseCleaned = true
	end)
	
	self.optionsFramesCatId = { }
	self.optionsFrames = {}
	self.optionsFrames.general, self.optionsFramesCatId.general = AceConfigDialog:AddToBlizOptions("ClassicUI", nil, nil, "general")
	self.optionsFrames.extraFrames, self.optionsFramesCatId.extraFrames = AceConfigDialog:AddToBlizOptions("ClassicUI", L["Extra Frames"], "ClassicUI", "extraFrames")
	self.optionsFrames.extraOptions, self.optionsFramesCatId.extraOptions = AceConfigDialog:AddToBlizOptions("ClassicUI", L["Extra Options"], "ClassicUI", "extraOptions")
	self.optionsFrames.profiles, self.optionsFramesCatId.profiles = AceConfigDialog:AddToBlizOptions("ClassicUI", L["Profiles"], "ClassicUI", "profiles")
	
	self:RegisterChatCommand("ClassicUI", "SlashCommand")
	
	-- Start ClassicUI Core
	if (self.db.profile.enabled) then
		self:Enable()
		self:MainFunction(true)
		self:ExtraFramesFunc(true)
		self:ExtraOptionsFunc()
	else
		self:Disable()
		self:ExtraFramesFunc(true)
		if (self.db.profile.forceExtraOptions) then
			self:ExtraOptionsFunc()
		end
	end
end

-- Executed after modifying, resetting or changing profiles from the profile configuration menu
function ClassicUI:RefreshConfig()
	if (self:IsEnabled()) then
		if (not self.db.profile.enabled) then
			self:Disable()
			ReloadUI()
		else
			ReloadUI()	-- Better option than a ReloadUI would be to correctly set the frame parameters of the new configuration
		end
	else
		if (self.db.profile.enabled) then
			self:Enable()
			self:MainFunction()
			self:ExtraFramesFunc()
			self:ExtraOptionsFunc()
		else
			ReloadUI()	-- We do this ReloadUI because the old value of self.db.profile.forceExtraOptions could be true
		end
	end
	self:ToggleVisibilityKeybinds(self.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode)
	self:ToggleVisibilityActionButtonNames(self.db.profile.extraConfigs.KeybindsConfig.hideActionButtonName)
	-- We should do a ReloadUI if the old self.db.profile.extraConfigs..KeybindsConfig.hideKeybindsMode >= 2, but we have not the old value, so we don't do anything, who cares :)
	if ((not self.db.profile.extraConfigs.RedRangeConfig.enabled) and (REDRANGEICONS_HOOKED)) then
		ReloadUI()
	end
	if ((not self.db.profile.extraConfigs.GreyOnCooldownConfig.enabled) and (GREYONCOOLDOWN_HOOKED)) then
		ReloadUI()
	end
	if ((not self.db.profile.extraConfigs.LossOfControlUIConfig.enabled) and (DISABLELOSSOFCONTROLUI_HOOKED)) then
		ReloadUI()
	end
end

-- Function to control the slash commands
function ClassicUI:SlashCommand(str)
	local cmd, arg1 = ClassicUI:GetArgs(str, 2, 1)
	cmd = strlower(cmd or "")
	arg1 = strlower(arg1 or "")
	if (cmd == "enable") or (cmd == "on") then
		if (not ClassicUI:IsEnabled()) then
			ClassicUI.db.profile.enabled = true
			ClassicUI:Enable()
			ClassicUI:MainFunction()
			ClassicUI:ExtraOptionsFunc()
		end
	elseif (cmd == "disable") or (cmd == "off") then
		if (ClassicUI:IsEnabled()) then
			ClassicUI.db.profile.enabled = false
			ClassicUI:Disable()
			ReloadUI()
		end
	elseif (cmd == "extraframes") or (cmd == "ef") then
		ClassicUI:ShowConfig(1)
	elseif (cmd == "extraoptions") or (cmd == "eo") then
		ClassicUI:ShowConfig(2)
	elseif (cmd == "forceextraoptions") or (cmd == "fextraoptions") or (cmd == "feo") then
		if (arg1 == "enable") or (arg1 == "on") then
			if (not ClassicUI.db.profile.forceExtraOptions) then
				ClassicUI.db.profile.forceExtraOptions = true
				if (not ClassicUI:IsEnabled()) then
					ClassicUI:ExtraOptionsFunc()
				end
			end
		elseif (arg1 == "disable") or (arg1 == "off") then
			if (ClassicUI.db.profile.forceExtraOptions) then
				ClassicUI.db.profile.forceExtraOptions = false
				if (not ClassicUI:IsEnabled()) then
					ReloadUI()
				end
			end
		else
			ClassicUI:ShowConfig(2)
		end
	elseif (cmd == "profiles") then
		ClassicUI:ShowConfig(3)
	elseif (cmd == "reset") then
		ClassicUI.db:ResetProfile()
	elseif (cmd == "help") then
		ClassicUI:ShowHelp()
	else
		ClassicUI:ShowConfig()
	end
end

-- Print the help
function ClassicUI:ShowHelp()
	ClassicUI:Print('|cffd78900' .. L['ClassicUI'] .. ' v' .. ClassicUI.VERSION .. '|r')
	ClassicUI:Print("|cffd2a679" .. L['CLASSICUI_HELP_LINE1'] .. "|r")
	ClassicUI:Print("|cffd2a679" .. L['CLASSICUI_HELP_LINE2'] .. "|r")
	ClassicUI:Print("|cffd2a679" .. L['CLASSICUI_HELP_LINE3'] .. "|r")
	ClassicUI:Print("|cffd2a679" .. L['CLASSICUI_HELP_LINE4'] .. "|r")
	ClassicUI:Print("|cffd2a679" .. L['CLASSICUI_HELP_LINE5'] .. "|r")
	ClassicUI:Print("|cffd2a679" .. L['CLASSICUI_HELP_LINE6'] .. "|r")
	ClassicUI:Print("|cffd2a679" .. L['CLASSICUI_HELP_LINE7'] .. "|r")
	ClassicUI:Print("|cffd2a679" .. L['CLASSICUI_HELP_LINE8'] .. "|r")
	ClassicUI:Print("|cffd2a679" .. L['CLASSICUI_HELP_LINE9'] .. "|r")
end

-- Function loaded when ClassicUI is Enabled
function ClassicUI:OnEnable()
	DEFAULT_CHAT_FRAME:AddMessage('|cffd78900' .. L['ClassicUI'] .. ' v' .. ClassicUI.VERSION .. '|r ' .. L['enabled'])
end

-- Function loaded when ClassicUI is Disabled
function ClassicUI:OnDisable()
	DEFAULT_CHAT_FRAME:AddMessage('|cffd78900' .. L['ClassicUI'] .. ' v' .. ClassicUI.VERSION .. '|r ' .. L['disabled'])
end

-- Show Options Menu
function ClassicUI:ShowConfig(category)
	if (category ~= nil) then
		if (category == 0) then
			Settings.OpenToCategory(self.optionsFramesCatId.general)
		elseif (category == 1) then
			Settings.OpenToCategory(self.optionsFramesCatId.extraFrames)
		elseif (category == 2) then
			Settings.OpenToCategory(self.optionsFramesCatId.extraOptions)
		elseif (category == 3) then
			Settings.OpenToCategory(self.optionsFramesCatId.profiles)
		else
			Settings.OpenToCategory(self.optionsFramesCatId.general)
		end
	else
		Settings.OpenToCategory(self.optionsFramesCatId.general)
	end
end

-- Function to get the identifier of SingleStatusBars for our 'n' config number
function ClassicUI:GetSingleBarToHide(n)
	if (n == 0) then		-- ExpBar (priority = 3)
		return 3
	elseif (n == 1) then	-- HonorBar (priority = 2)
		return 2
	elseif (n == 2) then	-- AzeriteBar (priority = 0)
		return 0
	elseif (n == 3) then	-- ArtifactBar (priority = 4)
		return 4
	elseif (n == 4) then	-- ReputationBar (priority = 1)
		return 1
	else
		return nil
	end
end

-- Function to get the identifiers of DoubleStatusBars for our 'n' config number
function ClassicUI:GetDoubleBarsToHide(n)
	if (n == 0) then		-- ExpBar+HonorBar (priority = 3, 2)
		return 2, 3
	elseif (n == 1) then	-- ExpBar+AzeriteBar (priority = 3, 0)
		return 0, 3
	elseif (n == 2) then	-- ExpBar+ArtifactBar (priority = 3, 4)
		return 3, 4
	elseif (n == 3) then	-- ExpBar+ReputationBar (priority = 3, 1)
		return 1, 3
	elseif (n == 4) then	-- HonorBar+AzeriteBar (priority = 2, 0)
		return 0, 2
	elseif (n == 5) then	-- HonorBar+ArtifactBar (priority = 2, 4)
		return 2, 4
	elseif (n == 6) then	-- HonorBar+ReputationBar (priority = 2, 1)
		return 1, 2
	elseif (n == 7) then	-- AzeriteBar+ArtifactBar (priority = 0, 4)
		return 0, 4
	elseif (n == 8) then	-- AzeriteBar+ReputationBar (priority = 0, 1)
		return 0, 1
	elseif (n == 9) then	-- ArtifactBar+ReputationBar (priority = 4, 1)
		return 1, 4
	else
		return nil, nil
	end
end

-- Function to update the status bar addon options cached variables
function ClassicUI:UpdateStatusBarOptionsCache()
	ClassicUI.cached_DoubleStatusBar_hide = nil
	ClassicUI.cached_SingleStatusBar_hide = nil
	for k, v in pairs(ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.hide) do
		if (v) then
			if (ClassicUI.cached_DoubleStatusBar_hide == nil) then
				ClassicUI.cached_DoubleStatusBar_hide = {}
			end
			tblinsert(ClassicUI.cached_DoubleStatusBar_hide, k)
		end
	end
	for k, v in pairs(ClassicUI.db.profile.barsConfig.SingleStatusBar.hide) do
		if (v) then
			if (ClassicUI.cached_SingleStatusBar_hide == nil) then
				ClassicUI.cached_SingleStatusBar_hide = {}
			end
			tblinsert(ClassicUI.cached_SingleStatusBar_hide, k)
		end
	end
end

-- Function to update some DB cached values
function ClassicUI:UpdateDBValuesCache()
	if self.databaseCleaned then return end	-- [DB Integrity Check]	Cache
	self.cached_db_profile.extraFrames_Bags_freeSlotCounterMod = self.db.profile.extraFrames.Bags.freeSlotCounterMod
	self.cached_db_profile.barsConfig_SingleStatusBar_expBarAlwaysShowRestedBar = self.db.profile.barsConfig.SingleStatusBar.expBarAlwaysShowRestedBar
	self.cached_db_profile.barsConfig_MainMenuBar_scale = self.db.profile.barsConfig.MainMenuBar.scale
	self.cached_db_profile.barsConfig_BottomMultiActionBars_scale = self.db.profile.barsConfig.BottomMultiActionBars.scale
	self.cached_db_profile.barsConfig_RightMultiActionBars_scale = self.db.profile.barsConfig.RightMultiActionBars.scale
	self.cached_db_profile.barsConfig_PetActionBarFrame_scale = self.db.profile.barsConfig.PetActionBarFrame.scale
	self.cached_db_profile.barsConfig_PossessBarFrame_scale = self.db.profile.barsConfig.PossessBarFrame.scale
	self.cached_db_profile.barsConfig_StanceBarFrame_scale = self.db.profile.barsConfig.StanceBarFrame.scale
	self.cached_db_profile.barsConfig_MicroButtons_useClassicMainMenuIcon = self.db.profile.barsConfig.MicroButtons.useClassicMainMenuIcon
	self.cached_db_profile.barsConfig_BagsIcons_xOffsetReagentBag = self.db.profile.barsConfig.BagsIcons.xOffsetReagentBag
	self.cached_db_profile.barsConfig_BagsIcons_yOffsetReagentBag = self.db.profile.barsConfig.BagsIcons.yOffsetReagentBag
	self.cached_db_profile.extraConfigs_KeybindsConfig_hideKeybindsMode = self.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode
	self.cached_db_profile.extraConfigs_GreyOnCooldownConfig_minDuration = self.db.profile.extraConfigs.GreyOnCooldownConfig.minDuration
	self.cached_db_profile.extraConfigs_GuildPanelMode_defaultOpenOldMenu = self.db.profile.extraConfigs.GuildPanelMode.defaultOpenOldMenu
	self.cached_db_profile.extraConfigs_GuildPanelMode_rightClickMicroButtonOpenOldMenu = self.db.profile.extraConfigs.GuildPanelMode.rightClickMicroButtonOpenOldMenu
	self.cached_db_profile.extraConfigs_GuildPanelMode_middleClickMicroButtonOpenOldMenu = self.db.profile.extraConfigs.GuildPanelMode.middleClickMicroButtonOpenOldMenu
	self.cached_db_profile.extraConfigs_GuildPanelMode_leftClickMicroButtonOpenOldMenu = self.db.profile.extraConfigs.GuildPanelMode.leftClickMicroButtonOpenOldMenu
end

-- Function to update the status bars when requested
function ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
	if (self:IsEnabled()) then
		local visBars = {}
		for _, bar in ipairs(StatusTrackingBarManager.bars) do
			if ( bar:ShouldBeVisible() ) then
				tblinsert(visBars, bar)
			end
		end
		tblsort(visBars, function(left, right) return left:GetPriority() < right:GetPriority() end)
		local width = StatusTrackingBarManager:GetParent():GetSize()
		local TOP_BAR = true
		if ( #visBars > 1 ) then
			self.StatusTrackingBarManager_LayoutBar(StatusTrackingBarManager, visBars[2], not TOP_BAR)
			self.StatusTrackingBarManager_LayoutBar(StatusTrackingBarManager, visBars[1], TOP_BAR)
		elseif( #visBars == 1 ) then
			self.StatusTrackingBarManager_LayoutBar(StatusTrackingBarManager, visBars[1], not TOP_BAR)
		end
	end
end

-- Function that sets the LFG button icon (QueueStatusButton) to a smaller size similar to the classic LFG button
function ClassicUI:QueueButtonSetSmallSize()
	QueueStatusButton:SetSize(33, 33)
	QueueStatusButtonIcon.texture:SetSize(29, 29)
	QueueStatusButtonIcon.EyeInitial.EyeInitialTexture:SetSize(30, 30)
	QueueStatusButtonIcon.EyeMouseOver.EyeMouseOverTexture:SetSize(30, 30)
	QueueStatusButtonIcon.EyeFoundInitial.EyeFoundInitialTexture:SetSize(30, 30)
	QueueStatusButtonIcon.EyeFoundLoop.EyeFoundLoopTexture:SetSize(30, 30)
	QueueStatusButtonIcon.EyePokeInitial.EyePokeInitialTexture:SetSize(30, 30)
	QueueStatusButtonIcon.EyePokeLoop.EyePokeLoopTexture:SetSize(30, 30)
	QueueStatusButtonIcon.EyePokeEnd.EyePokeEndTexture:SetSize(30, 30)
	QueueStatusButtonIcon.EyeSearchingLoop.EyeSearchingTexture:SetSize(30, 30)
	QueueStatusButtonIcon.EyeInitial.CircShine:SetSize(28, 28)
	QueueStatusButtonIcon.EyeFoundInitial.SpriteShards:SetSize(51, 51)
	QueueStatusButtonIcon.EyeInitial.GlowFront:SetSize(34, 34)
	QueueStatusButtonIcon.EyeInitial.GlowBack:SetSize(56, 56)
	QueueStatusButtonIcon.EyeFoundInitial.GlowFront:SetSize(34, 34)
	QueueStatusButtonIcon.EyeFoundInitial.GlowBack:SetSize(56, 56)
	QueueStatusButtonIcon.GlowBackLoop.GlowBack:SetSize(56, 56)
end

-- Function that sets the LFG button icon (QueueStatusButton) to a larger size (the default LFG button size since Dragonflight)
function ClassicUI:QueueButtonSetBigSize()
	QueueStatusButton:SetSize(45, 45)
	QueueStatusButtonIcon.texture:SetSize(43, 43)
	QueueStatusButtonIcon.EyeInitial.EyeInitialTexture:SetSize(44, 44)
	QueueStatusButtonIcon.EyeMouseOver.EyeMouseOverTexture:SetSize(44, 44)
	QueueStatusButtonIcon.EyeFoundInitial.EyeFoundInitialTexture:SetSize(44, 44)
	QueueStatusButtonIcon.EyeFoundLoop.EyeFoundLoopTexture:SetSize(44, 44)
	QueueStatusButtonIcon.EyePokeInitial.EyePokeInitialTexture:SetSize(4, 44)
	QueueStatusButtonIcon.EyePokeLoop.EyePokeLoopTexture:SetSize(44, 44)
	QueueStatusButtonIcon.EyePokeEnd.EyePokeEndTexture:SetSize(44, 44)
	QueueStatusButtonIcon.EyeSearchingLoop.EyeSearchingTexture:SetSize(44, 44)
	QueueStatusButtonIcon.EyeInitial.CircShine:SetSize(41, 41)
	QueueStatusButtonIcon.EyeFoundInitial.SpriteShards:SetSize(75, 75)
	QueueStatusButtonIcon.EyeInitial.GlowFront:SetSize(50, 50)
	QueueStatusButtonIcon.EyeInitial.GlowBack:SetSize(82, 82)
	QueueStatusButtonIcon.EyeFoundInitial.GlowFront:SetSize(50, 50)
	QueueStatusButtonIcon.EyeFoundInitial.GlowBack:SetSize(82, 82)
	QueueStatusButtonIcon.GlowBackLoop.GlowBack:SetSize(82, 82)
end

-- Function that modifies the behavior of the free slots counter in the bag
function ClassicUI:BagsFreeSlotsCounterMod()
	if (ClassicUI.cached_db_profile.extraFrames_Bags_freeSlotCounterMod == 2) then	-- cached db value
		ClassicUI.BACKPACK_FREESLOTS_FORMAT = "(%s+%s)"
	else
		ClassicUI.BACKPACK_FREESLOTS_FORMAT = "(%s)"
	end
	if not ClassicUI.hooked_MainMenuBarBackpackButton_UpdateFreeSlots then
		ClassicUI.MainMenuBarBackpackButton_UpdateFreeSlots = function(self)
			if (ClassicUI.cached_db_profile.extraFrames_Bags_freeSlotCounterMod == 1) then	-- cached db value
				local totalFree, freeSlots, bagFamily = 0
				for i = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
					if not(ContainerFrame_IsReagentBag(i)) then
						freeSlots, bagFamily = C_Container_GetContainerNumFreeSlots(i)
						if (bagFamily == 0) then
							totalFree = totalFree + freeSlots
						end
					end
				end
				self.Count:SetText(ClassicUI.BACKPACK_FREESLOTS_FORMAT:format(totalFree))
			elseif (ClassicUI.cached_db_profile.extraFrames_Bags_freeSlotCounterMod == 2) then	-- cached db value
				local totalFree, freeSlots, bagFamily = 0
				local reagentFree = 0
				for i = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
					freeSlots, bagFamily = C_Container.GetContainerNumFreeSlots(i)
					if (bagFamily == 0) then
						if not(ContainerFrame_IsReagentBag(i)) then
							totalFree = totalFree + freeSlots
						else
							reagentFree = reagentFree + freeSlots
						end
					end
				end
				self.Count:SetText(ClassicUI.BACKPACK_FREESLOTS_FORMAT:format(totalFree, reagentFree))
			end
		end
		hooksecurefunc(MainMenuBarBackpackButton, "UpdateFreeSlots", ClassicUI.MainMenuBarBackpackButton_UpdateFreeSlots)
		ClassicUI.hooked_MainMenuBarBackpackButton_UpdateFreeSlots = true
	end
	if (ClassicUI.cached_db_profile.extraFrames_Bags_freeSlotCounterMod ~= 0) then	-- cached db value
		ClassicUI.MainMenuBarBackpackButton_UpdateFreeSlots(MainMenuBarBackpackButton)
	else
		local freeBagSlots = CalculateTotalNumberOfFreeBagSlots()
		MainMenuBarBackpackButton:UpdateFreeSlots()
		MainMenuBarBackpackButton.Count:SetText(ClassicUI.BACKPACK_FREESLOTS_FORMAT:format(freeBagSlots))
	end
end

-- Function that hides the CollapseAndExpandButton from the BuffFrame
function ClassicUI:BuffFrameHideCollapseAndExpandButton()
	if not ClassicUI.hooked_BuffFrame_RefreshCollapseExpandButtonState then
		hooksecurefunc(BuffFrame, "RefreshCollapseExpandButtonState", function(self)
			self.CollapseAndExpandButton:Hide()
		end)
		ClassicUI.hooked_BuffFrame_RefreshCollapseExpandButtonState = true
	end
	BuffFrame.CollapseAndExpandButton:Hide()
end

-- Function that executes functionalities of the 'ExtraFramesFunc' function that need to be executed after the first "PLAYER_ENTERING_WORLD" event
function ClassicUI:EFF_PLAYER_ENTERING_WORLD()
	-- [Minimap]
	if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
		ClassicUI:EnableOldMinimap()
	end
	
	-- [QueueStatusButton]
	if (ClassicUI.db.profile.extraFrames.Minimap.anchorQueueButtonToMinimap) then
		QueueStatusButton:SetParent(MinimapBackdrop)
		QueueStatusButton:ClearAllPoints()
		if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
			QueueStatusButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 22 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, -100 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
		else
			QueueStatusButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", -7 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, -135 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
		end
		QueueStatusButton:SetFrameStrata("LOW")
		QueueStatusButton:SetFrameLevel(5)
		if not(ClassicUI.db.profile.extraFrames.Minimap.bigQueueButton) then
			ClassicUI:QueueButtonSetSmallSize()
		end
	else
		if (ClassicUI:IsEnabled()) then
			QueueStatusButton:SetParent(UIParent)
		end
	end
	
	-- [Bags]
	if (ClassicUI.db.profile.extraFrames.Bags.freeSlotCounterMod ~= 0) then
		ClassicUI:BagsFreeSlotsCounterMod()
	end
	if (ClassicUI.db.profile.extraFrames.Bags.xOffsetFreeSlotsCounter ~= 0) or (ClassicUI.db.profile.extraFrames.Bags.yOffsetFreeSlotsCounter ~= 0) then
		MainMenuBarBackpackButton.Count:ClearAllPoints()
		MainMenuBarBackpackButton.Count:SetPoint("CENTER", MainMenuBarBackpackButton, "CENTER", 0 + ClassicUI.db.profile.extraFrames.Bags.xOffsetFreeSlotsCounter, -10 + ClassicUI.db.profile.extraFrames.Bags.yOffsetFreeSlotsCounter)
	end
	
	-- [BuffAndDebuffFrames]
	if (ClassicUI.db.profile.extraFrames.BuffAndDebuffFrames.hideCollapseAndExpandButton) then
		ClassicUI:BuffFrameHideCollapseAndExpandButton()
	end
end

-- Main function that modifies the additional frames that ClassicUI handles
function ClassicUI:ExtraFramesFunc(isLogin)
	if (isLogin) then
		ClassicUI.OnEvent_PEW_eff = true
		if (not ClassicUI.frame:IsEventRegistered("PLAYER_ENTERING_WORLD")) then
			ClassicUI.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		end
	else
		ClassicUI:EFF_PLAYER_ENTERING_WORLD()
	end
end

-- Main function that loads the additional features of ClassicUI
function ClassicUI:ExtraOptionsFunc()
	--Extra Option: Guild Panel Mode
	if ((ClassicUI.db.profile.extraConfigs.GuildPanelMode.defaultOpenOldMenu) or (ClassicUI.db.profile.extraConfigs.GuildPanelMode.middleClickMicroButtonOpenOldMenu) or (ClassicUI.db.profile.extraConfigs.GuildPanelMode.rightClickMicroButtonOpenOldMenu) or (ClassicUI.db.profile.extraConfigs.GuildPanelMode.leftClickMicroButtonOpenOldMenu)) then
		ClassicUI:HookOpenGuildPanelMode()
	end
	--Extra Option: Keybinds Visibility
	if (ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode > 0) then
		self:ToggleVisibilityKeybinds(ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode)
	end
	--Extra Option: ActionBar Names Visibility
	if (ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideActionButtonName) then
		self:ToggleVisibilityActionButtonNames(ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideActionButtonName)
	end
	--Extra Option: RedRange
	if (ClassicUI.db.profile.extraConfigs.RedRangeConfig.enabled) then
		self:HookRedRangeIcons()
	end
	--Extra Option: GreyOnCooldown
	if (ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.enabled) then
		self:HookGreyOnCooldownIcons()
	end
	--Extra Option: LossOfControlUI
	if (ClassicUI.db.profile.extraConfigs.LossOfControlUIConfig.enabled) then
		self:HookLossOfControlUICCRemover()
	end
end

-- Function that modifies some attributes of the original frames
function ClassicUI:ModifyOriginalFrames()
	MainMenuBar:SetFrameStrata("MEDIUM")
	MainMenuBar:SetFrameLevel(1)
	MainMenuBar:EnableMouse(false)
	--it is preferable not to modify the size and position of the original frames
	--MainMenuBar:SetSize(1024, 53)
	--MainMenuBar:ClearAllPoints()
	--MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0 + ClassicUI.db.profile.barsConfig.MainMenuBar.xOffset, 0 + ClassicUI.db.profile.barsConfig.MainMenuBar.yOffset)
	PetActionBar:SetFrameStrata("LOW")
	PetActionBar:SetFrameLevel(2)
	PetActionBar:EnableMouse(false)
	MultiBarBottomLeft:SetFrameStrata("MEDIUM")
	MultiBarBottomLeft:SetFrameLevel(3)
	MultiBarBottomLeft:EnableMouse(false)
	MultiBarBottomRight:SetFrameStrata("MEDIUM")
	MultiBarBottomRight:SetFrameLevel(3)
	MultiBarBottomRight:EnableMouse(false)
	MultiBarRight:SetFrameStrata("MEDIUM")
	MultiBarRight:SetFrameLevel(3)
	MultiBarRight:EnableMouse(false)
	MultiBarLeft:SetFrameStrata("MEDIUM")
	MultiBarLeft:SetFrameLevel(3)
	MultiBarLeft:EnableMouse(false)
	PossessActionBar:SetFrameStrata("MEDIUM")
	PossessActionBar:SetFrameLevel(2)
	PossessActionBar:EnableMouse(false)
	StanceBar:SetFrameStrata("MEDIUM")
	StanceBar:SetFrameLevel(2)
	StanceBar:EnableMouse(false)
	MainMenuBarVehicleLeaveButton:SetFrameStrata("MEDIUM")
	MainMenuBarVehicleLeaveButton:SetFrameLevel(2)
end

-- Function that restores the FrameStrata and FrameLevel of the most significant frames
function ClassicUI:SetStrataForMainFrames()
	if InCombatLockdown() then
		delayFunc_SetStrataForMainFrames = true
		if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
			fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		return
	end
	MainMenuBar:SetFrameStrata("MEDIUM")
	MainMenuBar:SetFrameLevel(1)
	PetActionBar:SetFrameStrata("LOW")
	PetActionBar:SetFrameLevel(2)
	MultiBarBottomLeft:SetFrameStrata("MEDIUM")
	MultiBarBottomLeft:SetFrameLevel(3)
	MultiBarBottomRight:SetFrameStrata("MEDIUM")
	MultiBarBottomRight:SetFrameLevel(3)
	MultiBarRight:SetFrameStrata("MEDIUM")
	MultiBarRight:SetFrameLevel(3)
	MultiBarLeft:SetFrameStrata("MEDIUM")
	MultiBarLeft:SetFrameLevel(3)
	PossessActionBar:SetFrameStrata("MEDIUM")
	PossessActionBar:SetFrameLevel(2)
	StanceBar:SetFrameStrata("MEDIUM")
	StanceBar:SetFrameLevel(2)
	MainMenuBarVehicleLeaveButton:SetFrameStrata("MEDIUM")
	MainMenuBarVehicleLeaveButton:SetFrameLevel(2)
	CUI_MainMenuBar:SetFrameStrata("MEDIUM")
	CUI_MainMenuBar:SetFrameLevel(1)
	CUI_MainMenuBarArtFrame:SetFrameStrata("MEDIUM")
	CUI_MainMenuBarArtFrame:SetFrameLevel(2)
	CUI_MainMenuBarMaxLevelBar:SetFrameStrata("MEDIUM")
	CUI_MainMenuBarMaxLevelBar:SetFrameLevel(2)
	CUI_MainMenuBar.ActionBarPageNumber:SetFrameStrata("MEDIUM")
	CUI_MainMenuBar.ActionBarPageNumber:SetFrameLevel(3)
	CUI_MainMenuBar.ActionBarPageNumber:SetScale(1)
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetFrameStrata("MEDIUM")
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetFrameLevel(4)
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetFrameStrata("MEDIUM")
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetFrameLevel(4)
	CUI_MainMenuBar.ActionBarPageNumber:Show()
	CUI_PetActionBarFrame:SetFrameStrata("LOW")
	CUI_PetActionBarFrame:SetFrameLevel(2)
end

-- Function that retrieves the number of visible bars. It can negatively affect performance, so it is advisable to use a cached value when possible and avoid multiple unnecessary calls to this function
function ClassicUI:GetNumberVisibleBars(statBar)
	local numVisBars = 0
	for _, bar in ipairs(statBar.bars) do
		if (bar:ShouldBeVisible()) then
			numVisBars = numVisBars + 1
		end
	end
	return mathmin(2, numVisBars)
end

-- Function that keeps the old restored status bars
ClassicUI.StatusTrackingBarManager_LayoutBar = function(self, bar, isTopBar)
	-- Seems that this function does not need protection (InCombatLockdown)
	
	if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
	
	-- Update the cached number of visible bars
	ClassicUI.cached_NumberVisibleBars = ClassicUI:GetNumberVisibleBars(self)
	ClassicUI.cached_NumberRealVisibleBars = ClassicUI.cached_NumberVisibleBars
	
	if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
		-- Show/Hide the DoubleStatusBar
		if (ClassicUI.cached_DoubleStatusBar_hide) then
			local hideDoubleStatusBar = false
			local barsShown = {}
			for _, v in pairs(self.bars) do
				if (v:ShouldBeVisible()) then
					tblinsert(barsShown, v:GetPriority())
				end
			end
			tblsort(barsShown)
			if (#barsShown > 1) then
				for _, v in pairs(ClassicUI.cached_DoubleStatusBar_hide) do
					local barToHide1, barToHide2 = ClassicUI:GetDoubleBarsToHide(v)
					if ((barToHide1 ~= nil) and (barToHide2 ~= nil) and (barToHide1 == barsShown[1]) and (barToHide2 == barsShown[2])) then
						hideDoubleStatusBar = true
						break
					end
				end
			end
			if ( hideDoubleStatusBar ) then
				ClassicUI.cached_NumberRealVisibleBars = 0
				if (self:IsShown()) then
					self:Hide()
				end
			else
				if (not self:IsShown()) then
					self:Show()
				end
			end
		else
			if (not self:IsShown()) then
				self:Show()
			end
		end
	elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
		-- Show/Hide the SingleStatusBar
		if (ClassicUI.cached_SingleStatusBar_hide) then
			local hideSingleStatusBar = false
			local barsShown = {}
			for _, v in pairs(self.bars) do
				if (v:ShouldBeVisible()) then
					tblinsert(barsShown, v:GetPriority())
				end
			end
			tblsort(barsShown)
			if (#barsShown > 0) then
				for _, v in pairs(ClassicUI.cached_SingleStatusBar_hide) do
					local barToHide = ClassicUI:GetSingleBarToHide(v)
					if ((barToHide ~= nil) and (barToHide == barsShown[1])) then
						hideSingleStatusBar = true
						break
					end
				end
			end
			if ( hideSingleStatusBar ) then
				ClassicUI.cached_NumberRealVisibleBars = 0
				if (self:IsShown()) then
					self:Hide()
				end
			else
				if (not self:IsShown()) then
					self:Show()
				end
			end
		else
			if (not self:IsShown()) then
				self:Show()
			end
		end
	end

	bar.StatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar", "BORDER")
	bar.StatusBar:GetStatusBarTexture():SetDrawLayer("BORDER", 0)
	bar.StatusBar:GetStatusBarTexture():SetTexCoord(0, 0, 0, 1, 0.16666667, 0, 0.16666667, 1)
	
	self.TopBarFrameTexture:Hide()
	self.BottomBarFrameTexture:Hide()
	
	bar:ClearAllPoints()
	if (isTopBar) then
		local xOffset = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffset
		local yOffset = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffset
		local xSize = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSize
		local ySize = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySize
		local alpha = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.alpha
		local xOffsetArt = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffsetArt
		local yOffsetArt = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffsetArt
		local xSizeArt = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSizeArt
		local ySizeArt = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySizeArt
		local artAlpha = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artAlpha
		local artHide = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artHide
		local xOffsetOverlay = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffsetOverlay
		local yOffsetOverlay = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffsetOverlay
		local overlayAlpha = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.overlayAlpha
		local overlayHide = ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.overlayHide
		bar.StatusBar.Background:SetAlpha(alpha)
		bar:SetPoint("BOTTOM", CUI_MainMenuBar, "TOP", 0 + xOffset, 0 + yOffset)
		bar.StatusBar:SetSize(1024 + xSize, 7 + ySize)
		bar:SetSize(1024 + xSize, 7 + ySize)
		bar.OverlayFrame.Text:SetPoint("CENTER", bar.OverlayFrame, "CENTER", 0 + xOffsetOverlay, 1 + yOffsetOverlay)
		bar.OverlayFrame:SetAlpha(overlayHide and 0 or overlayAlpha)
		bar.OverlayFrame.Text:SetShown(not(overlayHide))
		self.TopBarFrameTexture0:SetPoint("BOTTOMLEFT", CUI_MainMenuBar, "TOPLEFT", 0 + xOffsetArt, -1 + yOffsetArt)
		self.TopBarFrameTexture0:SetSize(256 + xSizeArt, 11 + ySizeArt)
		self.TopBarFrameTexture1:SetSize(256 + xSizeArt, 11 + ySizeArt)
		self.TopBarFrameTexture2:SetSize(256 + xSizeArt, 11 + ySizeArt)
		self.TopBarFrameTexture3:SetSize(256 + xSizeArt, 11 + ySizeArt)
		self.TopBarFrameTexture0:SetAlpha(artAlpha)
		self.TopBarFrameTexture1:SetAlpha(artAlpha)
		self.TopBarFrameTexture2:SetAlpha(artAlpha)
		self.TopBarFrameTexture3:SetAlpha(artAlpha)
		if not(artHide) then
			if not(self.TopBarFrameTexture0:IsShown()) then
				self.TopBarFrameTexture0:Show()
				self.TopBarFrameTexture1:Show()
				self.TopBarFrameTexture2:Show()
				self.TopBarFrameTexture3:Show()
			end
		else
			if (self.TopBarFrameTexture0:IsShown()) then
				self.TopBarFrameTexture0:Hide()
				self.TopBarFrameTexture1:Hide()
				self.TopBarFrameTexture2:Hide()
				self.TopBarFrameTexture3:Hide()
			end
		end
	else
		local doubleBar = (ClassicUI.cached_NumberVisibleBars >= 2)
		local xOffset = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffset or ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffset
		local yOffset = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffset or ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffset
		local xSize = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSize or ClassicUI.db.profile.barsConfig.SingleStatusBar.xSize
		local ySize = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySize or ClassicUI.db.profile.barsConfig.SingleStatusBar.ySize
		local alpha = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.alpha or ClassicUI.db.profile.barsConfig.SingleStatusBar.alpha
		local xOffsetArt = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffsetArt or ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffsetArt
		local yOffsetArt = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffsetArt or ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffsetArt
		local xSizeArt = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSizeArt or ClassicUI.db.profile.barsConfig.SingleStatusBar.xSizeArt
		local ySizeArt = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySizeArt or ClassicUI.db.profile.barsConfig.SingleStatusBar.ySizeArt
		local artAlpha = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artAlpha or ClassicUI.db.profile.barsConfig.SingleStatusBar.artAlpha
		local artHide = (doubleBar and {ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artHide} or {ClassicUI.db.profile.barsConfig.SingleStatusBar.artHide})[1]
		local xOffsetOverlay = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffsetOverlay or ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffsetOverlay
		local yOffsetOverlay = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffsetOverlay or ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffsetOverlay
		local overlayAlpha = doubleBar and ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.overlayAlpha or ClassicUI.db.profile.barsConfig.SingleStatusBar.overlayAlpha
		local overlayHide = (doubleBar and {ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.overlayHide} or {ClassicUI.db.profile.barsConfig.SingleStatusBar.overlayHide})[1]
		bar.StatusBar.Background:SetAlpha(alpha)
		bar:SetPoint("TOP", CUI_MainMenuBar, "TOP", 0 + xOffset, -1 + yOffset)
		bar.StatusBar:SetSize(1024 + xSize, 10 + ySize)
		bar:SetSize(1024 + xSize, 10 + ySize)
		bar.OverlayFrame.Text:SetPoint("CENTER", bar.OverlayFrame, "CENTER", 0 + xOffsetOverlay, 0 + yOffsetOverlay)
		bar.OverlayFrame:SetAlpha(overlayHide and 0 or overlayAlpha)
		bar.OverlayFrame.Text:SetShown(not(overlayHide))
		self.BottomBarFrameTexture0:SetPoint("TOPLEFT", CUI_MainMenuBar, "TOPLEFT", 0 + xOffsetArt, 0 + yOffsetArt)
		self.BottomBarFrameTexture0:SetSize(256 + xSizeArt, 10 + ySizeArt)
		self.BottomBarFrameTexture1:SetSize(256 + xSizeArt, 10 + ySizeArt)
		self.BottomBarFrameTexture2:SetSize(256 + xSizeArt, 10 + ySizeArt)
		self.BottomBarFrameTexture3:SetSize(256 + xSizeArt, 10 + ySizeArt)
		self.BottomBarFrameTexture0:SetAlpha(artAlpha)
		self.BottomBarFrameTexture1:SetAlpha(artAlpha)
		self.BottomBarFrameTexture2:SetAlpha(artAlpha)
		self.BottomBarFrameTexture3:SetAlpha(artAlpha)
		if not(artHide) then
			if not(self.BottomBarFrameTexture0:IsShown()) then
				self.BottomBarFrameTexture0:Show()
				self.BottomBarFrameTexture1:Show()
				self.BottomBarFrameTexture2:Show()
				self.BottomBarFrameTexture3:Show()
			end
		else
			if (self.BottomBarFrameTexture0:IsShown()) then
				self.BottomBarFrameTexture0:Hide()
				self.BottomBarFrameTexture1:Hide()
				self.BottomBarFrameTexture2:Hide()
				self.BottomBarFrameTexture3:Hide()
			end
		end
	end
end

-- Function that updates the position of the some ActionBars
ClassicUI.UpdatedStatusBarsEvent = function()
	-- No need to update cache here
	
	if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
		if not(CUI_MainMenuBarMaxLevelBar:IsShown()) then
			CUI_MainMenuBarMaxLevelBar:Show()
		end
	elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
		if (CUI_MainMenuBarMaxLevelBar:IsShown()) then
			CUI_MainMenuBarMaxLevelBar:Hide()
		end
	else
		if (CUI_MainMenuBarMaxLevelBar:IsShown()) then
			CUI_MainMenuBarMaxLevelBar:Hide()
		end
	end
	
	if InCombatLockdown() then
		delayFunc_UpdatedStatusBarsEvent = true
		if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
			fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		return
	end
	
	if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
	
	CUI_MultiBarBottomLeft:RelocateBar()
	CUI_MultiBarRight:RelocateBar()
	CUI_PetActionBarFrame:RelocateBar()
	CUI_PossessBarFrame:RelocateBar()
	CUI_StanceBarFrame:RelocateBar()
	
	delayFunc_UpdatedStatusBarsEvent = false
end

-- Function to relocate Main Frames after a option change
function ClassicUI:ReloadMainFramesSettings()
	if (self:IsEnabled()) then
		CUI_MainMenuBar.ActionBarPageNumber:SetScale(1)
		if (self.db.profile.extraFrames.Minimap.enabled) then
			MinimapCluster:ClearAllPoints()
			MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", self.db.profile.extraFrames.Minimap.xOffset, self.db.profile.extraFrames.Minimap.yOffset)
		end
		if not(PetBattleFrame.BottomFrame.MicroButtonFrame:IsVisible()) and (ActionBarController_GetCurrentActionBarState() ~= LE_ACTIONBAR_STATE_OVERRIDE) then
			MoveMicroButtons("BOTTOMLEFT", CUI_MainMenuBarArtFrame, "BOTTOMLEFT", 556 + self.db.profile.barsConfig.MicroButtons.xOffset, 2 + self.db.profile.barsConfig.MicroButtons.yOffset, false)
			LFDMicroButton:SetPoint("BOTTOMLEFT", GuildMicroButton, "BOTTOMRIGHT", -3, 0)
		end
		for k, _ in pairs(self.MicroButtonsGroup) do
			k:SetScale(self.db.profile.barsConfig.MicroButtons.scale)
		end
		if not(self.db.profile.barsConfig.MicroButtons.useClassicQuestIcon) then
			QuestLogMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Quest-Up")
			QuestLogMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-Quest-Down")
			QuestLogMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-Quest-Disabled")
		else
			QuestLogMicroButton:SetNormalTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Quest-Up-classic")
			QuestLogMicroButton:SetPushedTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Quest-Down-classic")
			QuestLogMicroButton:SetDisabledTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Quest-Disabled-classic")
		end
		if not(self.db.profile.barsConfig.MicroButtons.useClassicGuildIcon) then
			GuildMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Socials-Up")
			GuildMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-Socials-Down")
			GuildMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-Socials-Disabled")
			GuildMicroButtonTabardEmblem:SetAlpha(1)
			GuildMicroButtonTabardEmblem:Show()
			GuildMicroButtonTabardBackground:SetAlpha(1)
			GuildMicroButtonTabardBackground:Show()
			GuildMicroButtonTabard:SetAlpha(1)
		else
			GuildMicroButton:SetNormalTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Socials-Up-classic")
			GuildMicroButton:SetPushedTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Socials-Down-classic")
			GuildMicroButton:SetDisabledTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Socials-Disabled-classic")
			GuildMicroButtonTabardEmblem:SetAlpha(0)
			GuildMicroButtonTabardEmblem:Hide()
			GuildMicroButtonTabardBackground:SetAlpha(0)
			GuildMicroButtonTabardBackground:Hide()
			GuildMicroButtonTabard:SetAlpha(0)
		end
		if not(self.db.profile.barsConfig.MicroButtons.useBiggerGuildEmblem) then
			GuildMicroButtonTabardEmblem:SetSize(14, 14)
		else
			GuildMicroButtonTabardEmblem:SetSize(16, 16)
		end
		GuildMicroButtonTabard:Hide()
		self.GuildMicroButton_UpdateTabard(true)
		if not(self.db.profile.barsConfig.MicroButtons.useClassicMainMenuIcon) then
			MainMenuMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-MainMenu-Up")
			MainMenuMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-MainMenu-Down")
			MainMenuMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-MainMenu-Disabled")
		else
			MainMenuMicroButton:SetNormalTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Up-classic")
			MainMenuMicroButton:SetPushedTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Down-classic")
			MainMenuMicroButton:SetDisabledTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Disabled-classic")
		end
		
		for i = 0, 3 do
			local bagSlot = _G["CharacterBag"..i.."Slot"]
			bagSlot.IconBorder:SetAlpha(self.db.profile.barsConfig.BagsIcons.iconBorderAlpha)
		end
		CharacterReagentBag0Slot:ClearAllPoints()
		CharacterReagentBag0Slot:SetPoint("CENTER", CharacterBag3Slot, "LEFT", -5 + self.db.profile.barsConfig.BagsIcons.xOffsetReagentBag, -2 + self.db.profile.barsConfig.BagsIcons.yOffsetReagentBag)
		
		if InCombatLockdown() then
			delayFunc_ReloadMainFramesSettings = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		
		CUI_MainMenuBar:RelocateBar()
		OverrideActionBar:SetPoint("BOTTOM", OverrideActionBar:GetParent(), "BOTTOM", self.db.profile.barsConfig.OverrideActionBar.xOffset, self.db.profile.barsConfig.OverrideActionBar.yOffset)
		OverrideActionBar:SetScale(self.db.profile.barsConfig.OverrideActionBar.scale)
		PetBattleFrame.BottomFrame:SetPoint("BOTTOM", PetBattleFrame.BottomFrame:GetParent(), "BOTTOM", self.db.profile.barsConfig.PetBattleFrameBar.xOffset, self.db.profile.barsConfig.PetBattleFrameBar.yOffset)
		PetBattleFrame.BottomFrame:SetScale(self.db.profile.barsConfig.PetBattleFrameBar.scale)
		
		CUI_MainMenuBar.oldOrigScale = nil
		CUI_MultiBarBottomLeft.oldOrigScale = nil
		CUI_MultiBarBottomRight.oldOrigScale = nil
		CUI_MultiBarRight.oldOrigScale = nil
		CUI_MultiBarLeft.oldOrigScale = nil
		CUI_PetActionBarFrame.oldOrigScale = nil
		CUI_PossessBarFrame.oldOrigScale = nil
		CUI_StanceBarFrame.oldOrigScale = nil
		
		CUI_MainMenuBar.hook_SetScale(MainMenuBar, MainMenuBar:GetScale())
		CUI_MultiBarBottomLeft.hook_SetScale(MultiBarBottomLeft, MultiBarBottomLeft:GetScale())
		CUI_MultiBarBottomRight.hook_SetScale(MultiBarBottomRight, MultiBarBottomRight:GetScale())
		CUI_MultiBarRight.hook_SetScale(MultiBarRight, MultiBarRight:GetScale())
		CUI_MultiBarLeft.hook_SetScale(MultiBarLeft, MultiBarLeft:GetScale())
		CUI_PetActionBarFrame.hook_SetScale(PetActionBar, PetActionBar:GetScale())
		CUI_PossessBarFrame.hook_SetScale(PossessActionBar, PossessActionBar:GetScale())
		CUI_StanceBarFrame.hook_SetScale(StanceBar, StanceBar:GetScale())
	end
end

-- Function that performs all the necessary modifications in the interface to bring back the old Minimap
function ClassicUI:EnableOldMinimap()
	MinimapCluster:SetSize(192, 192)
	MinimapCluster:SetHitRectInsets(30, 10, 0, 30)
	MinimapCluster:SetScale(self.db.profile.extraFrames.Minimap.scale)
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", self.db.profile.extraFrames.Minimap.xOffset, self.db.profile.extraFrames.Minimap.yOffset)
	Minimap:SetSize(140, 140)
	Minimap:ClearAllPoints()
	Minimap:SetPoint("CENTER", MinimapCluster, "TOP", 9, -92)
	MinimapBackdrop:ClearAllPoints()
	MinimapBackdrop:SetPoint("CENTER", MinimapCluster, "CENTER", 0, -20)
	MinimapBackdrop:SetSize(192,192)
	MinimapBackdrop:CreateTexture("MinimapBorder", "ARTWORK")
	MinimapBorder:ClearAllPoints()
	MinimapBorder:SetAllPoints(MinimapBackdrop)
	MinimapBorder:SetTexture("Interface\\Minimap\\UI-Minimap-Border", "ARTWORK")
	MinimapBorder:SetDrawLayer("ARTWORK", 0)
	MinimapBorder:SetTexCoord(0.25, 0.125, 0.25, 0.875, 1, 0.125, 1, 0.875)
	MinimapCompassTexture:ClearAllPoints()
	MinimapCompassTexture:SetPoint("CENTER", Minimap, "CENTER", -2, 0)
	MinimapCompassTexture:SetTexture("Interface\\Minimap\\CompassRing", "OVERLAY")
	MinimapCompassTexture:SetSize(256, 256)	-- 365x365 scaled 0.7 = 255.5x255.5
	MinimapCompassTexture:SetDrawLayer("OVERLAY", 0)
	MinimapBackdrop:CreateTexture("MinimapNorthTag")
	MinimapNorthTag:ClearAllPoints()
	MinimapNorthTag:SetPoint("CENTER", Minimap, "CENTER", 0, 67)
	MinimapNorthTag:SetTexture("Interface\\Minimap\\CompassNorthTag", "OVERLAY")
	MinimapNorthTag:SetSize(16, 16)
	MinimapNorthTag:SetDrawLayer("OVERLAY", 0)
	hooksecurefunc(MinimapCluster, "SetRotateMinimap", function(self, rotateMinimap)
		if (rotateMinimap) then
			MinimapCompassTexture:Show()
			MinimapNorthTag:Hide()
		else
			MinimapCompassTexture:Hide()
			MinimapNorthTag:Show()
		end
	end)
	if (GetCVar("rotateMinimap") == "1") then
		MinimapCompassTexture:Show()
		MinimapNorthTag:Hide()
	else
		MinimapCompassTexture:Hide()
		MinimapNorthTag:Show()
	end
	
	local iZoom = Minimap:GetZoom()
	if (iZoom+1 < Minimap:GetZoomLevels()) then
		Minimap:SetZoom(iZoom+1)
		Minimap:SetZoom(iZoom)
	else
		Minimap:SetZoom(0)
		Minimap:SetZoom(iZoom)
	end
	
	hooksecurefunc(ExpansionLandingPageMinimapButton, "UpdateIconForGarrison", function()
		ExpansionLandingPageMinimapButton:ClearAllPoints()
		ExpansionLandingPageMinimapButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 32, -105)
	end)
	ExpansionLandingPageMinimapButton:ClearAllPoints()
	ExpansionLandingPageMinimapButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 32, -105)
	local ldbi = LibStub ~= nil and LibStub:GetLibrary("LibDBIcon-1.0")
	if (ldbi ~= nil) then
		for _, v in pairs(ldbi:GetButtonList()) do
			ldbi:Refresh(v)
		end
	end
	
	TimeManagerClockButton:SetParent(Minimap)
	TimeManagerClockButton:ClearAllPoints()
	TimeManagerClockButton:SetPoint("CENTER", Minimap, "CENTER", 0, -75)
	TimeManagerClockButton:SetFrameStrata("LOW")
	TimeManagerClockButton:SetFrameLevel(5)
	TimeManagerClockButton:SetSize(60, 28)
	--TimeManagerClockButton:SetHitRectInsets(8, 5, 3, 3)	--is already the default value
	local TimeManagerClockButtonBackground = TimeManagerClockButton:CreateTexture("TimeManagerClockButtonBackground", "BORDER")
	TimeManagerClockButtonBackground:ClearAllPoints()
	TimeManagerClockButtonBackground:SetAllPoints(TimeManagerClockButton)
	TimeManagerClockButtonBackground:SetTexture("Interface\\TimeManager\\ClockBackground")
	TimeManagerClockButtonBackground:SetTexCoord(0.015625, 0.8125, 0.015625, 0.390625)
	TimeManagerClockButtonBackground:Show()
	
	GameTimeFrame:SetParent(Minimap)
	GameTimeFrame:ClearAllPoints()
	GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 20, -2)
	GameTimeFrame:SetSize(40, 40)
	GameTimeFrame:SetHitRectInsets(6, 0, 5, 10)
	GameTimeFrame:SetFrameStrata("LOW")
	GameTimeFrame:SetFrameLevel(5)
	
	hooksecurefunc("GameTimeFrame_SetDate", function()
		GameTimeFrame:SetText(C_DateAndTime_GetCurrentCalendarTime().monthDay)
		GameTimeFrame:SetNormalTexture("Interface\\Calendar\\UI-Calendar-Button")
		GameTimeFrame:GetNormalTexture():SetTexCoord(0, 0, 0, 0.78125, 0.390625, 0, 0.390625, 0.78125)
		GameTimeFrame:SetPushedTexture("Interface\\Calendar\\UI-Calendar-Button")
		GameTimeFrame:GetPushedTexture():SetTexCoord(0.5, 0, 0.5, 0.78125, 0.890625, 0, 0.890625, 0.78125)
		GameTimeFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
		--GameTimeFrame:GetHighlightTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)	--not needed
		GameTimeFrame:GetNormalTexture():SetDrawLayer("BACKGROUND")
		GameTimeFrame:GetPushedTexture():SetDrawLayer("BACKGROUND")
		GameTimeFrame:GetFontString():SetDrawLayer("BACKGROUND")
	end)
	GameTimeFrame:SetNormalTexture("Interface\\Calendar\\UI-Calendar-Button")
	GameTimeFrame:GetNormalTexture():SetTexCoord(0, 0, 0, 0.78125, 0.390625, 0, 0.390625, 0.78125)
	GameTimeFrame:SetPushedTexture("Interface\\Calendar\\UI-Calendar-Button")
	GameTimeFrame:GetPushedTexture():SetTexCoord(0.5, 0, 0.5, 0.78125, 0.890625, 0, 0.890625, 0.78125)
	GameTimeFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
	--GameTimeFrame:GetHighlightTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)	--not needed
	GameTimeFrame:SetNormalFontObject("GameFontBlack")
	GameTimeFrame:SetFontString(GameTimeFrame:CreateFontString(nil, "BACKGROUND", "GameFontBlack"))
	GameTimeFrame:GetFontString():ClearAllPoints()
	GameTimeFrame:GetFontString():SetPoint("CENTER", GameTimeFrame, "CENTER", -1, -1)
	GameTimeFrame:GetNormalTexture():SetDrawLayer("BACKGROUND")
	GameTimeFrame:GetPushedTexture():SetDrawLayer("BACKGROUND")
	GameTimeFrame:GetFontString():SetDrawLayer("BACKGROUND")
	GameTimeFrame:SetText(C_DateAndTime_GetCurrentCalendarTime().monthDay)
	
	MinimapCluster.Tracking:SetParent(MinimapBackdrop)
	MinimapCluster.Tracking:ClearAllPoints()
	MinimapCluster.Tracking:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 9, -45)
	MinimapCluster.Tracking:SetFrameStrata("LOW")
	MinimapCluster.Tracking:SetFrameLevel(4)
	MinimapCluster.Tracking:SetSize(32, 32)
	MinimapCluster.Tracking.Background:SetParent(MinimapCluster.Tracking)
	MinimapCluster.Tracking.Background:ClearAllPoints()
	MinimapCluster.Tracking.Background:SetPoint("TOPLEFT", MinimapCluster.Tracking, "TOPLEFT", 2, -4)
	MinimapCluster.Tracking.Background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
	MinimapCluster.Tracking.Background:SetSize(25, 25)
	MinimapCluster.Tracking.Background:SetAlpha(0.6)
	MinimapCluster.Tracking.Button:SetParent(MinimapCluster.Tracking)
	MinimapCluster.Tracking.Button:ClearAllPoints()
	MinimapCluster.Tracking.Button:SetPoint("TOPLEFT", MinimapCluster.Tracking, "TOPLEFT", 0, 0)
	MinimapCluster.Tracking.Button:SetFrameStrata("LOW")
	MinimapCluster.Tracking.Button:SetFrameLevel(5)
	MinimapCluster.Tracking.Button:SetSize(32, 32)
	MinimapCluster.Tracking.Button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
	
	MinimapCluster.Tracking.Button:GetNormalTexture():SetTexture(nil)
	MinimapCluster.Tracking.Button:GetNormalTexture():SetAlpha(0)
	MinimapCluster.Tracking.Button:GetNormalTexture():Hide()
	MinimapCluster.Tracking.Button:GetPushedTexture():SetTexture(nil)
	MinimapCluster.Tracking.Button:GetNormalTexture():SetAlpha(0)
	MinimapCluster.Tracking.Button:GetNormalTexture():Hide()
	MinimapCluster.Tracking.Button:CreateTexture("MiniMapTrackingButtonBorder", "BORDER")
	MinimapCluster.Tracking.ButtonBorder = MiniMapTrackingButtonBorder
	MinimapCluster.Tracking.ButtonBorder:ClearAllPoints()
	MinimapCluster.Tracking.ButtonBorder:SetPoint("TOPLEFT", MinimapCluster.Tracking.Button, "TOPLEFT", 0, 0)
	MinimapCluster.Tracking.ButtonBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\MiniMap-TrackingBorder")
	MinimapCluster.Tracking.ButtonBorder:SetSize(54, 54)
	MinimapCluster.Tracking.ButtonBorder:SetDrawLayer("BORDER", 0)
	MinimapCluster.Tracking:CreateTexture("MiniMapTrackingIcon", "ARTWORK")
	MinimapCluster.Tracking.MiniMapTrackingIcon = MiniMapTrackingIcon
	MinimapCluster.Tracking.MiniMapTrackingIcon:ClearAllPoints()
	MinimapCluster.Tracking.MiniMapTrackingIcon:SetPoint("TOPLEFT", MinimapCluster.Tracking, "TOPLEFT", 6, -6)
	MinimapCluster.Tracking.MiniMapTrackingIcon:SetTexture("Interface\\Minimap\\Tracking\\None")
	MinimapCluster.Tracking.MiniMapTrackingIcon:SetSize(20, 20)
	MinimapCluster.Tracking.MiniMapTrackingIcon:Show()
	MinimapCluster.Tracking:CreateTexture("MiniMapTrackingIconOverlay", "OVERLAY")
	MinimapCluster.Tracking.MiniMapTrackingIconOverlay = MiniMapTrackingIconOverlay
	MinimapCluster.Tracking.MiniMapTrackingIconOverlay:ClearAllPoints()
	MinimapCluster.Tracking.MiniMapTrackingIconOverlay:SetAllPoints(MinimapCluster.Tracking.MiniMapTrackingIcon)
	MinimapCluster.Tracking.MiniMapTrackingIconOverlay:SetSize(20, 20)
	MinimapCluster.Tracking.MiniMapTrackingIconOverlay:SetColorTexture(0, 0, 0, 0.5)
	MinimapCluster.Tracking.MiniMapTrackingIconOverlay:Hide()
	MinimapCluster.Tracking.Button:HookScript("OnMouseDown", function()
		MinimapCluster.Tracking.MiniMapTrackingIcon:SetPoint("TOPLEFT", MinimapCluster.Tracking, "TOPLEFT", 8, -8)
		MinimapCluster.Tracking.MiniMapTrackingIconOverlay:Show()
	end)
	
	MinimapCluster.Tracking.Button:HookScript("OnMouseUp", function()
		MinimapCluster.Tracking.MiniMapTrackingIcon:SetPoint("TOPLEFT", MinimapCluster.Tracking, "TOPLEFT", 6, -6)
		MinimapCluster.Tracking.MiniMapTrackingIconOverlay:Hide()
	end)
	
	Minimap.ZoomIn:SetParent(MinimapBackdrop)
	Minimap.ZoomIn:ClearAllPoints()
	Minimap.ZoomIn:SetPoint("CENTER", MinimapBackdrop, "CENTER", 72, -25)
	Minimap.ZoomIn:SetFrameStrata("LOW")
	Minimap.ZoomIn:SetFrameLevel(4)
	Minimap.ZoomIn:SetSize(32, 32)
	Minimap.ZoomIn:SetNormalTexture("Interface\\Minimap\\UI-Minimap-ZoomInButton-Up")
	Minimap.ZoomIn:SetPushedTexture("Interface\\Minimap\\UI-Minimap-ZoomInButton-Down")
	Minimap.ZoomIn:SetDisabledTexture("Interface\\Minimap\\UI-Minimap-ZoomInButton-Disabled")
	Minimap.ZoomIn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
	Minimap.ZoomIn:SetHitRectInsets(4, 4, 2, 6)
	Minimap.ZoomOut:SetParent(MinimapBackdrop)
	Minimap.ZoomOut:ClearAllPoints()
	Minimap.ZoomOut:SetPoint("CENTER", MinimapBackdrop, "CENTER", 50, -43)
	Minimap.ZoomOut:SetFrameStrata("LOW")
	Minimap.ZoomOut:SetFrameLevel(4)
	Minimap.ZoomOut:SetSize(32, 32)
	Minimap.ZoomOut:SetNormalTexture("Interface\\Minimap\\UI-Minimap-ZoomOutButton-Up")
	Minimap.ZoomOut:SetPushedTexture("Interface\\Minimap\\UI-Minimap-ZoomOutButton-Down")
	Minimap.ZoomOut:SetDisabledTexture("Interface\\Minimap\\UI-Minimap-ZoomOutButton-Disabled")
	Minimap.ZoomOut:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
	Minimap.ZoomOut:SetHitRectInsets(4, 4, 2, 6)
	Minimap:HookScript("OnLeave", function(self)
		self.ZoomIn:Show()
		self.ZoomOut:Show()
	end)
	Minimap.ZoomIn:Show()
	Minimap.ZoomOut:Show()
	
	MinimapCluster.MailFrame:SetParent(MinimapCluster)
	MinimapCluster.MailFrame:ClearAllPoints()
	MinimapCluster.MailFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 24, -37)
	MinimapCluster.MailFrame:SetSize(33, 33)
	MinimapCluster.MailFrame:SetFrameStrata("LOW")
	MinimapCluster.MailFrame:SetFrameLevel(4)
	
	MiniMapMailIcon:ClearAllPoints()
	MiniMapMailIcon:SetPoint("TOPLEFT", MinimapCluster.MailFrame, "TOPLEFT", 7, -6)
	MiniMapMailIcon:SetTexture("Interface\\Icons\\INV_Letter_15")
	MiniMapMailIcon:SetSize(18, 18)
	MiniMapMailIcon:SetDrawLayer("ARTWORK", 0)
	
	MinimapCluster.MailFrame:CreateTexture("MiniMapMailBorder", "OVERLAY")
	MiniMapMailBorder:ClearAllPoints()
	MiniMapMailBorder:SetPoint("TOPLEFT", MinimapCluster.MailFrame, "TOPLEFT", 0, 0)
	MiniMapMailBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\MiniMap-TrackingBorder")
	MiniMapMailBorder:SetSize(52, 52)
	MiniMapMailBorder:SetDrawLayer("OVERLAY", 0)
	
	MinimapCluster.InstanceDifficulty:Hide()
	
	local CUI_MiniMapInstanceDifficulty = CreateFrame("Frame", "CUI_MiniMapInstanceDifficulty", MinimapCluster)
	CUI_MiniMapInstanceDifficulty:SetFrameStrata("LOW")
	CUI_MiniMapInstanceDifficulty:SetFrameLevel(11)
	CUI_MiniMapInstanceDifficulty:SetSize(38, 46)
	CUI_MiniMapInstanceDifficulty:SetPoint("TOPLEFT", MinimapCluster, "TOPLEFT", 22, -17)
	CUI_MiniMapInstanceDifficulty:Hide()
	local CUI_MiniMapInstanceDifficultyTexture = CUI_MiniMapInstanceDifficulty:CreateTexture("CUI_MiniMapInstanceDifficultyTexture", "ARTWORK")
	CUI_MiniMapInstanceDifficultyTexture:SetSize(64, 46)
	CUI_MiniMapInstanceDifficultyTexture:SetTexture("Interface\\Minimap\\UI-DungeonDifficulty-Button")
	CUI_MiniMapInstanceDifficultyTexture:SetTexCoord(0, 0.25, 0.0703125, 0.4140625)
	CUI_MiniMapInstanceDifficultyTexture:SetPoint("CENTER", CUI_MiniMapInstanceDifficulty, "CENTER", 0, 0)
	local CUI_MiniMapInstanceDifficultyText = CUI_MiniMapInstanceDifficulty:CreateFontString("CUI_MiniMapInstanceDifficultyText", "ARTWORK", "GameFontNormalSmall")
	CUI_MiniMapInstanceDifficultyText:SetJustifyH("CENTER")
	CUI_MiniMapInstanceDifficultyText:SetJustifyV("MIDDLE")
	CUI_MiniMapInstanceDifficultyText:SetPoint("CENTER", CUI_MiniMapInstanceDifficulty, "CENTER", -1, -7)
	
	local CUI_GuildInstanceDifficulty = CreateFrame("Frame", "CUI_GuildInstanceDifficulty", MinimapCluster)
	CUI_GuildInstanceDifficulty:SetFrameStrata("LOW")
	CUI_GuildInstanceDifficulty:SetFrameLevel(11)
	CUI_GuildInstanceDifficulty:SetSize(38, 46)
	CUI_GuildInstanceDifficulty:SetPoint("TOPLEFT", MinimapCluster, "TOPLEFT", 22, -17)
	CUI_GuildInstanceDifficulty:Hide()
	local CUI_GuildInstanceDifficultyBackground = CUI_GuildInstanceDifficulty:CreateTexture("CUI_GuildInstanceDifficultyBackground", "BACKGROUND")
	CUI_GuildInstanceDifficulty.background = CUI_GuildInstanceDifficultyBackground
	CUI_GuildInstanceDifficultyBackground:SetSize(41, 53)
	CUI_GuildInstanceDifficultyBackground:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	CUI_GuildInstanceDifficultyBackground:SetTexCoord(0.0078125, 0.328125, 0.015625, 0.84375)
	CUI_GuildInstanceDifficultyBackground:SetPoint("TOPLEFT", CUI_GuildInstanceDifficulty, "TOPLEFT", 0, 0)
	local CUI_GuildInstanceDifficultyDarkBackground = CUI_GuildInstanceDifficulty:CreateTexture("CUI_GuildInstanceDifficultyDarkBackground", "BORDER")
	CUI_GuildInstanceDifficultyDarkBackground:SetSize(30, 21)
	CUI_GuildInstanceDifficultyDarkBackground:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	CUI_GuildInstanceDifficultyDarkBackground:SetTexCoord(0.6796875, 0.9140625, 0.015625, 0.34375)
	CUI_GuildInstanceDifficultyDarkBackground:SetPoint("BOTTOM", CUI_GuildInstanceDifficultyBackground, "BOTTOM", 0, 7)
	CUI_GuildInstanceDifficultyDarkBackground:SetAlpha(0.7)
	local CUI_GuildInstanceDifficultyEmblem = CUI_GuildInstanceDifficulty:CreateTexture("CUI_GuildInstanceDifficultyEmblem", "ARTWORK")
	CUI_GuildInstanceDifficulty.emblem = CUI_GuildInstanceDifficultyEmblem
	CUI_GuildInstanceDifficultyEmblem:SetSize(16, 16)
	CUI_GuildInstanceDifficultyEmblem:SetTexture("Interface\\GuildFrame\\GuildEmblems_01")
	CUI_GuildInstanceDifficultyEmblem:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	CUI_GuildInstanceDifficultyEmblem:SetPoint("TOPLEFT", CUI_GuildInstanceDifficulty, "TOPLEFT", 12, -10)
	local CUI_GuildInstanceDifficultyBorder = CUI_GuildInstanceDifficulty:CreateTexture("CUI_GuildInstanceDifficultyBorder", "ARTWORK")
	CUI_GuildInstanceDifficulty.border = CUI_GuildInstanceDifficultyBorder
	CUI_GuildInstanceDifficultyBorder:SetSize(41, 53)
	CUI_GuildInstanceDifficultyBorder:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	CUI_GuildInstanceDifficultyBorder:SetTexCoord(0.34375, 0.6640625, 0.015625, 0.84375)
	CUI_GuildInstanceDifficultyBorder:SetPoint("BOTTOMLEFT", CUI_GuildInstanceDifficulty, "BOTTOMLEFT", 0, 0)
	local CUI_GuildInstanceDifficultyHeroicTexture = CUI_GuildInstanceDifficulty:CreateTexture("CUI_GuildInstanceDifficultyHeroicTexture", "ARTWORK")
	CUI_GuildInstanceDifficultyHeroicTexture:SetSize(12, 13)
	CUI_GuildInstanceDifficultyHeroicTexture:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	CUI_GuildInstanceDifficultyHeroicTexture:SetTexCoord(0.6796875, 0.7734375, 0.65625, 0.859375)
	CUI_GuildInstanceDifficultyHeroicTexture:SetPoint("BOTTOMLEFT", CUI_GuildInstanceDifficulty, "BOTTOMLEFT", 8, 7)
	local CUI_GuildInstanceDifficultyMythicTexture = CUI_GuildInstanceDifficulty:CreateTexture("CUI_GuildInstanceDifficultyMythicTexture", "ARTWORK")
	CUI_GuildInstanceDifficultyMythicTexture:SetSize(12, 13)
	CUI_GuildInstanceDifficultyMythicTexture:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	CUI_GuildInstanceDifficultyMythicTexture:SetTexCoord(0.7734375, 0.8671875, 0.65625, 0.859375)
	CUI_GuildInstanceDifficultyMythicTexture:SetPoint("BOTTOMLEFT", CUI_GuildInstanceDifficulty, "BOTTOMLEFT", 8, 7)
	local CUI_GuildInstanceDifficultyChallengeModeTexture = CUI_GuildInstanceDifficulty:CreateTexture("CUI_GuildInstanceDifficultyChallengeModeTexture", "ARTWORK")
	CUI_GuildInstanceDifficultyChallengeModeTexture:SetSize(12, 12)
	CUI_GuildInstanceDifficultyChallengeModeTexture:SetTexture("Interface\\Common\\mini-hourglass")
	CUI_GuildInstanceDifficultyChallengeModeTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	CUI_GuildInstanceDifficultyChallengeModeTexture:SetPoint("BOTTOMLEFT", CUI_GuildInstanceDifficulty, "BOTTOMLEFT", 8, 7)
	local CUI_GuildInstanceDifficultyText = CUI_GuildInstanceDifficulty:CreateFontString("CUI_GuildInstanceDifficultyText", "ARTWORK", "GameFontNormalSmall")
	CUI_GuildInstanceDifficultyText:SetJustifyH("CENTER")
	CUI_GuildInstanceDifficultyText:SetJustifyV("MIDDLE")
	CUI_GuildInstanceDifficultyText:SetPoint("BOTTOMLEFT", CUI_GuildInstanceDifficulty, "BOTTOMLEFT", 20, 8)
	CUI_GuildInstanceDifficultyText:SetText("25")
	local CUI_GuildInstanceDifficultyHanger = CUI_GuildInstanceDifficulty:CreateTexture("CUI_GuildInstanceDifficultyHanger", "OVERLAY")
	CUI_GuildInstanceDifficultyHanger:SetSize(39, 16)
	CUI_GuildInstanceDifficultyHanger:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	CUI_GuildInstanceDifficultyHanger:SetTexCoord(0.6796875, 0.984375, 0.375, 0.625)
	CUI_GuildInstanceDifficultyHanger:SetPoint("TOPLEFT", CUI_GuildInstanceDifficulty, "TOPLEFT", 0, 0)
	
	local CUI_MiniMapChallengeMode = CreateFrame("Frame", "CUI_MiniMapChallengeMode", MinimapCluster)
	CUI_MiniMapChallengeMode:SetFrameStrata("LOW")
	CUI_MiniMapChallengeMode:SetFrameLevel(11)
	CUI_MiniMapChallengeMode:SetSize(27, 36)
	CUI_MiniMapChallengeMode:SetPoint("TOPLEFT", MinimapCluster, "TOPLEFT", 28, -23)
	CUI_MiniMapChallengeMode:Hide()
	local CUI_MiniMapChallengeModeTexture = CUI_MiniMapChallengeMode:CreateTexture("CUI_MiniMapChallengeModeTexture", "BACKGROUND")
	CUI_MiniMapChallengeModeTexture:SetSize(64, 46)
	CUI_MiniMapChallengeModeTexture:SetTexture("Interface\\Challenges\\challenges-minimap-banner")
	CUI_MiniMapChallengeModeTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	CUI_MiniMapChallengeModeTexture:SetPoint("CENTER", CUI_MiniMapChallengeMode, "CENTER", 0, 0)
	
	CUI_MiniMapInstanceDifficulty:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
	CUI_MiniMapInstanceDifficulty:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED")
	CUI_MiniMapInstanceDifficulty:RegisterEvent("UPDATE_INSTANCE_INFO")
	CUI_MiniMapInstanceDifficulty:RegisterEvent("PLAYER_GUILD_UPDATE")
	CUI_MiniMapInstanceDifficulty:RegisterEvent("GUILD_PARTY_STATE_UPDATED")
	
	function CUI_MiniMapInstanceDifficulty:MiniMapInstanceDifficulty_Update()
		local _, instanceType, difficulty, _, maxPlayers, playerDifficulty, isDynamicInstance, _, instanceGroupSize = GetInstanceInfo()
		local _, _, isHeroic, isChallengeMode, displayHeroic, displayMythic = GetDifficultyInfo(difficulty)
		if ( self.isGuildGroup ) then
			if ( instanceGroupSize == 0 ) then
				CUI_GuildInstanceDifficultyText:SetText("")
				CUI_GuildInstanceDifficultyDarkBackground:SetAlpha(0)
				CUI_GuildInstanceDifficulty.emblem:SetPoint("TOPLEFT", 12, -16)
			else
				CUI_GuildInstanceDifficultyText:SetText(instanceGroupSize)
				CUI_GuildInstanceDifficultyDarkBackground:SetAlpha(0.7)
				CUI_GuildInstanceDifficulty.emblem:SetPoint("TOPLEFT", 12, -10)
			end
			CUI_GuildInstanceDifficultyText:ClearAllPoints()
			if ( isHeroic or isChallengeMode or displayMythic or displayHeroic ) then
				local symbolTexture
				if ( isChallengeMode ) then
					symbolTexture = CUI_GuildInstanceDifficultyChallengeModeTexture
					CUI_GuildInstanceDifficultyHeroicTexture:Hide()
					CUI_GuildInstanceDifficultyMythicTexture:Hide()
				elseif ( displayMythic ) then
					symbolTexture = CUI_GuildInstanceDifficultyMythicTexture
					CUI_GuildInstanceDifficultyHeroicTexture:Hide()
					CUI_GuildInstanceDifficultyChallengeModeTexture:Hide()
				else
					symbolTexture = CUI_GuildInstanceDifficultyHeroicTexture
					CUI_GuildInstanceDifficultyChallengeModeTexture:Hide()
					CUI_GuildInstanceDifficultyMythicTexture:Hide()
				end
				if ( instanceGroupSize < 10 ) then
					symbolTexture:SetPoint("BOTTOMLEFT", 11, 7)
					CUI_GuildInstanceDifficultyText:SetPoint("BOTTOMLEFT", 23, 8)
				elseif ( instanceGroupSize > 19 ) then
					symbolTexture:SetPoint("BOTTOMLEFT", 8, 7)
					CUI_GuildInstanceDifficultyText:SetPoint("BOTTOMLEFT", 20, 8)
				else
					symbolTexture:SetPoint("BOTTOMLEFT", 8, 7)
					CUI_GuildInstanceDifficultyText:SetPoint("BOTTOMLEFT", 19, 8)
				end
				symbolTexture:Show()
			else
				CUI_GuildInstanceDifficultyHeroicTexture:Hide()
				CUI_GuildInstanceDifficultyChallengeModeTexture:Hide()
				CUI_GuildInstanceDifficultyMythicTexture:Hide()
				CUI_GuildInstanceDifficultyText:SetPoint("BOTTOM", 2, 8)
			end
			self:Hide()
			SetSmallGuildTabardTextures("player", CUI_GuildInstanceDifficulty.emblem, CUI_GuildInstanceDifficulty.background, CUI_GuildInstanceDifficulty.border)
			CUI_GuildInstanceDifficulty:Show()
			CUI_MiniMapChallengeMode:Hide()
		elseif ( isChallengeMode ) then
			CUI_MiniMapChallengeMode:Show()
			self:Hide()
			CUI_GuildInstanceDifficulty:Hide()
		elseif ( instanceType == "raid" or isHeroic or displayMythic or displayHeroic ) then
			CUI_MiniMapInstanceDifficultyText:SetText(instanceGroupSize)
			local xOffset = 0
			if ( instanceGroupSize >= 10 and instanceGroupSize <= 19 ) then
				xOffset = -1
			end
			if ( displayMythic ) then
				CUI_MiniMapInstanceDifficultyTexture:SetTexCoord(0.25, 0.5, 0.0703125, 0.4296875)
				CUI_MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, -9)
			elseif ( isHeroic or displayHeroic ) then
				CUI_MiniMapInstanceDifficultyTexture:SetTexCoord(0, 0.25, 0.0703125, 0.4296875)
				CUI_MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, -9)
			else
				CUI_MiniMapInstanceDifficultyTexture:SetTexCoord(0, 0.25, 0.5703125, 0.9296875)
				CUI_MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, 5)
			end
			self:Show()
			CUI_GuildInstanceDifficulty:Hide()
			CUI_MiniMapChallengeMode:Hide()
		else
			self:Hide()
			CUI_GuildInstanceDifficulty:Hide()
			CUI_MiniMapChallengeMode:Hide()
		end
	end
	CUI_MiniMapInstanceDifficulty:SetScript("OnEvent", function(self, event, ...)
		if ( event == "GUILD_PARTY_STATE_UPDATED" ) then
			local isGuildGroup = ...
			if ( isGuildGroup ~= self.isGuildGroup ) then
				self.isGuildGroup = isGuildGroup
				self:MiniMapInstanceDifficulty_Update()
			end
		elseif ( event == "PLAYER_DIFFICULTY_CHANGED") then
			self:MiniMapInstanceDifficulty_Update()
		elseif ( event == "UPDATE_INSTANCE_INFO" or event == "INSTANCE_GROUP_SIZE_CHANGED" ) then
			self:MiniMapInstanceDifficulty_Update()
		elseif ( event == "PLAYER_GUILD_UPDATE" ) then
			local tabard = CUI_GuildInstanceDifficulty
			SetSmallGuildTabardTextures("player", tabard.emblem, tabard.background, tabard.border)
			if not( IsInGuild() ) then
				self.isGuildGroup = nil
				self:MiniMapInstanceDifficulty_Update()
			end
		end
	end)
	CUI_MiniMapInstanceDifficulty:SetScript("OnEnter", function(self)
		local _, instanceType, difficulty, _, maxPlayers, playerDifficulty, isDynamicInstance, _, instanceGroupSize, lfgID = GetInstanceInfo()
		local isLFR = select(8, GetDifficultyInfo(difficulty))
		if (isLFR and lfgID) then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", 8, 8)
			local name = GetLFGDungeonInfo(lfgID)
			GameTooltip:SetText(RAID_FINDER, 1, 1, 1)
			GameTooltip:AddLine(name)
			GameTooltip:Show()
		end
	end)
	CUI_MiniMapInstanceDifficulty:SetScript("OnLeave", GameTooltip_Hide)
	
	CUI_GuildInstanceDifficulty:SetScript("OnEnter", function(self)
		local guildName = GetGuildInfo("player")
		local _, instanceType, _, _, maxPlayers = GetInstanceInfo()
		local _, numGuildPresent, numGuildRequired, xpMultiplier = InGuildParty()
		if ( instanceType == "arena" ) then
			maxPlayers = numGuildRequired
		end
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", 8, 8)
		GameTooltip:SetText(GUILD_GROUP, 1, 1, 1)
		if ( xpMultiplier < 1 ) then
			GameTooltip:AddLine(strformat(GUILD_ACHIEVEMENTS_ELIGIBLE_MINXP, numGuildRequired, maxPlayers, guildName, xpMultiplier * 100), nil, nil, nil, true)
		elseif ( xpMultiplier > 1 ) then
			GameTooltip:AddLine(strformat(GUILD_ACHIEVEMENTS_ELIGIBLE_MAXXP, guildName, xpMultiplier * 100), nil, nil, nil, true)
		else
			if ( instanceType == "party" and maxPlayers == 5 ) then
				numGuildRequired = 4
			end
			GameTooltip:AddLine(strformat(GUILD_ACHIEVEMENTS_ELIGIBLE, numGuildRequired, maxPlayers, guildName), nil, nil, nil, true)
		end
		GameTooltip:Show()
	end)
	CUI_GuildInstanceDifficulty:SetScript("OnLeave", GameTooltip_Hide)
	
	hooksecurefunc(MinimapCluster, "SetHeaderUnderneath", function(self, headerUnderneath)
		self.Minimap:ClearAllPoints()
		self.Minimap:SetPoint("CENTER", self, "TOP", 9, -92)
		self.BorderTop:ClearAllPoints()
		self.BorderTop:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
		self.MailFrame:ClearAllPoints()
		self.MailFrame:SetPoint("TOPRIGHT", self.Minimap, "TOPRIGHT", 24, -37)
	end)
	
	CreateFrame("Button", "MinimapZoneTextButton", MinimapCluster)
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint("CENTER", MinimapCluster, "CENTER", 0, 83)
	MinimapZoneTextButton:SetSize(140, 12)
	MinimapZoneTextButton:SetFrameStrata("LOW")
	MinimapZoneTextButton:SetFrameLevel(2)
	MinimapZoneText:SetParent(MinimapZoneTextButton)
	MinimapZoneText:ClearAllPoints()
	MinimapZoneText:SetPoint("CENTER", MinimapZoneTextButton, "TOP", 0, -6)
	MinimapZoneText:SetSize(140, 12)
	MinimapZoneText:SetDrawLayer("BACKGROUND")
	MinimapZoneText:SetJustifyH("CENTER")
	MinimapBackdrop:CreateTexture("MinimapBorderTop", "ARTWORK")
	MinimapBorderTop:ClearAllPoints()
	MinimapBorderTop:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", ClassicUI.db.profile.extraFrames.Minimap.xOffset, ClassicUI.db.profile.extraFrames.Minimap.yOffset)
	MinimapBorderTop:SetTexture("Interface\\Minimap\\UI-Minimap-Border")
	MinimapBorderTop:SetTexCoord(0.25, 0, 0.25, 0.125, 1, 0, 1, 0.125)
	MinimapBorderTop:SetSize(192, 32)
	MinimapBorderTop:SetDrawLayer("ARTWORK", 0)
	MinimapCluster.BorderTop.BottomEdge:Hide()
	MinimapCluster.BorderTop.Center:Hide()
	MinimapCluster.BorderTop.TopEdge:Hide()
	MinimapCluster.BorderTop.LeftEdge:Hide()
	MinimapCluster.BorderTop.RightEdge:Hide()
	MinimapCluster.BorderTop.BottomLeftCorner:Hide()
	MinimapCluster.BorderTop.TopLeftCorner:Hide()
	MinimapCluster.BorderTop.BottomRightCorner:Hide()
	MinimapCluster.BorderTop.TopRightCorner:Hide()
	
	MiniMapWorldMapButton = MinimapCluster.ZoneTextButton
	MiniMapWorldMapButton:ClearAllPoints()
	MiniMapWorldMapButton:SetPoint("TOPRIGHT", MinimapBackdrop, "TOPRIGHT", -2, 23)
	MiniMapWorldMapButton:SetSize(32, 32)
	MiniMapWorldMapButton:SetFrameStrata("LOW")
	MiniMapWorldMapButton:SetFrameLevel(4)
	MiniMapWorldMapButton:SetNormalTexture("Interface\\Minimap\\UI-Minimap-WorldMapSquare")
	MiniMapWorldMapButton:GetNormalTexture():SetSize(32, 32)
	MiniMapWorldMapButton:GetNormalTexture():SetTexCoord(0.0, 1, 0, 0.5)
	MiniMapWorldMapButton:SetPushedTexture("Interface\\Minimap\\UI-Minimap-WorldMapSquare")
	MiniMapWorldMapButton:GetPushedTexture():SetSize(32, 32)
	MiniMapWorldMapButton:GetPushedTexture():SetTexCoord(0.0, 1, 0.5, 1)
	MiniMapWorldMapButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	MiniMapWorldMapButton:GetHighlightTexture():SetSize(28, 28)
	MiniMapWorldMapButton:GetHighlightTexture():ClearAllPoints()
	MiniMapWorldMapButton:GetHighlightTexture():SetPoint("TOPRIGHT", MiniMapWorldMapButton, "TOPRIGHT", 2, -2)
	
	ClassicUI.Minimap_SetTooltip = function(pvpType, factionName)
		if (GameTooltip:IsOwned(MinimapZoneTextButton)) then
			GameTooltip:SetOwner(MinimapZoneTextButton, "ANCHOR_LEFT")
			local zoneName = GetZoneText()
			local subzoneName = GetSubZoneText()
			if (subzoneName == zoneName) then
				subzoneName = ""
			end
			GameTooltip:AddLine(zoneName, 1.0, 1.0, 1.0)
			if (pvpType == "sanctuary") then
				GameTooltip:AddLine(subzoneName, 0.41, 0.8, 0.94)
				GameTooltip:AddLine(SANCTUARY_TERRITORY, 0.41, 0.8, 0.94)
			elseif (pvpType == "arena") then
				GameTooltip:AddLine(subzoneName, 1.0, 0.1, 0.1)
				GameTooltip:AddLine(FREE_FOR_ALL_TERRITORY, 1.0, 0.1, 0.1)
			elseif (pvpType == "friendly") then
				if (factionName and factionName ~= "") then
					GameTooltip:AddLine(subzoneName, 0.1, 1.0, 0.1)
					GameTooltip:AddLine(format(FACTION_CONTROLLED_TERRITORY, factionName), 0.1, 1.0, 0.1)
				end
			elseif (pvpType == "hostile") then
				if (factionName and factionName ~= "") then
					GameTooltip:AddLine(subzoneName, 1.0, 0.1, 0.1)
					GameTooltip:AddLine(format(FACTION_CONTROLLED_TERRITORY, factionName), 1.0, 0.1, 0.1)
				end
			elseif (pvpType == "contested") then
				GameTooltip:AddLine(subzoneName, 1.0, 0.7, 0.0)
				GameTooltip:AddLine(CONTESTED_TERRITORY, 1.0, 0.7, 0.0)
			elseif (pvpType == "combat") then
				GameTooltip:AddLine(subzoneName, 1.0, 0.1, 0.1 )
				GameTooltip:AddLine(COMBAT_ZONE, 1.0, 0.1, 0.1)
			else
				GameTooltip:AddLine(subzoneName, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			end
			GameTooltip:Show()
		end
	end
	hooksecurefunc("Minimap_SetTooltip", ClassicUI.Minimap_SetTooltip)
	MinimapZoneTextButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		local pvpType, _, factionName = GetZonePVPInfo()
		ClassicUI.Minimap_SetTooltip(pvpType, factionName)
		GameTooltip:Show()
	end)
	MinimapZoneTextButton:SetScript("OnLeave", function(self)
		GameTooltip_Hide()
	end)
	
	MiniMapWorldMapButton.tooltipText = MicroButtonTooltipText(WORLDMAP_BUTTON, "TOGGLEWORLDMAP")
	MiniMapWorldMapButton.newbieText = NEWBIE_TOOLTIP_WORLDMAP
	MiniMapWorldMapButton:RegisterEvent("UPDATE_BINDINGS")
	MiniMapWorldMapButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip_SetTitle(GameTooltip, self.tooltipText)
		GameTooltip:Show()
	end)
	MiniMapWorldMapButton:SetScript("OnLeave", GameTooltip_Hide)
	MiniMapWorldMapButton:SetScript("OnEvent", function(self)
		self.tooltipText = MicroButtonTooltipText(WORLDMAP_BUTTON, "TOGGLEWORLDMAP")
		self.newbieText = NEWBIE_TOOLTIP_WORLDMAP
	end)
end

-- Function that executes functionalities of the 'MainFunction' function that need to be executed after the first "PLAYER_ENTERING_WORLD" event
function ClassicUI:MF_PLAYER_ENTERING_WORLD()
	ClassicUI:SetStrataForMainFrames()
	
	-- [QueueStatusButton]
	if (ClassicUI.db.profile.extraFrames.Minimap.anchorQueueButtonToMinimap) then
		QueueStatusButton:SetParent(MinimapBackdrop)
		QueueStatusButton:SetFrameStrata("LOW")
		QueueStatusButton:SetFrameLevel(5)
		if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
			QueueStatusButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 22 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, -100 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
		else
			QueueStatusButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", -7 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, -135 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
		end
	else
		QueueStatusButton:SetParent(UIParent)
		QueueStatusButton:SetFrameStrata("MEDIUM")
		QueueStatusButton:SetFrameLevel(53)
		QueueStatusButton:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -45 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, 4 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
	end
	
	--[StatusBars]
	StatusTrackingBarManager:SetParent(CUI_MainMenuBar)
	StatusTrackingBarManager:ClearAllPoints()
	StatusTrackingBarManager:SetPoint("BOTTOM", CUI_MainMenuBar, "BOTTOM", 0, 0)
	StatusTrackingBarManager:SetSize(804, 11)
	StatusTrackingBarManager.TopBarFrameTexture:SetSize(1024, 7)
	StatusTrackingBarManager.TopBarFrameTexture:ClearAllPoints()
	StatusTrackingBarManager.TopBarFrameTexture:SetPoint("BOTTOM", CUI_MainMenuBar, "TOP", 0, -3)
	StatusTrackingBarManager.BottomBarFrameTexture:SetSize(1024, 10)
	StatusTrackingBarManager.BottomBarFrameTexture:ClearAllPoints()
	StatusTrackingBarManager.BottomBarFrameTexture:SetPoint("TOP", CUI_MainMenuBar, "TOP", 0, 0)
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_TopBarFrameTexture0", "ARTWORK")
	StatusTrackingBarManager.TopBarFrameTexture0 = StatusTrackingBarManager_TopBarFrameTexture0
	StatusTrackingBarManager.TopBarFrameTexture0:ClearAllPoints()
	StatusTrackingBarManager.TopBarFrameTexture0:SetPoint("BOTTOMLEFT", CUI_MainMenuBar, "TOPLEFT", 0, -1)
	StatusTrackingBarManager.TopBarFrameTexture0:SetTexture("Interface/PaperDollInfoFrame/UI-ReputationWatchBar")
	StatusTrackingBarManager.TopBarFrameTexture0:SetTexCoord(0/256, 0/256, 0/256, 44/256, 256/256, 0/256, 256/256, 44/256)
	StatusTrackingBarManager.TopBarFrameTexture0:SetSize(256, 11)
	StatusTrackingBarManager.TopBarFrameTexture0:SetDrawLayer("ARTWORK", 0)
	StatusTrackingBarManager.TopBarFrameTexture0:Hide()
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_TopBarFrameTexture1", "ARTWORK")
	StatusTrackingBarManager.TopBarFrameTexture1 = StatusTrackingBarManager_TopBarFrameTexture1
	StatusTrackingBarManager.TopBarFrameTexture1:ClearAllPoints()
	StatusTrackingBarManager.TopBarFrameTexture1:SetPoint("LEFT", StatusTrackingBarManager.TopBarFrameTexture0, "RIGHT", 0, 0)
	StatusTrackingBarManager.TopBarFrameTexture1:SetTexture("Interface/PaperDollInfoFrame/UI-ReputationWatchBar")
	StatusTrackingBarManager.TopBarFrameTexture1:SetTexCoord(0/256, 48/256, 0/256, 92/256, 256/256, 48/256, 256/256, 92/256)
	StatusTrackingBarManager.TopBarFrameTexture1:SetSize(256, 11)
	StatusTrackingBarManager.TopBarFrameTexture1:SetDrawLayer("ARTWORK", 0)
	StatusTrackingBarManager.TopBarFrameTexture1:Hide()
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_TopBarFrameTexture2", "ARTWORK")
	StatusTrackingBarManager.TopBarFrameTexture2 = StatusTrackingBarManager_TopBarFrameTexture2
	StatusTrackingBarManager.TopBarFrameTexture2:ClearAllPoints()
	StatusTrackingBarManager.TopBarFrameTexture2:SetPoint("LEFT", StatusTrackingBarManager.TopBarFrameTexture1, "RIGHT", 0, 0)
	StatusTrackingBarManager.TopBarFrameTexture2:SetTexture("Interface/PaperDollInfoFrame/UI-ReputationWatchBar")
	StatusTrackingBarManager.TopBarFrameTexture2:SetTexCoord(0/256, 96/256, 0/256, 140/256, 256/256, 96/256, 256/256, 140/256)
	StatusTrackingBarManager.TopBarFrameTexture2:SetSize(256, 11)
	StatusTrackingBarManager.TopBarFrameTexture2:SetDrawLayer("ARTWORK", 0)
	StatusTrackingBarManager.TopBarFrameTexture2:Hide()
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_TopBarFrameTexture3", "ARTWORK")
	StatusTrackingBarManager.TopBarFrameTexture3 = StatusTrackingBarManager_TopBarFrameTexture3
	StatusTrackingBarManager.TopBarFrameTexture3:ClearAllPoints()
	StatusTrackingBarManager.TopBarFrameTexture3:SetPoint("LEFT", StatusTrackingBarManager.TopBarFrameTexture2, "RIGHT", 0, 0)
	StatusTrackingBarManager.TopBarFrameTexture3:SetTexture("Interface/PaperDollInfoFrame/UI-ReputationWatchBar")
	StatusTrackingBarManager.TopBarFrameTexture3:SetTexCoord(0/256, 144/256, 0/256, 188/256, 256/256, 144/256, 256/256, 188/256)
	StatusTrackingBarManager.TopBarFrameTexture3:SetSize(256, 11)
	StatusTrackingBarManager.TopBarFrameTexture3:SetDrawLayer("ARTWORK", 0)
	StatusTrackingBarManager.TopBarFrameTexture3:Hide()
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_BottomBarFrameTexture0", "ARTWORK")
	StatusTrackingBarManager.BottomBarFrameTexture0 = StatusTrackingBarManager_BottomBarFrameTexture0
	StatusTrackingBarManager.BottomBarFrameTexture0:ClearAllPoints()
	StatusTrackingBarManager.BottomBarFrameTexture0:SetPoint("TOPLEFT", CUI_MainMenuBar, "TOPLEFT", 0, 0)
	StatusTrackingBarManager.BottomBarFrameTexture0:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
	StatusTrackingBarManager.BottomBarFrameTexture0:SetTexCoord(0/256, 203/256, 0/256, 213/256, 256/256, 203/256, 256/256, 213/256)
	StatusTrackingBarManager.BottomBarFrameTexture0:SetSize(256, 10)
	StatusTrackingBarManager.BottomBarFrameTexture0:SetDrawLayer("ARTWORK", 0)
	StatusTrackingBarManager.BottomBarFrameTexture0:Hide()
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_BottomBarFrameTexture1", "ARTWORK")
	StatusTrackingBarManager.BottomBarFrameTexture1 = StatusTrackingBarManager_BottomBarFrameTexture1
	StatusTrackingBarManager.BottomBarFrameTexture1:ClearAllPoints()
	StatusTrackingBarManager.BottomBarFrameTexture1:SetPoint("LEFT", StatusTrackingBarManager.BottomBarFrameTexture0, "RIGHT", 0, 0)
	StatusTrackingBarManager.BottomBarFrameTexture1:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
	StatusTrackingBarManager.BottomBarFrameTexture1:SetTexCoord(0/256, 139/256, 0/256, 149/256, 256/256, 139/256, 256/256, 149/256)
	StatusTrackingBarManager.BottomBarFrameTexture1:SetSize(256, 10)
	StatusTrackingBarManager.BottomBarFrameTexture1:SetDrawLayer("ARTWORK", 0)
	StatusTrackingBarManager.BottomBarFrameTexture1:Hide()
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_BottomBarFrameTexture2", "ARTWORK")
	StatusTrackingBarManager.BottomBarFrameTexture2 = StatusTrackingBarManager_BottomBarFrameTexture2
	StatusTrackingBarManager.BottomBarFrameTexture2:ClearAllPoints()
	StatusTrackingBarManager.BottomBarFrameTexture2:SetPoint("LEFT", StatusTrackingBarManager.BottomBarFrameTexture1, "RIGHT", 0, 0)
	StatusTrackingBarManager.BottomBarFrameTexture2:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
	StatusTrackingBarManager.BottomBarFrameTexture2:SetTexCoord(0/256, 75/256, 0/256, 85/256, 256/256, 75/256, 256/256, 85/256)
	StatusTrackingBarManager.BottomBarFrameTexture2:SetSize(256, 10)
	StatusTrackingBarManager.BottomBarFrameTexture2:SetDrawLayer("ARTWORK", 0)
	StatusTrackingBarManager.BottomBarFrameTexture2:Hide()
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_BottomBarFrameTexture3", "ARTWORK")
	StatusTrackingBarManager.BottomBarFrameTexture3 = StatusTrackingBarManager_BottomBarFrameTexture3
	StatusTrackingBarManager.BottomBarFrameTexture3:ClearAllPoints()
	StatusTrackingBarManager.BottomBarFrameTexture3:SetPoint("LEFT", StatusTrackingBarManager.BottomBarFrameTexture2, "RIGHT", 0, 0)
	StatusTrackingBarManager.BottomBarFrameTexture3:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
	StatusTrackingBarManager.BottomBarFrameTexture3:SetTexCoord(0/256, 11/256, 0/256, 21/256, 256/256, 11/256, 256/256, 21/256)
	StatusTrackingBarManager.BottomBarFrameTexture3:SetSize(256, 10)
	StatusTrackingBarManager.BottomBarFrameTexture3:SetDrawLayer("ARTWORK", 0)
	StatusTrackingBarManager.BottomBarFrameTexture3:Hide()

	StatusTrackingBarManager:SetFrameStrata("MEDIUM")
	StatusTrackingBarManager:SetFrameLevel(2)
	for _, bar in ipairs(StatusTrackingBarManager.bars) do
		bar.StatusBar.Background:SetColorTexture(0, 0, 0, 1.0)
		bar.StatusBar.Background:SetAlpha(0.5)
		bar:SetFrameStrata("LOW")
		bar:SetFrameLevel(2)
		bar.StatusBar:SetFrameStrata("LOW")
		bar.StatusBar:SetFrameLevel(1)
		if (bar.priority == 0 or bar.priority == 4) then	-- AzeriteBar (priority = 0) or ArtifactBar (priority = 4)
			bar:SetBarColor(ARTIFACT_BAR_COLOR:GetRGB())
		elseif (bar.priority == 2) then						-- HonorBar (priority = 2)
			if not ClassicUI.hooked_honorBar then
				hooksecurefunc(bar, "Update", function(self)
					self.StatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar", "BORDER")
					self.StatusBar:GetStatusBarTexture():SetDrawLayer("BORDER", 0)
					self.StatusBar:GetStatusBarTexture():SetTexCoord(0, 0, 0, 1, 0.16666667, 0, 0.16666667, 1)
					self:SetBarColor(1.0, 0.24, 0)
				end)
				ClassicUI.hooked_honorBar = true
			end
			bar:SetBarColor(1.0, 0.24, 0)
		elseif (bar.priority == 1) then						-- ReputationBar (priority = 1)
			if not ClassicUI.hooked_repBar then
				hooksecurefunc(bar, "Update", function(self)
					local _, colorIndex, _, _, _, factionID = GetWatchedFactionInfo()
					if not(C_Reputation_IsFactionParagon(factionID)) then
						local friendshipID = C_GossipInfo_GetFriendshipReputation(factionID)
						if (friendshipID) then
							colorIndex = 5
						end
					end
					local color = FACTION_BAR_COLORS[colorIndex]
					self.StatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar", "BORDER")
					self.StatusBar:GetStatusBarTexture():SetDrawLayer("BORDER", 0)
					self.StatusBar:GetStatusBarTexture():SetTexCoord(0, 0, 0, 1, 0.16666667, 0, 0.16666667, 1)
					self:SetBarColor(color.r, color.g, color.b, 1)
				end)
				ClassicUI.hooked_repBar = true
			end
			local _, colorIndex, _, _, _, factionID = GetWatchedFactionInfo()
			if not(C_Reputation_IsFactionParagon(factionID)) then
				local friendshipID = C_GossipInfo_GetFriendshipReputation(factionID)
				if (friendshipID) then
					colorIndex = 5
				end
			end
			local color = FACTION_BAR_COLORS[colorIndex]
			if (color ~= nil) then
				bar:SetBarColor(color.r, color.g, color.b, 1)
			end
		elseif (bar.priority == 3) then						-- ExpBar (priority = 3)
			if not ClassicUI.hooked_expBar then
				hooksecurefunc(bar, "Update", function(self)
					if (GameLimitedMode_IsActive()) then
						local rLevel = GetRestrictedAccountData()
						if UnitLevel("player") >= rLevel then
							self.StatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar", "BORDER")
							self.StatusBar:GetStatusBarTexture():SetDrawLayer("BORDER", 0)
							self.StatusBar:GetStatusBarTexture():SetTexCoord(0, 0, 0, 1, 0.16666667, 0, 0.16666667, 1)
							self:SetBarColor(0.58, 0.0, 0.55, 1.0)
						end
					end
				end)
				hooksecurefunc(bar.ExhaustionTick, "UpdateTickPosition", function(self)
					local playerCurrXP = UnitXP("player")
					local playerMaxXP = UnitXPMax("player")
					local exhaustionThreshold = GetXPExhaustion()
					local exhaustionStateID = GetRestState()
					if (exhaustionStateID and exhaustionStateID >= 3) then
						self:SetPoint("CENTER", self:GetParent() , "RIGHT", 0, 0)
					end
					if (not exhaustionThreshold) then
						self:GetParent().ExhaustionLevelFillBar:Hide()
					else
						local exhaustionTickSet = mathmax(((playerCurrXP + exhaustionThreshold) / playerMaxXP) * (self:GetParent():GetWidth()), 0)
						self:GetParent().ExhaustionLevelFillBar:Show()
						if (exhaustionTickSet > bar:GetWidth()) then
							self:Hide()
							if ClassicUI.cached_db_profile.barsConfig_SingleStatusBar_expBarAlwaysShowRestedBar then	-- cached db value
								self:GetParent().ExhaustionLevelFillBar:SetPoint("TOPRIGHT", bar, "TOPLEFT", bar:GetWidth(), 0)
								self:GetParent().ExhaustionLevelFillBar:Show()
							else
								self:GetParent().ExhaustionLevelFillBar:Hide()
							end
						else
							self:Show()
							self:SetPoint("CENTER", self:GetParent(), "LEFT", exhaustionTickSet, -1)
							self:GetParent().ExhaustionLevelFillBar:Show()
							self:GetParent().ExhaustionLevelFillBar:SetPoint("TOPRIGHT", bar, "TOPLEFT", exhaustionTickSet, 0)
							self:GetParent().ExhaustionLevelFillBar:SetWidth(0)
						end
					end
					if (exhaustionStateID == 1) then
						self:GetParent():SetBarColor(0.0, 0.39, 0.88, 1.0)
						self:GetParent().ExhaustionLevelFillBar:SetVertexColor(0.0, 0.39, 0.88, 0.15)
						self.Highlight:SetVertexColor(0.0, 0.39, 0.88)
					else
						self:GetParent():SetBarColor(0.58, 0.0, 0.55, 1.0)
						self:GetParent().ExhaustionLevelFillBar:SetVertexColor(0.58, 0.0, 0.55, 0.15)
						self.Highlight:SetVertexColor(0.58, 0.0, 0.55)
					end
				end)
				hooksecurefunc(bar.ExhaustionTick, "UpdateExhaustionColor", function(self)
					local exhaustionStateID = GetRestState()
					self:GetParent().StatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar", "BORDER")
					self:GetParent().StatusBar:GetStatusBarTexture():SetDrawLayer("BORDER", 0)
					self:GetParent().StatusBar:GetStatusBarTexture():SetTexCoord(0, 0, 0, 1, 0.16666667, 0, 0.16666667, 1)
					if (exhaustionStateID == 1) then
						self:GetParent():SetBarColor(0.0, 0.39, 0.88, 1.0)
						self:GetParent().ExhaustionLevelFillBar:SetVertexColor(0.0, 0.39, 0.88, 0.15)
						self.Highlight:SetVertexColor(0.0, 0.39, 0.88)
					else
						self:GetParent():SetBarColor(0.58, 0.0, 0.55, 1.0)
						self:GetParent().ExhaustionLevelFillBar:SetVertexColor(0.58, 0.0, 0.55, 0.15)
						self.Highlight:SetVertexColor(0.58, 0.0, 0.55)
					end
				end)
				bar.ExhaustionTick:HookScript("OnEvent", function(self)
					if (IsRestrictedAccount()) then
						local rlevel = GetRestrictedAccountData()
						if (UnitLevel("player") >= rlevel) then
							self:GetParent().StatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar", "BORDER")
							self:GetParent().StatusBar:GetStatusBarTexture():SetDrawLayer("BORDER", 0)
							self:GetParent().StatusBar:GetStatusBarTexture():SetTexCoord(0, 0, 0, 1, 0.16666667, 0, 0.16666667, 1)
							self:GetParent():SetBarColor(0.0, 0.39, 0.88, 1.0)
						end
					end
				end)
				ClassicUI.hooked_expBar = true
			end
			
			bar.ExhaustionTick:SetSize(32, 32)
			bar.ExhaustionTick:GetNormalTexture():SetAtlas(nil)
			bar.ExhaustionTick:SetNormalTexture("Interface\\MainMenuBar\\UI-ExhaustionTickNormal")
			bar.ExhaustionTick:GetHighlightTexture():SetAtlas(nil)
			bar.ExhaustionTick:SetHighlightTexture("Interface\\MainMenuBar\\UI-ExhaustionTickHighlight", "ADD")
			
			bar.ExhaustionLevelFillBar:SetAtlas(nil)
			bar.ExhaustionLevelFillBar:SetColorTexture(1.0, 1.0, 1.0, 1.0)
			bar.ExhaustionLevelFillBar:SetSize(0, 8)
			bar.ExhaustionLevelFillBar:ClearAllPoints()
			bar.ExhaustionLevelFillBar:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
			
			local playerCurrXP = UnitXP("player")
			local playerMaxXP = UnitXPMax("player")
			local exhaustionThreshold = GetXPExhaustion()
			local exhaustionStateID = GetRestState()
			if (exhaustionStateID and exhaustionStateID >= 3) then
				bar.ExhaustionTick:SetPoint("CENTER", bar.ExhaustionTick:GetParent() , "RIGHT", 0, 0)
			end
			if (not exhaustionThreshold) then
				bar.ExhaustionLevelFillBar:Hide()
			else
				local exhaustionTickSet = mathmax(((playerCurrXP + exhaustionThreshold) / playerMaxXP) * (bar:GetWidth()), 0)
				bar.ExhaustionLevelFillBar:Show()
				if (exhaustionTickSet > bar:GetWidth()) then
					bar.ExhaustionTick:Hide()
					if ClassicUI.cached_db_profile.barsConfig_SingleStatusBar_expBarAlwaysShowRestedBar then	-- cached db value
						bar.ExhaustionLevelFillBar:SetPoint("TOPRIGHT", bar, "TOPLEFT", bar:GetWidth(), 0)
						bar.ExhaustionLevelFillBar:Show()
					else
						bar.ExhaustionLevelFillBar:Hide()
					end
				else
					bar.ExhaustionTick:Show()
					bar.ExhaustionTick:SetPoint("CENTER", bar.ExhaustionTick:GetParent(), "LEFT", exhaustionTickSet, -1)
					bar.ExhaustionLevelFillBar:Show()
					bar.ExhaustionLevelFillBar:SetPoint("TOPRIGHT", bar, "TOPLEFT", exhaustionTickSet, 0)
					bar.ExhaustionLevelFillBar:SetWidth(0)
				end
			end
			if (exhaustionStateID == 1) then
				bar:SetBarColor(0.0, 0.39, 0.88, 1.0)
				bar.ExhaustionLevelFillBar:SetVertexColor(0.0, 0.39, 0.88, 0.15)
				bar.ExhaustionTick.Highlight:SetVertexColor(0.0, 0.39, 0.88)
			else
				bar:SetBarColor(0.58, 0.0, 0.55, 1.0)
				bar.ExhaustionLevelFillBar:SetVertexColor(0.58, 0.0, 0.55, 0.15)
				bar.ExhaustionTick.Highlight:SetVertexColor(0.58, 0.0, 0.55)
			end
		end
	end
	-- Hook this function to StatusTrackingBarManager:LayoutBar
	hooksecurefunc(StatusTrackingBarManager, "LayoutBar", ClassicUI.StatusTrackingBarManager_LayoutBar)
	hooksecurefunc(StatusTrackingBarManager, "HideStatusBars", function(self)
		self.TopBarFrameTexture0:Hide()
		self.TopBarFrameTexture1:Hide()
		self.TopBarFrameTexture2:Hide()
		self.TopBarFrameTexture3:Hide()
		self.BottomBarFrameTexture0:Hide()
		self.BottomBarFrameTexture1:Hide()
		self.BottomBarFrameTexture2:Hide()
		self.BottomBarFrameTexture3:Hide()
	end)
	
	-- Hooks to keep action bars updated with changes
	hooksecurefunc("MultiActionBar_Update", ClassicUI.UpdatedStatusBarsEvent)
	hooksecurefunc(StatusTrackingBarManager, "UpdateBarsShown", ClassicUI.UpdatedStatusBarsEvent)
	hooksecurefunc("ActionBarController_UpdateAll", ClassicUI.UpdatedStatusBarsEvent)
	
	-- Update frames after exit edit mode
	ClassicUI.onExitEditMode = function(self)
		ClassicUI:SetStrataForMainFrames()
		ClassicUI:ReloadMainFramesSettings()
		ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
		ClassicUI.UpdatedStatusBarsEvent()
	end
	
	if (EventRegistry and type(EventRegistry) == "table") then
		EventRegistry:RegisterCallback("EditMode.Exit", ClassicUI.onExitEditMode, ClassicUI)
	end
	
	ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
	ClassicUI.UpdatedStatusBarsEvent()
end

-- Function to manage the PLAYER_ENTERING_WORLD event. Here we do modifications to interface elements that may not have been fully loaded before this event.
function ClassicUI:PLAYER_ENTERING_WORLD()
	ClassicUI.frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if (ClassicUI.OnEvent_PEW_mf) then
		ClassicUI.OnEvent_PEW_mf = false
		ClassicUI:MF_PLAYER_ENTERING_WORLD()
	end
	if (ClassicUI.OnEvent_PEW_eff) then
		ClassicUI.OnEvent_PEW_eff = false
		ClassicUI:EFF_PLAYER_ENTERING_WORLD()
	end
end

-- Function that handles a queue of pending functions that set the scale of combat-protected frames
function ClassicUI:BarHookProtectedApplySetScale()
	if InCombatLockdown() then
		delayFunc_BarHookProtectedApplySetScale = true
		if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
			fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		return
	end
	for iCUIframe, iInfo in pairs(self.queuePending_HookSetScale) do
		iCUIframe.hook_SetScale(iInfo[1], iInfo[2])
		self.queuePending_HookSetScale[iCUIframe] = nil
	end
end

-- Function that restores the Dragonflight layout of a specific ActionButton
ClassicUI.RestoreDragonflightLayoutActionButton = function(iActionButton, typeActionButton)
	local name = iActionButton:GetName()
	if (typeActionButton <= 2 or typeActionButton == 7) then
		iActionButton:SetSize(45, 45)
	else
		iActionButton:SetSize(30, 30)
	end
	local iabnt = iActionButton:GetNormalTexture()
	if (iabnt ~= nil) then
		iabnt:SetAtlas("UI-HUD-ActionBar-IconFrame-AddRow")
		iabnt:ClearAllPoints()
		iabnt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabnt:SetSize(51, 51)
		else
			iabnt:SetSize(35, 35)
		end
	end
	local iabpt = iActionButton:GetPushedTexture()
	if (iabpt ~= nil) then
		iabpt:SetAtlas("UI-HUD-ActionBar-IconFrame-AddRow-Down")
		iabpt:ClearAllPoints()
		iabpt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabpt:SetSize(51, 51)
		else
			iabpt:SetSize(35, 35)
		end
	end
	local iabht = iActionButton:GetHighlightTexture()
	if (iabht ~= nil) then
		iabht:SetAtlas("UI-HUD-ActionBar-IconFrame-Mouseover")
		iabht:SetBlendMode("BLEND")
		iabht:ClearAllPoints()
		iabht:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabht:SetSize(46, 45)
		else
			iabht:SetSize(31.6, 30.9)
		end
	end
	local iabchkt = iActionButton:GetCheckedTexture()
	if (iabchkt ~= nil) then
		iabchkt:SetAtlas("UI-HUD-ActionBar-IconFrame-Mouseover")
		iabchkt:SetBlendMode("BLEND")
		iabchkt:ClearAllPoints()
		iabchkt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabchkt:SetSize(46, 45)
		else
			iabchkt:SetSize(31.6, 30.9)
		end
	end
	local iabit = _G[name.."Icon"]
	if (iabit ~= nil) then
		if (typeActionButton == 6) then
			iabit:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		end
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabit:SetSize(45, 45)
		else
			iabit:SetSize(30, 30)
		end
	end
	local iabctt = _G[name.."Count"]
	if (iabctt ~= nil) then
		iabctt:ClearAllPoints()
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabctt:SetPoint("BOTTOMRIGHT", iActionButton, "BOTTOMRIGHT", -5, 5)
		else
			iabctt:SetPoint("BOTTOMRIGHT", iActionButton, "BOTTOMRIGHT", -3, 1)
		end
	end
	local iabbt = _G[name.."Border"]
	if (iabbt ~= nil) then
		iabbt:SetAtlas("UI-HUD-ActionBar-IconFrame-Border")
		iabbt:SetBlendMode("BLEND")
		if ((iActionButton.action ~= nil) and (IsEquippedAction(iActionButton.action))) then
			iabbt:SetAlpha(0.5)
		else
			iabbt:SetAlpha(1)
		end
		iabbt:ClearAllPoints()
		iabbt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabbt:SetSize(46, 45)
		else
			iabbt:SetSize(31.6, 30.9)
		end
	end
	local iabHt = _G[name.."HotKey"]
	if (iabHt ~= nil) then
		iabHt:ClearAllPoints()
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabHt:SetPoint("TOPRIGHT", iActionButton, "TOPRIGHT", -4, -5)
			iabHt:SetSize(37, 10)
		else
			iabHt:SetPoint("TOPRIGHT", iActionButton, "TOPRIGHT", -3, -4)
			iabHt:SetSize(32, 10)
		end
		local iabHt_f1, iabHt_f2, iabHt_f3 = iabHt:GetFont()
		if (iabHt_f3 ~= "OUTLINE") then
			iabHt:SetFont(iabHt_f1, iabHt_f2, "OUTLINE")
		end
	end
	local iabcdt = _G[name.."Cooldown"]
	if (iabcdt ~= nil) then
		iabcdt:ClearAllPoints()
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabcdt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 3, -3)
			iabcdt:SetPoint("BOTTOMRIGHT", iActionButton, "BOTTOMRIGHT", -3, 3)
			iabcdt:SetSize(39, 39)
		else
			iabcdt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 1.7, -1.7)
			iabcdt:SetPoint("BOTTOMRIGHT", iActionButton, "BOTTOMRIGHT", -1, 1)
			iabcdt:SetSize(27.3, 27.3)
		end
	end
	local iabft = _G[name.."Flash"]
	if (iabft ~= nil) then
		iabft:SetAtlas("UI-HUD-ActionBar-IconFrame-Flash")
		iabft:ClearAllPoints()
		iabft:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabft:SetSize(46, 45)
		else
			iabft:SetSize(31.6, 30.9)
		end
	end
	local iabfbst = _G[name.."FlyoutBorderShadow"]
	if (iabfbst ~= nil) then
		iabfbst:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		iabfbst:SetAtlas("UI-HUD-ActionBar-IconFrame-FlyoutBorderShadow")
		iabfbst:ClearAllPoints()
		iabfbst:SetPoint("CENTER", iActionButton, "CENTER", 0.2, 0.5)
		iabfbst:SetSize(52, 52)
	end
	local iabnat = iActionButton.NewActionTexture
	if (iabnat ~= nil) then
		iabnat:SetAtlas("UI-HUD-ActionBar-IconFrame-Mouseover")
		iabnat:SetBlendMode("BLEND")
		iabnat:ClearAllPoints()
		iabnat:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabnat:SetSize(46, 45)
		else
			iabnat:SetSize(31.6, 30.9)
		end
	end
	local iabsht = iActionButton.SpellHighlightTexture
	if (iabsht ~= nil) then
		iabsht:ClearAllPoints()
		if (typeActionButton == 3) then
			iabsht:SetAtlas("bags-newitem")
			iabsht:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
			iabsht:SetAlpha(1)
		else
			iabsht:SetAtlas("UI-HUD-ActionBar-IconFrame-Mouseover")
			iabsht:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
			iabsht:SetAlpha(0.4)
		end
		iabsht:SetBlendMode("ADD")
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabsht:SetSize(46, 45)
		else
			iabsht:SetSize(31.6, 30.9)
		end
	end
	local iabset = _G[name.."Shine"]
	if (iabset ~= nil) then
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabset:SetSize(40, 40)
		else
			iabset:SetSize(27, 27)
		end
	end
	local iabact = iActionButton.AutoCastable
	if (iabact ~= nil) then
		iabact:ClearAllPoints()
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabact:SetPoint("CENTER", iActionButton, "CENTER", 1, -1)
		else
			iabact:SetPoint("CENTER", iActionButton, "CENTER", 0.5, -0.5)
		end
	end
	local iabfbgt = iActionButton.FloatingBG
	if (iabfbgt ~= nil) then
		iabfbgt:Hide()
	end
	local iabfbt = iActionButton.FlyoutBorder
	if (iabfbt ~= nil) then
		iabfbt:Hide()
	end
end

-- Function that sets the current layout for a selected ActionButton
-- 'typeActionButton' defines the type of the ActionButton.The possible values for this parameter are:
--     0 = MainMenuBarButton     | 1 = BottomMultiBarButton | 2 = RightMultiBarButton  | 3 = PetBarButton
--     4 = StanceBarButton       | 5 = PossessBarButton     | 6 = SpellFlyoutButton    | 7 = OverrideBarButton
ClassicUI.LayoutActionButton = function(iActionButton, typeActionButton)
	local typeABprofile
	if (typeActionButton == 0) then
		typeABprofile = ClassicUI.db.profile.barsConfig.MainMenuBar
	elseif (typeActionButton == 1) then
		typeABprofile = ClassicUI.db.profile.barsConfig.BottomMultiActionBars
	elseif (typeActionButton == 2) then
		typeABprofile = ClassicUI.db.profile.barsConfig.RightMultiActionBars
	elseif (typeActionButton == 3) then
		typeABprofile = ClassicUI.db.profile.barsConfig.PetActionBarFrame
	elseif (typeActionButton == 4) then
		typeABprofile = ClassicUI.db.profile.barsConfig.StanceBarFrame
	elseif (typeActionButton == 5) then
		typeABprofile = ClassicUI.db.profile.barsConfig.PossessBarFrame
	elseif (typeActionButton == 6) then
		typeABprofile = ClassicUI.db.profile.barsConfig.SpellFlyoutButtons
	elseif (typeActionButton == 7) then
		typeABprofile = ClassicUI.db.profile.barsConfig.OverrideActionBar
	else
		return
	end
	local newBLScale = typeABprofile.scale or 1
	
	local name = iActionButton:GetName()
	iActionButton.RightDivider:SetAlpha(0)
	iActionButton.BottomDivider:SetAlpha(0)
	iActionButton.RightDivider:Hide()
	iActionButton.BottomDivider:Hide()
	if not(typeABprofile.BLStyle0AllowNewBackgroundArt) then
		iActionButton.SlotArt:SetAlpha(0)
		iActionButton.SlotBackground:SetAlpha(0)
		iActionButton.SlotArt:Hide()
		iActionButton.SlotBackground:Hide()
	else
		iActionButton.SlotArt:SetAlpha(1)
		iActionButton.SlotBackground:SetAlpha(1)
		if (iActionButton.showButtonArt) then
			iActionButton.SlotArt:Show()
			iActionButton.SlotBackground:Show()
		end
		if not(typeABprofile.BLStyle == 1) then
			iActionButton.SlotArt:SetDrawLayer("BACKGROUND", -1)
			iActionButton.SlotBackground:SetDrawLayer("BACKGROUND", -1)
		end
	end
	local iabnt = iActionButton:GetNormalTexture()
	local iabpt = iActionButton:GetPushedTexture()
	if ((iActionButton.UpdateButtonArt ~= nil) and (iabnt ~= nil) and (iabpt ~= nil) and not(ClassicUI.cached_ActionButtonInfo.hooked_UpdateButtonArt[iActionButton])) then
		hooksecurefunc(iActionButton, "UpdateButtonArt", function(self, hideDivider)
			--if ClassicUI.databaseCleaned then return end	-- not needed because typeABprofile is an upvalue local table variable (the upvalue table can become empty but never nil, not an issue)
			if (not self.SlotArt or not self.SlotBackground) then
				return
			end
			if (self.RightDivider:IsShown()) then
				self.RightDivider:Hide()
			end
			if (self.BottomDivider:IsShown()) then
				self.BottomDivider:Hide()
			end
			if not(typeABprofile.BLStyle0AllowNewBackgroundArt) then
				if (self.SlotArt:IsShown()) then
					self.SlotArt:Hide()
				end
				if (self.SlotBackground:IsShown()) then
					self.SlotBackground:Hide()
				end
			end
			if (typeABprofile.BLStyle == 1) then
				-- Dragonflight Layout
				if (self.showButtonArt) then
					if (self.NormalTexture:GetAtlas() ~= "UI-HUD-ActionBar-IconFrame-AddRow") then
						self:SetNormalAtlas("UI-HUD-ActionBar-IconFrame-AddRow")
						if (typeActionButton <= 2) then
							self.NormalTexture:SetSize(51, 51)
						end
						self.NormalTexture:SetAlpha(typeABprofile.BLStyle1NormalTextureAlpha)
					end
					if (self.PushedTexture:GetAtlas() ~= "UI-HUD-ActionBar-IconFrame-AddRow-Down") then
						self:SetPushedAtlas("UI-HUD-ActionBar-IconFrame-AddRow-Down")
						if (typeActionButton <= 2) then
							self.PushedTexture:SetSize(51, 51)
						end
					end
				end
			else
				-- Classic Layout
				if (self.NormalTexture:GetAtlas() ~= nil) then
					self.NormalTexture:SetAtlas(nil)
					if (typeActionButton == 3) then
						self.NormalTexture:SetSize(54, 54)
					elseif (typeActionButton == 4) then
						if (MultiBarBottomLeft and MultiBarBottomLeft:IsShown()) then
							self.NormalTexture:SetSize(52, 52)
						else
							self.NormalTexture:SetSize(64, 64)
						end
					elseif (typeActionButton == 5) then
						self.NormalTexture:SetSize(60, 60)
					elseif (typeActionButton == 6) then
						self.NormalTexture:SetSize(28, 28)
					elseif (typeActionButton == 7) then
						self.NormalTexture:SetSize(82, 82)
					else
						self.NormalTexture:SetSize(66, 66)
					end
					if (typeActionButton == 3 or typeActionButton == 4) then
						self.NormalTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
						self.NormalTexture:SetTexture("Interface\\Buttons\\UI-Quickslot2")
						self.NormalTexture:SetAlpha(typeABprofile.BLStyle0NormalTextureAlpha)
						self.NormalTexture:ClearAllPoints()
						self.NormalTexture:SetPoint("CENTER", self, "CENTER", 0, -1)
					elseif (typeActionButton == 6) then
						self.NormalTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
						self.NormalTexture:SetTexture(nil)
						self.NormalTexture:SetAlpha(typeABprofile.BLStyle0NormalTextureAlpha)
						self.NormalTexture:ClearAllPoints()
						self.NormalTexture:SetAllPoints(self)
					else
						self.NormalTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
						self.NormalTexture:SetTexture("Interface\\Buttons\\UI-Quickslot2")
						self.NormalTexture:SetAlpha(typeABprofile.BLStyle0NormalTextureAlpha)
						self.NormalTexture:ClearAllPoints()
						self.NormalTexture:SetPoint("TOPLEFT", self, "TOPLEFT", -15, 15)
						self.NormalTexture:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 15, -15)
					end
				end
				if not(typeABprofile.BLStyle0UseNewPushedTexture) then
					if (self.PushedTexture:GetAtlas() ~= nil) then
						self.PushedTexture:SetAtlas(nil)
						if (typeActionButton == 7) then
							self.PushedTexture:SetSize(52, 52)
						elseif (typeActionButton == 6) then
							self.PushedTexture:SetSize(28, 28)
						elseif (typeActionButton >= 3) then
							self.PushedTexture:SetSize(30, 30)
						else
							self.PushedTexture:SetSize(36, 36)
						end
						self.PushedTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
						self.PushedTexture:SetTexture("Interface\\Buttons\\UI-Quickslot-Depress")
						self.PushedTexture:SetAlpha(1)
						self.PushedTexture:ClearAllPoints()
						self.PushedTexture:SetAllPoints(self)
					end
				else
					if (self.PushedTexture:GetAtlas() ~= "UI-HUD-ActionBar-IconFrame-AddRow-Down") then
						self.PushedTexture:SetAtlas("UI-HUD-ActionBar-IconFrame-AddRow-Down")
					end
					if (typeActionButton == 7) then
						self.PushedTexture:SetSize(61, 60)
					elseif (typeActionButton == 6) then
						self.PushedTexture:SetSize(32, 32)
					elseif (typeActionButton <= 2) then
						self.PushedTexture:SetSize(42, 41)
					end
				end
			end
		end)
		ClassicUI.cached_ActionButtonInfo.hooked_UpdateButtonArt[iActionButton] = true
	end
	if (typeABprofile.BLStyle == 1) then
		-- Dragonflight Layout
		iActionButton.NormalTexture:SetAlpha(typeABprofile.BLStyle1NormalTextureAlpha)
		if (typeActionButton <= 2) then
			ClassicUI.cached_ActionButtonInfo.currentScale[iActionButton] = ClassicUI.ACTIONBUTTON_NEWLAYOUT_SCALE
			iActionButton:SetScale((newBLScale / iActionButton:GetParent():GetScale()) * ClassicUI.cached_ActionButtonInfo.currentScale[iActionButton])
			if (typeActionButton == 0) then
				if ((iActionButton.UpdateButtonArt ~= nil) and iActionButton.SlotArt and iActionButton.SlotBackground and iActionButton.showButtonArt) then
					if (iabnt ~= nil) and (iabnt:GetAtlas() ~= "UI-HUD-ActionBar-IconFrame-AddRow") then
						iActionButton:SetNormalAtlas("UI-HUD-ActionBar-IconFrame-AddRow")
						iabnt:SetSize(51, 51)
					end
					if (iabpt ~= nil) and (iabpt:GetAtlas() ~= "UI-HUD-ActionBar-IconFrame-AddRow-Down") then
						iActionButton:SetPushedAtlas("UI-HUD-ActionBar-IconFrame-AddRow-Down")
						iabpt:SetSize(51, 51)
					end
				end
			end
		end
		if (ClassicUI.cached_ActionButtonInfo.currLayout[iActionButton] == 0) then
			ClassicUI.RestoreDragonflightLayoutActionButton(iActionButton, typeActionButton)
		end
	else
		-- Classic Layout
		if (typeActionButton == 7) then
			iActionButton:SetSize(52, 52)
		elseif (typeActionButton == 6) then
			iActionButton:SetSize(28, 28)
		elseif (typeActionButton >= 3) then
			iActionButton:SetSize(30, 30)
		else
			iActionButton:SetSize(36, 36)
		end
		ClassicUI.cached_ActionButtonInfo.currentScale[iActionButton] = 1
		if (typeActionButton <= 2) then
			iActionButton:SetScale(newBLScale / iActionButton:GetParent():GetScale())
		end
		if (iabnt ~= nil) then
			iabnt:SetAtlas(nil)
			if (typeActionButton == 3) then
				iabnt:SetSize(54, 54)
			elseif (typeActionButton == 4) then
				if (MultiBarBottomLeft and MultiBarBottomLeft:IsShown()) then
					iabnt:SetSize(52, 52)
				else
					iabnt:SetSize(64, 64)
				end
			elseif (typeActionButton == 5) then
				iabnt:SetSize(60, 60)
			elseif (typeActionButton == 6) then
				iabnt:SetSize(28, 28)
			elseif (typeActionButton == 7) then
				iabnt:SetSize(82, 82)
			else
				iabnt:SetSize(66, 66)
			end
			if (typeActionButton == 3 or typeActionButton == 4) then
				iabnt:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
				iabnt:SetTexture("Interface\\Buttons\\UI-Quickslot2")
				iabnt:SetAlpha(typeABprofile.BLStyle0NormalTextureAlpha)
				iabnt:ClearAllPoints()
				iabnt:SetPoint("CENTER", iActionButton, "CENTER", 0, -1)
			elseif (typeActionButton == 6) then
				iabnt:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
				iabnt:SetTexture(nil)
				iabnt:SetAlpha(typeABprofile.BLStyle0NormalTextureAlpha)
				iabnt:ClearAllPoints()
				iabnt:SetAllPoints(iActionButton)
			else
				iabnt:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
				iabnt:SetTexture("Interface\\Buttons\\UI-Quickslot2")
				iabnt:SetAlpha(typeABprofile.BLStyle0NormalTextureAlpha)
				iabnt:ClearAllPoints()
				iabnt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -15, 15)
				iabnt:SetPoint("BOTTOMRIGHT", iActionButton, "BOTTOMRIGHT", 15, -15)
			end
		end
		if (iabpt ~= nil) then
			if not(typeABprofile.BLStyle0UseNewPushedTexture) then
				iabpt:SetAtlas(nil)
				if (typeActionButton == 7) then
					iabpt:SetSize(52, 52)
				elseif (typeActionButton == 6) then
					iabpt:SetSize(28, 28)
				elseif (typeActionButton >= 3) then
					iabpt:SetSize(30, 30)
				else
					iabpt:SetSize(36, 36)
				end
				iabpt:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
				iabpt:SetTexture("Interface\\Buttons\\UI-Quickslot-Depress")
				iabpt:SetAlpha(1)
				iabpt:ClearAllPoints()
				iabpt:SetAllPoints(iActionButton)
			else
				if (iabpt:GetAtlas() ~= "UI-HUD-ActionBar-IconFrame-AddRow-Down") then
					iabpt:SetAtlas("UI-HUD-ActionBar-IconFrame-AddRow-Down")
					iabpt:ClearAllPoints()
					iabpt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
				end
				if (typeActionButton == 7) then
					iabpt:SetSize(61, 60)
				elseif (typeActionButton == 6) then
					iabpt:SetSize(32, 32)
				elseif (typeActionButton <= 2) then
					iabpt:SetSize(42, 41)
				else
					iabpt:SetSize(35, 35)
				end
			end
		end
		local iabht = iActionButton:GetHighlightTexture()
		if (iabht ~= nil) then
			if not(typeABprofile.BLStyle0UseNewHighlightTexture) then
				iabht:SetAtlas(nil)
				if (typeActionButton == 7) then
					iabht:SetSize(52, 52)
				elseif (typeActionButton == 6) then
					iabht:SetSize(28, 28)
				elseif (typeActionButton >= 3) then
					iabht:SetSize(30, 30)
				else
					iabht:SetSize(36, 36)
				end
				iabht:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
				iabht:SetBlendMode("ADD")
				iabht:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
				iabht:SetAlpha(1)
				iabht:ClearAllPoints()
				iabht:SetAllPoints(iActionButton)
			else
				if (iabht:GetAtlas() == nil) then
					iabht:SetAtlas("UI-HUD-ActionBar-IconFrame-Mouseover")
					iabht:SetBlendMode("BLEND")
					iabht:ClearAllPoints()
					iabht:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
				end
				if (typeActionButton == 7) then
					iabht:SetSize(59, 58)
					iabht:ClearAllPoints()
					iabht:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -2.5, 2.5)
				elseif (typeActionButton == 6) then
					iabht:SetSize(31, 30.31)
					iabht:ClearAllPoints()
					iabht:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -1, 1)
				elseif (typeActionButton >= 3) then
					iabht:SetSize(34, 33.25)
					iabht:ClearAllPoints()
					iabht:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -1.5, 1.5)
				else
					iabht:ClearAllPoints()
					iabht:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -2, 2)
					iabht:SetSize(41, 40)
				end
			end
		end
		local iabchkt = iActionButton:GetCheckedTexture()
		if (iabchkt ~= nil) then
			if not(typeABprofile.BLStyle0UseNewCheckedTexture) then
				iabchkt:SetAtlas(nil)
				if (typeActionButton == 7) then
					iabchkt:SetSize(52, 52)
				elseif (typeActionButton == 6) then
					iabchkt:SetSize(28, 28)
				elseif (typeActionButton >= 3) then
					iabchkt:SetSize(30, 30)
				else
					iabchkt:SetSize(36, 36)
				end
				iabchkt:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
				iabchkt:SetBlendMode("ADD")
				iabchkt:SetTexture("Interface\\Buttons\\CheckButtonHilight")
				iabchkt:SetAlpha(1)
				iabchkt:ClearAllPoints()
				iabchkt:SetAllPoints(iActionButton)
			else
				if (iabchkt:GetAtlas() == nil) then
					iabchkt:SetAtlas("UI-HUD-ActionBar-IconFrame-Mouseover")
					iabchkt:SetBlendMode("BLEND")
					iabchkt:ClearAllPoints()
					iabchkt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
				end
				if (typeActionButton == 7) then
					iabchkt:SetSize(59, 58)
					iabchkt:ClearAllPoints()
					iabchkt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -2.5, 2.5)
				elseif (typeActionButton == 6) then
					iabchkt:SetSize(31, 30.31)
					iabchkt:ClearAllPoints()
					iabchkt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -1, 1)
				elseif (typeActionButton >= 3) then
					iabchkt:SetSize(34, 33.25)
					iabchkt:ClearAllPoints()
					iabchkt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -1.5, 1.5)
				else
					iabchkt:SetSize(41, 40)
					iabchkt:ClearAllPoints()
					iabchkt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -2, 2)
				end
			end
		end
		local iabit = _G[name.."Icon"]
		if (iabit ~= nil) then
			if (typeActionButton == 7) then
				iabit:SetSize(52, 52)
			elseif (typeActionButton == 6) then
				iabit:SetSize(28, 28)
				iabit:SetTexCoord(4/64, 60/64, 4/64, 60/64)
			elseif (typeActionButton >= 3) then
				iabit:SetSize(30, 30)
			else
				iabit:SetSize(36, 36)
			end
		end
		local iabctt = _G[name.."Count"]
		if (iabctt ~= nil) then
			iabctt:ClearAllPoints()
			iabctt:SetPoint("BOTTOMRIGHT", iActionButton, "BOTTOMRIGHT", -2, 2)
		end
		local iabbt = _G[name.."Border"]
		if (iabbt ~= nil) then
			iabbt:SetSize(62, 62)
			iabbt:SetAtlas(nil)
			iabbt:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			iabbt:SetBlendMode("ADD")
			if ((iActionButton.action ~= nil) and (IsEquippedAction(iActionButton.action))) then
				iabbt:SetAlpha(0.5)
			else
				iabbt:SetAlpha(1)
			end
			iabbt:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
			iabbt:ClearAllPoints()
			iabbt:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
		end
		local iabHt = _G[name.."HotKey"]
		if (iabHt ~= nil) then
			if (typeABprofile.BLStyle0UseOldHotKeyTextStyle) then
				iabHt:SetSize(36, 10)
				iabHt:ClearAllPoints()
				if (typeActionButton == 3) then
					iabHt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -2, -3)
				else
					iabHt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 1, -3)
				end
				local iabHt_f1, iabHt_f2, iabHt_f3 = iabHt:GetFont()
				if (iabHt_f3 ~= "OUTLINE, THICKOUTLINE, MONOCHROME") then
					iabHt:SetFont(iabHt_f1, iabHt_f2, "OUTLINE, THICKOUTLINE, MONOCHROME")
				end
			else
				iabHt:SetSize(32, 10)
				iabHt:ClearAllPoints()
				if (typeActionButton == 3) then
					iabHt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -2, -3)
				else
					iabHt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 3, -3)
				end
				local iabHt_f1, iabHt_f2, iabHt_f3 = iabHt:GetFont()
				if (iabHt_f3 ~= "OUTLINE") then
					iabHt:SetFont(iabHt_f1, iabHt_f2, "OUTLINE")
				end
			end
		end
		local iabcdt = _G[name.."Cooldown"]
		if (iabcdt ~= nil) then
			if (typeActionButton == 3) then
				iabcdt:SetSize(33, 33)
			elseif (typeActionButton == 6) then
				iabcdt:SetSize(28, 28)
			elseif (typeActionButton >= 4) then
				iabcdt:SetSize(30, 30)
			else
				iabcdt:SetSize(36, 36)
			end
			iabcdt:ClearAllPoints()
			iabcdt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", 0, 0)
			iabcdt:SetPoint("CENTER", iActionButton, "CENTER", 0, -1)
			iabcdt:SetPoint("BOTTOMRIGHT", iActionButton, "BOTTOMRIGHT", 0, 0)
		end
		local iabft = _G[name.."Flash"]
		if (iabft ~= nil) then
			if (typeActionButton == 7) then
				iabft:SetSize(52, 52)
			elseif (typeActionButton == 6) then
				iabft:SetSize(28, 28)
			elseif (typeActionButton >= 3) then
				iabft:SetSize(30, 30)
			else
				iabft:SetSize(36, 36)
			end
			iabft:SetAtlas(nil)
			iabft:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			iabft:SetAlpha(1)
			iabft:SetTexture("Interface\\Buttons\\UI-QuickslotRed")
			iabft:ClearAllPoints()
			iabft:SetAllPoints(iActionButton)
		end
		local iabfbst = _G[name.."FlyoutBorderShadow"]
		if (iabfbst ~= nil) then
			iabfbst:SetSize(48, 48)
			iabfbst:SetAtlas(nil)
			iabfbst:SetTexCoord(0.015625, 0.0078125, 0.015625, 0.3828125, 0.765625, 0.0078125, 0.765625, 0.3828125)
			iabfbst:SetAlpha(1)
			iabfbst:SetTexture("Interface\\Buttons\\ActionBarFlyoutButton")
			iabfbst:ClearAllPoints()
			iabfbst:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
		end
		local iabnat = iActionButton.NewActionTexture
		if (iabnat ~= nil) then
			iabnat:SetSize(44, 44)
			iabnat:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			iabnat:SetBlendMode("ADD")
			iabnat:SetAlpha(1)
			iabnat:SetTexture(969828)
			iabnat:SetAtlas("bags-newitem")
			iabnat:ClearAllPoints()
			iabnat:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
		end
		local iabsht = iActionButton.SpellHighlightTexture
		if (iabsht ~= nil) then
			if not(typeABprofile.BLStyle0UseNewSpellHighlightTexture) then
				if (typeActionButton == 3) then
					iabsht:SetSize(34, 34)
				else
					iabsht:SetSize(44, 44)
				end
				iabsht:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
				iabsht:SetBlendMode("ADD")
				iabsht:SetAlpha(1)
				iabsht:SetTexture(969828)
				iabsht:SetAtlas("bags-newitem")
				iabsht:ClearAllPoints()
				iabsht:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
			else
				if (typeActionButton == 3) then
					if (iabsht:GetAtlas() ~= "bags-newitem") then
						iabsht:SetAtlas("bags-newitem")
						iabsht:SetBlendMode("ADD")
					end
					iabsht:SetAlpha(1)
				else
					if (iabsht:GetAtlas() ~= "UI-HUD-ActionBar-IconFrame-Mouseover") then
						iabsht:SetAtlas("UI-HUD-ActionBar-IconFrame-Mouseover")
						iabsht:SetBlendMode("ADD")
					end
					iabsht:SetAlpha(0.4)
				end
				iabsht:ClearAllPoints()
				if (typeActionButton == 7) then
					iabsht:SetSize(59, 58)
					iabsht:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -2.5, 2.5)
				elseif (typeActionButton == 6) then
					iabsht:SetSize(31, 30.31)
					iabsht:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -1, 1)
				elseif (typeActionButton >= 4) then
					iabsht:SetSize(34, 33.25)
					iabsht:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -1.5, 1.5)
				elseif (typeActionButton == 3) then
					iabsht:SetSize(34, 34)
					iabsht:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
				elseif (typeActionButton <= 2) then
					iabsht:SetSize(41, 40)
					iabsht:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -2, 2)
				end
			end
		end
		local iabset = _G[name.."Shine"]
		if (iabset ~= nil) then
			iabset:SetSize(28, 28)
		end
		local iabact = iActionButton.AutoCastable
		if (iabact ~= nil) then
			iabact:SetSize(58, 58)
			iabact:ClearAllPoints()
			iabact:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
		end
		if (typeActionButton == 1 or typeActionButton == 2) then
			local iabfbgt = _G[name.."FloatingBG"]
			if (not iabfbgt) then
				iabfbgt = iActionButton:CreateTexture(name.."FloatingBG")
				iActionButton.FloatingBG = iabfbgt
			end
			iabfbgt:SetSize(66, 66)
			iabfbgt:SetAtlas(nil)
			iabfbgt:SetDrawLayer("BACKGROUND", -1)
			iabfbgt:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			iabfbgt:SetAlpha(0.4)
			iabfbgt:SetTexture("Interface\\Buttons\\UI-Quickslot")
			iabfbgt:SetPoint("TOPLEFT", iActionButton, "TOPLEFT", -15, 15)
			iabfbgt:SetPoint("BOTTOMRIGHT", iActionButton, "BOTTOMRIGHT", 15, -15)
			iabfbgt:Show()
		end
		local iabfbt = _G[name.."FlyoutBorder"]
		if (not iabfbt) then
			iabfbt = iActionButton:CreateTexture(name.."FlyoutBorder")
			iActionButton.FlyoutBorder = iabfbt
		end
		iabfbt:SetSize(42, 42)
		iabfbt:SetAtlas(nil)
		iabfbt:SetDrawLayer("ARTWORK", 1)
		iabfbt:SetTexCoord(0.015625, 0.3984375, 0.015625, 0.7265625, 0.671875, 0.3984375, 0.671875, 0.726562)
		iabfbt:SetAlpha(1)
		iabfbt:SetTexture("Interface\\Buttons\\ActionBarFlyoutButton")
		iabfbt:ClearAllPoints()
		iabfbt:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
		iabfbt:Hide()
		-- TODO: We keep the new Dragonflight FlyoutArrow, maybe we recreate the old one in a future version
		if (typeActionButton == 3) then
			-- Hide IconMask for PetActionButtons but leave it for the others
			iActionButton.IconMask:SetAlpha(0)
			iActionButton.IconMask:Hide()
		end
		if ((iActionButton.UpdateHotkeys ~= nil) and (iabHt ~= nil) and not(ClassicUI.cached_ActionButtonInfo.hooked_UpdateHotkeys[iActionButton])) then
			hooksecurefunc(iActionButton, "UpdateHotkeys", function(self, actionButtonType)
				--if ClassicUI.databaseCleaned then return end	-- not needed because typeABprofile is an upvalue local table variable (the upvalue table can become empty but never nil, not an issue)
				if not(typeABprofile.BLStyle == 1) then
					local id
					if (not actionButtonType) then
						actionButtonType = "ACTIONBUTTON"
						id = self:GetID()
					else
						if (actionButtonType == "MULTICASTACTIONBUTTON") then
							id = self.buttonIndex
						else
							id = self:GetID()
						end
					end
					local hotkey = self.HotKey
					local key = GetBindingKey(actionButtonType..id) or GetBindingKey("CLICK "..self:GetName()..":LeftButton")
					local text = GetBindingText(key, 1)
					if (text ~= "") then
						hotkey:ClearAllPoints()
						if (typeABprofile.BLStyle0UseOldHotKeyTextStyle) then
							hotkey:SetSize(36, 10)
							if (typeActionButton == 3) then
								hotkey:SetPoint("TOPLEFT", self, "TOPLEFT", -2, -3)
							else
								hotkey:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -3)
							end
						else
							hotkey:SetSize(32, 10)
							if (typeActionButton == 3) then
								hotkey:SetPoint("TOPLEFT", self, "TOPLEFT", -2, -3)
							else
								hotkey:SetPoint("TOPLEFT", self, "TOPLEFT", 3, -3)
							end
						end
					end
				end
			end)
			ClassicUI.cached_ActionButtonInfo.hooked_UpdateHotkeys[iActionButton] = true
		end
		if ((iActionButton.UpdateFlyout ~= nil) and (iabfbt ~= nil) and not(ClassicUI.cached_ActionButtonInfo.hooked_UpdateFlyout[iActionButton])) then
			hooksecurefunc(iActionButton, "UpdateFlyout", function(self, isButtonDownOverride)
				--if ClassicUI.databaseCleaned then return end	-- not needed because typeABprofile is an upvalue local table variable (the upvalue table can become empty but never nil, not an issue)
				if not(typeABprofile.BLStyle == 1) and not(typeABprofile.BLStyle0UseNewFlyoutBorder) then
					if (not self.FlyoutArrowContainer or not self.FlyoutBorderShadow) then
						return
					end
					local actionType = GetActionInfo(self.action)
					if (actionType ~= "flyout") then
						if (not(self.FlyoutBorderShadow:IsShown()) and self.FlyoutBorder:IsShown()) then
							self.FlyoutBorder:Hide()
						end
						return
					end
					local isMouseOverButton = GetMouseFocus() == self
					local isFlyoutShown = SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self
					if (isFlyoutShown or isMouseOverButton) then
						if (self.FlyoutBorderShadow:IsShown() and not(self.FlyoutBorder:IsShown())) then
							self.FlyoutBorder:Show()
						end
					else
						if (not(self.FlyoutBorderShadow:IsShown()) and self.FlyoutBorder:IsShown()) then
							self.FlyoutBorder:Hide()
						end
					end
				end
			end)
			ClassicUI.cached_ActionButtonInfo.hooked_UpdateFlyout[iActionButton] = true
		end
	end
	ClassicUI.cached_ActionButtonInfo.currLayout[iActionButton] = typeABprofile.BLStyle
end

-- Function that sets the current layout for a desired groups of ActionButtons
ClassicUI.LayoutGroupActionButtons = function(groups)
	if ((groups == nil) or (type(groups) ~= "table")) then return end
	if (groups[0]) then
		for i = 1, 12 do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["ActionButton"..i], 0)
		end
	end
	if (groups[1]) then
		for i = 1, 12 do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["MultiBarBottomLeftButton"..i], 1)
		end
		for i = 1, 12 do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["MultiBarBottomRightButton"..i], 1)
		end
	end
	if (groups[2]) then
		for i = 1, 12 do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["MultiBarLeftButton"..i], 2)
		end
		for i = 1, 12 do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["MultiBarRightButton"..i], 2)
		end
	end
	if (groups[3]) then
		for i = 1, 10 do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["PetActionButton"..i], 3)
		end
	end
	if (groups[4]) then
		for i = 1, 10 do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["StanceButton"..i], 4)
		end
	end
	if (groups[5]) then
		for i = 1, 2 do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["PossessButton"..i], 5)
		end
	end
	if (groups[6]) then
		for i = 1, 40 do
			local button = _G["SpellFlyoutButton"..i]
			if (button ~= nil) then
				ClassicUI:ActionButtonProtectedApplyLayout(button, 6)
			else
				break
			end
		end
	end
	if (groups[7]) then
		for i = 1, 6 do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["OverrideActionBarButton"..i], 7)
		end
	end
end

-- Function that sets the current layout for all ActionButtons
ClassicUI.LayoutAllActionButtons = function()
	ClassicUI.LayoutGroupActionButtons({[0]=true,[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[6]=true,[7]=true})
end

-- Function to apply the current layout to an ActionButton, handling a queue of pending buttons if in combat lockdown
function ClassicUI:ActionButtonProtectedApplyLayout(button, typeActionButton)
	if InCombatLockdown() then
		if ((button ~= nil) and (self.queuePending_ActionButtonsLayout[button] == nil)) then
			self.queuePending_ActionButtonsLayout[button] = typeActionButton
		end
		delayFunc_ActionButtonProtectedApplyLayout = true
		if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
			fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		return
	end
	if (button ~= nil) then
		self.LayoutActionButton(button, typeActionButton)
		self.queuePending_ActionButtonsLayout[button] = nil
	end
	for iButton, iTypeActionButton in pairs(self.queuePending_ActionButtonsLayout) do
		self.LayoutActionButton(iButton, iTypeActionButton)
		self.queuePending_ActionButtonsLayout[iButton] = nil
	end
end

-- Function that initializes the cache with the information of all the ActionButtons to the default values
function ClassicUI:InitActionButtonInfoCache()
	for i = 1, 12 do
		self.cached_ActionButtonInfo.hooked_UpdateButtonArt = {
			[_G["ActionButton"..i]] = false,
			[_G["MultiBarBottomLeftButton"..i]] = false,
			[_G["MultiBarBottomRightButton"..i]] = false,
			[_G["MultiBarRightButton"..i]] = false,
			[_G["MultiBarLeftButton"..i]] = false
		}
		self.cached_ActionButtonInfo.hooked_UpdateHotkeys = {
			[_G["ActionButton"..i]] = false,
			[_G["MultiBarBottomLeftButton"..i]] = false,
			[_G["MultiBarBottomRightButton"..i]] = false,
			[_G["MultiBarRightButton"..i]] = false,
			[_G["MultiBarLeftButton"..i]] = false
		}
		self.cached_ActionButtonInfo.hooked_UpdateFlyout = {
			[_G["ActionButton"..i]] = false,
			[_G["MultiBarBottomLeftButton"..i]] = false,
			[_G["MultiBarBottomRightButton"..i]] = false,
			[_G["MultiBarRightButton"..i]] = false,
			[_G["MultiBarLeftButton"..i]] = false
		}
		self.cached_ActionButtonInfo.currentScale = {
			[_G["ActionButton"..i]] = 1,
			[_G["MultiBarBottomLeftButton"..i]] = 1,
			[_G["MultiBarBottomRightButton"..i]] = 1,
			[_G["MultiBarRightButton"..i]] = 1,
			[_G["MultiBarLeftButton"..i]] = 1
		}
		self.cached_ActionButtonInfo.currLayout = {
			[_G["ActionButton"..i]] = 1,
			[_G["MultiBarBottomLeftButton"..i]] = 1,
			[_G["MultiBarBottomRightButton"..i]] = 1,
			[_G["MultiBarRightButton"..i]] = 1,
			[_G["MultiBarLeftButton"..i]] = 1
		}
	end
	for i = 1, 10 do
		self.cached_ActionButtonInfo.hooked_UpdateButtonArt = {
			[_G["PetActionButton"..i]] = false,
			[_G["StanceButton"..i]] = false
		}
		self.cached_ActionButtonInfo.hooked_UpdateHotkeys = {
			[_G["PetActionButton"..i]] = false,
			[_G["StanceButton"..i]] = false
		}
		self.cached_ActionButtonInfo.hooked_UpdateFlyout = {
			[_G["PetActionButton"..i]] = false,
			[_G["StanceButton"..i]] = false
		}
		self.cached_ActionButtonInfo.currentScale = {
			[_G["PetActionButton"..i]] = 1,
			[_G["StanceButton"..i]] = 1
		}
		self.cached_ActionButtonInfo.currLayout = {
			[_G["PetActionButton"..i]] = 1,
			[_G["StanceButton"..i]] = 1
		}
	end
	for i = 1, 6 do
		self.cached_ActionButtonInfo.hooked_UpdateButtonArt = {
			[_G["OverrideActionBarButton"..i]] = false
		}
		self.cached_ActionButtonInfo.hooked_UpdateHotkeys = {
			[_G["OverrideActionBarButton"..i]] = false
		}
		self.cached_ActionButtonInfo.hooked_UpdateFlyout = {
			[_G["OverrideActionBarButton"..i]] = false
		}
		self.cached_ActionButtonInfo.currentScale = {
			[_G["OverrideActionBarButton"..i]] = 1
		}
		self.cached_ActionButtonInfo.currLayout = {
			[_G["OverrideActionBarButton"..i]] = 1
		}
	end
	for i = 1, 40 do
		local button = _G["SpellFlyoutButton"..i]
		if (button ~= nil) then
			self.cached_ActionButtonInfo.hooked_UpdateButtonArt = {
				[button] = false
			}
			self.cached_ActionButtonInfo.hooked_UpdateHotkeys = {
				[button] = false
			}
			self.cached_ActionButtonInfo.hooked_UpdateFlyout = {
				[button] = false
			}
			self.cached_ActionButtonInfo.currentScale = {
				[button] = 1
			}
			self.cached_ActionButtonInfo.currLayout = {
				[button] = 1
			}
		else
			break
		end
	end
	self.cached_ActionButtonInfo.hooked_UpdateButtonArt[PossessButton1] = false
	self.cached_ActionButtonInfo.hooked_UpdateButtonArt[PossessButton2] = false
	self.cached_ActionButtonInfo.hooked_UpdateHotkeys[PossessButton1] = false
	self.cached_ActionButtonInfo.hooked_UpdateHotkeys[PossessButton2] = false
	self.cached_ActionButtonInfo.hooked_UpdateFlyout[PossessButton1] = false
	self.cached_ActionButtonInfo.hooked_UpdateFlyout[PossessButton2] = false
	self.cached_ActionButtonInfo.currentScale[PossessButton1] = 1
	self.cached_ActionButtonInfo.currentScale[PossessButton2] = 1
	self.cached_ActionButtonInfo.currLayout[PossessButton1] = 1
	self.cached_ActionButtonInfo.currLayout[PossessButton2] = 1
end

-- Main function that loads the core features of ClassicUI. This function at the end calls to 'ClassicUI:PLAYER_ENTERING_WORLD()'.
function ClassicUI:MainFunction(isLogin)
	
	-- Update the cached value of the number of visible bars and the number of real visible bars
	ClassicUI.cached_NumberVisibleBars = ClassicUI:GetNumberVisibleBars(StatusTrackingBarManager)
	ClassicUI.cached_NumberRealVisibleBars = ClassicUI.cached_NumberVisibleBars
	
	-- Get and set the cached values for the status bar variables
	ClassicUI:UpdateStatusBarOptionsCache()
	
	-- Create the basic default-value cache for ActionButtons
	ClassicUI:InitActionButtonInfoCache()
	
	-- Wipe the .buttonsAndSpacers table from ActionBars to avoid Blizzard layout updates with the UpdateGridLayout() function. Wiping this table does not taint :)
	if (MainMenuBar.buttonsAndSpacers ~= nil) then
		tblwipe(MainMenuBar.buttonsAndSpacers)
	end
	if (MultiBarBottomLeft.buttonsAndSpacers ~= nil) then
		tblwipe(MultiBarBottomLeft.buttonsAndSpacers)
	end
	if (MultiBarBottomRight.buttonsAndSpacers ~= nil) then
		tblwipe(MultiBarBottomRight.buttonsAndSpacers)
	end
	if (StanceBar.buttonsAndSpacers ~= nil) then
		tblwipe(StanceBar.buttonsAndSpacers)
	end
	if (PetActionBar.buttonsAndSpacers ~= nil) then
		tblwipe(PetActionBar.buttonsAndSpacers)
	end
	if (PossessActionBar.buttonsAndSpacers ~= nil) then
		tblwipe(PossessActionBar.buttonsAndSpacers)
	end
	if (MultiBarRight.buttonsAndSpacers ~= nil) then
		tblwipe(MultiBarRight.buttonsAndSpacers)
	end
	if (MultiBarLeft.buttonsAndSpacers ~= nil) then
		tblwipe(MultiBarLeft.buttonsAndSpacers)
	end
	
	if InCombatLockdown() then
		delayFunc_MainFunction = true
		if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
			fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		return
	end
	
	-- We reset certain attributes of the ActionBars to their old values and disable their interaction with the mouse
	ClassicUI:ModifyOriginalFrames()
	
	hooksecurefunc(MainMenuBar, "UpdateEndCaps", function(self, overrideHideEndCaps)
		self.EndCaps.LeftEndCap:Hide()
		self.EndCaps.RightEndCap:Hide()
		self.EndCaps:Hide()
	end)
	MainMenuBar.EndCaps.LeftEndCap:Hide()
	MainMenuBar.EndCaps.RightEndCap:Hide()
	MainMenuBar.EndCaps:Hide()
	hooksecurefunc(MainMenuBar, "UpdateSystemSettingHideBarArt", function(self)
		self.BorderArt:SetShown(false)
		self.Background:SetShown(false)
	end)
	MainMenuBar.BorderArt:SetShown(false)
	MainMenuBar.Background:SetShown(false)

	-- Create wrapper frames for the [ActionBars], setting their attributes to their originals, and using the original frame as parent
	-- These frames will be the ones used by the ActionButton to anchor, since they will have fewer restrictions than the original ones and will cause fewer taints errors
	-- These frames will always be visible, so their actual visibility depends on that of their parent frame (the original ActionBar)
	
	-- [ActionBars] OverrideActionBar
	OverrideActionBar:SetPoint("BOTTOM", OverrideActionBar:GetParent(), "BOTTOM", ClassicUI.db.profile.barsConfig.OverrideActionBar.xOffset, ClassicUI.db.profile.barsConfig.OverrideActionBar.yOffset)
	OverrideActionBar:SetScale(ClassicUI.db.profile.barsConfig.OverrideActionBar.scale)
	
	-- [ActionBars] PetBattleFrame
	PetBattleFrame.BottomFrame:SetPoint("BOTTOM", PetBattleFrame.BottomFrame:GetParent(), "BOTTOM", ClassicUI.db.profile.barsConfig.PetBattleFrameBar.xOffset, ClassicUI.db.profile.barsConfig.PetBattleFrameBar.yOffset)
	PetBattleFrame.BottomFrame:SetScale(ClassicUI.db.profile.barsConfig.PetBattleFrameBar.scale)
	
	-- [ActionBars] MainMenuBar
	local CUI_MainMenuBar = CreateFrame("Frame", "CUI_MainMenuBar", MainMenuBar)
	function CUI_MainMenuBar:InitButtons()
		for i = 1, 12 do
			local iActionButton = _G["ActionButton"..i]
			if (iActionButton ~= nil) then
				iActionButton:SetFrameStrata("MEDIUM")
				iActionButton:SetFrameLevel(3)
				ClassicUI.LayoutActionButton(iActionButton, 0)
			end
		end
	end
	function CUI_MainMenuBar:RelocateButtons()
		ActionButton1:ClearAllPoints()
		ActionButton1:SetPoint("BOTTOMLEFT", CUI_MainMenuBarArtFrame, "BOTTOMLEFT", 8, 4)
		local prevActionButton = ActionButton1
		for i = 2, 12 do
			local iActionButton = _G["ActionButton"..i]
			iActionButton:ClearAllPoints()
			iActionButton:SetPoint("LEFT", prevActionButton, "RIGHT", 6, 0)
			prevActionButton = iActionButton
		end
	end
	function CUI_MainMenuBar:RelocateBar()
		CUI_MainMenuBar:ClearAllPoints()
		CUI_MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0 + ClassicUI.db.profile.barsConfig.MainMenuBar.xOffset, 0 + ClassicUI.db.profile.barsConfig.MainMenuBar.yOffset)
	end
	CUI_MainMenuBar:RelocateBar()
	CUI_MainMenuBar:SetSize(1024, 53)
	CUI_MainMenuBar:SetFrameStrata("MEDIUM")
	CUI_MainMenuBar:SetFrameLevel(1)
	CUI_MainMenuBar:EnableMouse(true)
	CUI_MainMenuBar:SetAlpha(1)
	CUI_MainMenuBar:Show()
	CUI_MainMenuBar.hook_SetScale = function(self, scale)
		if (CUI_MainMenuBar.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_MainMenuBar_scale / scale	-- cached db value
			if (mathabs(CUI_MainMenuBar:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_MainMenuBar] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_MainMenuBar] = { self, scale }
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_MainMenuBar:SetScale(newMainScale)
				CUI_MainMenuBar.oldOrigScale = scale
				for i = 1, 12 do
					local iActionButton = _G["ActionButton"..i]
					if (iActionButton ~= nil) then
						iActionButton:SetScale(newMainScale * ClassicUI.cached_ActionButtonInfo.currentScale[iActionButton])
					end
				end
			end
		end
	end
	hooksecurefunc(MainMenuBar, "SetScale", CUI_MainMenuBar.hook_SetScale)
	
	-- [ActionBars] MainMenuBar -> MainMenuBarArtFrame
	local CUI_MainMenuBarArtFrame = CreateFrame("Frame", "CUI_MainMenuBarArtFrame", CUI_MainMenuBar)
	CUI_MainMenuBarArtFrame:SetAllPoints(CUI_MainMenuBar)
	CUI_MainMenuBarArtFrame:SetSize(1024, 53)
	CUI_MainMenuBarArtFrame:SetFrameStrata("MEDIUM")
	CUI_MainMenuBarArtFrame:SetFrameLevel(2)
	CUI_MainMenuBarArtFrame:EnableMouse(false)
	CUI_MainMenuBarArtFrame:SetAlpha(1)
	CUI_MainMenuBarArtFrame:Show()
	
	local CUI_MainMenuBarTexture0 = CUI_MainMenuBarArtFrame:CreateTexture("CUI_MainMenuBarTexture0")
	CUI_MainMenuBarTexture0:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", -384, 0)
	CUI_MainMenuBarTexture0:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
	CUI_MainMenuBarTexture0:SetTexCoord(0/256, 213/256, 0/256, 256/256, 256/256, 213/256, 256/256, 256/256)
	CUI_MainMenuBarTexture0:SetSize(256, 43)
	CUI_MainMenuBarTexture0:SetDrawLayer("BACKGROUND", 0)
	CUI_MainMenuBarTexture0:SetAlpha(1)
	CUI_MainMenuBarTexture0:Show()
	
	local CUI_MainMenuBarTexture1 = CUI_MainMenuBarArtFrame:CreateTexture("CUI_MainMenuBarTexture1")
	CUI_MainMenuBarTexture1:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", -128, 0)
	CUI_MainMenuBarTexture1:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
	CUI_MainMenuBarTexture1:SetTexCoord(0/256, 149/256, 0/256, 192/256, 256/256, 149/256, 256/256, 192/256)
	CUI_MainMenuBarTexture1:SetSize(256, 43)
	CUI_MainMenuBarTexture1:SetDrawLayer("BACKGROUND", 0)
	CUI_MainMenuBarTexture1:SetAlpha(1)
	CUI_MainMenuBarTexture1:Show()
	
	local CUI_MainMenuBarTexture2 = CUI_MainMenuBarArtFrame:CreateTexture("CUI_MainMenuBarTexture2")
	CUI_MainMenuBarTexture2:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", 128, 0)
	CUI_MainMenuBarTexture2:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-KeyRing")
	CUI_MainMenuBarTexture2:SetTexCoord(0/256, 170/256, 0/256, 256/256, 256/256, 170/256, 256/256, 256/256)
	CUI_MainMenuBarTexture2:SetSize(256, 43)
	CUI_MainMenuBarTexture2:SetDrawLayer("BACKGROUND", 0)
	CUI_MainMenuBarTexture2:SetAlpha(1)
	CUI_MainMenuBarTexture2:Show()
	
	local CUI_MainMenuBarTexture3 = CUI_MainMenuBarArtFrame:CreateTexture("CUI_MainMenuBarTexture3")
	CUI_MainMenuBarTexture3:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", 384, 0)
	CUI_MainMenuBarTexture3:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-KeyRing")
	CUI_MainMenuBarTexture3:SetTexCoord(0/256, 42/256, 0/256, 128/256, 256/256, 42/256, 256/256, 128/256)
	CUI_MainMenuBarTexture3:SetSize(256, 43)
	CUI_MainMenuBarTexture3:SetDrawLayer("BACKGROUND", 0)
	CUI_MainMenuBarTexture3:SetAlpha(1)
	CUI_MainMenuBarTexture3:Show()
	
	local CUI_MainMenuBarMaxLevelBar = CreateFrame("Frame", "CUI_MainMenuBarMaxLevelBar", CUI_MainMenuBar)
	CUI_MainMenuBarMaxLevelBar:SetPoint("TOP", CUI_MainMenuBar, "TOP", 0, -11)
	CUI_MainMenuBarMaxLevelBar:SetSize(1024, 7)
	CUI_MainMenuBarMaxLevelBar:SetFrameStrata("MEDIUM")
	CUI_MainMenuBarMaxLevelBar:SetFrameLevel(2)
	CUI_MainMenuBarMaxLevelBar:EnableMouse(true)
	CUI_MainMenuBarMaxLevelBar:SetAlpha(1)
	
	local CUI_MainMenuMaxLevelBar0 = CUI_MainMenuBarMaxLevelBar:CreateTexture("CUI_MainMenuMaxLevelBar0")
	CUI_MainMenuMaxLevelBar0:SetPoint("BOTTOM", CUI_MainMenuBarMaxLevelBar, "TOP", -384, 0)
	CUI_MainMenuMaxLevelBar0:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-MaxLevel")
	CUI_MainMenuMaxLevelBar0:SetTexCoord(0/256, 0/256, 0/256, 56/256, 256/256, 0/256, 256/256, 56/256)
	CUI_MainMenuMaxLevelBar0:SetSize(256, 7)
	CUI_MainMenuMaxLevelBar0:SetDrawLayer("BACKGROUND", 0)
	CUI_MainMenuMaxLevelBar0:SetAlpha(1)
	CUI_MainMenuMaxLevelBar0:Show()
	
	local CUI_MainMenuMaxLevelBar1 = CUI_MainMenuBarMaxLevelBar:CreateTexture("CUI_MainMenuMaxLevelBar1")
	CUI_MainMenuMaxLevelBar1:SetPoint("LEFT", CUI_MainMenuMaxLevelBar0, "RIGHT", 0, 0)
	CUI_MainMenuMaxLevelBar1:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-MaxLevel")
	CUI_MainMenuMaxLevelBar1:SetTexCoord(0/256, 64/256, 0/256, 120/256, 256/256, 64/256, 256/256, 120/256)
	CUI_MainMenuMaxLevelBar1:SetSize(256, 7)
	CUI_MainMenuMaxLevelBar1:SetDrawLayer("BACKGROUND", 0)
	CUI_MainMenuMaxLevelBar1:SetAlpha(1)
	CUI_MainMenuMaxLevelBar1:Show()
	
	local CUI_MainMenuMaxLevelBar2 = CUI_MainMenuBarMaxLevelBar:CreateTexture("CUI_MainMenuMaxLevelBar2")
	CUI_MainMenuMaxLevelBar2:SetPoint("LEFT", CUI_MainMenuMaxLevelBar1, "RIGHT", 0, 0)
	CUI_MainMenuMaxLevelBar2:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-MaxLevel")
	CUI_MainMenuMaxLevelBar2:SetTexCoord(0/256, 128/256, 0/256, 184/256, 256/256, 128/256, 256/256, 184/256)
	CUI_MainMenuMaxLevelBar2:SetSize(256, 7)
	CUI_MainMenuMaxLevelBar2:SetDrawLayer("BACKGROUND", 0)
	CUI_MainMenuMaxLevelBar2:SetAlpha(1)
	CUI_MainMenuMaxLevelBar2:Show()
	
	local CUI_MainMenuMaxLevelBar3 = CUI_MainMenuBarMaxLevelBar:CreateTexture("CUI_MainMenuMaxLevelBar3")
	CUI_MainMenuMaxLevelBar3:SetPoint("LEFT", CUI_MainMenuMaxLevelBar2, "RIGHT", 0, 0)
	CUI_MainMenuMaxLevelBar3:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-MaxLevel")
	CUI_MainMenuMaxLevelBar3:SetTexCoord(0/256, 192/256, 0/256, 248/256, 256/256, 192/256, 256/256, 248/256)
	CUI_MainMenuMaxLevelBar3:SetSize(256, 7)
	CUI_MainMenuMaxLevelBar3:SetDrawLayer("BACKGROUND", 0)
	CUI_MainMenuMaxLevelBar3:SetAlpha(1)
	CUI_MainMenuMaxLevelBar3:Show()
	
	if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
		CUI_MainMenuBarMaxLevelBar:Show()
	else
		CUI_MainMenuBarMaxLevelBar:Hide()
	end
	
	-- [ActionBars] MainMenuBar -> MainMebuBarPageNumber, ActionBarUpButton and ActionBarDownButton
	CUI_MainMenuBar.ActionBarPageNumber	= MainMenuBar.ActionBarPageNumber
	CUI_MainMenuBar.ActionBarPageNumber:SetParent(CUI_MainMenuBar)
	CUI_MainMenuBar.ActionBarPageNumber:SetFrameStrata("MEDIUM")
	CUI_MainMenuBar.ActionBarPageNumber:SetFrameLevel(3)
	CUI_MainMenuBar.ActionBarPageNumber:SetSize(32, 76)
	CUI_MainMenuBar.ActionBarPageNumber:ClearAllPoints()
	CUI_MainMenuBar.ActionBarPageNumber:SetPoint("CENTER", CUI_MainMenuBarArtFrame, "TOPLEFT", 522, -22)
	CUI_MainMenuBar.ActionBarPageNumber:SetScale(1)
	CUI_MainMenuBar.ActionBarPageNumber:SetShown(true)
	CUI_MainMenuBar.ActionBarPageNumber.Text:SetFontObject("GameFontNormalSmall")
	CUI_MainMenuBar.ActionBarPageNumber.Text:SetDrawLayer("OVERLAY")
	CUI_MainMenuBar.ActionBarPageNumber.Text:ClearAllPoints()
	CUI_MainMenuBar.ActionBarPageNumber.Text:SetPoint("CENTER", CUI_MainMenuBarArtFrame, "CENTER", 30, -5)
	CUI_MainMenuBar.ActionBarPageNumber.Text:SetAlpha(1)
	CUI_MainMenuBar.ActionBarPageNumber.Text:Show()
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetSize(32, 32)
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetHitRectInsets(6, 6, 7, 7)
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetFrameStrata("MEDIUM")
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetFrameLevel(4)
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetNormalTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollUpButton-Up")
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetPushedTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollUpButton-Down")
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetHighlightTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollUpButton-Highlight", "ADD")
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled")
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetAlpha(1)
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:Show()
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetSize(32, 32)
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetHitRectInsets(6, 6, 7, 7)
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetFrameStrata("MEDIUM")
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetFrameLevel(4)
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetNormalTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollDownButton-Up")
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetPushedTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollDownButton-Down")
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetHighlightTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollDownButton-Highlight", "ADD")
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled")
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetAlpha(1)
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:Show(1)
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:ClearAllPoints()
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetPoint("CENTER", CUI_MainMenuBarArtFrame, "TOPLEFT", 522, -22)
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:ClearAllPoints()
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetPoint("CENTER", CUI_MainMenuBarArtFrame, "TOPLEFT", 522, -42)
	
	hooksecurefunc(MainMenuBar, "EditModeSetScale", function(self, newScale)
		self.ActionBarPageNumber:SetScale(1)
	end)
	
	hooksecurefunc(MainMenuBar, "UpdateSystemSettingHideBarScrolling", function(self)
		self.ActionBarPageNumber:SetShown(true)
	end)
	
	-- [ActionBars] MainMenuBar -> MainMenuBarLeftEndCap
	local CUI_MainMenuBarLeftEndCap = CUI_MainMenuBarArtFrame:CreateTexture("CUI_MainMenuBarLeftEndCap")
	function CUI_MainMenuBarLeftEndCap:Init()
		CUI_MainMenuBarLeftEndCap:ClearAllPoints()
		if (ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.model == 1) then
			CUI_MainMenuBarLeftEndCap:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
			CUI_MainMenuBarLeftEndCap:SetTexCoord(0/128, 0/128, 0/128, 128/128, 128/128, 0/128, 128/128, 128/128)
			CUI_MainMenuBarLeftEndCap:SetSize(128, 128)
			CUI_MainMenuBarLeftEndCap:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", -544 + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.xOffset, 0 + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.yOffset)
		elseif (ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.model == 2) then
			CUI_MainMenuBarLeftEndCap:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			CUI_MainMenuBarLeftEndCap:SetAtlas("ui-hud-actionbar-gryphon-left")
			CUI_MainMenuBarLeftEndCap:SetSize(104.5, 98)
			CUI_MainMenuBarLeftEndCap:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", -544 + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.xOffset, -15 + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.yOffset)
		elseif (ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.model == 3) then
			CUI_MainMenuBarLeftEndCap:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			CUI_MainMenuBarLeftEndCap:SetAtlas("ui-hud-actionbar-wyvern-left")
			CUI_MainMenuBarLeftEndCap:SetSize(104.5, 98)
			CUI_MainMenuBarLeftEndCap:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", -544 + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.xOffset, -15 + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.yOffset)
		else
			CUI_MainMenuBarLeftEndCap:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Dwarf")
			CUI_MainMenuBarLeftEndCap:SetTexCoord(0/128, 0/128, 0/128, 128/128, 128/128, 0/128, 128/128, 128/128)
			CUI_MainMenuBarLeftEndCap:SetSize(128, 128)
			CUI_MainMenuBarLeftEndCap:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", -544 + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.xOffset, 0 + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.yOffset)
		end
		CUI_MainMenuBarLeftEndCap:SetDrawLayer("OVERLAY", 5)
		CUI_MainMenuBarLeftEndCap:SetAlpha(ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.alpha)
		CUI_MainMenuBarLeftEndCap:SetScale(ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.scale)
		if (ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.hide) then
			CUI_MainMenuBarLeftEndCap:Hide()
		else
			CUI_MainMenuBarLeftEndCap:Show()
		end
	end
	CUI_MainMenuBarLeftEndCap:Init()
	
	-- [ActionBars] MainMenuBar -> MainMenuBarRightEndCap
	local CUI_MainMenuBarRightEndCap = CUI_MainMenuBarArtFrame:CreateTexture("CUI_MainMenuBarRightEndCap")
	function CUI_MainMenuBarRightEndCap:Init()
		CUI_MainMenuBarRightEndCap:ClearAllPoints()
		if (ClassicUI.db.profile.barsConfig.RightGargoyleFrame.model == 1) then
			CUI_MainMenuBarRightEndCap:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
			CUI_MainMenuBarRightEndCap:SetTexCoord(128/128, 0/128, 128/128, 128/128, 0/128, 0/128, 0/128, 128/128)
			CUI_MainMenuBarRightEndCap:SetSize(128, 128)
			CUI_MainMenuBarRightEndCap:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", 544 + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.xOffset, 0 + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.yOffset)
		elseif (ClassicUI.db.profile.barsConfig.RightGargoyleFrame.model == 2) then
			CUI_MainMenuBarRightEndCap:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			CUI_MainMenuBarRightEndCap:SetAtlas("ui-hud-actionbar-gryphon-right")
			CUI_MainMenuBarRightEndCap:SetSize(104.5, 98)
			CUI_MainMenuBarRightEndCap:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", 549 + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.xOffset, -15 + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.yOffset)
		elseif (ClassicUI.db.profile.barsConfig.RightGargoyleFrame.model == 3) then
			CUI_MainMenuBarRightEndCap:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			CUI_MainMenuBarRightEndCap:SetAtlas("ui-hud-actionbar-wyvern-right")
			CUI_MainMenuBarRightEndCap:SetSize(104.5, 98)
			CUI_MainMenuBarRightEndCap:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", 546 + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.xOffset, -15 + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.yOffset)
		else
			CUI_MainMenuBarRightEndCap:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Dwarf")
			CUI_MainMenuBarRightEndCap:SetTexCoord(128/128, 0/128, 128/128, 128/128, 0/128, 0/128, 0/128, 128/128)
			CUI_MainMenuBarRightEndCap:SetSize(128, 128)
			CUI_MainMenuBarRightEndCap:SetPoint("BOTTOM", CUI_MainMenuBarArtFrame, "BOTTOM", 544 + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.xOffset, 0 + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.yOffset)
		end
		CUI_MainMenuBarRightEndCap:SetDrawLayer("OVERLAY", 5)
		CUI_MainMenuBarRightEndCap:SetAlpha(ClassicUI.db.profile.barsConfig.RightGargoyleFrame.alpha)
		CUI_MainMenuBarRightEndCap:SetScale(ClassicUI.db.profile.barsConfig.RightGargoyleFrame.scale)
		if (ClassicUI.db.profile.barsConfig.RightGargoyleFrame.hide) then
			CUI_MainMenuBarRightEndCap:Hide()
		else
			CUI_MainMenuBarRightEndCap:Show()
		end
	end
	CUI_MainMenuBarRightEndCap:Init()
	
	-- [SpellFlyout] Set the SpellFlyout and SpellFlyoutButtons layout
	SpellFlyout.Background.End:SetAtlas(nil)
	SpellFlyout.Background.End:SetSize(37, 22)
	SpellFlyout.Background.End:SetTexCoord(0.01562500, 0.59375000, 0.74218750, 0.91406250)
	SpellFlyout.Background.End:SetTexture("Interface\\Buttons\\ActionBarFlyoutButton")
	SpellFlyout.Background.HorizontalMiddle:SetAtlas(nil)
	SpellFlyout.Background.HorizontalMiddle:SetSize(32, 37)
	SpellFlyout.Background.HorizontalMiddle:SetTexCoord(0, 1, 0, 0.578125)
	SpellFlyout.Background.HorizontalMiddle:SetTexture("Interface\\Buttons\\ActionBarFlyoutButton-FlyoutMidLeft", true)
	SpellFlyout.Background.VerticalMiddle:SetAtlas(nil)
	SpellFlyout.Background.VerticalMiddle:SetSize(37, 32)
	SpellFlyout.Background.VerticalMiddle:SetTexCoord(0, 0.578125, 0, 1)
	SpellFlyout.Background.VerticalMiddle:SetTexture("Interface\\Buttons\\ActionBarFlyoutButton-FlyoutMid", true, true)
	SpellFlyout.Background.Start:Hide()
	SpellFlyout.Background.Start:SetAlpha(0)
	
	hooksecurefunc(SpellFlyout, "Toggle", function(self, flyoutID, parent, direction, distance, isActionBar, specID, showFullTooltip, reason)
		if (not(self:IsShown()) and self:GetParent() == parent) then
			return
		end
		if (self:IsShown() and self.glyphActivating) then
			return
		end
		local offSpec = specID and (specID ~= 0)
		local _, _, numSlots, isKnown = GetFlyoutInfo(flyoutID)
		if ((not isKnown and not offSpec) or numSlots == 0) then
			return
		end
		if (not direction) then
			direction = "UP"
		end
		if (isActionBar) then
			local actionBar = parent:GetParent()
			direction = actionBar:GetSpellFlyoutDirection()
		end
		local prevButton = nil
		local numButtons = 0
		for i = 1, numSlots do
			local spellID, overrideSpellID, isKnown, _, slotSpecID = GetFlyoutSlotInfo(flyoutID, i)
			local visible = true
			local petIndex, petName = GetCallPetSpellInfo(spellID)
			if (isActionBar and petIndex and (not petName or petName == "")) then
				visible = false
			end
			if (((not offSpec or slotSpecID == 0) and visible and isKnown) or (offSpec and slotSpecID == specID)) then
				local button = _G["SpellFlyoutButton"..numButtons+1]
				if (button ~= nil and button.icon ~= nil and button.icon:GetTexCoord() == 0) then
					-- Init ActionButtonInfo cache for the new SpellFlyoutButton
					if ClassicUI.cached_ActionButtonInfo.hooked_UpdateButtonArt[button] == nil then
						ClassicUI.cached_ActionButtonInfo.hooked_UpdateButtonArt[button] = false
					end
					if ClassicUI.cached_ActionButtonInfo.hooked_UpdateHotkeys[button] == nil then
						ClassicUI.cached_ActionButtonInfo.hooked_UpdateHotkeys[button] = false
					end
					if ClassicUI.cached_ActionButtonInfo.hooked_UpdateFlyout[button] == nil then
						ClassicUI.cached_ActionButtonInfo.hooked_UpdateFlyout[button] = false
					end
					if ClassicUI.cached_ActionButtonInfo.currentScale[button] == nil then
						ClassicUI.cached_ActionButtonInfo.currentScale[button] = 1
					end
					if ClassicUI.cached_ActionButtonInfo.currLayout[button] == nil then
						ClassicUI.cached_ActionButtonInfo.currLayout[button] = 1
					end
					-- Apply the current layout to the new SpellFlyoutButton (delayed if combat lockdown)
					ClassicUI:ActionButtonProtectedApplyLayout(button, 6)
				end
				prevButton = button
				numButtons = numButtons+1
			end
		end
		if (numButtons == 0) then
			return
		end
		self.Background.Start:Hide()
		SetClampedTextureRotation(self.Background.VerticalMiddle, 0)
		SetClampedTextureRotation(self.Background.HorizontalMiddle, 0)
		if (direction == "UP") then
			self.Background.End:SetPoint("TOP", 0, 0)
		elseif (direction == "DOWN") then
			self.Background.End:SetPoint("BOTTOM", 0, 0)
		elseif (direction == "LEFT") then
			self.Background.End:SetPoint("LEFT", 0, 0)
		elseif (direction == "RIGHT") then
			self.Background.End:SetPoint("RIGHT", 0, 0)
		end
		if (direction == "UP" or direction == "DOWN") then
			self:SetWidth(prevButton:GetWidth())
			self:SetHeight((prevButton:GetHeight()+ClassicUI.SPELLFLYOUT_DEFAULT_SPACING) * numButtons - ClassicUI.SPELLFLYOUT_DEFAULT_SPACING + ClassicUI.SPELLFLYOUT_INITIAL_SPACING + ClassicUI.SPELLFLYOUT_FINAL_SPACING)
		else
			self:SetHeight(prevButton:GetHeight())
			self:SetWidth((prevButton:GetWidth()+ClassicUI.SPELLFLYOUT_DEFAULT_SPACING) * numButtons - ClassicUI.SPELLFLYOUT_DEFAULT_SPACING + ClassicUI.SPELLFLYOUT_INITIAL_SPACING + ClassicUI.SPELLFLYOUT_FINAL_SPACING)
		end
		self:SetBorderSize(37)
	end)
	
	-- [ActionBars] MultiBarBottomLeft
	local CUI_MultiBarBottomLeft = CreateFrame("Frame", "CUI_MultiBarBottomLeft", MultiBarBottomLeft)
	function CUI_MultiBarBottomLeft:RelocateBar()
		local yPos
		if not(ClassicUI.db.profile.barsConfig.BottomMultiActionBars.ignoreyOffsetStatusBar) then
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = 12 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = 17 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset
			else
				yPos = 26 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset
			end
		else
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = 12 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = 12 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset1StatusBar
			else
				yPos = 12 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset2StatusBar
			end
		end
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", ClassicUI.db.profile.barsConfig.BottomMultiActionBars.xOffset, yPos)
	end
	function CUI_MultiBarBottomLeft:InitButtons()
		for i = 1, 12 do
			local iMultiBarBottomLeftButton = _G["MultiBarBottomLeftButton"..i]
			if (iMultiBarBottomLeftButton ~= nil) then
				iMultiBarBottomLeftButton:SetFrameStrata("MEDIUM")
				iMultiBarBottomLeftButton:SetFrameLevel(4)
				ClassicUI.LayoutActionButton(iMultiBarBottomLeftButton, 1)
			end
		end
	end
	function CUI_MultiBarBottomLeft:RelocateButtons()
		MultiBarBottomLeftButton1:ClearAllPoints()
		MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
		local prevActionButton = MultiBarBottomLeftButton1
		for i = 2, 12 do
			local iMultiBarBottomLeftButton = _G["MultiBarBottomLeftButton"..i]
			iMultiBarBottomLeftButton:ClearAllPoints()
			iMultiBarBottomLeftButton:SetPoint("LEFT", prevActionButton, "RIGHT", 6, 0)
			prevActionButton = iMultiBarBottomLeftButton
		end
	end
	CUI_MultiBarBottomLeft:RelocateBar()
	CUI_MultiBarBottomLeft:SetSize(500, 38)
	CUI_MultiBarBottomLeft:SetFrameStrata("MEDIUM")
	CUI_MultiBarBottomLeft:SetFrameLevel(3)
	CUI_MultiBarBottomLeft:EnableMouse(false)
	CUI_MultiBarBottomLeft:SetAlpha(1)
	CUI_MultiBarBottomLeft:Show()
	CUI_MultiBarBottomLeft.hook_SetScale = function(self, scale)
		if (CUI_MultiBarBottomLeft.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_scale / scale	-- cached db value
			if (mathabs(CUI_MultiBarBottomLeft:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomLeft] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomLeft] = { self, scale }
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_MultiBarBottomLeft:SetScale(newMainScale)
				CUI_MultiBarBottomLeft.oldOrigScale = scale
				for i = 1, 12 do
					local iMultiBarBottomLeftButton = _G["MultiBarBottomLeftButton"..i]
					if (iMultiBarBottomLeftButton ~= nil) then
						iMultiBarBottomLeftButton:SetScale(newMainScale * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarBottomLeftButton])
					end
				end
			end
		end
	end
	hooksecurefunc(MultiBarBottomLeft, "SetScale", CUI_MultiBarBottomLeft.hook_SetScale)
	
	-- [ActionBars] MultiBarBottomRight
	local CUI_MultiBarBottomRight = CreateFrame("Frame", "CUI_MultiBarBottomRight", MultiBarBottomRight)
	function CUI_MultiBarBottomRight:RelocateBar()
		self:ClearAllPoints()
		self:SetPoint("LEFT", CUI_MultiBarBottomLeft, "RIGHT", 10, 0)
	end
	function CUI_MultiBarBottomRight:InitButtons()
		for i = 1, 12 do
			local iMultiBarBottomRightButton = _G["MultiBarBottomRightButton"..i]
			if (iMultiBarBottomRightButton ~= nil) then
				iMultiBarBottomRightButton:SetFrameStrata("MEDIUM")
				iMultiBarBottomRightButton:SetFrameLevel(4)
				ClassicUI.LayoutActionButton(iMultiBarBottomRightButton, 1)
			end
		end
	end
	function CUI_MultiBarBottomRight:RelocateButtons()
		MultiBarBottomRightButton1:ClearAllPoints()
		MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
		local prevActionButton = MultiBarBottomRightButton1
		for i = 2, 12 do
			local iMultiBarBottomRightButton = _G["MultiBarBottomRightButton"..i]
			iMultiBarBottomRightButton:ClearAllPoints()
			iMultiBarBottomRightButton:SetPoint("LEFT", prevActionButton, "RIGHT", 6, 0)
			prevActionButton = iMultiBarBottomRightButton
		end
	end
	CUI_MultiBarBottomRight:RelocateBar()
	CUI_MultiBarBottomRight:SetSize(500, 38)
	CUI_MultiBarBottomRight:SetFrameStrata("MEDIUM")
	CUI_MultiBarBottomRight:SetFrameLevel(3)
	CUI_MultiBarBottomRight:EnableMouse(false)
	CUI_MultiBarBottomRight:SetAlpha(1)
	CUI_MultiBarBottomRight:Show()
	CUI_MultiBarBottomRight.hook_SetScale = function(self, scale)
		if (CUI_MultiBarBottomRight.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_scale / scale	-- cached db value
			if (mathabs(CUI_MultiBarBottomRight:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomRight] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomRight] = { self, scale }
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_MultiBarBottomRight:SetScale(newMainScale)
				CUI_MultiBarBottomRight.oldOrigScale = scale
				for i = 1, 12 do
					local iMultiBarBottomRightButton = _G["MultiBarBottomRightButton"..i]
					if (iMultiBarBottomRightButton ~= nil) then
						iMultiBarBottomRightButton:SetScale(newMainScale * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarBottomRightButton])
					end
				end
			end
		end
	end
	hooksecurefunc(MultiBarBottomRight, "SetScale", CUI_MultiBarBottomRight.hook_SetScale)
	
	-- [ActionBars] MultiBarRight
	local CUI_MultiBarRight = CreateFrame("Frame", "CUI_MultiBarRight", MultiBarRight)
	function CUI_MultiBarRight:RelocateBar()
		local yPos
		if not(ClassicUI.db.profile.barsConfig.RightMultiActionBars.ignoreyOffsetStatusBar) then
			if (ClassicUI.cached_NumberRealVisibleBars <= 1) then
				yPos = 98 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset
			else
				yPos = 107 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset
			end
		else
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = 98 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset1StatusBar
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = 98 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset1StatusBar
			else
				yPos = 98 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset2StatusBar
			end
		end
		self:ClearAllPoints()
		self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", ClassicUI.db.profile.barsConfig.RightMultiActionBars.xOffset, yPos)
	end
	function CUI_MultiBarRight:InitButtons()
		for i = 1, 12 do
			local iMultiBarRightButton = _G["MultiBarRightButton"..i]
			if (iMultiBarRightButton ~= nil) then
				iMultiBarRightButton:SetFrameStrata("MEDIUM")
				iMultiBarRightButton:SetFrameLevel(4)
				ClassicUI.LayoutActionButton(iMultiBarRightButton, 2)
			end
		end
	end
	function CUI_MultiBarRight:RelocateButtons()
		MultiBarRightButton1:ClearAllPoints()
		MultiBarRightButton1:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
		local prevActionButton = MultiBarRightButton1
		for i = 2, 12 do
			local iMultiBarRightButton = _G["MultiBarRightButton"..i]
			iMultiBarRightButton:ClearAllPoints()
			iMultiBarRightButton:SetPoint("TOP", prevActionButton, "BOTTOM", 0, -6)
			prevActionButton = iMultiBarRightButton
		end
	end
	CUI_MultiBarRight:RelocateBar()
	CUI_MultiBarRight:SetSize(38, 500)
	CUI_MultiBarRight:SetFrameStrata("MEDIUM")
	CUI_MultiBarRight:SetFrameLevel(3)
	CUI_MultiBarRight:EnableMouse(false)
	CUI_MultiBarRight:SetAlpha(1)
	CUI_MultiBarRight:Show()
	CUI_MultiBarRight.hook_SetScale = function(self, scale)
		if (CUI_MultiBarRight.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_scale / scale	-- cached db value
			if (mathabs(CUI_MultiBarRight:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarRight] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarRight] = { self, scale }
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_MultiBarRight:SetScale(newMainScale)
				CUI_MultiBarRight.oldOrigScale = scale
				for i = 1, 12 do
					local iMultiBarRightButton = _G["MultiBarRightButton"..i]
					if (iMultiBarRightButton ~= nil) then
						iMultiBarRightButton:SetScale(newMainScale * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarRightButton])
					end
				end
			end
		end
	end
	hooksecurefunc(MultiBarRight, "SetScale", CUI_MultiBarRight.hook_SetScale)
	
	-- [ActionBars] MultiBarLeft
	local CUI_MultiBarLeft = CreateFrame("Frame", "CUI_MultiBarLeft", MultiBarLeft)
	function CUI_MultiBarLeft:RelocateBar()
		self:ClearAllPoints()
		self:SetPoint("TOPRIGHT", CUI_MultiBarRight, "TOPLEFT", -5, 0)
	end
	function CUI_MultiBarLeft:InitButtons()
		for i = 1, 12 do
			local iMultiBarLeftButton = _G["MultiBarLeftButton"..i]
			if (iMultiBarLeftButton ~= nil) then
				iMultiBarLeftButton:SetFrameStrata("MEDIUM")
				iMultiBarLeftButton:SetFrameLevel(4)
				ClassicUI.LayoutActionButton(iMultiBarLeftButton, 2)
			end
		end
	end
	function CUI_MultiBarLeft:RelocateButtons()
		MultiBarLeftButton1:ClearAllPoints()
		MultiBarLeftButton1:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
		local prevActionButton = MultiBarLeftButton1
		for i = 2, 12 do
			local iMultiBarLeftButton = _G["MultiBarLeftButton"..i]
			iMultiBarLeftButton:ClearAllPoints()
			iMultiBarLeftButton:SetPoint("TOP", prevActionButton, "BOTTOM", 0, -6)
			prevActionButton = iMultiBarLeftButton
		end
	end
	CUI_MultiBarLeft:RelocateBar()
	CUI_MultiBarLeft:SetSize(38, 500)
	CUI_MultiBarLeft:SetFrameStrata("MEDIUM")
	CUI_MultiBarLeft:SetFrameLevel(3)
	CUI_MultiBarLeft:EnableMouse(false)
	CUI_MultiBarLeft:SetAlpha(1)
	CUI_MultiBarLeft:Show()
	CUI_MultiBarLeft.hook_SetScale = function(self, scale)
		if (CUI_MultiBarLeft.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_scale / scale	-- cached db value
			if (mathabs(CUI_MultiBarLeft:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarLeft] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarLeft] = { self, scale }
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_MultiBarLeft:SetScale(newMainScale)
				CUI_MultiBarLeft.oldOrigScale = scale
				for i = 1, 12 do
					local iMultiBarLeftButton = _G["MultiBarLeftButton"..i]
					if (iMultiBarLeftButton ~= nil) then
						iMultiBarLeftButton:SetScale(newMainScale * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarLeftButton])
					end
				end
			end
		end
	end
	hooksecurefunc(MultiBarLeft, "SetScale", CUI_MultiBarLeft.hook_SetScale)
	
	-- [ActionBars] PetActionBarFrame (a.k.a. PetActionBar)
	local CUI_PetActionBarFrame = CreateFrame("Frame", "CUI_PetActionBarFrame", PetActionBar)
	CUI_PetActionBarFrame.PETACTIONBAR_XPOS = 36
	
	local CUI_SlidingActionBarTexture0 = CUI_PetActionBarFrame:CreateTexture("CUI_SlidingActionBarTexture0")
	CUI_SlidingActionBarTexture0:SetPoint("TOPLEFT", CUI_PetActionBarFrame, "TOPLEFT", 0, 0)
	CUI_SlidingActionBarTexture0:SetTexture("Interface\\PetActionBar\\UI-PetBar")
	CUI_SlidingActionBarTexture0:SetTexCoord(0/256, 4/256, 0/256, 92/256, 256/256, 4/256, 256/256, 92/256)
	CUI_SlidingActionBarTexture0:SetSize(256, 44)
	CUI_SlidingActionBarTexture0:SetDrawLayer("OVERLAY", 0)
	CUI_SlidingActionBarTexture0:SetAlpha(1)
	CUI_SlidingActionBarTexture0:Hide()
	
	local CUI_SlidingActionBarTexture1 = CUI_PetActionBarFrame:CreateTexture("CUI_SlidingActionBarTexture1")
	CUI_SlidingActionBarTexture1:SetPoint("LEFT", CUI_SlidingActionBarTexture0, "RIGHT", 0, 0)
	CUI_SlidingActionBarTexture1:SetTexture("Interface\\PetActionBar\\UI-PetBar")
	CUI_SlidingActionBarTexture1:SetTexCoord(0/256, 96/256, 0/256, 184/256, 184/256, 96/256, 184/256, 184/256)
	CUI_SlidingActionBarTexture1:SetSize(184, 44)
	CUI_SlidingActionBarTexture1:SetDrawLayer("OVERLAY", 0)
	CUI_SlidingActionBarTexture1:SetAlpha(1)
	CUI_SlidingActionBarTexture1:Hide()
	
	function CUI_PetActionBarFrame:IsAboveStance(ignoreShowing)
		return (((StanceBar and GetNumShapeshiftForms() > 0) or (MultiCastActionBarFrame and HasMultiCastActionBar()) or
			(MainMenuBarVehicleLeaveButton and MainMenuBarVehicleLeaveButton:IsShown() and (MainMenuBarVehicleLeaveButton:GetRight() ~= nil))) and
			(not MultiBarBottomLeft:IsShown() and MultiBarBottomRight:IsShown()) and
			(ignoreShowing or (PetActionBarFrame and PetActionBarFrame:IsShown())))
	end
	function CUI_PetActionBarFrame:UpdateXPositionValue()
		if (CUI_PetActionBarFrame:IsAboveStance(true)) then
			self.PETACTIONBAR_XPOS = 36 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffset
		elseif (MainMenuBarVehicleLeaveButton and MainMenuBarVehicleLeaveButton:IsShown() and (MainMenuBarVehicleLeaveButton:GetRight() ~= nil)) then
			self.PETACTIONBAR_XPOS = MainMenuBarVehicleLeaveButton:GetRight() + 20 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffsetIfStanceBar
		elseif (StanceBar and GetNumShapeshiftForms() > 0) then
			self.PETACTIONBAR_XPOS = 500 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffsetIfStanceBar
		elseif (MultiCastActionBarFrame and HasMultiCastActionBar()) then
			self.PETACTIONBAR_XPOS = 500 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffsetIfStanceBar
		else
			self.PETACTIONBAR_XPOS = 36 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffset
		end
	end
	function CUI_PetActionBarFrame:RelocateBar(forceActionBarState)
		if ((forceActionBarState or ActionBarController_GetCurrentActionBarState()) == LE_ACTIONBAR_STATE_OVERRIDE) then
			if not(ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnOverrideActionBar) then
				if ((ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnPetBattleFrameBar) and not(self:IsShown())) then
					self:Show()
				end
				self:ClearAllPoints()
				self:SetPoint("BOTTOM", OverrideActionBar, "TOP", 31, 23)
			else
				if (self:IsShown()) then
					self:Hide()
				end
			end
			if (CUI_SlidingActionBarTexture0:IsShown()) then
				CUI_SlidingActionBarTexture0:Hide()
				CUI_SlidingActionBarTexture1:Hide()
			end
		elseif (C_PetBattles.IsInBattle()) then
			if not(ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnPetBattleFrameBar) then
				if ((ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnOverrideActionBar) and not(self:IsShown())) then
					self:Show()
				end
				self:ClearAllPoints()
				self:SetPoint("BOTTOM", PetBattleFrame.BottomFrame, "TOP", 31, 13)
			else
				if (self:IsShown()) then
					self:Hide()
				end
			end
			if (CUI_SlidingActionBarTexture0:IsShown()) then
				CUI_SlidingActionBarTexture0:Hide()
				CUI_SlidingActionBarTexture1:Hide()
			end
		else
			if (((ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnOverrideActionBar) or (ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnPetBattleFrameBar)) and not(self:IsShown())) then
				self:Show()
			end
			self:UpdateXPositionValue()
			self:ClearAllPoints()
			local show_multi_action_bar_1 = MultiBarBottomLeft:IsShown()
			local yPos = (show_multi_action_bar_1) and ClassicUI.ACTION_BAR_OFFSET or 0
			if not(ClassicUI.db.profile.barsConfig.PetActionBarFrame.ignoreyOffsetStatusBar) then
				if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
					yPos = yPos + 92 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset
				elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
					yPos = yPos + 97 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset
				else
					yPos = yPos + 106 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset
				end
			else
				if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
					yPos = yPos + 92 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset
				elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
					yPos = yPos + 92 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset1StatusBar
				else
					yPos = yPos + 92 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset2StatusBar
				end
			end
			self:SetPoint("TOPLEFT", CUI_MainMenuBar, "BOTTOMLEFT", self.PETACTIONBAR_XPOS, yPos)
			if (show_multi_action_bar_1) then
				if (CUI_SlidingActionBarTexture0:IsShown()) then
					CUI_SlidingActionBarTexture0:Hide()
					CUI_SlidingActionBarTexture1:Hide()
				end
			else
				if not(CUI_SlidingActionBarTexture0:IsShown()) then
					CUI_SlidingActionBarTexture0:Show()
					CUI_SlidingActionBarTexture1:Show()
				end
			end
		end
	end
	function CUI_PetActionBarFrame:InitButtons()
		for i = 1, 10 do
			local iPetActionButton = _G["PetActionButton"..i]
			if (iPetActionButton ~= nil) then
				iPetActionButton:SetParent(self)
				iPetActionButton:SetFrameStrata("MEDIUM")
				iPetActionButton:SetFrameLevel(3)
				iPetActionButton:SetScale(1)
				ClassicUI.LayoutActionButton(iPetActionButton, 3)
			end
		end
	end
	function CUI_PetActionBarFrame:RelocateButtons()
		PetActionButton1:ClearAllPoints()
		PetActionButton1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 36, 2)
		PetActionButton2:ClearAllPoints()
		PetActionButton2:SetPoint("LEFT", PetActionButton1, "RIGHT", 8, 0)
		PetActionButton3:ClearAllPoints()
		PetActionButton3:SetPoint("LEFT", PetActionButton2, "RIGHT", 8, 0)
		PetActionButton4:ClearAllPoints()
		PetActionButton4:SetPoint("LEFT", PetActionButton3, "RIGHT", 8, 0)
		PetActionButton5:ClearAllPoints()
		PetActionButton5:SetPoint("LEFT", PetActionButton4, "RIGHT", 8, 0)
		PetActionButton6:ClearAllPoints()
		PetActionButton6:SetPoint("LEFT", PetActionButton5, "RIGHT", 8, 0)
		PetActionButton7:ClearAllPoints()
		PetActionButton7:SetPoint("LEFT", PetActionButton6, "RIGHT", ClassicUI.db.profile.barsConfig.PetActionBarFrame.normalizeButtonsSpacing and 8 or 7, 0)
		PetActionButton8:ClearAllPoints()
		PetActionButton8:SetPoint("LEFT", PetActionButton7, "RIGHT", 8, 0)
		PetActionButton9:ClearAllPoints()
		PetActionButton9:SetPoint("LEFT", PetActionButton8, "RIGHT", 8, 0)
		PetActionButton10:ClearAllPoints()
		PetActionButton10:SetPoint("LEFT", PetActionButton9, "RIGHT", 8, 0)
	end
	CUI_PetActionBarFrame:RelocateBar()
	CUI_PetActionBarFrame:SetSize(509, 43)
	CUI_PetActionBarFrame:SetFrameStrata("LOW")
	CUI_PetActionBarFrame:SetFrameLevel(2)
	CUI_PetActionBarFrame:EnableMouse(false)
	CUI_PetActionBarFrame:SetAlpha(1)
	CUI_PetActionBarFrame:Show()
	CUI_PetActionBarFrame.hook_SetScale = function(self, scale)
		if (CUI_PetActionBarFrame.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_scale / scale	-- cached db value
			if (mathabs(CUI_PetActionBarFrame:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_PetActionBarFrame] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_PetActionBarFrame] = { self, scale }
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_PetActionBarFrame:SetScale(newMainScale)
				CUI_PetActionBarFrame.oldOrigScale = scale
			end
		end
	end
	hooksecurefunc(PetActionBar, "SetScale", CUI_PetActionBarFrame.hook_SetScale)
	OverrideActionBar:HookScript("OnShow", function(self)
		if InCombatLockdown() then
			delayFunc_CUI_PetActionBarFrame_RelocateBar_Update = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		CUI_PetActionBarFrame:RelocateBar(LE_ACTIONBAR_STATE_OVERRIDE)
	end)
	OverrideActionBar:HookScript("OnHide", function(self)
		if InCombatLockdown() then
			delayFunc_CUI_PetActionBarFrame_RelocateBar_Update = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		CUI_PetActionBarFrame:RelocateBar(LE_ACTIONBAR_STATE_MAIN)
	end)
	PetBattleFrame.BottomFrame:HookScript("OnShow", function(self)
		if InCombatLockdown() then
			delayFunc_CUI_PetActionBarFrame_RelocateBar_Update = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		CUI_PetActionBarFrame:RelocateBar(LE_ACTIONBAR_STATE_MAIN)
	end)
	PetBattleFrame.BottomFrame:HookScript("OnHide", function(self)
		if InCombatLockdown() then
			delayFunc_CUI_PetActionBarFrame_RelocateBar_Update = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		CUI_PetActionBarFrame:RelocateBar(LE_ACTIONBAR_STATE_MAIN)
	end)
	hooksecurefunc(MainMenuBarVehicleLeaveButton, "UpdateShownState", function(self)
		if InCombatLockdown() then
			delayFunc_CUI_PetActionBarFrame_RelocateBar_Update = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		CUI_PetActionBarFrame:RelocateBar()
	end)
	
	-- [ActionBars] PossessBarFrame (a.k.a. PossessActionBar)
	local CUI_PossessBarFrame = CreateFrame("Frame", "CUI_PossessBarFrame", PossessActionBar)
	
	local CUI_PossessBackground1 = CUI_PossessBarFrame:CreateTexture("CUI_PossessBackground1")
	CUI_PossessBackground1:SetPoint("BOTTOMLEFT", CUI_PossessBarFrame, "BOTTOMLEFT", 0, 0)
	CUI_PossessBackground1:SetTexture("Interface\\ShapeshiftBar\\ShapeshiftBar")
	CUI_PossessBackground1:SetTexCoord(0, 0, 0, 0.29687, 0.734375, 0, 0.734375, 0.29687)
	CUI_PossessBackground1:SetSize(47, 38)
	CUI_PossessBackground1:SetDrawLayer("BACKGROUND", 0)
	CUI_PossessBackground1:SetAlpha(1)
	CUI_PossessBackground1:Hide()
	
	local CUI_PossessBackground2 = CUI_PossessBarFrame:CreateTexture("CUI_PossessBackground2")
	CUI_PossessBackground2:SetPoint("LEFT", CUI_PossessBackground1, "RIGHT", 0, 0)
	CUI_PossessBackground2:SetTexture("Interface\\ShapeshiftBar\\ShapeshiftBar")
	CUI_PossessBackground2:SetTexCoord(0.328125, 0.3125, 0.328125, 0.6015625, 1, 0.3125, 1, 0.6015625)
	CUI_PossessBackground2:SetSize(43, 38)
	CUI_PossessBackground2:SetDrawLayer("BORDER", 0)
	CUI_PossessBackground2:SetAlpha(1)
	CUI_PossessBackground2:Hide()
	
	function CUI_PossessBarFrame:RelocateBar()
		local show_multi_action_bar_1 = MultiBarBottomLeft:IsShown()
		local yPos = (show_multi_action_bar_1) and ClassicUI.ACTION_BAR_OFFSET or 0
		if not(ClassicUI.db.profile.barsConfig.PossessBarFrame.ignoreyOffsetStatusBar) then
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = yPos - 5 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = yPos + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
			else
				yPos = yPos + 9 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
			end
		else
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = yPos - 5 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = yPos - 5 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset1StatusBar
			else
				yPos = yPos - 5 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset2StatusBar
			end
		end
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", CUI_MainMenuBar, "TOPLEFT", 30 + ClassicUI.db.profile.barsConfig.PossessBarFrame.xOffset, yPos)
		local _, _, enabled = GetPossessInfo(1)
		if (enabled) then
			CUI_PossessBackground1:Show()
		else
			CUI_PossessBackground1:Hide()
		end
		_, _, enabled = GetPossessInfo(2)
		if (enabled) then
			CUI_PossessBackground2:Show()
		else
			CUI_PossessBackground2:Hide()
		end
	end
	function CUI_PossessBarFrame:InitButtons()
		if (PossessButton1 ~= nil) then
			PossessButton1:SetParent(self)
			PossessButton1:SetFrameStrata("MEDIUM")
			PossessButton1:SetFrameLevel(3)
			PossessButton1:SetScale(1)
			ClassicUI.LayoutActionButton(PossessButton1, 5)
		end
		if (PossessButton2 ~= nil) then
			PossessButton2:SetParent(self)
			PossessButton2:SetFrameStrata("MEDIUM")
			PossessButton2:SetFrameLevel(3)
			PossessButton2:SetScale(1)
			ClassicUI.LayoutActionButton(PossessButton2, 5)
		end
	end
	function CUI_PossessBarFrame:RelocateButtons()
		PossessButton1:ClearAllPoints()
		PossessButton1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 10, 3)
		PossessButton2:ClearAllPoints()
		PossessButton2:SetPoint("LEFT", PossessButton1, "RIGHT", 8, 0)
	end
	CUI_PossessBarFrame:RelocateBar()
	CUI_PossessBarFrame:SetSize(29, 32)
	CUI_PossessBarFrame:SetFrameStrata("MEDIUM")
	CUI_PossessBarFrame:SetFrameLevel(2)
	CUI_PossessBarFrame:EnableMouse(true)
	CUI_PossessBarFrame:SetAlpha(1)
	CUI_PossessBarFrame:Show()
	CUI_PossessBarFrame.hook_SetScale = function(self, scale)
		if (CUI_PossessBarFrame.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_scale / scale	-- cached db value
			if (mathabs(CUI_PossessBarFrame:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_PossessBarFrame] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_PossessBarFrame] = { self, scale }
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_PossessBarFrame:SetScale(newMainScale)
				CUI_PossessBarFrame.oldOrigScale = scale
			end
		end
	end
	hooksecurefunc(PossessActionBar, "SetScale", CUI_PossessBarFrame.hook_SetScale)
	
	-- [ActionBars] StanceBarFrame (a.k.a. StanceBar)
	local CUI_StanceBarFrame = CreateFrame("Frame", "CUI_StanceBarFrame", StanceBar)
	
	local CUI_StanceBarLeft = CUI_StanceBarFrame:CreateTexture("CUI_StanceBarLeft")
	CUI_StanceBarLeft:SetPoint("BOTTOMLEFT", CUI_StanceBarFrame, "BOTTOMLEFT", 0, 0)
	CUI_StanceBarLeft:SetTexture("Interface\\ShapeshiftBar\\ShapeshiftBar")
	CUI_StanceBarLeft:SetTexCoord(0, 0, 0, 0.29687, 0.734375, 0, 0.734375, 0.29687)
	CUI_StanceBarLeft:SetSize(47, 38)
	CUI_StanceBarLeft:SetDrawLayer("BACKGROUND", 0)
	CUI_StanceBarLeft:SetAlpha(1)
	CUI_StanceBarLeft:Hide()
	
	local CUI_StanceBarMiddle = CUI_StanceBarFrame:CreateTexture("CUI_StanceBarMiddle")
	CUI_StanceBarMiddle:SetPoint("LEFT", CUI_StanceBarLeft, "RIGHT", 0, 0)
	CUI_StanceBarMiddle:SetTexture("Interface\\ShapeshiftBar\\ShapeshiftBarMiddle", true)
	CUI_StanceBarMiddle:SetTexCoord(0, 0, 0, 1, 2, 0, 2, 1)
	CUI_StanceBarMiddle:SetSize(37, 38)
	CUI_StanceBarMiddle:SetDrawLayer("BACKGROUND", 0)
	CUI_StanceBarMiddle:SetAlpha(1)
	CUI_StanceBarMiddle:Hide()
	
	local CUI_StanceBarRight = CUI_StanceBarFrame:CreateTexture("CUI_StanceBarRight")
	CUI_StanceBarRight:SetPoint("LEFT", CUI_StanceBarMiddle, "RIGHT", 0, 0)
	CUI_StanceBarRight:SetTexture("Interface\\ShapeshiftBar\\ShapeshiftBar")
	CUI_StanceBarRight:SetTexCoord(0.328125, 0.3125, 0.328125, 0.6015625, 1, 0.3125, 1, 0.6015625)
	CUI_StanceBarRight:SetSize(43, 38)
	CUI_StanceBarRight:SetDrawLayer("BORDER", 0)
	CUI_StanceBarRight:SetAlpha(1)
	CUI_StanceBarRight:Hide()
	
	function CUI_StanceBarFrame:RelocateBar()
		local show_multi_action_bar_1 = MultiBarBottomLeft:IsShown()
		local yPos = (show_multi_action_bar_1) and ClassicUI.ACTION_BAR_OFFSET or 0
		if not(ClassicUI.db.profile.barsConfig.StanceBarFrame.ignoreyOffsetStatusBar) then
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = yPos - 5 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = yPos + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
			else
				yPos = yPos + 9 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
			end
		else
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = yPos - 5 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = yPos - 5 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset1StatusBar
			else
				yPos = yPos - 5 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset2StatusBar
			end

		end
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", CUI_MainMenuBar, "TOPLEFT", 30 + ClassicUI.db.profile.barsConfig.StanceBarFrame.xOffset, yPos)
		if (show_multi_action_bar_1) then
			if CUI_StanceBarLeft:IsShown() then CUI_StanceBarLeft:Hide() end
			if CUI_StanceBarMiddle:IsShown() then CUI_StanceBarMiddle:Hide() end
			if CUI_StanceBarRight:IsShown() then CUI_StanceBarRight:Hide() end
			if not(ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle == 1) then
				for i = 1, 10 do
					_G["StanceButton"..i]:GetNormalTexture():SetSize(52, 52)
				end
			end
		else
			local numForms = GetNumShapeshiftForms()
			if (numForms > 0) then
				if not(CUI_StanceBarLeft:IsShown()) then CUI_StanceBarLeft:Show() end
				if not(CUI_StanceBarRight:IsShown()) then CUI_StanceBarRight:Show() end
				if (numForms == 1) then
					if CUI_StanceBarMiddle:IsShown() then CUI_StanceBarMiddle:Hide() end
					CUI_StanceBarRight:SetPoint("LEFT", CUI_StanceBarLeft, "LEFT", 12, 0)
				elseif (numForms == 2) then
					if CUI_StanceBarMiddle:IsShown() then CUI_StanceBarMiddle:Hide() end
					CUI_StanceBarRight:SetPoint("LEFT", CUI_StanceBarLeft, "RIGHT", 1, 0)
				else
					if not(CUI_StanceBarMiddle:IsShown()) then CUI_StanceBarMiddle:Show() end
					CUI_StanceBarMiddle:SetPoint("LEFT", CUI_StanceBarLeft, "RIGHT", 0, 0)
					CUI_StanceBarMiddle:SetWidth(37 * (numForms-2))
					CUI_StanceBarMiddle:SetTexCoord(0, numForms-2, 0, 1)
					CUI_StanceBarRight:SetPoint("LEFT", CUI_StanceBarMiddle, "RIGHT", 0, 0)
				end
			end
			if not(ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle == 1) then
				for i = 1, 10 do
					_G["StanceButton"..i]:GetNormalTexture():SetSize(64, 64)
				end
			end
		end
	end
	function CUI_StanceBarFrame:InitButtons()
		for i = 1, 10 do
			local iStanceButton = _G["StanceButton"..i]
			if (iStanceButton ~= nil) then
				iStanceButton:SetParent(self)
				iStanceButton:SetFrameStrata("MEDIUM")
				iStanceButton:SetFrameLevel(3)
				iStanceButton:SetScale(1)
				ClassicUI.LayoutActionButton(iStanceButton, 4)
			end
		end
	end
	function CUI_StanceBarFrame:RelocateButtons()
		StanceButton1:ClearAllPoints()
		StanceButton1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 11, 3)
		local prevActionButton = StanceButton1
		for i = 2, 10 do
			local iStanceButton = _G["StanceButton"..i]
			iStanceButton:ClearAllPoints()
			iStanceButton:SetPoint("LEFT", prevActionButton, "RIGHT", 7, 0)
			prevActionButton = iStanceButton
		end
	end
	CUI_StanceBarFrame:RelocateBar()
	CUI_StanceBarFrame:SetSize(29, 32)
	CUI_StanceBarFrame:SetFrameStrata("MEDIUM")
	CUI_StanceBarFrame:SetFrameLevel(2)
	CUI_StanceBarFrame:EnableMouse(true)
	CUI_StanceBarFrame:SetAlpha(1)
	CUI_StanceBarFrame:Show()
	CUI_StanceBarFrame.hook_SetScale = function(self, scale)
		if (CUI_StanceBarFrame.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_scale / scale	-- cached db value
			if (mathabs(CUI_StanceBarFrame:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_StanceBarFrame] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_StanceBarFrame] = { self, scale }
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_StanceBarFrame:SetScale(newMainScale)
				CUI_StanceBarFrame.oldOrigScale = scale
			end
		end
	end
	hooksecurefunc(StanceBar, "SetScale", CUI_StanceBarFrame.hook_SetScale)
	
	-- [ActionBars] OverrideActionBar
	for i = 1, 6 do
		local iOverrideButton = _G["OverrideActionBarButton"..i]
		if (iOverrideButton ~= nil) then
			ClassicUI.LayoutActionButton(iOverrideButton, 7)
		end
	end
	
	-- Init and Set the position of all ActionButtons
	CUI_MainMenuBar:InitButtons()
	CUI_MainMenuBar:RelocateButtons()
	CUI_MainMenuBar.hook_SetScale(MainMenuBar, MainMenuBar:GetScale())
	CUI_MultiBarBottomLeft:InitButtons()
	CUI_MultiBarBottomLeft:RelocateButtons()
	CUI_MultiBarBottomLeft.hook_SetScale(MultiBarBottomLeft, MultiBarBottomLeft:GetScale())
	CUI_MultiBarBottomRight:InitButtons()
	CUI_MultiBarBottomRight:RelocateButtons()
	CUI_MultiBarBottomRight.hook_SetScale(MultiBarBottomRight, MultiBarBottomRight:GetScale())
	CUI_MultiBarRight:InitButtons()
	CUI_MultiBarRight:RelocateButtons()
	CUI_MultiBarRight.hook_SetScale(MultiBarRight, MultiBarRight:GetScale())
	CUI_MultiBarLeft:InitButtons()
	CUI_MultiBarLeft:RelocateButtons()
	CUI_MultiBarLeft.hook_SetScale(MultiBarLeft, MultiBarLeft:GetScale())
	CUI_PetActionBarFrame:InitButtons()
	CUI_PetActionBarFrame:RelocateButtons()
	CUI_PetActionBarFrame.hook_SetScale(PetActionBar, PetActionBar:GetScale())
	CUI_PossessBarFrame:InitButtons()
	CUI_PossessBarFrame:RelocateButtons()
	CUI_PossessBarFrame.hook_SetScale(PossessActionBar, PossessActionBar:GetScale())
	CUI_StanceBarFrame:InitButtons()
	CUI_StanceBarFrame:RelocateButtons()
	CUI_StanceBarFrame.hook_SetScale(StanceBar, StanceBar:GetScale())
	
	-- We restore the rest of the interface elements (new frames and textures are created if necessary)
	
	-- [MainMenuBarVehicleLeaveButton]
	MainMenuBarVehicleLeaveButton:SetParent(CUI_MainMenuBar)
	MainMenuBarVehicleLeaveButton:SetSize(32, 32)
	MainMenuBarVehicleLeaveButton:SetScale(1)
	MainMenuBarVehicleLeaveButton:SetFrameStrata("MEDIUM")
	MainMenuBarVehicleLeaveButton:SetFrameLevel(2)
	ClassicUI.MainMenuBarVehicleLeaveButton_Relocate = function(self)
		if self:CanExitVehicle() then
			self:ClearAllPoints()
			if (IsPossessBarVisible() and PossessButton2 ~= nil) then
				self:SetPoint("LEFT", PossessButton2, "RIGHT", 30, 0)
			elseif (GetNumShapeshiftForms() > 0) then
				self:SetPoint("LEFT", _G["StanceButton"..GetNumShapeshiftForms()], "RIGHT", 30, 0)
			elseif (HasMultiCastActionBar()) then
				self:SetPoint("LEFT", MultiCastActionBarFrame, "RIGHT", 30, 0)
			else
				self:SetPoint("LEFT", CUI_PossessBarFrame, "LEFT", 10, 0)
			end
		end
	end
	hooksecurefunc(MainMenuBarVehicleLeaveButton, "Update", ClassicUI.MainMenuBarVehicleLeaveButton_Relocate)
	ClassicUI.MainMenuBarVehicleLeaveButton_Relocate(MainMenuBarVehicleLeaveButton)
	
	-- [MicroButtons]
	ClassicUI.mbWidth = 28
	ClassicUI.mbHeight = 38
	ClassicUI.MicroButtonsGroup = {
		[CharacterMicroButton] = 1,
		[SpellbookMicroButton] = 2,
		[TalentMicroButton] = 3,
		[AchievementMicroButton] = 4,
		[QuestLogMicroButton] = 5,
		[GuildMicroButton] = 6,
		[LFDMicroButton] = 7,
		[CollectionsMicroButton] = 8,
		[EJMicroButton] = 9,
		[StoreMicroButton] = 10,
		[MainMenuMicroButton] = 11
	}
	
	MainMenuBar:HookScript("OnShow", function(self)
		UpdateMicroButtonsParent(CUI_MainMenuBarArtFrame)
		MoveMicroButtons("BOTTOMLEFT", CUI_MainMenuBarArtFrame, "BOTTOMLEFT", 556 + ClassicUI.db.profile.barsConfig.MicroButtons.xOffset, 2 + ClassicUI.db.profile.barsConfig.MicroButtons.yOffset, false)
		LFDMicroButton:SetPoint("BOTTOMLEFT", GuildMicroButton, "BOTTOMRIGHT", -3, 0)
	end)
	
	hooksecurefunc(OverrideActionBar, "UpdateMicroButtons", function(self)
		if ActionBarController_GetCurrentActionBarState() == LE_ACTIONBAR_STATE_OVERRIDE then
			local anchorX, anchorY = 542, 41
			if self.HasExit and self.HasPitch then
				anchorX = 625
			elseif self.HasPitch then
				anchorX = 629
			elseif self.HasExit then
				anchorX = 537
			end
			UpdateMicroButtonsParent(self)
			MoveMicroButtons("BOTTOMLEFT", self, "BOTTOMLEFT", anchorX, anchorY, true)
			LFDMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "BOTTOMLEFT", 0, 4)
		end
	end)
	
	PetBattleFrame.BottomFrame.MicroButtonFrame:HookScript("OnShow", function(self)
		MoveMicroButtons("TOPLEFT", self, "TOPLEFT", -11.5, 7.5, true)
		LFDMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "BOTTOMLEFT", 0, 4)
	end)
	
	-- [MicroButtons] CharacterMicroButton
	CharacterMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	CharacterMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	CharacterMicroButton:SetPoint("BOTTOMLEFT", CUI_MainMenuBarArtFrame, "BOTTOMLEFT", 556 + ClassicUI.db.profile.barsConfig.MicroButtons.xOffset, 2 + ClassicUI.db.profile.barsConfig.MicroButtons.yOffset)
	CharacterMicroButton:SetFrameStrata("MEDIUM")
	CharacterMicroButton:SetFrameLevel(3)
	CharacterMicroButton:SetNormalAtlas("hud-microbutton-Character-Up", true)
	CharacterMicroButton:SetPushedAtlas("hud-microbutton-Character-Down", true)
	CharacterMicroButton:SetDisabledAtlas("hud-microbutton-Character-Disabled", true)
	CharacterMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	CharacterMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Up")
	CharacterMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Down")
	CharacterMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	CharacterMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Disabled")
	CharacterMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CharacterMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CharacterMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CharacterMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CharacterMicroButton.FlashBorder:SetSize(34, 44)
	CharacterMicroButton.FlashBorder:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", -2, 3)
	
	-- [MicroButtons] CharacterMicroButton -> Portrait texture
	local CUI_MicroButtonPortrait = CharacterMicroButton:CreateTexture("CUI_MicroButtonPortrait")
	CUI_MicroButtonPortrait:SetPoint("TOP", CharacterMicroButton, "TOP", 0, -7)
	CUI_MicroButtonPortrait:SetTexCoord(0.2, 0.8, 0.0666, 0.9)
	CUI_MicroButtonPortrait:SetAlpha(1)
	CUI_MicroButtonPortrait:SetSize(18, 25)
	CUI_MicroButtonPortrait:SetDrawLayer("OVERLAY", 0)
	hooksecurefunc(CharacterMicroButton, "SetPushed", function(self)
		CUI_MicroButtonPortrait:SetTexCoord(0.2666, 0.8666, 0, 0.8333)
		CUI_MicroButtonPortrait:SetAlpha(0.5)
	end)
	hooksecurefunc(CharacterMicroButton, "SetNormal", function(self)
		CUI_MicroButtonPortrait:SetTexCoord(0.2, 0.8, 0.0666, 0.9)
		CUI_MicroButtonPortrait:SetAlpha(1.0)
	end)
	CharacterMicroButton:HookScript("OnEvent", function(self, event, ...)
		if (event == "UNIT_PORTRAIT_UPDATE") then
			local unit = ...
			if (unit == "player") then
				SetPortraitTexture(CUI_MicroButtonPortrait, "player")
			end
		elseif (event == "PORTRAITS_UPDATED") then
			SetPortraitTexture(CUI_MicroButtonPortrait, "player")
		elseif (event == "PLAYER_ENTERING_WORLD") then
			SetPortraitTexture(CUI_MicroButtonPortrait, "player")
		end
	end)
	CharacterMicroButton:RegisterEvent("PLAYER_ENTERING_WORLD")
	CharacterMicroButton:RegisterEvent("UNIT_PORTRAIT_UPDATE")
	CharacterMicroButton:RegisterEvent("PORTRAITS_UPDATED")
	SetPortraitTexture(CUI_MicroButtonPortrait, "player")
	CUI_MicroButtonPortrait:Show()
	
	-- [MicroButtons] SpellbookMicroButton
	SpellbookMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	SpellbookMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	SpellbookMicroButton:SetPoint("BOTTOMLEFT", CharacterMicroButton, "BOTTOMRIGHT", -2, 0)
	SpellbookMicroButton:SetFrameStrata("MEDIUM")
	SpellbookMicroButton:SetFrameLevel(3)
	SpellbookMicroButton:SetNormalAtlas("hud-microbutton-Spellbook-Up", true)
	SpellbookMicroButton:SetPushedAtlas("hud-microbutton-Spellbook-Down", true)
	SpellbookMicroButton:SetDisabledAtlas("hud-microbutton-Spellbook-Disabled", true)
	SpellbookMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	SpellbookMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Spellbook-Up")
	SpellbookMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-Spellbook-Down")
	SpellbookMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	SpellbookMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-Spellbook-Disabled")
	SpellbookMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	SpellbookMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	SpellbookMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	SpellbookMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	SpellbookMicroButton.FlashBorder:SetSize(34, 44)
	SpellbookMicroButton.FlashBorder:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", -2, 3)
	
	-- [MicroButtons] TalentMicroButton
	TalentMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	TalentMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	TalentMicroButton:SetPoint("BOTTOMLEFT", SpellbookMicroButton, "BOTTOMRIGHT", -2, 0)
	TalentMicroButton:SetFrameStrata("MEDIUM")
	TalentMicroButton:SetFrameLevel(3)
	TalentMicroButton:SetNormalAtlas("hud-microbutton-Talents-Up", true)
	TalentMicroButton:SetPushedAtlas("hud-microbutton-Talents-Down", true)
	TalentMicroButton:SetDisabledAtlas("hud-microbutton-Talents-Disabled", true)
	TalentMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	TalentMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Talents-Up")
	TalentMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-Talents-Down")
	TalentMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	TalentMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-Talents-Disabled")
	TalentMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	TalentMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	TalentMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	TalentMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	TalentMicroButton.FlashBorder:SetSize(34, 44)
	TalentMicroButton.FlashBorder:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", -2, 3)
	
	-- [MicroButtons] AchievementMicroButton
	AchievementMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	AchievementMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	AchievementMicroButton:SetPoint("BOTTOMLEFT", TalentMicroButton, "BOTTOMRIGHT", -2, 0)
	AchievementMicroButton:SetFrameStrata("MEDIUM")
	AchievementMicroButton:SetFrameLevel(3)
	AchievementMicroButton:SetNormalAtlas("hud-microbutton-Achievement-Up", true)
	AchievementMicroButton:SetPushedAtlas("hud-microbutton-Achievement-Down", true)
	AchievementMicroButton:SetDisabledAtlas("hud-microbutton-Achievement-Disabled", true)
	AchievementMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	AchievementMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Achievement-Up")
	AchievementMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-Achievement-Down")
	AchievementMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	AchievementMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-Achievement-Disabled")
	AchievementMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	AchievementMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	AchievementMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	AchievementMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	AchievementMicroButton.FlashBorder:SetSize(34, 44)
	AchievementMicroButton.FlashBorder:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", -2, 3)
	
	-- [MicroButtons] QuestLogMicroButton
	QuestLogMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	QuestLogMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	QuestLogMicroButton:SetPoint("BOTTOMLEFT", AchievementMicroButton, "BOTTOMRIGHT", -2, 0)
	QuestLogMicroButton:SetFrameStrata("MEDIUM")
	QuestLogMicroButton:SetFrameLevel(3)
	QuestLogMicroButton:SetNormalAtlas("hud-microbutton-Quest-Up", true)
	QuestLogMicroButton:SetPushedAtlas("hud-microbutton-Quest-Down", true)
	QuestLogMicroButton:SetDisabledAtlas("hud-microbutton-Quest-Disabled", true)
	QuestLogMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	if not(ClassicUI.db.profile.barsConfig.MicroButtons.useClassicQuestIcon) then
		QuestLogMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Quest-Up")
		QuestLogMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-Quest-Down")
		QuestLogMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-Quest-Disabled")
	else
		QuestLogMicroButton:SetNormalTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Quest-Up-classic")
		QuestLogMicroButton:SetPushedTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Quest-Down-classic")
		QuestLogMicroButton:SetDisabledTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Quest-Disabled-classic")
	end
	QuestLogMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	QuestLogMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	QuestLogMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	QuestLogMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	QuestLogMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	QuestLogMicroButton.FlashBorder:SetSize(34, 44)
	QuestLogMicroButton.FlashBorder:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", -2, 3)
	
	-- [MicroButtons] GuildMicroButton
	GuildMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	GuildMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	GuildMicroButton:SetPoint("BOTTOMLEFT", QuestLogMicroButton, "BOTTOMRIGHT", -2, 0)
	GuildMicroButton:SetFrameStrata("MEDIUM")
	GuildMicroButton:SetFrameLevel(3)
	GuildMicroButton:SetNormalAtlas("hud-microbutton-Socials-Up", true)
	GuildMicroButton:SetPushedAtlas("hud-microbutton-Socials-Down", true)
	GuildMicroButton:SetDisabledAtlas("hud-microbutton-Socials-Disabled", true)
	GuildMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	if not(ClassicUI.db.profile.barsConfig.MicroButtons.useClassicGuildIcon) then
		GuildMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Socials-Up")
		GuildMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-Socials-Down")
		GuildMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-Socials-Disabled")
	else
		GuildMicroButton:SetNormalTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Socials-Up-classic")
		GuildMicroButton:SetPushedTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Socials-Down-classic")
		GuildMicroButton:SetDisabledTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Socials-Disabled-classic")
	end
	GuildMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	GuildMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	GuildMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	GuildMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	GuildMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	GuildMicroButton.FlashBorder:SetSize(34, 44)
	GuildMicroButton.FlashBorder:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", -2, 3)
	GuildMicroButton.NotificationOverlay:SetFrameStrata("MEDIUM")
	GuildMicroButton.NotificationOverlay:SetFrameLevel(500)
	GuildMicroButton.NotificationOverlay.UnreadNotificationIcon:SetAtlas("hud-microbutton-communities-icon-notification")
	GuildMicroButton.NotificationOverlay.UnreadNotificationIcon:SetSize(18, 18)
	GuildMicroButton.NotificationOverlay.UnreadNotificationIcon:ClearAllPoints()
	GuildMicroButton.NotificationOverlay.UnreadNotificationIcon:SetPoint("CENTER", GuildMicroButton.NotificationOverlay, "TOP", 0, -5)
	
	local GuildMicroButtonTabard = CreateFrame("Frame", "GuildMicroButtonTabard", GuildMicroButton)
	GuildMicroButtonTabard:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	GuildMicroButtonTabard:SetPoint("TOPLEFT", GuildMicroButton, "TOPLEFT", 0, 0)
	GuildMicroButtonTabard:CreateTexture("GuildMicroButtonTabardBackground", "ARTWORK")
	GuildMicroButtonTabard:Hide()
	GuildMicroButtonTabard.background = GuildMicroButtonTabardBackground
	GuildMicroButtonTabardBackground:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	GuildMicroButtonTabardBackground:SetTexture("Interface\\Buttons\\UI-MicroButton-Guild-Banner")
	GuildMicroButtonTabardBackground:SetTexCoord(0/32, 32/32, 22/64, 64/64)
	GuildMicroButtonTabardBackground:SetPoint("CENTER", GuildMicroButtonTabard, "CENTER", 0, 0)
	GuildMicroButtonTabard:CreateTexture("GuildMicroButtonTabardEmblem", "OVERLAY")
	GuildMicroButtonTabard.emblem = GuildMicroButtonTabardEmblem
	GuildMicroButtonTabardEmblem:SetTexture("Interface\\GuildFrame\\GuildEmblems_01")
	GuildMicroButtonTabardEmblem:SetDrawLayer("OVERLAY", 1)
	if not(ClassicUI.db.profile.barsConfig.MicroButtons.useBiggerGuildEmblem) then
		GuildMicroButtonTabardEmblem:SetSize(14, 14)
	else
		GuildMicroButtonTabardEmblem:SetSize(16, 16)
	end
	GuildMicroButtonTabardEmblem:SetPoint("CENTER", GuildMicroButtonTabard, "CENTER", 0, 0)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.useClassicGuildIcon) then
		GuildMicroButtonTabardEmblem:SetAlpha(0)
		GuildMicroButtonTabardEmblem:Hide()
		GuildMicroButtonTabardBackground:SetAlpha(0)
		GuildMicroButtonTabardBackground:Hide()
		GuildMicroButtonTabard:SetAlpha(0)
		GuildMicroButtonTabard:Hide()
	end
	
	ClassicUI.GuildMicroButton_UpdateTabard = function(forceUpdate)
		local tabard = GuildMicroButtonTabard
		if ( not tabard.needsUpdate and not forceUpdate ) then
			return
		end
		if not(ClassicUI.db.profile.barsConfig.MicroButtons.useClassicGuildIcon) then
			local emblemFilename = select(10, GetGuildLogoInfo())
			if ( emblemFilename ) then
				if ( not tabard:IsShown() ) then
					local button = GuildMicroButton
					button:SetNormalTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Up")
					button:SetPushedTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Down")
					tabard:Show()
				end
				SetSmallGuildTabardTextures("player", tabard.emblem, tabard.background)
			else
				if ( tabard:IsShown() ) then
					local button = GuildMicroButton
					button:SetDisabledAtlas("hud-microbutton-Socials-Disabled", true)
					button:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Socials-Up")
					button:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-Socials-Down")
					button:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-Socials-Disabled")
					tabard:Hide()
				end
			end
		end
		tabard.needsUpdate = nil
	end
	
	GuildMicroButtonTabard:SetScript("OnEvent", function(self, event, ...)
		if (Kiosk_IsEnabled()) then
			return
		end
		if (event == "PLAYER_GUILD_UPDATE" or event == "NEUTRAL_FACTION_SELECT_RESULT" ) then
			self.needsUpdate = true
			ClassicUI.GuildMicroButton_UpdateTabard()
		end
	end)
	
	hooksecurefunc("UpdateMicroButtons", function(self)
		ClassicUI.GuildMicroButton_UpdateTabard()
		local factionGroup = UnitFactionGroup("player")
		if not( IsCommunitiesUIDisabledByTrialAccount() or factionGroup == "Neutral" or Kiosk_IsEnabled() ) and
		   not( C_Club_IsEnabled() and not BNConnected() ) and
		   not( C_Club_IsEnabled() and C_Club_IsRestricted() ~= Enum.ClubRestrictionReason.None ) and
		      ( CommunitiesFrame and CommunitiesFrame:IsShown() ) or ( GuildFrame and GuildFrame:IsShown() ) then
			GuildMicroButtonTabard:SetPoint("TOPLEFT", -1, -2)
			GuildMicroButtonTabard:SetAlpha(0.70)
		else
			GuildMicroButtonTabard:SetPoint("TOPLEFT", 0, 0)
			GuildMicroButtonTabard:SetAlpha(1)
		end
	end)

	GuildMicroButtonTabard:RegisterEvent("PLAYER_GUILD_UPDATE")
	GuildMicroButtonTabard:RegisterEvent("NEUTRAL_FACTION_SELECT_RESULT")
	ClassicUI.GuildMicroButton_UpdateTabard(true)
	
	-- [MicroButtons] LFDMicroButton
	LFDMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	LFDMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	LFDMicroButton:SetPoint("BOTTOMLEFT", GuildMicroButton, "BOTTOMRIGHT", -3, 0)
	LFDMicroButton:SetFrameStrata("MEDIUM")
	LFDMicroButton:SetFrameLevel(3)
	LFDMicroButton:SetNormalAtlas("hud-microbutton-LFG-Up", true)
	LFDMicroButton:SetPushedAtlas("hud-microbutton-LFG-Down", true)
	LFDMicroButton:SetDisabledAtlas("hud-microbutton-LFG-Disabled", true)
	LFDMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	LFDMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-LFG-Up")
	LFDMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-LFG-Down")
	LFDMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	LFDMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-LFG-Disabled")
	LFDMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	LFDMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	LFDMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	LFDMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	LFDMicroButton.FlashBorder:SetSize(34, 44)
	LFDMicroButton.FlashBorder:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", -2, 3)
	
	-- [MicroButtons] CollectionsMicroButton
	CollectionsMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	CollectionsMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	CollectionsMicroButton:SetPoint("BOTTOMLEFT", LFDMicroButton, "BOTTOMRIGHT", -2, 0)
	CollectionsMicroButton:SetFrameStrata("MEDIUM")
	CollectionsMicroButton:SetFrameLevel(3)
	CollectionsMicroButton:SetNormalAtlas("hud-microbutton-Mounts-Up", true)
	CollectionsMicroButton:SetPushedAtlas("hud-microbutton-Mounts-Down", true)
	CollectionsMicroButton:SetDisabledAtlas("hud-microbutton-Mounts-Disabled", true)
	CollectionsMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	CollectionsMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Mounts-Up")
	CollectionsMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-Mounts-Down")
	CollectionsMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	CollectionsMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-Mounts-Disabled")
	CollectionsMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CollectionsMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CollectionsMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CollectionsMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CollectionsMicroButton.FlashBorder:SetSize(34, 44)
	CollectionsMicroButton.FlashBorder:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", -2, 3)
	
	-- [MicroButtons] EJMicroButton
	EJMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	EJMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	EJMicroButton:SetPoint("BOTTOMLEFT", CollectionsMicroButton, "BOTTOMRIGHT", -2, 0)
	EJMicroButton:SetFrameStrata("MEDIUM")
	EJMicroButton:SetFrameLevel(3)
	EJMicroButton:SetNormalAtlas("hud-microbutton-EJ-Up", true)
	EJMicroButton:SetPushedAtlas("hud-microbutton-EJ-Down", true)
	EJMicroButton:SetDisabledAtlas("hud-microbutton-EJ-Disabled", true)
	EJMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	EJMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-EJ-Up")
	EJMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-EJ-Down")
	EJMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	EJMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-EJ-Disabled")
	EJMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	EJMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	EJMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	EJMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	EJMicroButton.FlashBorder:SetSize(34, 44)
	EJMicroButton.FlashBorder:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", -2, 3)
	
	-- [MicroButtons] StoreMicroButton
	StoreMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	StoreMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	StoreMicroButton:SetPoint("BOTTOMLEFT", EJMicroButton, "BOTTOMRIGHT", -2, 0)
	StoreMicroButton:SetFrameStrata("MEDIUM")
	StoreMicroButton:SetFrameLevel(3)
	StoreMicroButton:SetNormalAtlas("hud-microbutton-BStore-Up", true)
	StoreMicroButton:SetPushedAtlas("hud-microbutton-BStore-Down", true)
	StoreMicroButton:SetDisabledAtlas("hud-microbutton-BStore-Disabled", true)
	StoreMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	StoreMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-BStore-Up")
	StoreMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-BStore-Down")
	StoreMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	StoreMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-BStore-Disabled")
	StoreMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	StoreMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	StoreMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	StoreMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	StoreMicroButton.FlashBorder:SetSize(34, 44)
	StoreMicroButton.FlashBorder:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", -2, 3)
	
	-- [MicroButtons] MainMenuMicroButton
	MainMenuMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	MainMenuMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	MainMenuMicroButton:SetPoint("BOTTOMLEFT", StoreMicroButton, "BOTTOMRIGHT", -3, 0)
	MainMenuMicroButton:SetFrameStrata("MEDIUM")
	MainMenuMicroButton:SetFrameLevel(3)
	MainMenuMicroButton:SetNormalAtlas("hud-microbutton-MainMenu-Up", true)
	MainMenuMicroButton:SetPushedAtlas("hud-microbutton-MainMenu-Down", true)
	MainMenuMicroButton:SetDisabledAtlas("hud-microbutton-MainMenu-Disabled", true)
	MainMenuMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	if not(ClassicUI.db.profile.barsConfig.MicroButtons.useClassicMainMenuIcon) then
		MainMenuMicroButton:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-MainMenu-Up")
		MainMenuMicroButton:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-MainMenu-Down")
		MainMenuMicroButton:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-MainMenu-Disabled")
	else
		MainMenuMicroButton:SetNormalTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Up-classic")
		MainMenuMicroButton:SetPushedTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Down-classic")
		MainMenuMicroButton:SetDisabledTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Disabled-classic")
	end
	MainMenuMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	MainMenuMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	MainMenuMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	MainMenuMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	MainMenuMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	MainMenuMicroButton.FlashBorder:SetSize(34, 44)
	MainMenuMicroButton.FlashBorder:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", -2, 3)
	
	if (MainMenuMicroButton.MainMenuBarPerformanceBar ~= nil) then
		MainMenuMicroButton.MainMenuBarPerformanceBar:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
		MainMenuMicroButton.MainMenuBarPerformanceBar:SetTexCoord(0/32, 32/32, 22/64, 64/64)
		MainMenuMicroButton.MainMenuBarPerformanceBar:SetPoint("BOTTOM", MainMenuMicroButton, "BOTTOM", 0, 0)
		if (ClassicUI.db.profile.barsConfig.MainMenuBar.hideLatencyBar) then
			MainMenuMicroButton.MainMenuBarPerformanceBar:SetAlpha(0)
			MainMenuMicroButton.MainMenuBarPerformanceBar:Hide()
		end
	end
	
	hooksecurefunc("MicroButtonPulse", function(self, duration)
		if (ClassicUI.MicroButtonsGroup[self] ~= nil and self.FlashContent ~= nil) then
			UIFrameFlashStop(self.FlashContent)
		end
	end)
	
	-- [MicroButtons] MainMenuMicroButton -> HelpOpenWebTicketButton
	if (HelpOpenWebTicketButton ~= nil) then
		HelpOpenWebTicketButton:SetParent(MainMenuMicroButton)
		HelpOpenWebTicketButton:SetPoint("CENTER", HelpOpenWebTicketButton:GetParent(), "TOPRIGHT", -3, -4)
	end
	
	-- [MicroButtons] MainMenuMicroButton -> MainMenuBarDownload texture
	local CUI_MainMenuBarDownload = MainMenuMicroButton:CreateTexture("CUI_MainMenuBarDownload")
	CUI_MainMenuBarDownload:SetPoint("BOTTOM", MainMenuMicroButton, "BOTTOM", 0, 7)
	CUI_MainMenuBarDownload:SetTexture("Interface\\Buttons\\UI-MicroStream-Yellow")
	CUI_MainMenuBarDownload:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	CUI_MainMenuBarDownload:SetSize(28, 28)
	CUI_MainMenuBarDownload:SetDrawLayer("OVERLAY", 0)
	CUI_MainMenuBarDownload:SetAlpha(1)
	CUI_MainMenuBarDownload:Hide()
	
	MainMenuMicroButton:HookScript("OnUpdate", function(self, elapsed)
		if (self.updateInterval >= 1) then	-- PERFORMANCE_BAR_UPDATE_INTERVAL = 1
			local status = GetFileStreamingStatus()
			if ( status == 0 ) then
				status = (GetBackgroundLoadingStatus()~=0) and 1 or 0
			end
			self:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
			self:SetNormalAtlas("hud-microbutton-MainMenu-Up", true)
			self:SetPushedAtlas("hud-microbutton-MainMenu-Down", true)
			self:SetDisabledAtlas("hud-microbutton-MainMenu-Disabled", true)
			self:SetHighlightAtlas("hud-microbutton-highlight")
			self:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
			self:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
			if ( status == 0 ) then
				if not(ClassicUI.cached_db_profile.barsConfig_MicroButtons_useClassicMainMenuIcon) then	-- cached db value
					self:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-MainMenu-Up")
					self:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-MainMenu-Down")
					self:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-MainMenu-Disabled")
				else
					self:SetNormalTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Up-classic")
					self:SetPushedTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Down-classic")
					self:SetDisabledTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Disabled-classic")
				end
				self:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				self:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				self:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				CUI_MainMenuBarDownload:Hide()
			else
				self:SetNormalTexture("Interface\\Buttons\\UI-MicroButtonStreamDL-Up")
				self:SetPushedTexture("Interface\\Buttons\\UI-MicroButtonStreamDL-Down")
				self:SetDisabledTexture("Interface\\Buttons\\UI-MicroButtonStreamDL-Up")
				self:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				self:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				self:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				if ( status == 1 ) then
					CUI_MainMenuBarDownload:SetTexture("Interface\\Buttons\\UI-MicroStream-Green")
				elseif ( status == 2 ) then
					CUI_MainMenuBarDownload:SetTexture("Interface\\Buttons\\UI-MicroStream-Yellow")
				elseif ( status == 3 ) then
					CUI_MainMenuBarDownload:SetTexture("Interface\\Buttons\\UI-MicroStream-Red")
				end
				CUI_MainMenuBarDownload:Show()
			end
		end
	end)
	
	-- [MicroButtons] -> Set the current position and scale
	if not(PetBattleFrame.BottomFrame.MicroButtonFrame:IsVisible()) then
		if ActionBarController_GetCurrentActionBarState() == LE_ACTIONBAR_STATE_OVERRIDE then
			local anchorX, anchorY = 542, 41
			if OverrideActionBar.HasExit and OverrideActionBar.HasPitch then
				anchorX = 625
			elseif OverrideActionBar.HasPitch then
				anchorX = 629
			elseif OverrideActionBar.HasExit then
				anchorX = 537
			end
			UpdateMicroButtonsParent(OverrideActionBar)
			MoveMicroButtons("BOTTOMLEFT", OverrideActionBar, "BOTTOMLEFT", anchorX, anchorY, true)
			LFDMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "BOTTOMLEFT", 0, 4)
		else
			UpdateMicroButtonsParent(CUI_MainMenuBarArtFrame)
			MoveMicroButtons("BOTTOMLEFT", CUI_MainMenuBarArtFrame, "BOTTOMLEFT", 556 + ClassicUI.db.profile.barsConfig.MicroButtons.xOffset, 2 + ClassicUI.db.profile.barsConfig.MicroButtons.yOffset, false)
			LFDMicroButton:SetPoint("BOTTOMLEFT", GuildMicroButton, "BOTTOMRIGHT", -3, 0)
		end
	else
		MoveMicroButtons("TOPLEFT", PetBattleFrame.BottomFrame.MicroButtonFrame, "TOPLEFT", -11.5, 7.5, true)
		LFDMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "BOTTOMLEFT", 0, 4)
	end
	for k, _ in pairs(ClassicUI.MicroButtonsGroup) do
		k:SetScale(ClassicUI.db.profile.barsConfig.MicroButtons.scale)
	end
	
	-- [Bags]
	ClassicUI.BaseBagSlotButton_UpdateTextures = function(self)
		self:GetPushedTexture():SetAtlas(nil)
		self:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress", "ADD")
		self:GetPushedTexture():SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		self:GetPushedTexture():SetSize(30, 30)
		self:GetPushedTexture():SetAlpha(1)
		--self:GetPushedTexture():ClearAllPoints()		-- not needed
		--self:GetPushedTexture():SetAllPoints(self)	-- not needed
		
		self:GetHighlightTexture():SetAtlas(nil)
		self:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
		self:GetHighlightTexture():SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		self:GetHighlightTexture():SetSize(30, 30)
		self:GetHighlightTexture():SetAlpha(1)
		--self:GetHighlightTexture():ClearAllPoints()	-- not needed
		--self:GetHighlightTexture():SetAllPoints(self)	-- not needed
		
		self.SlotHighlightTexture:SetAtlas(nil)
		self.SlotHighlightTexture:SetTexture("Interface\\Buttons\\CheckButtonHilight")
		self.SlotHighlightTexture:SetBlendMode("ADD")
		self.SlotHighlightTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		self.SlotHighlightTexture:SetSize(30, 30)
		self.SlotHighlightTexture:SetAlpha(1)
--		--self.SlotHighlightTexture:ClearAllPoints()	-- not needed
--		--self.SlotHighlightTexture:SetAllPoints(self)	-- not needed
		
		self:GetNormalTexture():SetAtlas(nil)
		self:GetNormalTexture():SetTexture("Interface\\Buttons\\UI-Quickslot2")
		self:GetNormalTexture():SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		self:GetNormalTexture():SetSize(50, 50)
		self:GetNormalTexture():SetAlpha(1)
		self:GetNormalTexture():ClearAllPoints()
		self:GetNormalTexture():SetPoint("CENTER", self, "CENTER", 0, -1)
	end
	
	for i = 0, 3 do
		local bagSlot = _G["CharacterBag"..i.."Slot"]
		bagSlot.IconBorder:SetTexture("Interface\\Common\\WhiteIconFrame")
		bagSlot.IconBorder:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		bagSlot.IconBorder:SetSize(30, 30)
		bagSlot.IconBorder:SetDrawLayer("OVERLAY")
		bagSlot.IconBorder:SetAlpha(ClassicUI.db.profile.barsConfig.BagsIcons.iconBorderAlpha)
		bagSlot.IconBorder:SetPoint("CENTER", bagSlot, "CENTER", 0, 0)
		hooksecurefunc(bagSlot, "SetItemButtonQuality", ItemButtonMixin.SetItemButtonQuality)
		hooksecurefunc(bagSlot, "UpdateTextures", ClassicUI.BaseBagSlotButton_UpdateTextures)
	end
	hooksecurefunc(MainMenuBarBackpackButton, "UpdateTextures", ClassicUI.BaseBagSlotButton_UpdateTextures)
	
	ItemButtonMixin.SetItemButtonQuality(CharacterBag0Slot, GetInventoryItemQuality("player", CharacterBag0Slot:GetID()), GetInventoryItemID("player", CharacterBag0Slot:GetID()), CharacterBag0Slot.HasPaperDollAzeriteItemOverlay)
	ItemButtonMixin.SetItemButtonQuality(CharacterBag1Slot, GetInventoryItemQuality("player", CharacterBag1Slot:GetID()), GetInventoryItemID("player", CharacterBag1Slot:GetID()), CharacterBag1Slot.HasPaperDollAzeriteItemOverlay)
	ItemButtonMixin.SetItemButtonQuality(CharacterBag2Slot, GetInventoryItemQuality("player", CharacterBag2Slot:GetID()), GetInventoryItemID("player", CharacterBag2Slot:GetID()), CharacterBag2Slot.HasPaperDollAzeriteItemOverlay)
	ItemButtonMixin.SetItemButtonQuality(CharacterBag3Slot, GetInventoryItemQuality("player", CharacterBag3Slot:GetID()), GetInventoryItemID("player", CharacterBag3Slot:GetID()), CharacterBag3Slot.HasPaperDollAzeriteItemOverlay)
	C_Timer.After(8, function()
		ItemButtonMixin.SetItemButtonQuality(CharacterBag0Slot, GetInventoryItemQuality("player", CharacterBag0Slot:GetID()), GetInventoryItemID("player", CharacterBag0Slot:GetID()), CharacterBag0Slot.HasPaperDollAzeriteItemOverlay)
		ItemButtonMixin.SetItemButtonQuality(CharacterBag1Slot, GetInventoryItemQuality("player", CharacterBag1Slot:GetID()), GetInventoryItemID("player", CharacterBag1Slot:GetID()), CharacterBag1Slot.HasPaperDollAzeriteItemOverlay)
		ItemButtonMixin.SetItemButtonQuality(CharacterBag2Slot, GetInventoryItemQuality("player", CharacterBag2Slot:GetID()), GetInventoryItemID("player", CharacterBag2Slot:GetID()), CharacterBag2Slot.HasPaperDollAzeriteItemOverlay)
		ItemButtonMixin.SetItemButtonQuality(CharacterBag3Slot, GetInventoryItemQuality("player", CharacterBag3Slot:GetID()), GetInventoryItemID("player", CharacterBag3Slot:GetID()), CharacterBag3Slot.HasPaperDollAzeriteItemOverlay)
	end)
	
	CharacterBag0Slot.CircleMask:Hide()
	ClassicUI.BaseBagSlotButton_UpdateTextures(CharacterBag0Slot)
	CharacterBag0Slot:SetParent(CUI_MainMenuBarArtFrame)
	CharacterBag0Slot:SetSize(30, 30)
	CharacterBag0Slot.IconBorder:SetSize(30, 30)
	CharacterBag0Slot:ClearAllPoints()
	CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -2, 0)
	CharacterBag0Slot:SetFrameStrata("MEDIUM")
	CharacterBag0Slot:SetFrameLevel(3)
	CharacterBag1Slot.CircleMask:Hide()
	ClassicUI.BaseBagSlotButton_UpdateTextures(CharacterBag1Slot)
	CharacterBag1Slot:SetParent(CUI_MainMenuBarArtFrame)
	CharacterBag1Slot:SetSize(30, 30)
	CharacterBag1Slot.IconBorder:SetSize(30, 30)
	CharacterBag1Slot:ClearAllPoints()
	CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot, "LEFT", -2, 0)
	CharacterBag1Slot:SetFrameStrata("MEDIUM")
	CharacterBag1Slot:SetFrameLevel(3)
	CharacterBag2Slot.CircleMask:Hide()
	ClassicUI.BaseBagSlotButton_UpdateTextures(CharacterBag2Slot)
	CharacterBag2Slot:SetParent(CUI_MainMenuBarArtFrame)
	CharacterBag2Slot:SetSize(30, 30)
	CharacterBag2Slot.IconBorder:SetSize(30, 30)
	CharacterBag2Slot:ClearAllPoints()
	CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot, "LEFT", -2, 0)
	CharacterBag2Slot:SetFrameStrata("MEDIUM")
	CharacterBag2Slot:SetFrameLevel(3)
	CharacterBag3Slot.CircleMask:Hide()
	ClassicUI.BaseBagSlotButton_UpdateTextures(CharacterBag3Slot)
	CharacterBag3SlotNormalTexture:Hide()
	CharacterBag3Slot:SetParent(CUI_MainMenuBarArtFrame)
	CharacterBag3Slot:SetSize(30, 30)
	CharacterBag3Slot.IconBorder:SetSize(30, 30)
	CharacterBag3Slot:ClearAllPoints()
	CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot, "LEFT", -2, 0)
	CharacterBag3Slot:SetFrameStrata("MEDIUM")
	CharacterBag3Slot:SetFrameLevel(3)
	CharacterReagentBag0Slot:SetParent(CUI_MainMenuBarArtFrame)
	CharacterReagentBag0Slot:ClearAllPoints()
	CharacterReagentBag0Slot:SetPoint("CENTER", CharacterBag3Slot, "LEFT", -5 + ClassicUI.db.profile.barsConfig.BagsIcons.xOffsetReagentBag, -2 + ClassicUI.db.profile.barsConfig.BagsIcons.yOffsetReagentBag)
	CharacterReagentBag0Slot:SetFrameStrata("MEDIUM")
	CharacterReagentBag0Slot:SetFrameLevel(4)
	MainMenuBarBackpackButton.CircleMask:Hide()
	ClassicUI.BaseBagSlotButton_UpdateTextures(MainMenuBarBackpackButton)
	MainMenuBarBackpackButtonIconTexture:SetTexture("Interface\\Buttons\\Button-Backpack-Up")
	MainMenuBarBackpackButton:SetParent(CUI_MainMenuBarArtFrame)
	MainMenuBarBackpackButton:SetSize(30, 30)
	MainMenuBarBackpackButton.IconBorder:SetSize(30, 30)
	MainMenuBarBackpackButton:ClearAllPoints()
	MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", CUI_MainMenuBarArtFrame, "BOTTOMRIGHT", -4, 6)
	MainMenuBarBackpackButton:SetFrameStrata("MEDIUM")
	MainMenuBarBackpackButton:SetFrameLevel(3)
	if not(MainMenuBarBagManager:IsBarUserExpanded()) then
		MainMenuBarBagManager:ToggleExpandBar()
	end
	BagBarExpandToggle:Hide()
	MicroButtonAndBagsBar:Hide()
	
	hooksecurefunc(CharacterReagentBag0Slot, "SetBarExpanded", function(self, isExpanded)
		CharacterReagentBag0Slot:ClearAllPoints()
		CharacterReagentBag0Slot:SetPoint("CENTER", CharacterBag3Slot, "LEFT", -5 + ClassicUI.cached_db_profile.barsConfig_BagsIcons_xOffsetReagentBag, -2 + ClassicUI.cached_db_profile.barsConfig_BagsIcons_yOffsetReagentBag)	-- cached db value
	end)

	if (isLogin) then
		ClassicUI.OnEvent_PEW_mf = true
		if (not ClassicUI.frame:IsEventRegistered("PLAYER_ENTERING_WORLD")) then
			ClassicUI.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		end
	else
		ClassicUI:MF_PLAYER_ENTERING_WORLD()
	end

end

-- Function to Show/Hide/OnlyShowDotRange keybinds text from ActionBars
-- Togle the visibilitity mode from 2 or 3 to another mode requires a ReloadUI
function ClassicUI:ToggleVisibilityKeybinds(mode)
	if (mode == 1) then
		for i = 1, 12 do
			local actionButtonHK
			actionButtonHK = _G["ExtraActionButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
			actionButtonHK = _G["ActionButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
			actionButtonHK = _G["MultiBarBottomLeftButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
			actionButtonHK = _G["MultiBarBottomRightButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
			actionButtonHK = _G["MultiBarLeftButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
			actionButtonHK = _G["MultiBarRightButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
			actionButtonHK = _G["PetActionButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
			actionButtonHK = _G["StanceButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
			actionButtonHK = _G["PossessButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
			actionButtonHK = _G["OverrideActionBarButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
		end
		ClassicUI:HookPetBattleKeybindsVisibilityMode()
		for i = 1, #PetBattleFrame.BottomFrame.abilityButtons do
			local actionButton = PetBattleFrame.BottomFrame.abilityButtons[i]
			if (actionButton and actionButton.HotKey) then
				actionButton.HotKey:SetAlpha(0)
				actionButton.HotKey:Hide()
			end
		end
		PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:SetAlpha(0)
		PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:Hide()
		PetBattleFrame.BottomFrame.CatchButton.HotKey:SetAlpha(0)
		PetBattleFrame.BottomFrame.CatchButton.HotKey:Hide()
	elseif (mode == 2) or (mode == 3) then
		for i = 1, 12 do
			local actionButton
			actionButton = _G["ExtraActionButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				if (actionButton.UpdateHotkeys ~= nil) then
					ClassicUI:HookKeybindsVisibilityMode(actionButton)
					actionButton:UpdateHotkeys()
				end
			end
			actionButton = _G["ActionButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				if (actionButton.UpdateHotkeys ~= nil) then
					ClassicUI:HookKeybindsVisibilityMode(actionButton)
					actionButton:UpdateHotkeys()
				end
			end
			actionButton = _G["MultiBarBottomLeftButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				if (actionButton.UpdateHotkeys ~= nil) then
					ClassicUI:HookKeybindsVisibilityMode(actionButton)
					actionButton:UpdateHotkeys()
				end
			end
			actionButton = _G["MultiBarBottomRightButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				if (actionButton.UpdateHotkeys ~= nil) then
					ClassicUI:HookKeybindsVisibilityMode(actionButton)
					actionButton:UpdateHotkeys()
				end
			end
			actionButton = _G["MultiBarLeftButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				if (actionButton.UpdateHotkeys ~= nil) then
					ClassicUI:HookKeybindsVisibilityMode(actionButton)
					actionButton:UpdateHotkeys()
				end
			end
			actionButton = _G["MultiBarRightButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				if (actionButton.UpdateHotkeys ~= nil) then
					ClassicUI:HookKeybindsVisibilityMode(actionButton)
					actionButton:UpdateHotkeys()
				end
			end
			actionButton = _G["PetActionButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				if (actionButton.UpdateHotkeys ~= nil) then
					ClassicUI:HookKeybindsVisibilityMode(actionButton)
					actionButton:UpdateHotkeys()
				end
			end
			actionButton = _G["StanceButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				if (actionButton.UpdateHotkeys ~= nil) then
					ClassicUI:HookKeybindsVisibilityMode(actionButton)
					actionButton:UpdateHotkeys()
				end
			end
			actionButton = _G["PossessButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				if (actionButton.UpdateHotkeys ~= nil) then
					ClassicUI:HookKeybindsVisibilityMode(actionButton)
					actionButton:UpdateHotkeys()
				end
			end
			actionButton = _G["OverrideActionBarButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				if (actionButton.UpdateHotkeys ~= nil) then
					ClassicUI:HookKeybindsVisibilityMode(actionButton)
					actionButton:UpdateHotkeys()
				end
			end
		end
		ACTIONBUTTON_UPDATEHOTKEYS_HOOKED = true
		ClassicUI:HookPetBattleKeybindsVisibilityMode()
		if (mode == 2) then
			for i=1, #PetBattleFrame.BottomFrame.abilityButtons do
				local actionButton = PetBattleFrame.BottomFrame.abilityButtons[i]
				if (actionButton and actionButton.HotKey) then
					actionButton.HotKey:SetAlpha(0)
					actionButton.HotKey:Hide()
				end
			end
			PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:SetAlpha(0)
			PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:Hide()
			PetBattleFrame.BottomFrame.CatchButton.HotKey:SetAlpha(0)
			PetBattleFrame.BottomFrame.CatchButton.HotKey:Hide()
		elseif (mode == 3) then
			for i=1, #PetBattleFrame.BottomFrame.abilityButtons do
				local actionButton = PetBattleFrame.BottomFrame.abilityButtons[i]
				if (actionButton and actionButton.HotKey) then
					actionButton.HotKey:SetAlpha(1)
					actionButton.HotKey:Show()
					PetBattleAbilityButton_UpdateHotKey(actionButton)
				end
			end
			PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:SetAlpha(1)
			PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:Show()
			PetBattleFrame.BottomFrame.CatchButton.HotKey:SetAlpha(1)
			PetBattleFrame.BottomFrame.CatchButton.HotKey:Show()
			PetBattleAbilityButton_UpdateHotKey(PetBattleFrame.BottomFrame.SwitchPetButton)
			PetBattleAbilityButton_UpdateHotKey(PetBattleFrame.BottomFrame.CatchButton)
		end
	else
		for i = 1, 12 do
			local actionButtonHK
			actionButtonHK = _G["ExtraActionButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
			actionButtonHK = _G["ActionButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
			actionButtonHK = _G["MultiBarBottomLeftButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
			actionButtonHK = _G["MultiBarBottomRightButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
			actionButtonHK = _G["MultiBarLeftButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
			actionButtonHK = _G["MultiBarRightButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
			actionButtonHK = _G["PetActionButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
			actionButtonHK = _G["StanceButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
			actionButtonHK = _G["PossessButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
			actionButtonHK = _G["OverrideActionBarButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
		end
		for i=1, #PetBattleFrame.BottomFrame.abilityButtons do
			local actionButton = PetBattleFrame.BottomFrame.abilityButtons[i]
			if (actionButton and actionButton.HotKey) then
				actionButton.HotKey:SetAlpha(1)
				actionButton.HotKey:Show()
				PetBattleAbilityButton_UpdateHotKey(actionButton)
			end
		end
		PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:SetAlpha(1)
		PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:Show()
		PetBattleFrame.BottomFrame.CatchButton.HotKey:SetAlpha(1)
		PetBattleFrame.BottomFrame.CatchButton.HotKey:Show()
		PetBattleAbilityButton_UpdateHotKey(PetBattleFrame.BottomFrame.SwitchPetButton)
		PetBattleAbilityButton_UpdateHotKey(PetBattleFrame.BottomFrame.CatchButton)
	end
end

-- The OnlyShowDotRange or OnlyShowPermanentDotRange keybind options require a Hook
function ClassicUI:HookKeybindsVisibilityMode(actionBarButton)
	if (not ACTIONBUTTON_UPDATEHOTKEYS_HOOKED) then
		hooksecurefunc(actionBarButton, "UpdateHotkeys", function(self, actionButtonType)
			if (ClassicUI.cached_db_profile.extraConfigs_KeybindsConfig_hideKeybindsMode == 2) then	-- cached db value
				self.HotKey:SetText(RANGE_INDICATOR)
			else
				self.HotKey:SetText(' '..RANGE_INDICATOR)
			end
		end)
	end
end

-- Hide/Modify the BattlePets action buttons hotkeys require a Hook
function ClassicUI:HookPetBattleKeybindsVisibilityMode()
	if (not PETBATTLEABILITYBUTTON_UPDATEHOTKEYS_HOOKED) then
		hooksecurefunc("PetBattleAbilityButton_UpdateHotKey", function(self)
			local mode = ClassicUI.cached_db_profile.extraConfigs_KeybindsConfig_hideKeybindsMode	-- cached db value
			if (mode == 1) then
				self.HotKey:SetAlpha(0)
				self.HotKey:Hide()
			elseif (mode == 2) then
				self.HotKey:SetAlpha(0)
				self.HotKey:Hide()
			elseif (mode == 3) then
				self.HotKey:SetText(RANGE_INDICATOR)
			end
		end)
		PETBATTLEABILITYBUTTON_UPDATEHOTKEYS_HOOKED = true
	end
end

-- Function to Show/Hide name text from ActionBars
function ClassicUI:ToggleVisibilityActionButtonNames(mode)
	if (mode) then
		for i = 1, 12 do
			local actionButtonName
			actionButtonName = _G["ExtraActionButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
			actionButtonName = _G["ActionButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
			actionButtonName = _G["MultiBarBottomLeftButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
			actionButtonName = _G["MultiBarBottomRightButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
			actionButtonName = _G["MultiBarLeftButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
			actionButtonName = _G["MultiBarRightButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
			actionButtonName = _G["PetActionButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
			actionButtonName = _G["StanceButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
			actionButtonName = _G["PossessButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
			actionButtonName = _G["OverrideActionBarButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
		end
	else
		for i = 1, 12 do
			local actionButtonName
			actionButtonName = _G["ExtraActionButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
			actionButtonName = _G["ActionButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
			actionButtonName = _G["MultiBarBottomLeftButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
			actionButtonName = _G["MultiBarBottomRightButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
			actionButtonName = _G["MultiBarLeftButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
			actionButtonName = _G["MultiBarRightButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
			actionButtonName = _G["PetActionButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
			actionButtonName = _G["StanceButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
			actionButtonName = _G["PossessButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
			actionButtonName = _G["OverrideActionBarButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
		end
	end
end

-- Function to disable Cooldown effect on action bars caused by CC
function ClassicUI:HookLossOfControlUICCRemover()
	if (not DISABLELOSSOFCONTROLUI_HOOKED) then
		hooksecurefunc('ActionButton_UpdateCooldown', function(self)
			if ( self.cooldown.currentCooldownType == COOLDOWN_TYPE_LOSS_OF_CONTROL ) then
				local start, duration, enable, charges, maxCharges, chargeStart, chargeDuration
				local modRate = 1.0
				local chargeModRate = 1.0
				if ( self.spellID ) then
					start, duration, enable, modRate = GetSpellCooldown(self.spellID)
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(self.spellID)
				else
					start, duration, enable, modRate = GetActionCooldown(self.action)
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(self.action)
				end
				self.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge")
				self.cooldown:SetSwipeColor(0, 0, 0)
				self.cooldown:SetHideCountdownNumbers(false)
				if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
					if chargeStart == 0 then
						ClearChargeCooldown(self)
					else
						if self.chargeCooldown then
							CooldownFrame_Set(self.chargeCooldown, chargeStart, chargeDuration, true, true, chargeModRate)
						end
					end
				else
					ClearChargeCooldown(self)
				end
				CooldownFrame_Set(self.cooldown, start, duration, enable, false, modRate)
			end
		end)
		DISABLELOSSOFCONTROLUI_HOOKED = true
	end
end

-- Function to show the entire icon in red when the spell is not at range instead of only show in red the keybind text
function ClassicUI:HookRedRangeIcons()
	if (not REDRANGEICONS_HOOKED) then
		local function HookActionBarButtonUpdateUsable(actionBarButton)
			if (actionBarButton.UpdateUsable ~= nil) then
				hooksecurefunc(actionBarButton, "UpdateUsable", function(self)
					local action = self.action
					local icon = self.icon
					local isUsable, notEnoughMana = IsUsableAction(action)
					local normalTexture = self.NormalTexture
					if ( not normalTexture ) then
						return
					end
					if (ActionHasRange(action) and IsActionInRange(action) == false) then
						icon:SetVertexColor(0.8, 0.1, 0.1)
						normalTexture:SetVertexColor(0.8, 0.1, 0.1)
						self.redRangeRed = true
					elseif (self.redRangeRed) then
						if (isUsable) then
							icon:SetVertexColor(1.0, 1.0, 1.0)
							normalTexture:SetVertexColor(1.0, 1.0, 1.0)
							self.redRangeRed = false
						elseif (notEnoughMana) then
							icon:SetVertexColor(0.1, 0.3, 1.0)
							normalTexture:SetVertexColor(0.1, 0.3, 1.0)
							self.redRangeRed = false
						else
							icon:SetVertexColor(0.4, 0.4, 0.4)
							normalTexture:SetVertexColor(1.0, 1.0, 1.0)
							self.redRangeRed = false
						end
					end
				end)
			end
		end
		hooksecurefunc("ActionButton_UpdateRangeIndicator", function(self, checksRange, inRange)
			if ( checksRange and not inRange ) then
				local icon = self.icon
				local normalTexture = self.NormalTexture
				icon:SetVertexColor(0.8, 0.1, 0.1)
				if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
					normalTexture:SetVertexColor(0.8, 0.1, 0.1)
				end
				self.redRangeRed = true
			elseif (self.redRangeRed) then
				local icon = self.icon
				local normalTexture = self.NormalTexture
				local action = self.action
				if (action) then
					local isUsable, notEnoughMana = IsUsableAction(action)
					if (isUsable) then
						icon:SetVertexColor(1.0, 1.0, 1.0)
						if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
							normalTexture:SetVertexColor(1.0, 1.0, 1.0)
						end
					elseif (notEnoughMana) then
						icon:SetVertexColor(0.1, 0.3, 1.0)
						if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
							normalTexture:SetVertexColor(0.1, 0.3, 1.0)
						end
					else
						icon:SetVertexColor(0.4, 0.4, 0.4)
						if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
							normalTexture:SetVertexColor(1.0, 1.0, 1.0)
						end
					end
				else
					icon:SetVertexColor(1.0, 1.0, 1.0)
					if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
						normalTexture:SetVertexColor(1.0, 1.0, 1.0)
					end
				end
				self.redRangeRed = false
			end
		end)
		for i = 1, 12 do
			local actionButton
			actionButton = _G["ExtraActionButton"..i]
			if (actionButton) then
				HookActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["ActionButton"..i]
			if (actionButton) then
				HookActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["MultiBarBottomLeftButton"..i]
			if (actionButton) then
				HookActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["MultiBarBottomRightButton"..i]
			if (actionButton) then
				HookActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["MultiBarLeftButton"..i]
			if (actionButton) then
				HookActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["MultiBarRightButton"..i]
			if (actionButton) then
				HookActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["PetActionButton"..i]
			if (actionButton) then
				HookActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["StanceButton"..i]
			if (actionButton) then
				HookActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["PossessButton"..i]
			if (actionButton) then
				HookActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["OverrideActionBarButton"..i]
			if (actionButton) then
				HookActionBarButtonUpdateUsable(actionButton)
			end
		end
		REDRANGEICONS_HOOKED = true
	end
end

-- Function to desaturate the entire action icon when the spell is on cooldown
function ClassicUI:HookGreyOnCooldownIcons()
	if (not GREYONCOOLDOWN_HOOKED) then
		local UpdateFuncCache = {}
		function ActionButtonGreyOnCooldown_UpdateCooldown(self, expectedUpdate)
			local icon = self.icon
			local spellID = self.spellID
			local action = self.action
			if (icon and ((action and type(action)~="table" and type(action)~="string") or (spellID and type(spellID)~="table" and type(spellID)~="string"))) then
				local start, duration
				if (spellID) then
					start, duration = GetSpellCooldown(spellID)
				else
					start, duration = GetActionCooldown(action)
				end
				if (duration >= ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_minDuration) then	-- cached db value
					if start > 3085367 and start <= 4294967.295 then
						start = start - 4294967.296
					end
					if ((not self.onCooldown) or (self.onCooldown == 0)) then
						self.onCooldown = start + duration
						local nextTime = start + duration - GetTime() - 1.0
						if (nextTime < -1.0) then
							nextTime = 0.05
						elseif (nextTime < 0) then
							nextTime = -nextTime / 2
						end
						if nextTime <= 4294967.295 then
							local func = UpdateFuncCache[self]
							if not func then
								func = function() ActionButtonGreyOnCooldown_UpdateCooldown(self, true) end
								UpdateFuncCache[self] = func
							end
							C_Timer.After(nextTime, func)
						end
					elseif (expectedUpdate or (self.onCooldown > start + duration + 0.05)) then
						if (self.onCooldown ~= start + duration) then
							self.onCooldown = start + duration
						end
						local nextTime = 0.05
						local timeRemains = self.onCooldown-GetTime()
						if (timeRemains > 0.31) then
							nextTime = timeRemains / 5
						elseif (timeRemains < 0) then
							nextTime = 0.05
						end
						if nextTime <= 4294967.295 then
							local func = UpdateFuncCache[self]
							if not func then
								func = function() ActionButtonGreyOnCooldown_UpdateCooldown(self, true) end
								UpdateFuncCache[self] = func
							end
							C_Timer.After(nextTime, func)
						end
					end
					if (not icon:IsDesaturated()) then
						icon:SetDesaturated(true)
					end
				else
					self.onCooldown = 0
					if (icon:IsDesaturated()) then
						icon:SetDesaturated(false)
					end
				end
			end
		end
		-- We hook to 'ActionButton_UpdateCooldown' instead of 'ActionButton_OnUpdate' because 'ActionButton_OnUpdate' is much more expensive. So, we need use C_Timer.After to trigger the function when cooldown ends.
		hooksecurefunc('ActionButton_UpdateCooldown', ActionButtonGreyOnCooldown_UpdateCooldown)
		GREYONCOOLDOWN_HOOKED = true
	end
end

-- Function to hook the functionalities of the Guild Panel Mode extra option
function ClassicUI:HookOpenGuildPanelMode()
	if (not OPENGUILDPANEL_HOOKED) then
		-- New global functions ToggleOldGuildFrame and ToggleNewGuildFrame to toggle the old and the new menu frame respectively
		ToggleNewGuildFrame = ToggleGuildFrame
		function ToggleOldGuildFrame()
			if (Kiosk_IsEnabled()) then
				return
			end
			local factionGroup = UnitFactionGroup("player")
			if (factionGroup == "Neutral") then
				return
			end
			if ( IsTrialAccount() or (IsVeteranTrialAccount() and not IsInGuild()) ) then
				UIErrorsFrame:AddMessage(ERR_RESTRICTED_ACCOUNT_TRIAL, 1.0, 0.1, 0.1, 1.0)
				return
			end
			if ( IsInGuild() ) then
				GuildFrame_LoadUI()
				if ( GuildFrame_Toggle ) then
					GuildFrame_Toggle()
				end
			else
				ToggleGuildFinder()
			end
		end

		-- Set hook to open new or old menu (this hook work on keybinds, guild alert click, ...)
		hooksecurefunc("ToggleGuildFrame", function(self)
			if ((not InCombatLockdown()) and (ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_defaultOpenOldMenu)) then	-- cached db value
				ToggleNewGuildFrame()
				ToggleOldGuildFrame()
			end
		end)

		--Set GuildMicroButton click specific hook
		GuildMicroButton:HookScript('OnClick', function(self, button)
			if (not InCombatLockdown()) then
				if (button == 'RightButton') then
					if (ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_rightClickMicroButtonOpenOldMenu) then	-- cached db value
						if not(ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_defaultOpenOldMenu) then	-- cached db value
							ToggleNewGuildFrame()
							ToggleOldGuildFrame()
						end
					elseif (ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_defaultOpenOldMenu) then	-- cached db value
						ToggleOldGuildFrame()
						ToggleNewGuildFrame()
					end
				elseif (button == 'MiddleButton') then
					if (ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_middleClickMicroButtonOpenOldMenu) then	-- cached db value
						if not(ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_defaultOpenOldMenu) then	-- cached db value
							ToggleNewGuildFrame()
							ToggleOldGuildFrame()
						end
					elseif (ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_defaultOpenOldMenu) then	-- cached db value
						ToggleOldGuildFrame()
						ToggleNewGuildFrame()
					end
				else
					if (ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_leftClickMicroButtonOpenOldMenu) then	-- cached db value
						if not(ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_defaultOpenOldMenu) then	-- cached db value
							ToggleNewGuildFrame()
							ToggleOldGuildFrame()
						end
					elseif (ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_defaultOpenOldMenu) then	-- cached db value
						ToggleOldGuildFrame()
						ToggleNewGuildFrame()
					end
				end
			end
		end)
		OPENGUILDPANEL_HOOKED = true
	end
end
