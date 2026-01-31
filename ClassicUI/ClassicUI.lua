-- ------------------------------------------------------------ --
-- Addon: ClassicUI                                             --
--                                                              --
-- Version: 3.0.0                                               --
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
ClassicUI.L = L

local _G = _G
local _
local STANDARD_EPSILON = 0.001
local SCALE_EPSILON = 0.001
local tblinsert = table.insert
local tblsort = table.sort
local mathabs = math.abs
local mathmin = math.min
local mathmax = math.max
local mathfloor = math.floor
local strformat = string.format
local strgsub = string.gsub
local type = type
local pairs = pairs
local ipairs = ipairs
local next = next
local InCombatLockdown = InCombatLockdown
local AnimateTexCoords = AnimateTexCoords
local GetActionInfo = GetActionInfo
local GetPetActionInfo = GetPetActionInfo
local GetPetActionSlotUsable = GetPetActionSlotUsable
local GetPetActionCooldown = GetPetActionCooldown
local C_ActionBar_GetActionCooldown = C_ActionBar.GetActionCooldown
local C_ActionBar_GetActionCooldownDuration = C_ActionBar.GetActionCooldownDuration
local C_Item_GetItemCooldown = C_Item.GetItemCooldown
local C_Spell_IsSpellUsable = C_Spell.IsSpellUsable
local C_Spell_GetSpellCooldown = C_Spell.GetSpellCooldown
local C_Spell_GetSpellCooldownDuration = C_Spell.GetSpellCooldownDuration
local C_ActionBar_HasRangeRequirements = C_ActionBar.HasRangeRequirements
local C_ActionBar_IsActionInRange = C_ActionBar.IsActionInRange
local C_ActionBar_IsUsableAction = C_ActionBar.IsUsableAction
local C_ActionBar_IsEquippedAction = C_ActionBar.IsEquippedAction
local ActionBarController_GetCurrentActionBarState = ActionBarController_GetCurrentActionBarState
local BNConnected = BNConnected
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_GossipInfo_GetFriendshipReputation = C_GossipInfo.GetFriendshipReputation
local C_Club_IsEnabled = C_Club.IsEnabled
local C_Club_IsRestricted = C_Club.IsRestricted
local C_Container_GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
local C_SocialRestrictions_CanReceiveChat = C_SocialRestrictions.CanReceiveChat
local CommunitiesUtil_DoesAnyCommunityHaveUnreadMessages = CommunitiesUtil.DoesAnyCommunityHaveUnreadMessages
local CommunitiesFrame_IsEnabled = CommunitiesFrame_IsEnabled
local ContainerFrame_IsReagentBag = ContainerFrame_IsReagentBag
local GetRestrictedAccountData = GetRestrictedAccountData
local C_Reputation_GetWatchedFactionData = C_Reputation.GetWatchedFactionData
local C_Housing_GetTrackedHouseGuid = C_Housing.GetTrackedHouseGuid
local C_PvP_IsActiveBattlefield = C_PvP.IsActiveBattlefield
local GameLimitedMode_IsActive = GameLimitedMode_IsActive
local C_CatalogShop_IsShop2Enabled = C_CatalogShop.IsShop2Enabled
local StoreFrame_IsShown = StoreFrame_IsShown
local Kiosk_IsEnabled = Kiosk.IsEnabled
local CurrentVersionHasNewUnseenSettings = CurrentVersionHasNewUnseenSettings
local IsPlayerAtEffectiveMaxLevel = IsPlayerAtEffectiveMaxLevel
local IsXPUserDisabled = IsXPUserDisabled
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax
local UnitFactionGroup = UnitFactionGroup
local UnitLevel = UnitLevel
local GetXPExhaustion = GetXPExhaustion
local GetRestState = GetRestState
local GetFlyoutInfo = GetFlyoutInfo
local GetFlyoutSlotInfo = GetFlyoutSlotInfo
local GetCallPetSpellInfo = GetCallPetSpellInfo
local GetFileStreamingStatus = GetFileStreamingStatus
local GetBackgroundLoadingStatus = GetBackgroundLoadingStatus
local GetPossessInfo = GetPossessInfo
local IsCommunitiesUIDisabledByTrialAccount = IsCommunitiesUIDisabledByTrialAccount
local IsRestrictedAccount = IsRestrictedAccount
local GetDifficultyInfo = GetDifficultyInfo
local GetInstanceInfo = GetInstanceInfo
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetGuildInfo = GetGuildInfo
local GetNetStats = GetNetStats
local InGuildParty = InGuildParty

-- Global constants
ClassicUI.VERSION = "3.0.0"
ClassicUI.STANDARD_EPSILON = STANDARD_EPSILON
ClassicUI.SCALE_EPSILON = SCALE_EPSILON
ClassicUI.ACTIONBUTTON_NEWLAYOUT_SCALE = 0.826
ClassicUI.ACTION_BAR_OFFSET = 45
ClassicUI.NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS or 12
ClassicUI.NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS or 10
ClassicUI.SPELLFLYOUT_DEFAULT_SPACING = 4
ClassicUI.SPELLFLYOUT_INITIAL_SPACING = 7	-- changed to 9 in Blizzard code since 11.1.0
ClassicUI.SPELLFLYOUT_FINAL_SPACING = 4	-- changed to 9 in Blizzard code since 10.0.0
ClassicUI.PERFORMANCEBAR_MEDIUM_LATENCY = 600
ClassicUI.PERFORMANCEBAR_LOW_LATENCY = 300
ClassicUI.MESSAGE_SCROLLBUTTON_INITIAL_DELAY = 0
ClassicUI.MESSAGE_SCROLLBUTTON_SCROLL_DELAY = 0.05
ClassicUI.playerClass = (UnitClass~=nil) and select(2, UnitClass("player"))
ClassicUI.MICROBUTTONANDBAGSBAR_CUI_OFFSET_Y = -1500
ClassicUI.MICROBUTTONS_MIN_ORDER = 1
ClassicUI.MICROBUTTONS_MAX_ORDER = 13
ClassicUI.MICROBUTTONS_MIN_PRIORITY = 1
ClassicUI.MICROBUTTONS_MAX_PRIORITY = 13
ClassicUI.MICROBUTTONS_DEFAULT_ALPHA_ENABLED = 1
ClassicUI.MICROBUTTONS_DEFAULT_ALPHA_DISABLED = 0.5
ClassicUI.MICROBUTTONS_OPTION_ICONS = {
	['Character Portrait'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-CharacterPortrailt-custom:32:24:0:0:32:64:0:32:22:64|t',
	['Class Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Class-'..(ClassicUI.playerClass or 'Warlock')..'-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['SpellBook Icon'] = '|T130810:32:24:0:0:32:64:0:32:22:64|t',
	['Talents Icon'] = '|T130813:32:24:0:0:32:64:0:32:22:64|t',
	['Profession Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Professions-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['Achievement Icon'] = '|T235422:32:24:0:0:32:64:0:32:22:64|t',
	['Quest Icon'] = '|T130804:32:24:0:0:32:64:0:32:22:64|t',
	['Guild Emblem'] = '|T130807:32:24:0:0:32:64:0:32:22:64|t',
	['Bigger Guild Emblem'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-BigEmblemSocials-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['LFD Icon'] = '|T130798:32:24:0:0:32:64:0:32:22:64|t',
	['Collections Icon'] = '|T615164:32:24:0:0:32:64:0:32:22:64|t',
	['EJ Icon'] = '|T525019:32:24:0:0:32:64:0:32:22:64|t',
	['Store Icon'] = '|T902317:32:24:0:0:32:64:0:32:22:64|t',
	['MainMenu Icon'] = '|T130801:32:24:0:0:32:64:0:32:22:64|t',
	['Help Icon'] = '|T130801:32:24:0:0:32:64:0:32:22:64|t',
	['Abilities Icon'] = '|T130786:32:24:0:0:32:64:0:32:22:64|t',
	['Raid Icon'] = '|T525021:32:24:0:0:32:64:0:32:22:64|t',
	['World Icon'] = '|T130816:32:24:0:0:32:64:0:32:22:64|t',
	['Classic Quest Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Quest-Up-classic:32:24:0:0:32:64:0:32:22:64|t',
	['Classic Social Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Socials-Up-classic:32:24:0:0:32:64:0:32:22:64|t',
	['Classic MainMenu Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Up-classic:32:24:0:0:32:64:0:32:22:64|t',
	['SpellBook/Talents Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PlayerSpells1-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['Talents/SpellBook Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PlayerSpells2-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['SB/T Variable Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-VariableSpellBookTalents-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['LFD Normalized Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-LFGNormalized-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['Classic Perf-MM Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PerfMM-Up-classic:32:24:0:0:32:64:0:32:22:64|t',
	['BFA Achievement Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-AchievementGold-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['PvP Variable Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpV-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['PvP Horde Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpH-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['PvP Alliance Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpA-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['PvP Neutral Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpN-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
	['Bug Icon'] = '|T130788:32:24:0:0:32:64:0:32:22:64|t',
	['Housing Icon'] = '|TInterface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Housing-Up-custom:32:24:0:0:32:64:0:32:22:64|t',
}
ClassicUI.MICROBUTTONS_ARRAYINFO = {
	[0] = {
		name = 'Character Portrait',
		normalTexture = 'Interface\\Buttons\\UI-MicroButtonCharacter-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButtonCharacter-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButtonCharacter-Up'	-- "UI-MicroButtonCharacter-Disabled" does not exists
	},
	[1] = {
		name = 'Class Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Class-'..(ClassicUI.playerClass or 'Warlock')..'-Up-custom',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Class-'..(ClassicUI.playerClass or 'Warlock')..'-Down-custom',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Class-'..(ClassicUI.playerClass or 'Warlock')..'-Disabled-custom'
	},
	[2] = {
		name = 'SpellBook Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Spellbook-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Spellbook-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-Spellbook-Disabled'
	},
	[3] = {
		name = 'Talents Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Talents-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Talents-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-Talents-Disabled'
	},
	[4] = {
		name = 'Profession Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Professions-Up-custom',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Professions-Down-custom',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Professions-Disabled-custom'
	},
	[5] = {
		name = 'Achievement Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Achievement-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Achievement-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-Achievement-Disabled'
	},
	[6] = {
		name = 'Quest Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Quest-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Quest-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-Quest-Disabled'
	},
	[7] = {
		name = 'Guild Emblem',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Socials-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Socials-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-Socials-Disabled',
		normalTextureGuild = 'Interface\\Buttons\\UI-MicroButtonCharacter-Up',
		pushedTextureGuild = 'Interface\\Buttons\\UI-MicroButtonCharacter-Down',
		disabledTextureGuild = 'Interface\\Buttons\\UI-MicroButtonCharacter-Up'	-- alt version: "Interface\\Buttons\\UI-MicroButton-Socials-Disabled"
	},
	[8] = {
		name = 'Bigger Guild Emblem',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Socials-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Socials-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-Socials-Disabled',
		normalTextureGuild = 'Interface\\Buttons\\UI-MicroButtonCharacter-Up',
		pushedTextureGuild = 'Interface\\Buttons\\UI-MicroButtonCharacter-Down',
		disabledTextureGuild = 'Interface\\Buttons\\UI-MicroButtonCharacter-Up'	-- alt version: "Interface\\Buttons\\UI-MicroButton-Socials-Disabled"
	},
	[9] = {
		name = 'LFD Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-LFG-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-LFG-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-LFG-Disabled'
	},
	[10] = {
		name = 'Collections Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Mounts-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Mounts-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-Mounts-Disabled'
	},
	[11] = {
		name = 'EJ Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-EJ-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-EJ-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-EJ-Disabled'
	},
	[12] = {
		name = 'Store Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-BStore-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-BStore-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-BStore-Disabled'
	},
	[13] = {
		name = 'MainMenu Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-MainMenu-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-MainMenu-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-MainMenu-Disabled'
	},
	[14] = {
		name = 'Help Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Help-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Help-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-Help-Disabled'
	},
	[15] = {
		name = 'Abilities Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Abilities-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Abilities-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-Abilities-Disabled'
	},
	[16] = {
		name = 'Raid Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Raid-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Raid-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-Raid-Disabled'
	},
	[17] = {
		name = 'World Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-World-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-World-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-World-Disabled'
	},
	[18] = {
		name = 'Classic Quest Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Quest-Up-classic',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Quest-Down-classic',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Quest-Disabled-classic'
	},
	[19] = {
		name = 'Classic Social Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Socials-Up-classic',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Socials-Down-classic',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Socials-Disabled-classic'
	},
	[20] = {
		name = 'Classic MainMenu Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Up-classic',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Down-classic',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Disabled-classic'
	},
	[21] = {
		name = 'SpellBook/Talents Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PlayerSpells1-Up-custom',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PlayerSpells1-Down-custom',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PlayerSpells1-Disabled-custom'
	},
	[22] = {
		name = 'Talents/SpellBook Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PlayerSpells2-Up-custom',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PlayerSpells2-Down-custom',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PlayerSpells2-Disabled-custom'
	},
	[23] = {
		name = 'SB/T Variable Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Talents-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Talents-Down',
		disabledTexture = 'Interface\\Buttons\\UI-MicroButton-Talents-Disabled',
		normalTextureSB = 'Interface\\Buttons\\UI-MicroButton-Spellbook-Up',
		pushedTextureSB = 'Interface\\Buttons\\UI-MicroButton-Spellbook-Down',
		disabledTextureSB = 'Interface\\Buttons\\UI-MicroButton-Spellbook-Disabled',
		normalTextureTT = 'Interface\\Buttons\\UI-MicroButton-Talents-Up',
		pushedTextureTT = 'Interface\\Buttons\\UI-MicroButton-Talents-Down',
		disabledTextureTT = 'Interface\\Buttons\\UI-MicroButton-Talents-Disabled'
	},
	[24] = {
		name = 'LFD Normalized Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-LFGNormalized-Up-custom',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-LFGNormalized-Down-custom',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-LFGNormalized-Disabled-custom'
	},
	[25] = {
		name = 'Classic Perf-MM Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Up-classic',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Down-classic',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-MainMenu-Disabled-classic'
	},
	[26] = {
		name = 'BFA Achievement Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-AchievementGold-Up-custom',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-AchievementGold-Down-custom',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-AchievementGold-Disabled-custom'
	},
	[27] = {
		name = 'PvP Variable Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpN-Up-custom',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpN-Down-custom',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpN-Disabled-custom'
	},
	[28] = {
		name = 'PvP Horde Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpH-Up-custom',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpH-Down-custom',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpH-Disabled-custom'
	},
	[29] = {
		name = 'PvP Alliance Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpA-Up-custom',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpA-Down-custom',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpA-Disabled-custom'
	},
	[30] = {
		name = 'PvP Neutral Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpN-Up-custom',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpN-Down-custom',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-PvpN-Disabled-custom'
	},
	[31] = {
		name = 'Bug Icon',
		normalTexture = 'Interface\\Buttons\\UI-MicroButton-Bug-Up',
		pushedTexture = 'Interface\\Buttons\\UI-MicroButton-Bug-Down',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Bug-Disabled-custom'
	},
	[32] = {
		name = 'Housing Icon',
		normalTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Housing-Up-custom',
		pushedTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Housing-Down-custom',
		disabledTexture = 'Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-Housing-Disabled-custom'
	}
}

-- Global variables
ClassicUI.databaseCleaned = false
ClassicUI.elpmbSizes = {
	['dragonflight'] = { w = 0, h = 0 },
	['warwithin'] = { w = 0, h = 0 }
}
ClassicUI.ACIaddonData = {
	text = "ClassicUI",
	icon = "Interface\\Addons\\ClassicUI\\micon",
	notCheckable = true,
	func = function()
		ClassicUI:ShowConfig(ClassicUI.optionsFramesCatId.general)
	end
}
-- Recreate the old global variables from the classic AutoCastShine action button animation
ClassicUI.AUTOCAST_SHINE_R = 0.95
ClassicUI.AUTOCAST_SHINE_G = 0.95
ClassicUI.AUTOCAST_SHINE_B = 0.32
ClassicUI.AUTOCAST_SHINE_SPEEDS = { 2, 4, 6, 8 }
ClassicUI.AUTOCAST_SHINE_TIMERS = { 0, 0, 0, 0 }
ClassicUI.AUTOCAST_SHINES = {}

-- GreyOnCooldown
ClassicUI.GOC_GCD = 1.88
ClassicUI.GOC_RelatedActionSpells = {
	[372608] = { 372610 },
	[372610] = { 372608 },
	[403092] = { 372608, 372610 },
	[425782] = { 372608, 372610 },
	[372606] = { 372608, 372610 }
}
ClassicUI.GOC_RegisteredActionSpells = {}

-- Cache variables
ClassicUI.cached_NumberVisibleBars = 0
ClassicUI.cached_NumberRealVisibleBars = 0
ClassicUI.cached_UpdateCacheVisibleBarsFunc_Timestamp = 0
ClassicUI.cached_DoubleStatusBar_hide = nil
ClassicUI.cached_SingleStatusBar_hide = nil
ClassicUI.cached_ActionButtonInfo = {
	hooked_UpdateButtonArt = { },
	hooked_UpdateHotkeys = { },
	hooked_UpdateFlyout = { },
	hooked_PlaySpellCastAnim = { },
	hooked_UpdateAssistedCombatRotationFrame = { },
	spellActivationAlertAdjusted = { },
	typeActionButton = { },
	currentScale = { },
	currLayout = { }
}
ClassicUI.cached_db_profile = { }
ClassicUI.queuePending_ActionButtonsLayout = { }
ClassicUI.queuePending_HookSetScale = { }
ClassicUI.STBMbars = { }
ClassicUI.STBMMainBars = { }
ClassicUI.STBMSecBars = { }
ClassicUI.UpdateBagItemButtonQualityFuncCache = { }
ClassicUI.OldMinimapLoaded = false

-- Default settings
ClassicUI.defaults = {
	profile = {
		enabled = true,
		disabledAddonCompartmentIntegration = false,
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
				BLStyle = 0,	-- 0 = Classic, 1 = Modern
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false,
				BLStyle0UseNewSpellActivationAlert = false,
				BLStyle0UseNewTargetReticleAnimFrame = false,
				BLStyle0UseNewInterruptDisplay = false,
				BLStyle0UseNewSpellCastAnimFrame = false,
				BLStyle0UseNewAutoCastOverlay = false,
				BLStyle0UseNewCooldownFlash = false,
				BLStyle0UseNewChargeCooldownEdgeTexture = false,
				BLStyle0HideCooldownBlingAnim = false
			},
			['SpellFlyoutButtons'] = {
				BLStyle = 0,	-- 0 = Classic, 1 = Modern
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false,
				BLStyle0UseNewSpellActivationAlert = false,
				BLStyle0UseNewTargetReticleAnimFrame = false,
				BLStyle0UseNewInterruptDisplay = false,
				BLStyle0UseNewSpellCastAnimFrame = false,
				BLStyle0UseNewAutoCastOverlay = false,
				BLStyle0UseNewCooldownFlash = false,
				BLStyle0UseNewChargeCooldownEdgeTexture = false,
				BLStyle0HideCooldownBlingAnim = false
			},
			['MicroButtons'] = {
				scale = 1,
				maxMicroButtonsShown = 11,
				helpOpenWebTicketButtonAnchor = 'MainMenuMicroButton',
				['CharacterMicroButton'] = {
					order = 1,
					priority = 1,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 0		-- 0 = Character Portrait (default)
				},
				['ProfessionMicroButton'] = {
					order = 3,
					priority = 5,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 4		-- 4 = Profession Icon (default)
				},
				['PlayerSpellsMicroButton'] = {
					order = 2,
					priority = 2,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 23	-- 23 = SB/T Variable Icon (default)
				},
				['AchievementMicroButton'] = {
					order = 4,
					priority = 7,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 5		-- 5 = Achievement Icon (default)
				},
				['QuestLogMicroButton'] = {
					order = 5,
					priority = 11,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 6		-- 6 = Quest Icon (default)
				},
				['HousingMicroButton'] = {
					order = 6,
					priority = 10,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 32,	-- 32 = Housing Icon (default)
					classicNotificationMicroButton = false
				},
				['GuildMicroButton'] = {
					order = 7,
					priority = 4,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 7,	-- 7 = Guild Emblem (default)
					classicNotificationMicroButton = true
				},
				['LFDMicroButton'] = {
					order = 8,
					priority = 3,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 9		-- 9 = LFD Icon (default)
				},
				['CollectionsMicroButton'] = {
					order = 9,
					priority = 8,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 10	-- 10 = Collections Icon (default)
				},
				['EJMicroButton'] = {
					order = 10,
					priority = 9,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 11,	-- 11 = EJ Icon (default)
					classicNotificationMicroButton = false
				},
				['HelpMicroButton'] = {
					order = 13,
					priority = 13,
					hideMicroButton = true,
					keepGapMicroButton = false,
					disableMicroButton = true,
					disableMouseMicroButton = true,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 14	-- 14 = Help Icon (default)
				},
				['StoreMicroButton'] = {
					order = 11,
					priority = 12,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 12	-- 12 = Store Icon (default)
				},
				['MainMenuMicroButton'] = {
					order = 12,
					priority = 6,
					hideMicroButton = false,
					keepGapMicroButton = false,
					disableMicroButton = false,
					disableMouseMicroButton = false,
					xOffsetMicroButton = 0,
					yOffsetMicroButton = 0,
					alphaMicroButton = 1,
					iconMicroButton = 13,	-- 13 = MainMenu Icon (default)
					classicNotificationMicroButton = false,
					hideLatencyBar = false
				}
			},
			['BagsIcons'] = {
				iconBorderAlpha = 1,
				xOffsetReagentBag = 0,
				yOffsetReagentBag = 0
			},
			['OverrideActionBar'] = {
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Modern
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false,
				BLStyle0UseNewSpellActivationAlert = false,
				BLStyle0UseNewTargetReticleAnimFrame = false,
				BLStyle0UseNewInterruptDisplay = false,
				BLStyle0UseNewSpellCastAnimFrame = false,
				BLStyle0UseNewAutoCastOverlay = false,
				BLStyle0UseNewCooldownFlash = false,
				BLStyle0UseNewChargeCooldownEdgeTexture = false,
				BLStyle0HideCooldownBlingAnim = false
			},
			['PetBattleFrameBar'] = {
				scale = 1
			},
			['BottomMultiActionBars'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Modern
				BLStyle0NormalTextureAlpha = 0.5,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false,
				BLStyle0UseNewSpellActivationAlert = false,
				BLStyle0UseNewTargetReticleAnimFrame = false,
				BLStyle0UseNewInterruptDisplay = false,
				BLStyle0UseNewSpellCastAnimFrame = false,
				BLStyle0UseNewAutoCastOverlay = false,
				BLStyle0UseNewCooldownFlash = false,
				BLStyle0UseNewChargeCooldownEdgeTexture = false,
				BLStyle0HideCooldownBlingAnim = false
			},
			['RightMultiActionBars'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Modern
				BLStyle0NormalTextureAlpha = 0.5,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false,
				BLStyle0UseNewSpellActivationAlert = false,
				BLStyle0UseNewTargetReticleAnimFrame = false,
				BLStyle0UseNewInterruptDisplay = false,
				BLStyle0UseNewSpellCastAnimFrame = false,
				BLStyle0UseNewAutoCastOverlay = false,
				BLStyle0UseNewCooldownFlash = false,
				BLStyle0UseNewChargeCooldownEdgeTexture = false,
				BLStyle0HideCooldownBlingAnim = false
			},
			['PetActionBarFrame'] = {
				normalizeButtonsSpacing = false,
				hideOnOverrideActionBar = false,
				hideOnPetBattleFrameBar = false,
				dontMoveOnOverrideActionBar = true,
				dontMoveOnPetBattleFrameBar = true,
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				xOffsetIfStanceBar = 0,
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Modern
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false,
				BLStyle0UseNewSpellActivationAlert = false,
				BLStyle0UseNewTargetReticleAnimFrame = false,
				BLStyle0UseNewInterruptDisplay = false,
				BLStyle0UseNewSpellCastAnimFrame = false,
				BLStyle0UseNewAutoCastOverlay = false,
				BLStyle0UseNewCooldownFlash = false,
				BLStyle0UseNewChargeCooldownEdgeTexture = false,
				BLStyle0HideCooldownBlingAnim = false
			},
			['StanceBarFrame'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Modern
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false,
				BLStyle0UseNewSpellActivationAlert = false,
				BLStyle0UseNewTargetReticleAnimFrame = false,
				BLStyle0UseNewInterruptDisplay = false,
				BLStyle0UseNewSpellCastAnimFrame = false,
				BLStyle0UseNewAutoCastOverlay = false,
				BLStyle0UseNewCooldownFlash = false,
				BLStyle0UseNewChargeCooldownEdgeTexture = false,
				BLStyle0HideCooldownBlingAnim = false
			},
			['PossessBarFrame'] = {
				ignoreyOffsetStatusBar = false,
				yOffset1StatusBar = 0,
				yOffset2StatusBar = 0,
				scale = 1,
				BLStyle = 0,	-- 0 = Classic, 1 = Modern
				BLStyle0NormalTextureAlpha = 1,
				BLStyle1NormalTextureAlpha = 1,
				BLStyle0AllowNewBackgroundArt = false,
				BLStyle0UseOldHotKeyTextStyle = false,
				BLStyle0UseNewPushedTexture = false,
				BLStyle0UseNewCheckedTexture = false,
				BLStyle0UseNewHighlightTexture = false,
				BLStyle0UseNewSpellHighlightTexture = false,
				BLStyle0UseNewFlyoutBorder = false,
				BLStyle0UseNewSpellActivationAlert = false,
				BLStyle0UseNewTargetReticleAnimFrame = false,
				BLStyle0UseNewInterruptDisplay = false,
				BLStyle0UseNewSpellCastAnimFrame = false,
				BLStyle0UseNewAutoCastOverlay = false,
				BLStyle0UseNewCooldownFlash = false,
				BLStyle0UseNewChargeCooldownEdgeTexture = false,
				BLStyle0HideCooldownBlingAnim = false
			},
			['SingleStatusBar'] = {
				hide = {
					[0] = false,	-- ExpBar
					[1] = false,	-- HonorBar
					[2] = false,	-- AzeriteBar
					[3] = false,	-- ArtifactBar
					[4] = false,	-- ReputationBar
					[5] = false		-- HouseFavorBar
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
					[9] = false,	-- ArtifactBar+ReputationBar
					[10] = false,	-- ExpBar+HouseFavorBar
					[11] = false,	-- HonorBar+HouseFavorBar
					[12] = false,	-- AzeriteBar+HouseFavorBar
					[13] = false,	-- ArtifactBar+HouseFavorBar
					[14] = false	-- ReputationBar+HouseFavorBar
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
				expBarAlwaysShowRestedBar = true	-- not used
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
				expBarAlwaysShowRestedBar = true	-- not used
			}
		},
		extraFrames = {
			['Minimap'] = {
				enabled = true,
				xOffset = 0,
				yOffset = 0,
				scale = 1,
				mailIconPriority = 0,				-- 0 = Crafting Order Icon > Mail Icon (default), 1 = Mail Icon > Crafting Order Icon
				minimapArrangementType = 0,			-- 0 = Legion (default), 1 = Classic, 2 = Cataclysm
				calendarIconType = 0,				-- 0 = Calendar Icon (legion/cataclysm default), 1 = Day/Night Icon (classic default)
				calendarIconSize = 40,				-- 40 = 40x40 (legion/cataclysm default), 50 = 50x50 (classic default)
				zoomButtonsPositions = 0,			-- 0 = Position 1 (legion default), 1 = Position 2 (classic/tbc default), 2 = Position 3 (wotlk//cataclysm default)
				useClassicTimeClock = false,
				xOffsetExpansionLandingPage = 0,
				yOffsetExpansionLandingPage = 0,
				scaleExpansionLandingPageDragonflight = 0.82,
				scaleExpansionLandingPageTheWarWithin = 0.82,
				hideAddonCompartment = true,
				xOffsetAddonCompartment = 0,
				yOffsetAddonCompartment = 0,
				scaleAddonCompartment = 1,
				anchorQueueButtonToMinimap = true,
				xOffsetQueueButton = 0,
				yOffsetQueueButton = 0,
				bigQueueButton = false
			},
			['Chat'] = {
				restoreScrollButtons = true,
				restoreBottomScrollButton = true,
				socialButtonToBottom = false
			},
			['Bags'] = {
				freeSlotCounterMod = 1,		-- 0 = AllItems (default), 1 = AllItems-ReagentItems (addon default), 2 = NormalItems and ReagentItems in two different numbers
				xOffsetFreeSlotsCounter = 0,
				yOffsetFreeSlotsCounter = 0,
				freeSlotsCounterFontSize = 14	-- Game Default is 14
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
				desaturateUnusableActions = true,
				desaturatePetActionButtons = true
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
local delayFunc_MF_PLAYER_ENTERING_WORLD = false
local delayFunc_SetStrataForMainFrames = false
local delayFunc_ReLayoutMainFrames = false
local delayFunc_ReloadMainFramesSettings = false
local delayFunc_UpdatedStatusBarsEvent = false
local delayFunc_CUI_PetActionBarFrame_RelocateBar_Update = false
local delayFunc_ActionButtonProtectedApplyLayout = false
local delayFunc_BarHookProtectedApplySetScale = false
local delayFunc_ClassicUI_ShowConfig = { false, 0 }
fclFrame:SetScript("OnEvent",function(self,event)
	if event=="PLAYER_REGEN_ENABLED" then
		fclFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		if (delayFunc_MainFunction) then
			delayFunc_MainFunction = false
			ClassicUI:MainFunction()
		end
		if (delayFunc_MF_PLAYER_ENTERING_WORLD) then
			delayFunc_MF_PLAYER_ENTERING_WORLD = false
			ClassicUI:MF_PLAYER_ENTERING_WORLD()
		end
		if (delayFunc_SetStrataForMainFrames) then
			delayFunc_SetStrataForMainFrames = false
			ClassicUI:SetStrataForMainFrames()
		end
		if (delayFunc_ReLayoutMainFrames) then
			delayFunc_ReLayoutMainFrames = false
			ClassicUI:ReLayoutMainFrames()
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
		if (delayFunc_ClassicUI_ShowConfig[1]) then
			delayFunc_ClassicUI_ShowConfig[1] = false
			ClassicUI:ShowConfig(delayFunc_ClassicUI_ShowConfig[2])
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
	self.optionsFrames.extraFrames, self.optionsFramesCatId.extraFrames = AceConfigDialog:AddToBlizOptions("ClassicUI", L['Extra Frames'], "ClassicUI", "extraFrames")
	self.optionsFrames.extraOptions, self.optionsFramesCatId.extraOptions = AceConfigDialog:AddToBlizOptions("ClassicUI", L['Extra Options'], "ClassicUI", "extraOptions")
	self.optionsFrames.profiles, self.optionsFramesCatId.profiles = AceConfigDialog:AddToBlizOptions("ClassicUI", L['Profiles'], "ClassicUI", "profiles")

	self:RegisterChatCommand("ClassicUI", "SlashCommand")

	-- Some pre-initialization stuff
	if NUM_ACTIONBAR_BUTTONS ~= nil then
		ClassicUI.NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
	end
	if NUM_PET_ACTION_SLOTS ~= nil then
		ClassicUI.NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
	end

	if (ClassicUI.playerClass == nil) then
		ClassicUI.playerClass = select(2,UnitClass("player"))
		ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon'] = strgsub(ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon'], "Warlock", ClassicUI.playerClass, 1)
		ClassicUI.MICROBUTTONS_ARRAYINFO[1].normalTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[1].normalTexture, "Warlock", ClassicUI.playerClass, 1)
		ClassicUI.MICROBUTTONS_ARRAYINFO[1].pushedTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[1].pushedTexture, "Warlock", ClassicUI.playerClass, 1)
		ClassicUI.MICROBUTTONS_ARRAYINFO[1].disabledTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[1].disabledTexture, "Warlock", ClassicUI.playerClass, 1)
	end
	if (C_SpecializationInfo.IsInitialized() and (C_SpecializationInfo.CanPlayerUseTalentSpecUI() == false)) or (not(C_SpecializationInfo.IsInitialized()) and (UnitLevel("player") < 10)) then
		ClassicUI.MICROBUTTONS_ARRAYINFO[23].normalTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[23].normalTexture, "Talents", "Spellbook", 1)
		ClassicUI.MICROBUTTONS_ARRAYINFO[23].pushedTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[23].pushedTexture, "Talents", "Spellbook", 1)
		ClassicUI.MICROBUTTONS_ARRAYINFO[23].disabledTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[23].disabledTexture, "Talents", "Spellbook", 1)
	end
	local factionGroup = UnitFactionGroup("player")
	if (factionGroup == "Horde") then
		ClassicUI.MICROBUTTONS_ARRAYINFO[27].normalTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[27].normalTexture, "PvpN", "PvpH", 1)
		ClassicUI.MICROBUTTONS_ARRAYINFO[27].pushedTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[27].pushedTexture, "PvpN", "PvpH", 1)
		ClassicUI.MICROBUTTONS_ARRAYINFO[27].disabledTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[27].disabledTexture, "PvpN", "PvpH", 1)
	elseif (factionGroup == "Alliance") then
		ClassicUI.MICROBUTTONS_ARRAYINFO[27].normalTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[27].normalTexture, "PvpN", "PvpA", 1)
		ClassicUI.MICROBUTTONS_ARRAYINFO[27].pushedTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[27].pushedTexture, "PvpN", "PvpA", 1)
		ClassicUI.MICROBUTTONS_ARRAYINFO[27].disabledTexture = strgsub(ClassicUI.MICROBUTTONS_ARRAYINFO[27].disabledTexture, "PvpN", "PvpA", 1)
	end

	if (not(self.db.profile.disabledAddonCompartmentIntegration)) then
		self:AddonCompartmentIntegration(true)
	end

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
			ReloadUI()
		end
	else
		if (self.db.profile.enabled) then
			self:Enable()
			self:MainFunction()
			self:ExtraFramesFunc()
			self:ExtraOptionsFunc()
			ReloadUI()
		else
			ReloadUI()
		end
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

-- Function to register/unregister the addon integration in the Blizzard AddonCompartment dropdown menu
function ClassicUI:AddonCompartmentIntegration(registerState)
	if (registerState) then
		if (AddonCompartmentFrame ~= nil and self.ACIaddonData ~= nil and AddonCompartmentFrame.registeredAddons ~= nil) then
			local aciIndex
			for k, v in pairs(AddonCompartmentFrame.registeredAddons) do
				if (v == self.ACIaddonData) then
					aciIndex = k
					break
				end
			end
			if not(aciIndex) then
				AddonCompartmentFrame:RegisterAddon(self.ACIaddonData)
			end
		end
	else
		if (AddonCompartmentFrame ~= nil and self.ACIaddonData ~= nil and AddonCompartmentFrame.registeredAddons ~= nil) then
			local aciIndex
			for k, v in pairs(AddonCompartmentFrame.registeredAddons) do
				if (v == self.ACIaddonData) then
					aciIndex = k
					break
				end
			end
			if (aciIndex ~= nil) then
				table.remove(AddonCompartmentFrame.registeredAddons, aciIndex)
				AddonCompartmentFrame:UpdateDisplay()
			end
		end
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
	if InCombatLockdown() then
		delayFunc_ClassicUI_ShowConfig[1] = true
		delayFunc_ClassicUI_ShowConfig[2] = category
		if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
			fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		ClassicUI:Print("|cffd2a679" .. L['CLASSICUI_OPENPANEL_AFTERCOMBAT'] .. "|r")
		return
	end
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
	elseif (n == 5) then	-- HouseFavorBar (priority = 5)
		return 5
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
	elseif (n == 10) then	-- ExpBar+HouseFavorBar (priority = 3, 5)
		return 5, 3
	elseif (n == 11) then	-- HonorBar+HouseFavorBar (priority = 2, 5)
		return 5, 2
	elseif (n == 12) then	-- AzeriteBar+HouseFavorBar (priority = 0, 5)
		return 5, 0
	elseif (n == 13) then	-- ArtifactBar+HouseFavorBar (priority = 4, 5)
		return 5, 4
	elseif (n == 14) then	-- ReputationBar+HouseFavorBar (priority = 1, 5)
		return 5, 1
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
	self.cached_db_profile.barsConfig_SingleStatusBar_expBarAlwaysShowRestedBar = self.db.profile.barsConfig.SingleStatusBar.expBarAlwaysShowRestedBar
	self.cached_db_profile.barsConfig_MainMenuBar_scale = self.db.profile.barsConfig.MainMenuBar.scale
	self.cached_db_profile.barsConfig_BottomMultiActionBars_scale = self.db.profile.barsConfig.BottomMultiActionBars.scale
	self.cached_db_profile.barsConfig_RightMultiActionBars_scale = self.db.profile.barsConfig.RightMultiActionBars.scale
	self.cached_db_profile.barsConfig_PetActionBarFrame_scale = self.db.profile.barsConfig.PetActionBarFrame.scale
	self.cached_db_profile.barsConfig_PossessBarFrame_scale = self.db.profile.barsConfig.PossessBarFrame.scale
	self.cached_db_profile.barsConfig_StanceBarFrame_scale = self.db.profile.barsConfig.StanceBarFrame.scale
	self.cached_db_profile.barsConfig_MainMenuBar_xOffset = self.db.profile.barsConfig.MainMenuBar.xOffset
	self.cached_db_profile.barsConfig_MainMenuBar_yOffset = self.db.profile.barsConfig.MainMenuBar.yOffset
	self.cached_db_profile.barsConfig_BottomMultiActionBars_xOffset = self.db.profile.barsConfig.BottomMultiActionBars.xOffset
	self.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset = self.db.profile.barsConfig.BottomMultiActionBars.yOffset
	self.cached_db_profile.barsConfig_BottomMultiActionBars_ignoreyOffsetStatusBar = self.db.profile.barsConfig.BottomMultiActionBars.ignoreyOffsetStatusBar
	self.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset1StatusBar = self.db.profile.barsConfig.BottomMultiActionBars.yOffset1StatusBar
	self.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset2StatusBar = self.db.profile.barsConfig.BottomMultiActionBars.yOffset2StatusBar
	self.cached_db_profile.barsConfig_RightMultiActionBars_xOffset = self.db.profile.barsConfig.RightMultiActionBars.xOffset
	self.cached_db_profile.barsConfig_RightMultiActionBars_yOffset = self.db.profile.barsConfig.RightMultiActionBars.yOffset
	self.cached_db_profile.barsConfig_RightMultiActionBars_ignoreyOffsetStatusBar = self.db.profile.barsConfig.RightMultiActionBars.ignoreyOffsetStatusBar
	self.cached_db_profile.barsConfig_RightMultiActionBars_yOffset1StatusBar = self.db.profile.barsConfig.RightMultiActionBars.yOffset1StatusBar
	self.cached_db_profile.barsConfig_RightMultiActionBars_yOffset2StatusBar = self.db.profile.barsConfig.RightMultiActionBars.yOffset2StatusBar
	self.cached_db_profile.barsConfig_PetActionBarFrame_hideOnOverrideActionBar = self.db.profile.barsConfig.PetActionBarFrame.hideOnOverrideActionBar
	self.cached_db_profile.barsConfig_PetActionBarFrame_hideOnPetBattleFrameBar = self.db.profile.barsConfig.PetActionBarFrame.hideOnPetBattleFrameBar
	self.cached_db_profile.barsConfig_PetActionBarFrame_dontMoveOnOverrideActionBar = self.db.profile.barsConfig.PetActionBarFrame.dontMoveOnOverrideActionBar
	self.cached_db_profile.barsConfig_PetActionBarFrame_dontMoveOnPetBattleFrameBar = self.db.profile.barsConfig.PetActionBarFrame.dontMoveOnPetBattleFrameBar
	self.cached_db_profile.barsConfig_PetActionBarFrame_xOffset = self.db.profile.barsConfig.PetActionBarFrame.xOffset
	self.cached_db_profile.barsConfig_PetActionBarFrame_yOffset = self.db.profile.barsConfig.PetActionBarFrame.yOffset
	self.cached_db_profile.barsConfig_PetActionBarFrame_xOffsetIfStanceBar = self.db.profile.barsConfig.PetActionBarFrame.xOffsetIfStanceBar
	self.cached_db_profile.barsConfig_PetActionBarFrame_ignoreyOffsetStatusBar = self.db.profile.barsConfig.PetActionBarFrame.ignoreyOffsetStatusBar
	self.cached_db_profile.barsConfig_PetActionBarFrame_yOffset1StatusBar = self.db.profile.barsConfig.PetActionBarFrame.yOffset1StatusBar
	self.cached_db_profile.barsConfig_PetActionBarFrame_yOffset2StatusBar = self.db.profile.barsConfig.PetActionBarFrame.yOffset2StatusBar
	self.cached_db_profile.barsConfig_PossessBarFrame_xOffset = self.db.profile.barsConfig.PossessBarFrame.xOffset
	self.cached_db_profile.barsConfig_PossessBarFrame_yOffset = self.db.profile.barsConfig.PossessBarFrame.yOffset
	self.cached_db_profile.barsConfig_PossessBarFrame_ignoreyOffsetStatusBar = self.db.profile.barsConfig.PossessBarFrame.ignoreyOffsetStatusBar
	self.cached_db_profile.barsConfig_PossessBarFrame_yOffset1StatusBar = self.db.profile.barsConfig.PossessBarFrame.yOffset1StatusBar
	self.cached_db_profile.barsConfig_PossessBarFrame_yOffset2StatusBar = self.db.profile.barsConfig.PossessBarFrame.yOffset2StatusBar
	self.cached_db_profile.barsConfig_StanceBarFrame_xOffset = self.db.profile.barsConfig.StanceBarFrame.xOffset
	self.cached_db_profile.barsConfig_StanceBarFrame_yOffset = self.db.profile.barsConfig.StanceBarFrame.yOffset
	self.cached_db_profile.barsConfig_StanceBarFrame_ignoreyOffsetStatusBar = self.db.profile.barsConfig.StanceBarFrame.ignoreyOffsetStatusBar
	self.cached_db_profile.barsConfig_StanceBarFrame_yOffset1StatusBar = self.db.profile.barsConfig.StanceBarFrame.yOffset1StatusBar
	self.cached_db_profile.barsConfig_StanceBarFrame_yOffset2StatusBar = self.db.profile.barsConfig.StanceBarFrame.yOffset2StatusBar
	self.cached_db_profile.barsConfig_StanceBarFrame_BLStyle = self.db.profile.barsConfig.StanceBarFrame.BLStyle
	self.cached_db_profile.barsConfig_MicroButtons_StoreMicroButton_hideMicroButton = self.db.profile.barsConfig.MicroButtons.StoreMicroButton.hideMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_CharacterMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.CharacterMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_ProfessionMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_AchievementMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.AchievementMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_QuestLogMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_HousingMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.HousingMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.GuildMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_LFDMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.LFDMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_CollectionsMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_EJMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.EJMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_StoreMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.StoreMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_disableMicroButton = self.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.disableMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_HousingMicroButton_classicNotificationMicroButton = self.db.profile.barsConfig.MicroButtons.HousingMicroButton.classicNotificationMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_classicNotificationMicroButton = self.db.profile.barsConfig.MicroButtons.GuildMicroButton.classicNotificationMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_EJMicroButton_classicNotificationMicroButton = self.db.profile.barsConfig.MicroButtons.EJMicroButton.classicNotificationMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_classicNotificationMicroButton = self.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.classicNotificationMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton = self.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_normalTextureSB = self.MICROBUTTONS_ARRAYINFO[23].normalTextureSB
	self.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_pushedTextureSB = self.MICROBUTTONS_ARRAYINFO[23].pushedTextureSB
	self.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_disabledTextureSB = self.MICROBUTTONS_ARRAYINFO[23].disabledTextureSB
	self.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_normalTextureTT = self.MICROBUTTONS_ARRAYINFO[23].normalTextureTT
	self.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_pushedTextureTT = self.MICROBUTTONS_ARRAYINFO[23].pushedTextureTT
	self.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_disabledTextureTT = self.MICROBUTTONS_ARRAYINFO[23].disabledTextureTT
	self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton = self.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_normalTexture = self.MICROBUTTONS_ARRAYINFO[self.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].normalTexture
	self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_pushedTexture = self.MICROBUTTONS_ARRAYINFO[self.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].pushedTexture
	self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_disabledTexture = self.MICROBUTTONS_ARRAYINFO[self.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].disabledTexture
	if (self.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton == 7 or self.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton == 8) then	-- Guild Emblem / Bigger Guild Emblem
		self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_normalTextureGuild = self.MICROBUTTONS_ARRAYINFO[self.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].normalTextureGuild
		self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_pushedTextureGuild = self.MICROBUTTONS_ARRAYINFO[self.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].pushedTextureGuild
		self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_disabledTextureGuild = self.MICROBUTTONS_ARRAYINFO[self.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].disabledTextureGuild
	else
		self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_normalTextureGuild = self.MICROBUTTONS_ARRAYINFO[7].normalTextureGuild
		self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_pushedTextureGuild = self.MICROBUTTONS_ARRAYINFO[7].pushedTextureGuild
		self.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_disabledTextureGuild = self.MICROBUTTONS_ARRAYINFO[7].disabledTextureGuild
	end
	self.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton = self.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton
	self.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton_normalTexture = self.MICROBUTTONS_ARRAYINFO[self.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton].normalTexture
	self.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton_pushedTexture = self.MICROBUTTONS_ARRAYINFO[self.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton].pushedTexture
	self.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton_disabledTexture = self.MICROBUTTONS_ARRAYINFO[self.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton].disabledTexture
	self.cached_db_profile.barsConfig_BagsIcons_xOffsetReagentBag = self.db.profile.barsConfig.BagsIcons.xOffsetReagentBag
	self.cached_db_profile.barsConfig_BagsIcons_yOffsetReagentBag = self.db.profile.barsConfig.BagsIcons.yOffsetReagentBag
	self.cached_db_profile.extraFrames_Minimap_enabled = self.db.profile.extraFrames.Minimap.enabled
	self.cached_db_profile.extraFrames_Minimap_xOffset = self.db.profile.extraFrames.Minimap.xOffset
	self.cached_db_profile.extraFrames_Minimap_yOffset = self.db.profile.extraFrames.Minimap.yOffset
	self.cached_db_profile.extraFrames_Minimap_minimapArrangementType = self.db.profile.extraFrames.Minimap.minimapArrangementType
	self.cached_db_profile.extraFrames_Minimap_xOffsetExpansionLandingPage = self.db.profile.extraFrames.Minimap.xOffsetExpansionLandingPage
	self.cached_db_profile.extraFrames_Minimap_yOffsetExpansionLandingPage = self.db.profile.extraFrames.Minimap.yOffsetExpansionLandingPage
	self.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageDragonflight = self.db.profile.extraFrames.Minimap.scaleExpansionLandingPageDragonflight
	self.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageTheWarWithin = self.db.profile.extraFrames.Minimap.scaleExpansionLandingPageTheWarWithin
	self.cached_db_profile.extraFrames_Minimap_hideAddonCompartment = self.db.profile.extraFrames.Minimap.hideAddonCompartment
	self.cached_db_profile.extraFrames_Minimap_anchorQueueButtonToMinimap = self.db.profile.extraFrames.Minimap.anchorQueueButtonToMinimap
	self.cached_db_profile.extraFrames_Minimap_xOffsetQueueButton = self.db.profile.extraFrames.Minimap.xOffsetQueueButton
	self.cached_db_profile.extraFrames_Minimap_yOffsetQueueButton = self.db.profile.extraFrames.Minimap.yOffsetQueueButton
	self.cached_db_profile.extraFrames_Bags_freeSlotCounterMod = self.db.profile.extraFrames.Bags.freeSlotCounterMod
	self.cached_db_profile.extraFrames_Chat_restoreScrollButtons = self.db.profile.extraFrames.Chat.restoreScrollButtons
	self.cached_db_profile.extraFrames_Chat_restoreBottomScrollButton = self.db.profile.extraFrames.Chat.restoreBottomScrollButton
	self.cached_db_profile.extraFrames_Chat_socialButtonToBottom = self.db.profile.extraFrames.Chat.socialButtonToBottom
	self.cached_db_profile.extraConfigs_KeybindsConfig_hideKeybindsMode = self.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode
	self.cached_db_profile.extraConfigs_GreyOnCooldownConfig_enabled = self.db.profile.extraConfigs.GreyOnCooldownConfig.enabled
	self.cached_db_profile.extraConfigs_GreyOnCooldownConfig_desaturateUnusableActions = self.db.profile.extraConfigs.GreyOnCooldownConfig.desaturateUnusableActions
	self.cached_db_profile.extraConfigs_GreyOnCooldownConfig_desaturatePetActionButtons = self.db.profile.extraConfigs.GreyOnCooldownConfig.desaturatePetActionButtons
	self.cached_db_profile.extraConfigs_LossOfControlUIConfig_enabled = self.db.profile.extraConfigs.LossOfControlUIConfig.enabled
	self.cached_db_profile.extraConfigs_GuildPanelMode_defaultOpenOldMenu = self.db.profile.extraConfigs.GuildPanelMode.defaultOpenOldMenu
	self.cached_db_profile.extraConfigs_GuildPanelMode_rightClickMicroButtonOpenOldMenu = self.db.profile.extraConfigs.GuildPanelMode.rightClickMicroButtonOpenOldMenu
	self.cached_db_profile.extraConfigs_GuildPanelMode_middleClickMicroButtonOpenOldMenu = self.db.profile.extraConfigs.GuildPanelMode.middleClickMicroButtonOpenOldMenu
	self.cached_db_profile.extraConfigs_GuildPanelMode_leftClickMicroButtonOpenOldMenu = self.db.profile.extraConfigs.GuildPanelMode.leftClickMicroButtonOpenOldMenu
end

-- Function to update the status bars when requested
function ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
	if (self:IsEnabled()) then
		StatusTrackingBarManager.TopBarFrameTexture0:Hide()
		StatusTrackingBarManager.TopBarFrameTexture1:Hide()
		StatusTrackingBarManager.TopBarFrameTexture2:Hide()
		StatusTrackingBarManager.TopBarFrameTexture3:Hide()
		StatusTrackingBarManager.BottomBarFrameTexture0:Hide()
		StatusTrackingBarManager.BottomBarFrameTexture1:Hide()
		StatusTrackingBarManager.BottomBarFrameTexture2:Hide()
		StatusTrackingBarManager.BottomBarFrameTexture3:Hide()
		local visBars = {}
		for _, bar in ipairs(ClassicUI.STBMbars) do
			if (bar:IsShown() and bar:ShouldBeVisible()) then
				tblinsert(visBars, bar)
			end
		end
		tblsort(visBars, function(left, right) return left:GetPriority() < right:GetPriority() end)
		local width = StatusTrackingBarManager:GetParent():GetSize()
		local visBarsSize = #visBars
		local TOP_BAR = true
		if (visBarsSize > 1) then
			self.StatusTrackingBarManager_LayoutBar(StatusTrackingBarManager, visBars[2], not TOP_BAR)
			self.StatusTrackingBarManager_LayoutBar(StatusTrackingBarManager, visBars[1], TOP_BAR)
		elseif (visBarsSize == 1) then
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
	QueueStatusButtonIcon.EyePokeInitial.EyePokeInitialTexture:SetSize(44, 44)
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
	if (ClassicUI.db.profile.extraFrames.Bags.freeSlotCounterMod == 2) then
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
					freeSlots, bagFamily = C_Container_GetContainerNumFreeSlots(i)
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
	if (ClassicUI.db.profile.extraFrames.Bags.freeSlotCounterMod ~= 0) then
		ClassicUI.MainMenuBarBackpackButton_UpdateFreeSlots(MainMenuBarBackpackButton)
	else
		local freeBagSlots = CalculateTotalNumberOfFreeBagSlots()
		MainMenuBarBackpackButton:UpdateFreeSlots()
		MainMenuBarBackpackButton.Count:SetText(ClassicUI.BACKPACK_FREESLOTS_FORMAT:format(freeBagSlots))
	end
end

-- Function that hides the CollapseAndExpandButton from the BuffFrame
function ClassicUI:BuffFrameHideCollapseAndExpandButton()
	if not ClassicUI.hooked_BuffFrame_RefreshConsolidationFrameVisibility then
		hooksecurefunc(BuffFrame, "RefreshConsolidationFrameVisibility", function(self)
			self.CollapseAndExpandButton:Hide()
		end)
		ClassicUI.hooked_BuffFrame_RefreshConsolidationFrameVisibility = true
	end
	BuffFrame.CollapseAndExpandButton:Hide()
end

-- Function to update the visibility and position of scroll buttons from the Chat Frame
function ClassicUI:UpdateScrollButtonsVisibilityAndPosition(cftvmb)
	if not(ClassicUI.cached_db_profile.extraFrames_Chat_restoreScrollButtons) then return end	-- cached db value
	local but = cftvmb or ChatFrameToggleVoiceMuteButton
	local voiceButtonsVisible
	if not(but) or not(but.isVisible) then
		voiceButtonsVisible = true
	else
		voiceButtonsVisible = but.isVisible and but:isVisible()
	end
	local hiddenMode = 0	-- 0 = three buttons shown; 1 = two buttons shown; 2 = three buttons hidden
	local chH = ChatFrame1ButtonFrame:GetHeight()
	if (voiceButtonsVisible) then
		if (chH == nil or chH >= 200) then
			-- Show the 3 scroll buttons
			if (CUI_ChatFrame1ButtonFrameBottomButton and not(CUI_ChatFrame1ButtonFrameBottomButton:IsShown()) and CUI_ChatFrame1ButtonFrameBottomButton.allowShow) then
				if not(CUI_ChatFrame1ButtonFrameBottomButton.hooked_ChatFrame_OnUpdate) then
					for i = 1, 10 do
						_G["ChatFrame"..i]:HookScript("OnUpdate", CUI_ChatFrame1ButtonFrameBottomButton.func_ChatFrame_OnUpdate)
					end
					CUI_ChatFrame1ButtonFrameBottomButton.hooked_ChatFrame_OnUpdate = true
				end
				CUI_ChatFrame1ButtonFrameBottomButton:Show()
			end
			if (CUI_ChatFrame1ButtonFrameDownButton and not(CUI_ChatFrame1ButtonFrameDownButton:IsShown()) and CUI_ChatFrame1ButtonFrameDownButton.allowShow) then
				CUI_ChatFrame1ButtonFrameDownButton:Show()
			end
			if (CUI_ChatFrame1ButtonFrameUpButton and not(CUI_ChatFrame1ButtonFrameUpButton:IsShown()) and CUI_ChatFrame1ButtonFrameUpButton.allowShow) then
				CUI_ChatFrame1ButtonFrameUpButton:Show()
			end
		elseif (chH >= 168) then
			-- Show the 2 main scroll buttons, hide the bottom scroll button
			if (CUI_ChatFrame1ButtonFrameBottomButton and CUI_ChatFrame1ButtonFrameBottomButton:IsShown()) then
				CUI_ChatFrame1ButtonFrameBottomButton:Hide()
			end
			if (CUI_ChatFrame1ButtonFrameDownButton and not(CUI_ChatFrame1ButtonFrameDownButton:IsShown()) and CUI_ChatFrame1ButtonFrameDownButton.allowShow) then
				CUI_ChatFrame1ButtonFrameDownButton:Show()
			end
			if (CUI_ChatFrame1ButtonFrameUpButton and not(CUI_ChatFrame1ButtonFrameUpButton:IsShown()) and CUI_ChatFrame1ButtonFrameUpButton.allowShow) then
				CUI_ChatFrame1ButtonFrameUpButton:Show()
			end
			hiddenMode = 1
		else
			-- Hide the 3 scroll buttons
			if (CUI_ChatFrame1ButtonFrameBottomButton and CUI_ChatFrame1ButtonFrameBottomButton:IsShown()) then
				CUI_ChatFrame1ButtonFrameBottomButton:Hide()
			end
			if (CUI_ChatFrame1ButtonFrameDownButton and CUI_ChatFrame1ButtonFrameDownButton:IsShown()) then
				CUI_ChatFrame1ButtonFrameDownButton:Hide()
			end
			if (CUI_ChatFrame1ButtonFrameUpButton and CUI_ChatFrame1ButtonFrameUpButton:IsShown()) then
				CUI_ChatFrame1ButtonFrameUpButton:Hide()
			end
			hiddenMode = 2
		end
	else
		if (chH == nil or chH >= 142) then
			-- Show the 3 scroll buttons
			if (CUI_ChatFrame1ButtonFrameBottomButton and not(CUI_ChatFrame1ButtonFrameBottomButton:IsShown()) and CUI_ChatFrame1ButtonFrameBottomButton.allowShow) then
				if not(CUI_ChatFrame1ButtonFrameBottomButton.hooked_ChatFrame_OnUpdate) then
					for i = 1, 10 do
						_G["ChatFrame"..i]:HookScript("OnUpdate", CUI_ChatFrame1ButtonFrameBottomButton.func_ChatFrame_OnUpdate)
					end
					CUI_ChatFrame1ButtonFrameBottomButton.hooked_ChatFrame_OnUpdate = true
				end
				CUI_ChatFrame1ButtonFrameBottomButton:Show()
			end
			if (CUI_ChatFrame1ButtonFrameDownButton and not(CUI_ChatFrame1ButtonFrameDownButton:IsShown()) and CUI_ChatFrame1ButtonFrameDownButton.allowShow) then
				CUI_ChatFrame1ButtonFrameDownButton:Show()
			end
			if (CUI_ChatFrame1ButtonFrameUpButton and not(CUI_ChatFrame1ButtonFrameUpButton:IsShown()) and CUI_ChatFrame1ButtonFrameUpButton.allowShow) then
				CUI_ChatFrame1ButtonFrameUpButton:Show()
			end
		else
			-- Show the 2 main scroll buttons, hide the bottom scroll button
			if (CUI_ChatFrame1ButtonFrameBottomButton and CUI_ChatFrame1ButtonFrameBottomButton:IsShown()) then
				CUI_ChatFrame1ButtonFrameBottomButton:Hide()
			end
			if (CUI_ChatFrame1ButtonFrameDownButton and not(CUI_ChatFrame1ButtonFrameDownButton:IsShown()) and CUI_ChatFrame1ButtonFrameDownButton.allowShow) then
				CUI_ChatFrame1ButtonFrameDownButton:Show()
			end
			if (CUI_ChatFrame1ButtonFrameUpButton and not(CUI_ChatFrame1ButtonFrameUpButton:IsShown()) and CUI_ChatFrame1ButtonFrameUpButton.allowShow) then
				CUI_ChatFrame1ButtonFrameUpButton:Show()
			end
			hiddenMode = 1
		end
	end
	if (CUI_ChatFrame1ButtonFrameDownButton and CUI_ChatFrame1ButtonFrameUpButton) then
		CUI_ChatFrame1ButtonFrameDownButton:ClearAllPoints()
		ChatFrameMenuButton:ClearAllPoints()
		if (ClassicUI.cached_db_profile.extraFrames_Chat_restoreBottomScrollButton and CUI_ChatFrame1ButtonFrameBottomButton) then	-- cached db value
			CUI_ChatFrame1ButtonFrameBottomButton:ClearAllPoints()
			if (ClassicUI.cached_db_profile.extraFrames_Chat_socialButtonToBottom) then	-- cached db value
				CUI_ChatFrame1ButtonFrameBottomButton:SetPoint("BOTTOM", ChatFrameMenuButton, "TOP", 0, -2)
				if (hiddenMode ~= 1) then
					CUI_ChatFrame1ButtonFrameDownButton:SetPoint("BOTTOM", CUI_ChatFrame1ButtonFrameBottomButton, "TOP", 0, -2)
				else
					CUI_ChatFrame1ButtonFrameDownButton:SetPoint("BOTTOM", ChatFrameMenuButton, "TOP", 0, -2)
				end
			else
				CUI_ChatFrame1ButtonFrameBottomButton:SetPoint("BOTTOM", ChatFrame1ButtonFrame, "BOTTOM", 0, -7)
				if (hiddenMode ~= 1) then
					CUI_ChatFrame1ButtonFrameDownButton:SetPoint("BOTTOM", CUI_ChatFrame1ButtonFrameBottomButton, "TOP", 0, -2)
				else
					CUI_ChatFrame1ButtonFrameDownButton:SetPoint("BOTTOM", ChatFrame1ButtonFrame, "BOTTOM", 0, -7)
				end
			end
		else
			if (ClassicUI.cached_db_profile.extraFrames_Chat_socialButtonToBottom) then	-- cached db value
				CUI_ChatFrame1ButtonFrameDownButton:SetPoint("BOTTOM", ChatFrameMenuButton, "TOP", 0, -2)
			else
				CUI_ChatFrame1ButtonFrameDownButton:SetPoint("BOTTOM", ChatFrame1ButtonFrame, "BOTTOM", 0, -7)
			end
		end
		if (ClassicUI.cached_db_profile.extraFrames_Chat_socialButtonToBottom or (hiddenMode == 2)) then	-- cached db value
			ChatFrameMenuButton:SetPoint("BOTTOM", ChatFrameMenuButton:GetParent(), "BOTTOM", 0, -7)
		else
			ChatFrameMenuButton:SetPoint("BOTTOM", CUI_ChatFrame1ButtonFrameUpButton, "TOP", 0, 0)
		end
	end
end

-- Function to restore some old buttons from the Chat Frame
function ClassicUI:RestoreChatScrollButtons()
	local cFrameStrata = ChatFrameMenuButton:GetFrameStrata() or "LOW"
	local cFrameLevel = ChatFrameMenuButton:GetFrameLevel() or 7
	local CUI_ChatFrame1ButtonFrameBottomButton = _G["CUI_ChatFrame1ButtonFrameBottomButton"]
	if (ClassicUI.db.profile.extraFrames.Chat.restoreBottomScrollButton) then
		if (CUI_ChatFrame1ButtonFrameBottomButton == nil) then
			CUI_ChatFrame1ButtonFrameBottomButton = CreateFrame("Button", "CUI_ChatFrame1ButtonFrameBottomButton", ChatFrame1ButtonFrame)
			CUI_ChatFrame1ButtonFrameBottomButton:SetFrameStrata(cFrameStrata)
			CUI_ChatFrame1ButtonFrameBottomButton:SetFrameLevel(cFrameLevel)
			CUI_ChatFrame1ButtonFrameBottomButton:SetSize(32, 32)
			CUI_ChatFrame1ButtonFrameBottomButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollEnd-Up")
			CUI_ChatFrame1ButtonFrameBottomButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollEnd-Down")
			CUI_ChatFrame1ButtonFrameBottomButton:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollEnd-Disabled")
			CUI_ChatFrame1ButtonFrameBottomButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
			local CUI_ChatFrame1ButtonFrameBottomButtonFlash = CUI_ChatFrame1ButtonFrameBottomButton:CreateTexture("CUI_ChatFrame1ButtonFrameBottomButtonFlash", "OVERLAY")
			CUI_ChatFrame1ButtonFrameBottomButtonFlash:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
			CUI_ChatFrame1ButtonFrameBottomButtonFlash:SetAllPoints(CUI_ChatFrame1ButtonFrameBottomButton)
			CUI_ChatFrame1ButtonFrameBottomButtonFlash:Hide()
			CUI_ChatFrame1ButtonFrameBottomButton.clickDelay = ClassicUI.MESSAGE_SCROLLBUTTON_INITIAL_DELAY
			CUI_ChatFrame1ButtonFrameBottomButton:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonUp", "RightButtonDown")
			CUI_ChatFrame1ButtonFrameBottomButton:SetScript("OnClick", function(self, button)
				PlaySound(SOUNDKIT.IG_CHAT_BOTTOM)
				self:GetParent():GetParent():ScrollToBottom()
			end)
			CUI_ChatFrame1ButtonFrameBottomButton.func_ChatFrame_OnUpdate = function(self, elapsed)
				local flash = CUI_ChatFrame1ButtonFrameBottomButtonFlash
				local cflash = self.ScrollToBottomButton.Flash
				if flash and cflash then
					if (self:AtBottom()) then
						if (flash:IsShown()) then
							flash:Hide()
						end
						return
					end
					if cflash:IsShown() then
						flash:SetAlpha(cflash:GetAlpha())
						if (not flash:IsShown()) then
							flash:Show()
						end
					else
						if (flash:IsShown()) then
							flash:Hide()
						end
					end
				end
			end
			CUI_ChatFrame1ButtonFrameBottomButton:Hide()
		end
		CUI_ChatFrame1ButtonFrameBottomButton.allowShow = true
	else
		if CUI_ChatFrame1ButtonFrameBottomButton ~= nil then
			CUI_ChatFrame1ButtonFrameBottomButton.allowShow = false
			CUI_ChatFrame1ButtonFrameBottomButton:Hide()
		end
	end
	local CUI_ChatFrame1ButtonFrameDownButton = _G["CUI_ChatFrame1ButtonFrameDownButton"]
	if (CUI_ChatFrame1ButtonFrameDownButton == nil) then
		CUI_ChatFrame1ButtonFrameDownButton = CreateFrame("Button", "CUI_ChatFrame1ButtonFrameDownButton", ChatFrame1ButtonFrame)
		CUI_ChatFrame1ButtonFrameDownButton:SetFrameStrata(cFrameStrata)
		CUI_ChatFrame1ButtonFrameDownButton:SetFrameLevel(cFrameLevel)
		CUI_ChatFrame1ButtonFrameDownButton:SetSize(32, 32)
		CUI_ChatFrame1ButtonFrameDownButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
		CUI_ChatFrame1ButtonFrameDownButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
		CUI_ChatFrame1ButtonFrameDownButton:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
		CUI_ChatFrame1ButtonFrameDownButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
		CUI_ChatFrame1ButtonFrameDownButton.clickDelay = ClassicUI.MESSAGE_SCROLLBUTTON_INITIAL_DELAY
		CUI_ChatFrame1ButtonFrameDownButton:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonUp", "RightButtonDown")
		CUI_ChatFrame1ButtonFrameDownButton:SetScript("OnUpdate", function(self, elapsed)
			if (self:GetButtonState() == "PUSHED") then
				self.clickDelay = self.clickDelay - elapsed
				if ( self.clickDelay < 0 ) then
					self:GetParent():GetParent():ScrollDown()
					self.clickDelay = ClassicUI.MESSAGE_SCROLLBUTTON_SCROLL_DELAY
				end
			end
		end)
		CUI_ChatFrame1ButtonFrameDownButton:SetScript("OnClick", function(self, button)
			if (self:GetButtonState() == "PUSHED") then
				self.clickDelay = ClassicUI.MESSAGE_SCROLLBUTTON_INITIAL_DELAY
			else
				self:GetParent():GetParent():ScrollDown()
			end
			PlaySound(SOUNDKIT.IG_CHAT_SCROLL_DOWN)
		end)
		CUI_ChatFrame1ButtonFrameDownButton:Hide()
	end
	CUI_ChatFrame1ButtonFrameDownButton.allowShow = true
	local CUI_ChatFrame1ButtonFrameUpButton = _G["CUI_ChatFrame1ButtonFrameUpButton"]
	if (CUI_ChatFrame1ButtonFrameUpButton == nil) then
		CUI_ChatFrame1ButtonFrameUpButton = CreateFrame("Button", "CUI_ChatFrame1ButtonFrameUpButton", ChatFrame1ButtonFrame)
		CUI_ChatFrame1ButtonFrameUpButton:SetFrameStrata(cFrameStrata)
		CUI_ChatFrame1ButtonFrameUpButton:SetFrameLevel(cFrameLevel)
		CUI_ChatFrame1ButtonFrameUpButton:SetSize(32, 32)
		CUI_ChatFrame1ButtonFrameUpButton:SetPoint("BOTTOM", CUI_ChatFrame1ButtonFrameDownButton, "TOP", 0, 0)
		CUI_ChatFrame1ButtonFrameUpButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up")
		CUI_ChatFrame1ButtonFrameUpButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down")
		CUI_ChatFrame1ButtonFrameUpButton:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled")
		CUI_ChatFrame1ButtonFrameUpButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
		CUI_ChatFrame1ButtonFrameUpButton.clickDelay = ClassicUI.MESSAGE_SCROLLBUTTON_INITIAL_DELAY
		CUI_ChatFrame1ButtonFrameUpButton:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonUp", "RightButtonDown")
		CUI_ChatFrame1ButtonFrameUpButton:SetScript("OnUpdate", function(self, elapsed)
			if (self:GetButtonState() == "PUSHED") then
				self.clickDelay = self.clickDelay - elapsed
				if ( self.clickDelay < 0 ) then
					self:GetParent():GetParent():ScrollUp()
					self.clickDelay = ClassicUI.MESSAGE_SCROLLBUTTON_SCROLL_DELAY
				end
			end
		end)
		CUI_ChatFrame1ButtonFrameUpButton:SetScript("OnClick", function(self, button)
			if (self:GetButtonState() == "PUSHED") then
				self.clickDelay = ClassicUI.MESSAGE_SCROLLBUTTON_INITIAL_DELAY
			else
				self:GetParent():GetParent():ScrollUp()
			end
			PlaySound(SOUNDKIT.IG_CHAT_SCROLL_UP)
		end)
		CUI_ChatFrame1ButtonFrameUpButton:Hide()
	end
	CUI_ChatFrame1ButtonFrameUpButton.allowShow = true
	ClassicUI:UpdateScrollButtonsVisibilityAndPosition()
	if not(ClassicUI.hooked_ChatFrameToggleVoiceMuteButton) then
		hooksecurefunc(ChatFrameToggleVoiceMuteButton, "CallVisibilityQuery", function(self)
			ClassicUI:UpdateScrollButtonsVisibilityAndPosition(self)
		end)
		ClassicUI.hooked_ChatFrameToggleVoiceMuteButton = true
	end
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
	else
		if (ClassicUI:IsEnabled()) then
			QueueStatusButton:SetParent(UIParent)
			QueueStatusButton:ClearAllPoints()
			QueueStatusButton:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -45 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, 4 - ClassicUI.MICROBUTTONANDBAGSBAR_CUI_OFFSET_Y + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
			QueueStatusButton:SetFrameStrata("MEDIUM")
			QueueStatusButton:SetFrameLevel(53)
		else
			local point, relativeTo, relativePoint, xOfs, yOfs = QueueStatusButton:GetPoint()
			QueueStatusButton:ClearAllPoints()
			QueueStatusButton:SetPoint(point, relativeTo, relativePoint, xOfs + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, yOfs + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
		end
	end
	if not(ClassicUI.db.profile.extraFrames.Minimap.bigQueueButton) then
		ClassicUI:QueueButtonSetSmallSize()
	end
	hooksecurefunc(QueueStatusButton, "UpdatePosition", function(self, microMenuPosition, isMenuHorizontal)
		if (ClassicUI.cached_db_profile.extraFrames_Minimap_anchorQueueButtonToMinimap) then	-- cached db value
			self:ClearAllPoints()
			if (ClassicUI.cached_db_profile.extraFrames_Minimap_enabled) then	-- cached db value
				self:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 22 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetQueueButton, -100 + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetQueueButton)	-- cached db value
			else
				self:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", -7 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetQueueButton, -135 + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetQueueButton)	-- cached db value
			end
		else
			if (ClassicUI:IsEnabled()) then
				self:ClearAllPoints()
				self:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -45 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetQueueButton, 4 - ClassicUI.MICROBUTTONANDBAGSBAR_CUI_OFFSET_Y + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetQueueButton)	-- cached db value
			else
				local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
				self:ClearAllPoints()
				self:SetPoint(point, relativeTo, relativePoint, xOfs + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetQueueButton, yOfs + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetQueueButton)	-- cached db value
			end
		end
	end)

	-- [Bags]
	if (ClassicUI.db.profile.extraFrames.Bags.freeSlotCounterMod ~= 0) then
		ClassicUI:BagsFreeSlotsCounterMod()
	end
	if (ClassicUI.db.profile.extraFrames.Bags.xOffsetFreeSlotsCounter ~= 0) or (ClassicUI.db.profile.extraFrames.Bags.yOffsetFreeSlotsCounter ~= 0) then
		MainMenuBarBackpackButton.Count:ClearAllPoints()
		MainMenuBarBackpackButton.Count:SetPoint("CENTER", MainMenuBarBackpackButton, "CENTER", 0 + ClassicUI.db.profile.extraFrames.Bags.xOffsetFreeSlotsCounter, -10 + ClassicUI.db.profile.extraFrames.Bags.yOffsetFreeSlotsCounter)
	end
	if (mathabs(ClassicUI.db.profile.extraFrames.Bags.freeSlotsCounterFontSize-ClassicUI.db.defaults.profile.extraFrames.Bags.freeSlotsCounterFontSize) > STANDARD_EPSILON) then
		local font, _, flags = MainMenuBarBackpackButton.Count:GetFont()
		MainMenuBarBackpackButton.Count:SetFont(font, ClassicUI.db.profile.extraFrames.Bags.freeSlotsCounterFontSize, flags)
	end

	-- [BuffAndDebuffFrames]
	if (ClassicUI.db.profile.extraFrames.BuffAndDebuffFrames.hideCollapseAndExpandButton) then
		ClassicUI:BuffFrameHideCollapseAndExpandButton()
	end

	-- [Chat]
	if (ClassicUI.db.profile.extraFrames.Chat.restoreScrollButtons) then
		ClassicUI:RestoreChatScrollButtons()
	end

	-- Updates after exit edit mode
	if not(ClassicUI.onExitEditModeMF) then
		if (EventRegistry and type(EventRegistry) == "table") then
			ClassicUI.onExitEditModeEFF = function(self)
				if (ClassicUI.cached_db_profile.extraFrames_Chat_restoreScrollButtons) then	-- cached db value
					ClassicUI:UpdateScrollButtonsVisibilityAndPosition()
				end
			end
			EventRegistry:RegisterCallback("EditMode.Exit", ClassicUI.onExitEditModeEFF, ClassicUI)
		end
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
	-- Extra Option: Guild Panel Mode
	if ((ClassicUI.db.profile.extraConfigs.GuildPanelMode.defaultOpenOldMenu) or (ClassicUI.db.profile.extraConfigs.GuildPanelMode.middleClickMicroButtonOpenOldMenu) or (ClassicUI.db.profile.extraConfigs.GuildPanelMode.rightClickMicroButtonOpenOldMenu) or (ClassicUI.db.profile.extraConfigs.GuildPanelMode.leftClickMicroButtonOpenOldMenu)) then
		ClassicUI:HookOpenGuildPanelMode()
	end
	-- Extra Option: Keybinds Visibility
	if (ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode > 0) then
		self:ToggleVisibilityKeybinds(ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode)
	end
	-- Extra Option: ActionBar Names Visibility
	if (ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideActionButtonName) then
		self:ToggleVisibilityActionButtonNames(ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideActionButtonName)
	end
	-- Extra Option: RedRange
	if (ClassicUI.db.profile.extraConfigs.RedRangeConfig.enabled) then
		self:HookRedRangeIcons()
	end
	-- Extra Option: GreyOnCooldown
	if (ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.enabled) then
		self:GOC_MainFunction()
	end
	-- Extra Option: LossOfControlUI
	if (ClassicUI.db.profile.extraConfigs.LossOfControlUIConfig.enabled) then
		self:HookLossOfControlUICCRemover()
	end
end

-- Function that modifies some attributes of the original frames
function ClassicUI:ModifyOriginalFrames()
	-- Modify FrameStrata and FrameLevel and make the ActionBar frames non-clickable
	MainActionBar:SetFrameStrata("MEDIUM")
	MainActionBar:SetFrameLevel(1)
	MainActionBar:EnableMouse(false)
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
	-- Modify the size of ActionBars
	MainActionBar:SetSize(1024, 53)
	MultiBarBottomLeft:SetSize(500, 38)
	MultiBarBottomRight:SetSize(500, 38)
	MultiBarRight:SetSize(38, 500)
	MultiBarLeft:SetSize(38, 500)
	PetActionBar:SetSize(509, 43)
	PossessActionBar:SetSize(29, 32)
	StanceBar:SetSize(29, 32)
	-- Modify the position of some ActionBars
	ClassicUI:UpdateRightActionBarPositions()
	ClassicUI:UpdateBottomActionBarPositions()
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
	MainActionBar:SetFrameStrata("MEDIUM")
	MainActionBar:SetFrameLevel(1)
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

-- Function that mimics 'EditModeManagerFrame.UpdateRightActionBarPositions' to calculate and set the position of the right side ActionBars (other modifications are ignored)
function ClassicUI:UpdateRightActionBarPositions()
	if ((EditModeManagerFrame == nil) or not(EditModeManagerFrame:IsInitialized()) or EditModeManagerFrame.layoutApplyInProgress) then
		return
	end
	local barsToUpdate = { MultiBarRight, MultiBarLeft }
	local offsetX = RIGHT_ACTION_BAR_DEFAULT_OFFSET_X
	local offsetY = RIGHT_ACTION_BAR_DEFAULT_OFFSET_Y
	local leftMostBar = nil
	for index, bar in ipairs(barsToUpdate) do
		if bar and bar:IsShown() then
			local isInDefaultPosition = bar:IsInDefaultPosition()
			if isInDefaultPosition then
				local leftMostBarWidth = leftMostBar and -leftMostBar:GetWidth() - 5 or 0
				offsetX = offsetX + leftMostBarWidth
				bar:ClearAllPoints()
				bar:SetPoint("RIGHT", UIParent, "RIGHT", offsetX, offsetY)
				leftMostBar = bar
			end
		end
	end
end

-- Function that mimics 'EditModeManagerFrame.UpdateBottomActionBarPositions' to calculate and set the position of the bottom side ActionBars (other modifications are ignored)
function ClassicUI:UpdateBottomActionBarPositions()
	if ((EditModeManagerFrame == nil) or not(EditModeManagerFrame:IsInitialized()) or EditModeManagerFrame.layoutApplyInProgress) then
		return
	end
	local barsToUpdate = { MainActionBar, MultiBarBottomLeft, MultiBarBottomRight, StanceBar, PetActionBar, PossessActionBar, MainMenuBarVehicleLeaveButton }
	local offsetX = 0
	local offsetY = MAIN_ACTION_BAR_DEFAULT_OFFSET_Y
	if OverrideActionBar and OverrideActionBar:IsShown() then
		local xpBarHeight = OverrideActionBar.xpBar:IsShown() and OverrideActionBar.xpBar:GetHeight() or 0
		offsetY = OverrideActionBar:GetHeight() + xpBarHeight + 10
	end
	local topMostBar = nil
	local layoutInfo = EditModeManagerFrame:GetActiveLayoutInfo()
	local isPresetLayout = layoutInfo.layoutType == Enum.EditModeLayoutType.Preset
	local isOverrideLayout = layoutInfo.layoutType == Enum.EditModeLayoutType.Override
	for index, bar in ipairs(barsToUpdate) do
		if bar and bar:IsShown() and bar:IsInDefaultPosition() then
			if (bar ~= MainMenuBarVehicleLeaveButton) then	-- exception for 'MainMenuBarVehicleLeaveButton', its position is controlled with a custom function
				bar:ClearAllPoints()
				if bar.useDefaultAnchors and isPresetLayout then
					local anchorInfo = EditModePresetLayoutManager:GetPresetLayoutSystemAnchorInfo(layoutInfo.layoutIndex, bar.system, bar.systemIndex)
					bar:SetPoint(anchorInfo.point, anchorInfo.relativeTo, anchorInfo.relativePoint, anchorInfo.offsetX, anchorInfo.offsetY)
				elseif bar.useDefaultAnchors and isOverrideLayout then
					local anchorInfo = EditModePresetLayoutManager:GetOverrideLayoutSystemAnchorInfo(layoutInfo.layoutIndex, bar.system, bar.systemIndex)
					bar:SetPoint(anchorInfo.point, anchorInfo.relativeTo, anchorInfo.relativePoint, anchorInfo.offsetX, anchorInfo.offsetY)
				else
					if not topMostBar then
						offsetX = -bar:GetWidth() / 2
					end
					local topBarHeight = topMostBar and topMostBar:GetHeight() + 5 or 0
					offsetY = offsetY + topBarHeight
					bar:ClearAllPoints()
					bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", offsetX, offsetY)
					topMostBar = bar
				end
			else
				ClassicUI.MainMenuBarVehicleLeaveButton_Relocate(MainMenuBarVehicleLeaveButton)
			end
		end
	end
end

-- Function to ReLayout all main frames to adjust its size and position, avoiding the issue that sometimes happens that causes them to fill the entire screen
function ClassicUI:ReLayoutMainFrames()
	if InCombatLockdown() then
		delayFunc_ReLayoutMainFrames = true
		if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
			fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		return
	end
	ClassicUI:ModifyOriginalFrames()
	ClassicUI:ReloadMainFramesSettings()
	local rightAnchor = (EditModeUtil ~= nil) and EditModeUtil:GetRightContainerAnchor() or nil
	if (rightAnchor and UIParentRightManagedFrameContainer) then
		rightAnchor:SetPoint(UIParentRightManagedFrameContainer, true)
	end
end

-- Function that retrieves the number of visible bars. It can negatively affect performance, so it is advisable to use a cached value when possible and avoid multiple unnecessary calls to this function
function ClassicUI:GetNumberVisibleBars()
	local numVisBars = 0
	for _, bar in ipairs(ClassicUI.STBMMainBars) do
		if (bar:ShouldBeVisible()) then
			numVisBars = numVisBars + 1
		end
	end
	return mathmin(2, numVisBars)
end

-- Function to update the cached number of visible bars
ClassicUI.UpdateCacheVisibleBars = function(self)
	if (GetTime() > ClassicUI.cached_UpdateCacheVisibleBarsFunc_Timestamp) then
		ClassicUI.cached_UpdateCacheVisibleBarsFunc_Timestamp = GetTime()
		ClassicUI.cached_NumberVisibleBars = ClassicUI:GetNumberVisibleBars()
		ClassicUI.cached_NumberRealVisibleBars = ClassicUI.cached_NumberVisibleBars
		if (ClassicUI.cached_NumberVisibleBars == 2) then
			-- Show/Hide the DoubleStatusBar
			if (ClassicUI.cached_DoubleStatusBar_hide) then
				local hideDoubleStatusBar = false
				local barsShown = {}
				for _, v in pairs(ClassicUI.STBMMainBars) do
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
				if (hideDoubleStatusBar) then
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
		elseif (ClassicUI.cached_NumberVisibleBars == 1) then
			-- Show/Hide the SingleStatusBar
			if (ClassicUI.cached_SingleStatusBar_hide) then
				local hideSingleStatusBar = false
				local barsShown = {}
				for _, v in pairs(ClassicUI.STBMMainBars) do
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
				if (hideSingleStatusBar) then
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
		if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
			if not(CUI_MainMenuBarMaxLevelBar:IsShown()) then
				CUI_MainMenuBarMaxLevelBar:Show()
			end
		else
			if (CUI_MainMenuBarMaxLevelBar:IsShown()) then
				CUI_MainMenuBarMaxLevelBar:Hide()
			end
		end
	end
end

-- Function that keeps the old restored status bars
ClassicUI.StatusTrackingBarManager_LayoutBar = function(self, bar, isTopBar)
	-- Seems that this function does not need protection (InCombatLockdown)

	if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]

	-- Update the cached number of visible bars
	ClassicUI.UpdateCacheVisibleBars(self)

	bar.StatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar", "BORDER")
	bar.StatusBar:GetStatusBarTexture():SetDrawLayer("BORDER", 0)
	bar.StatusBar:GetStatusBarTexture():SetTexCoord(0, 0, 0, 1, 0.16666667, 0, 0.16666667, 1)

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
		bar.OverlayFrame:SetShown(not(overlayHide))
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
		bar.OverlayFrame:SetShown(not(overlayHide))
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
	-- Update the cached number of visible bars
	ClassicUI.UpdateCacheVisibleBars(StatusTrackingBarManager)

	if InCombatLockdown() then
		delayFunc_UpdatedStatusBarsEvent = true
		if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
			fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		return
	end

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
		if self.databaseCleaned then return end	-- [DB Integrity Check]
		CUI_MainMenuBar.ActionBarPageNumber:SetScale(1)
		if (self.db.profile.extraFrames.Minimap.enabled) then
			MinimapCluster:ClearAllPoints()
			MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", self.db.profile.extraFrames.Minimap.xOffset, self.db.profile.extraFrames.Minimap.yOffset)
		end
		if not(PetBattleFrame.BottomFrame.MicroButtonFrame:IsVisible()) and (ActionBarController_GetCurrentActionBarState() ~= LE_ACTIONBAR_STATE_OVERRIDE) then
			self.UpdateMicroButtonsParent(CUI_MainMenuBarArtFrame)
			self.MoveMicroButtons("BOTTOMLEFT", CUI_MainMenuBarArtFrame, "BOTTOMLEFT", 556 + self.db.profile.barsConfig.MicroButtons.xOffset, 2 + self.db.profile.barsConfig.MicroButtons.yOffset, false)
		end
		self.SetPointsMicroButtons()
		for k, _ in pairs(self.MicroButtonsGroup) do
			k:SetScale(self.mbIsStacked and 1 or self.db.profile.barsConfig.MicroButtons.scale)
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
		self.MainMenuBarVehicleLeaveButton_Relocate(MainMenuBarVehicleLeaveButton)

		CUI_MainMenuBar.oldOrigScale = nil
		CUI_MultiBarBottomLeft.oldOrigScale = nil
		CUI_MultiBarBottomRight.oldOrigScale = nil
		CUI_MultiBarRight.oldOrigScale = nil
		CUI_MultiBarLeft.oldOrigScale = nil
		CUI_PetActionBarFrame.oldOrigScale = nil
		CUI_PossessBarFrame.oldOrigScale = nil
		CUI_StanceBarFrame.oldOrigScale = nil

		CUI_MainMenuBar.hook_SetScale(MainActionBar, MainActionBar:GetScale())
		CUI_MultiBarBottomLeft.hook_SetScale(MultiBarBottomLeft, MultiBarBottomLeft:GetScale())
		CUI_MultiBarBottomRight.hook_SetScale(MultiBarBottomRight, MultiBarBottomRight:GetScale())
		CUI_MultiBarRight.hook_SetScale(MultiBarRight, MultiBarRight:GetScale())
		CUI_MultiBarLeft.hook_SetScale(MultiBarLeft, MultiBarLeft:GetScale())
		CUI_PetActionBarFrame.hook_SetScale(PetActionBar, PetActionBar:GetScale())
		CUI_PossessBarFrame.hook_SetScale(PossessActionBar, PossessActionBar:GetScale())
		CUI_StanceBarFrame.hook_SetScale(StanceBar, StanceBar:GetScale())
	end
end

-- Function that updates the quality of bag items and tries again if fails (the 'GetInventoryItemQuality' function loads asynchronously, so it can return 'nil')
function ClassicUI:TrySetBagItemButtonQuality(button, bagQuality, itemIDOrLink, suppressOverlays, isBound)
	if (button ~= nil) then
		if (bagQuality == nil) then
			bagQuality = GetInventoryItemQuality("player", button:GetID())
		end
		if (itemIDOrLink == nil) then
			itemIDOrLink = GetInventoryItemID("player", button:GetID())
		end
		if (suppressOverlays == nil) then
			suppressOverlays = button.HasPaperDollAzeriteItemOverlay
		end
		if (bagQuality ~= nil) then
			ItemButtonMixin.SetItemButtonQuality(button, bagQuality, itemIDOrLink, suppressOverlays, isBound)
		elseif (itemIDOrLink ~= nil) then
			local func = self.UpdateBagItemButtonQualityFuncCache[button]
			if not func then
				func = function() ClassicUI:TrySetBagItemButtonQuality(button) end
				self.UpdateBagItemButtonQualityFuncCache[button] = func
			end
			C_Timer.After(4, func)
		end
	end
end

-- Function to get the offset points for the CUI placement of the AddonCompartmentFrame frame
function ClassicUI:GetCUIOffsetsAddonCompartmentFrame()
	local xCUIACFExtraOffset = 0
	local yCUIACFExtraOffset = 0
	if (ClassicUI.db.profile.extraFrames.Minimap.minimapArrangementType == 1) then
		if (ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize == 50) then
			xCUIACFExtraOffset = 2
			yCUIACFExtraOffset = -3
		else
			xCUIACFExtraOffset = -2
			yCUIACFExtraOffset = -3
		end
	elseif (ClassicUI.db.profile.extraFrames.Minimap.minimapArrangementType == 2) then
		if (ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize == 50) then
			xCUIACFExtraOffset = 14
			yCUIACFExtraOffset = 12
		else
			xCUIACFExtraOffset = 6
			yCUIACFExtraOffset = 11
		end
	else
		if (ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize == 50) then
			xCUIACFExtraOffset = 3
			yCUIACFExtraOffset = 1
		end
	end
	return xCUIACFExtraOffset, yCUIACFExtraOffset
end

-- Function to set the position of the AddonCompartmentFrame frame
function ClassicUI:RepositionAddonCompartmentFrame()
	local xCUIACFExtraOffset, yCUIACFExtraOffset = ClassicUI:GetCUIOffsetsAddonCompartmentFrame()
	AddonCompartmentFrame:ClearAllPoints()
	AddonCompartmentFrame:SetPoint("TOPRIGHT", GameTimeFrame, "TOPLEFT", 5 + xCUIACFExtraOffset + ClassicUI.db.profile.extraFrames.Minimap.xOffsetAddonCompartment, 0 + yCUIACFExtraOffset + ClassicUI.db.profile.extraFrames.Minimap.yOffsetAddonCompartment)
end

-- Function that performs all the necessary modifications in the interface to bring back the old Minimap
function ClassicUI:EnableOldMinimap()
	if (self.OldMinimapLoaded) then return end
	MinimapCluster:SetSize(192, 192)
	MinimapCluster:SetHitRectInsets(30, 10, 0, 30)
	MinimapCluster:SetScale(self.db.profile.extraFrames.Minimap.scale)
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", self.db.profile.extraFrames.Minimap.xOffset, self.db.profile.extraFrames.Minimap.yOffset)
	Minimap:SetParent(MinimapCluster)
	Minimap:SetSize(140, 140)
	Minimap:ClearAllPoints()
	Minimap:SetPoint("CENTER", MinimapCluster, "TOP", 9, -92)
	MinimapBackdrop:ClearAllPoints()
	MinimapBackdrop:SetPoint("CENTER", MinimapCluster, "CENTER", 0, -20)
	MinimapBackdrop:SetSize(192,192)
	MinimapBackdrop:CreateTexture("MinimapBorder", "ARTWORK")
	MinimapBackdrop.StaticOverlayTexture:ClearAllPoints()
	MinimapBackdrop.StaticOverlayTexture:SetPoint("CENTER", MinimapBackdrop, "CENTER",8, 23)
	MinimapBackdrop.StaticOverlayTexture:SetSize(135, 135)
	MinimapBackdrop.StaticOverlayTexture:SetDrawLayer("ARTWORK", -1)
	MinimapBackdrop.StaticOverlayTexture:SetTexCoord(0.056, 0.935, 0.084, 0.921)
	MinimapBorder:ClearAllPoints()
	MinimapBorder:SetAllPoints(MinimapBackdrop)
	MinimapBorder:SetTexture("Interface\\Minimap\\UI-Minimap-Border")
	MinimapBorder:SetDrawLayer("ARTWORK", 0)
	MinimapBorder:SetTexCoord(0.25, 0.125, 0.25, 0.875, 1, 0.125, 1, 0.875)
	MinimapCompassTexture:ClearAllPoints()
	MinimapCompassTexture:SetPoint("CENTER", Minimap, "CENTER", -2, 0)
	MinimapCompassTexture:SetTexture("Interface\\Minimap\\CompassRing")
	MinimapCompassTexture:SetSize(256, 256)	-- 365x365 scaled 0.7 = 255.5x255.5
	MinimapCompassTexture:SetDrawLayer("OVERLAY", 0)
	MinimapBackdrop:CreateTexture("MinimapNorthTag")
	MinimapNorthTag:ClearAllPoints()
	MinimapNorthTag:SetPoint("CENTER", Minimap, "CENTER", 0, 67)
	MinimapNorthTag:SetTexture("Interface\\Minimap\\CompassNorthTag")
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
	hooksecurefunc(MinimapCluster, "ApplySystemAnchor", function(self)
		self:ClearAllPoints()
		self:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", ClassicUI.cached_db_profile.extraFrames_Minimap_xOffset, ClassicUI.cached_db_profile.extraFrames_Minimap_yOffset)	-- cached db value
	end)
	hooksecurefunc(MinimapCluster, "Layout", function(self, headerUnderneath)
		self:SetSize(192, 192)
		self:ClearAllPoints()
		self:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", ClassicUI.cached_db_profile.extraFrames_Minimap_xOffset, ClassicUI.cached_db_profile.extraFrames_Minimap_yOffset)	-- cached db value
	end)

	-- Make ClassicUI compatible with 'Garrison Order Hall Report' addon
	local GarrisonOrderHallReport = LibStub ~= nil and LibStub("AceAddon-3.0"):GetAddon("GarrisonOrderHallReport", true)
	if (not(ClassicUI.hooked_GarrisonOrderHallReportSetButtonLook) and GarrisonOrderHallReport ~= nil and GarrisonOrderHallReport.SetButtonLook ~= nil and type(GarrisonOrderHallReport.SetButtonLook) == "function") then
		hooksecurefunc(GarrisonOrderHallReport, "SetButtonLook", function()
			ExpansionLandingPageMinimapButton:ClearAllPoints()
			if (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "dragonflight-landingbutton-up") then
				ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 4 + 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetExpansionLandingPage, -105 - 6 - 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetExpansionLandingPage)	-- cached db value
				if (ClassicUI.elpmbSizes.dragonflight.w == 0 or ClassicUI.elpmbSizes.dragonflight.h == 0) then
					ClassicUI.elpmbSizes.dragonflight.w = ExpansionLandingPageMinimapButton:GetWidth()
					ClassicUI.elpmbSizes.dragonflight.h = ExpansionLandingPageMinimapButton:GetHeight()
				end
				ExpansionLandingPageMinimapButton:SetSize(mathfloor(ClassicUI.elpmbSizes.dragonflight.w * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageDragonflight + 0.5), mathfloor(ClassicUI.elpmbSizes.dragonflight.h * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageDragonflight + 0.5))	-- cached db value
			elseif (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "warwithin-landingbutton-up") then
				ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 4 + 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetExpansionLandingPage, -105 - 6 - 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetExpansionLandingPage)	-- cached db value
				if (ClassicUI.elpmbSizes.warwithin.w == 0 or ClassicUI.elpmbSizes.warwithin.h == 0) then
					ClassicUI.elpmbSizes.warwithin.w = ExpansionLandingPageMinimapButton:GetWidth()
					ClassicUI.elpmbSizes.warwithin.h = ExpansionLandingPageMinimapButton:GetHeight()
				end
				ExpansionLandingPageMinimapButton:SetSize(mathfloor(ClassicUI.elpmbSizes.warwithin.w * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageTheWarWithin + 0.5), mathfloor(ClassicUI.elpmbSizes.warwithin.h * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageTheWarWithin + 0.5))	-- cached db value
			else
				ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 6 + 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetExpansionLandingPage, -105 - 7 - 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetExpansionLandingPage)	-- cached db value
			end
		end)
		ClassicUI.hooked_GarrisonOrderHallReportSetButtonLook = true
	end
	hooksecurefunc(ExpansionLandingPageMinimapButton, "UpdateIconForGarrison", function(self)
		self:ClearAllPoints()
		if (self:GetNormalTexture():GetAtlas() == "dragonflight-landingbutton-up") then
			self:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 4 + 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetExpansionLandingPage, -105 - 6 - 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetExpansionLandingPage)	-- cached db value
			if (ClassicUI.elpmbSizes.dragonflight.w == 0 or ClassicUI.elpmbSizes.dragonflight.h == 0) then
				ClassicUI.elpmbSizes.dragonflight.w = self:GetWidth()
				ClassicUI.elpmbSizes.dragonflight.h = self:GetHeight()
			end
			self:SetSize(mathfloor(ClassicUI.elpmbSizes.dragonflight.w * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageDragonflight + 0.5), mathfloor(ClassicUI.elpmbSizes.dragonflight.h * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageDragonflight + 0.5))	-- cached db value
		elseif (self:GetNormalTexture():GetAtlas() == "warwithin-landingbutton-up") then
			self:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 4 + 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetExpansionLandingPage, -105 - 6 - 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetExpansionLandingPage)	-- cached db value
			if (ClassicUI.elpmbSizes.warwithin.w == 0 or ClassicUI.elpmbSizes.warwithin.h == 0) then
				ClassicUI.elpmbSizes.warwithin.w = self:GetWidth()
				ClassicUI.elpmbSizes.warwithin.h = self:GetHeight()
			end
			self:SetSize(mathfloor(ClassicUI.elpmbSizes.warwithin.w * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageTheWarWithin + 0.5), mathfloor(ClassicUI.elpmbSizes.warwithin.h * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageTheWarWithin + 0.5))	-- cached db value
		else
			self:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 6 + 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetExpansionLandingPage, -105 - 7 - 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetExpansionLandingPage)	-- cached db value
		end
	end)
	hooksecurefunc(ExpansionLandingPageMinimapButton, "UpdateIcon", function(self)
		if not(self.garrisonMode) then
			self:ClearAllPoints()
			if (self:GetNormalTexture():GetAtlas() == "dragonflight-landingbutton-up") then
				self:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 4 + 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetExpansionLandingPage, -105 - 6 - 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetExpansionLandingPage)	-- cached db value
				if (ClassicUI.elpmbSizes.dragonflight.w == 0 or ClassicUI.elpmbSizes.dragonflight.h == 0) then
					ClassicUI.elpmbSizes.dragonflight.w = self:GetWidth()
					ClassicUI.elpmbSizes.dragonflight.h = self:GetHeight()
				end
				self:SetSize(mathfloor(ClassicUI.elpmbSizes.dragonflight.w * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageDragonflight + 0.5), mathfloor(ClassicUI.elpmbSizes.dragonflight.h * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageDragonflight + 0.5))	-- cached db value
			elseif (self:GetNormalTexture():GetAtlas() == "warwithin-landingbutton-up") then
				self:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 4 + 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetExpansionLandingPage, -105 - 6 - 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetExpansionLandingPage)	-- cached db value
				if (ClassicUI.elpmbSizes.warwithin.w == 0 or ClassicUI.elpmbSizes.warwithin.h == 0) then
					ClassicUI.elpmbSizes.warwithin.w = self:GetWidth()
					ClassicUI.elpmbSizes.warwithin.h = self:GetHeight()
				end
				self:SetSize(mathfloor(ClassicUI.elpmbSizes.warwithin.w * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageTheWarWithin + 0.5), mathfloor(ClassicUI.elpmbSizes.warwithin.h * ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageTheWarWithin + 0.5))	-- cached db value
			else
				self:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 6 + 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetExpansionLandingPage, -105 - 7 - 26.5 + ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetExpansionLandingPage)	-- cached db value
			end
		end
	end)
	ExpansionLandingPageMinimapButton:ClearAllPoints()
	if (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "dragonflight-landingbutton-up") then
		ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 4 + 26.5 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetExpansionLandingPage, -105 - 6 - 26.5 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetExpansionLandingPage)
		ClassicUI.elpmbSizes.dragonflight.w = ExpansionLandingPageMinimapButton:GetWidth()
		ClassicUI.elpmbSizes.dragonflight.h = ExpansionLandingPageMinimapButton:GetHeight()
		ExpansionLandingPageMinimapButton:SetSize(mathfloor(ClassicUI.elpmbSizes.dragonflight.w * ClassicUI.db.profile.extraFrames.Minimap.scaleExpansionLandingPageDragonflight + 0.5), mathfloor(ClassicUI.elpmbSizes.dragonflight.h * ClassicUI.db.profile.extraFrames.Minimap.scaleExpansionLandingPageDragonflight + 0.5))
	elseif (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "warwithin-landingbutton-up") then
		ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 4 + 26.5 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetExpansionLandingPage, -105 - 6 - 26.5 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetExpansionLandingPage)
		ClassicUI.elpmbSizes.warwithin.w = ExpansionLandingPageMinimapButton:GetWidth()
		ClassicUI.elpmbSizes.warwithin.h = ExpansionLandingPageMinimapButton:GetHeight()
		ExpansionLandingPageMinimapButton:SetSize(mathfloor(ClassicUI.elpmbSizes.warwithin.w * ClassicUI.db.profile.extraFrames.Minimap.scaleExpansionLandingPageTheWarWithin + 0.5), mathfloor(ClassicUI.elpmbSizes.warwithin.h * ClassicUI.db.profile.extraFrames.Minimap.scaleExpansionLandingPageTheWarWithin + 0.5))
	else
		ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 6 + 26.5 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetExpansionLandingPage, -105 - 7 - 26.5 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetExpansionLandingPage)
	end

	local ldbi = LibStub ~= nil and LibStub:GetLibrary("LibDBIcon-1.0", true)
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
	--TimeManagerClockButton:SetHitRectInsets(8, 5, 3, 3)	-- is already the default value
	local TimeManagerClockButtonBackground = TimeManagerClockButton:CreateTexture("TimeManagerClockButtonBackground", "BORDER")
	TimeManagerClockButtonBackground:ClearAllPoints()
	TimeManagerClockButtonBackground:SetAllPoints(TimeManagerClockButton)
	TimeManagerClockTicker:ClearAllPoints()
	if (ClassicUI.db.profile.extraFrames.Minimap.useClassicTimeClock) then
		TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 1, 0)
		TimeManagerClockButtonBackground:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\ClockBackground-classic")
	else
		TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 3, 1)
		TimeManagerClockButtonBackground:SetTexture("Interface\\TimeManager\\ClockBackground")
	end
	TimeManagerClockButtonBackground:SetTexCoord(0.015625, 0.8125, 0.015625, 0.390625)
	TimeManagerClockButtonBackground:Show()

	GameTimeFrame:SetParent(MinimapCluster)
	GameTimeFrame:ClearAllPoints()
	if (ClassicUI.db.profile.extraFrames.Minimap.minimapArrangementType == 1) then
		GameTimeFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 4, -19)
	elseif (ClassicUI.db.profile.extraFrames.Minimap.minimapArrangementType == 2) then
		GameTimeFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 4, -37)
	else
		GameTimeFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 3, -24)
	end
	GameTimeFrame:SetHitRectInsets(6, 0, 5, 10)
	GameTimeFrame:SetFrameStrata("LOW")
	GameTimeFrame:SetFrameLevel(8)

	hooksecurefunc("GameTimeFrame_SetDate", function()
		GameTimeFrame:SetText(C_DateAndTime_GetCurrentCalendarTime().monthDay)
		GameTimeFrame:SetNormalTexture("Interface\\Calendar\\UI-Calendar-Button")
		GameTimeFrame:GetNormalTexture():SetTexCoord(0, 0, 0, 0.78125, 0.390625, 0, 0.390625, 0.78125)
		GameTimeFrame:SetPushedTexture("Interface\\Calendar\\UI-Calendar-Button")
		GameTimeFrame:GetPushedTexture():SetTexCoord(0.5, 0, 0.5, 0.78125, 0.890625, 0, 0.890625, 0.78125)
		GameTimeFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
		--GameTimeFrame:GetHighlightTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)	-- not needed
		GameTimeFrame:GetNormalTexture():SetDrawLayer("BACKGROUND")
		GameTimeFrame:GetPushedTexture():SetDrawLayer("BACKGROUND")
		GameTimeFrame:GetFontString():SetDrawLayer("BACKGROUND")
	end)
	GameTimeFrame:SetNormalTexture("Interface\\Calendar\\UI-Calendar-Button")
	GameTimeFrame:GetNormalTexture():SetTexCoord(0, 0, 0, 0.78125, 0.390625, 0, 0.390625, 0.78125)
	GameTimeFrame:SetPushedTexture("Interface\\Calendar\\UI-Calendar-Button")
	GameTimeFrame:GetPushedTexture():SetTexCoord(0.5, 0, 0.5, 0.78125, 0.890625, 0, 0.890625, 0.78125)
	GameTimeFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
	--GameTimeFrame:GetHighlightTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)	-- not needed
	GameTimeFrame:SetNormalFontObject("GameFontBlack")
	GameTimeFrame:SetFontString(GameTimeFrame:CreateFontString(nil, "BACKGROUND", "GameFontBlack"))
	GameTimeFrame:GetFontString():ClearAllPoints()
	GameTimeFrame:GetFontString():SetPoint("CENTER", GameTimeFrame, "CENTER", -1, -1)
	GameTimeFrame:GetNormalTexture():SetDrawLayer("BACKGROUND")
	GameTimeFrame:GetPushedTexture():SetDrawLayer("BACKGROUND")
	GameTimeFrame:GetFontString():SetDrawLayer("BACKGROUND")
	GameTimeFrame:SetText(C_DateAndTime_GetCurrentCalendarTime().monthDay)
	if (ClassicUI.db.profile.extraFrames.Minimap.calendarIconType == 1) then
		GameTimeTexture:Show()
		GameTimeFrame:GetNormalTexture():SetAlpha(0)
	end
	if (ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize == 40) then
		GameTimeFrame:SetSize(40, 40)
	elseif (ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize == 50) then
		GameTimeFrame:SetSize(50, 50)
		GameTimeFrame:GetFontString():SetScale(1.25)
	elseif (type(ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize)=="number") then
		GameTimeFrame:SetSize(ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize, ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize)
		GameTimeFrame:GetFontString():SetScale(ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize / 40)
	else
		GameTimeFrame:SetSize(40, 40)
	end

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
	if (ClassicUI.db.profile.extraFrames.Minimap.zoomButtonsPositions == 1) then
		Minimap.ZoomIn:SetPoint("CENTER", MinimapBackdrop, "CENTER", 77, -13)
	elseif (ClassicUI.db.profile.extraFrames.Minimap.zoomButtonsPositions == 2) then
		Minimap.ZoomIn:SetPoint("CENTER", MinimapBackdrop, "CENTER", 71, -20)
	else
		Minimap.ZoomIn:SetPoint("CENTER", MinimapBackdrop, "CENTER", 72, -25)
	end
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
	if (ClassicUI.db.profile.extraFrames.Minimap.zoomButtonsPositions == 1) then
		Minimap.ZoomOut:SetPoint("CENTER", MinimapBackdrop, "CENTER", 51, -41)
	elseif (ClassicUI.db.profile.extraFrames.Minimap.zoomButtonsPositions == 2) then
		Minimap.ZoomOut:SetPoint("CENTER", MinimapBackdrop, "CENTER", 51, -39)
	else
		Minimap.ZoomOut:SetPoint("CENTER", MinimapBackdrop, "CENTER", 50, -43)
	end
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

	MinimapCluster.IndicatorFrame:SetParent(MinimapCluster)
	MinimapCluster.IndicatorFrame:ClearAllPoints()
	if (ClassicUI.db.profile.extraFrames.Minimap.minimapArrangementType == 2) then
		MinimapCluster.IndicatorFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 7, -74)
	else
		MinimapCluster.IndicatorFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 7, -59)
	end
	MinimapCluster.IndicatorFrame:SetSize(33, 33)
	MinimapCluster.IndicatorFrame:SetFrameStrata("LOW")
	MinimapCluster.IndicatorFrame:SetFrameLevel(4)

	MinimapCluster.IndicatorFrame.MailFrame:ClearAllPoints()
	MinimapCluster.IndicatorFrame.MailFrame:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame, "TOPLEFT", 0, 0)
	MinimapCluster.IndicatorFrame.MailFrame:SetSize(33, 33)
	MinimapCluster.IndicatorFrame.MailFrame:SetFrameStrata("LOW")

	MinimapCluster.IndicatorFrame.CraftingOrderFrame:ClearAllPoints()
	MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame, "TOPLEFT", 0, 0)
	MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetSize(33, 33)
	MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetFrameStrata("LOW")

	if (ClassicUI.db.profile.extraFrames.Minimap.mailIconPriority == 1) then
		MinimapCluster.IndicatorFrame.MailFrame:SetFrameLevel(6)
		MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetFrameLevel(5)
	else
		MinimapCluster.IndicatorFrame.MailFrame:SetFrameLevel(5)
		MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetFrameLevel(6)
	end

	hooksecurefunc("MiniMapIndicatorFrame_UpdatePosition", function()
		MinimapCluster.IndicatorFrame:ClearAllPoints()
		if (ClassicUI.cached_db_profile.extraFrames_Minimap_minimapArrangementType == 2) then	-- cached db value
			MinimapCluster.IndicatorFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 7, -74)
		else
			MinimapCluster.IndicatorFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 7, -59)
		end
	end)
	hooksecurefunc(MinimapCluster.IndicatorFrame, "Layout", function(self)
		MinimapCluster.IndicatorFrame:SetSize(33, 33)
		MinimapCluster.IndicatorFrame.MailFrame:ClearAllPoints()
		MinimapCluster.IndicatorFrame.MailFrame:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame, "TOPLEFT", 0, 0)
		MinimapCluster.IndicatorFrame.CraftingOrderFrame:ClearAllPoints()
		MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame, "TOPLEFT", 0, 0)
	end)

	MiniMapMailIcon:ClearAllPoints()
	MiniMapMailIcon:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame.MailFrame, "TOPLEFT", 7, -6)
	MiniMapMailIcon:SetTexture("Interface\\Icons\\INV_Letter_15")
	MiniMapMailIcon:SetSize(18, 18)
	MiniMapMailIcon:SetDrawLayer("ARTWORK", 0)

	MiniMapCraftingOrderIcon:ClearAllPoints()
	MiniMapCraftingOrderIcon:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame.CraftingOrderFrame, "TOPLEFT", 7, -6)
	MiniMapCraftingOrderIcon:SetTexture("Interface\\Icons\\INV_Hammer_12")
	MiniMapCraftingOrderIcon:SetSize(18, 18)
	MiniMapCraftingOrderIcon:SetDrawLayer("ARTWORK", 0)

	MinimapCluster.IndicatorFrame.MailFrame:CreateTexture("MiniMapMailBorder", "OVERLAY")
	MiniMapMailBorder:ClearAllPoints()
	MiniMapMailBorder:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame.MailFrame, "TOPLEFT", 0, 0)
	MiniMapMailBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\MiniMap-TrackingBorder")
	MiniMapMailBorder:SetSize(52, 52)
	MiniMapMailBorder:SetDrawLayer("OVERLAY", 0)

	MinimapCluster.IndicatorFrame.CraftingOrderFrame:CreateTexture("MiniMapMailBorder2", "OVERLAY")
	MiniMapMailBorder2:ClearAllPoints()
	MiniMapMailBorder2:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame.CraftingOrderFrame, "TOPLEFT", 0, 0)
	MiniMapMailBorder2:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\MiniMap-TrackingBorder")
	MiniMapMailBorder2:SetSize(52, 52)
	MiniMapMailBorder2:SetDrawLayer("OVERLAY", 0)

	MinimapCluster.IndicatorFrame.MailFrame.MailReminderAnim:HookScript("OnPlay", function()
		MiniMapMailIcon:Show()
	end)
	MinimapCluster.IndicatorFrame.MailFrame.MailReminderAnim:HookScript("OnFinished", function()
		MiniMapMailIcon:Show()
	end)
	MinimapCluster.IndicatorFrame.MailFrame.NewMailAnim:HookScript("OnPlay", function()
		MiniMapMailIcon:Show()
	end)
	MinimapCluster.IndicatorFrame.MailFrame.NewMailAnim:HookScript("OnFinished", function()
		MiniMapMailIcon:Show()
	end)
	hooksecurefunc(MinimapCluster.IndicatorFrame.MailFrame, "ResetMailIcon", function(self)
		self.MailIcon:Show()
	end)

	hooksecurefunc(AddonCompartmentFrame, "UpdateDisplay", function(self)
		if (ClassicUI.cached_db_profile.extraFrames_Minimap_hideAddonCompartment) then	-- cached db value
			if (self:IsShown()) then
				self:Hide()
			end
		end
	end)
	if (self.db.profile.extraFrames.Minimap.hideAddonCompartment) then
		AddonCompartmentFrame:Hide()
	end
	ClassicUI:RepositionAddonCompartmentFrame()
	AddonCompartmentFrame:SetFrameStrata("LOW")
	AddonCompartmentFrame:SetFrameLevel(4)
	AddonCompartmentFrame:SetScale(self.db.profile.extraFrames.Minimap.scaleAddonCompartment)

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
	CUI_GuildInstanceDifficultyBorder:SetPoint("TOPLEFT", CUI_GuildInstanceDifficulty, "TOPLEFT", 0, 0)
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
	CUI_MiniMapChallengeModeTexture:SetSize(64, 64)
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
		if (self.isGuildGroup) then
			if (instanceGroupSize == 0) then
				CUI_GuildInstanceDifficultyText:SetText("")
				CUI_GuildInstanceDifficultyDarkBackground:SetAlpha(0)
				CUI_GuildInstanceDifficulty.emblem:SetPoint("TOPLEFT", 12, -16)
			else
				CUI_GuildInstanceDifficultyText:SetText(instanceGroupSize)
				CUI_GuildInstanceDifficultyDarkBackground:SetAlpha(0.7)
				CUI_GuildInstanceDifficulty.emblem:SetPoint("TOPLEFT", 12, -10)
			end
			CUI_GuildInstanceDifficultyText:ClearAllPoints()
			if (isHeroic or isChallengeMode or displayMythic or displayHeroic) then
				local symbolTexture
				if (isChallengeMode) then
					symbolTexture = CUI_GuildInstanceDifficultyChallengeModeTexture
					CUI_GuildInstanceDifficultyHeroicTexture:Hide()
					CUI_GuildInstanceDifficultyMythicTexture:Hide()
				elseif (displayMythic) then
					symbolTexture = CUI_GuildInstanceDifficultyMythicTexture
					CUI_GuildInstanceDifficultyHeroicTexture:Hide()
					CUI_GuildInstanceDifficultyChallengeModeTexture:Hide()
				else
					symbolTexture = CUI_GuildInstanceDifficultyHeroicTexture
					CUI_GuildInstanceDifficultyChallengeModeTexture:Hide()
					CUI_GuildInstanceDifficultyMythicTexture:Hide()
				end
				if (instanceGroupSize < 10) then
					symbolTexture:SetPoint("BOTTOMLEFT", 11, 7)
					CUI_GuildInstanceDifficultyText:SetPoint("BOTTOMLEFT", 23, 8)
				elseif (instanceGroupSize > 19) then
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
		elseif (isChallengeMode) then
			CUI_MiniMapChallengeMode:Show()
			self:Hide()
			CUI_GuildInstanceDifficulty:Hide()
		elseif (instanceType == "raid" or isHeroic or displayMythic or displayHeroic) then
			CUI_MiniMapInstanceDifficultyText:SetText(instanceGroupSize)
			local xOffset = 0
			if (instanceGroupSize >= 10 and instanceGroupSize <= 19) then
				xOffset = -1
			end
			if (displayMythic) then
				CUI_MiniMapInstanceDifficultyTexture:SetTexCoord(0.25, 0.5, 0.0703125, 0.4296875)
				CUI_MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, -9)
			elseif (isHeroic or displayHeroic) then
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
		if (event == "GUILD_PARTY_STATE_UPDATED") then
			local isGuildGroup = ...
			if (isGuildGroup ~= self.isGuildGroup) then
				self.isGuildGroup = isGuildGroup
				self:MiniMapInstanceDifficulty_Update()
			end
		elseif (event == "PLAYER_DIFFICULTY_CHANGED") then
			self:MiniMapInstanceDifficulty_Update()
		elseif (event == "UPDATE_INSTANCE_INFO" or event == "INSTANCE_GROUP_SIZE_CHANGED") then
			self:MiniMapInstanceDifficulty_Update()
		elseif (event == "PLAYER_GUILD_UPDATE") then
			local tabard = CUI_GuildInstanceDifficulty
			SetSmallGuildTabardTextures("player", tabard.emblem, tabard.background, tabard.border)
			if not(IsInGuild()) then
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

	CUI_MiniMapInstanceDifficulty:MiniMapInstanceDifficulty_Update()
	C_Timer.After(0.1, function() RequestGuildPartyState() end)

	CUI_GuildInstanceDifficulty:SetScript("OnEnter", function(self)
		local guildName = GetGuildInfo("player")
		local _, instanceType, _, _, maxPlayers = GetInstanceInfo()
		local _, numGuildPresent, numGuildRequired, xpMultiplier = InGuildParty()
		if (instanceType == "arena") then
			maxPlayers = numGuildRequired
		end
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", 8, 8)
		GameTooltip:SetText(GUILD_GROUP, 1, 1, 1)
		if (xpMultiplier < 1) then
			GameTooltip:AddLine(strformat(GUILD_ACHIEVEMENTS_ELIGIBLE_MINXP, numGuildRequired, maxPlayers, guildName, xpMultiplier * 100), nil, nil, nil, true)
		elseif (xpMultiplier > 1) then
			GameTooltip:AddLine(strformat(GUILD_ACHIEVEMENTS_ELIGIBLE_MAXXP, guildName, xpMultiplier * 100), nil, nil, nil, true)
		else
			if (instanceType == "party" and maxPlayers == 5) then
				numGuildRequired = 4
			end
			GameTooltip:AddLine(strformat(GUILD_ACHIEVEMENTS_ELIGIBLE, numGuildRequired, maxPlayers, guildName), nil, nil, nil, true)
		end
		GameTooltip:Show()
	end)
	CUI_GuildInstanceDifficulty:SetScript("OnLeave", GameTooltip_Hide)

	hooksecurefunc(MinimapCluster, "SetHeaderUnderneath", function(self, headerUnderneath)
		self.MinimapContainer.Minimap:ClearAllPoints()
		self.MinimapContainer.Minimap:SetPoint("CENTER", self, "TOP", 9, -92)
		self.BorderTop:ClearAllPoints()
		self.BorderTop:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
		self.IndicatorFrame:ClearAllPoints()
		if (ClassicUI.cached_db_profile.extraFrames_Minimap_minimapArrangementType == 2) then	-- cached db value
			self.IndicatorFrame:SetPoint("TOPRIGHT", self, "TOPRIGHT", 7, -74)
		else
			self.IndicatorFrame:SetPoint("TOPRIGHT", self, "TOPRIGHT", 7, -59)
		end
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
	MinimapBorderTop:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", self.db.profile.extraFrames.Minimap.xOffset, self.db.profile.extraFrames.Minimap.yOffset)
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
				GameTooltip:AddLine(subzoneName, 1.0, 0.1, 0.1)
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
		local pvpType, _, factionName = C_PvP.GetZonePVPInfo()
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

	self.OldMinimapLoaded = true
end

-- Function that executes functionalities of the 'MainFunction' function that need to be executed after the first "PLAYER_ENTERING_WORLD" event
function ClassicUI:MF_PLAYER_ENTERING_WORLD()
	if InCombatLockdown() then
		delayFunc_MF_PLAYER_ENTERING_WORLD = true
		if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
			fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		return
	end

	-- Update the cached number of visible bars (pre update)
	ClassicUI.cached_NumberVisibleBars = ClassicUI:GetNumberVisibleBars()
	ClassicUI.cached_NumberRealVisibleBars = ClassicUI.cached_NumberVisibleBars

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
	local CUI_MainMenuBar = CreateFrame("Frame", "CUI_MainMenuBar", MainActionBar)
	function CUI_MainMenuBar:InitButtons()
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
		for i = 2, ClassicUI.NUM_ACTIONBAR_BUTTONS do
			local iActionButton = _G["ActionButton"..i]
			iActionButton:ClearAllPoints()
			iActionButton:SetPoint("LEFT", prevActionButton, "RIGHT", 6, 0)
			prevActionButton = iActionButton
		end
	end
	function CUI_MainMenuBar:RelocateBar()
		CUI_MainMenuBar:ClearAllPoints()
		CUI_MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0 + ClassicUI.cached_db_profile.barsConfig_MainMenuBar_xOffset, 0 + ClassicUI.cached_db_profile.barsConfig_MainMenuBar_yOffset)	-- cached db value
	end
	CUI_MainMenuBar:RelocateBar()
	CUI_MainMenuBar:SetSize(1024, 53)
	CUI_MainMenuBar:SetFrameStrata("MEDIUM")
	CUI_MainMenuBar:SetFrameLevel(1)
	CUI_MainMenuBar:EnableMouse(true)
	CUI_MainMenuBar:SetAlpha(1)
	CUI_MainMenuBar:Show()
	CUI_MainMenuBar.actionButtons = { }
	CUI_MainMenuBar.hook_SetScale = function(self, scale)
		if (CUI_MainMenuBar.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_MainMenuBar_scale / scale	-- cached db value
			if (mathabs(CUI_MainMenuBar:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_MainMenuBar] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_MainMenuBar] = { self, scale }
					else
						ClassicUI.queuePending_HookSetScale[CUI_MainMenuBar][2] = scale
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_MainMenuBar:SetScale(newMainScale)
				CUI_MainMenuBar.oldOrigScale = scale
				for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
					local iActionButton = _G["ActionButton"..i]
					if (iActionButton ~= nil) then
						iActionButton:SetScale(ClassicUI.cached_db_profile.barsConfig_MainMenuBar_scale / (iActionButton:GetParent():GetScale() * scale) * ClassicUI.cached_ActionButtonInfo.currentScale[iActionButton])	-- cached db value
					end
				end
			end
		end
	end
	hooksecurefunc(MainActionBar, "SetScale", CUI_MainMenuBar.hook_SetScale)
	for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
		local iActionButton = _G["ActionButton"..i]
		if (iActionButton ~= nil) then
			CUI_MainMenuBar.actionButtons[iActionButton] = { }
			CUI_MainMenuBar.actionButtons[iActionButton].hook_SetScale = function(self, scale)
				local newMainScale = ClassicUI.cached_db_profile.barsConfig_MainMenuBar_scale / (scale * iActionButton.bar:GetScale()) * ClassicUI.cached_ActionButtonInfo.currentScale[iActionButton]	-- cached db value
				if (mathabs(iActionButton:GetScale()-newMainScale) > SCALE_EPSILON) then
					if InCombatLockdown() then
						if (ClassicUI.queuePending_HookSetScale[CUI_MainMenuBar.actionButtons[iActionButton]] == nil) then
							ClassicUI.queuePending_HookSetScale[CUI_MainMenuBar.actionButtons[iActionButton]] = { self, scale }
						else
							ClassicUI.queuePending_HookSetScale[CUI_MainMenuBar.actionButtons[iActionButton]][2] = scale
						end
						delayFunc_BarHookProtectedApplySetScale = true
						if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
							fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
						end
						return
					end
					iActionButton:SetScale(newMainScale)
				end
			end
			hooksecurefunc(iActionButton:GetParent(), "SetScale", CUI_MainMenuBar.actionButtons[iActionButton].hook_SetScale)
		end
	end

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
	CUI_MainMenuBar.ActionBarPageNumber	= MainActionBar.ActionBarPageNumber
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
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:Show()
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:ClearAllPoints()
	CUI_MainMenuBar.ActionBarPageNumber.UpButton:SetPoint("CENTER", CUI_MainMenuBarArtFrame, "TOPLEFT", 522, -22)
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:ClearAllPoints()
	CUI_MainMenuBar.ActionBarPageNumber.DownButton:SetPoint("CENTER", CUI_MainMenuBarArtFrame, "TOPLEFT", 522, -42)

	hooksecurefunc(MainActionBar, "EditModeSetScale", function(self, newScale)
		self.ActionBarPageNumber:SetScale(1)
	end)

	hooksecurefunc(MainActionBar, "UpdateSystemSettingHideBarScrolling", function(self)
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

	hooksecurefunc(SpellFlyout, "Toggle", function(self, flyoutButton, flyoutID, isActionBar, specID, showFullTooltip, reason)
		if (not(self:IsShown()) and self.glyphActivating) then
			return
		end
		if (not(self:IsShown()) and self.flyoutButton == nil) then
			return
		end
		local offSpec = specID and (specID ~= 0)
		local _, _, numSlots, isKnown = GetFlyoutInfo(flyoutID)
		if ((not isKnown and not offSpec) or numSlots == 0) then
			return
		end

		local direction = flyoutButton:GetPopupDirection()
		if (not direction) then
			direction = "UP"
		end

		local prevButton = nil
		local numButtons = 0
		for i = 1, numSlots do
			local spellID, _, isKnownSlot, _, slotSpecID = GetFlyoutSlotInfo(flyoutID, i)
			local visible = true
			local petIndex, petName = GetCallPetSpellInfo(spellID)
			if (isActionBar and petIndex and (not petName or petName == "")) then
				visible = false
			end
			if (((not offSpec or slotSpecID == 0) and visible and isKnownSlot) or (offSpec and slotSpecID == specID)) then
				local button = _G["SpellFlyoutPopupButton"..numButtons+1]
				if (button ~= nil) then
					if (button.icon ~= nil and button.icon:GetTexCoord() == 0) then
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
						if ClassicUI.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[button] == nil then
							ClassicUI.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[button] = false
						end
						if ClassicUI.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[button] == nil then
							ClassicUI.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[button] = false
						end
						if ClassicUI.cached_ActionButtonInfo.spellActivationAlertAdjusted[button] == nil then
							ClassicUI.cached_ActionButtonInfo.spellActivationAlertAdjusted[button] = false
						end
						if ClassicUI.cached_ActionButtonInfo.typeActionButton[button] == nil then
							ClassicUI.cached_ActionButtonInfo.typeActionButton[button] = 6
						end
						if ClassicUI.cached_ActionButtonInfo.currentScale[button] == nil then
							ClassicUI.cached_ActionButtonInfo.currentScale[button] = 1
						end
						if ClassicUI.cached_ActionButtonInfo.currLayout[button] == nil then
							ClassicUI.cached_ActionButtonInfo.currLayout[button] = 1
						end
						-- Apply the current layout to the new SpellFlyoutButton (delayed if combat lockdown)
						ClassicUI:ActionButtonProtectedApplyLayout(button, 6)
						-- GreyOnCooldown (extra option) hook for the new SpellFlyoutButton (only if GOC_HookGOCSpellFlyout is not being used)
						if (ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_enabled) then	-- cached db value
							if (GREYONCOOLDOWN_HOOKED == ClassicUI and not(GREYONCOOLDOWN_SPELLFLYOUT_HOOKED)) then
								ClassicUI:GOC_HookGOCActionButtonUpdate(button)
							end
						end
						-- Apply LossOfControlUI CC Remover (extra option) to the new SpellFlyoutButton
						if (ClassicUI.cached_db_profile.extraConfigs_LossOfControlUIConfig_enabled) then
							if (button.enableLOCCooldown) then
								button.enableLOCCooldown = nil
							end
						end
					end
					if not(prevButton) then
						-- Setting 'SpellFlyoutPopupButtonX' position is protected in combat. It is only a minor adjustment, so it is not necessary to delay it, we just skip it if we're in combat lockdown
						if not(InCombatLockdown()) or not(button:IsProtected()) then
							if (direction == "UP") then
								button:SetPoint("BOTTOM", 0, ClassicUI.SPELLFLYOUT_INITIAL_SPACING)
							elseif (direction == "DOWN") then
								button:SetPoint("TOP", 0, -ClassicUI.SPELLFLYOUT_INITIAL_SPACING)
							elseif (direction == "LEFT") then
								button:SetPoint("RIGHT", -ClassicUI.SPELLFLYOUT_INITIAL_SPACING, 0)
							elseif (direction == "RIGHT") then
								button:SetPoint("LEFT", ClassicUI.SPELLFLYOUT_INITIAL_SPACING, 0)
							end
						end
					end
				end
				prevButton = button
				numButtons = numButtons+1
			end
		end
		if (numButtons == 0) then
			return
		end

		self.Background.Start:Hide()
		--SetClampedTextureRotation(self.Background.VerticalMiddle, 0)	-- Calls to 'SetClampedTextureRotation' cause taints, so we set the coords manually
		self.Background.VerticalMiddle:SetTexCoord(0, 0.578125, 0, 1)
		--SetClampedTextureRotation(self.Background.HorizontalMiddle, 0)	-- Calls to 'SetClampedTextureRotation' cause taints, so we set the coords manually
		self.Background.HorizontalMiddle:SetTexCoord(0, 1, 0, 0.578125)

		self.Background.End:ClearAllPoints()
		if (direction == "UP") then
			self.Background.End:SetPoint("TOP", 0, 0)
			--SetClampedTextureRotation(self.Background.End, 0)	-- Calls to 'SetClampedTextureRotation' cause taints, so we set the coords manually
			self.Background.End:SetTexCoord(0.015625, 0.7421875, 0.015625, 0.9140625, 0.59375, 0.7421875, 0.59375, 0.9140625)
		elseif (direction == "LEFT") then
			self.Background.End:SetPoint("LEFT", 0, 0)
			--SetClampedTextureRotation(self.Background.End, 270)	-- Calls to 'SetClampedTextureRotation' cause taints, so we set the coords manually
			self.Background.End:SetTexCoord(0.59375, 0.7421875, 0.015625, 0.7421875, 0.59375, 0.9140625, 0.015625, 0.9140625)
		elseif (direction == "DOWN") then
			self.Background.End:SetPoint("BOTTOM", 0, 0)
			--SetClampedTextureRotation(self.Background.End, 180)	-- Calls to 'SetClampedTextureRotation' cause taints, so we set the coords manually
			self.Background.End:SetTexCoord(0.59375, 0.9140625, 0.59375, 0.7421875, 0.015625, 0.9140625, 0.015625, 0.7421875)
		elseif (direction == "RIGHT") then
			self.Background.End:SetPoint("RIGHT", 0, 0)
			--SetClampedTextureRotation(self.Background.End, 90)	-- Calls to 'SetClampedTextureRotation' cause taints, so we set the coords manually
			self.Background.End:SetTexCoord(0.015625, 0.9140625, 0.59375, 0.9140625, 0.015625, 0.7421875, 0.59375, 0.7421875)
		end
		-- Setting 'SpellFlyout' size is protected in combat. It is only a minor adjustment, so it is not necessary to delay it, we just skip it if we're in combat lockdown
		if ((not(InCombatLockdown()) or not(self:IsProtected())) and (prevButton ~= nil)) then
			if (direction == "UP" or direction == "DOWN") then
				self:SetWidth(prevButton:GetWidth())
				self:SetHeight((prevButton:GetHeight()+ClassicUI.SPELLFLYOUT_DEFAULT_SPACING) * numButtons - ClassicUI.SPELLFLYOUT_DEFAULT_SPACING + ClassicUI.SPELLFLYOUT_INITIAL_SPACING + ClassicUI.SPELLFLYOUT_FINAL_SPACING)
			else
				self:SetHeight(prevButton:GetHeight())
				self:SetWidth((prevButton:GetWidth()+ClassicUI.SPELLFLYOUT_DEFAULT_SPACING) * numButtons - ClassicUI.SPELLFLYOUT_DEFAULT_SPACING + ClassicUI.SPELLFLYOUT_INITIAL_SPACING + ClassicUI.SPELLFLYOUT_FINAL_SPACING)
			end
		end
		-- self:SetBorderSize(37)	-- 'SetBorderSize' function was removed, its functionality is recreated below
		local nsize = 37
		if (not(direction) or (direction == "UP") or (direction == "DOWN")) then
			self.Background.HorizontalMiddle:SetWidth(nsize)
			self.Background.VerticalMiddle:SetWidth(nsize)
			self.Background.End:SetWidth(nsize)
		else
			self.Background.HorizontalMiddle:SetHeight(nsize)
			self.Background.VerticalMiddle:SetHeight(nsize)
			self.Background.End:SetHeight(nsize)
		end
	end)

	-- [ActionBars] MultiBarBottomLeft
	local CUI_MultiBarBottomLeft = CreateFrame("Frame", "CUI_MultiBarBottomLeft", MultiBarBottomLeft)
	function CUI_MultiBarBottomLeft:RelocateBar()
		local yPos
		if not(ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_ignoreyOffsetStatusBar) then	-- cached db value
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = 12 + ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset	-- cached db value
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = 17 + ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset	-- cached db value
			else
				yPos = 26 + ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset	-- cached db value
			end
		else
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = 12 + ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset	-- cached db value
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = 12 + ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset1StatusBar	-- cached db value
			else
				yPos = 12 + ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset2StatusBar	-- cached db value
			end
		end
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_xOffset, yPos)	-- cached db value
	end
	function CUI_MultiBarBottomLeft:InitButtons()
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
		for i = 2, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
	CUI_MultiBarBottomLeft.actionButtons = { }
	CUI_MultiBarBottomLeft.hook_SetScale = function(self, scale)
		if (CUI_MultiBarBottomLeft.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_scale / scale	-- cached db value
			if (mathabs(CUI_MultiBarBottomLeft:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomLeft] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomLeft] = { self, scale }
					else
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomLeft][2] = scale
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_MultiBarBottomLeft:SetScale(newMainScale)
				CUI_MultiBarBottomLeft.oldOrigScale = scale
				for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
					local iMultiBarBottomLeftButton = _G["MultiBarBottomLeftButton"..i]
					if (iMultiBarBottomLeftButton ~= nil) then
						iMultiBarBottomLeftButton:SetScale(ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_scale / (iMultiBarBottomLeftButton:GetParent():GetScale() * scale) * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarBottomLeftButton])	-- cached db value
					end
				end
			end
		end
	end
	hooksecurefunc(MultiBarBottomLeft, "SetScale", CUI_MultiBarBottomLeft.hook_SetScale)
	for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
		local iMultiBarBottomLeftButton = _G["MultiBarBottomLeftButton"..i]
		if (iMultiBarBottomLeftButton ~= nil) then
			CUI_MultiBarBottomLeft.actionButtons[iMultiBarBottomLeftButton] = { }
			CUI_MultiBarBottomLeft.actionButtons[iMultiBarBottomLeftButton].hook_SetScale = function(self, scale)
				local newMainScale = ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_scale / (scale * iMultiBarBottomLeftButton.bar:GetScale()) * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarBottomLeftButton]	-- cached db value
				if (mathabs(iMultiBarBottomLeftButton:GetScale()-newMainScale) > SCALE_EPSILON) then
					if InCombatLockdown() then
						if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomLeft.actionButtons[iMultiBarBottomLeftButton]] == nil) then
							ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomLeft.actionButtons[iMultiBarBottomLeftButton]] = { self, scale }
						else
							ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomLeft.actionButtons[iMultiBarBottomLeftButton]][2] = scale
						end
						delayFunc_BarHookProtectedApplySetScale = true
						if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
							fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
						end
						return
					end
					iMultiBarBottomLeftButton:SetScale(newMainScale)
				end
			end
			hooksecurefunc(iMultiBarBottomLeftButton:GetParent(), "SetScale", CUI_MultiBarBottomLeft.actionButtons[iMultiBarBottomLeftButton].hook_SetScale)
		end
	end

	-- [ActionBars] MultiBarBottomRight
	local CUI_MultiBarBottomRight = CreateFrame("Frame", "CUI_MultiBarBottomRight", MultiBarBottomRight)
	function CUI_MultiBarBottomRight:RelocateBar()
		self:ClearAllPoints()
		self:SetPoint("LEFT", CUI_MultiBarBottomLeft, "RIGHT", 10, 0)
	end
	function CUI_MultiBarBottomRight:InitButtons()
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
		for i = 2, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
	CUI_MultiBarBottomRight.actionButtons = { }
	CUI_MultiBarBottomRight.hook_SetScale = function(self, scale)
		if (CUI_MultiBarBottomRight.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_scale / scale	-- cached db value
			if (mathabs(CUI_MultiBarBottomRight:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomRight] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomRight] = { self, scale }
					else
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomRight][2] = scale
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_MultiBarBottomRight:SetScale(newMainScale)
				CUI_MultiBarBottomRight.oldOrigScale = scale
				for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
					local iMultiBarBottomRightButton = _G["MultiBarBottomRightButton"..i]
					if (iMultiBarBottomRightButton ~= nil) then
						iMultiBarBottomRightButton:SetScale(ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_scale / (iMultiBarBottomRightButton:GetParent():GetScale() * scale) * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarBottomRightButton])	-- cached db value
					end
				end
			end
		end
	end
	hooksecurefunc(MultiBarBottomRight, "SetScale", CUI_MultiBarBottomRight.hook_SetScale)
	for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
		local iMultiBarBottomRightButton = _G["MultiBarBottomRightButton"..i]
		if (iMultiBarBottomRightButton ~= nil) then
			CUI_MultiBarBottomRight.actionButtons[iMultiBarBottomRightButton] = { }
			CUI_MultiBarBottomRight.actionButtons[iMultiBarBottomRightButton].hook_SetScale = function(self, scale)
				local newMainScale = ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_scale / (scale * iMultiBarBottomRightButton.bar:GetScale()) * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarBottomRightButton]	-- cached db value
				if (mathabs(iMultiBarBottomRightButton:GetScale()-newMainScale) > SCALE_EPSILON) then
					if InCombatLockdown() then
						if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomRight.actionButtons[iMultiBarBottomRightButton]] == nil) then
							ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomRight.actionButtons[iMultiBarBottomRightButton]] = { self, scale }
						else
							ClassicUI.queuePending_HookSetScale[CUI_MultiBarBottomRight.actionButtons[iMultiBarBottomRightButton]][2] = scale
						end
						delayFunc_BarHookProtectedApplySetScale = true
						if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
							fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
						end
						return
					end
					iMultiBarBottomRightButton:SetScale(newMainScale)
				end
			end
			hooksecurefunc(iMultiBarBottomRightButton:GetParent(), "SetScale", CUI_MultiBarBottomRight.actionButtons[iMultiBarBottomRightButton].hook_SetScale)
		end
	end

	-- [ActionBars] MultiBarRight
	local CUI_MultiBarRight = CreateFrame("Frame", "CUI_MultiBarRight", MultiBarRight)
	function CUI_MultiBarRight:RelocateBar()
		local yPos
		if not(ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_ignoreyOffsetStatusBar) then	-- cached db value
			if (ClassicUI.cached_NumberRealVisibleBars <= 1) then
				yPos = 98 + ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_yOffset	-- cached db value
			else
				yPos = 107 + ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_yOffset	-- cached db value
			end
		else
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = 98 + ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_yOffset1StatusBar	-- cached db value
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = 98 + ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_yOffset1StatusBar	-- cached db value
			else
				yPos = 98 + ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_yOffset2StatusBar	-- cached db value
			end
		end
		self:ClearAllPoints()
		self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_xOffset, yPos)	-- cached db value
	end
	function CUI_MultiBarRight:InitButtons()
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
		for i = 2, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
	CUI_MultiBarRight.actionButtons = { }
	CUI_MultiBarRight.hook_SetScale = function(self, scale)
		if (CUI_MultiBarRight.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_scale / scale	-- cached db value
			if (mathabs(CUI_MultiBarRight:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarRight] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarRight] = { self, scale }
					else
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarRight][2] = scale
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_MultiBarRight:SetScale(newMainScale)
				CUI_MultiBarRight.oldOrigScale = scale
				for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
					local iMultiBarRightButton = _G["MultiBarRightButton"..i]
					if (iMultiBarRightButton ~= nil) then
						iMultiBarRightButton:SetScale(ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_scale / (iMultiBarRightButton:GetParent():GetScale() * scale) * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarRightButton])	-- cached db value
					end
				end
			end
		end
	end
	hooksecurefunc(MultiBarRight, "SetScale", CUI_MultiBarRight.hook_SetScale)
	for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
		local iMultiBarRightButton = _G["MultiBarRightButton"..i]
		if (iMultiBarRightButton ~= nil) then
			CUI_MultiBarRight.actionButtons[iMultiBarRightButton] = { }
			CUI_MultiBarRight.actionButtons[iMultiBarRightButton].hook_SetScale = function(self, scale)
				local newMainScale = ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_scale / (scale * iMultiBarRightButton.bar:GetScale()) * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarRightButton]	-- cached db value
				if (mathabs(iMultiBarRightButton:GetScale()-newMainScale) > SCALE_EPSILON) then
					if InCombatLockdown() then
						if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarRight.actionButtons[iMultiBarRightButton]] == nil) then
							ClassicUI.queuePending_HookSetScale[CUI_MultiBarRight.actionButtons[iMultiBarRightButton]] = { self, scale }
						else
							ClassicUI.queuePending_HookSetScale[CUI_MultiBarRight.actionButtons[iMultiBarRightButton]][2] = scale
						end
						delayFunc_BarHookProtectedApplySetScale = true
						if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
							fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
						end
						return
					end
					iMultiBarRightButton:SetScale(newMainScale)
				end
			end
			hooksecurefunc(iMultiBarRightButton:GetParent(), "SetScale", CUI_MultiBarRight.actionButtons[iMultiBarRightButton].hook_SetScale)
		end
	end
	MultiBarRight:HookScript("OnShow", function(self)
		ClassicUI:ReLayoutMainFrames()
	end)

	-- [ActionBars] MultiBarLeft
	local CUI_MultiBarLeft = CreateFrame("Frame", "CUI_MultiBarLeft", MultiBarLeft)
	function CUI_MultiBarLeft:RelocateBar()
		self:ClearAllPoints()
		self:SetPoint("TOPRIGHT", CUI_MultiBarRight, "TOPLEFT", -5, 0)
	end
	function CUI_MultiBarLeft:InitButtons()
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
		for i = 2, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
	CUI_MultiBarLeft.actionButtons = { }
	CUI_MultiBarLeft.hook_SetScale = function(self, scale)
		if (CUI_MultiBarLeft.oldOrigScale ~= scale) then
			local newMainScale = ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_scale / scale	-- cached db value
			if (mathabs(CUI_MultiBarLeft:GetScale()-newMainScale) > SCALE_EPSILON) then
				if InCombatLockdown() then
					if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarLeft] == nil) then
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarLeft] = { self, scale }
					else
						ClassicUI.queuePending_HookSetScale[CUI_MultiBarLeft][2] = scale
					end
					delayFunc_BarHookProtectedApplySetScale = true
					if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
						fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
					return
				end
				CUI_MultiBarLeft:SetScale(newMainScale)
				CUI_MultiBarLeft.oldOrigScale = scale
				for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
					local iMultiBarLeftButton = _G["MultiBarLeftButton"..i]
					if (iMultiBarLeftButton ~= nil) then
						iMultiBarLeftButton:SetScale(ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_scale / (iMultiBarLeftButton:GetParent():GetScale() * scale) * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarLeftButton])	-- cached db value
					end
				end
			end
		end
	end
	hooksecurefunc(MultiBarLeft, "SetScale", CUI_MultiBarLeft.hook_SetScale)
	for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
		local iMultiBarLeftButton = _G["MultiBarLeftButton"..i]
		if (iMultiBarLeftButton ~= nil) then
			CUI_MultiBarLeft.actionButtons[iMultiBarLeftButton] = { }
			CUI_MultiBarLeft.actionButtons[iMultiBarLeftButton].hook_SetScale = function(self, scale)
				local newMainScale = ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_scale / (scale * iMultiBarLeftButton.bar:GetScale()) * ClassicUI.cached_ActionButtonInfo.currentScale[iMultiBarLeftButton]	-- cached db value
				if (mathabs(iMultiBarLeftButton:GetScale()-newMainScale) > SCALE_EPSILON) then
					if InCombatLockdown() then
						if (ClassicUI.queuePending_HookSetScale[CUI_MultiBarLeft.actionButtons[iMultiBarLeftButton]] == nil) then
							ClassicUI.queuePending_HookSetScale[CUI_MultiBarLeft.actionButtons[iMultiBarLeftButton]] = { self, scale }
						else
							ClassicUI.queuePending_HookSetScale[CUI_MultiBarLeft.actionButtons[iMultiBarLeftButton]][2] = scale
						end
						delayFunc_BarHookProtectedApplySetScale = true
						if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
							fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
						end
						return
					end
					iMultiBarLeftButton:SetScale(newMainScale)
				end
			end
			hooksecurefunc(iMultiBarLeftButton:GetParent(), "SetScale", CUI_MultiBarLeft.actionButtons[iMultiBarLeftButton].hook_SetScale)
		end
	end
	MultiBarLeft:HookScript("OnShow", function(self)
		ClassicUI:ReLayoutMainFrames()
	end)

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
			self.PETACTIONBAR_XPOS = 36 + ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_xOffset	-- cached db value
		elseif (MainMenuBarVehicleLeaveButton and MainMenuBarVehicleLeaveButton:IsShown() and (MainMenuBarVehicleLeaveButton:GetRight() ~= nil)) then
			self.PETACTIONBAR_XPOS = MainMenuBarVehicleLeaveButton:GetRight() + 20 + ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_xOffsetIfStanceBar	-- cached db value
		elseif (StanceBar and GetNumShapeshiftForms() > 0) then
			self.PETACTIONBAR_XPOS = 500 + ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_xOffsetIfStanceBar	-- cached db value
		elseif (MultiCastActionBarFrame and HasMultiCastActionBar()) then
			self.PETACTIONBAR_XPOS = 500 + ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_xOffsetIfStanceBar	-- cached db value
		else
			self.PETACTIONBAR_XPOS = 36 + ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_xOffset	-- cached db value
		end
	end
	function CUI_PetActionBarFrame:RelocateBarToNormalPosition(show_multi_action_bar_1)
		self:UpdateXPositionValue()
		self:ClearAllPoints()
		local yPos = (show_multi_action_bar_1) and ClassicUI.ACTION_BAR_OFFSET or 0
		if not(ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_ignoreyOffsetStatusBar) then	-- cached db value
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = yPos + 92 + ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_yOffset	-- cached db value
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = yPos + 97 + ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_yOffset	-- cached db value
			else
				yPos = yPos + 106 + ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_yOffset	-- cached db value
			end
		else
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = yPos + 92 + ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_yOffset	-- cached db value
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = yPos + 92 + ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_yOffset1StatusBar	-- cached db value
			else
				yPos = yPos + 92 + ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_yOffset2StatusBar	-- cached db value
			end
		end
		self:SetPoint("TOPLEFT", CUI_MainMenuBar, "BOTTOMLEFT", self.PETACTIONBAR_XPOS, yPos)
	end
	function CUI_PetActionBarFrame:RelocateBar(forceActionBarState)
		if ((forceActionBarState or ActionBarController_GetCurrentActionBarState()) == LE_ACTIONBAR_STATE_OVERRIDE) then
			if not(ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_hideOnOverrideActionBar) then	-- cached db value
				if not(self:IsShown()) then
					self:Show()
				end
				if not(ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_dontMoveOnOverrideActionBar) then	-- cached db value
					self:ClearAllPoints()
					self:SetPoint("BOTTOM", OverrideActionBar, "TOP", 31, 23)
				else
					self:RelocateBarToNormalPosition(MultiBar1_IsVisible())
				end
			else
				if (self:IsShown()) then
					self:Hide()
				end
				self:RelocateBarToNormalPosition(MultiBar1_IsVisible())
			end
			if (CUI_SlidingActionBarTexture0:IsShown()) then
				CUI_SlidingActionBarTexture0:Hide()
				CUI_SlidingActionBarTexture1:Hide()
			end
		elseif (C_PetBattles.IsInBattle()) then
			if not(ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_hideOnPetBattleFrameBar) then	-- cached db value
				if not(self:IsShown()) then
					self:Show()
				end
				if not(ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_dontMoveOnPetBattleFrameBar) then	-- cached db value
					self:ClearAllPoints()
					self:SetPoint("BOTTOM", PetBattleFrame.BottomFrame, "TOP", 31, 13)
				else
					self:RelocateBarToNormalPosition(MultiBar1_IsVisible())
				end
			else
				if (self:IsShown()) then
					self:Hide()
				end
				self:RelocateBarToNormalPosition(MultiBar1_IsVisible())
			end
			if (CUI_SlidingActionBarTexture0:IsShown()) then
				CUI_SlidingActionBarTexture0:Hide()
				CUI_SlidingActionBarTexture1:Hide()
			end
		else
			if (((ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_hideOnOverrideActionBar) or (ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_hideOnPetBattleFrameBar)) and not(self:IsShown())) then	-- cached db value
				self:Show()
			end
			local show_multi_action_bar_1 = MultiBarBottomLeft:IsShown()
			self:RelocateBarToNormalPosition(show_multi_action_bar_1)
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
		for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
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
					else
						ClassicUI.queuePending_HookSetScale[CUI_PetActionBarFrame][2] = scale
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
	PetActionBar:HookScript("OnShow", function(self)
		ClassicUI:ReLayoutMainFrames()
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
		if not(ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_ignoreyOffsetStatusBar) then	-- cached db value
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = yPos - 5 + ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_yOffset	-- cached db value
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = yPos + ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_yOffset	-- cached db value
			else
				yPos = yPos + 9 + ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_yOffset	-- cached db value
			end
		else
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = yPos - 5 + ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_yOffset	-- cached db value
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = yPos - 5 + ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_yOffset1StatusBar	-- cached db value
			else
				yPos = yPos - 5 + ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_yOffset2StatusBar	-- cached db value
			end
		end
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", CUI_MainMenuBar, "TOPLEFT", 30 + ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_xOffset, yPos)	-- cached db value
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
					else
						ClassicUI.queuePending_HookSetScale[CUI_PossessBarFrame][2] = scale
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
	hooksecurefunc(PossessActionBar, "UpdateState", function(self)
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
	end)
	PossessActionBar:HookScript("OnShow", function(self)
		ClassicUI:ReLayoutMainFrames()
	end)

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
		if not(ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_ignoreyOffsetStatusBar) then	-- cached db value
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = yPos - 5 + ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_yOffset	-- cached db value
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = yPos + ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_yOffset	-- cached db value
			else
				yPos = yPos + 9 + ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_yOffset	-- cached db value
			end
		else
			if (ClassicUI.cached_NumberRealVisibleBars <= 0) then
				yPos = yPos - 5 + ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_yOffset	-- cached db value
			elseif (ClassicUI.cached_NumberRealVisibleBars == 1) then
				yPos = yPos - 5 + ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_yOffset1StatusBar	-- cached db value
			else
				yPos = yPos - 5 + ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_yOffset2StatusBar	-- cached db value
			end

		end
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", CUI_MainMenuBar, "TOPLEFT", 30 + ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_xOffset, yPos)	-- cached db value
		if (show_multi_action_bar_1) then
			if CUI_StanceBarLeft:IsShown() then CUI_StanceBarLeft:Hide() end
			if CUI_StanceBarMiddle:IsShown() then CUI_StanceBarMiddle:Hide() end
			if CUI_StanceBarRight:IsShown() then CUI_StanceBarRight:Hide() end
			if not(ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_BLStyle == 1) then	-- cached db value
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
			if not(ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_BLStyle == 1) then	-- cached db value
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
					else
						ClassicUI.queuePending_HookSetScale[CUI_StanceBarFrame][2] = scale
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
	StanceBar:HookScript("OnShow", function(self)
		ClassicUI:ReLayoutMainFrames()
	end)

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
	CUI_MainMenuBar.hook_SetScale(MainActionBar, MainActionBar:GetScale())
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
	ClassicUI.mbIsStacked = false
	ClassicUI.MicroButtonsGroup = {
		[CharacterMicroButton] = 1,
		[ProfessionMicroButton] = 2,
		[PlayerSpellsMicroButton] = 3,
		[AchievementMicroButton] = 4,
		[QuestLogMicroButton] = 5,
		[HousingMicroButton] = 6,
		[GuildMicroButton] = 7,
		[LFDMicroButton] = 8,
		[CollectionsMicroButton] = 9,
		[EJMicroButton] = 10,
		[HelpMicroButton] = 11,
		[StoreMicroButton] = 12,
		[MainMenuMicroButton] = 13
	}
	ClassicUI.MicroButtonsGroupOrderInfo = {
		current = { },		-- array with current ordered MicroButtons, execute 'ClassicUI.SetOrderInfoMicroButtons()' to refresh
		forceHidden = { },	-- array with current forcibly hidden MicroButtons (usually hidden because they do not fit)
		anchorInfo = {		-- array with the anchor information for the MicroButtons
			[1] = {
				point = "BOTTOMLEFT",
				relativeFrame = CUI_MainMenuBarArtFrame,
				relativePoint = "BOTTOMLEFT",
				offsetX = 556 + ClassicUI.db.profile.barsConfig.MicroButtons.xOffset,
				offsetY = 2 + ClassicUI.db.profile.barsConfig.MicroButtons.yOffset
			},
			[2] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -2,
				offsetY = 0
			},
			[3] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -2,
				offsetY = 0
			},
			[4] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -2,
				offsetY = 0
			},
			[5] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -2,
				offsetY = 0
			},
			[6] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -2,
				offsetY = 0
			},
			[7] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -3,
				offsetY = 0
			},
			[8] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -2,
				offsetY = 0
			},
			[9] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -2,
				offsetY = 0
			},
			[10] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -2,
				offsetY = 0
			},
			[11] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -3,
				offsetY = 0
			},
			[12] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -2,
				offsetY = 0
			},
			[13] = {
				point = "BOTTOMLEFT",
				relativePoint = "BOTTOMRIGHT",
				offsetX = -2,
				offsetY = 0
			}
		}
	}

	-- Function to refresh the 'ClassicUI.MicroButtonsGroupOrderInfo.current' array (current ordering status of the MicroButtons)
	ClassicUI.SetOrderInfoMicroButtons = function()
		-- Wipe the current table
		for k, _ in pairs(ClassicUI.MicroButtonsGroupOrderInfo.current) do
			ClassicUI.MicroButtonsGroupOrderInfo.current[k] = nil
		end
		-- Reset the forceHidden table
		for k, _ in pairs(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden) do
			ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[k] = false
		end
		-- Add space-consuming MicroButtons to the sort table
		local numButtonsAdded = 0
		for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
			if ((type(v) == 'table') and (type(v.order) == 'number')) then
				if (not(v.hideMicroButton) or v.keepGapMicroButton) then
					ClassicUI.MicroButtonsGroupOrderInfo.current[v.order] = {
						name = k,
						button = _G[k],
						priority = v.priority
					}
					numButtonsAdded = numButtonsAdded + 1
				end
			end
		end
		-- Remove from the table the non-priority MicroButtons that do not fit
		local numButtonsToRemove = numButtonsAdded - ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown
		if (numButtonsToRemove > 0) then
			local buttonsToRemove = { }
			local minIndex = nil
			local minPriority = nil
			for k, v in pairs(ClassicUI.MicroButtonsGroupOrderInfo.current) do
				if #buttonsToRemove < numButtonsToRemove then
					tblinsert(buttonsToRemove, { priority = v.priority, order = k, button = v.button })
					if minIndex == nil or v.priority < minPriority then
						minIndex = #buttonsToRemove
						minPriority = v.priority
					end
				else
					if v.priority > minPriority then
						buttonsToRemove[minIndex].priority = v.priority
						buttonsToRemove[minIndex].order = k
						buttonsToRemove[minIndex].button = v.button
						minIndex = 1
						minPriority = buttonsToRemove[1].priority
						for i = 2, numButtonsToRemove do
							if buttonsToRemove[i].priority < minPriority then
								minIndex = i
								minPriority = buttonsToRemove[i].priority
							end
						end
					end
				end
			end
			for i = 1, numButtonsToRemove do
				ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[buttonsToRemove[i].button] = true
				ClassicUI.MicroButtonsGroupOrderInfo.current[buttonsToRemove[i].order] = nil
			end
		end
		-- Shrink the table to adjust the sortings by removing the gaps, converting it to an array
		local c = ClassicUI.MICROBUTTONS_MIN_ORDER
		for i = ClassicUI.MICROBUTTONS_MIN_ORDER, ClassicUI.MICROBUTTONS_MAX_ORDER do
			if (ClassicUI.MicroButtonsGroupOrderInfo.current[i] ~= nil) then
				if (i ~= c) then
					ClassicUI.MicroButtonsGroupOrderInfo.current[c] = ClassicUI.MicroButtonsGroupOrderInfo.current[i]
					ClassicUI.MicroButtonsGroupOrderInfo.current[i] = nil
				end
				c = c + 1
			end
		end
	end

	-- Function to set the position for all MicroButtons
	ClassicUI.SetPointsMicroButtons = function()
		local otherButtons = { }
		for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
			if ((type(v) == 'table') and (type(v.order) == 'number')) then
				otherButtons[v.order] = {
					name = k,
					button = _G[k]
				}
			end
		end
		-- SetPoint for the ordered buttons shown
		local c = 1
		for k, v in ipairs(ClassicUI.MicroButtonsGroupOrderInfo.current) do
			v.button:ClearAllPoints()
			local anchorInfo = ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[k]
			local relativeFrame
			local xOffset = ClassicUI.db.profile.barsConfig.MicroButtons[v.name].xOffsetMicroButton
			local yOffset = ClassicUI.db.profile.barsConfig.MicroButtons[v.name].yOffsetMicroButton
			if (k == 1) then
				relativeFrame = anchorInfo.relativeFrame
			else
				local relativeFramePos = anchorInfo.relativeFramePos or k-1
				relativeFrame = ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].button
				xOffset = xOffset - ClassicUI.db.profile.barsConfig.MicroButtons[ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].name].xOffsetMicroButton
				yOffset = yOffset - ClassicUI.db.profile.barsConfig.MicroButtons[ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].name].yOffsetMicroButton
			end
			v.button:SetPoint(anchorInfo.point, relativeFrame, anchorInfo.relativePoint, anchorInfo.offsetX + (ClassicUI.mbIsStacked and 0 or xOffset), anchorInfo.offsetY + (ClassicUI.mbIsStacked and 0 or yOffset))
			for l, m in pairs(otherButtons) do
				if (m.button == v.button) then
					otherButtons[l] = nil
					break
				end
			end
			c = c + 1
		end
		-- SetPoint for unordered buttons not displayed
		for k, v in pairs(otherButtons) do
			v.button:ClearAllPoints()
			local anchorInfo = ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[c]
			local relativeFrame
			local xOffset = ClassicUI.db.profile.barsConfig.MicroButtons[v.name].xOffsetMicroButton
			local yOffset = ClassicUI.db.profile.barsConfig.MicroButtons[v.name].yOffsetMicroButton
			if (c == 1) then
				relativeFrame = anchorInfo.relativeFrame
			else
				local relativeFramePos = anchorInfo.relativeFramePos or c-1
				if (ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos] ~= nil) then
					relativeFrame = ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].button
					xOffset = xOffset - ClassicUI.db.profile.barsConfig.MicroButtons[ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].name].xOffsetMicroButton
					yOffset = yOffset - ClassicUI.db.profile.barsConfig.MicroButtons[ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].name].yOffsetMicroButton
				elseif (k > 1 and otherButtons[k-1] ~= nil) then
					relativeFrame = otherButtons[k-1].button
					xOffset = xOffset - ClassicUI.db.profile.barsConfig.MicroButtons[otherButtons[k-1].name].xOffsetMicroButton
					yOffset = yOffset - ClassicUI.db.profile.barsConfig.MicroButtons[otherButtons[k-1].name].yOffsetMicroButton
				end
			end
			v.button:SetPoint(anchorInfo.point, relativeFrame, anchorInfo.relativePoint, anchorInfo.offsetX + (ClassicUI.mbIsStacked and 0 or xOffset), anchorInfo.offsetY + (ClassicUI.mbIsStacked and 0 or yOffset))
			c = c + 1
		end
		-- Manage the forceHidden buttons
		for k, v in pairs(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden) do
			if (v) then
				k:Hide()
			else
				if not(ClassicUI.db.profile.barsConfig.MicroButtons[k:GetName()].hideMicroButton) then
					k:Show()
				end
				ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[k] = nil
			end
		end
	end

	-- Function to update the parent frame of all MicroButtons
	ClassicUI.UpdateMicroButtonsParent = function(parent)
		for k, _ in pairs(ClassicUI.MicroButtonsGroup) do
			k:SetParent(parent)
		end
	end

	-- Function to move the all MicroButtons to a new position
	ClassicUI.MoveMicroButtons = function(anchor, anchorTo, relAnchor, x, y, isStacked)
		-- SetPoint of the first and seventh MicroButtons
		local microbutton1 = ClassicUI.MicroButtonsGroupOrderInfo.current[1]
		if (microbutton1 ~= nil) then
			microbutton1.button:ClearAllPoints()
			microbutton1.button:SetPoint(anchor, anchorTo, relAnchor, x + (isStacked and 0 or ClassicUI.db.profile.barsConfig.MicroButtons[microbutton1.name].xOffsetMicroButton), y + (isStacked and 0 or ClassicUI.db.profile.barsConfig.MicroButtons[microbutton1.name].yOffsetMicroButton))
			ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[1].point = anchor
			ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[1].relativeFrame = anchorTo
			ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[1].relativePoint = relAnchor
			ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[1].offsetX = x
			ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[1].offsetY = y
			local microbutton7 = ClassicUI.MicroButtonsGroupOrderInfo.current[7]
			if (microbutton7 ~= nil) then
				microbutton7.button:ClearAllPoints()
				if (isStacked) then
					microbutton7.button:SetPoint("TOPLEFT", microbutton1.button, "BOTTOMLEFT", 0, 4)
					ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[7].point = "TOPLEFT"
					ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[7].relativeFramePos = 1
					ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[7].relativePoint = "BOTTOMLEFT"
					ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[7].offsetX = 0
					ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[7].offsetY = 4
				else
					local microbutton6 = ClassicUI.MicroButtonsGroupOrderInfo.current[6]
					microbutton7.button:SetPoint("BOTTOMLEFT", microbutton6.button, "BOTTOMRIGHT", -3 + ClassicUI.db.profile.barsConfig.MicroButtons[microbutton7.name].xOffsetMicroButton - ClassicUI.db.profile.barsConfig.MicroButtons[microbutton6.name].xOffsetMicroButton, 0 + ClassicUI.db.profile.barsConfig.MicroButtons[microbutton7.name].yOffsetMicroButton - ClassicUI.db.profile.barsConfig.MicroButtons[microbutton6.name].yOffsetMicroButton)
					ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[7].point = "BOTTOMLEFT"
					ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[7].relativeFramePos = nil
					ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[7].relativePoint = "BOTTOMRIGHT"
					ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[7].offsetX = -3
					ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[7].offsetY = 0
				end
			end
		end
		-- SetPoint of the other MicroButtons to set/unset their offsets when needed
		if (isStacked) then
			if not(ClassicUI.mbIsStacked) then	-- do this only once, when switching from unstacked to stacked
				-- SetScale of MicroButtons to normal size when stacked
				for k, _ in pairs(ClassicUI.MicroButtonsGroup) do
					k:SetScale(1)
				end
				-- SetPoint of the other MicroButtons to unset their offsets
				for k, v in pairs(ClassicUI.MicroButtonsGroupOrderInfo.current) do
					if (k ~= 1 and k ~= 7) then
						local anchorInfo = ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[k]
						local relativeFramePos = anchorInfo.relativeFramePos or k-1
						local xOffset = ClassicUI.db.profile.barsConfig.MicroButtons[v.name].xOffsetMicroButton - ClassicUI.db.profile.barsConfig.MicroButtons[ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].name].xOffsetMicroButton
						local yOffset = ClassicUI.db.profile.barsConfig.MicroButtons[v.name].yOffsetMicroButton - ClassicUI.db.profile.barsConfig.MicroButtons[ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].name].yOffsetMicroButton
						if (xOffset ~= 0 or yOffset ~= 0) then	-- only SetPoint if necessary
							v.button:SetPoint(anchorInfo.point, ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].button, anchorInfo.relativePoint, anchorInfo.offsetX, anchorInfo.offsetY)
						end
					end
				end
			end
		else
			if (ClassicUI.mbIsStacked) then	-- do this only once, when switching from stacked to unstacked
				-- SetScale of MicroButtons to the selected value size
				for k, _ in pairs(ClassicUI.MicroButtonsGroup) do
					k:SetScale(ClassicUI.db.profile.barsConfig.MicroButtons.scale)
				end
				-- SetPoint of the other MicroButtons to set their offsets
				for k, v in pairs(ClassicUI.MicroButtonsGroupOrderInfo.current) do
					if (k ~= 1 and k ~= 7) then
						local anchorInfo = ClassicUI.MicroButtonsGroupOrderInfo.anchorInfo[k]
						local relativeFramePos = anchorInfo.relativeFramePos or k-1
						local xOffset = ClassicUI.db.profile.barsConfig.MicroButtons[v.name].xOffsetMicroButton - ClassicUI.db.profile.barsConfig.MicroButtons[ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].name].xOffsetMicroButton
						local yOffset = ClassicUI.db.profile.barsConfig.MicroButtons[v.name].yOffsetMicroButton - ClassicUI.db.profile.barsConfig.MicroButtons[ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].name].yOffsetMicroButton
						if (xOffset ~= 0 or yOffset ~= 0) then	-- only SetPoint if necessary
							v.button:SetPoint(anchorInfo.point, ClassicUI.MicroButtonsGroupOrderInfo.current[relativeFramePos].button, anchorInfo.relativePoint, anchorInfo.offsetX + xOffset, anchorInfo.offsetY + yOffset)
						end
					end
				end
			end
		end
		ClassicUI.mbIsStacked = isStacked
	end

	ClassicUI.SetOrderInfoMicroButtons()

	MainActionBar:HookScript("OnShow", function(self)
		ClassicUI.UpdateMicroButtonsParent(CUI_MainMenuBarArtFrame)
		if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
		ClassicUI.MoveMicroButtons("BOTTOMLEFT", CUI_MainMenuBarArtFrame, "BOTTOMLEFT", 556 + ClassicUI.db.profile.barsConfig.MicroButtons.xOffset, 2 + ClassicUI.db.profile.barsConfig.MicroButtons.yOffset, false)
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
			ClassicUI.UpdateMicroButtonsParent(self)
			if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
			ClassicUI.MoveMicroButtons("BOTTOMLEFT", self, "BOTTOMLEFT", anchorX, anchorY, true)
		end
	end)

	PetBattleFrame.BottomFrame.MicroButtonFrame:HookScript("OnShow", function(self)
		ClassicUI.UpdateMicroButtonsParent(self)
		if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
		ClassicUI.MoveMicroButtons("TOPLEFT", self, "TOPLEFT", -11.5, 7.5, true)
	end)

	ClassicUI.hook_MicroButtonSetStateFunc = function(self)
		if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
		if (self:IsEnabled() and ClassicUI.db.profile.barsConfig.MicroButtons[self:GetName()].disableMicroButton) then
			self:Disable()
		end
		if self.Background:IsShown() then
			self.Background:Hide()
		end
		if self.PushedBackground:IsShown() then
			self.PushedBackground:Hide()
		end
		self:SetHighlightAtlas("hud-microbutton-highlight")
		self:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
		self:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
		self:GetHighlightTexture():SetAlpha(1)
	end
	ClassicUI.hookscript_MicroButtonOnEnter = function(self)
		self:GetNormalTexture():SetAlpha(1)
	end
	ClassicUI.hookscript_MicroButtonOnEnable = function(self)
		if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
		self:SetAlpha(ClassicUI.MICROBUTTONS_DEFAULT_ALPHA_ENABLED*ClassicUI.db.profile.barsConfig.MicroButtons[self:GetName()].alphaMicroButton)
	end
	ClassicUI.hookscript_MicroButtonOnDisable = function(self)
		if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
		self:SetAlpha(ClassicUI.MICROBUTTONS_DEFAULT_ALPHA_DISABLED*ClassicUI.db.profile.barsConfig.MicroButtons[self:GetName()].alphaMicroButton)
	end
	ClassicUI.CreateMainMenuBarPerformanceBar2Texture = function(microButton)
		if (microButton.MainMenuBarPerformanceBar2 == nil) then
			local MainMenuBarPerformanceBar2 = microButton:CreateTexture(microButton:GetName().."_MainMenuBarPerformanceBar2", "OVERLAY")
			microButton.MainMenuBarPerformanceBar2 = MainMenuBarPerformanceBar2
			MainMenuBarPerformanceBar2:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MainMenuBar-PerformanceBar-classic")
			MainMenuBarPerformanceBar2:SetSize(14, 7)
		end
		if (microButton:GetButtonState() == "PUSHED") then
			microButton.MainMenuBarPerformanceBar2:SetPoint("TOPLEFT", microButton, "TOPLEFT", 8.75, -15.45)
		else
			microButton.MainMenuBarPerformanceBar2:SetPoint("TOPLEFT", microButton, "TOPLEFT", 9.6, -13.5)
		end
	end

	ClassicUI.HookMicroButtonsClass_UI_Watcher = function(microButton)
		if (Class_UI_Watcher ~= nil) then
			if (microButton == PlayerSpellsMicroButton) then
				if not(ClassicUI.hooked_Class_UI_Watcher_StartWatching) then
					hooksecurefunc(Class_UI_Watcher, "StartWatching", function(self)	-- apply only to TutorialData.PLAYERSPELLS_MICROBUTTON microbutton
						if (not self.IsActive) then return end
						if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
						if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.hideMicroButton) then
							PlayerSpellsMicroButton:Hide()
						end
					end)
					ClassicUI.hooked_Class_UI_Watcher_StartWatching = true
				end
				if not(ClassicUI.hooked_Class_UI_Watcher_PLAYER_LEVEL_CHANGED) then
					hooksecurefunc(Class_UI_Watcher, "PLAYER_LEVEL_CHANGED", function(self)	-- apply only to TutorialData.PLAYERSPELLS_MICROBUTTON microbutton
						if (not self.IsActive) then return end
						if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
						if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.hideMicroButton) then
							PlayerSpellsMicroButton:Hide()
						end
					end)
					ClassicUI.hooked_Class_UI_Watcher_PLAYER_LEVEL_CHANGED = true
				end
			end
			if (microButton ~= HelpMicroButton) then
				if not(ClassicUI.hooked_Class_UI_Watcher_QUEST_ACCEPTED) then
					hooksecurefunc(Class_UI_Watcher, "QUEST_ACCEPTED", function(self, questID)	-- apply to TutorialData.UI_Elements.PLAYERSPELLS_MICROBUTTON/OTHER_MICROBUTTONS/STORE_MICROBUTTON microbuttons
						if (not self.IsActive) then return end
						if (questID == self.tutorialData.ShowAllUIQuest) then
							if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
							if (ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[CharacterMicroButton]) then
								CharacterMicroButton:Hide()
							end
							if (ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[ProfessionMicroButton]) then
								ProfessionMicroButton:Hide()
							end
							if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[PlayerSpellsMicroButton]) then
								PlayerSpellsMicroButton:Hide()
							end
							if (ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[AchievementMicroButton]) then
								AchievementMicroButton:Hide()
							end
							if (ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[QuestLogMicroButton]) then
								QuestLogMicroButton:Hide()
							end
							if (ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[HousingMicroButton]) then
								HousingMicroButton:Hide()
							end
							if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[GuildMicroButton]) then
								GuildMicroButton:Hide()
							end
							if (ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[LFDMicroButton]) then
								LFDMicroButton:Hide()
							end
							if (ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[CollectionsMicroButton]) then
								CollectionsMicroButton:Hide()
							end
							if (ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[EJMicroButton]) then
								EJMicroButton:Hide()
							end
							if (ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[StoreMicroButton]) then
								StoreMicroButton:Hide()
							end
							if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[MainMenuMicroButton]) then
								MainMenuMicroButton:Hide()
							end
						end
					end)
					ClassicUI.hooked_Class_UI_Watcher_QUEST_ACCEPTED = true
				end
				if not(ClassicUI.hooked_Class_UI_Watcher_OnInterrupt) then
					hooksecurefunc(Class_UI_Watcher, "OnInterrupt", function(sel)	-- apply to TutorialData.UI_Elements.PLAYERSPELLS_MICROBUTTON/OTHER_MICROBUTTONS/STORE_MICROBUTTON microbuttons
						if (not self.IsActive) then return end
						if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
						if (ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[CharacterMicroButton]) then
							CharacterMicroButton:Hide()
						end
						if (ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[ProfessionMicroButton]) then
							ProfessionMicroButton:Hide()
						end
						if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[PlayerSpellsMicroButton]) then
							PlayerSpellsMicroButton:Hide()
						end
						if (ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[AchievementMicroButton]) then
							AchievementMicroButton:Hide()
						end
						if (ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[QuestLogMicroButton]) then
							QuestLogMicroButton:Hide()
						end
						if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[GuildMicroButton]) then
							GuildMicroButton:Hide()
						end
						if (ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[LFDMicroButton]) then
							LFDMicroButton:Hide()
						end
						if (ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[CollectionsMicroButton]) then
							CollectionsMicroButton:Hide()
						end
						if (ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[EJMicroButton]) then
							EJMicroButton:Hide()
						end
						if (ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[StoreMicroButton]) then
							StoreMicroButton:Hide()
						end
						if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[MainMenuMicroButton]) then
							MainMenuMicroButton:Hide()
						end
					end)
					ClassicUI.hooked_Class_UI_Watcher_OnInterrupt = true
				end
			end
		end
	end
	ClassicUI.HookPlayerSpellsFrame_Tabs = function()
		if (PlayerSpellsFrame ~= nil and PlayerSpellsUtil ~= nil) then
			if not(ClassicUI.hooked_PlayerSpellsFrame_SetTab) then
				hooksecurefunc(PlayerSpellsFrame, "SetTab", function(self, tabID)
					if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton == 23) then	-- cached db value
						if (self.frameTabsToTabID[PlayerSpellsUtil.FrameTabs.SpellBook] == self.internalTabTracker.tabID) then
							PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_normalTextureSB)	-- cached db value
							PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_pushedTextureSB)	-- cached db value
							PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_disabledTextureSB)	-- cached db value
						else
							PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_normalTextureTT)	-- cached db value
							PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_pushedTextureTT)	-- cached db value
							PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_disabledTextureTT)	-- cached db value
						end
					end
				end)
				ClassicUI.hooked_PlayerSpellsFrame_SetTab = true
			end
			if not(ClassicUI.hooked_PlayerSpellsFrame_TabSystem_SetTab) then
				hooksecurefunc(PlayerSpellsFrame.TabSystem, "SetTab", function(self, tabID)
					if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton == 23) then	-- cached db value
						local parent = self:GetParent()
						if (parent.frameTabsToTabID[PlayerSpellsUtil.FrameTabs.SpellBook] == parent.internalTabTracker.tabID) then
							PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_normalTextureSB)	-- cached db value
							PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_pushedTextureSB)	-- cached db value
							PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_disabledTextureSB)	-- cached db value
						else
							PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_normalTextureTT)	-- cached db value
							PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_pushedTextureTT)	-- cached db value
							PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_disabledTextureTT)	-- cached db value
						end
					end
				end)
				ClassicUI.hooked_PlayerSpellsFrame_TabSystem_SetTab = true
			end
		end
	end

	-- [MicroButtons] CharacterMicroButton
	CharacterMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	CharacterMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	CharacterMicroButton:SetFrameStrata("MEDIUM")
	CharacterMicroButton:SetFrameLevel(3)
	CharacterMicroButton:SetNormalAtlas("hud-microbutton-Character-Up")
	CharacterMicroButton:SetPushedAtlas("hud-microbutton-Character-Down")
	CharacterMicroButton:SetDisabledAtlas("hud-microbutton-Character-Disabled")
	CharacterMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	CharacterMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	CharacterMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.iconMicroButton].normalTexture)
	CharacterMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.iconMicroButton].pushedTexture)
	CharacterMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.iconMicroButton].disabledTexture)
	CharacterMicroButton:GetDisabledTexture():SetDesaturated(true)
	CharacterMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CharacterMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CharacterMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CharacterMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CharacterMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	CharacterMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	CharacterMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	CharacterMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	CharacterMicroButton.Background:Hide()
	CharacterMicroButton.Background:SetAlpha(0)
	CharacterMicroButton.PushedBackground:Hide()
	CharacterMicroButton.PushedBackground:SetAlpha(0)
	CharacterMicroButton.FlashBorder:SetAtlas(nil)
	CharacterMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	CharacterMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	CharacterMicroButton.FlashBorder:SetBlendMode("ADD")
	CharacterMicroButton.FlashBorder:ClearAllPoints()
	CharacterMicroButton.FlashBorder:SetSize(34, 44)
	CharacterMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	CharacterMicroButton.FlashBorder:SetPoint("TOPLEFT", PlayerSpellsMicroButton, "TOPLEFT", -2, 3)
	hooksecurefunc(CharacterMicroButton, "SetPushed", function(self)
		if (self:IsEnabled() and ClassicUI.cached_db_profile.barsConfig_MicroButtons_CharacterMicroButton_disableMicroButton) then	-- cached db value
			self:Disable()
		end
		self.PushedBackground:Hide()
		self.Portrait:ClearAllPoints()
		self.Portrait:SetPoint("TOP", self, "TOP", 0, -7)
		self.Portrait:SetTexCoord(0.2666, 0.8666, 0, 0.8333)
		self.Portrait:SetAlpha(0.5)
	end)
	hooksecurefunc(CharacterMicroButton, "SetNormal", function(self)
		if (self:IsEnabled() and ClassicUI.cached_db_profile.barsConfig_MicroButtons_CharacterMicroButton_disableMicroButton) then	-- cached db value
			self:Disable()
		end
		self.Background:Hide()
		self.Portrait:ClearAllPoints()
		self.Portrait:SetPoint("TOP", self, "TOP", 0, -7)
		self.Portrait:SetTexCoord(0.2, 0.8, 0.0666, 0.9)
		self.Portrait:SetAlpha(1.0)
	end)
	CharacterMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.CharacterMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_CharacterMicroButton_OnEnableOnDisable) then
			CharacterMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			CharacterMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_CharacterMicroButton_OnEnableOnDisable = true
		end
		if (CharacterMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(CharacterMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(CharacterMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.hideMicroButton) then
		CharacterMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(CharacterMicroButton)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.disableMicroButton) then
		CharacterMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.disableMouseMicroButton) then
		CharacterMicroButton:EnableMouse(false)
	end

	-- [MicroButtons] CharacterMicroButton -> Portrait texture
	CharacterMicroButton.PortraitMask:Hide()
	CharacterMicroButton.PortraitMask:SetAlpha(0)
	CharacterMicroButton.Shadow:Hide()
	CharacterMicroButton.Shadow:SetAlpha(0)
	CharacterMicroButton.PushedShadow:Hide()
	CharacterMicroButton.PushedShadow:SetAlpha(0)
	CharacterMicroButton.Portrait:ClearAllPoints()
	CharacterMicroButton.Portrait:SetPoint("TOP", CharacterMicroButton, "TOP", 0, -7)
	CharacterMicroButton.Portrait:SetTexCoord(0.2, 0.8, 0.0666, 0.9)
	CharacterMicroButton.Portrait:SetAlpha(1.0)
	CharacterMicroButton.Portrait:SetSize(18, 25)
	CharacterMicroButton.Portrait:SetDrawLayer("OVERLAY", 0)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.iconMicroButton ~= 0) then
		CharacterMicroButton.Portrait:Hide()
	end

	-- [MicroButtons] ProfessionMicroButton
	ProfessionMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	ProfessionMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	ProfessionMicroButton:SetFrameStrata("MEDIUM")
	ProfessionMicroButton:SetFrameLevel(3)
	ProfessionMicroButton:SetNormalAtlas("hud-microbutton-Spellbook-Up")
	ProfessionMicroButton:SetPushedAtlas("hud-microbutton-Spellbook-Down")
	ProfessionMicroButton:SetDisabledAtlas("hud-microbutton-Spellbook-Disabled")
	ProfessionMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	ProfessionMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	ProfessionMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.iconMicroButton].normalTexture)
	ProfessionMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.iconMicroButton].pushedTexture)
	ProfessionMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.iconMicroButton].disabledTexture)
	ProfessionMicroButton:GetDisabledTexture():SetDesaturated(true)
	ProfessionMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	ProfessionMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	ProfessionMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	ProfessionMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	ProfessionMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	ProfessionMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	ProfessionMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	ProfessionMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	ProfessionMicroButton.Background:Hide()
	ProfessionMicroButton.Background:SetAlpha(0)
	ProfessionMicroButton.PushedBackground:Hide()
	ProfessionMicroButton.PushedBackground:SetAlpha(0)
	ProfessionMicroButton.FlashBorder:SetAtlas(nil)
	ProfessionMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	ProfessionMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	ProfessionMicroButton.FlashBorder:SetBlendMode("ADD")
	ProfessionMicroButton.FlashBorder:ClearAllPoints()
	ProfessionMicroButton.FlashBorder:SetSize(34, 44)
	ProfessionMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	ProfessionMicroButton.FlashBorder:SetPoint("TOPLEFT", ProfessionMicroButton, "TOPLEFT", -2, 3)
	hooksecurefunc(ProfessionMicroButton, "SetPushed", ClassicUI.hook_MicroButtonSetStateFunc)
	hooksecurefunc(ProfessionMicroButton, "SetNormal", ClassicUI.hook_MicroButtonSetStateFunc)
	ProfessionMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.ProfessionMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_ProfessionMicroButton_OnEnableOnDisable) then
			ProfessionMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			ProfessionMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_ProfessionMicroButton_OnEnableOnDisable = true
		end
		if (ProfessionMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(ProfessionMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(ProfessionMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.hideMicroButton) then
		ProfessionMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(ProfessionMicroButton)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.disableMicroButton) then
		ProfessionMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.disableMouseMicroButton) then
		ProfessionMicroButton:EnableMouse(false)
	end

	-- [MicroButtons] PlayerSpellsMicroButton
	PlayerSpellsMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	PlayerSpellsMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	PlayerSpellsMicroButton:SetFrameStrata("MEDIUM")
	PlayerSpellsMicroButton:SetFrameLevel(3)
	PlayerSpellsMicroButton:SetNormalAtlas("hud-microbutton-Talents-Up")
	PlayerSpellsMicroButton:SetPushedAtlas("hud-microbutton-Talents-Down")
	PlayerSpellsMicroButton:SetDisabledAtlas("hud-microbutton-Talents-Disabled")
	PlayerSpellsMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	PlayerSpellsMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton == 23) then
		if (PlayerSpellsFrame ~= nil and PlayerSpellsUtil ~= nil) then
			if (PlayerSpellsFrame.frameTabsToTabID[PlayerSpellsUtil.FrameTabs.SpellBook] == PlayerSpellsFrame.internalTabTracker.tabID) then
				PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].normalTextureSB)
				PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].pushedTextureSB)
				PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].disabledTextureSB)
			else
				PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].normalTextureTT)
				PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].pushedTextureTT)
				PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].disabledTextureTT)
			end
			ClassicUI.HookPlayerSpellsFrame_Tabs()
		else
			PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].normalTexture)
			PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].pushedTexture)
			PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].disabledTexture)
		end
	else
		PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].normalTexture)
		PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].pushedTexture)
		PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].disabledTexture)
	end
	PlayerSpellsMicroButton:GetDisabledTexture():SetDesaturated(true)
	PlayerSpellsMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	PlayerSpellsMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	PlayerSpellsMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	PlayerSpellsMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	PlayerSpellsMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	PlayerSpellsMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	PlayerSpellsMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	PlayerSpellsMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	PlayerSpellsMicroButton.Background:Hide()
	PlayerSpellsMicroButton.Background:SetAlpha(0)
	PlayerSpellsMicroButton.PushedBackground:Hide()
	PlayerSpellsMicroButton.PushedBackground:SetAlpha(0)
	PlayerSpellsMicroButton.FlashBorder:SetAtlas(nil)
	PlayerSpellsMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	PlayerSpellsMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	PlayerSpellsMicroButton.FlashBorder:SetBlendMode("ADD")
	PlayerSpellsMicroButton.FlashBorder:ClearAllPoints()
	PlayerSpellsMicroButton.FlashBorder:SetSize(34, 44)
	PlayerSpellsMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	PlayerSpellsMicroButton.FlashBorder:SetPoint("TOPLEFT", PlayerSpellsMicroButton, "TOPLEFT", -2, 3)
	hooksecurefunc(PlayerSpellsMicroButton, "SetPushed", ClassicUI.hook_MicroButtonSetStateFunc)
	hooksecurefunc(PlayerSpellsMicroButton, "SetNormal", ClassicUI.hook_MicroButtonSetStateFunc)
	PlayerSpellsMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_PlayerSpellsMicroButton_OnEnableOnDisable) then
			PlayerSpellsMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			PlayerSpellsMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_PlayerSpellsMicroButton_OnEnableOnDisable = true
		end
		if (PlayerSpellsMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(PlayerSpellsMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(PlayerSpellsMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.hideMicroButton) then
		PlayerSpellsMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(PlayerSpellsMicroButton)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.disableMicroButton) then
		PlayerSpellsMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.disableMouseMicroButton) then
		PlayerSpellsMicroButton:EnableMouse(false)
	end

	-- [MicroButtons] AchievementMicroButton
	AchievementMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	AchievementMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	AchievementMicroButton:ClearAllPoints()
	AchievementMicroButton:SetFrameStrata("MEDIUM")
	AchievementMicroButton:SetFrameLevel(3)
	AchievementMicroButton:SetNormalAtlas("hud-microbutton-Achievement-Up")
	AchievementMicroButton:SetPushedAtlas("hud-microbutton-Achievement-Down")
	AchievementMicroButton:SetDisabledAtlas("hud-microbutton-Achievement-Disabled")
	AchievementMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	AchievementMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	AchievementMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.iconMicroButton].normalTexture)
	AchievementMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.iconMicroButton].pushedTexture)
	AchievementMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.iconMicroButton].disabledTexture)
	AchievementMicroButton:GetDisabledTexture():SetDesaturated(true)
	AchievementMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	AchievementMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	AchievementMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	AchievementMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	AchievementMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	AchievementMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	AchievementMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	AchievementMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	AchievementMicroButton.Background:Hide()
	AchievementMicroButton.Background:SetAlpha(0)
	AchievementMicroButton.PushedBackground:Hide()
	AchievementMicroButton.PushedBackground:SetAlpha(0)
	AchievementMicroButton.FlashBorder:SetAtlas(nil)
	AchievementMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	AchievementMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	AchievementMicroButton.FlashBorder:SetBlendMode("ADD")
	AchievementMicroButton.FlashBorder:ClearAllPoints()
	AchievementMicroButton.FlashBorder:SetSize(34, 44)
	AchievementMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	AchievementMicroButton.FlashBorder:SetPoint("TOPLEFT", AchievementMicroButton, "TOPLEFT", -2, 3)
	hooksecurefunc(AchievementMicroButton, "SetPushed", ClassicUI.hook_MicroButtonSetStateFunc)
	hooksecurefunc(AchievementMicroButton, "SetNormal", ClassicUI.hook_MicroButtonSetStateFunc)
	AchievementMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.AchievementMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_AchievementMicroButton_OnEnableOnDisable) then
			AchievementMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			AchievementMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_AchievementMicroButton_OnEnableOnDisable = true
		end
		if (AchievementMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(AchievementMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(AchievementMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.hideMicroButton) then
		AchievementMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(AchievementMicroButton)
	ClassicUI.hook_AchievementMicroButton_UpdateMicroButton = function(self)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_AchievementMicroButton_disableMicroButton) then	-- cached db value
			self:Disable()
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.disableMicroButton) then
		if not(ClassicUI.hooked_AchievementMicroButton_UpdateMicroButton) then
			hooksecurefunc(AchievementMicroButton, "UpdateMicroButton", ClassicUI.hook_AchievementMicroButton_UpdateMicroButton)
			ClassicUI.hooked_AchievementMicroButton_UpdateMicroButton = true
		end
		AchievementMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.disableMouseMicroButton) then
		AchievementMicroButton:EnableMouse(false)
	end

	-- [MicroButtons] QuestLogMicroButton
	QuestLogMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	QuestLogMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	QuestLogMicroButton:SetFrameStrata("MEDIUM")
	QuestLogMicroButton:SetFrameLevel(3)
	QuestLogMicroButton:SetNormalAtlas("hud-microbutton-Quest-Up")
	QuestLogMicroButton:SetPushedAtlas("hud-microbutton-Quest-Down")
	QuestLogMicroButton:SetDisabledAtlas("hud-microbutton-Quest-Disabled")
	QuestLogMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	QuestLogMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.iconMicroButton].normalTexture)
	QuestLogMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.iconMicroButton].pushedTexture)
	QuestLogMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.iconMicroButton].disabledTexture)
	QuestLogMicroButton:GetDisabledTexture():SetDesaturated(true)
	QuestLogMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	QuestLogMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	QuestLogMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	QuestLogMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	QuestLogMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	QuestLogMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	QuestLogMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	QuestLogMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	QuestLogMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	QuestLogMicroButton.Background:Hide()
	QuestLogMicroButton.Background:SetAlpha(0)
	QuestLogMicroButton.PushedBackground:Hide()
	QuestLogMicroButton.PushedBackground:SetAlpha(0)
	QuestLogMicroButton.FlashBorder:SetAtlas(nil)
	QuestLogMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	QuestLogMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	QuestLogMicroButton.FlashBorder:SetBlendMode("ADD")
	QuestLogMicroButton.FlashBorder:ClearAllPoints()
	QuestLogMicroButton.FlashBorder:SetSize(34, 44)
	QuestLogMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	QuestLogMicroButton.FlashBorder:SetPoint("TOPLEFT", QuestLogMicroButton, "TOPLEFT", -2, 3)
	hooksecurefunc(QuestLogMicroButton, "SetPushed", ClassicUI.hook_MicroButtonSetStateFunc)
	hooksecurefunc(QuestLogMicroButton, "SetNormal", ClassicUI.hook_MicroButtonSetStateFunc)
	QuestLogMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.QuestLogMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_QuestLogMicroButton_OnEnableOnDisable) then
			QuestLogMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			QuestLogMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_QuestLogMicroButton_OnEnableOnDisable = true
		end
		if (QuestLogMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(QuestLogMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(QuestLogMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.hideMicroButton) then
		QuestLogMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(QuestLogMicroButton)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.disableMicroButton) then
		QuestLogMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.disableMouseMicroButton) then
		QuestLogMicroButton:EnableMouse(false)
	end

	-- [MicroButtons] HousingMicroButton
	HousingMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	HousingMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	HousingMicroButton:ClearAllPoints()
	HousingMicroButton:SetFrameStrata("MEDIUM")
	HousingMicroButton:SetFrameLevel(3)
	HousingMicroButton:SetNormalAtlas("hud-microbutton-Character-Up")
	HousingMicroButton:SetPushedAtlas("hud-microbutton-Character-Down")
	HousingMicroButton:SetDisabledAtlas("hud-microbutton-Character-Disabled")
	HousingMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	HousingMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	HousingMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.iconMicroButton].normalTexture)
	HousingMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.iconMicroButton].pushedTexture)
	HousingMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.iconMicroButton].disabledTexture)
	HousingMicroButton:GetDisabledTexture():SetDesaturated(true)
	HousingMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	HousingMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	HousingMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	HousingMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	HousingMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	HousingMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	HousingMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	HousingMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	HousingMicroButton.Background:Hide()
	HousingMicroButton.Background:SetAlpha(0)
	HousingMicroButton.PushedBackground:Hide()
	HousingMicroButton.PushedBackground:SetAlpha(0)
	HousingMicroButton.FlashBorder:SetAtlas(nil)
	HousingMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	HousingMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	HousingMicroButton.FlashBorder:SetBlendMode("ADD")
	HousingMicroButton.FlashBorder:ClearAllPoints()
	HousingMicroButton.FlashBorder:SetSize(34, 44)
	HousingMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	HousingMicroButton.FlashBorder:SetPoint("TOPLEFT", HousingMicroButton, "TOPLEFT", -2, 3)
	HousingMicroButton.NotificationOverlay:SetFrameStrata("MEDIUM")
	HousingMicroButton.NotificationOverlay:SetFrameLevel(500)
	HousingMicroButton.CUI_NotificationOverlay = CreateFrame("Frame", "HousingMicroButton_CUI_NotificationOverlay", HousingMicroButton)
	HousingMicroButton.CUI_NotificationOverlay:SetFrameStrata("MEDIUM")
	HousingMicroButton.CUI_NotificationOverlay:SetFrameLevel(500)
	HousingMicroButton.CUI_NotificationOverlay:ClearAllPoints()
	HousingMicroButton.CUI_NotificationOverlay:SetAllPoints(HousingMicroButton)
	HousingMicroButton.CUI_NotificationOverlay:CreateTexture("HousingMicroButton_CUI_NotificationOverlay_UnreadNotificationIcon", "OVERLAY")
	HousingMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon = HousingMicroButton_CUI_NotificationOverlay_UnreadNotificationIcon
	HousingMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetAtlas("hud-microbutton-communities-icon-notification")
	HousingMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetSize(18, 18)
	HousingMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:ClearAllPoints()
	HousingMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetPoint("CENTER", HousingMicroButton.CUI_NotificationOverlay, "TOP", 0, -5)
	ClassicUI.hook_HousingMicroButton_HousingTutorialsNewPipMixin_Init = function(self)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_HousingMicroButton_classicNotificationMicroButton) then	-- cached db value
			HousingMicroButton.NotificationOverlay:SetShown(false)
			HousingMicroButton.CUI_NotificationOverlay:SetShown(true)
		end
	end
	ClassicUI.hook_HousingMicroButton_HousingTutorialsNewPipMixin_OnHousingDashboardToggled = function(self)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_HousingMicroButton_classicNotificationMicroButton) then	-- cached db value
			HousingMicroButton.NotificationOverlay:SetShown(false)
			if HousingDashboardFrame:IsShown() then
				HousingMicroButton.CUI_NotificationOverlay:SetShown(false)
			end
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.classicNotificationMicroButton) then
		if not(ClassicUI.hooked_HousingMicroButton_HousingTutorialsNewPipMixin_Init) then
			hooksecurefunc(HousingTutorialsNewPipMixin, "Init", ClassicUI.hook_HousingMicroButton_HousingTutorialsNewPipMixin_Init)
			ClassicUI.hooked_HousingMicroButton_HousingTutorialsNewPipMixin_Init = true
		end
		if not(ClassicUI.hooked_HousingMicroButton_HousingTutorialsNewPipMixin_OnHousingDashboardToggled) then
			hooksecurefunc(HousingTutorialsNewPipMixin, "OnHousingDashboardToggled", ClassicUI.hook_HousingMicroButton_HousingTutorialsNewPipMixin_OnHousingDashboardToggled)
			ClassicUI.hooked_HousingMicroButton_HousingTutorialsNewPipMixin_OnHousingDashboardToggled = true
		end
		HousingMicroButton.CUI_NotificationOverlay:SetShown(HousingMicroButton.NotificationOverlay:IsShown())
		HousingMicroButton.NotificationOverlay:SetAlpha(0)
		HousingMicroButton.NotificationOverlay:Hide()
	else
		HousingMicroButton.CUI_NotificationOverlay:SetAlpha(0)
		HousingMicroButton.CUI_NotificationOverlay:Hide()
	end
	hooksecurefunc(HousingMicroButton, "SetPushed", ClassicUI.hook_MicroButtonSetStateFunc)
	hooksecurefunc(HousingMicroButton, "SetNormal", ClassicUI.hook_MicroButtonSetStateFunc)
	HousingMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.HousingMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_HousingMicroButton_OnEnableOnDisable) then
			HousingMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			HousingMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_HousingMicroButton_OnEnableOnDisable = true
		end
		if (HousingMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(HousingMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(HousingMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.hideMicroButton) then
		HousingMicroButton:Hide()
	else
		if (PlayerIsTimerunning() and not(HousingMicroButton:IsShown())) then
			HousingMicroButton:Show()
		end
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(HousingMicroButton)
	ClassicUI.hook_HousingMicroButton_UpdateMicroButton = function(self)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_HousingMicroButton_disableMicroButton) then	-- cached db value
			self:Disable()
		end
		if (PlayerIsTimerunning()) then
			if not(self:IsShown()) and not(ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.hideMicroButton) and not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[HousingMicroButton]) then
				self:Show()
			end
			self:Disable()
		end
	end
	if not(ClassicUI.hooked_HousingMicroButton_UpdateMicroButton) then
		hooksecurefunc(HousingMicroButton, "UpdateMicroButton", ClassicUI.hook_HousingMicroButton_UpdateMicroButton)
		ClassicUI.hooked_HousingMicroButton_UpdateMicroButton = true
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.disableMicroButton or PlayerIsTimerunning()) then
		HousingMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.disableMouseMicroButton) then
		HousingMicroButton:EnableMouse(false)
	end

	-- [MicroButtons] GuildMicroButton
	GuildMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	GuildMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	GuildMicroButton:SetFrameStrata("MEDIUM")
	GuildMicroButton:SetFrameLevel(3)
	GuildMicroButton:SetNormalAtlas("hud-microbutton-Socials-Up")
	GuildMicroButton:SetPushedAtlas("hud-microbutton-Socials-Down")
	GuildMicroButton:SetDisabledAtlas("hud-microbutton-Socials-Disabled")
	GuildMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	GuildMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].normalTexture)
	GuildMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].pushedTexture)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton == 7 or ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton == 8) then
		if IsInGuild() then
			GuildMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].disabledTextureGuild)
		else
			GuildMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].disabledTexture)
		end
	else
		GuildMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].disabledTexture)
	end
	GuildMicroButton:GetDisabledTexture():SetDesaturated(true)
	GuildMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	GuildMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	GuildMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	GuildMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	GuildMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	GuildMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	GuildMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	GuildMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	GuildMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	GuildMicroButton.Background:Hide()
	GuildMicroButton.Background:SetAlpha(0)
	GuildMicroButton.PushedBackground:Hide()
	GuildMicroButton.PushedBackground:SetAlpha(0)
	GuildMicroButton.FlashBorder:SetAtlas(nil)
	GuildMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	GuildMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	GuildMicroButton.FlashBorder:SetBlendMode("ADD")
	GuildMicroButton.FlashBorder:ClearAllPoints()
	GuildMicroButton.FlashBorder:SetSize(34, 44)
	GuildMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	GuildMicroButton.FlashBorder:SetPoint("TOPLEFT", GuildMicroButton, "TOPLEFT", -2, 3)
	GuildMicroButton.NotificationOverlay:SetFrameStrata("MEDIUM")
	GuildMicroButton.NotificationOverlay:SetFrameLevel(500)
	GuildMicroButton.CUI_NotificationOverlay = CreateFrame("Frame", "GuildMicroButton_CUI_NotificationOverlay", GuildMicroButton)
	GuildMicroButton.CUI_NotificationOverlay:SetFrameStrata("MEDIUM")
	GuildMicroButton.CUI_NotificationOverlay:SetFrameLevel(500)
	GuildMicroButton.CUI_NotificationOverlay:ClearAllPoints()
	GuildMicroButton.CUI_NotificationOverlay:SetAllPoints(GuildMicroButton)
	GuildMicroButton.CUI_NotificationOverlay:CreateTexture("GuildMicroButton_CUI_NotificationOverlay_UnreadNotificationIcon", "OVERLAY")
	GuildMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon = GuildMicroButton_CUI_NotificationOverlay_UnreadNotificationIcon
	GuildMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetAtlas("hud-microbutton-communities-icon-notification")
	GuildMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetSize(18, 18)
	GuildMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:ClearAllPoints()
	GuildMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetPoint("CENTER", GuildMicroButton.CUI_NotificationOverlay, "TOP", 0, -5)
	ClassicUI.hook_GuildMicroButton_UpdateNotificationIcon = function(self)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_classicNotificationMicroButton) then	-- cached db value
			self.NotificationOverlay:SetShown(false)
			if CommunitiesFrame_IsEnabled() and self:IsEnabled() then
				self.CUI_NotificationOverlay:SetShown(C_SocialRestrictions_CanReceiveChat() and (self:HasUnseenInvitations() or CommunitiesUtil_DoesAnyCommunityHaveUnreadMessages()))
			else
				self.CUI_NotificationOverlay:SetShown(false)
			end
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.classicNotificationMicroButton) then
		if not(ClassicUI.hooked_GuildMicroButton_UpdateNotificationIcon) then
			hooksecurefunc(GuildMicroButton, "UpdateNotificationIcon", ClassicUI.hook_GuildMicroButton_UpdateNotificationIcon)
			ClassicUI.hooked_GuildMicroButton_UpdateNotificationIcon = true
		end
		GuildMicroButton.CUI_NotificationOverlay:SetShown(GuildMicroButton.NotificationOverlay:IsShown())
		GuildMicroButton.NotificationOverlay:SetAlpha(0)
		GuildMicroButton.NotificationOverlay:Hide()
	else
		GuildMicroButton.CUI_NotificationOverlay:SetAlpha(0)
		GuildMicroButton.CUI_NotificationOverlay:Hide()
	end
	GuildMicroButton.Emblem:Hide()
	GuildMicroButton.Emblem:SetAlpha(0)
	GuildMicroButton.HighlightEmblem:Hide()
	GuildMicroButton.HighlightEmblem:SetAlpha(0)
	hooksecurefunc(GuildMicroButton, "SetPushed", ClassicUI.hook_MicroButtonSetStateFunc)
	hooksecurefunc(GuildMicroButton, "SetNormal", ClassicUI.hook_MicroButtonSetStateFunc)
	GuildMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.GuildMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_GuildMicroButton_OnEnableOnDisable) then
			GuildMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			GuildMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_GuildMicroButton_OnEnableOnDisable = true
		end
		if (GuildMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(GuildMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(GuildMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.hideMicroButton) then
		GuildMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(GuildMicroButton)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.disableMicroButton) then
		GuildMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.disableMouseMicroButton) then
		GuildMicroButton:EnableMouse(false)
	end

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
	if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton ~= 8) then
		GuildMicroButtonTabardEmblem:SetSize(14, 14)
	else
		GuildMicroButtonTabardEmblem:SetSize(16, 16)
	end
	GuildMicroButtonTabardEmblem:SetPoint("CENTER", GuildMicroButtonTabard, "CENTER", 0, 0)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton ~= 7 and ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton ~= 8) then
		GuildMicroButtonTabardEmblem:SetAlpha(0)
		GuildMicroButtonTabardEmblem:Hide()
		GuildMicroButtonTabardBackground:SetAlpha(0)
		GuildMicroButtonTabardBackground:Hide()
		GuildMicroButtonTabard:SetAlpha(0)
		GuildMicroButtonTabard:Hide()
	end

	ClassicUI.GuildMicroButton_UpdateTabard = function(forceUpdate)
		local button = GuildMicroButton
		if (not(forceUpdate) and (button:GetNormalTexture():GetAtlas() == nil)) then
			return
		end
		button.Emblem:Hide()
		button.Emblem:SetAlpha(0)
		button.HighlightEmblem:Hide()
		button.HighlightEmblem:SetAlpha(0)
		button:SetNormalAtlas("hud-microbutton-Socials-Up")
		button:SetPushedAtlas("hud-microbutton-Socials-Down")
		button:SetDisabledAtlas("hud-microbutton-Socials-Disabled")
		button:SetHighlightAtlas("hud-microbutton-highlight")
		button:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
		button:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
		button:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
		button:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
		button:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
		button:GetNormalTexture():SetVertexColor(1, 1, 1)
		button:GetPushedTexture():SetVertexColor(1, 1, 1)
		button:GetDisabledTexture():SetVertexColor(1, 1, 1)
		button:GetHighlightTexture():SetVertexColor(1, 1, 1)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton == 7 or ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton == 8) then	-- cached db value
			local emblemFilename = select(10, GetGuildLogoInfo())
			local tabard = GuildMicroButtonTabard
			if (emblemFilename) then
				button:SetNormalTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_normalTextureGuild)	-- cached db value
				button:SetPushedTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_pushedTextureGuild)	-- cached db value
				if (not tabard:IsShown()) then
					tabard:Show()
				end
				SetSmallGuildTabardTextures("player", tabard.emblem, tabard.background)
			else
				button:SetNormalTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_normalTexture)	-- cached db value
				button:SetPushedTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_pushedTexture)	-- cached db value
				if (tabard:IsShown()) then
					tabard:Hide()
				end
			end
			if IsInGuild() then
				button:SetDisabledTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_disabledTextureGuild)	-- cached db value
			else
				button:SetDisabledTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_disabledTexture)	-- cached db value
			end
		else
			button:SetNormalTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_normalTexture)	-- cached db value
			button:SetPushedTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_pushedTexture)	-- cached db value
			button:SetDisabledTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_disabledTexture)	-- cached db value
		end
	end

	hooksecurefunc(GuildMicroButton, "UpdateMicroButton", function(self)
		ClassicUI.GuildMicroButton_UpdateTabard()
		local factionGroup = UnitFactionGroup("player")
		if not(IsCommunitiesUIDisabledByTrialAccount() or factionGroup == "Neutral" or Kiosk_IsEnabled()) and
			not(C_Club_IsEnabled() and not BNConnected()) and
			not(C_Club_IsEnabled() and C_Club_IsRestricted() ~= Enum.ClubRestrictionReason.None) and
				(CommunitiesFrame and CommunitiesFrame:IsShown()) or (GuildFrame and GuildFrame:IsShown()) then
			GuildMicroButtonTabard:SetPoint("TOPLEFT", -1, -2)
			GuildMicroButtonTabard:SetAlpha(0.70)
		else
			GuildMicroButtonTabard:SetPoint("TOPLEFT", 0, 0)
			GuildMicroButtonTabard:SetAlpha(1)
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_disableMicroButton) then	-- cached db value
			self:Disable()
		end
	end)

	ClassicUI.GuildMicroButton_UpdateTabard(true)

	-- [MicroButtons] LFDMicroButton
	LFDMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	LFDMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	LFDMicroButton:SetFrameStrata("MEDIUM")
	LFDMicroButton:SetFrameLevel(3)
	LFDMicroButton:SetNormalAtlas("hud-microbutton-LFG-Up")
	LFDMicroButton:SetPushedAtlas("hud-microbutton-LFG-Down")
	LFDMicroButton:SetDisabledAtlas("hud-microbutton-LFG-Disabled")
	LFDMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	LFDMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	LFDMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.iconMicroButton].normalTexture)
	LFDMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.iconMicroButton].pushedTexture)
	LFDMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.iconMicroButton].disabledTexture)
	LFDMicroButton:GetDisabledTexture():SetDesaturated(true)
	LFDMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	LFDMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	LFDMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	LFDMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	LFDMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	LFDMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	LFDMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	LFDMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	LFDMicroButton.Background:Hide()
	LFDMicroButton.Background:SetAlpha(0)
	LFDMicroButton.PushedBackground:Hide()
	LFDMicroButton.PushedBackground:SetAlpha(0)
	LFDMicroButton.FlashBorder:SetAtlas(nil)
	LFDMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	LFDMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	LFDMicroButton.FlashBorder:SetBlendMode("ADD")
	LFDMicroButton.FlashBorder:ClearAllPoints()
	LFDMicroButton.FlashBorder:SetSize(34, 44)
	LFDMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	LFDMicroButton.FlashBorder:SetPoint("TOPLEFT", LFDMicroButton, "TOPLEFT", -2, 3)
	hooksecurefunc(LFDMicroButton, "SetPushed", ClassicUI.hook_MicroButtonSetStateFunc)
	hooksecurefunc(LFDMicroButton, "SetNormal", ClassicUI.hook_MicroButtonSetStateFunc)
	LFDMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.LFDMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_LFDMicroButton_OnEnableOnDisable) then
			LFDMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			LFDMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_LFDMicroButton_OnEnableOnDisable = true
		end
		if (LFDMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(LFDMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(LFDMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.hideMicroButton) then
		LFDMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(LFDMicroButton)
	ClassicUI.hook_LFDMicroButton_UpdateMicroButton = function(self)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_LFDMicroButton_disableMicroButton) then	-- cached db value
			self:Disable()
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.disableMicroButton) then
		if not(ClassicUI.hooked_LFDMicroButton_UpdateMicroButton) then
			hooksecurefunc(LFDMicroButton, "UpdateMicroButton", ClassicUI.hook_LFDMicroButton_UpdateMicroButton)
			ClassicUI.hooked_LFDMicroButton_UpdateMicroButton = true
		end
		LFDMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.disableMouseMicroButton) then
		LFDMicroButton:EnableMouse(false)
	end

	-- [MicroButtons] CollectionsMicroButton
	CollectionsMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	CollectionsMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	CollectionsMicroButton:SetFrameStrata("MEDIUM")
	CollectionsMicroButton:SetFrameLevel(3)
	CollectionsMicroButton:SetNormalAtlas("hud-microbutton-Mounts-Up")
	CollectionsMicroButton:SetPushedAtlas("hud-microbutton-Mounts-Down")
	CollectionsMicroButton:SetDisabledAtlas("hud-microbutton-Mounts-Disabled")
	CollectionsMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	CollectionsMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	CollectionsMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.iconMicroButton].normalTexture)
	CollectionsMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.iconMicroButton].pushedTexture)
	CollectionsMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.iconMicroButton].disabledTexture)
	CollectionsMicroButton:GetDisabledTexture():SetDesaturated(true)
	CollectionsMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CollectionsMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CollectionsMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CollectionsMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	CollectionsMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	CollectionsMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	CollectionsMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	CollectionsMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	CollectionsMicroButton.Background:Hide()
	CollectionsMicroButton.Background:SetAlpha(0)
	CollectionsMicroButton.PushedBackground:Hide()
	CollectionsMicroButton.PushedBackground:SetAlpha(0)
	CollectionsMicroButton.FlashBorder:SetAtlas(nil)
	CollectionsMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	CollectionsMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	CollectionsMicroButton.FlashBorder:SetBlendMode("ADD")
	CollectionsMicroButton.FlashBorder:ClearAllPoints()
	CollectionsMicroButton.FlashBorder:SetSize(34, 44)
	CollectionsMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	CollectionsMicroButton.FlashBorder:SetPoint("TOPLEFT", CollectionsMicroButton, "TOPLEFT", -2, 3)
	hooksecurefunc(CollectionsMicroButton, "SetPushed", ClassicUI.hook_MicroButtonSetStateFunc)
	hooksecurefunc(CollectionsMicroButton, "SetNormal", ClassicUI.hook_MicroButtonSetStateFunc)
	CollectionsMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.CollectionsMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_CollectionsMicroButton_OnEnableOnDisable) then
			CollectionsMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			CollectionsMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_CollectionsMicroButton_OnEnableOnDisable = true
		end
		if (CollectionsMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(CollectionsMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(CollectionsMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.hideMicroButton) then
		CollectionsMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(CollectionsMicroButton)
	ClassicUI.hook_CollectionsMicroButton_UpdateMicroButton = function(self)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_CollectionsMicroButton_disableMicroButton) then	-- cached db value
			self:Disable()
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.disableMicroButton) then
		if not(ClassicUI.hooked_CollectionsMicroButton_UpdateMicroButton) then
			hooksecurefunc(CollectionsMicroButton, "UpdateMicroButton", ClassicUI.hook_CollectionsMicroButton_UpdateMicroButton)
			ClassicUI.hooked_CollectionsMicroButton_UpdateMicroButton = true
		end
		CollectionsMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.disableMouseMicroButton) then
		CollectionsMicroButton:EnableMouse(false)
	end

	-- [MicroButtons] EJMicroButton
	EJMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	EJMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	EJMicroButton:SetFrameStrata("MEDIUM")
	EJMicroButton:SetFrameLevel(3)
	EJMicroButton:SetNormalAtlas("hud-microbutton-EJ-Up")
	EJMicroButton:SetPushedAtlas("hud-microbutton-EJ-Down")
	EJMicroButton:SetDisabledAtlas("hud-microbutton-EJ-Disabled")
	EJMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	EJMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	EJMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.iconMicroButton].normalTexture)
	EJMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.iconMicroButton].pushedTexture)
	EJMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.iconMicroButton].disabledTexture)
	EJMicroButton:GetDisabledTexture():SetDesaturated(true)
	EJMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	EJMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	EJMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	EJMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	EJMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	EJMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	EJMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	EJMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	EJMicroButton.Background:Hide()
	EJMicroButton.Background:SetAlpha(0)
	EJMicroButton.PushedBackground:Hide()
	EJMicroButton.PushedBackground:SetAlpha(0)
	EJMicroButton.FlashBorder:SetAtlas(nil)
	EJMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	EJMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	EJMicroButton.FlashBorder:SetBlendMode("ADD")
	EJMicroButton.FlashBorder:ClearAllPoints()
	EJMicroButton.FlashBorder:SetSize(34, 44)
	EJMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	EJMicroButton.FlashBorder:SetPoint("TOPLEFT", EJMicroButton, "TOPLEFT", -2, 3)
	EJMicroButton.NotificationOverlay:SetFrameStrata("MEDIUM")
	EJMicroButton.NotificationOverlay:SetFrameLevel(500)
	EJMicroButton.CUI_NotificationOverlay = CreateFrame("Frame", "EJMicroButton_CUI_NotificationOverlay", EJMicroButton)
	EJMicroButton.CUI_NotificationOverlay:SetFrameStrata("MEDIUM")
	EJMicroButton.CUI_NotificationOverlay:SetFrameLevel(500)
	EJMicroButton.CUI_NotificationOverlay:ClearAllPoints()
	EJMicroButton.CUI_NotificationOverlay:SetAllPoints(EJMicroButton)
	EJMicroButton.CUI_NotificationOverlay:CreateTexture("EJMicroButton_CUI_NotificationOverlay_UnreadNotificationIcon", "OVERLAY")
	EJMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon = EJMicroButton_CUI_NotificationOverlay_UnreadNotificationIcon
	EJMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetAtlas("hud-microbutton-communities-icon-notification")
	EJMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetSize(18, 18)
	EJMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:ClearAllPoints()
	EJMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetPoint("CENTER", EJMicroButton.CUI_NotificationOverlay, "TOP", 0, -5)
	ClassicUI.hook_EJMicroButton_UpdateNotificationIcon = function(self)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_EJMicroButton_classicNotificationMicroButton) then	-- cached db value
			self.NotificationOverlay:SetShown(false)
			local show = not GetCVarBitfield("closedInfoFramesAccountWide", Enum.FrameTutorialAccount.EnconterJournalTutorialsTabSeen)
			self.CUI_NotificationOverlay:SetShown(show)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.classicNotificationMicroButton) then
		if not(ClassicUI.hooked_EJMicroButton_UpdateNotificationIcon) then
			hooksecurefunc(EJMicroButton, "UpdateNotificationIcon", ClassicUI.hook_EJMicroButton_UpdateNotificationIcon)
			ClassicUI.hooked_EJMicroButton_UpdateNotificationIcon = true
		end
		EJMicroButton.CUI_NotificationOverlay:SetShown(EJMicroButton.NotificationOverlay:IsShown())
		EJMicroButton.NotificationOverlay:SetAlpha(0)
		EJMicroButton.NotificationOverlay:Hide()
	else
		EJMicroButton.CUI_NotificationOverlay:SetAlpha(0)
		EJMicroButton.CUI_NotificationOverlay:Hide()
	end
	hooksecurefunc(EJMicroButton, "SetPushed", ClassicUI.hook_MicroButtonSetStateFunc)
	hooksecurefunc(EJMicroButton, "SetNormal", ClassicUI.hook_MicroButtonSetStateFunc)
	EJMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.EJMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_EJMicroButton_OnEnableOnDisable) then
			EJMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			EJMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_EJMicroButton_OnEnableOnDisable = true
		end
		if (EJMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(EJMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(EJMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.hideMicroButton) then
		EJMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(EJMicroButton)
	ClassicUI.hook_EJMicroButton_UpdateMicroButton = function(self)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_EJMicroButton_disableMicroButton) then	-- cached db value
			self:Disable()
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.disableMicroButton) then
		if not(ClassicUI.hooked_EJMicroButton_UpdateMicroButton) then
			hooksecurefunc(EJMicroButton, "UpdateMicroButton", ClassicUI.hook_EJMicroButton_UpdateMicroButton)
			ClassicUI.hooked_EJMicroButton_UpdateMicroButton = true
		end
		EJMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.disableMouseMicroButton) then
		EJMicroButton:EnableMouse(false)
	end

	-- [MicroButtons] HelpMicroButton
	HelpMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	HelpMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	HelpMicroButton:SetFrameStrata("MEDIUM")
	HelpMicroButton:SetFrameLevel(3)
	HelpMicroButton:SetNormalAtlas("hud-microbutton-Help-Up")
	HelpMicroButton:SetPushedAtlas("hud-microbutton-Help-Down")
	HelpMicroButton:SetDisabledAtlas("hud-microbutton-Help-Disabled")
	HelpMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	HelpMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	HelpMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.iconMicroButton].normalTexture)
	HelpMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.iconMicroButton].pushedTexture)
	HelpMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.iconMicroButton].disabledTexture)
	HelpMicroButton:GetDisabledTexture():SetDesaturated(true)
	HelpMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	HelpMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	HelpMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	HelpMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	HelpMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	HelpMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	HelpMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	HelpMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	HelpMicroButton.Background:Hide()
	HelpMicroButton.Background:SetAlpha(0)
	HelpMicroButton.PushedBackground:Hide()
	HelpMicroButton.PushedBackground:SetAlpha(0)
	HelpMicroButton.FlashBorder:SetAtlas(nil)
	HelpMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	HelpMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	HelpMicroButton.FlashBorder:SetBlendMode("ADD")
	HelpMicroButton.FlashBorder:ClearAllPoints()
	HelpMicroButton.FlashBorder:SetSize(34, 44)
	HelpMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	HelpMicroButton.FlashBorder:SetPoint("TOPLEFT", HelpMicroButton, "TOPLEFT", -2, 3)
	hooksecurefunc(HelpMicroButton, "SetPushed", ClassicUI.hook_MicroButtonSetStateFunc)
	hooksecurefunc(HelpMicroButton, "SetNormal", ClassicUI.hook_MicroButtonSetStateFunc)
	HelpMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.HelpMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_HelpMicroButton_OnEnableOnDisable) then
			HelpMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			HelpMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_HelpMicroButton_OnEnableOnDisable = true
		end
		if (HelpMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(HelpMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(HelpMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.hideMicroButton) then
		HelpMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(HelpMicroButton)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.disableMicroButton) then
		HelpMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.disableMouseMicroButton) then
		HelpMicroButton:EnableMouse(false)
	end
	-- This button is generally unused, since 'MainMenuMicroButton' is used instead

	-- [MicroButtons] StoreMicroButton
	StoreMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	StoreMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	StoreMicroButton:SetFrameStrata("MEDIUM")
	StoreMicroButton:SetFrameLevel(3)
	StoreMicroButton:SetNormalAtlas("hud-microbutton-BStore-Up")
	StoreMicroButton:SetPushedAtlas("hud-microbutton-BStore-Down")
	StoreMicroButton:SetDisabledAtlas("hud-microbutton-BStore-Disabled")
	StoreMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	StoreMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	StoreMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.iconMicroButton].normalTexture)
	StoreMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.iconMicroButton].pushedTexture)
	StoreMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.iconMicroButton].disabledTexture)
	StoreMicroButton:GetDisabledTexture():SetDesaturated(true)
	StoreMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	StoreMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	StoreMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	StoreMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	StoreMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	StoreMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	StoreMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	StoreMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	StoreMicroButton.Background:Hide()
	StoreMicroButton.Background:SetAlpha(0)
	StoreMicroButton.PushedBackground:Hide()
	StoreMicroButton.PushedBackground:SetAlpha(0)
	StoreMicroButton.FlashBorder:SetAtlas(nil)
	StoreMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	StoreMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	StoreMicroButton.FlashBorder:SetBlendMode("ADD")
	StoreMicroButton.FlashBorder:ClearAllPoints()
	StoreMicroButton.FlashBorder:SetSize(34, 44)
	StoreMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	StoreMicroButton.FlashBorder:SetPoint("TOPLEFT", StoreMicroButton, "TOPLEFT", -2, 3)
	hooksecurefunc(StoreMicroButton, "SetPushed", ClassicUI.hook_MicroButtonSetStateFunc)
	hooksecurefunc(StoreMicroButton, "SetNormal", ClassicUI.hook_MicroButtonSetStateFunc)
	StoreMicroButton:HookScript("OnEnter", ClassicUI.hookscript_MicroButtonOnEnter)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.StoreMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_StoreMicroButton_OnEnableOnDisable) then
			StoreMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			StoreMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_StoreMicroButton_OnEnableOnDisable = true
		end
		if (StoreMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(StoreMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(StoreMicroButton)
		end
	end
	ClassicUI.hook_StoreMicroButton_UpdateMicroButton = function(self)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_StoreMicroButton_hideMicroButton or ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[self]) then	-- cached db value
			self:Hide()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_StoreMicroButton_disableMicroButton) then	-- cached db value
			self:Disable()
		end
		if ( C_CatalogShop_IsShop2Enabled() and not( CatalogShopFrame and CatalogShopInboundInterface.IsShown() ) ) or ( not(C_CatalogShop_IsShop2Enabled()) and not( StoreFrame and StoreFrame_IsShown() ) ) then
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_CharacterMicroButton_disableMicroButton) then	-- cached db value
				CharacterMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_ProfessionMicroButton_disableMicroButton) then	-- cached db value
				ProfessionMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_disableMicroButton) then	-- cached db value
				PlayerSpellsMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_QuestLogMicroButton_disableMicroButton) then	-- cached db value
				QuestLogMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_HousingMicroButton_disableMicroButton) then	-- cached db value
				HousingMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_disableMicroButton) then	-- cached db value
				GuildMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_LFDMicroButton_disableMicroButton) then	-- cached db value
				LFDMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_AchievementMicroButton_disableMicroButton) then	-- cached db value
				AchievementMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_EJMicroButton_disableMicroButton) then	-- cached db value
				EJMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_CollectionsMicroButton_disableMicroButton) then	-- cached db value
				CollectionsMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_disableMicroButton) then	-- cached db value
				MainMenuMicroButton:Disable()
			end
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.hideMicroButton) then
		StoreMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(StoreMicroButton)
	hooksecurefunc(StoreMicroButton, "UpdateMicroButton", ClassicUI.hook_StoreMicroButton_UpdateMicroButton)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.disableMicroButton) then
		StoreMicroButton:Disable()
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.disableMouseMicroButton) then
		StoreMicroButton:EnableMouse(false)
	end

	-- [MicroButtons] MainMenuMicroButton
	MainMenuMicroButton:SetParent(CUI_MainMenuBarArtFrame)
	MainMenuMicroButton:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
	MainMenuMicroButton:SetFrameStrata("MEDIUM")
	MainMenuMicroButton:SetFrameLevel(3)
	MainMenuMicroButton:SetNormalAtlas("hud-microbutton-MainMenu-Up")
	MainMenuMicroButton:SetPushedAtlas("hud-microbutton-MainMenu-Down")
	MainMenuMicroButton:SetDisabledAtlas("hud-microbutton-MainMenu-Disabled")
	MainMenuMicroButton:SetHighlightAtlas("hud-microbutton-highlight")
	MainMenuMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton].normalTexture)
	MainMenuMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton].pushedTexture)
	MainMenuMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton].disabledTexture)
	if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton == 25) then	-- Classic Perf-MM Icon
		ClassicUI.CreateMainMenuBarPerformanceBar2Texture(MainMenuMicroButton)
	end
	MainMenuMicroButton:GetDisabledTexture():SetDesaturated(true)
	MainMenuMicroButton:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
	MainMenuMicroButton:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	MainMenuMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	MainMenuMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	MainMenuMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
	MainMenuMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	MainMenuMicroButton:GetPushedTexture():SetVertexColor(1, 1, 1)
	MainMenuMicroButton:GetDisabledTexture():SetVertexColor(1, 1, 1)
	MainMenuMicroButton:GetHighlightTexture():SetVertexColor(1, 1, 1)
	MainMenuMicroButton.Background:Hide()
	MainMenuMicroButton.Background:SetAlpha(0)
	MainMenuMicroButton.PushedBackground:Hide()
	MainMenuMicroButton.PushedBackground:SetAlpha(0)
	MainMenuMicroButton.FlashBorder:SetAtlas(nil)
	MainMenuMicroButton.FlashBorder:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\UI-MicroButton-FlashBorderHilight")
	MainMenuMicroButton.FlashBorder:SetTexCoord(0/128, 66/128, 0/128, 80/128)
	MainMenuMicroButton.FlashBorder:SetBlendMode("ADD")
	MainMenuMicroButton.FlashBorder:ClearAllPoints()
	MainMenuMicroButton.FlashBorder:SetSize(34, 44)
	MainMenuMicroButton.FlashBorder:SetDrawLayer("OVERLAY", 0)
	MainMenuMicroButton.FlashBorder:SetPoint("TOPLEFT", MainMenuMicroButton, "TOPLEFT", -2, 3)
	MainMenuMicroButton.NotificationOverlay:SetFrameStrata("MEDIUM")
	MainMenuMicroButton.NotificationOverlay:SetFrameLevel(500)
	MainMenuMicroButton.CUI_NotificationOverlay = CreateFrame("Frame", "MainMenuMicroButton_CUI_NotificationOverlay", MainMenuMicroButton)
	MainMenuMicroButton.CUI_NotificationOverlay:SetFrameStrata("MEDIUM")
	MainMenuMicroButton.CUI_NotificationOverlay:SetFrameLevel(500)
	MainMenuMicroButton.CUI_NotificationOverlay:ClearAllPoints()
	MainMenuMicroButton.CUI_NotificationOverlay:SetAllPoints(MainMenuMicroButton)
	MainMenuMicroButton.CUI_NotificationOverlay:CreateTexture("MainMenuMicroButton_CUI_NotificationOverlay_UnreadNotificationIcon", "OVERLAY")
	MainMenuMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon = MainMenuMicroButton_CUI_NotificationOverlay_UnreadNotificationIcon
	MainMenuMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetAtlas("hud-microbutton-communities-icon-notification")
	MainMenuMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetSize(18, 18)
	MainMenuMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:ClearAllPoints()
	MainMenuMicroButton.CUI_NotificationOverlay.UnreadNotificationIcon:SetPoint("CENTER", MainMenuMicroButton.CUI_NotificationOverlay, "TOP", 0, -5)
	ClassicUI.hook_MainMenuMicroButton_UpdateNotificationIcon = function(self)
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_classicNotificationMicroButton) then	-- cached db value
			self.NotificationOverlay:SetShown(false)
			local needEditModeNotification = EditModeManagerFrame:CanEnterEditMode() and EditModeManagerFrame.Tutorial:HasHelptipsToShow()
			self.CUI_NotificationOverlay:SetShown(needEditModeNotification or CurrentVersionHasNewUnseenSettings())
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.classicNotificationMicroButton) then
		if not(ClassicUI.hooked_MainMenuMicroButton_UpdateNotificationIcon) then
			hooksecurefunc(MainMenuMicroButton, "UpdateNotificationIcon", ClassicUI.hook_MainMenuMicroButton_UpdateNotificationIcon)
			ClassicUI.hooked_MainMenuMicroButton_UpdateNotificationIcon = true
		end
		MainMenuMicroButton.CUI_NotificationOverlay:SetShown(MainMenuMicroButton.NotificationOverlay:IsShown())
		MainMenuMicroButton.NotificationOverlay:SetAlpha(0)
		MainMenuMicroButton.NotificationOverlay:Hide()
	else
		MainMenuMicroButton.CUI_NotificationOverlay:SetAlpha(0)
		MainMenuMicroButton.CUI_NotificationOverlay:Hide()
	end
	hooksecurefunc(MainMenuMicroButton, "SetPushed", function(self)
		ClassicUI.hook_MicroButtonSetStateFunc(self)
		if (self.MainMenuBarPerformanceBar2 ~= nil) then
			self.MainMenuBarPerformanceBar2:SetPoint("TOPLEFT", self, "TOPLEFT", 8.75, -15.45)
		end
	end)
	hooksecurefunc(MainMenuMicroButton, "SetNormal", function(self)
		ClassicUI.hook_MicroButtonSetStateFunc(self)
		if (self.MainMenuBarPerformanceBar2 ~= nil) then
			self.MainMenuBarPerformanceBar2:SetPoint("TOPLEFT", self, "TOPLEFT", 9.6, -13.5)
		end
	end)
	if (mathabs(ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.MainMenuMicroButton.alphaMicroButton) > STANDARD_EPSILON) then
		if not(ClassicUI.hooked_MainMenuMicroButton_OnEnableOnDisable) then
			MainMenuMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
			MainMenuMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
			ClassicUI.hooked_MainMenuMicroButton_OnEnableOnDisable = true
		end
		if (MainMenuMicroButton:IsEnabled()) then
			ClassicUI.hookscript_MicroButtonOnEnable(MainMenuMicroButton)
		else
			ClassicUI.hookscript_MicroButtonOnDisable(MainMenuMicroButton)
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.hideMicroButton) then
		MainMenuMicroButton:Hide()
	end
	ClassicUI.HookMicroButtonsClass_UI_Watcher(MainMenuMicroButton)
	ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton = function(self)
		if not( ( GameMenuFrame and GameMenuFrame:IsShown() ) or ( SettingsPanel:IsShown()) or ( KeyBindingFrame and KeyBindingFrame:IsShown()) or ( MacroFrame and MacroFrame:IsShown()) ) then
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_disableMicroButton) then	-- cached db value
				self:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_CharacterMicroButton_disableMicroButton) then	-- cached db value
				CharacterMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_ProfessionMicroButton_disableMicroButton) then	-- cached db value
				ProfessionMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_disableMicroButton) then	-- cached db value
				PlayerSpellsMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_QuestLogMicroButton_disableMicroButton) then	-- cached db value
				QuestLogMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_HousingMicroButton_disableMicroButton) then	-- cached db value
				HousingMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_disableMicroButton) then	-- cached db value
				GuildMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_LFDMicroButton_disableMicroButton) then	-- cached db value
				LFDMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_AchievementMicroButton_disableMicroButton) then	-- cached db value
				AchievementMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_EJMicroButton_disableMicroButton) then	-- cached db value
				EJMicroButton:Disable()
			end
			if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_CollectionsMicroButton_disableMicroButton) then	-- cached db value
				CollectionsMicroButton:Disable()
			end
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.disableMicroButton) or (ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.disableMicroButton) or
		(ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.disableMicroButton) or (ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.disableMicroButton) or
		(ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.disableMicroButton) or (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.disableMicroButton) or
		(ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.disableMicroButton) or (ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.disableMicroButton) or
		(ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.disableMicroButton) or (ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.disableMicroButton) or
		(ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.disableMicroButton) then
		if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
			hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
			ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
		end
		if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.disableMicroButton) then
			MainMenuMicroButton:Disable()
		end
	end
	if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.disableMouseMicroButton) then
		MainMenuMicroButton:EnableMouse(false)
	end

	if (MainMenuMicroButton.MainMenuBarPerformanceBar ~= nil) then
		MainMenuMicroButton.MainMenuBarPerformanceBar:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
		MainMenuMicroButton.MainMenuBarPerformanceBar:SetTexCoord(0/32, 32/32, 22/64, 64/64)
		MainMenuMicroButton.MainMenuBarPerformanceBar:SetPoint("BOTTOM", MainMenuMicroButton, "BOTTOM", 0, 0)
		if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.hideLatencyBar) then
			MainMenuMicroButton.MainMenuBarPerformanceBar:SetAlpha(0)
			MainMenuMicroButton.MainMenuBarPerformanceBar:Hide()
		end
	end

	local CUI_MicroButtonPulseHiddenFrame = CreateFrame("Frame", "CUI_MicroButtonPulseHiddenFrame", UIParent)
	CUI_MicroButtonPulseHiddenFrame:Hide()
	ProfessionMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)
	PlayerSpellsMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)
	AchievementMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)
	QuestLogMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)
	HousingMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)
	GuildMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)
	LFDMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)
	CollectionsMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)
	EJMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)
	HelpMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)
	StoreMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)
	MainMenuMicroButton.FlashContent:SetParent(CUI_MicroButtonPulseHiddenFrame)

	-- [MicroButtons] MainMenuMicroButton -> HelpOpenWebTicketButton
	if (HelpOpenWebTicketButton ~= nil) then
		HelpOpenWebTicketButton:SetParent(_G[ClassicUI.db.profile.barsConfig.MicroButtons.helpOpenWebTicketButtonAnchor] or MainMenuMicroButton)
		HelpOpenWebTicketButton:ClearAllPoints()
		HelpOpenWebTicketButton:SetPoint("CENTER", HelpOpenWebTicketButton:GetParent(), "TOPRIGHT", -3, -4)
		if (MicroMenu ~= nil and MicroMenu.UpdateHelpTicketButtonAnchor ~= nil) then
			hooksecurefunc(MicroMenu, "UpdateHelpTicketButtonAnchor", function(self, position)
				HelpOpenWebTicketButton:ClearAllPoints()
				HelpOpenWebTicketButton:SetPoint("CENTER", HelpOpenWebTicketButton:GetParent(), "TOPRIGHT", -3, -4)
			end)
		end
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
			if (status == 0) then
				status = (GetBackgroundLoadingStatus()~=0) and 1 or 0
			end
			self:SetSize(ClassicUI.mbWidth, ClassicUI.mbHeight)
			self:SetNormalAtlas("hud-microbutton-MainMenu-Up")
			self:SetPushedAtlas("hud-microbutton-MainMenu-Down")
			self:SetDisabledAtlas("hud-microbutton-MainMenu-Disabled")
			self:SetHighlightAtlas("hud-microbutton-highlight")
			self:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight", "ADD")
			self:GetNormalTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
			if (status == 0) then
				self:SetNormalTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton_normalTexture)	-- cached db value
				self:SetPushedTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton_pushedTexture)	-- cached db value
				self:SetDisabledTexture(ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton_disabledTexture)	-- cached db value
				self:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				self:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				self:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				if (self.MainMenuBarPerformanceBar2 ~= nil and ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton == 25) then	-- cached db value
					local _, _, latencyHome, latencyWorld = GetNetStats()
					local latency = latencyHome > latencyWorld and latencyHome or latencyWorld
					if (latency > ClassicUI.PERFORMANCEBAR_MEDIUM_LATENCY) then
						self.MainMenuBarPerformanceBar2:SetVertexColor(1, 0, 0)
					elseif (latency > ClassicUI.PERFORMANCEBAR_LOW_LATENCY) then
						self.MainMenuBarPerformanceBar2:SetVertexColor(1, 1, 0)
					else
						self.MainMenuBarPerformanceBar2:SetVertexColor(0, 1, 0)
					end
					self.MainMenuBarPerformanceBar2:Show()
				end
				CUI_MainMenuBarDownload:Hide()
			else
				self:SetNormalTexture("Interface\\Buttons\\UI-MicroButtonStreamDL-Up")
				self:SetPushedTexture("Interface\\Buttons\\UI-MicroButtonStreamDL-Down")
				self:SetDisabledTexture("Interface\\Buttons\\UI-MicroButtonStreamDL-Up")
				self:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				self:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				self:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
				if (status == 1) then
					CUI_MainMenuBarDownload:SetTexture("Interface\\Buttons\\UI-MicroStream-Green")
				elseif (status == 2) then
					CUI_MainMenuBarDownload:SetTexture("Interface\\Buttons\\UI-MicroStream-Yellow")
				elseif (status == 3) then
					CUI_MainMenuBarDownload:SetTexture("Interface\\Buttons\\UI-MicroStream-Red")
				end
				if (self.MainMenuBarPerformanceBar2 ~= nil) then
					self.MainMenuBarPerformanceBar2:Hide()
				end
				CUI_MainMenuBarDownload:Show()
			end
		end
	end)

	-- [MicroButtons] -> Extra hooks
	hooksecurefunc("MicroMenuBar_ClearFullScreenFrame", function()
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_CharacterMicroButton_disableMicroButton) then	-- cached db value
			CharacterMicroButton:Disable()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_ProfessionMicroButton_disableMicroButton) then	-- cached db value
			ProfessionMicroButton:Disable()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_disableMicroButton) then	-- cached db value
			PlayerSpellsMicroButton:Disable()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_QuestLogMicroButton_disableMicroButton) then	-- cached db value
			QuestLogMicroButton:Disable()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_HousingMicroButton_disableMicroButton) then	-- cached db value
			HousingMicroButton:Disable()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_disableMicroButton) then	-- cached db value
			GuildMicroButton:Disable()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_LFDMicroButton_disableMicroButton) then	-- cached db value
			LFDMicroButton:Disable()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_AchievementMicroButton_disableMicroButton) then	-- cached db value
			AchievementMicroButton:Disable()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_EJMicroButton_disableMicroButton) then	-- cached db value
			EJMicroButton:Disable()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_CollectionsMicroButton_disableMicroButton) then	-- cached db value
			CollectionsMicroButton:Disable()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_StoreMicroButton_disableMicroButton) then	-- cached db value
			StoreMicroButton:Disable()
		end
		if (ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_disableMicroButton) then	-- cached db value
			MainMenuMicroButton:Disable()
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
			ClassicUI.UpdateMicroButtonsParent(OverrideActionBar)
			ClassicUI.MoveMicroButtons("BOTTOMLEFT", OverrideActionBar, "BOTTOMLEFT", anchorX, anchorY, true)
		else
			ClassicUI.UpdateMicroButtonsParent(CUI_MainMenuBarArtFrame)
			ClassicUI.MoveMicroButtons("BOTTOMLEFT", CUI_MainMenuBarArtFrame, "BOTTOMLEFT", 556 + ClassicUI.db.profile.barsConfig.MicroButtons.xOffset, 2 + ClassicUI.db.profile.barsConfig.MicroButtons.yOffset, false)
			for k, _ in pairs(ClassicUI.MicroButtonsGroup) do
				k:SetScale(ClassicUI.db.profile.barsConfig.MicroButtons.scale)
			end
		end
	else
		ClassicUI.UpdateMicroButtonsParent(PetBattleFrame.BottomFrame.MicroButtonFrame)
		ClassicUI.MoveMicroButtons("TOPLEFT", PetBattleFrame.BottomFrame.MicroButtonFrame, "TOPLEFT", -11.5, 7.5, true)
	end
	ClassicUI.SetPointsMicroButtons()

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
		--self.SlotHighlightTexture:ClearAllPoints()	-- not needed
		--self.SlotHighlightTexture:SetAllPoints(self)	-- not needed

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
		hooksecurefunc(bagSlot, "SetItemButtonQuality", function(self, quality, itemIDOrLink, suppressOverlays, isBound)
			ClassicUI:TrySetBagItemButtonQuality(self, quality, itemIDOrLink, suppressOverlays, isBound)
		end)
		hooksecurefunc(bagSlot, "UpdateTextures", ClassicUI.BaseBagSlotButton_UpdateTextures)
	end
	hooksecurefunc(MainMenuBarBackpackButton, "UpdateTextures", ClassicUI.BaseBagSlotButton_UpdateTextures)
	ClassicUI.onExpandChangedMainMenuBarManager = function(self)
		MainMenuBarBackpackButton:ClearAllPoints()
		MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", CUI_MainMenuBarArtFrame, "BOTTOMRIGHT", -4, 6)
		CharacterBag0Slot:ClearAllPoints()
		CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -2, 0)
		CharacterBag1Slot:ClearAllPoints()
		CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot, "LEFT", -2, 0)
		CharacterBag2Slot:ClearAllPoints()
		CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot, "LEFT", -2, 0)
		CharacterBag3Slot:ClearAllPoints()
		CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot, "LEFT", -2, 0)
		CharacterReagentBag0Slot:ClearAllPoints()
		CharacterReagentBag0Slot:SetPoint("CENTER", CharacterBag3Slot, "LEFT", -5 + ClassicUI.cached_db_profile.barsConfig_BagsIcons_xOffsetReagentBag, -2 + ClassicUI.cached_db_profile.barsConfig_BagsIcons_yOffsetReagentBag)	-- cached db value
	end
	hooksecurefunc(BagsBar, "Layout", ClassicUI.onExpandChangedMainMenuBarManager)
	if (EventRegistry and type(EventRegistry) == "table") then
		EventRegistry:RegisterCallback("MainMenuBarManager.OnExpandChanged", ClassicUI.onExpandChangedMainMenuBarManager, BagsBar)
	end

	-- 'GetInventoryItemQuality' function seems to load asynchronously, so it can return 'nil' sometimes
	ClassicUI:TrySetBagItemButtonQuality(CharacterBag0Slot)
	ClassicUI:TrySetBagItemButtonQuality(CharacterBag1Slot)
	ClassicUI:TrySetBagItemButtonQuality(CharacterBag2Slot)
	ClassicUI:TrySetBagItemButtonQuality(CharacterBag3Slot)

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
	CharacterBag3Slot:SetParent(CUI_MainMenuBarArtFrame)
	CharacterBag3Slot:SetSize(30, 30)
	CharacterBag3Slot.IconBorder:SetSize(30, 30)
	CharacterBag3Slot:ClearAllPoints()
	CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot, "LEFT", -2, 0)
	CharacterBag3Slot:SetFrameStrata("MEDIUM")
	CharacterBag3Slot:SetFrameLevel(3)
	CharacterReagentBag0Slot:SetParent(CUI_MainMenuBarArtFrame)
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
	hooksecurefunc(CharacterBag0Slot, "SetBarExpanded", function(self, isExpanded) if not(self:IsShown()) then self:Show() end end)
	hooksecurefunc(CharacterBag1Slot, "SetBarExpanded", function(self, isExpanded) if not(self:IsShown()) then self:Show() end end)
	hooksecurefunc(CharacterBag2Slot, "SetBarExpanded", function(self, isExpanded) if not(self:IsShown()) then self:Show() end end)
	hooksecurefunc(CharacterBag3Slot, "SetBarExpanded", function(self, isExpanded) if not(self:IsShown()) then self:Show() end end)
	hooksecurefunc(CharacterReagentBag0Slot, "SetBarExpanded", function(self, isExpanded)
		CharacterReagentBag0Slot:ClearAllPoints()
		CharacterReagentBag0Slot:SetPoint("CENTER", CharacterBag3Slot, "LEFT", -5 + ClassicUI.cached_db_profile.barsConfig_BagsIcons_xOffsetReagentBag, -2 + ClassicUI.cached_db_profile.barsConfig_BagsIcons_yOffsetReagentBag)	-- cached db value
	end)
	if not(CharacterBag0Slot:IsShown()) then CharacterBag0Slot:Show() end
	if not(CharacterBag1Slot:IsShown()) then CharacterBag1Slot:Show() end
	if not(CharacterBag2Slot:IsShown()) then CharacterBag2Slot:Show() end
	if not(CharacterBag3Slot:IsShown()) then CharacterBag3Slot:Show() end
	CharacterReagentBag0Slot:ClearAllPoints()
	CharacterReagentBag0Slot:SetPoint("CENTER", CharacterBag3Slot, "LEFT", -5 + ClassicUI.db.profile.barsConfig.BagsIcons.xOffsetReagentBag, -2 + ClassicUI.db.profile.barsConfig.BagsIcons.yOffsetReagentBag)
	BagBarExpandToggle:Hide()
	MicroButtonAndBagsBar:Hide()
	MicroButtonAndBagsBar:ClearAllPoints()
	MicroButtonAndBagsBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -6, 6 + ClassicUI.MICROBUTTONANDBAGSBAR_CUI_OFFSET_Y)	-- this prevents Blizzard from rescaling MultiBarRight and MultiBarLeft in the 'UpdateRightActionBarPositions()' function

	ClassicUI:SetStrataForMainFrames()
	ClassicUI:ReLayoutMainFrames()

	--[StatusBars]
	StatusTrackingBarManager:SetParent(CUI_MainMenuBar)
	StatusTrackingBarManager:ClearAllPoints()
	StatusTrackingBarManager:SetPoint("BOTTOM", CUI_MainMenuBar, "BOTTOM", 0, 0)
	StatusTrackingBarManager:SetSize(804, 11)
	StatusTrackingBarManager.MainStatusTrackingBarContainer.BarFrameTexture:SetSize(1024, 7)
	StatusTrackingBarManager.MainStatusTrackingBarContainer:ClearAllPoints()
	StatusTrackingBarManager.MainStatusTrackingBarContainer:SetPoint("BOTTOM", CUI_MainMenuBar, "TOP", 0, -3)
	StatusTrackingBarManager.MainStatusTrackingBarContainer:Hide()
	StatusTrackingBarManager.MainStatusTrackingBarContainer.BarFrameTexture:Hide()
	for _, bar in ipairs(StatusTrackingBarManager.MainStatusTrackingBarContainer.bars) do
		bar.oriparent = bar:GetParent()
		bar:SetParent(StatusTrackingBarManager)
		tblinsert(ClassicUI.STBMbars, bar)
		tblinsert(ClassicUI.STBMMainBars, bar)
	end
	StatusTrackingBarManager.SecondaryStatusTrackingBarContainer.BarFrameTexture:SetSize(1024, 10)
	StatusTrackingBarManager.SecondaryStatusTrackingBarContainer:ClearAllPoints()
	StatusTrackingBarManager.SecondaryStatusTrackingBarContainer:SetPoint("TOP", CUI_MainMenuBar, "TOP", 0, 0)
	StatusTrackingBarManager.SecondaryStatusTrackingBarContainer:Hide()
	StatusTrackingBarManager.SecondaryStatusTrackingBarContainer.BarFrameTexture:Hide()
	for _, bar in ipairs(StatusTrackingBarManager.SecondaryStatusTrackingBarContainer.bars) do
		bar.oriparent = bar:GetParent()
		bar:SetParent(StatusTrackingBarManager)
		tblinsert(ClassicUI.STBMbars, bar)
		tblinsert(ClassicUI.STBMSecBars, bar)
	end
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_TopBarFrameTexture0", "ARTWORK")
	StatusTrackingBarManager.TopBarFrameTexture0 = StatusTrackingBarManager_TopBarFrameTexture0
	StatusTrackingBarManager.TopBarFrameTexture0:ClearAllPoints()
	StatusTrackingBarManager.TopBarFrameTexture0:SetPoint("BOTTOMLEFT", CUI_MainMenuBar, "TOPLEFT", 0, -1)
	StatusTrackingBarManager.TopBarFrameTexture0:SetTexture("Interface\\PaperDollInfoFrame\\UI-ReputationWatchBar")
	StatusTrackingBarManager.TopBarFrameTexture0:SetTexCoord(0/256, 0/256, 0/256, 44/256, 256/256, 0/256, 256/256, 44/256)
	StatusTrackingBarManager.TopBarFrameTexture0:SetSize(256, 11)
	StatusTrackingBarManager.TopBarFrameTexture0:SetDrawLayer("ARTWORK", 0)
	StatusTrackingBarManager.TopBarFrameTexture0:Hide()
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_TopBarFrameTexture1", "ARTWORK")
	StatusTrackingBarManager.TopBarFrameTexture1 = StatusTrackingBarManager_TopBarFrameTexture1
	StatusTrackingBarManager.TopBarFrameTexture1:ClearAllPoints()
	StatusTrackingBarManager.TopBarFrameTexture1:SetPoint("LEFT", StatusTrackingBarManager.TopBarFrameTexture0, "RIGHT", 0, 0)
	StatusTrackingBarManager.TopBarFrameTexture1:SetTexture("Interface\\PaperDollInfoFrame\\UI-ReputationWatchBar")
	StatusTrackingBarManager.TopBarFrameTexture1:SetTexCoord(0/256, 48/256, 0/256, 92/256, 256/256, 48/256, 256/256, 92/256)
	StatusTrackingBarManager.TopBarFrameTexture1:SetSize(256, 11)
	StatusTrackingBarManager.TopBarFrameTexture1:SetDrawLayer("ARTWORK", 0)
	StatusTrackingBarManager.TopBarFrameTexture1:Hide()
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_TopBarFrameTexture2", "ARTWORK")
	StatusTrackingBarManager.TopBarFrameTexture2 = StatusTrackingBarManager_TopBarFrameTexture2
	StatusTrackingBarManager.TopBarFrameTexture2:ClearAllPoints()
	StatusTrackingBarManager.TopBarFrameTexture2:SetPoint("LEFT", StatusTrackingBarManager.TopBarFrameTexture1, "RIGHT", 0, 0)
	StatusTrackingBarManager.TopBarFrameTexture2:SetTexture("Interface\\PaperDollInfoFrame\\UI-ReputationWatchBar")
	StatusTrackingBarManager.TopBarFrameTexture2:SetTexCoord(0/256, 96/256, 0/256, 140/256, 256/256, 96/256, 256/256, 140/256)
	StatusTrackingBarManager.TopBarFrameTexture2:SetSize(256, 11)
	StatusTrackingBarManager.TopBarFrameTexture2:SetDrawLayer("ARTWORK", 0)
	StatusTrackingBarManager.TopBarFrameTexture2:Hide()
	StatusTrackingBarManager:CreateTexture("StatusTrackingBarManager_TopBarFrameTexture3", "ARTWORK")
	StatusTrackingBarManager.TopBarFrameTexture3 = StatusTrackingBarManager_TopBarFrameTexture3
	StatusTrackingBarManager.TopBarFrameTexture3:ClearAllPoints()
	StatusTrackingBarManager.TopBarFrameTexture3:SetPoint("LEFT", StatusTrackingBarManager.TopBarFrameTexture2, "RIGHT", 0, 0)
	StatusTrackingBarManager.TopBarFrameTexture3:SetTexture("Interface\\PaperDollInfoFrame\\UI-ReputationWatchBar")
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
	for _, bar in ipairs(ClassicUI.STBMbars) do
		bar.StatusBar.GainFlareAnimationTexture:Hide()
		bar.StatusBar.LevelUpTexture:Hide()
		bar.StatusBar.AnimationMask:Hide()
		hooksecurefunc(bar.StatusBar.GainFlareAnimation, "Play", function(self)
			self:Stop()
			self:GetParent().GainFlareAnimationTexture:Hide()
		end)
		hooksecurefunc(bar.StatusBar.LevelUpRolloverAnimation, "Play", function(self)
			self:Stop()
			self:GetParent().LevelUpTexture:Hide()
		end)
		hooksecurefunc(bar.StatusBar.LevelUpMaxAnimation, "Play", function(self)
			self:Stop()
			self:GetParent().LevelUpTexture:Hide()
		end)
		hooksecurefunc(bar.StatusBar.GainFlareAnimation, "Restart", function(self)
			self:Stop()
			self:GetParent().GainFlareAnimationTexture:Hide()
		end)
		hooksecurefunc(bar.StatusBar.LevelUpRolloverAnimation, "Restart", function(self)
			self:Stop()
			self:GetParent().LevelUpTexture:Hide()
		end)
		hooksecurefunc(bar.StatusBar.LevelUpMaxAnimation, "Restart", function(self)
			self:Stop()
			self:GetParent().LevelUpTexture:Hide()
		end)
		bar.StatusBar.Background:SetColorTexture(0, 0, 0, 1.0)
		bar.StatusBar.Background:SetAlpha(0.5)
		bar:SetFixedFrameStrata(false)
		bar:SetFrameStrata("MEDIUM")
		bar:SetFrameLevel(2)
		bar:SetFixedFrameStrata(true)
		bar.StatusBar:SetFrameStrata("LOW")
		bar.StatusBar:SetFrameLevel(1)
		if (bar.GetPriority == nil) then
			bar.GetPriority = function(self)
				return self.priority
			end
		end
		if (bar.SetBarColor == nil) then
			bar.SetBarColor = function(self, r, g, b, a)
				self.StatusBar:SetStatusBarColor(r, g, b, a)
				--self.StatusBar:SetAnimatedTextureColors(r, g, b)	-- not available, 'StatusBar' no longer inherits from 'AnimatedStatusBarTemplate'
			end
		end
		if (bar.barIndex == StatusTrackingBarInfo.BarsEnum.HouseFavor) then		-- HouseFavorBar (priority = 5) (barIndex = 6)
			bar.priority = 5
			if (bar.ShouldBeVisible == nil) then
				bar.ShouldBeVisible = function(self)
					return C_Housing_GetTrackedHouseGuid()
				end
			end
			bar:SetBarColor(ARTIFACT_BAR_COLOR:GetRGB())
		elseif (bar.barIndex == StatusTrackingBarInfo.BarsEnum.Azerite) then	-- AzeriteBar (priority = 0) (barIndex = 5)
			bar.priority = 0
			if (bar.ShouldBeVisible == nil) then
				bar.ShouldBeVisible = function(self)
					local azeriteItem = C_AzeriteItem.FindActiveAzeriteItem()
					return not C_AzeriteItem.IsAzeriteItemAtMaxLevel() and azeriteItem and azeriteItem:IsEquipmentSlot() and C_AzeriteItem.IsAzeriteItemEnabled(azeriteItem)
				end
			end
			bar:SetBarColor(ARTIFACT_BAR_COLOR:GetRGB())
		elseif (bar.barIndex == StatusTrackingBarInfo.BarsEnum.Artifact) then	-- ArtifactBar (priority = 4) (barIndex = 3)
			bar.priority = 4
			if (bar.ShouldBeVisible == nil) then
				bar.ShouldBeVisible = function(self)
					return HasArtifactEquipped() and not C_ArtifactUI.IsEquippedArtifactMaxed() and not C_ArtifactUI.IsEquippedArtifactDisabled()
				end
			end
			bar:SetBarColor(ARTIFACT_BAR_COLOR:GetRGB())
		elseif (bar.barIndex == StatusTrackingBarInfo.BarsEnum.Honor) then		-- HonorBar (priority = 2) (barIndex = 2)
			bar.priority = 2
			if (bar.ShouldBeVisible == nil) then
				bar.ShouldBeVisible = function(self)
					return IsWatchingHonorAsXP() or C_PvP_IsActiveBattlefield() or IsInActiveWorldPVP()
				end
			end
			bar.StatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar", "BORDER")
			bar.StatusBar:GetStatusBarTexture():SetDrawLayer("BORDER", 0)
			bar.StatusBar:GetStatusBarTexture():SetTexCoord(0, 0, 0, 1, 0.16666667, 0, 0.16666667, 1)
			bar:SetBarColor(1.0, 0.24, 0)
		elseif (bar.barIndex == StatusTrackingBarInfo.BarsEnum.Reputation) then	-- ReputationBar (priority = 1) (barIndex = 1)
			bar.priority = 1
			if (bar.ShouldBeVisible == nil) then
				bar.ShouldBeVisible = function(self)
					local watchedFactionData = C_Reputation_GetWatchedFactionData()
					return watchedFactionData and watchedFactionData.name ~= nil and watchedFactionData.name ~= ""
				end
			end
			hooksecurefunc(bar, "Update", function(self)
				self.StatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar", "BORDER")
				self.StatusBar:GetStatusBarTexture():SetDrawLayer("BORDER", 0)
				self.StatusBar:GetStatusBarTexture():SetTexCoord(0, 0, 0, 1, 0.16666667, 0, 0.16666667, 1)
				local watchedFactionData = C_Reputation_GetWatchedFactionData()
				if (watchedFactionData ~= nil) then
					local colorIndex, factionID = watchedFactionData.reaction, watchedFactionData.factionID
					if (factionID ~= nil) and (factionID ~= 0) and not(C_Reputation_IsFactionParagon(factionID)) then
						local reputationInfo = C_GossipInfo_GetFriendshipReputation(factionID)
						if (reputationInfo ~= nil) then
							local friendshipID = reputationInfo.friendshipFactionID
							if (friendshipID > 0) then
								colorIndex = 5
							end
						end
					end
					if (colorIndex ~= nil and colorIndex > 0) then
						local color = FACTION_BAR_COLORS[colorIndex]
						if (color ~= nil) then
							self:SetBarColor(color.r, color.g, color.b, 1)
						end
					end
				end
			end)
			local watchedFactionData = C_Reputation_GetWatchedFactionData()
			if (watchedFactionData ~= nil) then
				local colorIndex, factionID = watchedFactionData.reaction, watchedFactionData.factionID
				if (factionID ~= nil) and (factionID ~= 0) and not(C_Reputation_IsFactionParagon(factionID)) then
					local reputationInfo = C_GossipInfo_GetFriendshipReputation(factionID)
					if (reputationInfo ~= nil) then
						local friendshipID = reputationInfo.friendshipFactionID
						if (friendshipID > 0) then
							colorIndex = 5
						end
					end
				end
				if (colorIndex ~= nil and colorIndex > 0) then
					local color = FACTION_BAR_COLORS[colorIndex]
					if (color ~= nil) then
						bar:SetBarColor(color.r, color.g, color.b, 1)
					end
				end
			end
		elseif (bar.barIndex == StatusTrackingBarInfo.BarsEnum.Experience) then	-- ExpBar (priority = 3) (barIndex = 4)
			bar.priority = 3
			if (bar.ShouldBeVisible == nil) then
				bar.ShouldBeVisible = function(self)
					return not IsPlayerAtEffectiveMaxLevel() and not IsXPUserDisabled()
				end
			end
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
					if ClassicUI.db.profile.barsConfig.SingleStatusBar.expBarAlwaysShowRestedBar then
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
	hooksecurefunc(StatusTrackingBarManager.MainStatusTrackingBarContainer, "UpdateShownState", function(self)
		if self:IsShown() then
			self:Hide()
		end
	end)
	hooksecurefunc(StatusTrackingBarManager.SecondaryStatusTrackingBarContainer, "UpdateShownState", function(self)
		if self:IsShown() then
			self:Hide()
		end
	end)

	-- Hooks to keep action bars updated with changes
	hooksecurefunc("MultiActionBar_Update", ClassicUI.UpdatedStatusBarsEvent)
	hooksecurefunc(StatusTrackingBarManager, "UpdateBarsShown", ClassicUI.UpdatedStatusBarsEvent)
	hooksecurefunc("ActionBarController_UpdateAll", ClassicUI.UpdatedStatusBarsEvent)
	hooksecurefunc(StatusTrackingBarManager.MainStatusTrackingBarContainer, "SetShownBar", function(self, barIndex)
		local stbm = self:GetParent()
		if (barIndex > 0) then
			ClassicUI.StatusTrackingBarManager_LayoutBar(stbm, self.bars[barIndex], false)
		else
			if (stbm.BottomBarFrameTexture0:IsShown()) then
				stbm.BottomBarFrameTexture0:Hide()
				stbm.BottomBarFrameTexture1:Hide()
				stbm.BottomBarFrameTexture2:Hide()
				stbm.BottomBarFrameTexture3:Hide()
			end
		end
	end)
	hooksecurefunc(StatusTrackingBarManager.SecondaryStatusTrackingBarContainer, "SetShownBar", function(self, barIndex)
		local stbm = self:GetParent()
		if (barIndex > 0) then
			ClassicUI.StatusTrackingBarManager_LayoutBar(stbm, self.bars[barIndex], true)
		else
			if (stbm.TopBarFrameTexture0:IsShown()) then
				stbm.TopBarFrameTexture0:Hide()
				stbm.TopBarFrameTexture1:Hide()
				stbm.TopBarFrameTexture2:Hide()
				stbm.TopBarFrameTexture3:Hide()
			end
		end
	end)

	-- Update frames after exit edit mode
	if (EventRegistry and type(EventRegistry) == "table") then
		ClassicUI.onExitEditModeMF = function(self)
			ClassicUI:SetStrataForMainFrames()
			ClassicUI:ReLayoutMainFrames()
			ClassicUI:ReloadMainFramesSettings()
			ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
			ClassicUI.UpdatedStatusBarsEvent()
			if (ClassicUI.cached_db_profile.extraFrames_Chat_restoreScrollButtons) then	-- cached db value
				ClassicUI:UpdateScrollButtonsVisibilityAndPosition()
			end
		end
		if (ClassicUI.onExitEditModeEFF) then
			EventRegistry:UnregisterCallback("EditMode.Exit", ClassicUI)
		end
		EventRegistry:RegisterCallback("EditMode.Exit", ClassicUI.onExitEditModeMF, ClassicUI)
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

-- Function to manage the ADDON_LOADED event. Used to detect if the Blizzard 'Blizzard_NewPlayerExperience' and/or 'Blizzard_PlayerSpells' addons are loaded.
function ClassicUI:ADDON_LOADED(addonName)
	if (ClassicUI:IsEnabled()) then
		if (addonName == "Blizzard_NewPlayerExperience") then
			if (ClassicUI.HookMicroButtonsClass_UI_Watcher ~= nil ) then
				ClassicUI.HookMicroButtonsClass_UI_Watcher(CharacterMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(ProfessionMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(PlayerSpellsMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(AchievementMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(QuestLogMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(HousingMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(GuildMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(LFDMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(CollectionsMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(EJMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(HelpMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(StoreMicroButton)
				ClassicUI.HookMicroButtonsClass_UI_Watcher(MainMenuMicroButton)
			end
			ClassicUI.addonLoaded_Blizzard_NewPlayerExperience = true
			if (ClassicUI.addonLoaded_Blizzard_PlayerSpells) then
				ClassicUI.frame:UnregisterEvent("ADDON_LOADED")
			end
		elseif (addonName == "Blizzard_PlayerSpells") then
			if (ClassicUI.HookPlayerSpellsFrame_Tabs ~= nil) then
				if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton == 23) then
					ClassicUI.HookPlayerSpellsFrame_Tabs()
				end
			end
			ClassicUI.addonLoaded_Blizzard_PlayerSpells = true
			if (ClassicUI.addonLoaded_Blizzard_NewPlayerExperience) then
				ClassicUI.frame:UnregisterEvent("ADDON_LOADED")
			end
		end
	end
end

-- Function that determines whether the order of the MicroButtons in the user's DB corresponds to the default order.
function ClassicUI:IsMicroButtonsOrderDefaultDB()
	if (self.db ~= nil) then
		for k, v in pairs(self.db.profile.barsConfig.MicroButtons) do
			if ((type(v) == 'table') and (type(v.order) == 'number') and (v.order ~= self.db.defaults.profile.barsConfig.MicroButtons[k].order)) then
				return false
			end
		end
		return true
	else
		return false
	end
end

-- Function that allows changing the order of a MicroButton in the user's DB. It also allows reset them to default values.
function ClassicUI:ReorderMicroButtonsDB(mb, dir)
	if (mb == nil and dir == "DEFAULT") then
		for k, v in pairs(self.db.profile.barsConfig.MicroButtons) do
			if ((type(v) == 'table') and (type(v.order) == 'number') and (v.order ~= self.db.defaults.profile.barsConfig.MicroButtons[k].order)) then
				self.db.profile.barsConfig.MicroButtons[k].order = self.db.defaults.profile.barsConfig.MicroButtons[k].order
			end
		end
	else
		if (mb ~= nil and self.db.profile.barsConfig.MicroButtons[mb] ~= nil and self.db.profile.barsConfig.MicroButtons[mb].order ~= nil) then
			local oldValue, newValue
			if (dir == "UP") then
				if (self.db.profile.barsConfig.MicroButtons[mb].order > self.MICROBUTTONS_MIN_ORDER) then
					oldValue = self.db.profile.barsConfig.MicroButtons[mb].order
					newValue = self.db.profile.barsConfig.MicroButtons[mb].order - 1
				end
			elseif (dir == "DOWN") then
				if (self.db.profile.barsConfig.MicroButtons[mb].order < self.MICROBUTTONS_MAX_ORDER) then
					oldValue = self.db.profile.barsConfig.MicroButtons[mb].order
					newValue = self.db.profile.barsConfig.MicroButtons[mb].order + 1
				end
			elseif (dir == "DEFAULT") then
				if (self.db.profile.barsConfig.MicroButtons[mb].order ~= self.db.defaults.profile.barsConfig.MicroButtons[mb].order) then
					oldValue = self.db.profile.barsConfig.MicroButtons[mb].order
					newValue = self.db.defaults.profile.barsConfig.MicroButtons[mb].order
				end
			end
			if (oldValue ~= nil and newValue ~= nil) then
				self.db.profile.barsConfig.MicroButtons[mb].order = newValue
				for k, v in pairs(self.db.profile.barsConfig.MicroButtons) do
					if ((type(v) == 'table') and (type(v.order) == 'number') and (k ~= mb) and (v.order == newValue)) then
						self.db.profile.barsConfig.MicroButtons[k].order = oldValue
						break
					end
				end
			end
		end
	end
end

-- Function that determines whether the priority of the MicroButtons in the user's DB corresponds to the default priority.
function ClassicUI:IsMicroButtonsPriorityDefaultDB()
	if (self.db ~= nil) then
		for k, v in pairs(self.db.profile.barsConfig.MicroButtons) do
			if ((type(v) == 'table') and (type(v.priority) == 'number') and (v.priority ~= self.db.defaults.profile.barsConfig.MicroButtons[k].priority)) then
				return false
			end
		end
		return true
	else
		return false
	end
end

-- Function that allows changing the priority of a MicroButton in the user's DB. It also allows reset them to default values.
function ClassicUI:RepriorizeMicroButtonsDB(mb, dir)
	if (mb == nil and dir == "DEFAULT") then
		for k, v in pairs(self.db.profile.barsConfig.MicroButtons) do
			if ((type(v) == 'table') and (type(v.priority) == 'number') and (v.priority ~= self.db.defaults.profile.barsConfig.MicroButtons[k].priority)) then
				self.db.profile.barsConfig.MicroButtons[k].priority = self.db.defaults.profile.barsConfig.MicroButtons[k].priority
			end
		end
	else
		if (mb ~= nil and self.db.profile.barsConfig.MicroButtons[mb] ~= nil and self.db.profile.barsConfig.MicroButtons[mb].priority ~= nil) then
			local oldValue, newValue
			if (dir == "UP") then
				if (self.db.profile.barsConfig.MicroButtons[mb].priority > self.MICROBUTTONS_MIN_PRIORITY) then
					oldValue = self.db.profile.barsConfig.MicroButtons[mb].priority
					newValue = self.db.profile.barsConfig.MicroButtons[mb].priority - 1
				end
			elseif (dir == "DOWN") then
				if (self.db.profile.barsConfig.MicroButtons[mb].priority < self.MICROBUTTONS_MAX_PRIORITY) then
					oldValue = self.db.profile.barsConfig.MicroButtons[mb].priority
					newValue = self.db.profile.barsConfig.MicroButtons[mb].priority + 1
				end
			elseif (dir == "DEFAULT") then
				if (self.db.profile.barsConfig.MicroButtons[mb].priority ~= self.db.defaults.profile.barsConfig.MicroButtons[mb].priority) then
					oldValue = self.db.profile.barsConfig.MicroButtons[mb].priority
					newValue = self.db.defaults.profile.barsConfig.MicroButtons[mb].priority
				end
			end
			if (oldValue ~= nil and newValue ~= nil) then
				self.db.profile.barsConfig.MicroButtons[mb].priority = newValue
				for k, v in pairs(self.db.profile.barsConfig.MicroButtons) do
					if ((type(v) == 'table') and (type(v.priority) == 'number') and (k ~= mb) and (v.priority == newValue)) then
						self.db.profile.barsConfig.MicroButtons[k].priority = oldValue
						break
					end
				end
			end
		end
	end
end

-- Function that hides the dividers of the MainMenuBar
function ClassicUI:HideMainMenuBarDividers(actionBar, forceHide)
	if (actionBar == nil) then actionBar = MainActionBar end
	local actionBarDividersPool = actionBar.isHorizontal and actionBar.HorizontalDividersPool or actionBar.VerticalDividersPool
	if (actionBarDividersPool ~= nil and actionBarDividersPool.EnumerateActive ~= nil) then
		for divider, _ in actionBarDividersPool:EnumerateActive() do
			if (divider:IsShown() or forceHide) then
				divider:SetAlpha(0)
				divider:Hide()
			end
		end
	end
end

-- Recreate the old 'AutoCastShine_AutoCastStart' from the classic AutoCastShine action button animation
ClassicUI.AutoCastShine_AutoCastStart = function(button, r, g, b)
	if ( ClassicUI.AUTOCAST_SHINES[button] ) then
		return
	end
	if not ClassicUI.hooked_UIParent_AutoCastShine_OnUpdate then
		-- Hook the AutoCastShine_OnUpdate to UIParent in the first AutoCastShine activation
		UIParent:HookScript("OnUpdate", function(self, elapsed)
			ClassicUI.AutoCastShine_OnUpdate(nil, elapsed)
		end)
		ClassicUI.hooked_UIParent_AutoCastShine_OnUpdate = true
	end
	ClassicUI.AUTOCAST_SHINES[button] = true
	if ( not r ) then
		r, g, b = ClassicUI.AUTOCAST_SHINE_R, ClassicUI.AUTOCAST_SHINE_G, ClassicUI.AUTOCAST_SHINE_B
	end
	for _, sparkle in next, button.sparkles do
		sparkle:Show()
		sparkle:SetVertexColor(r, g, b)
	end
end

-- Recreate the old 'AutoCastShine_AutoCastStop' from the classic AutoCastShine action button animation
ClassicUI.AutoCastShine_AutoCastStop = function(button)
	ClassicUI.AUTOCAST_SHINES[button] = nil
	for _, sparkle in next, button.sparkles do
		sparkle:Hide()
	end
end

-- Recreate the old 'AutoCastShine_OnUpdate' from the classic AutoCastShine action button animation
ClassicUI.AutoCastShine_OnUpdate = function(self, elapsed)
	for i in next, ClassicUI.AUTOCAST_SHINE_TIMERS do
		ClassicUI.AUTOCAST_SHINE_TIMERS[i] = ClassicUI.AUTOCAST_SHINE_TIMERS[i] + elapsed
		if ( ClassicUI.AUTOCAST_SHINE_TIMERS[i] > ClassicUI.AUTOCAST_SHINE_SPEEDS[i]*4 ) then
			ClassicUI.AUTOCAST_SHINE_TIMERS[i] = 0
		end
	end
	for button in next, ClassicUI.AUTOCAST_SHINES do
		self = button
		local parent, distance = self, self:GetWidth()
		-- local AUTOCAST_SHINE_SPACING = 6		-- Seems unused.
		for i = 1, 4 do
			local timer = ClassicUI.AUTOCAST_SHINE_TIMERS[i]
			local speed = ClassicUI.AUTOCAST_SHINE_SPEEDS[i]
			if ( timer <= speed ) then
				local basePosition = timer/speed*distance
				self.sparkles[0+i]:SetPoint("CENTER", parent, "TOPLEFT", basePosition, 0)
				self.sparkles[4+i]:SetPoint("CENTER", parent, "BOTTOMRIGHT", -basePosition, 0)
				self.sparkles[8+i]:SetPoint("CENTER", parent, "TOPRIGHT", 0, -basePosition)
				self.sparkles[12+i]:SetPoint("CENTER", parent, "BOTTOMLEFT", 0, basePosition)
			elseif ( timer <= speed*2 ) then
				local basePosition = (timer-speed)/speed*distance
				self.sparkles[0+i]:SetPoint("CENTER", parent, "TOPRIGHT", 0, -basePosition)
				self.sparkles[4+i]:SetPoint("CENTER", parent, "BOTTOMLEFT", 0, basePosition)
				self.sparkles[8+i]:SetPoint("CENTER", parent, "BOTTOMRIGHT", -basePosition, 0)
				self.sparkles[12+i]:SetPoint("CENTER", parent, "TOPLEFT", basePosition, 0)
			elseif ( timer <= speed*3 ) then
				local basePosition = (timer-speed*2)/speed*distance
				self.sparkles[0+i]:SetPoint("CENTER", parent, "BOTTOMRIGHT", -basePosition, 0)
				self.sparkles[4+i]:SetPoint("CENTER", parent, "TOPLEFT", basePosition, 0)
				self.sparkles[8+i]:SetPoint("CENTER", parent, "BOTTOMLEFT", 0, basePosition)
				self.sparkles[12+i]:SetPoint("CENTER", parent, "TOPRIGHT", 0, -basePosition)
			else
				local basePosition = (timer-speed*3)/speed*distance
				self.sparkles[0+i]:SetPoint("CENTER", parent, "BOTTOMLEFT", 0, basePosition)
				self.sparkles[4+i]:SetPoint("CENTER", parent, "TOPRIGHT", 0, -basePosition)
				self.sparkles[8+i]:SetPoint("CENTER", parent, "TOPLEFT", basePosition, 0)
				self.sparkles[12+i]:SetPoint("CENTER", parent, "BOTTOMRIGHT", -basePosition, 0)
			end
		end
	end
end

-- Function to recreate the classic AutoCastable frame for an ActionButton
ClassicUI.CreateClassicAutoCastable = function(iActionButton)
	if (iActionButton.ClassicAutoCastable) then return end

	-- Recreate the classic animation frames, textures and animations
	local parentName = iActionButton:GetName()

	local iabcact = iActionButton:CreateTexture(parentName.."ClassicAutoCastable", "OVERLAY", nil, 1)
	iabcact:SetTexture("Interface\\Buttons\\UI-AutoCastableOverlay")

	iabcact:SetSize(58, 58)
	iabcact:ClearAllPoints()
	iabcact:SetPoint("CENTER", 0, 0)

	if (iActionButton.AutoCastOverlay:IsShown()) then
		iabcact:Show()
	else
		iabcact:Hide()
	end

	-- Create an intermediary parent frame to easily hide this animation if desired
	local iabpcact = CreateFrame("Frame", nil, iActionButton)
	iabpcact:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
	iabpcact:SetAlpha(1)
	iabpcact:Show()
	iabcact:SetParent(iabpcact)

	iActionButton.ParentClassicAutoCastable = iabpcact
	iActionButton.ClassicAutoCastable = iabcact

	iActionButton.AutoCastOverlay:HookScript("OnShow", function(self)
		if (self:GetParent().ClassicAutoCastable ~= nil) then
			self:GetParent().ClassicAutoCastable:Show()
		end
	end)
	iActionButton.AutoCastOverlay:HookScript("OnHide", function(self)
		if (self:GetParent().ClassicAutoCastable ~= nil) then
			self:GetParent().ClassicAutoCastable:Hide()
		end
	end)
	return iabcact
end

-- Function to recreate the classic AutoCastShine animation frame for an ActionButton
ClassicUI.CreateClassicAutoCastShine = function(iActionButton)
	if (iActionButton.ClassicAutoCastShine) then return end

	-- Recreate the classic animation frames, textures and animations
	local parentName = iActionButton:GetName().."ClassicShine"
	local iabcset = CreateFrame("Frame", parentName, iActionButton)
	iabcset.sparkles = {}

	iabcset.sparkles[1] = iabcset:CreateTexture(parentName.."1", "OVERLAY")
	iabcset.sparkles[1]:SetBlendMode("ADD")
	iabcset.sparkles[1]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[1]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[1]:ClearAllPoints()
	iabcset.sparkles[1]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[1]:SetSize(13, 13)
	iabcset.sparkles[1]:Hide()

	iabcset.sparkles[2] = iabcset:CreateTexture(parentName.."2", "OVERLAY")
	iabcset.sparkles[2]:SetBlendMode("ADD")
	iabcset.sparkles[2]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[2]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[2]:ClearAllPoints()
	iabcset.sparkles[2]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[2]:SetSize(10, 10)
	iabcset.sparkles[2]:Hide()

	iabcset.sparkles[3] = iabcset:CreateTexture(parentName.."3", "OVERLAY")
	iabcset.sparkles[3]:SetBlendMode("ADD")
	iabcset.sparkles[3]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[3]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[3]:ClearAllPoints()
	iabcset.sparkles[3]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[3]:SetSize(7, 7)
	iabcset.sparkles[3]:Hide()

	iabcset.sparkles[4] = iabcset:CreateTexture(parentName.."4", "OVERLAY")
	iabcset.sparkles[4]:SetBlendMode("ADD")
	iabcset.sparkles[4]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[4]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[4]:ClearAllPoints()
	iabcset.sparkles[4]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[4]:SetSize(4, 4)
	iabcset.sparkles[4]:Hide()

	iabcset.sparkles[5] = iabcset:CreateTexture(parentName.."5", "OVERLAY")
	iabcset.sparkles[5]:SetBlendMode("ADD")
	iabcset.sparkles[5]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[5]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[5]:ClearAllPoints()
	iabcset.sparkles[5]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[5]:SetSize(13, 13)
	iabcset.sparkles[5]:Hide()

	iabcset.sparkles[6] = iabcset:CreateTexture(parentName.."6", "OVERLAY")
	iabcset.sparkles[6]:SetBlendMode("ADD")
	iabcset.sparkles[6]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[6]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[6]:ClearAllPoints()
	iabcset.sparkles[6]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[6]:SetSize(10, 10)
	iabcset.sparkles[6]:Hide()

	iabcset.sparkles[7] = iabcset:CreateTexture(parentName.."7", "OVERLAY")
	iabcset.sparkles[7]:SetBlendMode("ADD")
	iabcset.sparkles[7]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[7]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[7]:ClearAllPoints()
	iabcset.sparkles[7]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[7]:SetSize(7, 7)
	iabcset.sparkles[7]:Hide()

	iabcset.sparkles[8] = iabcset:CreateTexture(parentName.."8", "OVERLAY")
	iabcset.sparkles[8]:SetBlendMode("ADD")
	iabcset.sparkles[8]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[8]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[8]:ClearAllPoints()
	iabcset.sparkles[8]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[8]:SetSize(4, 4)
	iabcset.sparkles[8]:Hide()

	iabcset.sparkles[9] = iabcset:CreateTexture(parentName.."9", "OVERLAY")
	iabcset.sparkles[9]:SetBlendMode("ADD")
	iabcset.sparkles[9]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[9]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[9]:ClearAllPoints()
	iabcset.sparkles[9]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[9]:SetSize(13, 13)
	iabcset.sparkles[9]:Hide()

	iabcset.sparkles[10] = iabcset:CreateTexture(parentName.."10", "OVERLAY")
	iabcset.sparkles[10]:SetBlendMode("ADD")
	iabcset.sparkles[10]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[10]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[10]:ClearAllPoints()
	iabcset.sparkles[10]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[10]:SetSize(10, 10)
	iabcset.sparkles[10]:Hide()

	iabcset.sparkles[11] = iabcset:CreateTexture(parentName.."11", "OVERLAY")
	iabcset.sparkles[11]:SetBlendMode("ADD")
	iabcset.sparkles[11]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[11]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[11]:ClearAllPoints()
	iabcset.sparkles[11]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[11]:SetSize(7, 7)
	iabcset.sparkles[11]:Hide()

	iabcset.sparkles[12] = iabcset:CreateTexture(parentName.."12", "OVERLAY")
	iabcset.sparkles[12]:SetBlendMode("ADD")
	iabcset.sparkles[12]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[12]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[12]:ClearAllPoints()
	iabcset.sparkles[12]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[12]:SetSize(4, 4)
	iabcset.sparkles[12]:Hide()

	iabcset.sparkles[13] = iabcset:CreateTexture(parentName.."13", "OVERLAY")
	iabcset.sparkles[13]:SetBlendMode("ADD")
	iabcset.sparkles[13]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[13]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[13]:ClearAllPoints()
	iabcset.sparkles[13]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[13]:SetSize(13, 13)
	iabcset.sparkles[13]:Hide()

	iabcset.sparkles[14] = iabcset:CreateTexture(parentName.."14", "OVERLAY")
	iabcset.sparkles[14]:SetBlendMode("ADD")
	iabcset.sparkles[14]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[14]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[14]:ClearAllPoints()
	iabcset.sparkles[14]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[14]:SetSize(10, 10)
	iabcset.sparkles[14]:Hide()

	iabcset.sparkles[15] = iabcset:CreateTexture(parentName.."15", "OVERLAY")
	iabcset.sparkles[15]:SetBlendMode("ADD")
	iabcset.sparkles[15]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[15]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[15]:ClearAllPoints()
	iabcset.sparkles[15]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[15]:SetSize(7, 7)
	iabcset.sparkles[15]:Hide()

	iabcset.sparkles[16] = iabcset:CreateTexture(parentName.."16", "OVERLAY")
	iabcset.sparkles[16]:SetBlendMode("ADD")
	iabcset.sparkles[16]:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
	iabcset.sparkles[16]:SetTexture("Interface\\ItemSocketingFrame\\UI-ItemSockets")
	iabcset.sparkles[16]:ClearAllPoints()
	iabcset.sparkles[16]:SetPoint("CENTER", 0, 0)
	iabcset.sparkles[16]:SetSize(4, 4)
	iabcset.sparkles[16]:Hide()

	iabcset:SetSize(28, 28)
	iabcset:ClearAllPoints()
	iabcset:SetPoint("CENTER", 0, 0)

	if (iActionButton.AutoCastOverlay.autoCastEnabled) then
		iabcset:Show()
		ClassicUI.AutoCastShine_AutoCastStart(iabcset)
	else
		iabcset:Hide()
	end

	-- Create an intermediary parent frame to easily hide this animation if desired
	local iabpcset = CreateFrame("Frame", nil, iActionButton)
	iabpcset:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
	iabpcset:SetAlpha(1)
	iabpcset:Show()
	iabcset:SetParent(iabpcset)

	iActionButton.ParentClassicAutoCastShine = iabpcset
	iActionButton.ClassicAutoCastShine = iabcset

	hooksecurefunc(iActionButton.AutoCastOverlay, "ShowAutoCastEnabled", function(self, isEnabled)
		if (self:GetParent().ClassicAutoCastShine ~= nil) then
			if (isEnabled) then
				self:GetParent().ClassicAutoCastShine:Show()
				ClassicUI.AutoCastShine_AutoCastStart(self:GetParent().ClassicAutoCastShine)
			else
				self:GetParent().ClassicAutoCastShine:Hide()
				ClassicUI.AutoCastShine_AutoCastStop(self:GetParent().ClassicAutoCastShine)
			end
		end
	end)
	return iabcset
end

-- Function to recreate the classic SpellActivationAlert animation frame for an ActionButton
ClassicUI.CreateClassicSpellActivationAlertFrame = function(iActionButton)
	if (iActionButton.ClassicSpellActivationAlert) then return end

	-- Recreate the classic animation frames and animations
	local parentName = iActionButton:GetName()
	local iabcsaa = CreateFrame("Frame", nil, iActionButton)

	iabcsaa.spark = iabcsaa:CreateTexture(parentName.."Spark", "BACKGROUND")
	iabcsaa.spark:SetTexCoord(0.00781250, 0.61718750, 0.00390625, 0.26953125)
	iabcsaa.spark:SetTexture("Interface\\SpellActivationOverlay\\IconAlert")
	iabcsaa.spark:ClearAllPoints()
	iabcsaa.spark:SetAllPoints(iabcsaa)
	iabcsaa.spark:ClearAllPoints()
	iabcsaa.spark:SetPoint("CENTER")
	iabcsaa.spark:SetAlpha(0)

	iabcsaa.innerGlow = iabcsaa:CreateTexture(parentName.."InnerGlow", "ARTWORK")
	iabcsaa.innerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)
	iabcsaa.innerGlow:SetTexture("Interface\\SpellActivationOverlay\\IconAlert")
	iabcsaa.innerGlow:ClearAllPoints()
	iabcsaa.innerGlow:SetAllPoints(iabcsaa)
	iabcsaa.innerGlow:ClearAllPoints()
	iabcsaa.innerGlow:SetPoint("CENTER")
	iabcsaa.innerGlow:SetAlpha(0)

	iabcsaa.innerGlowOver = iabcsaa:CreateTexture(parentName.."InnerGlowOver", "ARTWORK")
	iabcsaa.innerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)
	iabcsaa.innerGlowOver:SetTexture("Interface\\SpellActivationOverlay\\IconAlert")
	iabcsaa.innerGlowOver:ClearAllPoints()
	iabcsaa.innerGlowOver:SetPoint("TOPLEFT", iabcsaa.innerGlow, "TOPLEFT")
	iabcsaa.innerGlowOver:SetPoint("BOTTOMRIGHT", iabcsaa.innerGlow, "BOTTOMRIGHT")
	iabcsaa.innerGlowOver:SetAlpha(0)

	iabcsaa.outerGlow = iabcsaa:CreateTexture(parentName.."OuterGlow", "ARTWORK")
	iabcsaa.outerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)
	iabcsaa.outerGlow:SetTexture("Interface\\SpellActivationOverlay\\IconAlert")
	iabcsaa.outerGlow:ClearAllPoints()
	iabcsaa.outerGlow:SetAllPoints(iabcsaa)
	iabcsaa.outerGlow:ClearAllPoints()
	iabcsaa.outerGlow:SetPoint("CENTER")
	iabcsaa.outerGlow:SetAlpha(0)

	iabcsaa.outerGlowOver = iabcsaa:CreateTexture(parentName.."OuterGlowOver", "ARTWORK")
	iabcsaa.outerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)
	iabcsaa.outerGlowOver:SetTexture("Interface\\SpellActivationOverlay\\IconAlert")
	iabcsaa.outerGlowOver:ClearAllPoints()
	iabcsaa.outerGlowOver:SetPoint("TOPLEFT", iabcsaa.outerGlow, "TOPLEFT")
	iabcsaa.outerGlowOver:SetPoint("BOTTOMRIGHT", iabcsaa.outerGlow, "BOTTOMRIGHT")
	iabcsaa.outerGlowOver:SetAlpha(0)

	iabcsaa.ants = iabcsaa:CreateTexture(parentName.."Ants", "OVERLAY")
	iabcsaa.ants:SetTexture("Interface\\SpellActivationOverlay\\IconAlertAnts")
	iabcsaa.ants:ClearAllPoints()
	iabcsaa.ants:SetAllPoints(iabcsaa)
	iabcsaa.ants:ClearAllPoints()
	iabcsaa.ants:SetPoint("CENTER")
	iabcsaa.ants:SetAlpha(0)

	if (ClassicUI.ClassicSpellActivationAlertCurve == nil) then
		ClassicUI.ClassicSpellActivationAlertCurve = C_CurveUtil.CreateCurve()
		ClassicUI.ClassicSpellActivationAlertCurve:SetType(Enum.LuaCurveType.Step)
		ClassicUI.ClassicSpellActivationAlertCurve:AddPoint(0, 1)
		ClassicUI.ClassicSpellActivationAlertCurve:AddPoint(3.0, 0.5)
	end

	iabcsaa.OnUpdate = function(self, elapsed)
		AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01)
		local button = self:GetParent():GetParent()
		local cooldown = button.cooldown
		-- we need some threshold to avoid dimming the glow during the gdc
		-- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
		if (cooldown and cooldown:IsShown()) then
			local isInCooldown = true
			local isOnGCD = true
			if (button.action) then
				local actionCooldownInfo = C_ActionBar_GetActionCooldown(button.action)
				if (actionCooldownInfo) then
					local actionInfoType, actionInfoID, actionInfoSubType = GetActionInfo(button.action)
					if issecretvalue(actionCooldownInfo.duration) then
						if actionInfoType == "spell" or actionInfoSubType == "spell" or actionInfoSubType == "pet" then
							isInCooldown = actionCooldownInfo.timeUntilEndOfStartRecovery ~= nil
							isOnGCD = actionCooldownInfo.isOnGCD
						elseif actionInfoType == "item" then
							local _, durationSeconds = C_Item_GetItemCooldown(actionInfoID)
							isInCooldown = durationSeconds > 0
							isOnGCD = durationSeconds > 0 and durationSeconds <= 3.0
						else
							local duration = C_ActionBar_GetActionCooldownDuration(button.action)
							self:SetAlpha(duration:EvaluateRemainingDuration(ClassicUI.ClassicSpellActivationAlertCurve))
							return
						end
					else
						isInCooldown = actionCooldownInfo.duration > 0
						if actionInfoType == "spell" or actionInfoSubType == "spell" or actionInfoSubType == "pet" then
							isOnGCD = actionCooldownInfo.isOnGCD or (actionCooldownInfo.duration > 0 and actionCooldownInfo.duration <= 3.0)
						else
							isOnGCD = actionCooldownInfo.duration > 0 and actionCooldownInfo.duration <= 3.0
						end
					end
				end
			else
				if (button.spellID) then
					local spellCooldownInfo = C_Spell_GetSpellCooldown(button.spellID)
					if spellCooldownInfo then
						if issecretvalue(spellCooldownInfo.duration) then
							isInCooldown = spellCooldownInfo.timeUntilEndOfStartRecovery ~= nil
							isOnGCD = spellCooldownInfo.isOnGCD
						else
							isInCooldown = spellCooldownInfo.duration > 0
							isOnGCD = spellCooldownInfo.isOnGCD or (spellCooldownInfo.duration > 0 and spellCooldownInfo.duration <= 3.0)
						end
					end
				end
			end
			if (not(isInCooldown) or isOnGCD) then
				self:SetAlpha(1.0)
			else
				self:SetAlpha(0.5)
			end
		else
			self:SetAlpha(1.0)
		end
	end
	iabcsaa:SetScript("OnUpdate", iabcsaa.OnUpdate)

	iabcsaa.OnHide = function(self)
		if ( self.animOut:IsPlaying() ) then
			self.animOut:Stop()
			self.animOut:OnFinished()
		end
	end
	iabcsaa:SetScript("OnHide", iabcsaa.OnHide)

	local tmpanim
	iabcsaa.animIn = iabcsaa:CreateAnimationGroup()
	iabcsaa.animIn.pstatus = 0	-- Add extra status info for this AnimationGroup: 0 = Finished, 1 = Playing, 2 = Stopped, 3 = Paused

	tmpanim = iabcsaa.animIn:CreateAnimation("Scale")
	tmpanim:SetTarget(iabcsaa.spark)
	tmpanim:SetDuration(0.2)
	tmpanim:SetScale(1.5, 1.5)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animIn:CreateAnimation("Alpha")
	tmpanim:SetTarget(iabcsaa.spark)
	tmpanim:SetDuration(0.2)
	tmpanim:SetFromAlpha(0)
	tmpanim:SetToAlpha(1)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animIn:CreateAnimation("Scale")
	tmpanim:SetTarget(iabcsaa.innerGlow)
	tmpanim:SetDuration(0.3)
	tmpanim:SetScale(2, 2)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animIn:CreateAnimation("Scale")
	tmpanim:SetTarget(iabcsaa.innerGlowOver)
	tmpanim:SetDuration(0.3)
	tmpanim:SetScale(2, 2)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animIn:CreateAnimation("Alpha")
	tmpanim:SetTarget(iabcsaa.innerGlowOver)
	tmpanim:SetDuration(0.3)
	tmpanim:SetFromAlpha(1)
	tmpanim:SetToAlpha(0)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animIn:CreateAnimation("Scale")
	tmpanim:SetTarget(iabcsaa.outerGlow)
	tmpanim:SetDuration(0.3)
	tmpanim:SetScale(0.5, 0.5)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animIn:CreateAnimation("Scale")
	tmpanim:SetTarget(iabcsaa.outerGlowOver)
	tmpanim:SetDuration(0.3)
	tmpanim:SetScale(0.5, 0.5)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animIn:CreateAnimation("Alpha")
	tmpanim:SetTarget(iabcsaa.outerGlowOver)
	tmpanim:SetDuration(0.3)
	tmpanim:SetFromAlpha(1)
	tmpanim:SetToAlpha(0)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animIn:CreateAnimation("Scale")
	tmpanim:SetTarget(iabcsaa.spark)
	tmpanim:SetStartDelay(0.2)
	tmpanim:SetDuration(0.2)
	tmpanim:SetScale(0.666666, 0.666666)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animIn:CreateAnimation("Alpha")
	tmpanim:SetTarget(iabcsaa.spark)
	tmpanim:SetStartDelay(0.2)
	tmpanim:SetDuration(0.2)
	tmpanim:SetFromAlpha(1)
	tmpanim:SetToAlpha(0)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animIn:CreateAnimation("Alpha")
	tmpanim:SetTarget(iabcsaa.innerGlow)
	tmpanim:SetStartDelay(0.3)
	tmpanim:SetDuration(0.2)
	tmpanim:SetFromAlpha(1)
	tmpanim:SetToAlpha(0)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animIn:CreateAnimation("Alpha")
	tmpanim:SetTarget(iabcsaa.ants)
	tmpanim:SetStartDelay(0.3)
	tmpanim:SetDuration(0.2)
	tmpanim:SetFromAlpha(0)
	tmpanim:SetToAlpha(1)
	tmpanim:SetOrder(1)

	iabcsaa.animIn.OnPlay = function(self)
		local frame = self:GetParent()
		local frameWidth, frameHeight = frame:GetSize()
		frame.spark:SetSize(frameWidth, frameHeight)
		frame.spark:SetAlpha(0.3)
		frame.innerGlow:SetSize(frameWidth / 2, frameHeight / 2)
		frame.innerGlow:SetAlpha(1.0)
		frame.innerGlowOver:SetAlpha(1.0)
		frame.outerGlow:SetSize(frameWidth * 2, frameHeight * 2)
		frame.outerGlow:SetAlpha(1.0)
		frame.outerGlowOver:SetAlpha(1.0)
		frame.ants:SetSize(frameWidth * 0.85, frameHeight * 0.85)
		frame.ants:SetAlpha(0)
		self.pstatus = 1
		frame:Show()
	end
	iabcsaa.animIn:SetScript("OnPlay", iabcsaa.animIn.OnPlay)

	iabcsaa.animIn.OnFinished = function(self)
		local frame = self:GetParent()
		local frameWidth, frameHeight = frame:GetSize()
		frame.spark:SetAlpha(0)
		frame.innerGlow:SetAlpha(0)
		frame.innerGlow:SetSize(frameWidth, frameHeight)
		frame.innerGlowOver:SetAlpha(0.0)
		frame.outerGlow:SetSize(frameWidth, frameHeight)
		frame.outerGlowOver:SetAlpha(0.0)
		frame.outerGlowOver:SetSize(frameWidth, frameHeight)
		frame.ants:SetAlpha(1.0)
		self.pstatus = 0
	end
	iabcsaa.animIn:SetScript("OnFinished", iabcsaa.animIn.OnFinished)

	iabcsaa.animIn.OnStop = function(self)
		self.pstatus = 2
	end
	iabcsaa.animIn:SetScript("OnStop", iabcsaa.animIn.OnStop)

	iabcsaa.animIn.OnPause = function(self)
		self.pstatus = 3
	end
	iabcsaa.animIn:SetScript("OnPause", iabcsaa.animIn.OnPause)

	iabcsaa.animIn.IsStopped = function(self)
		return (self.pstatus == 2)
	end

	iabcsaa.animIn.IsStoppedOrPaused = function(self)
		return (self.pstatus >= 2)
	end

	iabcsaa.animOut = iabcsaa:CreateAnimationGroup()

	tmpanim = iabcsaa.animOut:CreateAnimation("Alpha")
	tmpanim:SetTarget(iabcsaa.outerGlowOver)
	tmpanim:SetDuration(0.2)
	tmpanim:SetFromAlpha(0)
	tmpanim:SetToAlpha(1)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animOut:CreateAnimation("Alpha")
	tmpanim:SetTarget(iabcsaa.ants)
	tmpanim:SetDuration(0.2)
	tmpanim:SetFromAlpha(1)
	tmpanim:SetToAlpha(0)
	tmpanim:SetOrder(1)

	tmpanim = iabcsaa.animOut:CreateAnimation("Alpha")
	tmpanim:SetTarget(iabcsaa.outerGlowOver)
	tmpanim:SetDuration(0.2)
	tmpanim:SetFromAlpha(1)
	tmpanim:SetToAlpha(0)
	tmpanim:SetOrder(2)

	tmpanim = iabcsaa.animOut:CreateAnimation("Alpha")
	tmpanim:SetTarget(iabcsaa.outerGlow)
	tmpanim:SetDuration(0.2)
	tmpanim:SetFromAlpha(1)
	tmpanim:SetToAlpha(0)
	tmpanim:SetOrder(2)

	iabcsaa.animOut.OnFinished = function(self)
		local frame = self:GetParent()
		frame:Hide()
	end
	iabcsaa.animOut:SetScript("OnFinished", iabcsaa.animOut.OnFinished)

	-- Create an intermediary parent frame to easily hide this animation if desired
	local iabpcsaa = CreateFrame("Frame", nil, iActionButton)
	iabpcsaa.cooldown = iActionButton.cooldown
	iabpcsaa:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
	iabpcsaa:SetAlpha(1)
	iabpcsaa:Show()
	iabcsaa:SetParent(iabpcsaa)

	iActionButton.ParentClassicSpellActivationAlert = iabpcsaa
	iActionButton.ClassicSpellActivationAlert = iabcsaa
	local frameWidth, frameHeight = iActionButton:GetSize()
	iabcsaa:SetSize(frameWidth * 1.4, frameHeight * 1.4)
	iabcsaa:SetPoint("CENTER", iActionButton, "CENTER", 0, 0)
	iabcsaa:Hide()

	-- Global hooks to the main functions that show/hide these animations
	if not ClassicUI.hooked_ActionButton_ShowHideOverlayGlow then
		hooksecurefunc(ActionButtonSpellAlertManager, "ShowAlert", function(self, button)
			if issecretvalue(button) then return end	-- function also used by secret-protected CooldownViewer items
			if not(button.ClassicSpellActivationAlert) then return end
			if button.ClassicSpellActivationAlert.animOut:IsPlaying() then
				button.ClassicSpellActivationAlert.animOut:Stop()
			end
			if not button.ClassicSpellActivationAlert:IsShown() or button.ClassicSpellActivationAlert.animIn:IsStopped() then
				button.ClassicSpellActivationAlert.animIn:Play()
			end
		end)
		hooksecurefunc(ActionButtonSpellAlertManager, "HideAlert", function(self, button)
			if issecretvalue(button) then return end	-- function also used by secret-protected CooldownViewer items
			if not(button.ClassicSpellActivationAlert) then	return end
			if button.ClassicSpellActivationAlert.animIn:IsPlaying() then
				button.ClassicSpellActivationAlert.animIn:Stop()
			end
			if button:IsVisible() then
				button.ClassicSpellActivationAlert.animOut:Play()
			else
				button.ClassicSpellActivationAlert.animOut:OnFinished()	-- We aren't shown anyway, so we'll instantly hide it.
			end
		end)
		ClassicUI.hooked_ActionButton_ShowHideOverlayGlow = true
	end
	return iabcsaa
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

-- Function that restores the Modern layout of a specific ActionButton
ClassicUI.RestoreModernLayoutActionButton = function(iActionButton, typeActionButton)
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
		if ((iActionButton.action ~= nil) and (C_ActionBar_IsEquippedAction(iActionButton.action))) then
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
	local iabcdt = _G[name.."Cooldown"] or iActionButton.cooldown
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
		iabcdt:SetEdgeTexture("Interface\\Cooldown\\UI-HUD-ActionBar-SecondaryCooldown")
		iabcdt:SetDrawBling(false)
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
	local iabacot = iActionButton.AutoCastOverlay
	if (iabacot ~= nil) then
		iabacot:ClearAllPoints()
		if (typeActionButton <= 2 or typeActionButton == 7) then
			iabacot:SetSize(45, 45)
			iabacot:SetPoint("CENTER", 0, 0)
		else
			iabacot:SetSize(31, 31)
			iabacot:SetPoint("CENTER", 0.5, -0.5)
		end
		iabacot:SetAlpha(1)
		local iabcact = iActionButton.ClassicAutoCastable
		if (iabcact ~= nil) then
			iabcact:GetParent():Hide()
			iabcact:GetParent():SetAlpha(0)
		end
		local iabcset = iActionButton.ClassicAutoCastShine
		if (iabcset ~= nil) then
			iabcset:GetParent():Hide()
			iabcset:GetParent():SetAlpha(0)
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
	local iabsaa = iActionButton.SpellActivationAlert
	if (iabsaa ~= nil) then
		local frameWidth, frameHeight = iActionButton:GetSize()
		iabsaa:SetSize(frameWidth * 1.4, frameHeight * 1.4)
		iabsaa.ProcStartFlipbook:SetSize(150, 150)
		iabsaa.ProcAltGlow:SetSize(49, 49)
		iabsaa:SetAlpha(1)
		local iabcsaa = iActionButton.ClassicSpellActivationAlert
		if (iabcsaa ~= nil) then
			iabcsaa.spark:Hide()
			iabcsaa.innerGlow:Hide()
			iabcsaa.innerGlowOver:Hide()
			iabcsaa.outerGlow:Hide()
			iabcsaa.outerGlowOver:Hide()
			iabcsaa.ants:Hide()
			iabcsaa:GetParent():Hide()
			iabcsaa:GetParent():SetAlpha(0)
		end
	end
	local iabtraf = iActionButton.TargetReticleAnimFrame
	if (iabtraf ~= nil) then
		iabtraf:SetScale(1)
		iabtraf:SetAlpha(1)
	end
	local iabid = iActionButton.InterruptDisplay
	if (iabid ~= nil) then
		iabid:SetScale(1)
		iabid:SetAlpha(1)
	end
	local iabscaf = iActionButton.SpellCastAnimFrame
	if (iabscaf ~= nil) then
		iabscaf:SetScale(1)
		iabscaf:SetAlpha(1)
	end
	local iabcf = iActionButton.CooldownFlash
	if (iabcf ~= nil) then
		iabcf:SetScale(1)
		iabcf:SetAlpha(0)	-- should be 1, but this effect is unused since 10.1.7 patch (there is an option to restore this effect, but it should only take effect for the classic layout, so we hide it)
	end
	local iabcc = iActionButton.chargeCooldown
	if (iabcc ~= nil) then
		iabcc:SetEdgeTexture("Interface\\Cooldown\\UI-HUD-ActionBar-SecondaryCooldown")
	end
	local iabachf = iActionButton.AssistedCombatHighlightFrame
	if (iabachf ~= nil) then
		if (iabachf.Flipbook ~= nil) then
			iabachf.Flipbook:SetSize(66,66)
		end
	end
	local iabacrf = iActionButton.AssistedCombatRotationFrame
	if (iabacrf ~= nil) then
		if (iabacrf.InactiveTexture ~= nil) then
			iabacrf.InactiveTexture:SetSize(64, 64)
			iabacrf.InactiveTexture:ClearAllPoints()
			iabacrf.InactiveTexture:SetPoint("CENTER", iabacrf, "CENTER", 0, 0)
		end
		if (iabacrf.ActiveFrame ~= nil) then
			iabacrf.ActiveFrame.Border:SetSize(64, 64)
			iabacrf.ActiveFrame.Glow:SetSize(100, 100)
			iabacrf.ActiveFrame.Mask:SetSize(64, 64)
			iabacrf.ActiveFrame:ClearAllPoints()
			iabacrf.ActiveFrame:SetPoint("CENTER", iabacrf, "CENTER", 0, 0)
		end
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
		hooksecurefunc(iActionButton, "UpdateButtonArt", function(self)
			--if ClassicUI.databaseCleaned then return end	-- not needed because typeABprofile is an upvalue local table variable (the upvalue table can become empty but never nil, not an issue)
			if (not self.SlotArt or not self.SlotBackground) then
				return
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
				-- Modern Layout
				if (self.bar and not self.bar.hideBarArt) then
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
	if (typeActionButton <= 1) then
		iActionButton:SetAttribute("flyoutDirection", "UP")
	elseif (typeActionButton == 2) then
		iActionButton:SetAttribute("flyoutDirection", "LEFT")
	end
	if (typeABprofile.BLStyle == 1) then
		-- Modern Layout
		iActionButton.NormalTexture:SetAlpha(typeABprofile.BLStyle1NormalTextureAlpha)
		if (typeActionButton <= 2) then
			ClassicUI.cached_ActionButtonInfo.currentScale[iActionButton] = ClassicUI.ACTIONBUTTON_NEWLAYOUT_SCALE
			iActionButton:SetScale((newBLScale / (iActionButton:GetParent():GetScale() * iActionButton.bar:GetScale())) * ClassicUI.cached_ActionButtonInfo.currentScale[iActionButton])
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
		local iabcf = iActionButton.CooldownFlash
		if (iabcf ~= nil) then
			iabcf:SetAlpha(0)	-- should be 1, but this effect is unused since 10.1.7 patch (there is an option to restore this effect, but it should only take effect for the classic layout, so we hide it)
		end
		if (ClassicUI.cached_ActionButtonInfo.currLayout[iActionButton] == 0) then
			ClassicUI.RestoreModernLayoutActionButton(iActionButton, typeActionButton)
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
			iActionButton:SetScale(newBLScale / (iActionButton:GetParent():GetScale() * iActionButton.bar:GetScale()))
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
			if ((iActionButton.action ~= nil) and (C_ActionBar_IsEquippedAction(iActionButton.action))) then
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
		local iabcdt = _G[name.."Cooldown"] or iActionButton.cooldown
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
			iabcdt:SetEdgeTexture("Interface\\Cooldown\\edge")
			if not typeABprofile.BLStyle0HideCooldownBlingAnim then
				iabcdt:SetDrawBling(true)
			else
				iabcdt:SetDrawBling(false)
			end
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
		local iabacot = iActionButton.AutoCastOverlay
		if (iabacot ~= nil) then
			local iabcact = iActionButton.ClassicAutoCastable
			local iabcset = iActionButton.ClassicAutoCastShine
			if not(typeABprofile.BLStyle0UseNewAutoCastOverlay) then
				iabacot:SetAlpha(0)
				if (not iabcact) then
					iabcact = ClassicUI.CreateClassicAutoCastable(iActionButton)
				end
				iabcact:GetParent():Show()
				iabcact:GetParent():SetAlpha(1)
				if (not iabcset) then
					iabcset = ClassicUI.CreateClassicAutoCastShine(iActionButton)
				end
				iabcset:GetParent():Show()
				iabcset:GetParent():SetAlpha(1)
			else
				iabacot:ClearAllPoints()
				if (typeActionButton <= 2) then
					iabacot:SetSize(38, 38)
					iabacot:SetPoint("CENTER", 0, 0)
				elseif (typeActionButton >= 3 and typeActionButton <= 5) then
					iabacot:SetSize(33,33)
					iabacot:SetPoint("CENTER", -0.25, -0.5)
				elseif (typeActionButton == 6) then
					iabacot:SetSize(30, 30)
					iabacot:SetPoint("CENTER", 0, 0)
				elseif (typeActionButton == 7) then
					iabacot:SetSize(52, 52)
					iabacot:SetPoint("CENTER", 0, 0)
				end
				iabacot:SetAlpha(1)
				if (iabcact ~= nil) then
					iabcact:GetParent():Hide()
					iabcact:GetParent():SetAlpha(0)
				end
				if (iabcset ~= nil) then
					iabcset:GetParent():Hide()
					iabcset:GetParent():SetAlpha(0)
				end
			end
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
		-- TODO: We keep the new Modern FlyoutArrow, maybe we recreate the old one in a future version
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
					local isMouseOverButton = self:IsMouseMotionFocus()
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
		local iabsaa = iActionButton.SpellActivationAlert
		if (iabsaa ~= nil) then
			local iabcsaa = iActionButton.ClassicSpellActivationAlert
			if not(typeABprofile.BLStyle0UseNewSpellActivationAlert) then
				iabsaa:SetAlpha(0)
				if (not iabcsaa) then
					iabcsaa = ClassicUI.CreateClassicSpellActivationAlertFrame(iActionButton)
				end
				iabcsaa.spark:Show()
				iabcsaa.innerGlow:Show()
				iabcsaa.innerGlowOver:Show()
				iabcsaa.outerGlow:Show()
				iabcsaa.outerGlowOver:Show()
				iabcsaa.ants:Show()
				iabcsaa:GetParent():Show()
				iabcsaa:GetParent():SetAlpha(1)
			else
				local frameWidth, frameHeight = iActionButton:GetSize()
				iabsaa:SetSize(frameWidth * 1.4, frameHeight * 1.4)
				iabsaa.ProcStartFlipbook:SetSize(128, 128)
				iabsaa.ProcAltGlow:SetSize(41, 41)
				iabsaa:SetAlpha(1)
				if (iabcsaa ~= nil) then
					iabcsaa.spark:Hide()
					iabcsaa.innerGlow:Hide()
					iabcsaa.innerGlowOver:Hide()
					iabcsaa.outerGlow:Hide()
					iabcsaa.outerGlowOver:Hide()
					iabcsaa.ants:Hide()
					iabcsaa:GetParent():Hide()
					iabcsaa:GetParent():SetAlpha(0)
				end
			end
		else
			if not ClassicUI.hooked_ActionButton_SetupOverlayGlow then
				hooksecurefunc(ActionButtonSpellAlertManager, "ShowAlert", function(self, button)
					if issecretvalue(button) then return end	-- function also used by secret-protected CooldownViewer items
					if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
					local iabsaa = button.SpellActivationAlert
					local iabcsaa = button.ClassicSpellActivationAlert
					local typeActionButton = ClassicUI.cached_ActionButtonInfo.typeActionButton[button]
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
					if ((typeABprofile.BLStyle == 0) and not(typeABprofile.BLStyle0UseNewSpellActivationAlert)) then
						if (iabsaa ~= nil) then
							iabsaa:SetAlpha(0)
						end
						if (not iabcsaa) then
							iabcsaa = ClassicUI.CreateClassicSpellActivationAlertFrame(button)
						end
						iabcsaa.spark:Show()
						iabcsaa.innerGlow:Show()
						iabcsaa.innerGlowOver:Show()
						iabcsaa.outerGlow:Show()
						iabcsaa.outerGlowOver:Show()
						iabcsaa.ants:Show()
						iabcsaa:GetParent():Show()
						iabcsaa:GetParent():SetAlpha(1)
					else
						if (iabcsaa ~= nil) then
							iabcsaa.spark:Hide()
							iabcsaa.innerGlow:Hide()
							iabcsaa.innerGlowOver:Hide()
							iabcsaa.outerGlow:Hide()
							iabcsaa.outerGlowOver:Hide()
							iabcsaa.ants:Hide()
							iabcsaa:GetParent():Hide()
							iabcsaa:GetParent():SetAlpha(0)
						end
						if (iabsaa ~= nil) then
							if not(ClassicUI.cached_ActionButtonInfo.spellActivationAlertAdjusted[button]) then
								local frameWidth, frameHeight = button:GetSize()
								iabsaa:SetSize(frameWidth * 1.4, frameHeight * 1.4)
								if (typeABprofile.BLStyle == 0) then
									iabsaa.ProcStartFlipbook:SetSize(128, 128)
									iabsaa.ProcAltGlow:SetSize(41, 41)
								else
									iabsaa.ProcStartFlipbook:SetSize(150, 150)
									iabsaa.ProcAltGlow:SetSize(49, 49)
								end
								ClassicUI.cached_ActionButtonInfo.spellActivationAlertAdjusted[button] = true
							end
							iabsaa:SetAlpha(1)
						end
					end
				end)
				ClassicUI.hooked_ActionButton_SetupOverlayGlow = true
			end
		end
		local iabtraf = iActionButton.TargetReticleAnimFrame
		if (iabtraf ~= nil) then
			if not(typeABprofile.BLStyle0UseNewTargetReticleAnimFrame) then
				iabtraf:SetAlpha(0)
				iabtraf:SetScale(1)
			else
				iabtraf:SetAlpha(1)
				iabtraf:SetScale(ClassicUI.ACTIONBUTTON_NEWLAYOUT_SCALE)
			end
		end
		local iabid = iActionButton.InterruptDisplay
		if (iabid ~= nil) then
			if not(typeABprofile.BLStyle0UseNewInterruptDisplay) then
				iabid:SetAlpha(0)
				iabid:SetScale(1)
			else
				iabid:SetAlpha(1)
				iabid:SetScale(ClassicUI.ACTIONBUTTON_NEWLAYOUT_SCALE)
			end
		end
		local iabscaf = iActionButton.SpellCastAnimFrame
		if (iabscaf ~= nil) then
			if not(typeABprofile.BLStyle0UseNewSpellCastAnimFrame) then
				iabscaf:SetAlpha(0)
				iabscaf:SetScale(1)
				if (type(iActionButton.PlaySpellCastAnim) == "function") then
					if not ClassicUI.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[iActionButton] then
						hooksecurefunc(iActionButton, "PlaySpellCastAnim", function(self, actionButtonCastType)
							--if ClassicUI.databaseCleaned then return end	-- not needed because typeABprofile is an upvalue local table variable (the upvalue table can become empty but never nil, not an issue)
							if ((typeABprofile.BLStyle == 0) and not(typeABprofile.BLStyle0UseNewSpellCastAnimFrame)) then
								self.cooldown:SetSwipeColor(0, 0, 0, 1)
							end
						end)
						ClassicUI.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[iActionButton] = true
					end
				end
			else
				iabscaf:SetAlpha(1)
				iabscaf:SetScale(ClassicUI.ACTIONBUTTON_NEWLAYOUT_SCALE)
			end
		end
		local iabcf = iActionButton.CooldownFlash
		if (iabcf ~= nil) then
			if not(typeABprofile.BLStyle0UseNewCooldownFlash) then
				iabcf:SetAlpha(0)
				iabcf:SetScale(1)
			else
				iabcf:SetAlpha(1)
				iabcf:SetScale(ClassicUI.ACTIONBUTTON_NEWLAYOUT_SCALE)
				if not ClassicUI.hooked_ActionButtonCooldown_OnCooldownDone_CooldownFlash then
					hooksecurefunc("ActionButtonCooldown_OnCooldownDone", function(self, requireCooldownUpdate)
						local cooldownFlash = self:GetParent().CooldownFlash
						local spellCastAnimFrame = self:GetParent().SpellCastAnimFrame
						if (cooldownFlash) then
							if (not spellCastAnimFrame or (spellCastAnimFrame and not spellCastAnimFrame:IsShown())) then
								cooldownFlash:Setup()
							end
						end
					end)
					ClassicUI.hooked_ActionButtonCooldown_OnCooldownDone_CooldownFlash = true
				end
			end
		end
		local iabcc = iActionButton.chargeCooldown
		if (iabcc ~= nil) then
			if not typeABprofile.BLStyle0UseNewChargeCooldownEdgeTexture then
				iabcc:SetEdgeTexture("Interface\\Cooldown\\edge")
			else
				iabcc:SetEdgeTexture("Interface\\Cooldown\\UI-HUD-ActionBar-SecondaryCooldown")
			end
		else
			if not typeABprofile.BLStyle0UseNewChargeCooldownEdgeTexture then
				if not ClassicUI.hooked_ActionButton_StartChargeCooldown then
					hooksecurefunc("StartChargeCooldown", function(parent, chargeStart, chargeDuration, chargeModRate)
						if ClassicUI.databaseCleaned then return end	-- [DB Integrity Check]
						local iabcc = parent.chargeCooldown
						if (iabcc == nil) then return end
						local typeActionButton = ClassicUI.cached_ActionButtonInfo.typeActionButton[parent]
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
						if ((typeABprofile.BLStyle == 0) and not(typeABprofile.BLStyle0UseNewChargeCooldownEdgeTexture)) then
							iabcc:SetEdgeTexture("Interface\\Cooldown\\edge")
						end
					end)
					ClassicUI.hooked_ActionButton_StartChargeCooldown = true
				end
			end
		end
		local iabachf = iActionButton.AssistedCombatHighlightFrame
		if (iabachf ~= nil) then
			if (iabachf.Flipbook ~= nil) then
				iabachf.Flipbook:SetSize(57,57)
			end
		else
			if not ClassicUI.hooked_AssistedCombatManager_SetAssistedHighlightFrameShown then
				hooksecurefunc(AssistedCombatManager, "SetAssistedHighlightFrameShown", function(self, actionButton, shown)
					if (shown) then
						if (actionButton.AssistedCombatHighlightFrame and actionButton.AssistedCombatHighlightFrame.Flipbook) then
							local typeActionButton = ClassicUI.cached_ActionButtonInfo.typeActionButton[actionButton]
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
							if (typeABprofile.BLStyle == 0) then
								actionButton.AssistedCombatHighlightFrame.Flipbook:SetSize(57, 57)
							end
						end
					end
				end)
				ClassicUI.hooked_AssistedCombatManager_SetAssistedHighlightFrameShown = true
			end
		end
		local iabacrf = iActionButton.AssistedCombatRotationFrame
		if (iabacrf ~= nil) then
			if (iabacrf.InactiveTexture ~= nil) then
				iabacrf.InactiveTexture:SetSize(55, 55)
				iabacrf.InactiveTexture:ClearAllPoints()
				iabacrf.InactiveTexture:SetPoint("CENTER", iabacrf, "CENTER", 1, -0.25)
			end
			if (iabacrf.ActiveFrame ~= nil) then
				iabacrf.ActiveFrame.Border:SetSize(55, 55)
				iabacrf.ActiveFrame.Glow:SetSize(86, 86)
				iabacrf.ActiveFrame.Mask:SetSize(55, 55)
				iabacrf.ActiveFrame:ClearAllPoints()
				iabacrf.ActiveFrame:SetPoint("CENTER", iabacrf, "CENTER", 1, -0.25)
			end
		else
			if not ClassicUI.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[iActionButton] then
				if iActionButton.UpdateAssistedCombatRotationFrame and type(iActionButton.UpdateAssistedCombatRotationFrame)=="function" then
					hooksecurefunc(iActionButton, "UpdateAssistedCombatRotationFrame", function(self)
						--if ClassicUI.databaseCleaned then return end	-- not needed because typeABprofile is an upvalue local table variable (the upvalue table can become empty but never nil, not an issue)
						if (self.AssistedCombatRotationFrame ~= nil) then
							if (typeABprofile.BLStyle == 0) then
								if (self.AssistedCombatRotationFrame.InactiveTexture ~= nil) then
									self.AssistedCombatRotationFrame.InactiveTexture:SetSize(55, 55)
									self.AssistedCombatRotationFrame.InactiveTexture:ClearAllPoints()
									self.AssistedCombatRotationFrame.InactiveTexture:SetPoint("CENTER", self.AssistedCombatRotationFrame, "CENTER", 1, -0.25)
								end
								if (self.AssistedCombatRotationFrame.ActiveFrame ~= nil) then
									self.AssistedCombatRotationFrame.ActiveFrame.Border:SetSize(55, 55)
									self.AssistedCombatRotationFrame.ActiveFrame.Glow:SetSize(86, 86)
									self.AssistedCombatRotationFrame.ActiveFrame.Mask:SetSize(55, 55)
									self.AssistedCombatRotationFrame.ActiveFrame:ClearAllPoints()
									self.AssistedCombatRotationFrame.ActiveFrame:SetPoint("CENTER", self.AssistedCombatRotationFrame, "CENTER", 1, -0.25)
								end
							end
						end
					end)
					ClassicUI.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[iActionButton] = true
				end
			end
		end
	end
	ClassicUI.cached_ActionButtonInfo.currLayout[iActionButton] = typeABprofile.BLStyle
end

-- Function that sets the current layout for a desired groups of ActionButtons
ClassicUI.LayoutGroupActionButtons = function(groups)
	if ((groups == nil) or (type(groups) ~= "table")) then return end
	if (groups[0]) then
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["ActionButton"..i], 0)
		end
	end
	if (groups[1]) then
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["MultiBarBottomLeftButton"..i], 1)
		end
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["MultiBarBottomRightButton"..i], 1)
		end
	end
	if (groups[2]) then
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["MultiBarLeftButton"..i], 2)
		end
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
			ClassicUI:ActionButtonProtectedApplyLayout(_G["MultiBarRightButton"..i], 2)
		end
	end
	if (groups[3]) then
		for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
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
			local button = _G["SpellFlyoutPopupButton"..i]
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
	for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
		self.cached_ActionButtonInfo.hooked_UpdateButtonArt[_G["ActionButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateButtonArt[_G["MultiBarBottomLeftButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateButtonArt[_G["MultiBarBottomRightButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateButtonArt[_G["MultiBarRightButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateButtonArt[_G["MultiBarLeftButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateHotkeys[_G["ActionButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateHotkeys[_G["MultiBarBottomLeftButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateHotkeys[_G["MultiBarBottomRightButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateHotkeys[_G["MultiBarRightButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateHotkeys[_G["MultiBarLeftButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateFlyout[_G["ActionButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateFlyout[_G["MultiBarBottomLeftButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateFlyout[_G["MultiBarBottomRightButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateFlyout[_G["MultiBarRightButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateFlyout[_G["MultiBarLeftButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[_G["ActionButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[_G["MultiBarBottomLeftButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[_G["MultiBarBottomRightButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[_G["MultiBarRightButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[_G["MultiBarLeftButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[_G["ActionButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[_G["MultiBarBottomLeftButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[_G["MultiBarBottomRightButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[_G["MultiBarRightButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[_G["MultiBarLeftButton"..i]] = false
		self.cached_ActionButtonInfo.spellActivationAlertAdjusted[_G["ActionButton"..i]] = false
		self.cached_ActionButtonInfo.spellActivationAlertAdjusted[_G["MultiBarBottomLeftButton"..i]] = false
		self.cached_ActionButtonInfo.spellActivationAlertAdjusted[_G["MultiBarBottomRightButton"..i]] = false
		self.cached_ActionButtonInfo.spellActivationAlertAdjusted[_G["MultiBarRightButton"..i]] = false
		self.cached_ActionButtonInfo.spellActivationAlertAdjusted[_G["MultiBarLeftButton"..i]] = false
		self.cached_ActionButtonInfo.typeActionButton[_G["ActionButton"..i]] = 0
		self.cached_ActionButtonInfo.typeActionButton[_G["MultiBarBottomLeftButton"..i]] = 1
		self.cached_ActionButtonInfo.typeActionButton[_G["MultiBarBottomRightButton"..i]] = 1
		self.cached_ActionButtonInfo.typeActionButton[_G["MultiBarRightButton"..i]] = 2
		self.cached_ActionButtonInfo.typeActionButton[_G["MultiBarLeftButton"..i]] = 2
		self.cached_ActionButtonInfo.currentScale[_G["ActionButton"..i]] = 1
		self.cached_ActionButtonInfo.currentScale[_G["MultiBarBottomLeftButton"..i]] = 1
		self.cached_ActionButtonInfo.currentScale[_G["MultiBarBottomRightButton"..i]] = 1
		self.cached_ActionButtonInfo.currentScale[_G["MultiBarRightButton"..i]] = 1
		self.cached_ActionButtonInfo.currentScale[_G["MultiBarLeftButton"..i]] = 1
		self.cached_ActionButtonInfo.currLayout[_G["ActionButton"..i]] = 1
		self.cached_ActionButtonInfo.currLayout[_G["MultiBarBottomLeftButton"..i]] = 1
		self.cached_ActionButtonInfo.currLayout[_G["MultiBarBottomRightButton"..i]] = 1
		self.cached_ActionButtonInfo.currLayout[_G["MultiBarRightButton"..i]] = 1
		self.cached_ActionButtonInfo.currLayout[_G["MultiBarLeftButton"..i]] = 1
	end
	for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
		self.cached_ActionButtonInfo.hooked_UpdateButtonArt[_G["PetActionButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateHotkeys[_G["PetActionButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateFlyout[_G["PetActionButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[_G["PetActionButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[_G["PetActionButton"..i]] = false
		self.cached_ActionButtonInfo.spellActivationAlertAdjusted[_G["PetActionButton"..i]] = false
		self.cached_ActionButtonInfo.typeActionButton[_G["PetActionButton"..i]] = 3
		self.cached_ActionButtonInfo.currentScale[_G["PetActionButton"..i]] = 1
		self.cached_ActionButtonInfo.currLayout[_G["PetActionButton"..i]] = 1
	end
	for i = 1, 10 do
		self.cached_ActionButtonInfo.hooked_UpdateButtonArt[_G["StanceButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateHotkeys[_G["StanceButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateFlyout[_G["StanceButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[_G["StanceButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[_G["StanceButton"..i]] = false
		self.cached_ActionButtonInfo.spellActivationAlertAdjusted[_G["StanceButton"..i]] = false
		self.cached_ActionButtonInfo.typeActionButton[_G["StanceButton"..i]] = 4
		self.cached_ActionButtonInfo.currentScale[_G["StanceButton"..i]] = 1
		self.cached_ActionButtonInfo.currLayout[_G["StanceButton"..i]] = 1
	end
	for i = 1, 6 do
		self.cached_ActionButtonInfo.hooked_UpdateButtonArt[_G["OverrideActionBarButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateHotkeys[_G["OverrideActionBarButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateFlyout[_G["OverrideActionBarButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[_G["OverrideActionBarButton"..i]] = false
		self.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[_G["OverrideActionBarButton"..i]] = false
		self.cached_ActionButtonInfo.spellActivationAlertAdjusted[_G["OverrideActionBarButton"..i]] = false
		self.cached_ActionButtonInfo.typeActionButton[_G["OverrideActionBarButton"..i]] = 7
		self.cached_ActionButtonInfo.currentScale[_G["OverrideActionBarButton"..i]] = 1
		self.cached_ActionButtonInfo.currLayout[_G["OverrideActionBarButton"..i]] = 1
	end
	for i = 1, 40 do
		local button = _G["SpellFlyoutPopupButton"..i]
		if (button ~= nil) then
			self.cached_ActionButtonInfo.hooked_UpdateButtonArt[button] = false
			self.cached_ActionButtonInfo.hooked_UpdateHotkeys[button] = false
			self.cached_ActionButtonInfo.hooked_UpdateFlyout[button] = false
			self.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[button] = false
			self.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[button] = false
			self.cached_ActionButtonInfo.spellActivationAlertAdjusted[button] = false
			self.cached_ActionButtonInfo.typeActionButton[button] = 6
			self.cached_ActionButtonInfo.currentScale[button] = 1
			self.cached_ActionButtonInfo.currLayout[button] = 1
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
	self.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[PossessButton1] = false
	self.cached_ActionButtonInfo.hooked_PlaySpellCastAnim[PossessButton2] = false
	self.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[PossessButton1] = false
	self.cached_ActionButtonInfo.hooked_UpdateAssistedCombatRotationFrame[PossessButton2] = false
	self.cached_ActionButtonInfo.spellActivationAlertAdjusted[PossessButton1] = false
	self.cached_ActionButtonInfo.spellActivationAlertAdjusted[PossessButton2] = false
	self.cached_ActionButtonInfo.typeActionButton[PossessButton1] = 5
	self.cached_ActionButtonInfo.typeActionButton[PossessButton2] = 5
	self.cached_ActionButtonInfo.currentScale[PossessButton1] = 1
	self.cached_ActionButtonInfo.currentScale[PossessButton2] = 1
	self.cached_ActionButtonInfo.currLayout[PossessButton1] = 1
	self.cached_ActionButtonInfo.currLayout[PossessButton2] = 1
end

-- Function handler for event fired when player changes specialization. This can change the layout, so we need to relayout the main frames here.
function ClassicUI:PLAYER_SPECIALIZATION_CHANGED()
	ClassicUI:ReLayoutMainFrames()
end

-- Main function that loads the core features of ClassicUI. This function at the end calls to 'ClassicUI:PLAYER_ENTERING_WORLD()'.
function ClassicUI:MainFunction(isLogin)

	-- Get and set the cached values for the status bar variables
	ClassicUI:UpdateStatusBarOptionsCache()

	-- Create the basic default-value cache for ActionButtons
	ClassicUI:InitActionButtonInfoCache()

	-- Seems that this frame normally does not need protection (InCombatLockdown) to be moved, as long as there are no protected frames anchored to it.
	hooksecurefunc("UIParent_ManageFramePositions", function()
		if (not(InCombatLockdown()) or not(UIParentBottomManagedFrameContainer:IsProtected())) then
			UIParentBottomManagedFrameContainer:ClearAllPoints()
			UIParentBottomManagedFrameContainer:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, MAIN_ACTION_BAR_DEFAULT_OFFSET_Y + 100)
		end
	end)
	UIParentBottomManagedFrameContainer:ClearAllPoints()
	UIParentBottomManagedFrameContainer:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, MAIN_ACTION_BAR_DEFAULT_OFFSET_Y + 100)

	if InCombatLockdown() then
		delayFunc_MainFunction = true
		if (not fclFrame:IsEventRegistered("PLAYER_REGEN_ENABLED")) then
			fclFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		return
	end

	-- We reset certain attributes of the ActionBars to their old values and disable their interaction with the mouse
	ClassicUI:ModifyOriginalFrames()

	hooksecurefunc(MainActionBar, "UpdateEndCaps", function(self, overrideHideEndCaps)
		self.EndCaps.LeftEndCap:Hide()
		self.EndCaps.RightEndCap:Hide()
		self.EndCaps:Hide()
	end)
	MainActionBar.EndCaps.LeftEndCap:Hide()
	MainActionBar.EndCaps.RightEndCap:Hide()
	MainActionBar.EndCaps:Hide()
	hooksecurefunc(MainActionBar, "UpdateSystemSettingHideBarArt", function(self)
		self.BorderArt:SetShown(false)
	end)
	MainActionBar.BorderArt:SetShown(false)
	hooksecurefunc(MainActionBar, "UpdateDividers", function(self)
		ClassicUI:HideMainMenuBarDividers(self)
	end)
	ClassicUI:HideMainMenuBarDividers(MainActionBar, true)

	if (not ClassicUI.frame:IsEventRegistered("PLAYER_SPECIALIZATION_CHANGED")) then
		ClassicUI.frame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
	end
	if (not ClassicUI.frame:IsEventRegistered("ADDON_LOADED")) then
		ClassicUI.frame:RegisterEvent("ADDON_LOADED")
	end
	if (isLogin) then
		ClassicUI.OnEvent_PEW_mf = true
		if (not ClassicUI.frame:IsEventRegistered("PLAYER_ENTERING_WORLD")) then
			ClassicUI.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		end
	else
		ClassicUI:MF_PLAYER_ENTERING_WORLD()
	end

end

-- Extra Option: Keybinds Visibility. Main function to Show/Hide/OnlyShowDotRange keybinds text from ActionBars
-- Togle the visibilitity mode from 2 or 3 to another mode requires a ReloadUI
function ClassicUI:ToggleVisibilityKeybinds(mode)
	if (mode == 1) then
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
		for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
			local actionButtonHK = _G["PetActionButton"..i.."HotKey"]
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
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
		for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
			local actionButton = _G["PetActionButton"..i]
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
		elseif (mode == 3) then
			for i = 1, #PetBattleFrame.BottomFrame.abilityButtons do
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
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
		for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
			local actionButtonHK = _G["PetActionButton"..i.."HotKey"]
			if (actionButtonHK) then
				actionButtonHK:SetAlpha(1)
			end
		end
		for i = 1, #PetBattleFrame.BottomFrame.abilityButtons do
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
				local valid = C_ActionBar_IsActionInRange(self.action)
				local checksRange = (valid ~= nil)
				local inRange = checksRange and valid
				ActionButton_UpdateRangeIndicator(self, checksRange, inRange)
			else
				self.HotKey:SetText(' '..RANGE_INDICATOR)
				self.HotKey:Show()
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

-- Extra Option: ActionBar Names Visibility. Main function to Show/Hide name text from ActionBars
function ClassicUI:ToggleVisibilityActionButtonNames(mode)
	if (mode) then
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
		for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
			local actionButtonName = _G["PetActionButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(0)
			end
		end
	else
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
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
		for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
			local actionButtonName = _G["PetActionButton"..i.."Name"]
			if (actionButtonName) then
				actionButtonName:SetAlpha(1)
			end
		end
	end
end

-- Extra Option: LossOfControlUI. Main function to disable Cooldown effect on action bars caused by crowd control (CC)
function ClassicUI:HookLossOfControlUICCRemover()
	if (not DISABLELOSSOFCONTROLUI_HOOKED) then
		-- Globally disable Loss of Control (LoC) cooldown effects on action buttons through 'ActionButton_ApplyCooldown'
		hooksecurefunc('ActionButton_ApplyCooldown', function(normalCooldown, cooldownInfo, chargeCooldown, chargeInfo, lossOfControlCooldown, lossOfControlInfo)
			if (lossOfControlInfo and (issecretvalue(lossOfControlInfo.startTime) or issecretvalue(lossOfControlInfo.duration) or issecretvalue(lossOfControlInfo.modRate) or lossOfControlInfo.startTime ~= 0 or lossOfControlInfo.duration ~= 0 or lossOfControlInfo.modRate ~= 0)) then
				ActionButton_ApplyCooldown(normalCooldown, cooldownInfo, chargeCooldown, chargeInfo, lossOfControlCooldown)
			end
		end)
		-- Explicitly disable Loss of Control (LoC) cooldown effects on Blizzard default action buttons
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
			local actionButton
			actionButton = _G["ExtraActionButton"..i]
			if (actionButton and actionButton.enableLOCCooldown) then
				actionButton.enableLOCCooldown = nil
			end
			actionButton = _G["ActionButton"..i]
			if (actionButton and actionButton.enableLOCCooldown) then
				actionButton.enableLOCCooldown = nil
			end
			actionButton = _G["MultiBarBottomLeftButton"..i]
			if (actionButton and actionButton.enableLOCCooldown) then
				actionButton.enableLOCCooldown = nil
			end
			actionButton = _G["MultiBarBottomRightButton"..i]
			if (actionButton and actionButton.enableLOCCooldown) then
				actionButton.enableLOCCooldown = nil
			end
			actionButton = _G["MultiBarLeftButton"..i]
			if (actionButton and actionButton.enableLOCCooldown) then
				actionButton.enableLOCCooldown = nil
			end
			actionButton = _G["MultiBarRightButton"..i]
			if (actionButton and actionButton.enableLOCCooldown) then
				actionButton.enableLOCCooldown = nil
			end
			actionButton = _G["StanceButton"..i]
			if (actionButton and actionButton.enableLOCCooldown) then
				actionButton.enableLOCCooldown = nil
			end
			actionButton = _G["PossessButton"..i]
			if (actionButton and actionButton.enableLOCCooldown) then
				actionButton.enableLOCCooldown = nil
			end
			actionButton = _G["OverrideActionBarButton"..i]
			if (actionButton and actionButton.enableLOCCooldown) then
				actionButton.enableLOCCooldown = nil
			end
		end
		for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
			local actionButton = _G["PetActionButton"..i]
			if (actionButton and actionButton.enableLOCCooldown) then
				actionButton.enableLOCCooldown = nil
			end
		end
		for i = 1, 40 do
			local actionButton = _G["SpellFlyoutPopupButton"..i]
			if (actionButton and actionButton.enableLOCCooldown) then
				actionButton.enableLOCCooldown = nil
			end
		end
		DISABLELOSSOFCONTROLUI_HOOKED = true
	end
end

-- Extra Option: RedRange. Main function to show the entire icon in red when the spell is not at range instead of only show in red the keybind text
function ClassicUI:HookRedRangeIcons()
	if (not REDRANGEICONS_HOOKED) then
		local function HookRRActionBarButtonUpdateUsable(actionBarButton)
			if (actionBarButton.UpdateUsable ~= nil) then
				hooksecurefunc(actionBarButton, "UpdateUsable", function(self, action, isUsable, notEnoughMana)
					if (action ~= nil and action ~= self.action) then
						isUsable = nil
						notEnoughMana = nil
					end
					local icon = self.icon
					local normalTexture = self.NormalTexture
					if (C_ActionBar_HasRangeRequirements(self.action) and C_ActionBar_IsActionInRange(self.action) == false) then
						icon:SetVertexColor(0.8, 0.1, 0.1)
						if (normalTexture ~= nil) then
							normalTexture:SetVertexColor(0.8, 0.1, 0.1)
						end
						self.redRangeRed = true
					else
						if isUsable == nil or notEnoughMana == nil then
							isUsable, notEnoughMana = C_ActionBar_IsUsableAction(self.action)
						end
						if (isUsable) then
							icon:SetVertexColor(1.0, 1.0, 1.0)
							if (normalTexture ~= nil) then
								normalTexture:SetVertexColor(1.0, 1.0, 1.0)
							end
						elseif (notEnoughMana) then
							icon:SetVertexColor(0.1, 0.3, 1.0)
							if (normalTexture ~= nil) then
								normalTexture:SetVertexColor(0.1, 0.3, 1.0)
							end
						else
							icon:SetVertexColor(0.4, 0.4, 0.4)
							if (normalTexture ~= nil) then
								normalTexture:SetVertexColor(1.0, 1.0, 1.0)
							end
						end
						self.redRangeRed = false
					end
				end)
			end
		end
		hooksecurefunc("ActionButton_UpdateRangeIndicator", function(self, checksRange, inRange)
			if (checksRange and not inRange) then
				local icon = self.icon
				local normalTexture = self.NormalTexture
				icon:SetVertexColor(0.8, 0.1, 0.1)
				if (normalTexture ~= nil) then
					normalTexture:SetVertexColor(0.8, 0.1, 0.1)
				end
				self.redRangeRed = true
			elseif (self.redRangeRed) then
				local icon = self.icon
				local normalTexture = self.NormalTexture
				local action = self.action
				if (action) then
					local isUsable, notEnoughMana = C_ActionBar_IsUsableAction(action)
					if (isUsable) then
						icon:SetVertexColor(1.0, 1.0, 1.0)
						if (normalTexture ~= nil) then
							normalTexture:SetVertexColor(1.0, 1.0, 1.0)
						end
					elseif (notEnoughMana) then
						icon:SetVertexColor(0.1, 0.3, 1.0)
						if (normalTexture ~= nil) then
							normalTexture:SetVertexColor(0.1, 0.3, 1.0)
						end
					else
						icon:SetVertexColor(0.4, 0.4, 0.4)
						if (normalTexture ~= nil) then
							normalTexture:SetVertexColor(1.0, 1.0, 1.0)
						end
					end
				else
					icon:SetVertexColor(1.0, 1.0, 1.0)
					if (normalTexture ~= nil) then
						normalTexture:SetVertexColor(1.0, 1.0, 1.0)
					end
				end
				self.redRangeRed = false
			end
		end)
		for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
			local actionButton
			actionButton = _G["ExtraActionButton"..i]
			if (actionButton) then
				HookRRActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["ActionButton"..i]
			if (actionButton) then
				HookRRActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["MultiBarBottomLeftButton"..i]
			if (actionButton) then
				HookRRActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["MultiBarBottomRightButton"..i]
			if (actionButton) then
				HookRRActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["MultiBarLeftButton"..i]
			if (actionButton) then
				HookRRActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["MultiBarRightButton"..i]
			if (actionButton) then
				HookRRActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["StanceButton"..i]
			if (actionButton) then
				HookRRActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["PossessButton"..i]
			if (actionButton) then
				HookRRActionBarButtonUpdateUsable(actionButton)
			end
			actionButton = _G["OverrideActionBarButton"..i]
			if (actionButton) then
				HookRRActionBarButtonUpdateUsable(actionButton)
			end
		end
		for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
			local actionButton = _G["PetActionButton"..i]
			if (actionButton) then
				HookRRActionBarButtonUpdateUsable(actionButton)
			end
		end
		ActionBarController:HookScript("OnEvent", function(self, event, ...)	-- Needed because Blizzard doesn't update the range text color on action bar page change
			if (event == "ACTIONBAR_PAGE_CHANGED") then
				for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
					local actionButton = _G["ActionButton"..i]
					if (actionButton) then
						local valid = C_ActionBar_IsActionInRange(actionButton.action)
						local checksRange = (valid ~= nil)
						local inRange = checksRange and valid
						ActionButton_UpdateRangeIndicator(actionButton, checksRange, inRange)
					end
				end
			end
		end)
		REDRANGEICONS_HOOKED = true
	end
end

-- Extra Option: GreyOnCooldown. Function to call the GOCUpdateCheck() for all action buttons
function ClassicUI:GOC_UpdateAllActionButtons()
	for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
		local actionButton
		actionButton = _G["ExtraActionButton"..i]
		if (actionButton and actionButton.GOCUpdateCheck) then
			actionButton:GOCUpdateCheck()
		end
		actionButton = _G["ActionButton"..i]
		if (actionButton and actionButton.GOCUpdateCheck) then
			actionButton:GOCUpdateCheck()
		end
		actionButton = _G["MultiBarBottomLeftButton"..i]
		if (actionButton and actionButton.GOCUpdateCheck) then
			actionButton:GOCUpdateCheck()
		end
		actionButton = _G["MultiBarBottomRightButton"..i]
		if (actionButton and actionButton.GOCUpdateCheck) then
			actionButton:GOCUpdateCheck()
		end
		actionButton = _G["MultiBarLeftButton"..i]
		if (actionButton and actionButton.GOCUpdateCheck) then
			actionButton:GOCUpdateCheck()
		end
		actionButton = _G["MultiBarRightButton"..i]
		if (actionButton and actionButton.GOCUpdateCheck) then
			actionButton:GOCUpdateCheck()
		end
		actionButton = _G["StanceButton"..i]
		if (actionButton and actionButton.GOCUpdateCheck) then
			actionButton:GOCUpdateCheck()
		end
		actionButton = _G["PossessButton"..i]
		if (actionButton and actionButton.GOCUpdateCheck) then
			actionButton:GOCUpdateCheck()
		end
		actionButton = _G["OverrideActionBarButton"..i]
		if (actionButton and actionButton.GOCUpdateCheck) then
			actionButton:GOCUpdateCheck()
		end
	end
	for i = 1, 40 do
		local actionButton = _G["SpellFlyoutPopupButton"..i]
		if (actionButton and actionButton.GOCUpdateCheck) then
			actionButton:GOCUpdateCheck()
		end
	end
	if (ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.desaturatePetActionButtons) then
		for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
			local actionButton = _G["PetActionButton"..i]
			if (actionButton and actionButton.GOCUpdateCheck) then
				actionButton:GOCUpdateCheck()
			end
		end
	end
end

-- Extra Option: GreyOnCooldown. Function to update the RegisteredActionSpells table (ActionButtons)
ClassicUI.GOC_UpdateActionButtonAction = function(button)
	if (button.action) then
		local actionInfoType, actionInfoID, actionInfoSubType = GetActionInfo(button.action)
		if (actionInfoType == "spell" or actionInfoSubType == "spell" or actionInfoSubType == "pet") then
			if (actionInfoID ~= button._actionSpellId) then
				if (button._actionSpellId and ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId]) then
					ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId][button] = nil
				end
				if (ClassicUI.GOC_RegisteredActionSpells[actionInfoID] == nil) then
					ClassicUI.GOC_RegisteredActionSpells[actionInfoID] = { }
				end
				ClassicUI.GOC_RegisteredActionSpells[actionInfoID][button] = true
				button._actionSpellId = actionInfoID
			end
		else
			if (button._actionSpellId and ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId]) then
				ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId][button] = nil
			end
			button._actionSpellId = nil
		end
	else
		if (button._actionSpellId and ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId]) then
			ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId][button] = nil
		end
		button._actionSpellId = nil
	end
	if (button.GOCUpdateCheck) then
		button:GOCUpdateCheck()
	end
end

-- Extra Option: GreyOnCooldown. Function to update the RegisteredActionSpells table (PetActionButtons)
ClassicUI.GOC_UpdatePetActionButtonAction = function(button)
	local index = button.index or button.id
	if (index) then
		local _, _, _, _, _, _, spellID = GetPetActionInfo(index)
		if (spellID ~= nil) then
			if (spellID ~= button._actionSpellId) then
				if (button._actionSpellId and ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId]) then
					ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId][button] = nil
				end
				if (ClassicUI.GOC_RegisteredActionSpells[spellID] == nil) then
					ClassicUI.GOC_RegisteredActionSpells[spellID] = { }
				end
				ClassicUI.GOC_RegisteredActionSpells[spellID][button] = true
				button._actionSpellId = spellID
			end
		else
			if (button._actionSpellId and ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId]) then
				ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId][button] = nil
			end
			button._actionSpellId = nil
		end
	else
		if (button._actionSpellId and ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId]) then
			ClassicUI.GOC_RegisteredActionSpells[button._actionSpellId][button] = nil
		end
		button._actionSpellId = nil
	end
	if (button.GOCUpdateCheck) then
		button:GOCUpdateCheck()
	end
end

-- Extra Option: GreyOnCooldown. Main GOC ActionButton Update function to desaturate the entire action icon when the spell is on cooldown or unusable
ClassicUI.GOC_GOCActionButtonUpdateCheck = function(self, isOnGCD)
	if not(self.icon) then return end
	local duration
	local useGCDCurve = false
	if (self.action) then
		if (ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_desaturateUnusableActions) then
			local isUsable, notEnoughMana = C_ActionBar_IsUsableAction(self.action)
			if not(isUsable or notEnoughMana) then
				self.icon:SetDesaturation(1)
				return
			end
		end
		duration = C_ActionBar_GetActionCooldownDuration(self.action)
		if duration:HasSecretValues() then
			local actionInfoType, actionInfoID, actionInfoSubType = GetActionInfo(self.action)
			if actionInfoType == "item" then
				local _, durationSeconds, enableCooldownTimer = C_Item_GetItemCooldown(actionInfoID)
				if (isOnGCD == nil) then
					isOnGCD = (enableCooldownTimer and durationSeconds > 0 and durationSeconds <= ClassicUI.GOC_GCD) or false
				end
				if not(isOnGCD) then
					duration = durationSeconds
				else
					duration = nil
				end
			else
				if (isOnGCD == nil) then
					local actionCooldownInfo = C_ActionBar_GetActionCooldown(self.action)
					if actionCooldownInfo then
						isOnGCD = actionCooldownInfo.isOnGCD or false
						if not(isOnGCD) then
							if actionInfoType == "macro" and actionInfoSubType=="item" then
								useGCDCurve = true
							end
						end
					end
				end
				if isOnGCD then
					duration = nil
				end
			end
		else
			if not(isOnGCD) then
				local actionCooldownInfo = C_ActionBar_GetActionCooldown(self.action)
				if actionCooldownInfo then
					isOnGCD = actionCooldownInfo.isOnGCD or (not(issecretvalue(actionCooldownInfo.activeCategory)) and actionCooldownInfo.activeCategory == 2316) or false
					if not(isOnGCD) then
						local actionInfoType, _, actionInfoSubType = GetActionInfo(self.action)
						if actionInfoType ~= "spell" and actionInfoSubType~="spell" and actionInfoSubType~="pet" then
							isOnGCD = (actionCooldownInfo.isEnabled and duration:GetRemainingDuration() > 0 and duration:GetTotalDuration() <= ClassicUI.GOC_GCD) or false
						end
					end
				end
			end
			if isOnGCD then
				duration = nil
			end
		end
	elseif (self.spellID) then
		if (ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_desaturateUnusableActions) then
			local isUsable, notEnoughMana = C_Spell_IsSpellUsable(self.spellID)
			if not(isUsable or notEnoughMana) then
				self.icon:SetDesaturation(1)
				return
			end
		end
		if (isOnGCD == nil) then
			local spellCooldownInfo = C_Spell_GetSpellCooldown(self.spellID)
			if spellCooldownInfo then
				isOnGCD = spellCooldownInfo.isOnGCD or (not(issecretvalue(spellCooldownInfo.activeCategory)) and spellCooldownInfo.activeCategory == 2316) or false
			end
		end
		if not(isOnGCD) then
			duration = C_Spell_GetSpellCooldownDuration(self.spellID)
		end
	end
	if duration then
		if type(duration)=="number" then
			if (duration > 0) then
				self.icon:SetDesaturation(1)
			else
				self.icon:SetDesaturation(0)
			end
		else
			if duration:HasSecretValues() then
				if not(useGCDCurve) then
					self.icon:SetDesaturation(duration:EvaluateRemainingDuration(ClassicUI.GOC_DesaturationCurve))
				else
					self.icon:SetDesaturation(duration:EvaluateRemainingDuration(ClassicUI.GOC_DesaturationCurveGCD))
				end
			else
				if (duration:GetRemainingDuration() > 0) then
					self.icon:SetDesaturation(1)
				else
					self.icon:SetDesaturation(0)
				end
			end
		end
	else
		self.icon:SetDesaturation(0)
	end
end

-- Extra Option: GreyOnCooldown. Main GOC PetActionButton Update function to desaturate the entire action icon when the spell is on cooldown or unusable
ClassicUI.GOC_GOCPetActionButtonUpdateCheck = function(self)
	local index = self.index or self.id
	if not(self.icon and index and GetPetActionInfo(index)) then return end
	if (ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_desaturatePetActionButtons) then
		if (ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_desaturateUnusableActions) then
			if not(GetPetActionSlotUsable(index)) then
				self.icon:SetDesaturation(1)
				return
			end
		end
		local _, duration, enable = GetPetActionCooldown(index)
		if (enable and duration and duration > 0 and duration > ClassicUI.GOC_GCD) then
			self.icon:SetDesaturation(1)
		else
			self.icon:SetDesaturation(0)
		end
	else
		self.icon:SetDesaturation(0)
	end
end

-- Extra Option: GreyOnCooldown. Hook function to update the ActionButton (self)
ClassicUI.GOC_ButtonUpdateHookFunc = function(self)
	if (self.GOCUpdateCheck) then
		self:GOCUpdateCheck()
	end
end

-- Extra Option: GreyOnCooldown. Hook function to update the ActionButton (self:GetParent())
ClassicUI.GOC_ButtonParentUpdateHookFunc = function(self)
	if (self:GetParent().GOCUpdateCheck) then
		self:GetParent():GOCUpdateCheck()
	end
end

-- Extra Option: GreyOnCooldown. Function that establishes the needed GOC hooks for an ActionButton
function ClassicUI:GOC_HookGOCActionButtonUpdate(button)
	-- Establish the main GOC ActionButton Update function
	if (GREYONCOOLDOWN_UPDATECHECK_SET_AB == nil) then
		GREYONCOOLDOWN_UPDATECHECK_SET_AB = {}
	end
	if not(GREYONCOOLDOWN_UPDATECHECK_SET_AB[button]) then
		button.GOCUpdateCheck = ActionButton_GreyOnCooldown_UpdateCheck
		GREYONCOOLDOWN_UPDATECHECK_SET_AB[button] = true
	end
	-- ActionButton essentials GOC hooks (AB hooks: OnCooldownDone, OnShow, OnHide, Update, UpdateUsable)
	if button.cooldown then
		if (GREYONCOOLDOWN_ONCOOLDOWNDONE_HOOKED_ABC == nil) then
			GREYONCOOLDOWN_ONCOOLDOWNDONE_HOOKED_ABC = {}
		end
		if not(GREYONCOOLDOWN_ONCOOLDOWNDONE_HOOKED_ABC[button]) then
			button.cooldown:HookScript("OnCooldownDone", ClassicUI.GOC_ButtonParentUpdateHookFunc)
			GREYONCOOLDOWN_ONCOOLDOWNDONE_HOOKED_ABC[button] = true
		end
		if (GREYONCOOLDOWN_ONSHOW_HOOKED_ABC == nil) then
			GREYONCOOLDOWN_ONSHOW_HOOKED_ABC = {}
		end
		if not(GREYONCOOLDOWN_ONSHOW_HOOKED_ABC[button]) then
			button.cooldown:HookScript("OnShow", ClassicUI.GOC_ButtonParentUpdateHookFunc)
			GREYONCOOLDOWN_ONSHOW_HOOKED_ABC[button] = true
		end
		if (GREYONCOOLDOWN_ONHIDE_HOOKED_ABC == nil) then
			GREYONCOOLDOWN_ONHIDE_HOOKED_ABC = {}
		end
		if not(GREYONCOOLDOWN_ONHIDE_HOOKED_ABC[button]) then
			button.cooldown:HookScript("OnHide", ClassicUI.GOC_ButtonParentUpdateHookFunc)
			GREYONCOOLDOWN_ONHIDE_HOOKED_ABC[button] = true
		end
	end
	if type(button.Update)=="function" then
		if (GREYONCOOLDOWN_UPDATE_HOOKED_AB == nil) then
			GREYONCOOLDOWN_UPDATE_HOOKED_AB = {}
		end
		if not(GREYONCOOLDOWN_UPDATE_HOOKED_AB[button]) then
			hooksecurefunc(button, "Update", ClassicUI.GOC_ButtonUpdateHookFunc)
			GREYONCOOLDOWN_UPDATE_HOOKED_AB[button] = true
		end
	end
	if type(button.UpdateUsable)=="function" then
		if (GREYONCOOLDOWN_UPDATEUSABLE_HOOKED_AB == nil) then
			GREYONCOOLDOWN_UPDATEUSABLE_HOOKED_AB = {}
		end
		if not(GREYONCOOLDOWN_UPDATEUSABLE_HOOKED_AB[button]) then
			hooksecurefunc(button, "UpdateUsable", ClassicUI.GOC_ButtonUpdateHookFunc)
			GREYONCOOLDOWN_UPDATEUSABLE_HOOKED_AB[button] = true
		end
	end
	-- ActionButton GOC hooks to update the RegisteredActionSpells when needed (AB hooks: UpdateAction)
	if type(button.UpdateAction) == "function" then
		if (GREYONCOOLDOWN_UPDATEACTION_HOOKED_AB == nil) then
			GREYONCOOLDOWN_UPDATEACTION_HOOKED_AB = {}
		end
		if not(GREYONCOOLDOWN_UPDATEACTION_HOOKED_AB[button]) then
			hooksecurefunc(button, "UpdateAction", ClassicUI.GOC_UpdateActionButtonAction)
			GREYONCOOLDOWN_UPDATEACTION_HOOKED_AB[button] = true
		end
	end
	ClassicUI.GOC_UpdateActionButtonAction(button)
end

-- Extra Option: GreyOnCooldown. Function that establishes the needed GOC hooks for an PetActionButton
function ClassicUI:GOC_HookGOCPetActionButtonUpdate(button)
	-- Establish the main GOC PetActionButton Update function
	if (GREYONCOOLDOWN_UPDATECHECK_SET_AB == nil) then
		GREYONCOOLDOWN_UPDATECHECK_SET_AB = {}
	end
	if not(GREYONCOOLDOWN_UPDATECHECK_SET_AB[button]) then
		button.GOCUpdateCheck = PetActionButton_GreyOnCooldown_UpdateCheck
		GREYONCOOLDOWN_UPDATECHECK_SET_AB[button] = true
	end
	-- PetActionButton essentials GOC hooks (AB hooks: OnCooldownDone, OnShow, OnHide, Update, UpdateCooldowns)
	if button.cooldown then
		if (GREYONCOOLDOWN_ONCOOLDOWNDONE_HOOKED_ABC == nil) then
			GREYONCOOLDOWN_ONCOOLDOWNDONE_HOOKED_ABC = {}
		end
		if not(GREYONCOOLDOWN_ONCOOLDOWNDONE_HOOKED_ABC[button]) then
			button.cooldown:HookScript("OnCooldownDone", ClassicUI.GOC_ButtonParentUpdateHookFunc)
			GREYONCOOLDOWN_ONCOOLDOWNDONE_HOOKED_ABC[button] = true
		end
		if (GREYONCOOLDOWN_ONSHOW_HOOKED_ABC == nil) then
			GREYONCOOLDOWN_ONSHOW_HOOKED_ABC = {}
		end
		if not(GREYONCOOLDOWN_ONSHOW_HOOKED_ABC[button]) then
			button.cooldown:HookScript("OnShow", ClassicUI.GOC_ButtonParentUpdateHookFunc)
			GREYONCOOLDOWN_ONSHOW_HOOKED_ABC[button] = true
		end
		if (GREYONCOOLDOWN_ONHIDE_HOOKED_ABC == nil) then
			GREYONCOOLDOWN_ONHIDE_HOOKED_ABC = {}
		end
		if not(GREYONCOOLDOWN_ONHIDE_HOOKED_ABC[button]) then
			button.cooldown:HookScript("OnHide", ClassicUI.GOC_ButtonParentUpdateHookFunc)
			GREYONCOOLDOWN_ONHIDE_HOOKED_ABC[button] = true
		end
	end
	if type(button.Update)=="function" then
		if (GREYONCOOLDOWN_UPDATE_HOOKED_AB == nil) then
			GREYONCOOLDOWN_UPDATE_HOOKED_AB = {}
		end
		if not(GREYONCOOLDOWN_UPDATE_HOOKED_AB[button]) then
			hooksecurefunc(button, "Update", ClassicUI.GOC_ButtonUpdateHookFunc)
			GREYONCOOLDOWN_UPDATE_HOOKED_AB[button] = true
		end
	end
	if not(GREYONCOOLDOWN_UPDATECOOLDOWNS_HOOKED_PAB) then
		if (PetActionBar ~= nil and type(PetActionBar.UpdateCooldowns) == "function") then
			hooksecurefunc(PetActionBar, "UpdateCooldowns", function(self)
				for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
					local button = self.actionButtons[i]
					if button then
						ClassicUI.GOC_UpdatePetActionButtonAction(button)
					end
				end
			end)
		end
		GREYONCOOLDOWN_UPDATECOOLDOWNS_HOOKED_PAB = true
	end
	ClassicUI.GOC_UpdatePetActionButtonAction(button)
end

-- Extra Option: GreyOnCooldown. Function to handle the SPELL_UPDATE_COOLDOWN event
function ClassicUI:SPELL_UPDATE_COOLDOWN(spellID, baseSpellID, category, startRecoveryCategory)
	if (spellID == nil) then
		spellID = baseSpellID
		if (spellID == nil) then
			return
		end
	end
	local spellCooldownInfo = C_Spell_GetSpellCooldown(spellID)
	if (spellCooldownInfo) then
		if (ClassicUI.GOC_RegisteredActionSpells[spellID]) then
			for k, _ in pairs(ClassicUI.GOC_RegisteredActionSpells[spellID]) do
				if (k.GOCUpdateCheck) then
					k:GOCUpdateCheck(spellCooldownInfo.isOnGCD or false)
				end
			end
		end
	end
	if (ClassicUI.GOC_RelatedActionSpells[spellID] ~= nil) then
		for _, relatedSpellID in pairs(ClassicUI.GOC_RelatedActionSpells[spellID]) do
			spellCooldownInfo = C_Spell_GetSpellCooldown(relatedSpellID)
			if (spellCooldownInfo) then
				if (ClassicUI.GOC_RegisteredActionSpells[relatedSpellID]) then
					for k, _ in pairs(ClassicUI.GOC_RegisteredActionSpells[relatedSpellID]) do
						if (k.GOCUpdateCheck) then
							k:GOCUpdateCheck(spellCooldownInfo.isOnGCD or false)
						end
					end
				end
			end
		end
	end
end

-- Extra Option: GreyOnCooldown. Function to set hooks for SpellFlyout frame to detect the newly created SpellFlyoutButtons
function ClassicUI:GOC_HookGOCSpellFlyout()
	if not(GREYONCOOLDOWN_SPELLFLYOUT_HOOKED) then
		hooksecurefunc(SpellFlyout, "Toggle", function(self, flyoutButton, flyoutID, isActionBar, specID, showFullTooltip, reason)
			if (not(self:IsShown()) and self.glyphActivating) then
				return
			end
			if (not(self:IsShown()) and self.flyoutButton == nil) then
				return
			end
			local offSpec = specID and (specID ~= 0)
			local _, _, numSlots, isKnown = GetFlyoutInfo(flyoutID)
			if ((not isKnown and not offSpec) or numSlots == 0) then
				return
			end
			local numButtons = 0
			for i = 1, numSlots do
				local spellID, _, isKnownSlot, _, slotSpecID = GetFlyoutSlotInfo(flyoutID, i)
				local visible = true
				local petIndex, petName = GetCallPetSpellInfo(spellID)
				if (isActionBar and petIndex and (not petName or petName == "")) then
					visible = false
				end
				if (((not offSpec or slotSpecID == 0) and visible and isKnownSlot) or (offSpec and slotSpecID == specID)) then
					local button = _G["SpellFlyoutPopupButton"..numButtons+1]
					if (button ~= nil) then
						ClassicUI:GOC_HookGOCActionButtonUpdate(button)
					end
					numButtons = numButtons+1
				end
			end
		end)
		GREYONCOOLDOWN_SPELLFLYOUT_HOOKED = true
	end
end

-- Extra Option: GreyOnCooldown. Function to iterate through ActionButtons and hook them
function ClassicUI:GOC_HookGOCActionButtons()
	for i = 1, ClassicUI.NUM_ACTIONBAR_BUTTONS do
		local actionButton
		actionButton = _G["ExtraActionButton"..i]
		if (actionButton) then
			ClassicUI:GOC_HookGOCActionButtonUpdate(actionButton)
		end
		actionButton = _G["ActionButton"..i]
		if (actionButton) then
			ClassicUI:GOC_HookGOCActionButtonUpdate(actionButton)
		end
		actionButton = _G["MultiBarBottomLeftButton"..i]
		if (actionButton) then
			ClassicUI:GOC_HookGOCActionButtonUpdate(actionButton)
		end
		actionButton = _G["MultiBarBottomRightButton"..i]
		if (actionButton) then
			ClassicUI:GOC_HookGOCActionButtonUpdate(actionButton)
		end
		actionButton = _G["MultiBarLeftButton"..i]
		if (actionButton) then
			ClassicUI:GOC_HookGOCActionButtonUpdate(actionButton)
		end
		actionButton = _G["MultiBarRightButton"..i]
		if (actionButton) then
			ClassicUI:GOC_HookGOCActionButtonUpdate(actionButton)
		end
		actionButton = _G["StanceButton"..i]
		if (actionButton) then
			ClassicUI:GOC_HookGOCActionButtonUpdate(actionButton)
		end
		actionButton = _G["PossessButton"..i]
		if (actionButton) then
			ClassicUI:GOC_HookGOCActionButtonUpdate(actionButton)
		end
		actionButton = _G["OverrideActionBarButton"..i]
		if (actionButton) then
			ClassicUI:GOC_HookGOCActionButtonUpdate(actionButton)
		end
	end
	for i = 1, 40 do
		local actionButton = _G["SpellFlyoutPopupButton"..i]
		if (actionButton) then
			ClassicUI:GOC_HookGOCActionButtonUpdate(actionButton)
		end
	end
	-- SpellFlyoutButtons are created dynamically as needed. This needs to be monitored to apply GOC hooks to new ones.
	-- Controlled in the ClassicUI 'SpellFlyout.Toogle' hook if ClassicUI core is enabled
	if not(ClassicUI:IsEnabled()) then
		ClassicUI:GOC_HookGOCSpellFlyout()
	end
	if not(GREYONCOOLDOWN_ACTIONBUTTON_UPDATECOOLDOWN_HOOKED) then
		hooksecurefunc("ActionButton_UpdateCooldown", ClassicUI.GOC_ButtonUpdateHookFunc)
		GREYONCOOLDOWN_ACTIONBUTTON_UPDATECOOLDOWN_HOOKED = true
	end
	if not(GREYONCOOLDOWN_MULTICASTSPELLBUTTON_UPDATECOOLDOWN_HOOKED) then
		hooksecurefunc("MultiCastSpellButton_UpdateCooldown", ClassicUI.GOC_ButtonUpdateHookFunc)
		GREYONCOOLDOWN_MULTICASTSPELLBUTTON_UPDATECOOLDOWN_HOOKED = true
	end
end

-- Extra Option: GreyOnCooldown. Function to iterate through PetActionButtons and hook them
function ClassicUI:GOC_HookGOCPetActionButtons()
	for i = 1, ClassicUI.NUM_PET_ACTION_SLOTS do
		local petActionButton = _G["PetActionButton"..i]
		if (petActionButton) then
			ClassicUI:GOC_HookGOCPetActionButtonUpdate(petActionButton)
		end
	end
end

-- Extra Option: GreyOnCooldown. Main function to desaturate the entire action icon when the spell is on cooldown or unusable
function ClassicUI:GOC_MainFunction()
	-- Main desaturation Curve that distinguishes between zero and a non-zero value
	ClassicUI.GOC_DesaturationCurve = C_CurveUtil.CreateCurve()
	ClassicUI.GOC_DesaturationCurve:SetType(Enum.LuaCurveType.Step)
	ClassicUI.GOC_DesaturationCurve:AddPoint(0, 0)
	ClassicUI.GOC_DesaturationCurve:AddPoint(0.001, 1)
	-- Alternative desaturation Curve that establishes the GCD duration as the step-point (for cases where isOnGCD is not available/reliable)
	ClassicUI.GOC_DesaturationCurveGCD = C_CurveUtil.CreateCurve()
	ClassicUI.GOC_DesaturationCurveGCD:SetType(Enum.LuaCurveType.Step)
	ClassicUI.GOC_DesaturationCurveGCD:AddPoint(0, 0)
	ClassicUI.GOC_DesaturationCurveGCD:AddPoint(ClassicUI.GOC_GCD, 1)

	-- Set ActionButton hooks to desaturate the entire action icon when the spell is on cooldown or unusable
	if not(GREYONCOOLDOWN_HOOKED) then
		ActionButton_GreyOnCooldown_UpdateCheck = ClassicUI.GOC_GOCActionButtonUpdateCheck
		PetActionButton_GreyOnCooldown_UpdateCheck = ClassicUI.GOC_GOCPetActionButtonUpdateCheck
		-- Register the SPELL_UPDATE_COOLDOWN event to update the AB (isOnGCD is updated at this event)
		if not(ClassicUI.frame:IsEventRegistered("SPELL_UPDATE_COOLDOWN")) then
			ClassicUI.frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		end
		-- Main ActionButtons
		ClassicUI:GOC_HookGOCActionButtons()
		-- Handle PetActionButtons
		if (ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.desaturatePetActionButtons) then
			ClassicUI:GOC_HookGOCPetActionButtons()
		end
		GREYONCOOLDOWN_HOOKED = ClassicUI or true
	end
end

-- Extra Option: Guild Panel Mode. Main function to hook the functionalities of the Guild Panel Mode extra option
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
			if (IsTrialAccount() or (IsVeteranTrialAccount() and not IsInGuild())) then
				UIErrorsFrame:AddMessage(ERR_RESTRICTED_ACCOUNT_TRIAL, 1.0, 0.1, 0.1, 1.0)
				return
			end
			if (IsInGuild()) then
				local loaded, reason = C_AddOns.LoadAddOn("ClassicUI_ClassicBlizzGuildUI")
				if (not loaded) then
					if (not ClassicUI.addonloadfailed_ClassicBlizzGuildUI) then
						ClassicUI.addonloadfailed_ClassicBlizzGuildUI = true
						SetBasicMessageDialogText(format(ADDON_LOAD_FAILED, "ClassicUI_ClassicBlizzGuildUI", _G["ADDON_"..reason]), true)
					end
					ToggleNewGuildFrame()
				else
					if (CUI_GuildFrame_Toggle) then
						CUI_GuildFrame_Toggle()
					end
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

		-- Set GuildMicroButton click specific hook
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
