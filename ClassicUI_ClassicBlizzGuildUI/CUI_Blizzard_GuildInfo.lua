local GUILD_BUTTON_HEIGHT = 84;
local GUILD_COMMENT_HEIGHT = 50;
local GUILD_COMMENT_BORDER = 10;

function CUI_GuildInfoFrame_OnLoad(self)
	CUI_GuildFrame_RegisterPanel(self);
	PanelTemplates_SetNumTabs(self, 1);

	self:RegisterEvent("GUILD_MOTD");
	self:RegisterEvent("GUILD_ROSTER_UPDATE");
	self:RegisterEvent("GUILD_RANKS_UPDATE");
	self:RegisterEvent("PLAYER_GUILD_UPDATE");
	self:RegisterEvent("GUILD_CHALLENGE_UPDATED");

	RequestGuildChallengeInfo();
end

function CUI_GuildInfoFrame_OnEvent(self, event, arg1)
	if ( event == "GUILD_MOTD" ) then
		CUI_GuildInfoMOTD:SetText(arg1, true);	--Ignores markup.
	elseif ( event == "GUILD_ROSTER_UPDATE" ) then
		CUI_GuildInfoFrame_UpdatePermissions();
		CUI_GuildInfoFrame_UpdateText();
	elseif ( event == "GUILD_RANKS_UPDATE" ) then
		CUI_GuildInfoFrame_UpdatePermissions();
	elseif ( event == "PLAYER_GUILD_UPDATE" ) then
		CUI_GuildInfoFrame_UpdatePermissions();
	elseif ( event == "GUILD_CHALLENGE_UPDATED" ) then
		CUI_GuildInfoFrame_UpdateChallenges();
	end
end

function CUI_GuildInfoFrame_OnShow(self)
	RequestGuildChallengeInfo();
end

function CUI_GuildInfoFrame_Update()
	local selectedTab = PanelTemplates_GetSelectedTab(CUI_GuildInfoFrame);
	if ( selectedTab == 1 ) then
		CUI_GuildInfoFrameInfo:Show();
	end
end

--*******************************************************************************
--   Info Tab
--*******************************************************************************

function CUI_GuildInfoFrameInfo_OnLoad(self)
	local fontString = CUI_GuildInfoEditMOTDButton:GetFontString();
	CUI_GuildInfoEditMOTDButton:SetHeight(fontString:GetHeight() + 4);
	CUI_GuildInfoEditMOTDButton:SetWidth(fontString:GetWidth() + 4);
	fontString = CUI_GuildInfoEditDetailsButton:GetFontString();
	CUI_GuildInfoEditDetailsButton:SetHeight(fontString:GetHeight() + 4);
	CUI_GuildInfoEditDetailsButton:SetWidth(fontString:GetWidth() + 4);
end

function CUI_GuildInfoFrameInfo_OnShow(self)
	CUI_GuildInfoFrame_UpdatePermissions();
	CUI_GuildInfoFrame_UpdateText();
end

function CUI_GuildInfoFrame_UpdatePermissions()
	if ( CanEditMOTD() ) then
		CUI_GuildInfoEditMOTDButton:Show();
	else
		CUI_GuildInfoEditMOTDButton:Hide();
	end
	if ( CanEditGuildInfo() ) then
		CUI_GuildInfoEditDetailsButton:Show();
	else
		CUI_GuildInfoEditDetailsButton:Hide();
	end
	local guildInfoFrame = CUI_GuildInfoFrame;
	if ( IsGuildLeader() ) then
		CUI_GuildControlButton:Enable();
	else
		CUI_GuildControlButton:Disable();
	end
	if ( CanGuildInvite() ) then
		CUI_GuildAddMemberButton:Enable();
		-- show the recruitment tabs
		if ( not guildInfoFrame.tabsShowing ) then
			guildInfoFrame.tabsShowing = true;
			CUI_GuildInfoFrameTab1:Show();
			PanelTemplates_SetTab(guildInfoFrame, 1);
			PanelTemplates_UpdateTabs(guildInfoFrame);
		end
	else
		CUI_GuildAddMemberButton:Disable();
		-- hide the recruitment tabs
		if ( guildInfoFrame.tabsShowing ) then
			guildInfoFrame.tabsShowing = nil;
			CUI_GuildInfoFrameTab1:Hide();
			if ( PanelTemplates_GetSelectedTab(guildInfoFrame) ~= 1 ) then
				PanelTemplates_SetTab(guildInfoFrame, 1);
				CUI_GuildInfoFrame_Update();
			end
		end
	end
end

function CUI_GuildInfoFrame_UpdateText(infoText)
	CUI_GuildInfoMOTD:SetText(GetGuildRosterMOTD(), true); --Extra argument ignores markup.
	CUI_GuildInfoDetails:SetText(infoText or GetGuildInfoText());
	CUI_GuildInfoDetailsFrame:SetVerticalScroll(0);
	--CUI_GuildInfoDetailsFrameScrollBarScrollUpButton:Disable();
end

function CUI_GuildInfoFrame_UpdateChallenges()
	local numChallenges = GetNumGuildChallenges();
	for i = 1, numChallenges do
		local index, current, max = GetGuildChallengeInfo(i);
		local frame = _G["CUI_GuildInfoFrameInfoChallenge"..index];
		if ( frame ) then
			frame.dataIndex = i;
			if ( current == max ) then
				frame.count:Hide();
				frame.check:Show();
				frame.label:SetTextColor(0.1, 1, 0.1);
			else
				frame.count:Show();
				frame.count:SetFormattedText(GUILD_CHALLENGE_PROGRESS_FORMAT, current, max);
				frame.check:Hide();
				frame.label:SetTextColor(1, 1, 1);
			end
		end
	end
end

--*******************************************************************************
--   Popups
--*******************************************************************************

function CUI_GuildTextEditFrame_OnLoad(self)
	CUI_GuildFrame_RegisterPopup(self);
	CUI_GuildTextEditBox:SetTextInsets(4, 0, 4, 4);
	CUI_GuildTextEditBox:SetSpacing(2);
end

function CUI_GuildTextEditFrame_Show(editType)
	if ( editType == "motd" ) then
		CUI_GuildTextEditFrame:SetHeight(200);	-- �or maybe 162?
		CUI_GuildTextEditBox:SetMaxLetters(128);
		CUI_GuildTextEditBox:SetText(GetGuildRosterMOTD());
		CUI_GuildTextEditFrameTitle:SetText(GUILD_MOTD_EDITLABEL);
		CUI_GuildTextEditBox:SetScript("OnEnterPressed", CUI_GuildTextEditFrame_OnAccept);
	elseif ( editType == "info" ) then
		CUI_GuildTextEditFrame:SetHeight(295);
		CUI_GuildTextEditBox:SetMaxLetters(500);
		CUI_GuildTextEditBox:SetText(GetGuildInfoText());
		CUI_GuildTextEditFrameTitle:SetText(GUILD_INFO_EDITLABEL);
		CUI_GuildTextEditBox:SetScript("OnEnterPressed", nil);
	end
	CUI_GuildTextEditFrame.type = editType;
	CUI_GuildFramePopup_Show(CUI_GuildTextEditFrame);
	CUI_GuildTextEditBox:SetCursorPosition(0);
	CUI_GuildTextEditBox:SetFocus();
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
end

function CUI_GuildTextEditFrame_OnAccept()
	if ( CUI_GuildTextEditFrame.type == "motd" ) then
		GuildSetMOTD(CUI_GuildTextEditBox:GetText());
	elseif ( CUI_GuildTextEditFrame.type == "info" ) then
		local infoText = CUI_GuildTextEditBox:GetText();
		SetGuildInfoText(infoText);
		CUI_GuildInfoFrame_UpdateText(infoText);
	end
	CUI_GuildTextEditFrame:Hide();
end

function CUI_GuildLogFrame_OnLoad(self)
	CUI_GuildFrame_RegisterPopup(self);
	CUI_GuildLogHTMLFrame:SetSpacing("P", 2);
	--ScrollBar_AdjustAnchors(CUI_GuildLogScrollFrameScrollBar, 0, -2);
	self:RegisterEvent("GUILD_EVENT_LOG_UPDATE");
end

function CUI_GuildLogFrame_Update()
	local numEvents = GetNumGuildEvents();
	local type, player1, player2, rank, year, month, day, hour;
	local msg;
	local buffer = "";
	for i = numEvents, 1, -1 do
		type, player1, player2, rank, year, month, day, hour = GetGuildEventInfo(i);
		if ( not player1 ) then
			player1 = UNKNOWN;
		end
		if ( not player2 ) then
			player2 = UNKNOWN;
		end
		if ( type == "invite" ) then
			msg = format(GUILDEVENT_TYPE_INVITE, player1, player2);
		elseif ( type == "join" ) then
			msg = format(GUILDEVENT_TYPE_JOIN, player1);
		elseif ( type == "promote" ) then
			msg = format(GUILDEVENT_TYPE_PROMOTE, player1, player2, rank);
		elseif ( type == "demote" ) then
			msg = format(GUILDEVENT_TYPE_DEMOTE, player1, player2, rank);
		elseif ( type == "remove" ) then
			msg = format(GUILDEVENT_TYPE_REMOVE, player1, player2);
		elseif ( type == "quit" ) then
			msg = format(GUILDEVENT_TYPE_QUIT, player1);
		end
		if ( msg ) then
			buffer = buffer..msg..GUILD_BANK_LOG_TIME:format(RecentTimeDate(year, month, day, hour)).."|n";
		end
	end
	CUI_GuildLogHTMLFrame:SetText(buffer);
end