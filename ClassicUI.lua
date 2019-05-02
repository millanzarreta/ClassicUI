-- ------------------------------------------------------------ --
-- Addon: ClassicUI                                             --
--                                                              --
-- Version: 1.0.2                                               --
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

-- Global variables
ClassicUI.BAG_SIZE = 32
ClassicUI.BAGS_WIDTH = (4*ClassicUI.BAG_SIZE+32)
ClassicUI.ACTION_BAR_OFFSET = 48
ClassicUI.VERSION = "1.0.2"

ClassicUI.Update_MultiActionBar = function() end
ClassicUI.Update_PetActionBar = function() end
ClassicUI.Update_StanceBar = function() end
ClassicUI.Update_PossessBar = function() end
ClassicUI.SetPositionForStatusBars_MainMenuBar = function() end

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
				hide = false
			},
			['RightGargoyleFrame'] = {
				hide = false
			},
			['MainMenuBar'] = {},
			['BottomMultiActionBars'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0
			},
			['RightMultiActionBars'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0
			},
			['PetActionBarFrame'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				xOffsetIfStanceBar = 0
			},
			['StanceBarFrame'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0
			},
			['PossessBarFrame'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0
			}
		},
		extraConfigs = {
			['KeybindsConfig'] = {
				hideKeybindsMode = 0	--0 = show keybinds, 1 = hide keybinds, 2 = show range dots on keybinds
			},
			['RedRangeConfig'] = {
				enabled = false
			},
			['LossOfControlUIConfig'] = {
				enabled = false
			}
		},
	},
}

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
	
	self:RegisterChatCommand("ClassicUI", function() ClassicUI:ShowConfig() end )
	
	-- Start ClassicUI Core
	if (self.db.profile.enabled) then
		ClassicUI:Enable()
		ClassicUI:MainFunction() 
		ClassicUI:ExtraFunction()
	else
		ClassicUI:Disable()
	end
end

-- Executed after modifying, resetting or changing profiles from the profile configuration menu
function ClassicUI:RefreshConfig()
	if (self:IsEnabled()) then
		if (not self.db.profile.enabled) then
			self:Disable()
			ReloadUI()
		else
			self.SetPositionForStatusBars_MainMenuBar()
		end
	else
		if (self.db.profile.enabled) then
			self:Enable()
			self:MainFunction() 
			self:ExtraFunction()
			self.SetPositionForStatusBars_MainMenuBar()
		end
	end
	self:ToggleVisibilityKeybinds(self.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode)
	-- We should do a ReloadUI if the old self.db.profile.extraConfigs..KeybindsConfig.hideKeybindsMode == 2, but we have not the old value, so we don't do anything, who cares :)
	if ((not self.db.profile.extraConfigs.RedRangeConfig.enabled) and (REDRANGEICONS_HOOKED)) then
		ReloadUI()
	end
	if ((not self.db.profile.extraConfigs.LossOfControlUIConfig.enabled) and (DISABLELOSSOFCONTROLUI_HOOKED)) then
		ReloadUI()
	end
end

function ClassicUI:OnEnable()
	print('|cffd78900' .. L['ClassicUI'] .. ' v' .. ClassicUI.VERSION .. '|r ' .. L['enabled'])
end

function ClassicUI:OnDisable()
	print('|cffd78900' .. L['ClassicUI'] .. ' v' .. ClassicUI.VERSION .. '|r ' .. L['disabled'])
end

--Show Options Menu
function ClassicUI:ShowConfig()
	-- Call twice to workaround a bug in Blizzard's function
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.general)
end

function ClassicUI:ExtraFunction()
	--Extra Option: Keybinds
	if (ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode > 0) then
		self:ToggleVisibilityKeybinds(ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode)
	end
	--Extra Option: RedRange
	if (ClassicUI.db.profile.extraConfigs.RedRangeConfig.enabled) then
		self:HookRedRangeIcons()
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

	-- Create the frame and the flag variables needed to execute protected functions after leave combat.
	-- If a protected function tries to running while the player is in combat, a flag for the funcion is
	-- activated and when the player leaves the combat the function is executed.
	local fclFrame = CreateFrame("Frame");
	local delayFunc_SetPositionForStatusBars_MainMenuBar = false
	local delayFunc_Update_MultiActionBar = false
	local delayFunc_Update_PossessBar = false
	local delayFunc_Update_StanceBar = false
	local delayFunc_Update_PetActionBar = false
	local delayFunc_MainMenuBar_ChangeMenuBarSizeAndPosition = false
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
			if (delayFunc_MainMenuBar_ChangeMenuBarSizeAndPosition) then
				delayFunc_MainMenuBar_ChangeMenuBarSizeAndPosition = false
				MainMenuBar:ChangeMenuBarSizeAndPosition()
			end
		end
	end)
	
	-- Create a second backdrop texture (only cosmetic)
	MainMenuBarArtFrameBackground.BackgroundLarge2 = MainMenuBarArtFrameBackground:CreateTexture();
	MainMenuBarArtFrameBackground.BackgroundLarge2:SetSize(231, 49);
	MainMenuBarArtFrameBackground.BackgroundLarge2:SetPoint("BOTTOMLEFT", MainMenuBarArtFrameBackground.BackgroundLarge, "BOTTOMRIGHT", -11, 0);
	MainMenuBarArtFrameBackground.BackgroundLarge2:SetTexture(MicroButtonAndBagsBar.MicroBagBar:GetTexture());
	MainMenuBarArtFrameBackground.BackgroundLarge2:SetTexCoord(154/1024, 385/1024, 116/256, 165/256);
	MainMenuBarArtFrameBackground.BackgroundLarge2:SetAlpha(MainMenuBarArtFrameBackground.BackgroundLarge:GetAlpha())
	
	-- Create new textures for microbuttons backdrop
	MainMenuBarArtFrameBackground.MicroButtonArt = MainMenuBarArtFrameBackground:CreateTexture();
	MainMenuBarArtFrameBackground.MicroButtonArt:SetSize(309, 42);
	MainMenuBarArtFrameBackground.MicroButtonArt:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, 548, -10);
	MainMenuBarArtFrameBackground.MicroButtonArt:SetTexture(MicroButtonAndBagsBar.MicroBagBar:GetTexture());
	MainMenuBarArtFrameBackground.MicroButtonArt:SetTexCoord(245/1024, 542/1024, 212/256, 255/256);
	
	-- Create new textures for bags backdrop
	-- Background for all the bags
	MainMenuBarArtFrameBackground.BagsBackgroundArt = MainMenuBarArtFrameBackground:CreateTexture();
	MainMenuBarArtFrameBackground.BagsBackgroundArt:SetSize(168, 42);
	MainMenuBarArtFrameBackground.BagsBackgroundArt:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, 856, -10);
	MainMenuBarArtFrameBackground.BagsBackgroundArt:SetTexture(MicroButtonAndBagsBar.MicroBagBar:GetTexture());
	MainMenuBarArtFrameBackground.BagsBackgroundArt:SetTexCoord(245/1024, 542/1024, 212/256, 255/256);
	-- MainBags backdrop
	MainMenuBarArtFrameBackground.MainBagsArt = MainMenuBarArtFrameBackground:CreateTexture();
	MainMenuBarArtFrameBackground.MainBagsArt:SetSize(BAG_SIZE + 1, BAG_SIZE + 3);
	MainMenuBarArtFrameBackground.MainBagsArt:SetPoint("BOTTOMRIGHT", MainMenuBarArtFrameBackground.BagsBackgroundArt, -2, 4);
	MainMenuBarArtFrameBackground.MainBagsArt:SetTexture(MicroButtonAndBagsBar.MicroBagBar:GetTexture());
	MainMenuBarArtFrameBackground.MainBagsArt:SetTexCoord(462/1024, 495/1024, 177/256, 211/256);
	-- MultiBags backdrop
	MainMenuBarArtFrameBackground.MultiBagsArt = MainMenuBarArtFrameBackground:CreateTexture();
	MainMenuBarArtFrameBackground.MultiBagsArt:SetSize(BAGS_WIDTH - 30, BAG_SIZE + 3);
	MainMenuBarArtFrameBackground.MultiBagsArt:SetPoint("BOTTOMRIGHT", MainMenuBarArtFrameBackground.MainBagsArt, -(BAG_SIZE+1), 0);
	MainMenuBarArtFrameBackground.MultiBagsArt:SetTexture(MicroButtonAndBagsBar.MicroBagBar:GetTexture());
	MainMenuBarArtFrameBackground.MultiBagsArt:SetTexCoord(365/1024, 495/1024, 177/256, 211/256);
	
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
		-- Set position MultiBarBottomLeft and MultiBarBottomRight
		if (SHOW_MULTI_ACTIONBAR_1 or SHOW_MULTI_ACTIONBAR_2) then
			MultiBarBottomLeft:ClearAllPoints();
			MultiBarBottomRightButton7:ClearAllPoints();
			MultiBarBottomRightButton1:ClearAllPoints();
			local xPos = 0 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.xOffset
			local yPos
			if (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.ignoreyOffsetStatusBar) then
				if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
					yPos = 9 + 17 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset2StatusBar
				elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
					yPos = 9 + 8 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset1StatusBar
				end
			else
				if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
					yPos = 9 + 17 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset
				elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
					yPos = 9 + 8 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset
				end
			end
			if ( StatusTrackingBarManager:GetNumberVisibleBars() < 1 ) then
				yPos = 9 + 3 + ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset
			end
			MultiBarBottomLeft:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", xPos, yPos);
			MultiBarBottomRightButton1:SetPoint("TOPLEFT", MultiBarBottomLeftButton12, "TOPLEFT", 48, 0);
			MultiBarBottomRightButton7:SetPoint("TOPLEFT", MultiBarBottomRightButton6, "TOPLEFT", 42, 0);
		end
		-- Set position VerticalMultiBarsContainer (yPos) and MultiBarRight (xPos)
		if ( SHOW_MULTI_ACTIONBAR_3 ) then
			local yPos
			if (ClassicUI.db.profile.barsConfig.RightMultiActionBars.ignoreyOffsetStatusBar) then
				if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
					yPos = 90 + 17 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset2StatusBar
				elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
					yPos = 90 + 8 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset1StatusBar
				end
			else
				if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
					yPos = 90 + 17 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset
				elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
					yPos = 90 + 8 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset
				end
			end
			if ( StatusTrackingBarManager:GetNumberVisibleBars() < 1 ) then
				yPos = 90 + 8 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset
			end
			VerticalMultiBarsContainer:SetPoint("BOTTOMRIGHT", UIParent, 0, yPos);
		end
		if ( SHOW_MULTI_ACTIONBAR_3 or SHOW_MULTI_ACTION_BAR_4) then
			MultiBarRight:SetPoint("TOPRIGHT", MultiBarRight:GetParent(), "TOPRIGHT", 2 + ClassicUI.db.profile.barsConfig.RightMultiActionBars.xOffset, 0)
		end
		-- Set the grid background for MultiBarBottomRightButton1 to MultiBarBottomRightButton6 (is hidden by default)
		if (SHOW_MULTI_ACTIONBAR_2) then
			local showgrid = MultiBarBottomRightButton7:GetAttribute("showgrid");
			if (MultiBarBottomRightButton1:GetAttribute("showgrid") ~= showgrid) then
				MultiBarBottomRightButton1:SetAttribute("showgrid", showgrid);
				if ((showgrid ~= nil) and (showgrid > 0)) then
					if (not MultiBarBottomRightButton1:IsShown()) then
						MultiBarBottomRightButton1:Show();
					end
				else
					if (MultiBarBottomRightButton1:IsShown()) then
						MultiBarBottomRightButton1:Hide();
					end
				end
			end
			if (MultiBarBottomRightButton2:GetAttribute("showgrid") ~= showgrid) then
				MultiBarBottomRightButton2:SetAttribute("showgrid", showgrid);
				if ((showgrid ~= nil) and (showgrid > 0)) then
					if (not MultiBarBottomRightButton2:IsShown()) then
						MultiBarBottomRightButton2:Show();
					end
				else
					if (MultiBarBottomRightButton2:IsShown()) then
						MultiBarBottomRightButton2:Hide();
					end
				end
			end
			if (MultiBarBottomRightButton3:GetAttribute("showgrid") ~= showgrid) then
				MultiBarBottomRightButton3:SetAttribute("showgrid", showgrid);
				if ((showgrid ~= nil) and (showgrid > 0)) then
					if (not MultiBarBottomRightButton3:IsShown()) then
						MultiBarBottomRightButton3:Show();
					end
				else
					if (MultiBarBottomRightButton3:IsShown()) then
						MultiBarBottomRightButton3:Hide();
					end
				end
			end
			if (MultiBarBottomRightButton4:GetAttribute("showgrid") ~= showgrid) then
				MultiBarBottomRightButton4:SetAttribute("showgrid", showgrid);
				if ((showgrid ~= nil) and (showgrid > 0)) then
					if (not MultiBarBottomRightButton4:IsShown()) then
						MultiBarBottomRightButton4:Show();
					end
				else
					if (MultiBarBottomRightButton4:IsShown()) then
						MultiBarBottomRightButton4:Hide();
					end
				end
			end
			if (MultiBarBottomRightButton5:GetAttribute("showgrid") ~= showgrid) then
				MultiBarBottomRightButton5:SetAttribute("showgrid", showgrid);
				if ((showgrid ~= nil) and (showgrid > 0)) then
					if (not MultiBarBottomRightButton5:IsShown()) then
						MultiBarBottomRightButton5:Show();
					end
				else
					if (MultiBarBottomRightButton5:IsShown()) then
						MultiBarBottomRightButton5:Hide();
					end
				end
			end
			if (MultiBarBottomRightButton6:GetAttribute("showgrid") ~= showgrid) then
				MultiBarBottomRightButton6:SetAttribute("showgrid", showgrid);
				if ((showgrid ~= nil) and (showgrid > 0)) then
					if (not MultiBarBottomRightButton6:IsShown()) then
						MultiBarBottomRightButton6:Show();
					end
				else
					if (MultiBarBottomRightButton6:IsShown()) then
						MultiBarBottomRightButton6:Hide();
					end
				end
			end
		end
	end
	Update_MultiActionBar = ClassicUI.Update_MultiActionBar
	-- Hook function to update MultiActionBars
	hooksecurefunc("MultiActionBar_Update", Update_MultiActionBar);
	
	-- We are unable to get the UIParent not to manage the PetActionBar. We need replace PetActionBar.SetPoint function to prevent this. But this induce some minor taints...
	PetActionBarFrame.oSetPoint = PetActionBarFrame.SetPoint	-- Reference to original SetPoint function
	PetActionBarFrame.SetPoint = function(self)	-- Enjoy the unlucky taint
		Update_PetActionBar()
	end
	-- Function to set the position of PetActionBar
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
		local xPos
		if ( PetActionBarFrame_IsAboveStance(true) ) then
			xPos = -74 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffset
		elseif ( MainMenuBarVehicleLeaveButton and MainMenuBarVehicleLeaveButton:IsShown() ) then
			xPos = MainMenuBarVehicleLeaveButton:GetRight() + 20;
		elseif ( StanceBarFrame and GetNumShapeshiftForms() > 0 ) then
			xPos = 390 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffsetIfStanceBar;
		elseif ( MultiCastActionBarFrame and HasMultiCastActionBar() ) then
			xPos = 390 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffsetIfStanceBar;
		else
			xPos = -74 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffset
		end
		-- Set yPos
		local yPos
		if (ClassicUI.db.profile.barsConfig.PetActionBarFrame.ignoreyOffsetStatusBar) then
			if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 138 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset2StatusBar;
				else
					yPos = 138 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset2StatusBar;
				end
			elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 138 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset1StatusBar;
				else
					yPos = 138 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset1StatusBar;
				end
			end
		else
			if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 138 - 4 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
				else
					yPos = 138 - 4 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
				end
			elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 138 - 10 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
				else
					yPos = 138 - 10 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
				end
			end
		end
		if ( StatusTrackingBarManager:GetNumberVisibleBars() < 1 ) then
			if ( SHOW_MULTI_ACTIONBAR_1 ) then
				yPos = 137 + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
			else
				yPos = 137 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset;
			end
		end
		-- Set position for PetActionBarFrame to xPos, yPos
		PetActionBarFrame:oSetPoint("TOPLEFT", PetActionBarFrame:GetParent(), "BOTTOMLEFT", xPos, yPos);
	end
	Update_PetActionBar = ClassicUI.Update_PetActionBar
	
	-- Function to set the position of StanceBar
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
		local xPos = -80 + ClassicUI.db.profile.barsConfig.StanceBarFrame.xOffset
		-- Set yPos
		local yPos
		if (ClassicUI.db.profile.barsConfig.StanceBarFrame.ignoreyOffsetStatusBar) then
			if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 41 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset2StatusBar
				else
					yPos = 41 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset2StatusBar
				end
			elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 35 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset1StatusBar
				else
					yPos = 35 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset1StatusBar
				end
			end
		else
			if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 41 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
				else
					yPos = 41 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
				end
			elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 35 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
				else
					yPos = 35 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
				end
			end
		end
		if ( StatusTrackingBarManager:GetNumberVisibleBars() < 1 ) then
			if ( SHOW_MULTI_ACTIONBAR_1 ) then
				yPos = 44 + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
			else
				yPos = 44 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset
			end
		end
		-- Set position for StanceBarFrame to xPos, yPos
		StanceBarFrame:SetPoint("BOTTOMLEFT", StanceBarFrame:GetParent(), "TOPLEFT", xPos, yPos)
	end
	Update_StanceBar = ClassicUI.Update_StanceBar
	-- Hook this function to update StanceBar
	hooksecurefunc("StanceBar_Update", Update_StanceBar)

	-- Function to set the position of PossessBar
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
		local xPos = -80 + ClassicUI.db.profile.barsConfig.PossessBarFrame.xOffset
		-- Set yPos
		local yPos
		if (ClassicUI.db.profile.barsConfig.PossessBarFrame.ignoreyOffsetStatusBar) then
			if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 41 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset2StatusBar
				else
					yPos = 41 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset2StatusBar
				end
			elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 35 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset1StatusBar
				else
					yPos = 35 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset1StatusBar
				end
			end
		else
			if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 41 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
				else
					yPos = 41 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
				end
			elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
				if ( SHOW_MULTI_ACTIONBAR_1 ) then
					yPos = 35 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
				else
					yPos = 35 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
				end
			end
		end
		if ( StatusTrackingBarManager:GetNumberVisibleBars() < 1 ) then
			if ( SHOW_MULTI_ACTIONBAR_1 ) then
				yPos = 44 + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
			else
				yPos = 44 - ACTION_BAR_OFFSET + ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset
			end
		end
		-- Set position for PossessBarFrame to xPos, yPos
		PossessBarFrame:SetPoint("BOTTOMLEFT", PossessBarFrame:GetParent(), "TOPLEFT", xPos, yPos)
	end
	Update_PossessBar = ClassicUI.Update_PossessBar
	-- Hook this function to update StanceBar
	hooksecurefunc("PossessBar_Update", Update_PossessBar)
	
	-- Function to modify the status bars (enlarge status bars to include bags and microbuttons and move it between the 2 rows of buttons)
	hooksecurefunc(StatusTrackingBarManager, "LayoutBar", function (self, bar, barWidth, isTopBar, isDouble)
		-- Seems that this function does not need protection (InCombatLockdown)
		bar:ClearAllPoints();
		local width = barWidth + BAGS_WIDTH + 60
		if ( isDouble ) then
			self:SetDoubleBarSize(bar, width);
			if( isDouble ) then 
				self.SingleBarLargeUpper:SetSize(width, 9); 
				self.SingleBarLarge:SetSize(width, 12)
			else
				self.SingleBarSmallUpper:SetSize(width, 9);
				self.SingleBarSmall:SetSize(width, 12); 
			end
			if ( isTopBar ) then
				bar:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "TOPLEFT", 0, -7);
				bar.StatusBar:SetPoint("RIGHT", bar, "RIGHT", 0, -1);
				bar.OverlayFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, -4)
				self.SingleBarLarge:SetPoint("CENTER", bar, "CENTER", 0, -10)
				bar.StatusBar:SetSize(width, 9);
				bar:SetSize(width, 9);
			else
				bar:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "TOPLEFT", 0, -18);
				bar.StatusBar:SetPoint("RIGHT", bar, "RIGHT", 0, 0);
				bar.OverlayFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, -7)
				bar.StatusBar:SetSize(width, 11);
				bar:SetSize(width, 12);
			end
		else 
			bar:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "TOPLEFT", 0, -18);
			bar.StatusBar:SetPoint("RIGHT", bar, "RIGHT", 0, 0);
			bar.OverlayFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, -7)
			self:SetSingleBarSize(bar, width);
			if (self.largeSize) then 
				self.SingleBarLarge:SetSize(width, 12); 
			else
				self.SingleBarSmall:SetSize(width, 12); 
			end
			self.SingleBarLarge:SetPoint("CENTER", bar, "CENTER", 0, 0)
			bar.StatusBar:SetSize(width, 12); 
			bar:SetSize(width, 12);
		end
	end);
	
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
	
	-- Hook to avoid bad UI behaviour when the MultiBarBottomRight is hidden
	local oMainMenuBar_ChangeMenuBarSizeAndPosition = MainMenuBar.ChangeMenuBarSizeAndPosition
	hooksecurefunc(MainMenuBar, "ChangeMenuBarSizeAndPosition", function(self, rightMultiBarShowing)
		if InCombatLockdown() then
			delayFunc_MainMenuBar_ChangeMenuBarSizeAndPosition = true
			if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
				fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
			return
		end
		delayFunc_MainMenuBar_ChangeMenuBarSizeAndPosition = false
		rightMultiBarShowing = IsNormalActionBarState()
		oMainMenuBar_ChangeMenuBarSizeAndPosition(self, rightMultiBarShowing)
	end)
	
	-- Hook to move MicroButtons when the MainMenuBar is Showed
	MainMenuBar:HookScript("OnShow", function()
		MoveMicroButtons("BOTTOMLEFT", MainMenuBarArtFrameBackground.MicroButtonArt, "BOTTOMLEFT", 9, 2, false);
	end)
	
	-- A function to update all bars and frames, especially the MainMenuBar, MicroButtons and bags frames
	ClassicUI.SetPositionForStatusBars_MainMenuBar = function()
		-- Show/Hide Gargoyles
		if (ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.hide) then
			if (MainMenuBarArtFrame.LeftEndCap:IsShown()) then
				MainMenuBarArtFrame.LeftEndCap:Hide()
			end
		else
			if (not MainMenuBarArtFrame.LeftEndCap:IsShown()) then
				MainMenuBarArtFrame.LeftEndCap:Show()
			end
		end
		if (ClassicUI.db.profile.barsConfig.RightGargoyleFrame.hide) then
			if (MainMenuBarArtFrame.RightEndCap:IsShown()) then
				MainMenuBarArtFrame.RightEndCap:Hide()
			end
		else
			if (not MainMenuBarArtFrame.RightEndCap:IsShown()) then
				MainMenuBarArtFrame.RightEndCap:Show()
			end
		end
		-- Move Gargoyles
		MainMenuBarArtFrame.LeftEndCap:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "BOTTOMLEFT", 64 - BAGS_WIDTH + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.xOffset, -10 + ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.yOffset);
		MainMenuBarArtFrame.RightEndCap:SetPoint("BOTTOMRIGHT", MainMenuBarArtFrame, "BOTTOMRIGHT", 156 + BAGS_WIDTH + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.xOffset, -10 + ClassicUI.db.profile.barsConfig.RightGargoyleFrame.yOffset);
		
		-- If OverrideActionBar is showed, let the Blizzard code move the MicroButtons. If OverrideActionBar, is hidden we must move the MicroButtons on our frame.
		if (not OverrideActionBar:IsShown()) then
			MoveMicroButtons("BOTTOMLEFT", MainMenuBarArtFrameBackground.MicroButtonArt, "BOTTOMLEFT", 9, 2, false);
		end
		
		-- Move the bags buttons
		MainMenuBarBackpackButton:SetParent(MainMenuBarArtFrame);
		MainMenuBarBackpackButton:ClearAllPoints();
		MainMenuBarBackpackButton:SetPoint("RIGHT", MainMenuBarArtFrameBackground.MainBagsArt, -2, -1);
		MainMenuBarBackpackButton:SetSize(BAG_SIZE-2, BAG_SIZE-2)
		MainMenuBarBackpackButtonNormalTexture:SetAlpha(0)
		for i = 0,3 do
			_G["CharacterBag"..i.."Slot"]:SetParent(MainMenuBarArtFrame);
			_G["CharacterBag"..i.."Slot"]:SetSize(BAG_SIZE-2, BAG_SIZE-2);
			_G["CharacterBag"..i.."Slot"].IconBorder:SetSize(BAG_SIZE-2, BAG_SIZE-2);
			--_G["CharacterBag"..i.."SlotNormalTexture"]:SetAlpha(0)	-- seems unnecessary, at least for this icons size
		end
		CharacterBag0Slot:ClearAllPoints();
		CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarArtFrameBackground.MultiBagsArt, -1, -1);

		-- Hide and resize the new MicroButtonAndBagsBar frame.
		MicroButtonAndBagsBar:SetWidth(1);	-- This allow the UIParent code center the MainMenuBar frame correctly.
		MicroButtonAndBagsBar:Hide();
		-- Move Latency and Ticket MicroButtons
		MainMenuBarPerformanceBar:SetPoint("CENTER", MainMenuBarPerformanceBar:GetParent(), "CENTER", 0, 11);
		HelpOpenTicketButton:SetPoint("CENTER", HelpOpenTicketButton:GetParent(), "TOPRIGHT", -3, -4);
		HelpOpenWebTicketButton:SetPoint("CENTER", HelpOpenWebTicketButton:GetParent(), "TOPRIGHT", -3, -4);
		
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
		
		-- Set the offsetY for the MainMenuBarArtFrame
		local offsetY;
		if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
			offsetY = -17;
		elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
			offsetY = -14;
		else
			offsetY = 0;
		end
		
		-- Set the position for MainMenuBarArtFrame
		local menuBarRealWidth = MainMenuBar:GetWidth() + BAGS_WIDTH + 60;
		MainMenuBarArtFrame:SetPoint("TOPLEFT", MainMenuBar, ((MainMenuBar:GetWidth()-menuBarRealWidth)/2) + ClassicUI.db.profile.barsConfig.MainMenuBar.xOffset, 10 + offsetY + ClassicUI.db.profile.barsConfig.MainMenuBar.yOffset);
		MainMenuBarArtFrame:SetPoint("BOTTOMRIGHT", MainMenuBar, ((MainMenuBar:GetWidth()-menuBarRealWidth)/2) + ClassicUI.db.profile.barsConfig.MainMenuBar.xOffset, 10 + offsetY + ClassicUI.db.profile.barsConfig.MainMenuBar.yOffset);

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
-- Togle the visibilitity mode from 2 to another mode requires a ReloadUI
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
		end
	elseif (mode == 2) then
		ClassicUI:HookKeybindsVisibilityMode2()
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
		end
	end
end

-- The OnlyShowDotRange keybind options require a Hook
function ClassicUI:HookKeybindsVisibilityMode2()
	if (not ACTIONBUTTON_UPDATEHOTKEYS_HOOKED) then
		hooksecurefunc("ActionButton_UpdateHotkeys", function(self, actionButtonType)
			self.HotKey:SetText(RANGE_INDICATOR);
		end)
		ACTIONBUTTON_UPDATEHOTKEYS_HOOKED = true
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
			if ( self.cooldown.currentCooldownType ~= COOLDOWN_TYPE_NORMAL ) then
				self.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge");
				self.cooldown:SetSwipeColor(0, 0, 0);
				self.cooldown:SetHideCountdownNumbers(false);
				self.cooldown.currentCooldownType = COOLDOWN_TYPE_NORMAL;
			end
			if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
				StartChargeCooldown(self, chargeStart, chargeDuration, chargeModRate);
			else
				ClearChargeCooldown(self);
			end
			CooldownFrame_Set(self.cooldown, start, duration, enable, false, modRate);
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
				icon:SetVertexColor(1.0, 1.0, 1.0);
				if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				end
				self.redRangeRed = false;
			end
		end)
		hooksecurefunc("ActionButton_UpdateUsable", function(self)
			local id = self.action;
			local isUsable, notEnoughMana = IsUsableAction(id)
			if (isUsable) then
				if (ActionHasRange(id) and IsActionInRange(id) == false) then
					local icon = self.icon;
					local normalTexture = self.NormalTexture;
					icon:SetVertexColor(0.8, 0.1, 0.1);
					normalTexture:SetVertexColor(0.8, 0.1, 0.1);
					self.redRangeRed = true;
				elseif (self.redRangeRed) then
					local icon = self.icon;
					local normalTexture = self.NormalTexture;
					icon:SetVertexColor(1.0, 1.0, 1.0);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
					self.redRangeRed = false;
				end
			elseif (notEnoughMana) then
				local icon = self.icon;
				local normalTexture = self.NormalTexture;
				icon:SetVertexColor(0.1, 0.3, 1.0);
				normalTexture:SetVertexColor(0.1, 0.3, 1.0);
			end
		end)
		REDRANGEICONS_HOOKED = true
	end
end
