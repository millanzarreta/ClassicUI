local GUILD_REWARDS_BUTTON_OFFSET = 0;
local GUILD_REWARDS_BUTTON_HEIGHT = 47;
local GUILD_REWARDS_ACHIEVEMENT_ICON = " |TInterface\\AchievementFrame\\UI-Achievement-Guild:18:16:0:1:512:512:324:344:67:85|t ";

function CUI_GuildRewardsFrame_OnLoad(self)
	CUI_GuildFrame_RegisterPanel(self);
	CUI_GuildRewardsContainer.update = CUI_GuildRewards_Update;
	HybridScrollFrame_CreateButtons(CUI_GuildRewardsContainer, "CUI_GuildRewardsButtonTemplate", 1, 0);
	CUI_GuildRewardsContainerScrollBar.doNotHide = true;
	self:RegisterEvent("GUILD_REWARDS_LIST");
end

function CUI_GuildRewardsFrame_OnShow(self)
	RequestGuildRewards();
end

function CUI_GuildRewardsFrame_OnHide(self)
	if ( CUI_GuildRewardsDropDown.rewardIndex ) then
		CloseDropDownMenus();
	end
end

function CUI_GuildRewardsFrame_OnEvent(self, event)
	CUI_GuildRewards_Update();
end

function CUI_GuildRewards_Update()
	local scrollFrame = CUI_GuildRewardsContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local button, index;
	local playerMoney = GetMoney();
	local numRewards = GetNumGuildRewards();
	local gender = UnitSex("player");
	local guildFactionData = C_Reputation.GetGuildFactionData();

	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i;
		local achievementID, itemID, itemName, iconTexture, repLevel, moneyCost = GetGuildRewardInfo(index);
		if ( itemName ) then
			button.name:SetText(itemName);
			button.icon:SetTexture(iconTexture);
			button:Show();
			if ( moneyCost and moneyCost > 0 ) then
				MoneyFrame_Update(button.money:GetName(), moneyCost);
				if ( playerMoney >= moneyCost ) then
					SetMoneyFrameColor(button.money:GetName(), "white");
				else
					SetMoneyFrameColor(button.money:GetName(), "red");
				end
				button.money:Show();
			else
				button.money:Hide();
			end
			if ( achievementID and achievementID > 0 ) then
				local id, name = GetAchievementInfo(achievementID)
				button.achievementID = achievementID;
				button.subText:SetText(REQUIRES_LABEL..GUILD_REWARDS_ACHIEVEMENT_ICON..YELLOW_FONT_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE);
				button.subText:Show();
				button.disabledBG:Show();
				button.icon:SetVertexColor(1, 1, 1);
				button.icon:SetDesaturated(true);
				button.name:SetFontObject(GameFontNormalLeftGrey);
				button.lock:Show();
			else
				button.achievementID = nil;
				button.disabledBG:Hide();
				button.icon:SetDesaturated(false);
				button.name:SetFontObject(GameFontNormal);
				button.lock:Hide();
				if ( guildFactionData and repLevel > guildFactionData.reaction ) then
					local factionStandingtext = GetText("FACTION_STANDING_LABEL"..repLevel, gender);
					button.subText:SetFormattedText(REQUIRES_GUILD_FACTION, factionStandingtext);
					button.subText:Show();
					button.icon:SetVertexColor(1, 0, 0);
				else
					button.subText:Hide();
					button.icon:SetVertexColor(1, 1, 1);
				end
			end
			button.index = index;
		else
			button:Hide();
		end
	end
	local totalHeight = numRewards * (GUILD_REWARDS_BUTTON_HEIGHT + GUILD_REWARDS_BUTTON_OFFSET);
	local displayedHeight = numButtons * (GUILD_REWARDS_BUTTON_HEIGHT + GUILD_REWARDS_BUTTON_OFFSET);
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
	
	-- hide dropdown menu
	if ( CUI_GuildRewardsDropDown.rewardIndex ) then
		CloseDropDownMenus();
	end
	-- update tooltip
	if ( CUI_GuildRewardsFrame.activeButton ) then
		CUI_GuildRewardsButton_OnEnter(CUI_GuildRewardsFrame.activeButton);
	end	
end

function CUI_GuildRewardsButton_OnEnter(self)
	CUI_GuildRewardsFrame.activeButton = self;
	local achievementID, itemID, itemName, iconTexture, repLevel, moneyCost = GetGuildRewardInfo(self.index);
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 28, 0);
	if (itemID ~= nil) then
		GameTooltip:SetHyperlink("item:"..itemID);
	end
	if ( achievementID and achievementID > 0 ) then
		local id, name, _, _, _, _, _, description = GetAchievementInfo(achievementID)
		GameTooltip:AddLine(" ", 1, 0, 0, true);
		GameTooltip:AddLine(REQUIRES_GUILD_ACHIEVEMENT, 1, 0, 0, true);
		GameTooltip:AddLine(ACHIEVEMENT_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE);
		GameTooltip:AddLine(description, 1, 1, 1, true);
	end
	local guildFactionData = C_Reputation.GetGuildFactionData();
	if ( guildFactionData and repLevel > guildFactionData.reaction ) then
		local gender = UnitSex("player");
		local factionStandingtext = GetText("FACTION_STANDING_LABEL"..repLevel, gender);
		GameTooltip:AddLine(" ", 1, 0, 0, true);
		GameTooltip:AddLine(string.format(REQUIRES_GUILD_FACTION_TOOLTIP, factionStandingtext), 1, 0, 0, true);
	end
	self.UpdateTooltip = CUI_GuildRewardsButton_OnEnter;
	GameTooltip:Show();
end

function CUI_GuildRewardsButton_OnLeave(self)
	GameTooltip:Hide();
	CUI_GuildRewardsFrame.activeButton = nil;
	self.UpdateTooltip = nil;
end

function CUI_GuildRewardsButton_OnClick(self, button)
	if ( IsModifiedClick("CHATLINK") ) then
		local achievementID, itemID, itemName, iconTexture, repLevel, moneyCost = GetGuildRewardInfo(self.index);
		CUI_GuildFrame_LinkItem(_, itemID);
	elseif ( button == "RightButton" ) then
		local dropDown = CUI_GuildRewardsDropDown;
		if ( dropDown.rewardIndex ~= self.index ) then
			CloseDropDownMenus();
		end
		dropDown.rewardIndex = self.index;
		dropDown.onHide = CUI_GuildRewardsDropDown_OnHide;
		ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3);
	end
end

--****** Dropdown **************************************************************

function CUI_GuildRewardsDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, CUI_GuildRewardsDropDown_Initialize, "MENU");
end

function CUI_GuildRewardsDropDown_Initialize(self)
	if ( not self.rewardIndex ) then
		return;
	end
	
	local achievementID, itemID, itemName, iconTexture, repLevel, moneyCost = GetGuildRewardInfo(self.rewardIndex);

	local info = UIDropDownMenu_CreateInfo();
	info.notCheckable = 1;
	info.isTitle = 1;
	info.text = itemName;
	UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL);
	info = UIDropDownMenu_CreateInfo();
	info.notCheckable = 1;

	info.func = CUI_GuildFrame_LinkItem;
	info.text = GUILD_NEWS_LINK_ITEM;
	info.arg1 = itemID;
	UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL);
		
	if ( achievementID and achievementID > 0 ) then
		info.func = CUI_GuildFrame_OpenAchievement;
		info.text = GUILD_NEWS_VIEW_ACHIEVEMENT;
		info.arg1 = achievementID;
		UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL);
	end
end

function CUI_GuildRewardsDropDown_OnHide(self)
	CUI_GuildRewardsDropDown.rewardIndex = nil;
end