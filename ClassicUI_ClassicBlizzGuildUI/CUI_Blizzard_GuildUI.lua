UIPanelWindows["CUI_GuildFrame"] = { area = "left", pushable = 1, whileDead = 1 };
local GUILDFRAME_PANELS = { };
local GUILDFRAME_POPUPS = { };
local BUTTON_WIDTH_WITH_SCROLLBAR = 298;
local BUTTON_WIDTH_NO_SCROLLBAR = 320;

function CUI_GuildFrame_OnLoad(self)
	self:RegisterEvent("GUILD_ROSTER_UPDATE");
	self:RegisterEvent("PLAYER_GUILD_UPDATE");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("UPDATE_FACTION");
	self:RegisterEvent("GUILD_RENAME_REQUIRED");
	self:RegisterEvent("REQUIRED_GUILD_RENAME_RESULT");
	CUI_GuildFrame.hasForcedNameChange = GetGuildRenameRequired();
	PanelTemplates_SetNumTabs(self, 5);
	RequestGuildRewards();
--	QueryGuildXP();
	QueryGuildNews();
	C_Calendar.OpenCalendar();		-- to get event data
	CUI_GuildFrame_UpdateTabard();
	CUI_GuildFrame_UpdateFaction();
	local guildName, _, _, realm = GetGuildInfo("player");
	local fullName;
	if (realm) then
		fullName = string.format(FULL_PLAYER_NAME, guildName, realm);
	else
		fullName = guildName
	end

	self:SetTitle(fullName);
	local totalMembers, onlineMembers, onlineAndMobileMembers = GetNumGuildMembers();
	CUI_GuildFrameMembersCount:SetText(onlineAndMobileMembers.." / "..totalMembers);
end

function CUI_GuildFrame_OnShow(self)
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
	CUI_GuildFrameTab1:Show();
	CUI_GuildFrameTab3:Show();
	CUI_GuildFrameTab4:Show();
	CUI_GuildFrameTab2:SetPoint("LEFT", CUI_GuildFrameTab1, "RIGHT", -15, 0);
	CUI_GuildFrameTab5:SetPoint("LEFT", CUI_GuildFrameTab4, "RIGHT", -15, 0);
	if ( not PanelTemplates_GetSelectedTab(self) ) then
		CUI_GuildFrame_TabClicked(CUI_GuildFrameTab1);
	end
	C_GuildInfo.GuildRoster();
	UpdateMicroButtons();
	CUI_GuildNameChangeAlertFrame.topAnchored = true;
	CUI_GuildFrame.hasForcedNameChange = GetGuildRenameRequired();
	CUI_GuildFrame_CheckName();

	if (CUI_GuildFrameTitleText:IsTruncated()) then
		CUI_GuildFrame.TitleMouseover.tooltip = CUI_GuildFrameTitleText:GetText();
	else
		CUI_GuildFrame.TitleMouseover.tooltip = nil;
	end

	-- keep points frame centered
	local pointFrame = CUI_GuildPointFrame;
	pointFrame.SumText:SetText(BreakUpLargeNumbers(GetTotalAchievementPoints(true)));
	local width = pointFrame.SumText:GetStringWidth() + pointFrame.LeftCap:GetWidth() + pointFrame.RightCap:GetWidth() + pointFrame.Icon:GetWidth();
	pointFrame:SetWidth(width);
end

function CUI_GuildFrame_OnHide(self)
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
	UpdateMicroButtons();
	CUI_CloseGuildMenus();
end

function CUI_GuildFrame_Toggle()
	if not(InCombatLockdown()) then	-- show/hide UI panels in combat is forbidden for insecure code
		if ( CUI_GuildFrame:IsShown() ) then
			HideUIPanel(CUI_GuildFrame);
		else
			ShowUIPanel(CUI_GuildFrame);
		end
	end
end

function CUI_GuildFrame_OnEvent(self, event, ...)
	if ( event == "GUILD_ROSTER_UPDATE" ) then
		local totalMembers, onlineMembers, onlineAndMobileMembers = GetNumGuildMembers();
		CUI_GuildFrameMembersCount:SetText(onlineAndMobileMembers.." / "..totalMembers);
	elseif ( event == "UPDATE_FACTION" ) then
		CUI_GuildFrame_UpdateFaction();
	elseif ( event == "PLAYER_GUILD_UPDATE" ) then
		if ( IsInGuild() ) then
			local guildName = GetGuildInfo("player");
			self:SetTitle(guildName);
			CUI_GuildFrame_UpdateTabard();
		else
			if not(InCombatLockdown()) then	-- show/hide UI panels in combat is forbidden for insecure code
				if ( self:IsShown() ) then
					HideUIPanel(self);
				end
			end
		end
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
--		QueryGuildXP();
		QueryGuildNews();
	elseif ( event == "GUILD_RENAME_REQUIRED" ) then
		CUI_GuildFrame.hasForcedNameChange = ...;
		CUI_GuildFrame_CheckName();
	elseif ( event == "REQUIRED_GUILD_RENAME_RESULT" ) then
		local success = ...
		if ( success ) then
			CUI_GuildFrame.hasForcedNameChange = GetGuildRenameRequired();
			CUI_GuildFrame_CheckName();
		else
			UIErrorsFrame:AddMessage(ERR_GUILD_NAME_INVALID, 1.0, 0.1, 0.1, 1.0);
		end
	end
end

function CUI_GuildFrame_UpdateFaction()
	local factionBar = CUI_GuildFactionFrame;
	local gender = UnitSex("player");
	local guildFactionData = C_Reputation.GetGuildFactionData();
	local barMin, barMax, barValue = guildFactionData.currentReactionThreshold, guildFactionData.nextReactionThreshold, guildFactionData.currentStanding;
	local factionStandingtext = GetText("FACTION_STANDING_LABEL"..guildFactionData.reaction, gender);
	--Normalize Values
	barMax = barMax - barMin;
	barValue = barValue - barMin;
	if (barMax == 0) then
		barValue = 1;
		barMax = 1;
	end
	CUI_GuildFactionBarLabel:SetText(barValue.." / "..barMax);
	CUI_GuildFactionFrameStanding:SetText(factionStandingtext);
	CUI_GuildBar_SetProgress(CUI_GuildFactionBar, barValue, barMax);
end

function CUI_GuildFrame_UpdateTabard()
	SetLargeGuildTabardTextures("player", CUI_GuildFrameTabardEmblem, CUI_GuildFrameTabardBackground, CUI_GuildFrameTabardBorder);
end

function CUI_GuildFrame_CheckPermissions()
	if ( IsGuildLeader() ) then
		CUI_GuildControlButton:Enable();
	else
		CUI_GuildControlButton:Disable();
	end
	if ( CanGuildInvite() ) then
		CUI_GuildAddMemberButton:Enable();
	else
		CUI_GuildAddMemberButton:Disable();
	end
end

function CUI_GuildFrame_CheckName()
	if ( CUI_GuildFrame.hasForcedNameChange ) then
		local clickableHelp = false
		CUI_GuildNameChangeAlertFrame:Show();

		if ( IsGuildLeader() ) then
			CUI_GuildNameChangeFrame.gmText:Show();
			CUI_GuildNameChangeFrame.memberText:Hide();
			CUI_GuildNameChangeFrame.button:SetText(ACCEPT);
			CUI_GuildNameChangeFrame.button:SetPoint("TOP", CUI_GuildNameChangeFrame.editBox, "BOTTOM", 0, -10);
			CUI_GuildNameChangeFrame.renameText:Show();
			CUI_GuildNameChangeFrame.editBox:Show();
		else
			clickableHelp = CUI_GuildNameChangeAlertFrame.topAnchored;
			CUI_GuildNameChangeFrame.gmText:Hide();
			CUI_GuildNameChangeFrame.memberText:Show();
			CUI_GuildNameChangeFrame.button:SetText(OKAY);
			CUI_GuildNameChangeFrame.button:SetPoint("TOP", CUI_GuildNameChangeFrame.memberText, "BOTTOM", 0, -30);
			CUI_GuildNameChangeFrame.renameText:Hide();
			CUI_GuildNameChangeFrame.editBox:Hide();
		end


		if ( clickableHelp ) then
			CUI_GuildNameChangeAlertFrame.alert:SetFontObject(GameFontHighlight);
			CUI_GuildNameChangeAlertFrame.alert:ClearAllPoints();
			CUI_GuildNameChangeAlertFrame.alert:SetPoint("BOTTOM", CUI_GuildNameChangeAlertFrame, "CENTER", 0, 0);
			CUI_GuildNameChangeAlertFrame.alert:SetWidth(190);
			CUI_GuildNameChangeAlertFrame:SetPoint("TOP", 15, -4);
			CUI_GuildNameChangeAlertFrame:SetSize(256, 60);
			CUI_GuildNameChangeAlertFrame:Enable();
			CUI_GuildNameChangeAlertFrame.clickText:Show();
			CUI_GuildNameChangeFrame:Hide();
		else
			CUI_GuildNameChangeAlertFrame.alert:SetFontObject(GameFontHighlightMedium);
			CUI_GuildNameChangeAlertFrame.alert:ClearAllPoints();
			CUI_GuildNameChangeAlertFrame.alert:SetPoint("CENTER", CUI_GuildNameChangeAlertFrame, "CENTER", 0, 0);
			CUI_GuildNameChangeAlertFrame.alert:SetWidth(220);
			CUI_GuildNameChangeAlertFrame:SetPoint("TOP", 0, -82);
			CUI_GuildNameChangeAlertFrame:SetSize(300, 40);
			CUI_GuildNameChangeAlertFrame:Disable();
			CUI_GuildNameChangeAlertFrame.clickText:Hide();
			CUI_GuildNameChangeFrame:Show();
		end
	else
		CUI_GuildNameChangeAlertFrame:Hide();
		CUI_GuildNameChangeFrame:Hide();
	end
end

function CUI_GuildPointFrame_OnEnter(self)
	self.Highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(GUILD_POINTS_TT, 1, 1, 1);
	GameTooltip:Show();
end

function CUI_GuildPointFrame_OnLeave(self)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function CUI_GuildPointFrame_OnMouseUp(self)
	if ( IsInGuild() and CanShowAchievementUI() ) then
		AchievementFrame_LoadUI();
		AchievementFrame_ToggleAchievementFrame(false, true);
	end
end

--****** Common Functions *******************************************************

function CUI_GuildFrame_OpenAchievement(button, achievementID)
	if ( not AchievementFrame ) then
		AchievementFrame_LoadUI();
	end
	if ( not AchievementFrame:IsShown() ) then
		AchievementFrame_ToggleAchievementFrame();
	end
	AchievementFrame_SelectAchievement(achievementID);
end

function CUI_GuildFrame_LinkItem(button, itemID, itemLink)
	itemLink = itemLink or select(2, GetItemInfo(itemID));
	if ( itemLink ) then
		if ( ChatEdit_GetActiveWindow() ) then
			ChatEdit_InsertLink(itemLink);
		else
			ChatFrame_OpenChat(itemLink);
		end
	end
end

function CUI_GuildFrame_UpdateScrollFrameWidth(scrollFrame)
	local newButtonWidth;
	local buttons = scrollFrame.buttons;

	if ( scrollFrame.scrollBar:IsShown() ) then
		if ( scrollFrame.wideButtons ) then
			newButtonWidth = BUTTON_WIDTH_WITH_SCROLLBAR;
		end
	else
		if ( not scrollFrame.wideButtons ) then
			newButtonWidth = BUTTON_WIDTH_NO_SCROLLBAR;
		end
	end
	if ( newButtonWidth ) then
		for i = 1, #buttons do
			buttons[i]:SetWidth(newButtonWidth);
		end
		scrollFrame.wideButtons = not scrollFrame.wideButtons;
		scrollFrame:SetWidth(newButtonWidth);
		scrollFrame.scrollChild:SetWidth(newButtonWidth);
	end
end

--****** Panels/Popups **********************************************************

function CUI_GuildFrame_RegisterPanel(frame)
	tinsert(GUILDFRAME_PANELS, frame:GetName());
end

function CUI_GuildFrame_ShowPanel(frameName)
	local frame;
	for index, value in pairs(GUILDFRAME_PANELS) do
		if ( value == frameName ) then
			frame = _G[value];
		else
			_G[value]:Hide();
		end
	end
	if ( frame ) then
		frame:Show();
	end
end

function CUI_GuildFrame_RegisterPopup(frame)
	tinsert(GUILDFRAME_POPUPS, frame:GetName());
end

function CUI_GuildFramePopup_Show(frame)
	local name = frame:GetName();
	for index, value in ipairs(GUILDFRAME_POPUPS) do
		if ( name ~= value ) then
			_G[value]:Hide();
		end
	end
	frame:Show();
end

function CUI_GuildFramePopup_Toggle(frame)
	if ( frame:IsShown() ) then
		frame:Hide();
	else
		CUI_GuildFramePopup_Show(frame);
	end
end

function CUI_CloseGuildMenus()
	for index, value in ipairs(GUILDFRAME_POPUPS) do
		local frame = _G[value];
		if ( frame:IsShown() ) then
			frame:Hide();
			return true;
		end
	end
end

--****** Tabs *******************************************************************

function CUI_GuildFrame_TabClicked(self)
	local updateRosterCount = false;
	local tabIndex = self:GetID();
	CUI_CloseGuildMenus();
	PanelTemplates_SetTab(self:GetParent(), tabIndex);
	if ( tabIndex == 1 ) then -- News
		ButtonFrameTemplate_HideButtonBar(CUI_GuildFrame);
		CUI_GuildFrame_ShowPanel("CUI_GuildNewsFrame");
		CUI_GuildFrameInset:SetPoint("TOPLEFT", 4, -65);
		CUI_GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 44);
		CUI_GuildFrameBottomInset:Hide();
		CUI_GuildPointFrame:Show();
		CUI_GuildFactionFrame:Show();
		updateRosterCount = true;
		CUI_GuildFrameMembersCountLabel:Hide();
	elseif ( tabIndex == 2 ) then -- Roster
		ButtonFrameTemplate_HideButtonBar(CUI_GuildFrame);
		CUI_GuildFrame_ShowPanel("CUI_GuildRosterFrame");
		CUI_GuildFrameInset:SetPoint("TOPLEFT", 4, -90);
		CUI_GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 26);
		CUI_GuildFrameBottomInset:Hide();
		CUI_GuildPointFrame:Hide();
		CUI_GuildFactionFrame:Hide();
		updateRosterCount = true;
		CUI_GuildFrameMembersCountLabel:Show();
	elseif ( tabIndex == 3 ) then -- Perks
		ButtonFrameTemplate_HideButtonBar(CUI_GuildFrame);
		CUI_GuildFrame_ShowPanel("CUI_GuildPerksFrame");
		CUI_GuildFrameInset:SetPoint("TOPLEFT", 4, -65);
		CUI_GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 26);
		CUI_GuildPointFrame:Show();
		CUI_GuildFactionFrame:Hide();
		updateRosterCount = true;
		CUI_GuildFrameMembersCountLabel:Show();
		CUI_GuildPerksFrameMembersCountLabel:Hide();
		CUI_GuildFrameBottomInset:Hide();
	elseif ( tabIndex == 4 ) then -- Rewards
		ButtonFrameTemplate_HideButtonBar(CUI_GuildFrame);
		CUI_GuildFrame_ShowPanel("CUI_GuildRewardsFrame");
		CUI_GuildFrameInset:SetPoint("TOPLEFT", 4, -65);
		CUI_GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 44);
		CUI_GuildFrameBottomInset:Hide();
		CUI_GuildPointFrame:Hide();
		CUI_GuildFactionFrame:Show();
		updateRosterCount = true;
		CUI_GuildFrameMembersCountLabel:Hide();
	elseif ( tabIndex == 5 ) then -- Info
		ButtonFrameTemplate_ShowButtonBar(CUI_GuildFrame);
		CUI_GuildFrame_ShowPanel("CUI_GuildInfoFrame");
		CUI_GuildFrameInset:SetPoint("TOPLEFT", 4, -65);
		CUI_GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 26);
		CUI_GuildFrameBottomInset:Hide();
		CUI_GuildPointFrame:Hide();
		CUI_GuildFactionFrame:Hide();
		CUI_GuildFrameMembersCountLabel:Hide();
	end
	if ( updateRosterCount ) then
		C_GuildInfo.GuildRoster();
		CUI_GuildFrameMembersCount:Show();
	else
		CUI_GuildFrameMembersCount:Hide();
	end
end

function CUI_GuildFactionBar_OnEnter(self)
	local guildFactionData = C_Reputation.GetGuildFactionData();
	local barMin, barMax, barValue = guildFactionData.currentReactionThreshold, guildFactionData.nextReactionThreshold, guildFactionData.currentStanding;
	local factionStandingtext = GetText("FACTION_STANDING_LABEL"..guildFactionData.reaction);
	--Normalize Values
	barMax = barMax - barMin;
	barValue = barValue - barMin;
	if (barMax == 0) then
		barValue = 1;
		barMax = 1;
	end

	CUI_GuildFactionBarLabel:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(GUILD_REPUTATION);
	GameTooltip:AddLine(guildFactionData.description, 1, 1, 1, true);
	local percentTotal = tostring(math.ceil((barValue / barMax) * 100));
	GameTooltip:AddLine(string.format(GUILD_EXPERIENCE_CURRENT, BreakUpLargeNumbers(barValue), BreakUpLargeNumbers(barMax), percentTotal));
	GameTooltip:Show();
end

function CUI_GuildBar_SetProgress(bar, currentValue, maxValue)
	if (maxValue == 0) then
		maxValue = 1;
	end

	local MAX_BAR = bar:GetWidth() - 4;
	local progress = min(MAX_BAR * currentValue / maxValue, MAX_BAR);
	bar.progress:SetWidth(progress + 1);
	bar.cap:Hide();
	bar.capMarker:Hide();
	-- hide shadow on progress bar near the right edge
	if ( progress > MAX_BAR - 4 ) then
		bar.shadow:Hide();
	else
		bar.shadow:Show();
	end
	currentValue = BreakUpLargeNumbers(currentValue);
	maxValue = BreakUpLargeNumbers(maxValue);
end

--*******************************************************************************
--   Guild Panel
--*******************************************************************************

function CUI_GuildPerksFrame_OnLoad(self)
	CUI_GuildFrame_RegisterPanel(self);
	CUI_GuildPerksContainer.update = CUI_GuildPerks_Update;
	HybridScrollFrame_CreateButtons(CUI_GuildPerksContainer, "CUI_GuildPerksButtonTemplate", 8, 0, "TOPLEFT", "TOPLEFT", 0, 0, "TOP", "BOTTOM");
	self:RegisterEvent("GUILD_ROSTER_UPDATE");
	-- create buttons table for news update
	local buttons = { };
	for i = 1, 9 do
		tinsert(buttons, _G["GuildUpdatesButton"..i]);
	end
	CUI_GuildPerksFrame.buttons = buttons;
end

function CUI_GuildPerksFrame_OnShow(self)
	CUI_GuildPerks_Update();
end

function CUI_GuildPerksFrame_OnEvent(self, event, ...)
	if ( not self:IsShown() ) then
		return;
	end
	if ( event == "GUILD_ROSTER_UPDATE" ) then
		local canRequestRosterUpdate = ...;
		if ( canRequestRosterUpdate ) then
			C_GuildInfo.GuildRoster();
		end
	end
end

--****** News/Events ************************************************************
function CUI_GuildEventButton_OnClick(self, button)
	if ( button == "LeftButton" ) then
		if ( CalendarFrame ) then
			CalendarFrame_OpenToGuildEventIndex(self.index);
		else
			ToggleCalendar();
			CalendarFrame_OpenToGuildEventIndex(self.index);
		end
	end
end

--****** Perks ******************************************************************

function CUI_GuildPerksButton_OnEnter(self)
	CUI_GuildPerksContainer.activeButton = self;
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 36, 0);
	local spellLink = GetSpellLink(self.spellID);
	if (spellLink ~= nil) then
		GameTooltip:SetHyperlink(spellLink);
	end
end

function CUI_GuildPerks_Update()
	local scrollFrame = CUI_GuildPerksContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local button, index;
	local numPerks = GetNumGuildPerks();
--	local guildLevel = GetGuildLevel();

	local totalHeight = numPerks * scrollFrame.buttonHeight;
	local displayedHeight = numButtons * scrollFrame.buttonHeight;
	local buttonWidth = scrollFrame.buttonWidth;
	if( totalHeight > displayedHeight )then
		scrollFrame:SetPoint("TOPLEFT", CUI_GuildAllPerksFrame, "TOPLEFT", 0, scrollFrame.yOffset);
		scrollFrame:SetWidth( scrollFrame.width );
		scrollFrame:SetHeight( scrollFrame.height );
	else
		buttonWidth = scrollFrame.buttonWidthNoScroll;
		scrollFrame:SetPoint("TOPLEFT", CUI_GuildAllPerksFrame, "TOPLEFT", 0, scrollFrame.yOffsetNoScroll);
		scrollFrame:SetWidth( scrollFrame.widthNoScroll );
		scrollFrame:SetHeight( scrollFrame.heightNoScroll );
	end
	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i;
		if ( index <= numPerks ) then
			local name, spellID, iconTexture = GetGuildPerkInfo(index);
			button.name:SetText(name);
			button.icon:SetTexture(iconTexture);
			button.spellID = spellID;
			button:Show();
			button:SetWidth(buttonWidth);
		else
			button:Hide();
		end
	end
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);

	-- update tooltip
	if ( scrollFrame.activeButton ) then
		CUI_GuildPerksButton_OnEnter(scrollFrame.activeButton);
	end
end

--****** Aux ********************************************************************

local AL = LibStub and LibStub("AceLocale-3.0")
local L = AL and AL:GetLocale("ClassicUI") or (ClassicUI and ClassicUI.L)
local textCGPF = L and L['CUI_GUILD_PROTECTEDFUNC'] or 'Functionality not available from ClassicUI Guild Panel, please use Blizzard\'s default Guild UI for this action'
StaticPopupDialogs["CUI_GUILD_PROTECTEDFUNC_W"] = {
	text = textCGPF,
	button1 = OKAY,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = STATICPOPUP_NUMDIALOGS or 3,	-- avoid some UI taint
}

local textCGPFGI = GUILD_IMPEACH_POPUP_TEXT .. "\n\n" .. textCGPF
StaticPopupDialogs["CUI_GUILD_PROTECTEDFUNC_IMPEACH_W"] = {
	text = textCGPFGI,
	button1 = OKAY,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = STATICPOPUP_NUMDIALOGS or 3,	-- avoid some UI taint
}
