-- ------------------------------------------------------------ --
-- Addon: ClassicUI                                             --
--                                                              --
-- Version: 1.1.4                                               --
-- Author: Millán - C'Thun                                      --
--                                                              --
-- License: GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007 --
-- ------------------------------------------------------------ --

ClassicUI = LibStub("AceAddon-3.0"):NewAddon("ClassicUI", "AceConsole-3.0");

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

ClassicUI.frame = ClassicUI.frame or CreateFrame("Frame", "ClassicUIFrame")

function ClassicUI:OnEvent(event, ...) -- functions created in "object:method"-style have an implicit first parameter of "self", which points to object
	ClassicUI[event](ClassicUI, ...) -- route event parameters to ClassicUI:event methods
end
ClassicUI.frame:SetScript("OnEvent", ClassicUI.OnEvent)

local L = LibStub("AceLocale-3.0"):GetLocale("ClassicUI");

local _G = _G
local _
local STANDARD_EPSILON = 0.0001
local SCALE_EPSILON = 0.0001

-- Global variables
ClassicUI.BAG_SIZE = 32
ClassicUI.BAGS_WIDTH = (4*ClassicUI.BAG_SIZE+32)
ClassicUI.ACTION_BAR_OFFSET = 48
ClassicUI.VERSION = "1.1.4"

ClassicUI.cached_NumberVisibleBars = 0
ClassicUI.cached_NumberRealVisibleBars = 0
ClassicUI.cached_DoubleStatusBar_hide = nil
ClassicUI.cached_SingleStatusBar_hide = nil
ClassicUI.cached_LastMainMenuBarPoint = { "BOTTOM", UIParent, "BOTTOM", 0, MainMenuBar and MainMenuBar:GetYOffset() or 14 }
ClassicUI.TitanPanelIsPresent = false
ClassicUI.LibJostleIsPresent = false
ClassicUI.TitanPanelBottomBarsYOffset = 0
ClassicUI.MultiBarBottomRightButtonsBackgroundsCreated = false

ClassicUI.Update_MultiActionBar = function() end
ClassicUI.Update_PetActionBar = function() end
ClassicUI.Update_StanceBar = function() end
ClassicUI.Update_PossessBar = function() end
ClassicUI.SetPositionForStatusBars_MainMenuBar = function() end
ClassicUI.TransferPetActionBarFrameChildrens = function() end
ClassicUI.StatusTrackingBarManager_LayoutBar = function() end

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
				model = 0	-- 0 = Gryphon, 1 = Lion
			},
			['RightGargoyleFrame'] = {
				hide = false,
				alpha = 1,
				scale = 1,
				model = 0	-- 0 = Gryphon, 1 = Lion
			},
			['MainMenuBar'] = {
				scale = 1
			},
			['OverrideActionBar'] = {
				scale = 1
			},
			['PetBattleFrameBar'] = {
				scale = 1
			},
			['BottomMultiActionBars'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1
			},
			['RightMultiActionBars'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1
			},
			['PetActionBarFrame'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				xOffsetIfStanceBar = 0,
				scale = 1
			},
			['StanceBarFrame'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1
			},
			['PossessBarFrame'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1
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
				overlayHide = false,
				overlayAlpha = 1.0,
				xOffsetOverlay = 0,
				yOffsetOverlay = 0
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
				overlayHide = false,
				overlayAlpha = 1.0,
				xOffsetOverlay = 0,
				yOffsetOverlay = 0
			},
			['DoubleLowerStatusBar'] = {
				alpha = 0.5,
				xSize = 0,
				ySize = 0,
				artHide = false,
				artAlpha = 1.0,
				xOffsetArt = 0,
				yOffsetArt = 0,
				overlayHide = false,
				overlayAlpha = 1.0,
				xOffsetOverlay = 0,
				yOffsetOverlay = 0
			}
		},
		extraConfigs = {
			['forceExtraOptions'] = false,
			['GuildPanelMode'] = {
				defauiltOpenOldMenu = false,
				leftClickMicroButtonOpenOldMenu = false, 
				rightClickMicroButtonOpenOldMenu = false
			},
			['KeybindsConfig'] = {
				hideKeybindsMode = 0,	--0 = show keybinds, 1 = hide keybinds, 2 = show range dots on keybinds, 3 = show permanent range dots on keybinds
				hideActionButtonName = false
			},
			['RedRangeConfig'] = {
				enabled = false
			},
			['GreyOnCooldownConfig'] = {
				enabled = false
			},
			['LossOfControlUIConfig'] = {
				enabled = false
			}
		},
	},
}

-- First function fired
function ClassicUI:OnInitialize()
	self.db = AceDB:New("ClassicUI_DB", self.defaults, true)
	
	self.optionsTable.args.profiles = AceDBOptions:GetOptionsTable(self.db)
	
	AceConfig:RegisterOptionsTable("ClassicUI", self.optionsTable)
	
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	
	self.optionsFrames = {}
	self.optionsFrames.general = AceConfigDialog:AddToBlizOptions("ClassicUI", nil, nil, "general")
	self.optionsFrames.extraOptions = AceConfigDialog:AddToBlizOptions("ClassicUI", L["Extra Options"], "ClassicUI", "extraOptions")
	self.optionsFrames.profiles = AceConfigDialog:AddToBlizOptions("ClassicUI", L["Profiles"], "ClassicUI", "profiles")
	
	self:RegisterChatCommand("ClassicUI", "SlashCommand")
	
	-- Start ClassicUI Core
	if (self.db.profile.enabled) then
		ClassicUI:Enable()
		ClassicUI:MainFunction() 
		ClassicUI:ExtraFunction()
	else
		ClassicUI:Disable()
		if (ClassicUI.db.profile.forceExtraOptions) then
			ClassicUI:ExtraFunction()
		end
	end
end

-- Executed after modifying, resetting or changing profiles from the profile configuration menu
function ClassicUI:RefreshConfig()
	if (ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.model == 1) then
		MainMenuBarArtFrame.LeftEndCap:Hide()
	else
		MainMenuBarArtFrame.LeftEndCap:SetSize(128, 76)
		MainMenuBarArtFrame.LeftEndCap:SetTexture("Interface\\MAINMENUBAR\\UI-MainMenuBar-EndCap-Dwarf.blp")
		MainMenuBarArtFrame.LeftEndCap:SetTexCoord(0/128, 128/128, 52/128, 128/128);
		MainMenuBarArtFrame.LeftEndCap:SetScale(1)
		MainMenuBarArtFrame.LeftEndCap:SetAlpha(1)
	end
	if (ClassicUI.db.profile.barsConfig.RightGargoyleFrame.model == 1) then
		MainMenuBarArtFrame.RightEndCap:Hide()
	else
		MainMenuBarArtFrame.RightEndCap:SetSize(128, 76)
		MainMenuBarArtFrame.RightEndCap:SetTexture("Interface\\MAINMENUBAR\\UI-MainMenuBar-EndCap-Dwarf.blp")
		MainMenuBarArtFrame.RightEndCap:SetTexCoord(128/128, 0/128, 52/128, 128/128);
		MainMenuBarArtFrame.RightEndCap:SetScale(1)
		MainMenuBarArtFrame.RightEndCap:SetAlpha(1)
	end
	if (self:IsEnabled()) then
		if (not self.db.profile.enabled) then
			self:Disable()
			ReloadUI()
		else
			self.SetPositionForStatusBars_MainMenuBar()
			ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
			ClassicUI:ForceExpBarExhaustionTickUpdate()
		end
	else
		if (self.db.profile.enabled) then
			self:Enable()
			self:MainFunction() 
			self:ExtraFunction()
			self.SetPositionForStatusBars_MainMenuBar()
			ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
			ClassicUI:ForceExpBarExhaustionTickUpdate()
		else
			ReloadUI()	--We do this ReloadUI because the old value of self.db.profile.forceExtraOptions could be true
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
			ClassicUI:ExtraFunction()
			ClassicUI.SetPositionForStatusBars_MainMenuBar()
			ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
			ClassicUI:ForceExpBarExhaustionTickUpdate()
		end
	elseif (cmd == "disable") or (cmd == "off") then
		if (ClassicUI:IsEnabled()) then
			ClassicUI.db.profile.enabled = false
			ClassicUI:Disable()
			ReloadUI()
		end
	elseif (cmd == "extraoptions") or (cmd == "eo") then
		ClassicUI:ShowConfig(1)
	elseif (cmd == "forceextraoptions") or (cmd == "fextraoptions") or (cmd == "feo") then
		if (arg1 == "enable") or (arg1 == "on") then
			if (not ClassicUI.db.profile.forceExtraOptions) then
				ClassicUI.db.profile.forceExtraOptions = true
				if (not ClassicUI:IsEnabled()) then
					ClassicUI:ExtraFunction()
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
			ClassicUI:ShowConfig(1)
		end
	elseif (cmd == "profiles") then
		ClassicUI:ShowConfig(2)
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
end

function ClassicUI:OnEnable()
	DEFAULT_CHAT_FRAME:AddMessage('|cffd78900' .. L['ClassicUI'] .. ' v' .. ClassicUI.VERSION .. '|r ' .. L['enabled'])
end

function ClassicUI:OnDisable()
	DEFAULT_CHAT_FRAME:AddMessage('|cffd78900' .. L['ClassicUI'] .. ' v' .. ClassicUI.VERSION .. '|r ' .. L['disabled'])
end

--Show Options Menu
function ClassicUI:ShowConfig(category)
	-- Call twice to workaround a bug in Blizzard's function
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.profiles)
	if (category ~= nil) then
		if (category == 0) then
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.general)
		elseif (category == 1) then
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.extraOptions)
		elseif (category == 2) then
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.profiles)
		else
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.general)
		end
	else
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.general)
	end
end

-- This function gets the extra width needed to some frames when the MultiBarBottomRight is hidden
function ClassicUI:GetExtraWidth()
	local extraWidth
	if (math.floor(MainMenuBar:GetWidth()+0.5) < 804) then
		extraWidth = 804 - math.floor(MainMenuBar:GetWidth()+0.5)
	else
		extraWidth = 0
	end
	return extraWidth
end

-- Function to move the MicroButtons but only when needed
function ClassicUI:MoveMicroButtons(point, relativeFrame, relativePoint, ofsx, ofsy, isStacked)
	local anchor, anchorTo, relAnchor, x, y = CharacterMicroButton:GetPoint()
	if ((anchor ~= point) or (anchorTo ~= relativeFrame) or (relAnchor ~= relativePoint) or (math.abs(x-ofsx) > STANDARD_EPSILON) or (math.abs(y-ofsy) > STANDARD_EPSILON)) then
		MoveMicroButtons(point, relativeFrame, relativePoint, ofsx, ofsy, isStacked);
	else
		local anchor2, anchorTo2, relAnchor2, x2, y2 = LFDMicroButton:GetPoint()
		if (isStacked) then
			if ((anchor2 ~= "TOPLEFT") or (anchorTo2 ~= CharacterMicroButton) or (relAnchor2 ~= "BOTTOMLEFT") or (math.abs(x2) > STANDARD_EPSILON) or (math.abs(y2+1) > STANDARD_EPSILON)) then
				MoveMicroButtons(point, relativeFrame, relativePoint, ofsx, ofsy, true);
			end
		else
			if ((anchor2 ~= "BOTTOMLEFT") or (anchorTo2 ~= GuildMicroButton) or (relAnchor2 ~= "BOTTOMRIGHT") or (math.abs(x2+2) > STANDARD_EPSILON) or (math.abs(y2) > STANDARD_EPSILON)) then
				MoveMicroButtons(point, relativeFrame, relativePoint, ofsx, ofsy, false);
			end
		end
	end
end

-- Function to fast-check if TitanPanel addon is present
function ClassicUI:CheckTitanPanel()
	if (ClassicUI.TitanPanelIsPresent) then
		return true
	else
		if ((TITAN_PANEL_BAR_HEIGHT == nil) or (TitanUtils_AddonAdjust == nil) or (TitanPanelGetVar == nil)) then
			return false
		else
			TitanUtils_AddonAdjust("MainMenuBar", true)
			TitanUtils_AddonAdjust("OverrideActionBar", true)
			TitanUtils_AddonAdjust("MultiBarRight", true)
			TitanUtils_AddonAdjust("MicroButtonAndBagsBar", true)
			if (MainMenuBar:IsUserPlaced()) then
				MainMenuBar:SetMovable(true)
				MainMenuBar:SetUserPlaced(false)
				MainMenuBar:SetMovable(false)
			elseif (MainMenuBar:IsMovable()) then
				MainMenuBar:SetMovable(false)
			end
			ClassicUI.TitanPanelIsPresent = true
			return true
		end
	end
end

-- Function to fast-check if Jostle addon library is present
function ClassicUI:CheckLibJostle()
	if (ClassicUI.LibJostleIsPresent) then
		return true
	else
		local Jostle = LibStub:GetLibrary("LibJostle-3.0", true)
		if (Jostle == nil) then
			local ChocolateBar = LibStub("AceAddon-3.0"):GetAddon("ChocolateBar", true)
			if (ChocolateBar) then
				Jostle = ChocolateBar.Jostle
			end
		end
		if (Jostle == nil) then
			return false
		else
			if (not Gypsy_HotBarCapsule) then
				Gypsy_HotBarCapsule = {}
			end
			if (MainMenuBar:IsUserPlaced()) then
				MainMenuBar:SetMovable(true)
				MainMenuBar:SetUserPlaced(false)
				MainMenuBar:SetMovable(false)
			elseif (MainMenuBar:IsMovable()) then
				MainMenuBar:SetMovable(false)
			end
			ClassicUI.LibJostleIsPresent = true
			return true
		end
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

-- Function to update the status bar cached variables
function ClassicUI:UpdateStatusBarCache()
	ClassicUI.cached_DoubleStatusBar_hide = nil
	ClassicUI.cached_SingleStatusBar_hide = nil
	for k, v in pairs(ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.hide) do
		if (v) then
			if (ClassicUI.cached_DoubleStatusBar_hide == nil) then
				ClassicUI.cached_DoubleStatusBar_hide = {}
			end
			table.insert(ClassicUI.cached_DoubleStatusBar_hide, k)
		end
	end
	for k, v in pairs(ClassicUI.db.profile.barsConfig.SingleStatusBar.hide) do
		if (v) then
			if (ClassicUI.cached_SingleStatusBar_hide == nil) then
				ClassicUI.cached_SingleStatusBar_hide = {}
			end
			table.insert(ClassicUI.cached_SingleStatusBar_hide, k)
		end
	end
end

-- Function to force a Update of ExhaustionTick from ExpBar (StatusBar)
function ClassicUI:ForceExpBarExhaustionTickUpdate()
	for _, bar in pairs(StatusTrackingBarManager.bars) do
		if ((bar:GetPriority() == 0) and (bar:ShouldBeVisible()) and (bar.ExhaustionTick)) then
			bar.ExhaustionTick:UpdateTickPosition();
		end
	end
end

-- Function to update the status bars when requested
function ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
	if (ClassicUI:IsEnabled()) then
		local visBars = {};
		for i, bar in ipairs(StatusTrackingBarManager.bars) do
			if ( bar:ShouldBeVisible() ) then
				table.insert(visBars, bar);
			end
		end
		table.sort(visBars, function(left, right) return left:GetPriority() < right:GetPriority() end);
		local width = StatusTrackingBarManager:GetParent():GetSize();
		local TOP_BAR = true;
		local IS_DOUBLE = true;
		if ( #visBars > 1 ) then
			ClassicUI.StatusTrackingBarManager_LayoutBar(StatusTrackingBarManager, visBars[2], width, not TOP_BAR, IS_DOUBLE);
			ClassicUI.StatusTrackingBarManager_LayoutBar(StatusTrackingBarManager, visBars[1], width, TOP_BAR, IS_DOUBLE);
		elseif( #visBars == 1 ) then
			ClassicUI.StatusTrackingBarManager_LayoutBar(StatusTrackingBarManager, visBars[1], width, TOP_BAR, not IS_DOUBLE);
		end
	end
end

function ClassicUI:ExtraFunction()
	--Extra Option: Guild Panel Mode
	if ((ClassicUI.db.profile.extraConfigs.GuildPanelMode.defauiltOpenOldMenu) or (ClassicUI.db.profile.extraConfigs.GuildPanelMode.rightClickMicroButtonOpenOldMenu) or (ClassicUI.db.profile.extraConfigs.GuildPanelMode.leftClickMicroButtonOpenOldMenu)) then
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

function ClassicUI:MainFunction()
	-- Localize some variables
	local _
	local BAG_SIZE = ClassicUI.BAG_SIZE
	local BAGS_WIDTH = ClassicUI.BAGS_WIDTH
	local ACTION_BAR_OFFSET = ClassicUI.ACTION_BAR_OFFSET
	
	local Update_MultiActionBar
	local Update_PetActionBar
	local Update_StanceBar
	local Update_PossessBar
	local SetPositionForStatusBars_MainMenuBar
	local TransferPetActionBarFrameChildrens
	local StatusTrackingBarManager_LayoutBar
	local CreateMultiBarBottomRightButtonsBackgrounds

	-- Create the frame and the flag variables needed to execute protected functions after leave combat.
	-- If a protected function tries to running while the player is in combat, a flag for the funcion is
	-- activated and when the player leaves the combat the function is executed.
	local fclFrame = CreateFrame("Frame");
	local delayFunc_SetPositionForStatusBars_MainMenuBar = false
	local delayFunc_Update_MultiActionBar = false
	local delayFunc_Update_PossessBar = false
	local delayFunc_Update_StanceBar = false
	local delayFunc_Update_PetActionBar = false
	local delayFunc_TransferPetActionBarFrameChildrens = false
	fclFrame:SetScript("OnEvent",function(self,event)
		if event=="PLAYER_REGEN_ENABLED" then
			fclFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
			if (delayFunc_SetPositionForStatusBars_MainMenuBar) then
				delayFunc_SetPositionForStatusBars_MainMenuBar = false
				SetPositionForStatusBars_MainMenuBar()
			end
			if (delayFunc_Update_MultiActionBar) then
				delayFunc_Update_MultiActionBar = false
				Update_MultiActionBar()
			end
			if (delayFunc_Update_PossessBar) then
				delayFunc_Update_PossessBar = false
				Update_PossessBar()
			end
			if (delayFunc_Update_StanceBar) then
				delayFunc_Update_StanceBar = false
				Update_StanceBar()
			end
			if (delayFunc_Update_PetActionBar) then
				delayFunc_Update_PetActionBar = false
				Update_PetActionBar()
			end
			if (delayFunc_TransferPetActionBarFrameChildrens) then
				delayFunc_TransferPetActionBarFrameChildrens = false
				TransferPetActionBarFrameChildrens()
			end
		end
	end)
	
	-- Create a second backdrop texture (only cosmetic)
	MainMenuBarArtFrameBackground.BackgroundLarge2 = MainMenuBarArtFrameBackground:CreateTexture();
	MainMenuBarArtFrameBackground.BackgroundLarge2:SetSize(500, 8);
	MainMenuBarArtFrameBackground.BackgroundLarge2:SetPoint("TOPLEFT", MainMenuBarArtFrameBackground.BackgroundLarge, "TOPLEFT", 524, 0);
	MainMenuBarArtFrameBackground.BackgroundLarge2:SetTexture(MicroButtonAndBagsBar.MicroBagBar:GetTexture());
	MainMenuBarArtFrameBackground.BackgroundLarge2:SetTexCoord(154/1024, 654/1024, 116/256, 124/256);
	MainMenuBarArtFrameBackground.BackgroundLarge2:SetAlpha(MainMenuBarArtFrameBackground.BackgroundLarge:GetAlpha())
	
	-- Create new textures for microbuttons backdrop
	MainMenuBarArtFrameBackground.MicroButtonArt = MainMenuBarArtFrameBackground:CreateTexture();
	MainMenuBarArtFrameBackground.MicroButtonArt:SetSize(256, 43);
	MainMenuBarArtFrameBackground.MicroButtonArt:SetPoint("BOTTOMLEFT", MainMenuBarArtFrameBackground.BackgroundLarge, "BOTTOMLEFT", 512, 0);
	MainMenuBarArtFrameBackground.MicroButtonArt:SetTexture("Interface\\MAINMENUBAR\\UI-MainMenuBar-Dwarf.blp");
	MainMenuBarArtFrameBackground.MicroButtonArt:SetTexCoord(0/256, 256/256, 85/256, 128/256);
	
	-- Create new textures for bags backdrop
	MainMenuBarArtFrameBackground.BagsArt = MainMenuBarArtFrameBackground:CreateTexture();
	MainMenuBarArtFrameBackground.BagsArt:SetSize(256, 43);
	MainMenuBarArtFrameBackground.BagsArt:SetPoint("BOTTOMLEFT", MainMenuBarArtFrameBackground.MicroButtonArt, "BOTTOMRIGHT", 0, 0);
	MainMenuBarArtFrameBackground.BagsArt:SetTexture("Interface\\MAINMENUBAR\\UI-MainMenuBar-Dwarf.blp");
	MainMenuBarArtFrameBackground.BagsArt:SetTexCoord(0/256, 256/256, 21/256, 64/256);
	
	-- Move the bags buttons
	MainMenuBarBackpackButton:SetParent(MainMenuBarArtFrame);
	MainMenuBarBackpackButton:ClearAllPoints();
	MainMenuBarBackpackButton:SetPoint("RIGHT", MainMenuBarArtFrameBackground.BagsArt, -4, -1);
	MainMenuBarBackpackButton:SetSize(BAG_SIZE-2, BAG_SIZE-2)
	MainMenuBarBackpackButtonNormalTexture:SetAlpha(0)
	MainMenuBarBackpackButtonCount:ClearAllPoints()
	MainMenuBarBackpackButtonCount:SetPoint("CENTER", 1, -7)
	for i = 0,3 do
		_G["CharacterBag"..i.."Slot"]:SetParent(MainMenuBarArtFrame);
		_G["CharacterBag"..i.."Slot"]:SetSize(BAG_SIZE-2, BAG_SIZE-2);
		_G["CharacterBag"..i.."Slot"].IconBorder:SetSize(BAG_SIZE-2, BAG_SIZE-2);
		--_G["CharacterBag"..i.."SlotNormalTexture"]:SetAlpha(0)	-- seems unnecessary, at least for this icons size
	end
	CharacterBag0Slot:ClearAllPoints();
	CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarArtFrameBackground.BagsArt, -36, -1);

	-- Hide and resize the old MicroButtonAndBagsBar frame.
	MicroButtonAndBagsBar:SetWidth(1);	-- This allow the UIParent code center the MainMenuBar frame correctly.
	MicroButtonAndBagsBar:Hide();
	
	-- Disable clicks on MainMenuBar
	MainMenuBar:EnableMouse(false);
	
	-- Move Latency and Ticket MicroButtons
	MainMenuBarPerformanceBar:SetPoint("CENTER", MainMenuBarPerformanceBar:GetParent(), "CENTER", 0, 11);
	HelpOpenTicketButton:SetPoint("CENTER", HelpOpenTicketButton:GetParent(), "TOPRIGHT", -3, -4);
	HelpOpenWebTicketButton:SetPoint("CENTER", HelpOpenWebTicketButton:GetParent(), "TOPRIGHT", -3, -4);
	
	-- Hide the Gargoyles (will be processed later)
	MainMenuBarArtFrame.LeftEndCap:Hide()
	MainMenuBarArtFrame.RightEndCap:Hide()
	
	-- Get and set the cached values for the status bar variables
	ClassicUI:UpdateStatusBarCache()
	
	-- Create a new subFrame CUI_PetActionBarFrame of PetActionBarFrame
	CUI_PetActionBarFrame = CreateFrame("Frame", "CUI_PetActionBarFrame", PetActionBarFrame)
	CUI_PetActionBarFrame:SetSize(PetActionBarFrame:GetSize())
	CUI_PetActionBarFrame:SetPoint(PetActionBarFrame:GetPoint())
	CUI_PetActionBarFrame:SetFrameStrata(PetActionBarFrame:GetFrameStrata())
	CUI_PetActionBarFrame:EnableMouse(false)
	
	-- Function to set the new parent (CUI_PetActionBarFrame) for the PetActionBarFrame childrens and anchor they to CUI_PetActionBarFrame
	ClassicUI.TransferPetActionBarFrameChildrens = function()
		if InCombatLockdown() then
			delayFunc_TransferPetActionBarFrameChildrens = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		delayFunc_TransferPetActionBarFrameChildrens = false
		PetActionBarFrame:EnableMouse(false)
		for _, v in ipairs({PetActionBarFrame:GetChildren()}) do
			if (v ~= CUI_PetActionBarFrame) then
				v:SetParent(CUI_PetActionBarFrame)
			end
			local point, relativeTo, relativePoint, xOfs, yOfs = v:GetPoint()
			if (relativeTo == PetActionBarFrame) then
				v:ClearAllPoints()
				v:SetPoint(point, CUI_PetActionBarFrame, relativePoint, xOfs, yOfs)
			end
		end
		SlidingActionBarTexture0:SetParent(CUI_PetActionBarFrame)
		SlidingActionBarTexture1:SetParent(CUI_PetActionBarFrame)
		local point, _, relativePoint, xOfs, yOfs = SlidingActionBarTexture0:GetPoint()
		SlidingActionBarTexture0:ClearAllPoints()
		SlidingActionBarTexture0:SetPoint(point, CUI_PetActionBarFrame, relativePoint, xOfs, yOfs)
	end
	TransferPetActionBarFrameChildrens = ClassicUI.TransferPetActionBarFrameChildrens
	TransferPetActionBarFrameChildrens()
	
	-- Function to create the grid background for the MultiBarBottomRightButtons (1 to 6)
	ClassicUI.CreateMultiBarBottomRightButtonsBackgrounds = function()
		if (not ClassicUI.MultiBarBottomRightButtonsBackgroundsCreated) then
			ClassicUI.MultiBarBottomRightButtonsBackgroundsCreated = true
			-- Create the FloatingBG Texture for the normal MultiBarBottomRightButtons
			for i = 1, 6 do
				local buttonBack = _G["MultiBarBottomRightButton"..i.."FloatingBG"]
				if (not buttonBack) then
					local button = _G["MultiBarBottomRightButton"..i]
					buttonBack = button:CreateTexture("MultiBarBottomRightButton"..i.."FloatingBG")
					buttonBack:SetSize(66, 66);
					buttonBack:SetDrawLayer("BACKGROUND", -1)
					buttonBack:SetAlpha(0.4)
					buttonBack:SetTexture("Interface\\Buttons\\UI-Quickslot");
					buttonBack:SetPoint("TOPLEFT", button, "TOPLEFT", -15, 15);
					buttonBack:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 15, -15);
					buttonBack:SetTexCoord(0,0,0,1,1,0,1,1);
				end
			end
			-- Create new background frames for the MultiBarBottomRightButtons
			CUI_MultiBarBottomRightButton1Background = CreateFrame("Button", "CUI_MultiBarBottomRightButton1Background", MultiBarBottomRightButton1:GetParent(), "ActionButtonTemplate")
			CUI_MultiBarBottomRightButton2Background = CreateFrame("Button", "CUI_MultiBarBottomRightButton2Background", MultiBarBottomRightButton2:GetParent(), "ActionButtonTemplate")
			CUI_MultiBarBottomRightButton3Background = CreateFrame("Button", "CUI_MultiBarBottomRightButton3Background", MultiBarBottomRightButton3:GetParent(), "ActionButtonTemplate")
			CUI_MultiBarBottomRightButton4Background = CreateFrame("Button", "CUI_MultiBarBottomRightButton4Background", MultiBarBottomRightButton4:GetParent(), "ActionButtonTemplate")
			CUI_MultiBarBottomRightButton5Background = CreateFrame("Button", "CUI_MultiBarBottomRightButton5Background", MultiBarBottomRightButton5:GetParent(), "ActionButtonTemplate")
			CUI_MultiBarBottomRightButton6Background = CreateFrame("Button", "CUI_MultiBarBottomRightButton6Background", MultiBarBottomRightButton6:GetParent(), "ActionButtonTemplate")
			for i = 1, 6 do
				-- Set properties of the new background frames and anchor it to the normal buttons
				local button = _G["CUI_MultiBarBottomRightButton"..i.."Background"]
				local origButton = _G["MultiBarBottomRightButton"..i]
				button:SetParent(origButton:GetParent())
				button.NormalTexture:SetVertexColor(1.0, 1.0, 1.0, 0.5);
				button:SetPoint("TOPLEFT", origButton, "TOPLEFT", 0, 0)
				button:SetFrameStrata("BACKGROUND")
				button.FloatingBGTexture = button:CreateTexture("CUI_MultiBarBottomRightButton"..i.."BackgroundFloatingBG")
				-- Create the FloatingBG Texture for the new background frames
				local buttonBack = button.FloatingBGTexture
				buttonBack:SetSize(66, 66);
				buttonBack:SetDrawLayer("BACKGROUND", -1)
				buttonBack:SetAlpha(0.4)
				buttonBack:SetTexture("Interface\\Buttons\\UI-Quickslot");
				buttonBack:SetPoint("TOPLEFT", button, "TOPLEFT", -15, 15);
				buttonBack:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 15, -15);
				buttonBack:SetTexCoord(0,0,0,1,1,0,1,1);
				-- Set the background frames HotKey behaviour
				button.HotKey:SetText(origButton.HotKey:GetText())
				if (button.HotKey == RANGE_INDICATOR) then
					button.HotKey:Hide()
				end
				button.HotKey:SetAlpha(origButton.HotKey:GetAlpha())
				hooksecurefunc(origButton.HotKey, "SetText", function(self) button.HotKey:SetText(self:GetText()) end)
				hooksecurefunc(origButton.HotKey, "SetAlpha", function(self) button.HotKey:SetAlpha(self:GetAlpha()) end)
				hooksecurefunc(origButton.HotKey, "Show", function(self) button.HotKey:Show() end)
				hooksecurefunc(origButton.HotKey, "Hide", function(self) button.HotKey:Hide() end)
				-- Set the background frames Visibility behaviour
				if ((ALWAYS_SHOW_MULTIBARS == 1) or (ALWAYS_SHOW_MULTIBARS == "1")) then
					if (not button:IsShown()) then
						button:Show()
					end
				else
					if (button:IsShown()) then
						button:Hide()
					end
				end
				hooksecurefunc(origButton, "Show", function(self)
					if (button:IsShown()) then
						button:Hide()
					end
				end)
				hooksecurefunc(origButton, "Hide", function(self)
					if ((ALWAYS_SHOW_MULTIBARS == 1) or (ALWAYS_SHOW_MULTIBARS == "1")) then
						if (not button:IsShown()) then
							button:Show()
						end
					else
						if (button:IsShown()) then
							button:Hide()
						end
					end
				end)
			end
		end
	end
	CreateMultiBarBottomRightButtonsBackgrounds = ClassicUI.CreateMultiBarBottomRightButtonsBackgrounds
	CreateMultiBarBottomRightButtonsBackgrounds()
	
	--Function to set the position of MultiActionBars
	ClassicUI.Update_MultiActionBar = function()
		if InCombatLockdown() then
			delayFunc_Update_MultiActionBar = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		delayFunc_Update_MultiActionBar = false
		-- Set position and scale MultiBarBottomLeft and MultiBarBottomRight
		if (SHOW_MULTI_ACTIONBAR_1 or SHOW_MULTI_ACTIONBAR_2) then
			MultiBarBottomLeft:ClearAllPoints();
			MultiBarBottomRightButton7:ClearAllPoints();
			MultiBarBottomRightButton1:ClearAllPoints();
			local xPos = 0 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.xOffset
			local yPos = 0
			if (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.ignoreyOffsetStatusBar and StatusTrackingBarManager:IsShown()) then
				if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
					yPos = 9 + 17 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset2StatusBar
				elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
					yPos = 9 + 8 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset1StatusBar
				end
			else
				if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
					yPos = 9 + 17 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset
				elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
					yPos = 9 + 8 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset
				end
			end
			if ( (not StatusTrackingBarManager:IsShown()) or (ClassicUI.cached_NumberVisibleBars < 1) ) then
				yPos = 9 + 3 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset
			end
			MultiBarBottomLeft:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", xPos, yPos);
			MultiBarBottomRightButton1:SetPoint("TOPLEFT", MultiBarBottomLeftButton12, "TOPLEFT", 48, 0);
			MultiBarBottomRightButton7:SetPoint("TOPLEFT", MultiBarBottomRightButton6, "TOPLEFT", 42, 0);
			if ((math.abs(MultiBarBottomLeft:GetScale()-ClassicUI.db.profile.barsConfig.BottomMultiActionBars.scale) > SCALE_EPSILON) or (math.abs(MultiBarBottomRight:GetScale()-ClassicUI.db.profile.barsConfig.BottomMultiActionBars.scale) > SCALE_EPSILON)) then
				MultiBarBottomLeft:SetScale(ClassicUI.db.profile.barsConfig.BottomMultiActionBars.scale)
				MultiBarBottomRight:SetScale(ClassicUI.db.profile.barsConfig.BottomMultiActionBars.scale)
			end
		end
		-- Set position and scale VerticalMultiBarsContainer (yPos) and MultiBarRight (xPos)
		if ( SHOW_MULTI_ACTIONBAR_3 or SHOW_MULTI_ACTION_BAR_4) then
			local yPos = 0
			if (ClassicUI.db.profile.barsConfig.RightMultiActionBars.ignoreyOffsetStatusBar and StatusTrackingBarManager:IsShown()) then
				if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
					yPos = 90 + 17 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset2StatusBar
				elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
					yPos = 90 + 8 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset1StatusBar
				end
			else
				if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
					yPos = 90 + 17 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset
				elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
					yPos = 90 + 8 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset
				end
			end
			if ( (not StatusTrackingBarManager:IsShown()) or (ClassicUI.cached_NumberVisibleBars < 1) ) then
				yPos = 90 + 8 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset
			end
			VerticalMultiBarsContainer:SetPoint("BOTTOMRIGHT", VerticalMultiBarsContainer:GetParent(), 0, yPos);
			MultiBarRight:SetPoint("TOPRIGHT", MultiBarRight:GetParent(), "TOPRIGHT", 2 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.xOffset, 0)
			if (MultiBarLeft:GetParent() ~= VerticalMultiBarsContainer) then
				MultiBarLeft:SetParent(VerticalMultiBarsContainer)
			end
			if (math.abs(VerticalMultiBarsContainer:GetScale()-ClassicUI.db.profile.barsConfig.RightMultiActionBars.scale) > SCALE_EPSILON) then
				VerticalMultiBarsContainer:SetScale(ClassicUI.db.profile.barsConfig.RightMultiActionBars.scale)
			end
		end
	end
	Update_MultiActionBar = ClassicUI.Update_MultiActionBar
	-- Hook function to update MultiActionBars
	hooksecurefunc("MultiActionBar_Update", Update_MultiActionBar);
	
	-- Function to set the position and scale of PetActionBar
	ClassicUI.Update_PetActionBar = function()
		if InCombatLockdown() then
			delayFunc_Update_PetActionBar = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		delayFunc_Update_PetActionBar = false
		-- Set xPos
		local xPos = -(ClassicUI:GetExtraWidth() / 2)
		if ( PetActionBarFrame_IsAboveStance(true) ) then
			xPos = xPos + -74 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffset
		elseif ( MainMenuBarVehicleLeaveButton and MainMenuBarVehicleLeaveButton:IsShown() and (MainMenuBarVehicleLeaveButton:GetRight() ~= nil) ) then
			xPos = xPos + MainMenuBarVehicleLeaveButton:GetRight() + 20;
		elseif ( StanceBarFrame and GetNumShapeshiftForms() > 0 ) then
			xPos = xPos + 390 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffsetIfStanceBar;
		elseif ( MultiCastActionBarFrame and HasMultiCastActionBar() ) then
			xPos = xPos + 390 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffsetIfStanceBar;
		else
			xPos = xPos + -74 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffset
		end
		-- Set yPos
		local yPos = 0
		if (ClassicUI.db.profile.barsConfig.PetActionBarFrame.ignoreyOffsetStatusBar and StatusTrackingBarManager:IsShown()) then
			if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 138 - 4 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset2StatusBar;
				else
					yPos = 138 - 4 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset2StatusBar;
				end
			elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 138 - 10 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset1StatusBar;
				else
					yPos = 138 - 10 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset1StatusBar;
				end
			end
		else
			if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 138 - 4 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
				else
					yPos = 138 - 4 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
				end
			elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 138 - 10 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
				else
					yPos = 138 - 10 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
				end
			end
		end
		if ( ClassicUI.cached_NumberVisibleBars < 1 ) then
			if ( SHOW_MULTI_ACTIONBAR_1 ) then
				yPos = 137 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
			else
				yPos = 137 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
			end
		end
		if (not StatusTrackingBarManager:IsShown()) then
			if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
				yPos = yPos - 14
			elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
				yPos = yPos - 5
			end
		end
		if (ClassicUI.TitanPanelIsPresent) then
			yPos = yPos + ClassicUI.TitanPanelBottomBarsYOffset
		end
		-- Set position for PetActionBarFrame to xPos, yPos
		CUI_PetActionBarFrame:SetPoint("TOPLEFT", PetActionBarFrame:GetParent(), "BOTTOMLEFT", xPos, yPos);
		-- Set scale for PetActionBar
		if (math.abs(PetActionBarFrame:GetScale()-ClassicUI.db.profile.barsConfig.PetActionBarFrame.scale) > SCALE_EPSILON) then
			PetActionBarFrame:SetScale(ClassicUI.db.profile.barsConfig.PetActionBarFrame.scale)
		end
	end
	Update_PetActionBar = ClassicUI.Update_PetActionBar
	--Hook a function to update PetActionBar
	hooksecurefunc('PetActionBar_UpdatePositionValues', Update_PetActionBar)
	
	-- Function to set the position and scale of StanceBar
	ClassicUI.Update_StanceBar = function()
		if InCombatLockdown() then
			delayFunc_Update_StanceBar = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		delayFunc_Update_StanceBar = false
		-- Set xPos
		local xPos = -80 + ClassicUI.db.profile.barsConfig.StanceBarFrame.xOffset - (ClassicUI:GetExtraWidth() / 2)
		-- Set yPos
		local yPos = 0
		if (ClassicUI.db.profile.barsConfig.StanceBarFrame.ignoreyOffsetStatusBar and StatusTrackingBarManager:IsShown()) then
			if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 41 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset2StatusBar
				else
					yPos = 41 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset2StatusBar
				end
			elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 35 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset1StatusBar
				else
					yPos = 35 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset1StatusBar
				end
			end
		else
			if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 41 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
				else
					yPos = 41 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
				end
			elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 35 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
				else
					yPos = 35 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
				end
			end
		end
		if ( ClassicUI.cached_NumberVisibleBars < 1 ) then
			if ( SHOW_MULTI_ACTIONBAR_1 ) then
				yPos = 44 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
			else
				yPos = 44 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
			end
		end
		if (not StatusTrackingBarManager:IsShown()) then
			if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
				yPos = yPos - 14
			elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
				yPos = yPos - 5
			end
		end
		if (ClassicUI.TitanPanelIsPresent) then
			yPos = yPos + ClassicUI.TitanPanelBottomBarsYOffset
		end
		-- Set position for StanceBarFrame to xPos, yPos
		StanceBarFrame:SetPoint("BOTTOMLEFT", StanceBarFrame:GetParent(), "TOPLEFT", xPos, yPos)
		-- Set scale for StanceBarFrame
		if (math.abs(StanceBarFrame:GetScale()-ClassicUI.db.profile.barsConfig.StanceBarFrame.scale) > SCALE_EPSILON) then
			StanceBarFrame:SetScale(ClassicUI.db.profile.barsConfig.StanceBarFrame.scale)
		end
	end
	Update_StanceBar = ClassicUI.Update_StanceBar
	-- Hook this function to update StanceBar
	hooksecurefunc("StanceBar_Update", Update_StanceBar)

	-- Function to set the position and scale of PossessBar
	ClassicUI.Update_PossessBar = function()
		if InCombatLockdown() then
			delayFunc_Update_PossessBar = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		delayFunc_Update_PossessBar = false
		-- Set xPos
		local xPos = -80 + ClassicUI.db.profile.barsConfig.PossessBarFrame.xOffset - (ClassicUI:GetExtraWidth() / 2)
		-- Set yPos
		local yPos = 0
		if (ClassicUI.db.profile.barsConfig.PossessBarFrame.ignoreyOffsetStatusBar and StatusTrackingBarManager:IsShown()) then
			if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 41 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset2StatusBar
				else
					yPos = 41 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset2StatusBar
				end
			elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 35 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset1StatusBar
				else
					yPos = 35 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset1StatusBar
				end
			end
		else
			if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 41 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
				else
					yPos = 41 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
				end
			elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 35 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
				else
					yPos = 35 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
				end
			end
		end
		if ( ClassicUI.cached_NumberVisibleBars < 1 ) then
			if ( SHOW_MULTI_ACTIONBAR_1 ) then
				yPos = 44 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
			else
				yPos = 44 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
			end
		end
		if (not StatusTrackingBarManager:IsShown()) then
			if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
				yPos = yPos - 14
			elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
				yPos = yPos - 5
			end
		end
		if (ClassicUI.TitanPanelIsPresent) then
			yPos = yPos + ClassicUI.TitanPanelBottomBarsYOffset
		end
		-- Set position for PossessBarFrame to xPos, yPos
		PossessBarFrame:SetPoint("BOTTOMLEFT", PossessBarFrame:GetParent(), "TOPLEFT", xPos, yPos)
		-- Set scale for PossessBarFrame
		if (math.abs(PossessBarFrame:GetScale()-ClassicUI.db.profile.barsConfig.PossessBarFrame.scale) > SCALE_EPSILON) then
			PossessBarFrame:SetScale(ClassicUI.db.profile.barsConfig.PossessBarFrame.scale)
		end
	end
	Update_PossessBar = ClassicUI.Update_PossessBar
	-- Hook this function to update StanceBar
	hooksecurefunc("PossessBar_Update", Update_PossessBar)
	
	-- Function to modify the status bars (enlarge status bars to include bags and microbuttons and move it between the 2 rows of buttons)
	ClassicUI.StatusTrackingBarManager_LayoutBar = function (self, bar, barWidth, isTopBar, isDouble)
		-- Seems that this function does not need protection (InCombatLockdown)
		bar:ClearAllPoints();
		local width = barWidth + BAGS_WIDTH + 60 + ClassicUI:GetExtraWidth()
		if ( isDouble ) then
			self:SetDoubleBarSize(bar, width);
			self.SingleBarLargeUpper:SetSize(width + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSize, 9 + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySize); 
			self.SingleBarLarge:SetSize(width + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSize, 12 + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySize)
			if ( isTopBar ) then
				bar:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "TOPLEFT", 0 + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffset, -7 + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffset);
				bar.StatusBar:SetPoint("RIGHT", bar, "RIGHT", 0, -1);
				bar.OverlayFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", 0 + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffsetOverlay, -1 + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffsetOverlay)
				if (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.overlayHide) then
					bar.OverlayFrame:Hide()
				else
					if (not bar.OverlayFrame:IsShown()) then
						bar.OverlayFrame:Show()
					end
					bar.OverlayFrame:SetAlpha(ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.overlayAlpha);
				end
				self.SingleBarLarge:SetPoint("CENTER", bar, "CENTER", 0 - ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffset + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffset - (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSize / 2) + (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSize / 2) + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffsetArt, -10 - ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffset + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffset - (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySize / 2) + (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySize / 2) + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffsetArt)
				self.SingleBarLargeUpper:SetPoint("TOP", self.SingleBarLarge, "TOP", 0 + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffset - ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffset - ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffsetArt + (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSize / 2) - (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSize / 2) + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffsetArt, 8 + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffset - ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffset - ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffsetArt + (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySize) - ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySize + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffsetArt)
				if (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artHide) then
					self.SingleBarLargeUpper:Hide()
				else
					self.SingleBarLargeUpper:SetAlpha(ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artAlpha)
				end
				if (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artHide) then
					self.SingleBarLarge:Hide()
				else
					self.SingleBarLarge:SetAlpha(ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artAlpha)
				end
				bar.StatusBar:SetSize(width + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSize, 9 + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySize);
				if ((bar.priority == 0) and (bar.ExhaustionLevelFillBar)) then
					bar.ExhaustionLevelFillBar:SetSize(width + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSize, 9 + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySize)
				end
				bar:SetSize(width + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSize, 9 + ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySize);
				bar.StatusBar.Background:SetAlpha(ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.alpha);
			else
				bar:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "TOPLEFT", 0 + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffset, -18 + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffset);
				bar.StatusBar:SetPoint("RIGHT", bar, "RIGHT", 0, 0);
				bar.OverlayFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", 0 + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffsetOverlay, -3 + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffsetOverlay)
				if (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.overlayHide) then
					bar.OverlayFrame:Hide()
				else
					if (not bar.OverlayFrame:IsShown()) then
						bar.OverlayFrame:Show()
					end
					bar.OverlayFrame:SetAlpha(ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.overlayAlpha);
				end
				bar.StatusBar:SetSize(width + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSize, 11 + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySize);
				if ((bar.priority == 0) and (bar.ExhaustionLevelFillBar)) then
					bar.ExhaustionLevelFillBar:SetSize(width + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSize, 11 + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySize)
				end
				bar:SetSize(width + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSize, 12 + ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySize);
				bar.StatusBar.Background:SetAlpha(ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.alpha);
			end
		else
			bar:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "TOPLEFT", 0 + ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffset, -18 + ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffset);
			bar.StatusBar:SetPoint("RIGHT", bar, "RIGHT", 0, 0);
			bar.OverlayFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", 0 + ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffsetOverlay, -3 + ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffsetOverlay)
			if (ClassicUI.db.profile.barsConfig.SingleStatusBar.overlayHide) then
				bar.OverlayFrame:Hide()
			else
				if (not bar.OverlayFrame:IsShown()) then
					bar.OverlayFrame:Show()
				end
				bar.OverlayFrame:SetAlpha(ClassicUI.db.profile.barsConfig.SingleStatusBar.overlayAlpha);
			end
			self:SetSingleBarSize(bar, width);
			self.SingleBarLarge:SetSize(width + ClassicUI.db.profile.barsConfig.SingleStatusBar.xSize, 12 + ClassicUI.db.profile.barsConfig.SingleStatusBar.ySize);
			self.SingleBarLarge:SetPoint("CENTER", bar, "CENTER", 0 + ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffsetArt, 0 + ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffsetArt)
			if (ClassicUI.db.profile.barsConfig.SingleStatusBar.artHide) then
				self.SingleBarLarge:Hide()
			else
				self.SingleBarLarge:SetAlpha(ClassicUI.db.profile.barsConfig.SingleStatusBar.artAlpha)
			end
			bar.StatusBar:SetSize(width + ClassicUI.db.profile.barsConfig.SingleStatusBar.xSize, 12 + ClassicUI.db.profile.barsConfig.SingleStatusBar.ySize);
			if ((bar.priority == 0) and (bar.ExhaustionLevelFillBar)) then
				bar.ExhaustionLevelFillBar:SetSize(width + ClassicUI.db.profile.barsConfig.SingleStatusBar.xSize, 12 + ClassicUI.db.profile.barsConfig.SingleStatusBar.ySize)
			end
			bar:SetSize(width + ClassicUI.db.profile.barsConfig.SingleStatusBar.xSize, 12 + ClassicUI.db.profile.barsConfig.SingleStatusBar.ySize);
			bar.StatusBar.Background:SetAlpha(ClassicUI.db.profile.barsConfig.SingleStatusBar.alpha);
		end
	end
	StatusTrackingBarManager_LayoutBar = ClassicUI.StatusTrackingBarManager_LayoutBar
	-- Hook this function to StatusTrackingBarManager:LayoutBar
	hooksecurefunc(StatusTrackingBarManager, "LayoutBar", StatusTrackingBarManager_LayoutBar)
	
	-- Hook this function to execute 'SetDoubleBarSize' as if it has self.largeSize=true
	hooksecurefunc(StatusTrackingBarManager, 'SetDoubleBarSize', function(self, bar, width)
		local textureHeight = self:GetInitialBarHeight(); 
		local statusBarHeight = textureHeight - 4; 
		if ( not self.largeSize ) then
			self.SingleBarSmallUpper:Hide(); 
			self.SingleBarSmall:Hide(); 
		end
		self.SingleBarLargeUpper:SetSize(width, statusBarHeight); 
		self.SingleBarLargeUpper:SetPoint("CENTER", bar, 0, 4);
		self.SingleBarLargeUpper:Show();
		self.SingleBarLarge:SetSize(width, statusBarHeight); 
		self.SingleBarLarge:SetPoint("CENTER", bar, 0, -9);
		self.SingleBarLarge:Show(); 
	end)
	
	-- Hook this function to execute 'SetSingleBarSize' as if it has self.largeSize=true
	hooksecurefunc(StatusTrackingBarManager, 'SetSingleBarSize', function(self, bar, width) 
		local textureHeight = self:GetInitialBarHeight();
		if ( not self.largeSize ) then
			self.SingleBarSmall:Hide(); 
		end
		self.SingleBarLarge:SetSize(width, textureHeight); 
		self.SingleBarLarge:SetPoint("CENTER", bar, 0, 0);
		self.SingleBarLarge:Show(); 
	end)
	
	-- Function to move the rest indicator
	hooksecurefunc(ExhaustionTickMixin, "UpdateTickPosition", function(self)
		local playerCurrXP = UnitXP("player");
		local playerMaxXP = UnitXPMax("player");
		local exhaustionThreshold = GetXPExhaustion();
		local exhaustionStateID, exhaustionStateName, exhaustionStateMultiplier = GetRestState();
		
		if ( exhaustionStateID and exhaustionStateID >= 3 ) then
			self:SetPoint("CENTER", self:GetParent() , "RIGHT", 0, 0);
		end

		if ( not exhaustionThreshold ) then
			return
		else
			local exhaustionTickSet = max(((playerCurrXP + exhaustionThreshold) / playerMaxXP) * (self:GetParent():GetWidth()), 0);
			self:ClearAllPoints();
			if ( exhaustionTickSet > self:GetParent():GetWidth() ) then
				return
			else
				self:SetPoint("CENTER", self:GetParent(), "LEFT", exhaustionTickSet, 0);
			end
		end
	end)
	
	-- Hook to move MicroButtons when the MainMenuBar is Showed
	MainMenuBar:HookScript("OnShow", function()
		ClassicUI:MoveMicroButtons("BOTTOMLEFT", MainMenuBarArtFrameBackground.MicroButtonArt, "BOTTOMLEFT", 45, 2, false)
	end)
	
	-- Hook to refresh the cached values of the last not nil point positions for the MainMenuBar
	hooksecurefunc(MainMenuBar, "SetPoint", function(self)
		local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
		if (point ~= nil) and (xOfs ~= nil) and (yOfs ~= nil) then
			ClassicUI.cached_LastMainMenuBarPoint = { point, relativeTo, relativePoint, xOfs, yOfs }
		end
	end)
	
	-- A function to update all bars and frames, especially the MainMenuBar, MicroButtons and bags frames
	ClassicUI.SetPositionForStatusBars_MainMenuBar = function()
		local extraWidth = ClassicUI:GetExtraWidth()
		
		-- Show/Hide Gargoyles and set their scale and alpha
		if (ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.hide) then
			if (MainMenuBarArtFrame.LeftEndCap:IsShown()) then
				MainMenuBarArtFrame.LeftEndCap:Hide()
			end
		else
			if (not MainMenuBarArtFrame.LeftEndCap:IsShown()) then
				MainMenuBarArtFrame.LeftEndCap:Show()
				if (ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.model == 1) then
					MainMenuBarArtFrame.LeftEndCap:SetSize(128, 86)
					MainMenuBarArtFrame.LeftEndCap:SetTexture("Interface\\MAINMENUBAR\\UI-MainMenuBar-EndCap-Human.blp")
					MainMenuBarArtFrame.LeftEndCap:SetTexCoord(0/128, 128/128, 42/128, 128/128)
				end
				if (math.abs(MainMenuBarArtFrame.LeftEndCap:GetScale()-ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.scale) > SCALE_EPSILON) then
					MainMenuBarArtFrame.LeftEndCap:SetScale(ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.scale)
				end
				MainMenuBarArtFrame.LeftEndCap:SetAlpha(ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.alpha)
			end
		end
		if (ClassicUI.db.profile.barsConfig.RightGargoyleFrame.hide) then
			if (MainMenuBarArtFrame.RightEndCap:IsShown()) then
				MainMenuBarArtFrame.RightEndCap:Hide()
			end
		else
			if (not MainMenuBarArtFrame.RightEndCap:IsShown()) then
				MainMenuBarArtFrame.RightEndCap:Show()
				if (ClassicUI.db.profile.barsConfig.RightGargoyleFrame.model == 1) then
					MainMenuBarArtFrame.RightEndCap:SetSize(128, 86)
					MainMenuBarArtFrame.RightEndCap:SetTexture("Interface\\MAINMENUBAR\\UI-MainMenuBar-EndCap-Human.blp")
					MainMenuBarArtFrame.RightEndCap:SetTexCoord(128/128, 0/128, 42/128, 128/128)
				end
				MainMenuBarArtFrame.RightEndCap:SetAlpha(ClassicUI.db.profile.barsConfig.RightGargoyleFrame.alpha)
				if (math.abs(MainMenuBarArtFrame.RightEndCap:GetScale()-ClassicUI.db.profile.barsConfig.RightGargoyleFrame.scale) > SCALE_EPSILON) then
					MainMenuBarArtFrame.RightEndCap:SetScale(ClassicUI.db.profile.barsConfig.RightGargoyleFrame.scale)
				end
			end
		end
		
		-- Move Gargoyles
		MainMenuBarArtFrame.LeftEndCap:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "BOTTOMLEFT", 64 - BAGS_WIDTH + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.xOffset, -10 + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.yOffset);
		MainMenuBarArtFrame.RightEndCap:SetPoint("BOTTOMRIGHT", MainMenuBarArtFrame, "BOTTOMRIGHT", 156 + BAGS_WIDTH + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.xOffset + extraWidth, -10 + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.yOffset);
		
		-- If OverrideActionBar or PetBattleFrame are showed, let the Blizzard code move the MicroButtons. If are hidden we must move the MicroButtons on our frame.
		if ((not OverrideActionBar:IsShown()) and (not PetBattleFrame:IsShown())) then
			ClassicUI:MoveMicroButtons("BOTTOMLEFT", MainMenuBarArtFrameBackground.MicroButtonArt, "BOTTOMLEFT", 45, 2, false);
		end
		
		-- Move the PageNumber frame
		MainMenuBarArtFrame.PageNumber:ClearAllPoints();
		MainMenuBarArtFrame.PageNumber:SetPoint("CENTER", MainMenuBarArtFrameBackground.MicroButtonArt, "LEFT", 30, 0);
		
		-- Compatibility with TitanPanel
		if (ClassicUI:CheckTitanPanel()) then
			if (not TitanPanelGetVar("AuxScreenAdjust")) then
				local titan_barnum_bot = 0
				if TitanPanelGetVar("AuxBar2_Show") then
					titan_barnum_bot = 2
				elseif TitanPanelGetVar("AuxBar_Show") then
					titan_barnum_bot = 1
				end
				local titan_scale = TitanPanelGetVar("Scale")
				if (titan_scale and (titan_barnum_bot > 0)) then
					ClassicUI.TitanPanelBottomBarsYOffset = (TITAN_PANEL_BAR_HEIGHT * titan_scale) * (titan_barnum_bot) - 1; 
				else
					ClassicUI.TitanPanelBottomBarsYOffset = 0
				end
			else
				ClassicUI.TitanPanelBottomBarsYOffset = 0
			end
		end
		
		-- Compatibility with LibJostle library
		ClassicUI:CheckLibJostle()
		
		-- Compatibility with addons that sets MainMenuBar or MicroButtonAndBagsBar as UserPlaced
		local wasUserPlaced = false
		if (MainMenuBar:IsUserPlaced()) then
			wasUserPlaced = true
			MainMenuBar:SetMovable(true)
			MainMenuBar:SetUserPlaced(false)
			MainMenuBar:SetMovable(false)
		elseif (MainMenuBar:IsMovable()) then
			MainMenuBar:SetMovable(false)
		end
		if (MicroButtonAndBagsBar:IsUserPlaced()) then
			wasUserPlaced = true
			MicroButtonAndBagsBar:SetMovable(true)
			MicroButtonAndBagsBar:SetUserPlaced(false)
			MicroButtonAndBagsBar:SetMovable(false)
		elseif (MicroButtonAndBagsBar:IsMovable()) then
			MicroButtonAndBagsBar:SetMovable(false)
		end
		
		if InCombatLockdown() then
			delayFunc_SetPositionForStatusBars_MainMenuBar = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		delayFunc_SetPositionForStatusBars_MainMenuBar = false
		
		-- Reposition MainMenuBarArtFrame and use it as the anchor instead of MainMenuBar where possible
		MainMenuBarArtFrameBackground:ClearAllPoints();
		MainMenuBarArtFrameBackground:SetPoint("BOTTOM", MainMenuBarArtFrame, 0, -10);
		
		-- Update the cached number of visible bars
		ClassicUI.cached_NumberVisibleBars = StatusTrackingBarManager:GetNumberVisibleBars()
		ClassicUI.cached_NumberRealVisibleBars = ClassicUI.cached_NumberVisibleBars
		-- Set the offsetY for the MainMenuBarArtFrame and also show/hide StatusBars if needed
		local offsetY;
		if ( ClassicUI.cached_NumberVisibleBars == 2 ) then
			-- Set offsetY
			offsetY = -19 + ClassicUI.TitanPanelBottomBarsYOffset;
			-- Show/Hide the DoubleStatusBar
			if (ClassicUI.cached_DoubleStatusBar_hide) then
				local hideDoubleStatusBar = false
				local barsShown = {}
				for _, v in pairs(StatusTrackingBarManager.bars) do
					if (v:ShouldBeVisible()) then
						table.insert(barsShown, v:GetPriority())
					end
				end
				table.sort(barsShown)
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
					if (StatusTrackingBarManager:IsShown()) then
						StatusTrackingBarManager:Hide()
					end
				else
					if (not StatusTrackingBarManager:IsShown()) then
						StatusTrackingBarManager:Show()
					end
				end
			else
				if (not StatusTrackingBarManager:IsShown()) then
					StatusTrackingBarManager:Show()
				end
			end
		elseif ( ClassicUI.cached_NumberVisibleBars == 1 ) then
			-- Set offsetY
			offsetY = -14 + ClassicUI.TitanPanelBottomBarsYOffset;
			-- Show/Hide the SingleStatusBar
			if (ClassicUI.cached_SingleStatusBar_hide) then
				local hideSingleStatusBar = false
				local barsShown = {}
				for _, v in pairs(StatusTrackingBarManager.bars) do
					if (v:ShouldBeVisible()) then
						table.insert(barsShown, v:GetPriority())
					end
				end
				table.sort(barsShown)
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
					if (StatusTrackingBarManager:IsShown()) then
						StatusTrackingBarManager:Hide()
					end
				else
					if (not StatusTrackingBarManager:IsShown()) then
						StatusTrackingBarManager:Show()
					end
				end
			else
				if (not StatusTrackingBarManager:IsShown()) then
					StatusTrackingBarManager:Show()
				end
			end
		else
			-- Set offsetY
			offsetY = 0 + ClassicUI.TitanPanelBottomBarsYOffset;
		end
		
		-- Modify the MainMenuBarArtFrameBackground to show/hidde the background top border
		local _, _, _, _, yPosMainMenuBL = MainMenuBarArtFrameBackground.BackgroundLarge:GetPoint();
		if ( ClassicUI.cached_NumberRealVisibleBars > 0 ) then
			if (yPosMainMenuBL ~= -7) then
				MainMenuBarArtFrameBackground.BackgroundLarge:SetTexCoord(0, 1, 7/49, 1)
				MainMenuBarArtFrameBackground.BackgroundSmall:SetTexCoord(0, 1, 7/49, 1)
				MainMenuBarArtFrameBackground.BackgroundLarge:SetPoint("TOPLEFT", MainMenuBarArtFrameBackground, "TOPLEFT", 0, -7)
				MainMenuBarArtFrameBackground.BackgroundSmall:SetPoint("TOPLEFT", MainMenuBarArtFrameBackground, "TOPLEFT", 0, -7)
				MainMenuBarArtFrameBackground.BackgroundLarge2:Hide()
			end
		else
			if (yPosMainMenuBL ~= 0) then
				MainMenuBarArtFrameBackground.BackgroundLarge:SetTexCoord(0, 1, 0, 1)
				MainMenuBarArtFrameBackground.BackgroundSmall:SetTexCoord(0, 1, 0, 1)
				MainMenuBarArtFrameBackground.BackgroundLarge:SetPoint("TOPLEFT", MainMenuBarArtFrameBackground, "TOPLEFT", 0, 0)
				MainMenuBarArtFrameBackground.BackgroundSmall:SetPoint("TOPLEFT", MainMenuBarArtFrameBackground, "TOPLEFT", 0, 0)
				MainMenuBarArtFrameBackground.BackgroundLarge2:Show()
			end
		end
		
		-- Detect and fix the unresponsive action bars issue caused by other addons that sets the MainMenuBar or the MicroButtonAndBagsBar as UserPlaced
		if ((MainMenuBar:IsUserPlaced() or MicroButtonAndBagsBar:IsUserPlaced() or wasUserPlaced) and (MainMenuBar:GetPoint() == nil)) then
			MainMenuBar:SetPoint(ClassicUI.cached_LastMainMenuBarPoint[1], ClassicUI.cached_LastMainMenuBarPoint[2], ClassicUI.cached_LastMainMenuBarPoint[3], ClassicUI.cached_LastMainMenuBarPoint[4], ClassicUI.cached_LastMainMenuBarPoint[5])
		end
		
		-- Set the position and scale for MainMenuBarArtFrame
		local menuBarBagsWidth = BAGS_WIDTH + 60 + extraWidth;
		MainMenuBarArtFrame:SetPoint("TOPLEFT", MainMenuBarArtFrame:GetParent(), ((-menuBarBagsWidth)/2) + ClassicUI.db.profile.barsConfig.MainMenuBar.xOffset, 10 + offsetY + ClassicUI.db.profile.barsConfig.MainMenuBar.yOffset);
		MainMenuBarArtFrame:SetPoint("BOTTOMRIGHT", MainMenuBarArtFrame:GetParent(), ((-menuBarBagsWidth)/2) + ClassicUI.db.profile.barsConfig.MainMenuBar.xOffset, 10 + offsetY + ClassicUI.db.profile.barsConfig.MainMenuBar.yOffset);
		if ((math.abs(MainMenuBarArtFrame:GetScale()-ClassicUI.db.profile.barsConfig.MainMenuBar.scale) > SCALE_EPSILON) or (math.abs(StatusTrackingBarManager:GetScale()-ClassicUI.db.profile.barsConfig.MainMenuBar.scale) > SCALE_EPSILON)) then
			MainMenuBarArtFrame:SetScale(ClassicUI.db.profile.barsConfig.MainMenuBar.scale)
			StatusTrackingBarManager:SetScale(ClassicUI.db.profile.barsConfig.MainMenuBar.scale)
		end
		
		-- Set the position and scale for OverrideActionBar
		OverrideActionBar:SetPoint("BOTTOM", OverrideActionBar:GetParent(), "BOTTOM", ClassicUI.db.profile.barsConfig.OverrideActionBar.xOffset, ClassicUI.db.profile.barsConfig.OverrideActionBar.yOffset + ClassicUI.TitanPanelBottomBarsYOffset)
		if (math.abs(OverrideActionBar:GetScale()-ClassicUI.db.profile.barsConfig.OverrideActionBar.scale) > SCALE_EPSILON) then
			OverrideActionBar:SetScale(ClassicUI.db.profile.barsConfig.OverrideActionBar.scale)
		end
		
		-- Set the position and scale for PetBattleFrameBar
		PetBattleFrame.BottomFrame:SetPoint("BOTTOM", PetBattleFrame.BottomFrame:GetParent(), "BOTTOM", ClassicUI.db.profile.barsConfig.PetBattleFrameBar.xOffset, ClassicUI.db.profile.barsConfig.PetBattleFrameBar.yOffset)
		if (math.abs(PetBattleFrame.BottomFrame:GetScale()-ClassicUI.db.profile.barsConfig.PetBattleFrameBar.scale) > SCALE_EPSILON) then
			PetBattleFrame.BottomFrame:SetScale(ClassicUI.db.profile.barsConfig.PetBattleFrameBar.scale)
		end
		if ( IsPlayerInWorld() ) then
			-- Don't let UIParent_ManageFramePositions manage the MultiBarBottomLeft, StanceBarFrame and PossessBarFrame. Sadly can't do this for PetActionBarFrame.
			UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil;
			UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"] = nil;
			UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil;
			-- Update the other bars
			Update_PossessBar()
			Update_StanceBar()
			Update_PetActionBar()
			Update_MultiActionBar()
		end
	end
	SetPositionForStatusBars_MainMenuBar = ClassicUI.SetPositionForStatusBars_MainMenuBar
	-- Hook this function to MainMenuBar:SetPositionForStatusBars
	hooksecurefunc(MainMenuBar, "SetPositionForStatusBars", SetPositionForStatusBars_MainMenuBar);
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
			actionButtonHK =  _G["PossessButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
			actionButtonHK =  _G["OverrideActionBarButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(0)
			end
		end
		ClassicUI:HookPetBattleKeybindsVisibilityMode()
		for i = 1, #PetBattleFrame.BottomFrame.abilityButtons do
			local actionButton = PetBattleFrame.BottomFrame.abilityButtons[i];
			if (actionButton and actionButton.HotKey) then
				actionButton.HotKey:SetAlpha(0)
				actionButton.HotKey:Hide()
			end
		end
		PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:SetAlpha(0);
		PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:Hide();
		PetBattleFrame.BottomFrame.CatchButton.HotKey:SetAlpha(0);
		PetBattleFrame.BottomFrame.CatchButton.HotKey:Hide();
	elseif (mode == 2) or (mode == 3) then
		ClassicUI:HookKeybindsVisibilityMode()
		for i = 1, 12 do
			local actionButton
			actionButton = _G["ExtraActionButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				ActionButton_UpdateHotkeys(actionButton)
			end
			actionButton = _G["ActionButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				ActionButton_UpdateHotkeys(actionButton)
			end
			actionButton = _G["MultiBarBottomLeftButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				ActionButton_UpdateHotkeys(actionButton)
			end
			actionButton = _G["MultiBarBottomRightButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				ActionButton_UpdateHotkeys(actionButton)
			end
			actionButton = _G["MultiBarLeftButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				ActionButton_UpdateHotkeys(actionButton)
			end
			actionButton = _G["MultiBarRightButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				ActionButton_UpdateHotkeys(actionButton)
			end
			actionButton = _G["PetActionButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				ActionButton_UpdateHotkeys(actionButton)
			end
			actionButton = _G["StanceButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				ActionButton_UpdateHotkeys(actionButton)
			end
			actionButton =  _G["PossessButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				ActionButton_UpdateHotkeys(actionButton)
			end
			actionButton =  _G["OverrideActionBarButton"..i]
			if (actionButton) then
				actionButton.HotKey:SetAlpha(1)
				ActionButton_UpdateHotkeys(actionButton)
			end
		end
		ClassicUI:HookPetBattleKeybindsVisibilityMode()
		if (mode == 2) then
			for i=1, #PetBattleFrame.BottomFrame.abilityButtons do
				local actionButton = PetBattleFrame.BottomFrame.abilityButtons[i];
				if (actionButton and actionButton.HotKey) then
					actionButton.HotKey:SetAlpha(0)
					actionButton.HotKey:Hide()
				end
			end
			PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:SetAlpha(0);
			PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:Hide();
			PetBattleFrame.BottomFrame.CatchButton.HotKey:SetAlpha(0);
			PetBattleFrame.BottomFrame.CatchButton.HotKey:Hide();
		elseif (mode == 3) then
			for i=1, #PetBattleFrame.BottomFrame.abilityButtons do
				local actionButton = PetBattleFrame.BottomFrame.abilityButtons[i];
				if (actionButton and actionButton.HotKey) then
					actionButton.HotKey:SetAlpha(1)
					actionButton.HotKey:Show()
					PetBattleAbilityButton_UpdateHotKey(actionButton)
				end
			end
			PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:SetAlpha(1);
			PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:Show()
			PetBattleFrame.BottomFrame.CatchButton.HotKey:SetAlpha(1);
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
			actionButtonHK =  _G["PossessButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
			actionButtonHK =  _G["OverrideActionBarButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
		end
		for i=1, #PetBattleFrame.BottomFrame.abilityButtons do
			local actionButton = PetBattleFrame.BottomFrame.abilityButtons[i];
			if (actionButton and actionButton.HotKey) then
				actionButton.HotKey:SetAlpha(1)
				actionButton.HotKey:Show()
				PetBattleAbilityButton_UpdateHotKey(actionButton)
			end
		end
		PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:SetAlpha(1);
		PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:Show()
		PetBattleFrame.BottomFrame.CatchButton.HotKey:SetAlpha(1);
		PetBattleFrame.BottomFrame.CatchButton.HotKey:Show()
		PetBattleAbilityButton_UpdateHotKey(PetBattleFrame.BottomFrame.SwitchPetButton)
		PetBattleAbilityButton_UpdateHotKey(PetBattleFrame.BottomFrame.CatchButton)
	end
end

-- The OnlyShowDotRange or OnlyShowPermanentDotRange keybind options require a Hook
function ClassicUI:HookKeybindsVisibilityMode()
	if (not ACTIONBUTTON_UPDATEHOTKEYS_HOOKED) then
		hooksecurefunc("ActionButton_UpdateHotkeys", function(self, actionButtonType)
			if (ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode == 2) then
				self.HotKey:SetText(RANGE_INDICATOR);
			else
				self.HotKey:SetText(' '..RANGE_INDICATOR);
			end
		end)
		ACTIONBUTTON_UPDATEHOTKEYS_HOOKED = true
	end
end

-- Hide/Modify the BattlePets action buttons hotkeys require a Hook
function ClassicUI:HookPetBattleKeybindsVisibilityMode()
	if (not PETBATTLEABILITYBUTTON_UPDATEHOTKEYS_HOOKED) then
		hooksecurefunc("PetBattleAbilityButton_UpdateHotKey", function(self)
			local mode = ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode
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
			actionButtonName =  _G["PossessButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
			actionButtonName =  _G["OverrideActionBarButton"..i.."Name"]
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
			actionButtonName =  _G["PossessButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
			actionButtonName =  _G["OverrideActionBarButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
		end
	end
end

-- Function to disable Cooldown effect on action bars caused by CC
function ClassicUI:HookLossOfControlUICCRemover()
	if (not DISABLELOSSOFCONTROLUI_HOOKED) then
		hooksecurefunc('CooldownFrame_Set', function(self)
			if self.currentCooldownType == COOLDOWN_TYPE_LOSS_OF_CONTROL then
				self:SetDrawBling(false)
				self:SetCooldown(0, 0)
			else
				if not self:GetDrawBling() then
					self:SetDrawBling(true)
				end
			end
		end)
		hooksecurefunc('ActionButton_UpdateCooldown', function(self)
			if ( self.cooldown.currentCooldownType == COOLDOWN_TYPE_LOSS_OF_CONTROL ) then
				local start, duration, enable, charges, maxCharges, chargeStart, chargeDuration;
				local modRate = 1.0;
				local chargeModRate = 1.0;
				if ( self.spellID ) then
					start, duration, enable, modRate = GetSpellCooldown(self.spellID);
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(self.spellID);
				else
					start, duration, enable, modRate = GetActionCooldown(self.action);
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(self.action);
				end
				self.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge");
				self.cooldown:SetSwipeColor(0, 0, 0);
				self.cooldown:SetHideCountdownNumbers(false);
				if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
					if chargeStart == 0 then
						ClearChargeCooldown(self);
					else
						if self.chargeCooldown then
							CooldownFrame_Set(self.chargeCooldown, chargeStart, chargeDuration, true, true, chargeModRate);
						end
					end
				else
					ClearChargeCooldown(self);
				end
				CooldownFrame_Set(self.cooldown, start, duration, enable, false, modRate);
			end
		end)
		DISABLELOSSOFCONTROLUI_HOOKED = true
	end
end

-- Function to show the entire icon in red when the spell is not at range instead of only show in red the keybind text
function ClassicUI:HookRedRangeIcons()
	if (not REDRANGEICONS_HOOKED) then
		hooksecurefunc("ActionButton_UpdateRangeIndicator", function(self, checksRange, inRange)
			if ( checksRange and not inRange ) then
				local icon = self.icon;
				local normalTexture = self.NormalTexture;
				icon:SetVertexColor(0.8, 0.1, 0.1);
				if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
					normalTexture:SetVertexColor(0.8, 0.1, 0.1);
				end
				self.redRangeRed = true;
			elseif (self.redRangeRed) then
				local icon = self.icon;
				local normalTexture = self.NormalTexture;
				local action = self.action;
				if (action) then
					local isUsable, notEnoughMana = IsUsableAction(action)
					if (isUsable) then
						icon:SetVertexColor(1.0, 1.0, 1.0);
						if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
							normalTexture:SetVertexColor(1.0, 1.0, 1.0);
						end
					elseif (notEnoughMana) then
						icon:SetVertexColor(0.1, 0.3, 1.0);
						if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
							normalTexture:SetVertexColor(0.1, 0.3, 1.0);
						end
					else
						icon:SetVertexColor(0.4, 0.4, 0.4);
						if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
							normalTexture:SetVertexColor(1.0, 1.0, 1.0);
						end
					end
				else
					icon:SetVertexColor(1.0, 1.0, 1.0);
					if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
						normalTexture:SetVertexColor(1.0, 1.0, 1.0);
					end
				end
				self.redRangeRed = false;
			end
		end)
		hooksecurefunc("ActionButton_UpdateUsable", function(self)
			local action = self.action;
			local icon = self.icon;
			local isUsable, notEnoughMana = IsUsableAction(action)
			local normalTexture = self.NormalTexture;
			if ( not normalTexture ) then
				return;
			end
			if (ActionHasRange(action) and IsActionInRange(action) == false) then
				icon:SetVertexColor(0.8, 0.1, 0.1);
				normalTexture:SetVertexColor(0.8, 0.1, 0.1);
				self.redRangeRed = true;
			elseif (self.redRangeRed) then
				if (isUsable) then
					icon:SetVertexColor(1.0, 1.0, 1.0);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
					self.redRangeRed = false;
				elseif (notEnoughMana) then
					icon:SetVertexColor(0.1, 0.3, 1.0);
					normalTexture:SetVertexColor(0.1, 0.3, 1.0);
					self.redRangeRed = false;
				else
					icon:SetVertexColor(0.4, 0.4, 0.4);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
					self.redRangeRed = false;
				end
			end
		end)
		REDRANGEICONS_HOOKED = true
	end
end

-- Function to desaturate the entire action icon when the spell is on cooldown
function ClassicUI:HookGreyOnCooldownIcons()
	if (not GREYONCOOLDOWN_HOOKED) then
		function ActionButtonGreyOnCooldown_UpdateCooldown(self, expectedUpdate)
			local icon = self.icon;
			if (icon) then
				local start, duration = GetActionCooldown(self.action);
				if (duration >= 1.51) then
					if ((not self.onCooldown) or (self.onCooldown == 0)) then
						local nextTime = start + duration - GetTime() - 1.0;
						if (nextTime < -1.0) then
							nextTime = 0.05;
						elseif (nextTime < 0) then
							nextTime = -nextTime / 2;
						end
						C_Timer.After(nextTime, function()
							ActionButtonGreyOnCooldown_UpdateCooldown(self, true);
						end);
					elseif (expectedUpdate) then
						if ((not self.onCooldown) or (self.onCooldown < start + duration)) then
							self.onCooldown = start + duration;
						end
						local nextTime = 0.05;
						local timeRemains = self.onCooldown-GetTime();
						if (timeRemains > 0.31) then
							nextTime = timeRemains / 5;
						elseif (timeRemains < 0) then
							nextTime = 0.05;
						end
						C_Timer.After(nextTime, function()
							ActionButtonGreyOnCooldown_UpdateCooldown(self, true);
						end);
					end
					if ((not self.onCooldown) or (self.onCooldown < start + duration)) then
						self.onCooldown = start + duration;
					end
					if (not icon:IsDesaturated()) then
						icon:SetDesaturated(true);
					end
				else
					self.onCooldown = 0;
					if (icon:IsDesaturated()) then
						icon:SetDesaturated(false);
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
		ToggleNewGuildFrame = ToggleGuildFrame;
		function ToggleOldGuildFrame()
			if (IsKioskModeEnabled()) then
				return;
			end
			local factionGroup = UnitFactionGroup("player");
			if (factionGroup == "Neutral") then
				return;
			end
			if ( IsTrialAccount() or (IsVeteranTrialAccount() and not IsInGuild()) ) then
				UIErrorsFrame:AddMessage(ERR_RESTRICTED_ACCOUNT_TRIAL, 1.0, 0.1, 0.1, 1.0);
				return;
			end
			if ( IsInGuild() ) then
				GuildFrame_LoadUI();
				if ( GuildFrame_Toggle ) then
					GuildFrame_Toggle();
				end
			else
				ToggleGuildFinder();
			end
		end

		-- Set hook to open new or old menu (this hook work on keybinds, guild alert click, ...)
		hooksecurefunc("ToggleGuildFrame", function(self)
			if (ClassicUI.db.profile.extraConfigs.GuildPanelMode.defauiltOpenOldMenu) then
				ToggleNewGuildFrame()
				ToggleOldGuildFrame()
			end
		end)

		--Set GuildMicroButton click specific hook
		GuildMicroButton:HookScript('OnClick', function(self, button)
			if (button == 'RightButton') then
				if (ClassicUI.db.profile.extraConfigs.GuildPanelMode.rightClickMicroButtonOpenOldMenu) then
					ToggleNewGuildFrame()
					ToggleOldGuildFrame()
				end
			else
				if (ClassicUI.db.profile.extraConfigs.GuildPanelMode.leftClickMicroButtonOpenOldMenu) then
					ToggleNewGuildFrame()
					ToggleOldGuildFrame()
				end
			end
		end)
		OPENGUILDPANEL_HOOKED = true
	end
end
