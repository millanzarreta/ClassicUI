local L = LibStub("AceLocale-3.0"):GetLocale("ClassicUI")

ClassicUI.optionsTable = {
	type = 'group',
	icon = '',
	name = L['ClassicUI'],
	args = {
		general = {
			order = 1,
			type = "group",
			name = L['General Settings'],
			childGroups = "tab",
			args = {
				versionD = {
					order = 1,
					type = "description",
					name = '\124cfffb5e26' .. L['Version'] .. ': v' .. ClassicUI.VERSION .. '\124r'
				},
				authorD = {
					order = 2,
					type = "description",
					name = '\124cfffb5e26' .. L['Author: Millán-Sanguino'] .. '\124r'
				},
				Spacer1 = {
					type = "description",
					order = 3,
					name = " "
				},
				enabled = {
					order = 4,
					type = "toggle",
					name = L['Enable ClassicUI core'],
					desc = L['EnableClassicUICoreDesc'],
					width = 1.25,
					confirm = function(_, newValue)
						if (not newValue) then
							return L['RELOADUI_MSG']
						else
							return false
						end
					end,
					get = function() return ClassicUI.db.profile.enabled end,
					set = function(_,value)
						ClassicUI.db.profile.enabled = value
						if value then
							if (not ClassicUI:IsEnabled()) then
								ClassicUI:Enable()
								ClassicUI:MainFunction()
								ClassicUI:ExtraOptionsFunc()
							end
						else
							if (ClassicUI:IsEnabled()) then
								ClassicUI:Disable()
								ReloadUI()
							end
						end
					end
				},
				Header1 = {
					type = 'header',
					order = 5,
					name = L['Configure Frames']
				},
				MainMenuBarOptions = {
					order = 6,
					type = "group",
					name = L['MainMenuBar'],
					desc = L['MainMenuBar'],
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['MainMenuBar']
						},
						xOffset = {
							order = 2,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MainMenuBar.xOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						yOffset = {
							order = 3,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MainMenuBar.yOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						scale = {
							order = 4,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MainMenuBar.scale = value
								ClassicUI.cached_db_profile.barsConfig_MainMenuBar_scale = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBar.oldOrigScale = value
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						Spacer1 = {
							type = "description",
							order = 5,
							name = ""
						},
						ActionButtonsLayoutGroup1 = {
							order = 6,
							type = "group",
							inline = true,
							name = L['ActionButtons Layout'],
							desc = "",
							args = {
								BLStyle = {
									order = 1,
									type = "select",
									name = L['BLStyle0'],
									desc = L['BLStyleDesc0'],
									width = 1.5,
									values = {
										[0] = L['Default - Classic Layout'],
										[1] = L['Dragonflight Layout']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= value) then
											ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle = value
											if (ClassicUI:IsEnabled()) then
												ClassicUI.LayoutGroupActionButtons({[0]=true})
											end
										end
									end,
								},
								Spacer1 = {
									type = "description",
									order = 2,
									name = " ",
									width = 0.45
								},
								BLNormalTextureAlpha = {
									order = 3,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = L['NormalTexture Alpha'],
									get = function()
										return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle == 1) and ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle1NormalTextureAlpha or ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0NormalTextureAlpha
									end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle == 1) then
											ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle1NormalTextureAlpha = value
										else
											ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0NormalTextureAlpha = value
										end
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0AllowNewBackgroundArt = {
									order = 4,
									type = "toggle",
									name = L['BLStyle0AllowNewBackgroundArt'],
									desc = L['BLStyle0AllowNewBackgroundArtDesc'],
									width = 2.40,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0AllowNewBackgroundArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0AllowNewBackgroundArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseOldHotKeyTextStyle = {
									order = 5,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseOldHotKeyTextStyle'],
									desc = L['BLStyle0UseOldHotKeyTextStyleDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseOldHotKeyTextStyle end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseOldHotKeyTextStyle = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewPushedTexture = {
									order = 6,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewPushedTexture'],
									desc = L['BLStyle0UseNewPushedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewPushedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewPushedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewCheckedTexture = {
									order = 7,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCheckedTexture'],
									desc = L['BLStyle0UseNewCheckedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewCheckedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewCheckedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewHighlightTexture = {
									order = 8,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewHighlightTexture'],
									desc = L['BLStyle0UseNewHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewSpellHighlightTexture = {
									order = 9,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellHighlightTexture'],
									desc = L['BLStyle0UseNewSpellHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewSpellHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewSpellHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewFlyoutBorder = {
									order = 10,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewFlyoutBorder'],
									desc = L['BLStyle0UseNewFlyoutBorderDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								}
							}
						},
						hideLatencyBar = {
							order = 7,
							type = "toggle",
							name = L['Hide Small Latency Bar'],
							desc = L['Hide Small Latency Bar'],
							width = "double",
							get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.hideLatencyBar end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MainMenuBar.hideLatencyBar = value
								if (ClassicUI:IsEnabled()) then
									if value then
										if (MainMenuMicroButton.MainMenuBarPerformanceBar ~= nil) then
											MainMenuMicroButton.MainMenuBarPerformanceBar:SetAlpha(0)
											MainMenuMicroButton.MainMenuBarPerformanceBar:Hide()
										end
									else
										if (MainMenuMicroButton.MainMenuBarPerformanceBar ~= nil) then
											MainMenuMicroButton.MainMenuBarPerformanceBar:SetAlpha(1)
											MainMenuMicroButton.MainMenuBarPerformanceBar:Show()
										end
									end
								end
							end
						},
						Spacer2 = {
							type = "description",
							order = 8,
							name = ""
						},
						Header2 = {
							type = 'header',
							order = 9,
							name = L['MicroButtons']
						},
						xOffsetMicroButtons = {
							order = 10,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MicroButtons.xOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						yOffsetMicroButtons = {
							order = 11,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MicroButtons.yOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						scaleMicroButtons = {
							order = 12,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MicroButtons.scale = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						Spacer3 = {
							type = "description",
							order = 13,
							name = ""
						},
						useClassicQuestIconMicroButtons = {
							order = 14,
							type = "toggle",
							name = L['Use the classic Quest MicroButton Icon'],
							desc = L['Replaces the Quest MicroButton icon with its classic texture'],
							width = 2.5,
							get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.useClassicQuestIcon end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MicroButtons.useClassicQuestIcon = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						useClassicGuildIconMicroButtons = {
							order = 15,
							type = "toggle",
							name = L['Use the classic Guild MicroButton Icon'],
							desc = L['Replaces the dynamic Guild MicroButton (with its emblem) with its classic static texture'],
							width = 2.5,
							get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.useClassicGuildIcon end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MicroButtons.useClassicGuildIcon = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						useBiggerGuildEmblemMicroButtons = {
							order = 16,
							disabled = function() return (ClassicUI.db.profile.barsConfig.MicroButtons.useClassicGuildIcon) end,
							type = "toggle",
							name = L['Make Guild Emblem bigger'],
							desc = L['Enlarges the Guild Emblem on the MicroButton to make it bigger and more visible'],
							width = 2.5,
							get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.useBiggerGuildEmblem end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MicroButtons.useBiggerGuildEmblem = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						useClassicMainMenuIconMicroButtons = {
							order = 17,
							type = "toggle",
							name = L['Use the classic MainMenu MicroButton Icon'],
							desc = L['Replaces the Quest Main Menu icon with its classic texture'],
							width = 2.5,
							get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.useClassicMainMenuIcon end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MicroButtons.useClassicMainMenuIcon = value
								ClassicUI.cached_db_profile.barsConfig_MicroButtons_useClassicMainMenuIcon = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						Spacer4 = {
							type = "description",
							order = 18,
							name = ""
						},
						Header3 = {
							type = 'header',
							order = 19,
							name = L['BagsIcons']
						},
						iconBorderAlphaBags = {
							order = 20,
							type = "range",
							softMin = 0,
							softMax = 1,
							step = 0.01,
							bigStep = 0.02,
							name = L['IconBorder Alpha'],
							desc = L['IconBorder Alpha'],
							get = function() return ClassicUI.db.profile.barsConfig.BagsIcons.iconBorderAlpha end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.BagsIcons.iconBorderAlpha = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						xOffsetReagentBag = {
							order = 21,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffsetReagentBag'],
							desc = L['xOffsetReagentBag'],
							get = function() return ClassicUI.db.profile.barsConfig.BagsIcons.xOffsetReagentBag end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.BagsIcons.xOffsetReagentBag = value
								ClassicUI.cached_db_profile.barsConfig_BagsIcons_xOffsetReagentBag = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						yOffsetReagentBag = {
							order = 22,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffsetReagentBag'],
							desc = L['yOffsetReagentBag'],
							get = function() return ClassicUI.db.profile.barsConfig.BagsIcons.yOffsetReagentBag end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.BagsIcons.yOffsetReagentBag = value
								ClassicUI.cached_db_profile.barsConfig_BagsIcons_yOffsetReagentBag = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						Spacer5 = {
							type = "description",
							order = 23,
							name = ""
						},
						Header4 = {
							type = 'header',
							order = 24,
							name = L['SpellFlyoutButtons']
						},
						ActionButtonsLayoutGroup2 = {
							order = 25,
							type = "group",
							inline = true,
							name = L['ActionButtons Layout'],
							desc = "",
							args = {
								BLStyle = {
									order = 1,
									type = "select",
									name = L['BLStyle6'],
									desc = L['BLStyleDesc6'],
									width = 1.5,
									values = {
										[0] = L['Default - Classic Layout'],
										[1] = L['Dragonflight Layout']
									},
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= value) then
											ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle = value
											if (ClassicUI:IsEnabled()) then
												ClassicUI.LayoutGroupActionButtons({[6]=true})
											end
										end
									end,
								},
								Spacer1 = {
									type = "description",
									order = 2,
									name = " ",
									width = 0.45
								},
								BLNormalTextureAlpha = {
									order = 3,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = L['NormalTexture Alpha'],
									get = function()
										return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle == 1) and ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle1NormalTextureAlpha or ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0NormalTextureAlpha
									end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle == 1) then
											ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle1NormalTextureAlpha = value
										else
											ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0NormalTextureAlpha = value
										end
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0AllowNewBackgroundArt = {
									order = 4,
									type = "toggle",
									name = L['BLStyle0AllowNewBackgroundArt'],
									desc = L['BLStyle0AllowNewBackgroundArtDesc'],
									width = 2.40,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0AllowNewBackgroundArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0AllowNewBackgroundArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseOldHotKeyTextStyle = {
									order = 5,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseOldHotKeyTextStyle'],
									desc = L['BLStyle0UseOldHotKeyTextStyleDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseOldHotKeyTextStyle end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseOldHotKeyTextStyle = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewPushedTexture = {
									order = 6,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewPushedTexture'],
									desc = L['BLStyle0UseNewPushedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewPushedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewPushedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewCheckedTexture = {
									order = 7,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCheckedTexture'],
									desc = L['BLStyle0UseNewCheckedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewCheckedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewCheckedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewHighlightTexture = {
									order = 8,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewHighlightTexture'],
									desc = L['BLStyle0UseNewHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewSpellHighlightTexture = {
									order = 9,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellHighlightTexture'],
									desc = L['BLStyle0UseNewSpellHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewSpellHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewSpellHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewFlyoutBorder = {
									order = 10,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewFlyoutBorder'],
									desc = L['BLStyle0UseNewFlyoutBorderDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								}
							}
						}
					}
				},
				OverrideActionBarOptions = {
					order = 7,
					type = "group",
					name = L['OverrideActionBar'],
					desc = L['OverrideActionBar'],
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['OverrideActionBar']
						},
						xOffset = {
							order = 2,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.OverrideActionBar.xOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						yOffset = {
							order = 3,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.OverrideActionBar.yOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						scale = {
							order = 4,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.OverrideActionBar.scale = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						Spacer1 = {
							type = "description",
							order = 5,
							name = ""
						},
						ActionButtonsLayoutGroup = {
							order = 6,
							type = "group",
							inline = true,
							name = L['ActionButtons Layout'],
							desc = "",
							args = {
								BLStyle = {
									order = 1,
									type = "select",
									name = L['BLStyle7'],
									desc = L['BLStyleDesc7'],
									width = 1.5,
									values = {
										[0] = L['Default - Classic Layout'],
										[1] = L['Dragonflight Layout']
									},
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= value) then
											ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle = value
											if (ClassicUI:IsEnabled()) then
												ClassicUI.LayoutGroupActionButtons({[7]=true})
											end
										end
									end,
								},
								Spacer1 = {
									type = "description",
									order = 2,
									name = " ",
									width = 0.45
								},
								BLNormalTextureAlpha = {
									order = 3,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = L['NormalTexture Alpha'],
									get = function()
										return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle == 1) and ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle1NormalTextureAlpha or ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0NormalTextureAlpha
									end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle == 1) then
											ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle1NormalTextureAlpha = value
										else
											ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0NormalTextureAlpha = value
										end
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0AllowNewBackgroundArt = {
									order = 4,
									type = "toggle",
									name = L['BLStyle0AllowNewBackgroundArt'],
									desc = L['BLStyle0AllowNewBackgroundArtDesc'],
									width = 2.40,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0AllowNewBackgroundArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0AllowNewBackgroundArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseOldHotKeyTextStyle = {
									order = 5,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseOldHotKeyTextStyle'],
									desc = L['BLStyle0UseOldHotKeyTextStyleDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseOldHotKeyTextStyle end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseOldHotKeyTextStyle = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewPushedTexture = {
									order = 6,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewPushedTexture'],
									desc = L['BLStyle0UseNewPushedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewPushedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewPushedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewCheckedTexture = {
									order = 7,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCheckedTexture'],
									desc = L['BLStyle0UseNewCheckedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewCheckedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewCheckedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewHighlightTexture = {
									order = 8,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewHighlightTexture'],
									desc = L['BLStyle0UseNewHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewSpellHighlightTexture = {
									order = 9,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellHighlightTexture'],
									desc = L['BLStyle0UseNewSpellHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewSpellHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewSpellHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewFlyoutBorder = {
									order = 10,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewFlyoutBorder'],
									desc = L['BLStyle0UseNewFlyoutBorderDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								}
							}
						}
					}
				},
				GargoyleOptions = {
					order = 8,
					type = "group",
					name = L['GargoyleFrames'],
					desc = L['GargoyleFrames'],
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['Left Gargoyle']
						},
						hideLeftGargoyle = {
							order = 2,
							type = "toggle",
							name = L['Hide'],
							desc = L['Hide Left Gargoyle'],
							get = function() return ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.hide end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.hide = value
								if (ClassicUI:IsEnabled()) then
									if (value) then
										CUI_MainMenuBarLeftEndCap:Hide()
									else
										CUI_MainMenuBarLeftEndCap:Show()
									end
								end
							end,
						},
						xOffsetLeftGargoyle = {
							order = 3,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.xOffset = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBarLeftEndCap:Init()
								end
							end
						},
						yOffsetLeftGargoyle = {
							order = 4,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.yOffset = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBarLeftEndCap:Init()
								end
							end
						},
						modelLeftGargoyle = {
							order = 5,
							type = "select",
							name = L['Left Gargoyle Model'],
							desc = L['Select the model of the Left Gargoyle'],
							values = {
								[0] = L['Default - Gryphon'],
								[1] = L['Lion'],
								[2] = L['New Gryphon'],
								[3] = L['New Wyvern']
							},
							get = function() return ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.model end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.model = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBarLeftEndCap:Init()
								end
							end,
						},
						alphaLeftGargoyle = {
							order = 6,
							type = "range",
							softMin = 0,
							softMax = 1,
							step = 0.01,
							bigStep = 0.02,
							name = L['Alpha'],
							desc = L['Alpha'],
							get = function() return ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.alpha end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.alpha = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBarLeftEndCap:SetAlpha(value)
								end
							end
						},
						scaleLeftGargoyle = {
							order = 7,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.scale = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBarLeftEndCap:SetScale(value)
								end
							end
						},
						Spacer1 = {
							type = "description",
							order = 8,
							name = ""
						},
						Header2 = {
							type = 'header',
							order = 9,
							name = L['Right Gargoyle']
						},
						hideRightGargoyle = {
							order = 10,
							type = "toggle",
							name = L['Hide'],
							desc = L['Hide Right Gargoyle'],
							get = function() return ClassicUI.db.profile.barsConfig.RightGargoyleFrame.hide end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightGargoyleFrame.hide = value
								if (ClassicUI:IsEnabled()) then
									if (value) then
										CUI_MainMenuBarRightEndCap:Hide()
									else
										CUI_MainMenuBarRightEndCap:Show()
									end
								end
							end,
						},
						xOffsetRightGargoyle = {
							order = 11,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.RightGargoyleFrame.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightGargoyleFrame.xOffset = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBarRightEndCap:Init()
								end
							end
						},
						yOffsetRightGargoyle = {
							order = 12,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.RightGargoyleFrame.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightGargoyleFrame.yOffset = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBarRightEndCap:Init()
								end
							end
						},
						modelRightGargoyle = {
							order = 13,
							type = "select",
							name = L['Right Gargoyle Model'],
							desc = L['Select the model of the Right Gargoyle'],
							values = {
								[0] = L['Default - Gryphon'],
								[1] = L['Lion'],
								[2] = L['New Gryphon'],
								[3] = L['New Wyvern']
							},
							get = function() return ClassicUI.db.profile.barsConfig.RightGargoyleFrame.model end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightGargoyleFrame.model = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBarRightEndCap:Init()
								end
							end,
						},
						alphaRightGargoyle = {
							order = 14,
							type = "range",
							softMin = 0,
							softMax = 1,
							step = 0.01,
							bigStep = 0.02,
							name = L['Alpha'],
							desc = L['Alpha'],
							get = function() return ClassicUI.db.profile.barsConfig.RightGargoyleFrame.alpha end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightGargoyleFrame.alpha = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBarRightEndCap:SetAlpha(value)
								end
							end
						},
						scaleRightGargoyle = {
							order = 15,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.RightGargoyleFrame.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightGargoyleFrame.scale = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBarRightEndCap:SetScale(value)
								end
							end
						}
					},
				},
				PetBattleFrameBarOptions = {
					order = 9,
					type = "group",
					name = L['PetBattleFrameBar'],
					desc = L['PetBattleFrameBar'],
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['PetBattleFrameBar']
						},
						xOffset = {
							order = 2,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.PetBattleFrameBar.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetBattleFrameBar.xOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						yOffset = {
							order = 3,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.PetBattleFrameBar.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetBattleFrameBar.yOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						scale = {
							order = 4,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.PetBattleFrameBar.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetBattleFrameBar.scale = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						}
					}
				},
				MultiActionBarOptions = {
					order = 10,
					type = "group",
					name = L['MultiActionBar'],
					desc = L['MultiActionBar'],
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['BottomMultiActionBars']
						},
						xOffsetBottomMultiActionBars = {
							order = 2,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.BottomMultiActionBars.xOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end
						},
						yOffsetBottomMultiActionBars = {
							order = 3,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end
						},
						Spacer1 = {
							type = "description",
							order = 4,
							name = ""
						},
						OffsetsStatusBar1 = {
							order = 5,
							inline = true,
							type = "group",
							name = " ",
							desc = "",
							args = {
								ignoreyOffsetStatusBar = {
									order = 1,
									type = "toggle",
									name = L['Disable auto-yOffset [*]'],
									desc = L['Disable auto-yOffset when StatusBar are shown'],
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.ignoreyOffsetStatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.ignoreyOffsetStatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end,
								},
								yOffset1StatusBar = {
									order = 2,
									disabled = function() return (not ClassicUI.db.profile.barsConfig.BottomMultiActionBars.ignoreyOffsetStatusBar) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset - 1 StatusBar Shown'],
									desc = L['yOffset when One Status Bar is shown'],
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset1StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset1StatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end
								},
								yOffset2StatusBar = {
									order = 3,
									disabled = function() return (not ClassicUI.db.profile.barsConfig.BottomMultiActionBars.ignoreyOffsetStatusBar) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset - 2 StatusBar Shown'],
									desc = L['yOffset when Two Status Bars are shown'],
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset2StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset2StatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end
								}
							}
						},
						scaleBottomMultiActionBars = {
							order = 6,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.BottomMultiActionBars.scale = value
								ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_scale = value
								if (ClassicUI:IsEnabled()) then
									CUI_MultiBarBottomLeft.oldOrigScale = value
									CUI_MultiBarBottomRight.oldOrigScale = value
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						Spacer2 = {
							type = "description",
							order = 7,
							name = ""
						},
						ActionButtonsLayoutGroup1 = {
							order = 8,
							type = "group",
							inline = true,
							name = L['ActionButtons Layout'],
							desc = "",
							args = {
								BLStyle = {
									order = 1,
									type = "select",
									name = L['BLStyle1'],
									desc = L['BLStyleDesc1'],
									width = 1.5,
									values = {
										[0] = L['Default - Classic Layout'],
										[1] = L['Dragonflight Layout']
									},
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= value) then
											ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle = value
											if (ClassicUI:IsEnabled()) then
												ClassicUI.LayoutGroupActionButtons({[1]=true})
											end
										end
									end,
								},
								Spacer1 = {
									type = "description",
									order = 2,
									name = " ",
									width = 0.45
								},
								BLNormalTextureAlpha = {
									order = 3,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = L['NormalTexture Alpha'],
									get = function()
										return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle == 1) and ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle1NormalTextureAlpha or ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0NormalTextureAlpha
									end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle == 1) then
											ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle1NormalTextureAlpha = value
										else
											ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0NormalTextureAlpha = value
										end
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0AllowNewBackgroundArt = {
									order = 4,
									type = "toggle",
									name = L['BLStyle0AllowNewBackgroundArt'],
									desc = L['BLStyle0AllowNewBackgroundArtDesc'],
									width = 2.40,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0AllowNewBackgroundArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0AllowNewBackgroundArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseOldHotKeyTextStyle = {
									order = 5,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseOldHotKeyTextStyle'],
									desc = L['BLStyle0UseOldHotKeyTextStyleDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseOldHotKeyTextStyle end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseOldHotKeyTextStyle = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewPushedTexture = {
									order = 6,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewPushedTexture'],
									desc = L['BLStyle0UseNewPushedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewPushedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewPushedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewCheckedTexture = {
									order = 7,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCheckedTexture'],
									desc = L['BLStyle0UseNewCheckedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewCheckedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewCheckedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewHighlightTexture = {
									order = 8,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewHighlightTexture'],
									desc = L['BLStyle0UseNewHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewSpellHighlightTexture = {
									order = 9,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellHighlightTexture'],
									desc = L['BLStyle0UseNewSpellHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewSpellHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewSpellHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewFlyoutBorder = {
									order = 10,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewFlyoutBorder'],
									desc = L['BLStyle0UseNewFlyoutBorderDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								}
							}
						},
						Header2 = {
							type = 'header',
							order = 9,
							name = L['RightMultiActionBars']
						},
						xOffsetRightMultiActionBars = {
							order = 10,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightMultiActionBars.xOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end
						},
						yOffsetRightMultiActionBars = {
							order = 11,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end
						},
						OffsetsStatusBar2 = {
							order = 12,
							inline = true,
							type = "group",
							name = " ",
							desc = "",
							args = {
								ignoreyOffsetStatusBar = {
									order = 1,
									type = "toggle",
									name = L['Disable auto-yOffset [*]'],
									desc = L['Disable auto-yOffset when StatusBar are shown'],
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.ignoreyOffsetStatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.ignoreyOffsetStatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end,
								},
								yOffset1StatusBar = {
									order = 2,
									disabled = function() return (not ClassicUI.db.profile.barsConfig.RightMultiActionBars.ignoreyOffsetStatusBar) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset - 1 StatusBar Shown'],
									desc = L['yOffset when One Status Bar is shown'],
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset1StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset1StatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end
								},
								yOffset2StatusBar = {
									order = 3,
									disabled = function() return (not ClassicUI.db.profile.barsConfig.RightMultiActionBars.ignoreyOffsetStatusBar) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset - 2 StatusBar Shown'],
									desc = L['yOffset when Two Status Bars are shown'],
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset2StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset2StatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end
								}
							}
						},
						scaleRightMultiActionBars = {
							order = 13,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightMultiActionBars.scale = value
								ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_scale = value
								if (ClassicUI:IsEnabled()) then
									CUI_MultiBarLeft.oldOrigScale = value
									CUI_MultiBarRight.oldOrigScale = value
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						Spacer3 = {
							type = "description",
							order = 14,
							name = ""
						},
						ActionButtonsLayoutGroup2 = {
							order = 15,
							type = "group",
							inline = true,
							name = L['ActionButtons Layout'],
							desc = "",
							args = {
								BLStyle = {
									order = 1,
									type = "select",
									name = L['BLStyle2'],
									desc = L['BLStyleDesc2'],
									width = 1.5,
									values = {
										[0] = L['Default - Classic Layout'],
										[1] = L['Dragonflight Layout']
									},
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= value) then
											ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle = value
											if (ClassicUI:IsEnabled()) then
												ClassicUI.LayoutGroupActionButtons({[2]=true})
											end
										end
									end,
								},
								Spacer1 = {
									type = "description",
									order = 2,
									name = " ",
									width = 0.45
								},
								BLNormalTextureAlpha = {
									order = 3,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = L['NormalTexture Alpha'],
									get = function()
										return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle == 1) and ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle1NormalTextureAlpha or ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0NormalTextureAlpha
									end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle == 1) then
											ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle1NormalTextureAlpha = value
										else
											ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0NormalTextureAlpha = value
										end
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0AllowNewBackgroundArt = {
									order = 4,
									type = "toggle",
									name = L['BLStyle0AllowNewBackgroundArt'],
									desc = L['BLStyle0AllowNewBackgroundArtDesc'],
									width = 2.40,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0AllowNewBackgroundArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0AllowNewBackgroundArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseOldHotKeyTextStyle = {
									order = 5,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseOldHotKeyTextStyle'],
									desc = L['BLStyle0UseOldHotKeyTextStyleDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseOldHotKeyTextStyle end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseOldHotKeyTextStyle = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewPushedTexture = {
									order = 6,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewPushedTexture'],
									desc = L['BLStyle0UseNewPushedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewPushedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewPushedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewCheckedTexture = {
									order = 7,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCheckedTexture'],
									desc = L['BLStyle0UseNewCheckedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewCheckedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewCheckedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewHighlightTexture = {
									order = 8,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewHighlightTexture'],
									desc = L['BLStyle0UseNewHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewSpellHighlightTexture = {
									order = 9,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellHighlightTexture'],
									desc = L['BLStyle0UseNewSpellHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewSpellHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewSpellHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewFlyoutBorder = {
									order = 10,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewFlyoutBorder'],
									desc = L['BLStyle0UseNewFlyoutBorderDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								}
							}
						}
					}
				},
				PetActionBarOptions = {
					order = 11,
					type = "group",
					name = L['PetActionBar'],
					desc = L['PetActionBar'],
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['PetActionBar']
						},
						xOffset = {
							order = 2,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end
						},
						yOffset = {
							order = 3,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end
						},
						xOffsetIfStanceBar = {
							order = 4,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset - StanceBar Shown'],
							desc = L['xOffset when StanceBar is shown'],
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffsetIfStanceBar end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.xOffsetIfStanceBar = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end
						},
						Spacer1 = {
							type = "description",
							order = 5,
							name = ""
						},
						OffsetsStatusBar = {
							order = 6,
							inline = true,
							type = "group",
							name = " ",
							desc = "",
							args = {
								ignoreyOffsetStatusBar = {
									order = 1,
									type = "toggle",
									name = L['Disable auto-yOffset [*]'],
									desc = L['Disable auto-yOffset when StatusBar are shown'],
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.ignoreyOffsetStatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.ignoreyOffsetStatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end,
								},
								yOffset1StatusBar = {
									order = 2,
									disabled = function() return (not ClassicUI.db.profile.barsConfig.PetActionBarFrame.ignoreyOffsetStatusBar) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset - 1 StatusBar Shown'],
									desc = L['yOffset when One Status Bar is shown'],
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset1StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset1StatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end
								},
								yOffset2StatusBar = {
									order = 3,
									disabled = function() return (not ClassicUI.db.profile.barsConfig.PetActionBarFrame.ignoreyOffsetStatusBar) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset - 2 StatusBar Shown'],
									desc = L['yOffset when Two Status Bars are shown'],
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset2StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset2StatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end
								}
							}
						},
						scale = {
							order = 7,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.scale = value
								ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_scale = value
								if (ClassicUI:IsEnabled()) then
									CUI_PetActionBarFrame.oldOrigScale = value
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						Spacer2 = {
							type = "description",
							order = 8,
							name = ""
						},
						ActionButtonsLayoutGroup = {
							order = 9,
							type = "group",
							inline = true,
							name = L['ActionButtons Layout'],
							desc = "",
							args = {
								BLStyle = {
									order = 1,
									type = "select",
									name = L['BLStyle3'],
									desc = L['BLStyleDesc3'],
									width = 1.5,
									values = {
										[0] = L['Default - Classic Layout'],
										[1] = L['Dragonflight Layout']
									},
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= value) then
											ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle = value
											if (ClassicUI:IsEnabled()) then
												ClassicUI.LayoutGroupActionButtons({[3]=true})
											end
										end
									end,
								},
								Spacer1 = {
									type = "description",
									order = 2,
									name = " ",
									width = 0.45
								},
								BLNormalTextureAlpha = {
									order = 3,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = L['NormalTexture Alpha'],
									get = function()
										return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle == 1) and ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle1NormalTextureAlpha or ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0NormalTextureAlpha
									end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle == 1) then
											ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle1NormalTextureAlpha = value
										else
											ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0NormalTextureAlpha = value
										end
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0AllowNewBackgroundArt = {
									order = 4,
									type = "toggle",
									name = L['BLStyle0AllowNewBackgroundArt'],
									desc = L['BLStyle0AllowNewBackgroundArtDesc'],
									width = 2.40,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0AllowNewBackgroundArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0AllowNewBackgroundArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseOldHotKeyTextStyle = {
									order = 5,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseOldHotKeyTextStyle'],
									desc = L['BLStyle0UseOldHotKeyTextStyleDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseOldHotKeyTextStyle end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseOldHotKeyTextStyle = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewPushedTexture = {
									order = 6,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewPushedTexture'],
									desc = L['BLStyle0UseNewPushedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewPushedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewPushedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewCheckedTexture = {
									order = 7,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCheckedTexture'],
									desc = L['BLStyle0UseNewCheckedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewCheckedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewCheckedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewHighlightTexture = {
									order = 8,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewHighlightTexture'],
									desc = L['BLStyle0UseNewHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewSpellHighlightTexture = {
									order = 9,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellHighlightTexture'],
									desc = L['BLStyle0UseNewSpellHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewSpellHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewSpellHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewFlyoutBorder = {
									order = 10,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewFlyoutBorder'],
									desc = L['BLStyle0UseNewFlyoutBorderDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								}
							}
						},
						Spacer3 = {
							type = "description",
							order = 10,
							name = ""
						},
						normalizeButtonsSpacing = {
							order = 11,
							type = "toggle",
							name = L['Normalize spacing of PetActionButtons'],
							desc = L['Select this option to make the spacing of all PetActionButtons the same, since by default the spacing between button 6 and 7 is 1px less than the rest'],
							width = "double",
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.normalizeButtonsSpacing end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.normalizeButtonsSpacing = value
								if (ClassicUI:IsEnabled()) then
									if not(InCombatLockdown()) then
										CUI_PetActionBarFrame:RelocateButtons()
									end
								end
							end,
						},
						hideOnOverrideActionBar = {
							order = 12,
							type = "toggle",
							name = L['Hide on OverrideActionBar'],
							desc = L['Hide the PetActionBar when the OverrideActionBar is shown instead of moving it to a new spot'],
							width = "double",
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnOverrideActionBar end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnOverrideActionBar = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end,
						},
						hideOnPetBattleFrameBar = {
							order = 13,
							type = "toggle",
							name = L['Hide on PetBattleFrameBar'],
							desc = L['Hide the PetActionBar when the PetBattleFrameBar is shown instead of moving it to a new spot'],
							width = "double",
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnPetBattleFrameBar end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnPetBattleFrameBar = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end,
						}
					}
				},
				StanceBarOptions = {
					order = 12,
					type = "group",
					name = L['StanceBar'],
					desc = L['StanceBar'],
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['StanceBar']
						},
						xOffset = {
							order = 2,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.StanceBarFrame.xOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end
						},
						yOffset = {
							order = 3,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end
						},
						Spacer1 = {
							type = "description",
							order = 4,
							name = ""
						},
						OffsetsStatusBar = {
							order = 5,
							inline = true,
							type = "group",
							name = " ",
							desc = "",
							args = {
								ignoreyOffsetStatusBar = {
									order = 1,
									type = "toggle",
									name = L['Disable auto-yOffset [*]'],
									desc = L['Disable auto-yOffset when StatusBar are shown'],
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.ignoreyOffsetStatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.ignoreyOffsetStatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end,
								},
								yOffset1StatusBar = {
									order = 2,
									disabled = function() return (not ClassicUI.db.profile.barsConfig.StanceBarFrame.ignoreyOffsetStatusBar) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset - 1 StatusBar Shown'],
									desc = L['yOffset when One Status Bar is shown'],
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset1StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset1StatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end
								},
								yOffset2StatusBar = {
									order = 3,
									disabled = function() return (not ClassicUI.db.profile.barsConfig.StanceBarFrame.ignoreyOffsetStatusBar) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset - 2 StatusBar Shown'],
									desc = L['yOffset when Two Status Bars are shown'],
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset2StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset2StatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end
								}
							}
						},
						scale = {
							order = 6,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.StanceBarFrame.scale = value
								ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_scale = value
								if (ClassicUI:IsEnabled()) then
									CUI_StanceBarFrame.oldOrigScale = value
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						Spacer2 = {
							type = "description",
							order = 7,
							name = ""
						},
						ActionButtonsLayoutGroup = {
							order = 8,
							type = "group",
							inline = true,
							name = L['ActionButtons Layout'],
							desc = "",
							args = {
								BLStyle = {
									order = 1,
									type = "select",
									name = L['BLStyle4'],
									desc = L['BLStyleDesc4'],
									width = 1.5,
									values = {
										[0] = L['Default - Classic Layout'],
										[1] = L['Dragonflight Layout']
									},
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= value) then
											ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle = value
											if (ClassicUI:IsEnabled()) then
												ClassicUI.LayoutGroupActionButtons({[4]=true})
											end
										end
									end,
								},
								Spacer1 = {
									type = "description",
									order = 2,
									name = " ",
									width = 0.45
								},
								BLNormalTextureAlpha = {
									order = 3,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = L['NormalTexture Alpha'],
									get = function()
										return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle == 1) and ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle1NormalTextureAlpha or ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0NormalTextureAlpha
									end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle == 1) then
											ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle1NormalTextureAlpha = value
										else
											ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0NormalTextureAlpha = value
										end
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0AllowNewBackgroundArt = {
									order = 4,
									type = "toggle",
									name = L['BLStyle0AllowNewBackgroundArt'],
									desc = L['BLStyle0AllowNewBackgroundArtDesc'],
									width = 2.40,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0AllowNewBackgroundArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0AllowNewBackgroundArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseOldHotKeyTextStyle = {
									order = 5,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseOldHotKeyTextStyle'],
									desc = L['BLStyle0UseOldHotKeyTextStyleDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseOldHotKeyTextStyle end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseOldHotKeyTextStyle = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewPushedTexture = {
									order = 6,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewPushedTexture'],
									desc = L['BLStyle0UseNewPushedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewPushedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewPushedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewCheckedTexture = {
									order = 7,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCheckedTexture'],
									desc = L['BLStyle0UseNewCheckedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewCheckedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewCheckedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewHighlightTexture = {
									order = 8,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewHighlightTexture'],
									desc = L['BLStyle0UseNewHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewSpellHighlightTexture = {
									order = 9,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellHighlightTexture'],
									desc = L['BLStyle0UseNewSpellHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewSpellHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewSpellHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewFlyoutBorder = {
									order = 10,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewFlyoutBorder'],
									desc = L['BLStyle0UseNewFlyoutBorderDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								}
							}
						}
					}
				},
				PossessBarOptions = {
					order = 13,
					type = "group",
					name = L['PossessBar'],
					desc = L['PossessBar'],
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['PossessBar']
						},
						xOffset = {
							order = 2,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PossessBarFrame.xOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end
						},
						yOffset = {
							order = 3,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end
						},
						Spacer1 = {
							type = "description",
							order = 4,
							name = ""
						},
						OffsetsStatusBar = {
							order = 5,
							inline = true,
							type = "group",
							name = " ",
							desc = "",
							args = {
								ignoreyOffsetStatusBar = {
									order = 1,
									type = "toggle",
									name = L['Disable auto-yOffset [*]'],
									desc = L['Disable auto-yOffset when StatusBar are shown'],
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.ignoreyOffsetStatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.ignoreyOffsetStatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end,
								},
								yOffset1StatusBar = {
									order = 2,
									disabled = function() return (not ClassicUI.db.profile.barsConfig.PossessBarFrame.ignoreyOffsetStatusBar) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset - 1 StatusBar Shown'],
									desc = L['yOffset when One Status Bar is shown'],
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset1StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset1StatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end
								},
								yOffset2StatusBar = {
									order = 3,
									disabled = function() return (not ClassicUI.db.profile.barsConfig.PossessBarFrame.ignoreyOffsetStatusBar) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset - 2 StatusBar Shown'],
									desc = L['yOffset when Two Status Bars are shown'],
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset2StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset2StatusBar = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:UpdatedStatusBarsEvent()
										end
									end
								}
							}
						},
						scale = {
							order = 6,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PossessBarFrame.scale = value
								ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_scale = value
								if (ClassicUI:IsEnabled()) then
									CUI_PossessBarFrame.oldOrigScale = value
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						Spacer2 = {
							type = "description",
							order = 7,
							name = ""
						},
						ActionButtonsLayoutGroup = {
							order = 8,
							type = "group",
							inline = true,
							name = L['ActionButtons Layout'],
							desc = "",
							args = {
								BLStyle = {
									order = 1,
									type = "select",
									name = L['BLStyle5'],
									desc = L['BLStyleDesc5'],
									width = 1.5,
									values = {
										[0] = L['Default - Classic Layout'],
										[1] = L['Dragonflight Layout']
									},
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= value) then
											ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle = value
											if (ClassicUI:IsEnabled()) then
												ClassicUI.LayoutGroupActionButtons({[5]=true})
											end
										end
									end,
								},
								Spacer1 = {
									type = "description",
									order = 2,
									name = " ",
									width = 0.45
								},
								BLNormalTextureAlpha = {
									order = 3,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = L['NormalTexture Alpha'],
									get = function()
										return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle == 1) and ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle1NormalTextureAlpha or ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0NormalTextureAlpha
									end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle == 1) then
											ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle1NormalTextureAlpha = value
										else
											ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0NormalTextureAlpha = value
										end
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0AllowNewBackgroundArt = {
									order = 4,
									type = "toggle",
									name = L['BLStyle0AllowNewBackgroundArt'],
									desc = L['BLStyle0AllowNewBackgroundArtDesc'],
									width = 2.40,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0AllowNewBackgroundArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0AllowNewBackgroundArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseOldHotKeyTextStyle = {
									order = 5,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseOldHotKeyTextStyle'],
									desc = L['BLStyle0UseOldHotKeyTextStyleDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseOldHotKeyTextStyle end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseOldHotKeyTextStyle = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewPushedTexture = {
									order = 6,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewPushedTexture'],
									desc = L['BLStyle0UseNewPushedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewPushedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewPushedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewCheckedTexture = {
									order = 7,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCheckedTexture'],
									desc = L['BLStyle0UseNewCheckedTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewCheckedTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewCheckedTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewHighlightTexture = {
									order = 8,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewHighlightTexture'],
									desc = L['BLStyle0UseNewHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewSpellHighlightTexture = {
									order = 9,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellHighlightTexture'],
									desc = L['BLStyle0UseNewSpellHighlightTextureDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewSpellHighlightTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewSpellHighlightTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewFlyoutBorder = {
									order = 10,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewFlyoutBorder'],
									desc = L['BLStyle0UseNewFlyoutBorderDesc'],
									width = 2.40,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								}
							}
						}
					}
				},
				StatusBarOptions = {
					order = 14,
					type = "group",
					name = L['StatusBar'],
					desc = L['StatusBar'],
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['StatusBar General Configuration']
						},
						Comment1 = {
							type = 'description',
							order = 2,
							name = L['General configuration of StatusBar that applies regardless of how many StatusBars are visible']
						},
						Spacer1 = {
							type = "description",
							order = 3,
							name = ""
						},
						expBarAlwaysShowRestedBar = {
							order = 4,
							type = "toggle",
							name = L['expBarAlwaysShowRestedBar'],
							desc = L['expBarAlwaysShowRestedBarDesc'],
							width = 2.5,
							get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.expBarAlwaysShowRestedBar end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.SingleStatusBar.expBarAlwaysShowRestedBar = value
								ClassicUI.cached_db_profile.barsConfig_SingleStatusBar_expBarAlwaysShowRestedBar = value
								ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.expBarAlwaysShowRestedBar = value
								ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.expBarAlwaysShowRestedBar = value
								if (ClassicUI:IsEnabled()) then
									for _, bar in pairs(ClassicUI.STBMbars) do
										if (bar.priority == 3 and bar.ExhaustionTick and bar.ExhaustionTick.UpdateTickPosition) then
											bar.ExhaustionTick:UpdateTickPosition()
										end
									end
								end
							end,
						},
						Spacer2 = {
							type = "description",
							order = 5,
							name = ""
						},
						Header2 = {
							type = 'header',
							order = 6,
							name = L['SingleStatusBar']
						},
						Comment2 = {
							type = 'description',
							order = 7,
							name = L['Configuration for 1 visible StatusBar']
						},
						Spacer3 = {
							type = "description",
							order = 8,
							name = ""
						},
						hideSingleStatusBar = {
							order = 9,
							type = "multiselect",
							name = L['Hide for:'],
							desc = L['Hide SingleStatusBar for the selected StatusBar types'],
							values = {
								[0] = L['ExpBar'],
								[1] = L['HonorBar'],
								[2] = L['AzeriteBar'],
								[3] = L['ArtifactBar'],
								[4] = L['ReputationBar']
							},
							get = function(_, keyname) return ClassicUI.db.profile.barsConfig.SingleStatusBar.hide[keyname] end,
							set = function(_, keyname, value)
								ClassicUI.db.profile.barsConfig.SingleStatusBar.hide[keyname] = value
								ClassicUI:UpdateStatusBarOptionsCache()
								if (ClassicUI:IsEnabled()) then
									if (not ClassicUI.cached_SingleStatusBar_hide) then
										if (not StatusTrackingBarManager:IsShown()) then
											StatusTrackingBarManager:Show()
										end
									end
									ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end,
						},
						Spacer4 = {
							type = "description",
							order = 10,
							name = ""
						},
						SingleStatusBarxOffset = {
							order = 11,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
								end
							end
						},
						SingleStatusBaryOffset = {
							order = 12,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffset = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
								end
							end
						},
						SingleStatusBarAlpha = {
							order = 13,
							type = "range",
							softMin = 0,
							softMax = 1,
							step = 1,
							bigStep = 0.02,
							name = L['Alpha'],
							desc = L['Alpha'],
							get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.alpha end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.SingleStatusBar.alpha = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
								end
							end
						},
						Spacer5 = {
							type = "description",
							order = 14,
							name = ""
						},
						SingleStatusBarxSize = {
							order = 15,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xSize'],
							desc = L['xSize'],
							get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.xSize end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.SingleStatusBar.xSize = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
								end
							end
						},
						SingleStatusBarySize = {
							order = 16,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['ySize'],
							desc = L['ySize'],
							get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.ySize end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.SingleStatusBar.ySize = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
								end
							end
						},
						SingleStatusBarArt = {
							order = 17,
							type = "group",
							inline = true,
							name = L['ArtFrame'],
							desc = "",
							args = {
								hideArt = {
									order = 1,
									type = "toggle",
									name = L['Hide'],
									desc = L['Hide ArtFrame'],
									get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.artHide end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SingleStatusBar.artHide = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end,
								},
								alphaArt = {
									order = 2,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SingleStatusBar.artHide) end,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 1,
									bigStep = 0.02,
									name = L['alphaArt'],
									desc = L['alphaArt'],
									get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.artAlpha end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SingleStatusBar.artAlpha = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 3,
									name = ""
								},
								xOffsetArt = {
									order = 4,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SingleStatusBar.artHide) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetArt'],
									desc = L['xOffsetArt'],
									get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffsetArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffsetArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								yOffsetArt = {
									order = 5,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SingleStatusBar.artHide) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetArt'],
									desc = L['yOffsetArt'],
									get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffsetArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffsetArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 6,
									name = ""
								},
								xSizeArt = {
									order = 7,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xSizeArt'],
									desc = L['xSizeArt'],
									get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.xSizeArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SingleStatusBar.xSizeArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								ySizeArt = {
									order = 8,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['ySizeArt'],
									desc = L['ySizeArt'],
									get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.ySizeArt end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SingleStatusBar.ySizeArt = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								}
							}
						},
						SingleStatusBarOverlay = {
							order = 18,
							type = "group",
							inline = true,
							name = L['OverlayFrame'],
							desc = "",
							args = {
								hideOverlay = {
									order = 1,
									type = "toggle",
									name = L['Hide'],
									desc = L['Hide OverlayFrame'],
									get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.overlayHide end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SingleStatusBar.overlayHide = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end,
								},
								alphaOverlay = {
									order = 2,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SingleStatusBar.overlayHide) end,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaOverlay'],
									desc = L['alphaOverlay'],
									get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.overlayAlpha end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SingleStatusBar.overlayAlpha = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 3,
									name = ""
								},
								xOffsetOverlay = {
									order = 4,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SingleStatusBar.overlayHide) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetOverlay'],
									desc = L['xOffsetOverlay'],
									get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffsetOverlay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SingleStatusBar.xOffsetOverlay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								yOffsetOverlay = {
									order = 5,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SingleStatusBar.overlayHide) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetOverlay'],
									desc = L['yOffsetOverlay'],
									get = function() return ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffsetOverlay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SingleStatusBar.yOffsetOverlay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								}
							}
						},
						Spacer6 = {
							type = "description",
							order = 19,
							name = ""
						},
						Header3 = {
							type = 'header',
							order = 20,
							name = L['DoubleStatusBar']
						},
						Comment3 = {
							type = 'description',
							order = 21,
							name = L['Configuration for 2 visible StatusBars']
						},
						Spacer7 = {
							type = 'description',
							order = 22,
							name = ""
						},
						hideDoubleStatusBar = {
							order = 23,
							type = "multiselect",
							name = L['Hide for:'],
							desc = L['Hide DoubleStatusBar for the selected StatusBar types'],
							values = {
								[0] = L['ExpBar+HonorBar'],
								[1] = L['ExpBar+AzeriteBar'],
								[2] = L['ExpBar+ArtifactBar'],
								[3] = L['ExpBar+ReputationBar'],
								[4] = L['HonorBar+AzeriteBar'],
								[5] = L['HonorBar+ArtifactBar'],
								[6] = L['HonorBar+ReputationBar'],
								[7] = L['AzeriteBar+ArtifactBar'],
								[8] = L['AzeriteBar+ReputationBar'],
								[9] = L['ArtifactBar+ReputationBar']
							},
							get = function(_, keyname) return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.hide[keyname] end,
							set = function(_, keyname, value)
								ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.hide[keyname] = value
								ClassicUI:UpdateStatusBarOptionsCache()
								if (ClassicUI:IsEnabled()) then
									if (not ClassicUI.cached_DoubleStatusBar_hide) then
										if (not StatusTrackingBarManager:IsShown()) then
											StatusTrackingBarManager:Show()
										end
									end
									ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end,
						},
						Spacer8 = {
							type = 'description',
							order = 24,
							name = ""
						},
						UpperStatusBar = {
							order = 25,
							inline = true,
							type = "group",
							name = L['UpperStatusBar'],
							desc = "",
							args = {
								xOffset = {
									order = 1,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffset'],
									desc = L['xOffset'],
									get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffset end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffset = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								yOffset = {
									order = 2,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset'],
									desc = L['yOffset'],
									get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffset end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffset = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								alpha = {
									order = 3,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 1,
									bigStep = 0.02,
									name = L['Alpha'],
									desc = L['Alpha'],
									get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.alpha end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.alpha = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 4,
									name = ""
								},
								xSize = {
									order = 5,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xSize'],
									desc = L['xSize'],
									get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSize end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSize = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								ySize = {
									order = 6,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['ySize'],
									desc = L['ySize'],
									get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySize end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySize = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								DoubleUpperStatusBarArt = {
									order = 7,
									type = "group",
									inline = true,
									name = L['ArtFrame'],
									desc = "",
									args = {
										hideArt = {
											order = 1,
											type = "toggle",
											name = L['Hide'],
											desc = L['Hide ArtFrame'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artHide end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artHide = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end,
										},
										alphaArt = {
											order = 2,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artHide) end,
											type = "range",
											softMin = 0,
											softMax = 1,
											step = 1,
											bigStep = 0.02,
											name = L['alphaArt'],
											desc = L['alphaArt'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artAlpha end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artAlpha = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										Spacer1 = {
											type = "description",
											order = 3,
											name = ""
										},
										xOffsetArt = {
											order = 4,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['xOffsetArt'],
											desc = L['xOffsetArt'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffsetArt end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffsetArt = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										yOffsetArt = {
											order = 5,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['yOffsetArt'],
											desc = L['yOffsetArt'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffsetArt end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffsetArt = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										Spacer2 = {
											type = "description",
											order = 6,
											name = ""
										},
										xSizeArt = {
											order = 7,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['xSizeArt'],
											desc = L['xSizeArt'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSizeArt end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xSizeArt = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										ySizeArt = {
											order = 8,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['ySizeArt'],
											desc = L['ySizeArt'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySizeArt end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySizeArt = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
									}
								},
								DoubleUpperStatusBarOverlay = {
									order = 8,
									type = "group",
									inline = true,
									name = L['OverlayFrame'],
									desc = "",
									args = {
										hideOverlay = {
											order = 1,
											type = "toggle",
											name = L['Hide'],
											desc = L['Hide OverlayFrame'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.overlayHide end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.overlayHide = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end,
										},
										alphaOverlay = {
											order = 2,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.overlayHide) end,
											type = "range",
											softMin = 0,
											softMax = 1,
											step = 0.01,
											bigStep = 0.02,
											name = L['alphaOverlay'],
											desc = L['alphaOverlay'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.overlayAlpha end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.overlayAlpha = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										Spacer1 = {
											type = "description",
											order = 3,
											name = ""
										},
										xOffsetOverlay = {
											order = 4,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.overlayHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['xOffsetOverlay'],
											desc = L['xOffsetOverlay'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffsetOverlay end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.xOffsetOverlay = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										yOffsetOverlay = {
											order = 5,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.overlayHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['yOffsetOverlay'],
											desc = L['yOffsetOverlay'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffsetOverlay end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.yOffsetOverlay = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										}
									}
								}
							}
						},
						LowerStatusBar = {
							order = 26,
							inline = true,
							type = "group",
							name = L['LowerStatusBar'],
							desc = "",
							args = {
								xOffset = {
									order = 1,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffset'],
									desc = L['xOffset'],
									get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffset end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffset = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								yOffset = {
									order = 2,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffset'],
									desc = L['yOffset'],
									get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffset end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffset = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								alpha = {
									order = 3,
									type = "range",
									softMin = 0,
									softMax = 1,
									step = 1,
									bigStep = 0.02,
									name = L['Alpha'],
									desc = L['Alpha'],
									get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.alpha end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.alpha = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 4,
									name = ""
								},
								xSize = {
									order = 5,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xSize'],
									desc = L['xSize'],
									get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSize end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSize = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								ySize = {
									order = 6,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['ySize'],
									desc = L['ySize'],
									get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySize end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySize = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										end
									end
								},
								DoubleLowerStatusBarArt = {
									order = 7,
									type = "group",
									inline = true,
									name = L['ArtFrame'],
									desc = "",
									args = {
										hideArt = {
											order = 1,
											type = "toggle",
											name = L['Hide'],
											desc = L['Hide ArtFrame'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artHide end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artHide = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end,
										},
										alphaArt = {
											order = 2,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artHide) end,
											type = "range",
											softMin = 0,
											softMax = 1,
											step = 1,
											bigStep = 0.02,
											name = L['alphaArt'],
											desc = L['alphaArt'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artAlpha end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artAlpha = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										Spacer1 = {
											type = "description",
											order = 3,
											name = ""
										},
										xOffsetArt = {
											order = 4,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['xOffsetArt'],
											desc = L['xOffsetArt'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffsetArt end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffsetArt = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										yOffsetArt = {
											order = 5,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['yOffsetArt'],
											desc = L['yOffsetArt'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffsetArt end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffsetArt = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										Spacer2 = {
											type = "description",
											order = 6,
											name = ""
										},
										xSizeArt = {
											order = 7,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['xSizeArt'],
											desc = L['xSizeArt'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSizeArt end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xSizeArt = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										ySizeArt = {
											order = 8,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['ySizeArt'],
											desc = L['ySizeArt'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySizeArt end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySizeArt = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
									}
								},
								DoubleLowerStatusBarOverlay = {
									order = 8,
									type = "group",
									inline = true,
									name = L['OverlayFrame'],
									desc = "",
									args = {
										hideOverlay = {
											order = 1,
											type = "toggle",
											name = L['Hide'],
											desc = L['Hide OverlayFrame'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.overlayHide end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.overlayHide = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end,
										},
										alphaOverlay = {
											order = 2,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.overlayHide) end,
											type = "range",
											softMin = 0,
											softMax = 1,
											step = 0.01,
											bigStep = 0.02,
											name = L['alphaOverlay'],
											desc = L['alphaOverlay'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.overlayAlpha end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.overlayAlpha = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										Spacer1 = {
											type = "description",
											order = 3,
											name = ""
										},
										xOffsetOverlay = {
											order = 4,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.overlayHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['xOffsetOverlay'],
											desc = L['xOffsetOverlay'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffsetOverlay end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.xOffsetOverlay = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										},
										yOffsetOverlay = {
											order = 5,
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.overlayHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['yOffsetOverlay'],
											desc = L['yOffsetOverlay'],
											get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffsetOverlay end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.yOffsetOverlay = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
											end
										}
									}
								}
							}
						}
					}
				}
			}
		},
		extraFrames = {
			order = 2,
			type = 'group',
			childGroups = "tab",
			icon = '',
			name = L['Extra Frames'],
			args = {
				versionD = {
					order = 1,
					type = "description",
					name = '\124cfffb5e26' .. L['Version'] .. ': v' .. ClassicUI.VERSION .. '\124r'
				},
				authorD = {
					order = 2,
					type = "description",
					name = '\124cfffb5e26' .. L['Author: Millán-Sanguino'] .. '\124r'
				},
				Spacer1 = {
					type = "description",
					order = 3,
					name = " "
				},
				enabled = {
					order = 4,
					type = "toggle",
					name = L['Enable ClassicUI core'],
					desc = L['EnableClassicUICoreDesc'],
					width = 1.25,
					confirm = function(_, newValue)
						if (not newValue) then
							return L['RELOADUI_MSG']
						else
							return false
						end
					end,
					get = function() return ClassicUI.db.profile.enabled end,
					set = function(_,value)
						ClassicUI.db.profile.enabled = value
						if value then
							if (not ClassicUI:IsEnabled()) then
								ClassicUI:Enable()
								ClassicUI:MainFunction()
								ClassicUI:ExtraOptionsFunc()
							end
						else
							if (ClassicUI:IsEnabled()) then
								ClassicUI:Disable()
								ReloadUI()
							end
						end
					end
				},
				Header1 = {
					type = 'header',
					order = 5,
					name = L['Extra Frames']
				},
				Comment1 = {
					type = 'description',
					order = 6,
					name = L['EXTRA_FRAMES_DESC']
				},
				Spacer2 = {
					type = "description",
					order = 7,
					name = ""
				},
				Minimap = {
					order = 8,
					name = L['Minimap'],
					type = "group",
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['Minimap']
						},
						Comment1 = {
							type = 'description',
							order = 2,
							name = L['MINIMAP_OPTIONS_DESC']
						},
						Spacer1 = {
							type = "description",
							order = 3,
							name = ""
						},
						enabled1 = {
							order = 4,
							type = "toggle",
							name = L['Enable'],
							desc = L['Restore the old Minimap'],
							confirm = function(_, newValue)
								if (not newValue) then
									return L['RELOADUI_MSG']
								else
									return false
								end
							end,
							get = function()
								return ClassicUI.db.profile.extraFrames.Minimap.enabled
							end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.Minimap.enabled = value
								if (value) then
									ClassicUI:EnableOldMinimap()
									if (ClassicUI.db.profile.extraFrames.Minimap.anchorQueueButtonToMinimap) then
										QueueStatusButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 22 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, -100 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
									end
								else
									if not(ClassicUI.db.profile.extraFrames.Minimap.anchorQueueButtonToMinimap) then
										QueueStatusButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", -7 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, -135 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
									end
									ReloadUI()
								end
							end
						},
						Spacer2 = {
							type = "description",
							order = 5,
							name = ""
						},
						xOffset = {
							order = 6,
							disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
							type = "range",
							softMin = -700,
							softMax = 700,
							step = 1,
							bigStep = 10,
							name = L['xOffset'],
							desc = L['xOffset'],
							get = function() return ClassicUI.db.profile.extraFrames.Minimap.xOffset end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.Minimap.xOffset = value
								ClassicUI.cached_db_profile.extraFrames_Minimap_xOffset = value
								if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
									MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", value, ClassicUI.db.profile.extraFrames.Minimap.yOffset)
									MinimapBorderTop:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", value, ClassicUI.db.profile.extraFrames.Minimap.yOffset)
								end
							end
						},
						yOffset = {
							order = 7,
							disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
							type = "range",
							softMin = -700,
							softMax = 700,
							step = 1,
							bigStep = 10,
							name = L['yOffset'],
							desc = L['yOffset'],
							get = function() return ClassicUI.db.profile.extraFrames.Minimap.yOffset end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.Minimap.yOffset = value
								ClassicUI.cached_db_profile.extraFrames_Minimap_yOffset = value
								if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
									MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", ClassicUI.db.profile.extraFrames.Minimap.xOffset, value)
									MinimapBorderTop:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", ClassicUI.db.profile.extraFrames.Minimap.xOffset, value)
								end
							end
						},
						scale = {
							order = 8,
							disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.extraFrames.Minimap.scale end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.Minimap.scale = value
								if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
									MinimapCluster:SetScale(ClassicUI.db.profile.extraFrames.Minimap.scale)
									MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", ClassicUI.db.profile.extraFrames.Minimap.xOffset, ClassicUI.db.profile.extraFrames.Minimap.yOffset)
								end
							end
						},
						Spacer3 = {
							type = "description",
							order = 9,
							name = ""
						},
						MailIconPriority = {
							order = 10,
							disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
							type = "select",
							name = L['MailIconPriority'],
							desc = L['MailIconPriorityDesc'],
							width = 2.25,
							values = {
								[0] = L['Default - Crafting Order Icon > Mail Icon'],
								[1] = L['Mail Icon > Crafting Order Icon']
							},
							get = function() return ClassicUI.db.profile.extraFrames.Minimap.mailIconPriority end,
							set = function(_,value)
								if (ClassicUI.db.profile.extraFrames.Minimap.mailIconPriority ~= value) then
									ClassicUI.db.profile.extraFrames.Minimap.mailIconPriority = value
									if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
										if (value == 1) then
											MinimapCluster.IndicatorFrame.MailFrame:SetFrameLevel(6)
											MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetFrameLevel(5)
										else
											MinimapCluster.IndicatorFrame.MailFrame:SetFrameLevel(5)
											MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetFrameLevel(6)
										end
									end
								end
							end,
						},
						Spacer4 = {
							type = "description",
							order = 11,
							name = ""
						},
						ExpansionLandingPageButtonGroup = {
							order = 12,
							disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
							inline = true,
							type = "group",
							name = L["ExpansionLandingPage (ELP) Button"],
							desc = "",
							args = {
								xOffsetExpansionLandingPage = {
									order = 1,
									disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
									type = "range",
									softMin = -700,
									softMax = 700,
									step = 1,
									bigStep = 10,
									name = L['xOffsetELPButton'],
									desc = L['xOffsetELPButton'],
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.xOffsetExpansionLandingPage end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Minimap.xOffsetExpansionLandingPage = value
										ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetExpansionLandingPage = value
										if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
											ExpansionLandingPageMinimapButton:ClearAllPoints()
											if (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "dragonflight-landingbutton-up") then
												ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 4 + 26.5 + value, -105 - 6 - 26.5 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetExpansionLandingPage)
											else
												ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 6 + 26.5 + value, -105 - 7 - 26.5 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetExpansionLandingPage)
											end
										end
									end
								},
								yOffsetExpansionLandingPage = {
									order = 2,
									disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
									type = "range",
									softMin = -700,
									softMax = 700,
									step = 1,
									bigStep = 10,
									name = L['yOffsetELPButton'],
									desc = L['yOffsetELPButton'],
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.yOffsetExpansionLandingPage end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Minimap.yOffsetExpansionLandingPage = value
										ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetExpansionLandingPage = value
										if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
											ExpansionLandingPageMinimapButton:ClearAllPoints()
											if (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "dragonflight-landingbutton-up") then
												ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 4 + 26.5 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetExpansionLandingPage, -105 - 6 - 26.5 + value)
											else
												ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 6 + 26.5 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetExpansionLandingPage, -105 - 7 - 26.5 + value)
											end
										end
									end
								},
								scaleExpansionLandingPageDragonflight = {
									order = 3,
									disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
									type = "range",
									min = 0.01,
									softMin = 0.01,
									softMax = 4,
									step = 0.01,
									bigStep = 0.03,
									name = L['ScaleELP-DF-Button'],
									desc = L['ScaleELP-DF-ButtonDesc'],
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.scaleExpansionLandingPageDragonflight end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Minimap.scaleExpansionLandingPageDragonflight = value
										ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageDragonflight = value
										if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
											if (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "dragonflight-landingbutton-up") then
												if (ClassicUI.elpmbSizeW == 0 or ClassicUI.elpmbSizeH == 0) then
													ClassicUI.elpmbSizeW = ExpansionLandingPageMinimapButton:GetWidth()
													ClassicUI.elpmbSizeH = ExpansionLandingPageMinimapButton:GetHeight()
												end
												ExpansionLandingPageMinimapButton:SetSize(math.floor(ClassicUI.elpmbSizeW * value + 0.5), math.floor(ClassicUI.elpmbSizeH * value + 0.5))
											end
										end
									end
								}
							}
						},
						Spacer5 = {
							type = "description",
							order = 13,
							name = ""
						},
						AddonCompartmentFrameGroup = {
							order = 14,
							disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
							inline = true,
							type = "group",
							name = L["AddonCompartment Frame Button"],
							desc = "",
							args = {
								hideAddonCompartment = {
									order = 1,
									type = "toggle",
									name = L['Hide'],
									desc = L['HideAddonCompartmentDesc'],
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.hideAddonCompartment end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Minimap.hideAddonCompartment = value
										ClassicUI.cached_db_profile.extraFrames_Minimap_hideAddonCompartment = value
										if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
											if (value) then
												AddonCompartmentFrame:Hide()
											else
												local addonCount = (type(AddonCompartmentFrame.registeredAddons)=="table") and #AddonCompartmentFrame.registeredAddons or 0
												AddonCompartmentFrame:SetShown(addonCount > 0)
											end
										end
									end,
								},
								Spacer1 = {
									type = "description",
									order = 2,
									name = ""
								},
								xOffsetAddonCompartment = {
									order = 3,
									disabled = function() return (not(ClassicUI.db.profile.extraFrames.Minimap.enabled) or ClassicUI.db.profile.extraFrames.Minimap.hideAddonCompartment) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetACFrame'],
									desc = L['xOffsetACFrame'],
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.xOffsetAddonCompartment end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Minimap.xOffsetAddonCompartment = value
										if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
											AddonCompartmentFrame:ClearAllPoints()
											AddonCompartmentFrame:SetPoint("TOPRIGHT", GameTimeFrame, "TOPLEFT", 5 + value, 0 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetAddonCompartment)
										end
									end
								},
								yOffsetAddonCompartment = {
									order = 4,
									disabled = function() return (not(ClassicUI.db.profile.extraFrames.Minimap.enabled) or ClassicUI.db.profile.extraFrames.Minimap.hideAddonCompartment) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetACFrame'],
									desc = L['yOffsetACFrame'],
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.yOffsetAddonCompartment end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Minimap.yOffsetAddonCompartment = value
										if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
											AddonCompartmentFrame:ClearAllPoints()
											AddonCompartmentFrame:SetPoint("TOPRIGHT", GameTimeFrame, "TOPLEFT", 5 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetAddonCompartment, 0 + value)
										end
									end
								},
								scaleAddonCompartmentDragonflight = {
									order = 5,
									disabled = function() return (not(ClassicUI.db.profile.extraFrames.Minimap.enabled) or ClassicUI.db.profile.extraFrames.Minimap.hideAddonCompartment) end,
									type = "range",
									min = 0.01,
									softMin = 0.01,
									softMax = 4,
									step = 0.01,
									bigStep = 0.03,
									name = L['ScaleACFrame'],
									desc = L['ScaleACFrameDesc'],
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.scaleAddonCompartmentDragonflight end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Minimap.scaleAddonCompartmentDragonflight = value
										if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
											AddonCompartmentFrame:SetScale(value)
										end
									end
								}
							}
						},
						Spacer6 = {
							type = "description",
							order = 15,
							name = ""
						},
						Header2 = {
							type = 'header',
							order = 16,
							name = L['QueueButton (LFG)']
						},
						enabled2 = {
							order = 17,
							type = "toggle",
							name = L['Anchor QueueButton (LFG) to Minimap'],
							desc = L['Anchor QueueButton (LFG) to Minimap'],
							width = "double",
							get = function()
								return ClassicUI.db.profile.extraFrames.Minimap.anchorQueueButtonToMinimap
							end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.Minimap.anchorQueueButtonToMinimap = value
								if (value) then
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
										QueueStatusButton:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -45 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, 4 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
										QueueStatusButton:SetFrameStrata("MEDIUM")
										QueueStatusButton:SetFrameLevel(53)
									else
										QueueStatusButton:SetParent(MicroMenuContainer)
										if MicroMenu ~= nil and MicroMenuContainer~= nil then
											QueueStatusButton:UpdatePosition(MicroMenuContainer:GetPosition(), MicroMenu.isHorizontal)
										end
										QueueStatusButton:SetFrameStrata("MEDIUM")
										QueueStatusButton:SetFrameLevel(2)
									end
								end
							end
						},
						Spacer7 = {
							type = "description",
							order = 18,
							name = ""
						},
						xOffsetQueueButton = {
							order = 19,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['xOffsetQueueButton'],
							desc = L['xOffsetQueueButton'],
							get = function() return ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton = value
								ClassicUI.cached_db_profile.extraFrames_Minimap_xOffsetQueueButton = value
								if (ClassicUI.db.profile.extraFrames.Minimap.anchorQueueButtonToMinimap) then
									QueueStatusButton:ClearAllPoints()
									if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
										QueueStatusButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 22 + value, -100 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
									else
										QueueStatusButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", -7 + value, -135 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
									end
								else
									if (ClassicUI:IsEnabled()) then
										QueueStatusButton:ClearAllPoints()
										QueueStatusButton:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -45 + value, 4 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
									else
										if MicroMenu ~= nil and MicroMenuContainer~= nil then
											QueueStatusButton:UpdatePosition(MicroMenuContainer:GetPosition(), MicroMenu.isHorizontal)
										end
									end
								end
							end
						},
						yOffsetQueueButton = {
							order = 20,
							type = "range",
							softMin = -500,
							softMax = 500,
							step = 1,
							bigStep = 10,
							name = L['yOffsetQueueButton'],
							desc = L['yOffsetQueueButton'],
							get = function() return ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton = value
								ClassicUI.cached_db_profile.extraFrames_Minimap_yOffsetQueueButton = value
								if (ClassicUI.db.profile.extraFrames.Minimap.anchorQueueButtonToMinimap) then
									QueueStatusButton:ClearAllPoints()
									if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
										QueueStatusButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 22 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, -100 + value)
									else
										QueueStatusButton:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", -7 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, -135 + value)
									end
								else
									if (ClassicUI:IsEnabled()) then
										QueueStatusButton:ClearAllPoints()
										QueueStatusButton:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -45 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, 4 + value)
									else
										if MicroMenu ~= nil and MicroMenuContainer~= nil then
											QueueStatusButton:UpdatePosition(MicroMenuContainer:GetPosition(), MicroMenu.isHorizontal)
										end
									end
								end
							end
						},
						Spacer8 = {
							type = "description",
							order = 21,
							name = ""
						},
						bigQueueButton = {
							order = 22,
							type = "toggle",
							name = L['Use a big QueueButton (LFG)'],
							desc = L['Use the default Big QueueButton (LFG) introduced in Dragonflight'],
							width = "double",
							get = function()
								return ClassicUI.db.profile.extraFrames.Minimap.bigQueueButton
							end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.Minimap.bigQueueButton = value
								if (value) then
									ClassicUI:QueueButtonSetBigSize()
								else
									ClassicUI:QueueButtonSetSmallSize()
								end
							end
						}
					}
				},
				Bags = {
					order = 9,
					name = L['Bags'],
					type = "group",
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['Bags']
						},
						Spacer1 = {
							type = "description",
							order = 2,
							name = ""
						},
						FreeSlotsCounterGroup = {
							order = 3,
							inline = true,
							type = "group",
							name = L["FreeSlots Counter"],
							desc = "",
							args = {
								freeSlotCounterMod = {
									order = 1,
									type = "select",
									name = L['FreeSlots Counter Mod'],
									desc = L['Select what text is shown in the FreeSlots Counter in the bag'],
									width = 3.25,
									values = {
										[0] = L['Blizzard-Default - Free slots of All Bags'],
										[1] = L['ClassicUI-Default - Free slots of All Bags excluding the Reagent Bag'],
										[2] = L['Free slots of Normal Bags in one number and free slots of reagent bag in another']
									},
									get = function() return ClassicUI.db.profile.extraFrames.Bags.freeSlotCounterMod end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Bags.freeSlotCounterMod = value
										ClassicUI.cached_db_profile.extraFrames_Bags_freeSlotCounterMod = value
										ClassicUI:BagsFreeSlotsCounterMod()
									end,
								},
								Spacer1 = {
									type = "description",
									order = 2,
									width = 3.25,
									name = ""
								},
								xOffsetFreeSlotsCounter = {
									order = 3,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetFreeSlotsCounter'],
									desc = L['xOffsetFreeSlotsCounter'],
									get = function() return ClassicUI.db.profile.extraFrames.Bags.xOffsetFreeSlotsCounter end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Bags.xOffsetFreeSlotsCounter = value
										MainMenuBarBackpackButton.Count:SetPoint("CENTER", MainMenuBarBackpackButton, "CENTER", 0 + value, -10 + ClassicUI.db.profile.extraFrames.Bags.yOffsetFreeSlotsCounter)
									end
								},
								yOffsetFreeSlotsCounter = {
									order = 4,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetFreeSlotsCounter'],
									desc = L['yOffsetFreeSlotsCounter'],
									get = function() return ClassicUI.db.profile.extraFrames.Bags.yOffsetFreeSlotsCounter end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Bags.yOffsetFreeSlotsCounter = value
										MainMenuBarBackpackButton.Count:SetPoint("CENTER", MainMenuBarBackpackButton, "CENTER", 0 + ClassicUI.db.profile.extraFrames.Bags.xOffsetFreeSlotsCounter, -10 + value)
									end
								},
								freeSlotsCounterFontSize = {
									order = 5,
									type = "range",
									min = 0.05,
									softMin = 0.25,
									softMax = 28,
									step = 0.05,
									bigStep = 0.25,
									name = L['freeSlotsCounterFontSize'],
									desc = L['freeSlotsCounterFontSizeDesc'],
									get = function() return ClassicUI.db.profile.extraFrames.Bags.freeSlotsCounterFontSize end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Bags.freeSlotsCounterFontSize = value
										local font, _, flags = MainMenuBarBackpackButton.Count:GetFont()
										MainMenuBarBackpackButton.Count:SetFont(font, value, flags)
									end
								}
							}
						}
					}
				},
				BuffAndDebuffFrames = {
					order = 10,
					name = L['BuffAndDebuffFrames'],
					type = "group",
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['BuffAndDebuffFrames']
						},
						Spacer1 = {
							type = "description",
							order = 2,
							name = ""
						},
						hideCollapseAndExpandButton = {
							order = 3,
							type = "toggle",
							name = L['Hide the CollapseAndExpandButton'],
							desc = L['Hide the arrow button to the right of the Buffs that allows to show/hide these Buffs and keeps the Buffs always visible'],
							width = "double",
							confirm = function(_, newValue)
								if (not newValue) then
									return L['RELOADUI_MSG']
								else
									return false
								end
							end,
							get = function()
								return ClassicUI.db.profile.extraFrames.BuffAndDebuffFrames.hideCollapseAndExpandButton
							end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.BuffAndDebuffFrames.hideCollapseAndExpandButton = value
								if (value) then
									ClassicUI:BuffFrameHideCollapseAndExpandButton()
								else
									ReloadUI()
								end
							end
						}
					}
				},
				Chat = {
					order = 11,
					name = L['Chat'],
					type = "group",
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['Chat']
						},
						Comment1 = {
							type = "description",
							order = 2,
							name = L['CHAT_OPTIONS_DESC']
						},
						Spacer1 = {
							type = "description",
							order = 3,
							name = ""
						},
						restoreScrollButtons = {
							order = 4,
							type = "toggle",
							name = L['restoreScrollButtons'],
							desc = L['restoreScrollButtonsDesc'],
							width = 2.25,
							get = function()
								return ClassicUI.db.profile.extraFrames.Chat.restoreScrollButtons
							end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.Chat.restoreScrollButtons = value
								if (value) then
									ClassicUI:RestoreChatScrollButtons()
								else
									if CUI_ChatFrame1ButtonFrameBottomButton and CUI_ChatFrame1ButtonFrameBottomButton:IsShown() then
										CUI_ChatFrame1ButtonFrameBottomButton.allowShow = false
										CUI_ChatFrame1ButtonFrameBottomButton:Hide()
									end
									if CUI_ChatFrame1ButtonFrameDownButton and CUI_ChatFrame1ButtonFrameDownButton:IsShown() then
										CUI_ChatFrame1ButtonFrameDownButton.allowShow = false
										CUI_ChatFrame1ButtonFrameDownButton:Hide()
									end
									if CUI_ChatFrame1ButtonFrameUpButton and CUI_ChatFrame1ButtonFrameUpButton:IsShown() then
										CUI_ChatFrame1ButtonFrameUpButton.allowShow = false
										CUI_ChatFrame1ButtonFrameUpButton:Hide()
									end
									ChatFrameMenuButton:ClearAllPoints()
									ChatFrameMenuButton:SetPoint("BOTTOM", ChatFrameMenuButton:GetParent(), "BOTTOM", 0, 0)
								end
							end
						},
						restoreBottomScrollButton = {
							order = 5,
							disabled = function() return not(ClassicUI.db.profile.extraFrames.Chat.restoreScrollButtons) end,
							type = "toggle",
							name = L['restoreBottomScrollButton'],
							desc = L['restoreBottomScrollButtonDesc'],
							width = 2.25,
							get = function()
								return ClassicUI.db.profile.extraFrames.Chat.restoreBottomScrollButton
							end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.Chat.restoreBottomScrollButton = value
								ClassicUI.cached_db_profile.extraFrames_Chat_restoreBottomScrollButton = value
								if (ClassicUI.db.profile.extraFrames.Chat.restoreScrollButtons) then
									ClassicUI:RestoreChatScrollButtons()
								end
							end
						},
						socialButtonToBottom = {
							order = 6,
							disabled = function() return not(ClassicUI.db.profile.extraFrames.Chat.restoreScrollButtons) end,
							type = "toggle",
							name = L['socialButtonToBottom'],
							desc = L['socialButtonToBottomDesc'],
							width = 2.25,
							get = function()
								return ClassicUI.db.profile.extraFrames.Chat.socialButtonToBottom
							end,
							set = function(_,value)
								ClassicUI.db.profile.extraFrames.Chat.socialButtonToBottom = value
								ClassicUI.cached_db_profile.extraFrames_Chat_socialButtonToBottom = value
								if (ClassicUI.db.profile.extraFrames.Chat.restoreScrollButtons) then
									ClassicUI:RestoreChatScrollButtons()
								end
							end
						},
					}
				}
			}
		},
		extraOptions = {
			order = 3,
			type = 'group',
			childGroups = "tab",
			icon = '',
			name = L['Extra Options'],
			args = {
				versionD = {
					order = 1,
					type = "description",
					name = '\124cfffb5e26' .. L['Version'] .. ': v' .. ClassicUI.VERSION .. '\124r'
				},
				authorD = {
					order = 2,
					type = "description",
					name = '\124cfffb5e26' .. L['Author: Millán-Sanguino'] .. '\124r'
				},
				Spacer1 = {
					type = "description",
					order = 3,
					name = " "
				},
				enabled = {
					order = 4,
					type = "toggle",
					name = L['Enable ClassicUI core'],
					desc = L['EnableClassicUICoreDesc'],
					width = 1.25,
					confirm = function(_, newValue)
						if (not newValue) then
							return L['RELOADUI_MSG']
						else
							return false
						end
					end,
					get = function() return ClassicUI.db.profile.enabled end,
					set = function(_,value)
						ClassicUI.db.profile.enabled = value
						if value then
							if (not ClassicUI:IsEnabled()) then
								ClassicUI:Enable()
								ClassicUI:MainFunction()
								ClassicUI:ExtraOptionsFunc()
							end
						else
							if (ClassicUI:IsEnabled()) then
								ClassicUI:Disable()
								ReloadUI()
							end
						end
					end
				},
				forceExtraOptions = {
					order = 5,
					type = "toggle",
					name = L['Force Extra Options'],
					desc = L['Enable Extra Options even ClassicUI core is disabled'],
					width = "double",
					confirm = function(_, newValue)
						if ((not newValue) and (not ClassicUI:IsEnabled())) then
							return L['RELOADUI_MSG']
						else
							return false
						end
					end,
					get = function() return ClassicUI.db.profile.forceExtraOptions end,
					set = function(_,value)
						ClassicUI.db.profile.forceExtraOptions = value
						if value then
							if (not ClassicUI:IsEnabled()) then
								ClassicUI:ExtraOptionsFunc()
							end
						else
							if (not ClassicUI:IsEnabled()) then
								ReloadUI()
							end
						end
					end
				},
				Header1 = {
					type = 'header',
					order = 6,
					name = L['Extra Options']
				},
				Comment1 = {
					type = 'description',
					order = 7,
					name = L['EXTRA_OPTIONS_DESC']
				},
				Spacer2 = {
					type = "description",
					order = 8,
					name = ""
				},
				openGuildPanelOptions = {
					order = 9,
					name = L['Guild Panel Mode'],
					type = "group",
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['Guild Panel Mode']
						},
						Comment1 = {
							type = 'description',
							order = 2,
							name = L['GUILD_PANEL_MODE_OPTIONS_DESC']
						},
						Spacer1 = {
							type = "description",
							order = 3,
							name = ""
						},
						openGuildPanelNormalMode = {
							order = 4,
							type = "select",
							name = L['OPEN_GUILD_PANEL_NORMAL'],
							desc = L['OPEN_GUILD_PANEL_NORMAL_DESC'],
							width = 2.25,
							values = {
								[0] = L['Defauilt - Show the new social guild panel'],
								[1] = L['Show the old guild panel']
							},
							get = function()
								return (ClassicUI.db.profile.extraConfigs.GuildPanelMode.defaultOpenOldMenu and 1 or 0)
							end,
							set = function(_, value)
								if (value == 1) then
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.defaultOpenOldMenu = true
									ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_defaultOpenOldMenu = true
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:HookOpenGuildPanelMode()
									end
								else
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.defaultOpenOldMenu = false
									ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_defaultOpenOldMenu = false
								end
							end
						},
						openGuildPanelLeftClickMicroButton = {
							order = 5,
							type = "select",
							name = L['OPEN_GUILD_PANEL_LEFT_MICROBUTTON_CLICK'],
							desc = L['OPEN_GUILD_PANEL_LEFT_MICROBUTTON_CLICK_DESC'],
							width = 2.25,
							values = {
								[0] = L['Defauilt - Show the new social guild panel'],
								[1] = L['Show the old guild panel']
							},
							get = function()
								return (ClassicUI.db.profile.extraConfigs.GuildPanelMode.leftClickMicroButtonOpenOldMenu and 1 or 0)
							end,
							set = function(_, value)
								if (value == 1) then
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.leftClickMicroButtonOpenOldMenu = true
									ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_leftClickMicroButtonOpenOldMenu = true
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:HookOpenGuildPanelMode()
									end
								else
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.leftClickMicroButtonOpenOldMenu = false
									ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_leftClickMicroButtonOpenOldMenu = false
								end
							end
						},
						openGuildPanelRightClickMicroButton = {
							order = 6,
							type = "select",
							name = L['OPEN_GUILD_PANEL_RIGHT_MICROBUTTON_CLICK'],
							desc = L['OPEN_GUILD_PANEL_RIGHT_MICROBUTTON_CLICK_DESC'],
							width = 2.25,
							values = {
								[0] = L['Defauilt - Show the new social guild panel'],
								[1] = L['Show the old guild panel']
							},
							get = function()
								return (ClassicUI.db.profile.extraConfigs.GuildPanelMode.rightClickMicroButtonOpenOldMenu and 1 or 0)
							end,
							set = function(_, value)
								if (value == 1) then
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.rightClickMicroButtonOpenOldMenu = true
									ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_rightClickMicroButtonOpenOldMenu = true
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:HookOpenGuildPanelMode()
									end
								else
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.rightClickMicroButtonOpenOldMenu = false
									ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_rightClickMicroButtonOpenOldMenu = false
								end
							end
						},
						openGuildPanelMiddleClickMicroButton = {
							order = 7,
							type = "select",
							name = L['OPEN_GUILD_PANEL_MIDDLE_MICROBUTTON_CLICK'],
							desc = L['OPEN_GUILD_PANEL_MIDDLE_MICROBUTTON_CLICK_DESC'],
							width = 2.25,
							values = {
								[0] = L['Defauilt - Show the new social guild panel'],
								[1] = L['Show the old guild panel']
							},
							get = function()
								return (ClassicUI.db.profile.extraConfigs.GuildPanelMode.middleClickMicroButtonOpenOldMenu and 1 or 0)
							end,
							set = function(_, value)
								if (value == 1) then
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.middleClickMicroButtonOpenOldMenu = true
									ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_middleClickMicroButtonOpenOldMenu = true
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:HookOpenGuildPanelMode()
									end
								else
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.middleClickMicroButtonOpenOldMenu = false
									ClassicUI.cached_db_profile.extraConfigs_GuildPanelMode_middleClickMicroButtonOpenOldMenu = false
								end
							end
						}
					}
				},
				keybindsVisibilityOptions = {
					order = 10,
					name = L['Keybinds Visibility'],
					type = "group",
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['Keybinds Visibility']
						},
						Comment1 = {
							type = 'description',
							order = 2,
							name = L['KEYBINDS_VISIBILITY_OPTIONS_DESC']
						},
						Spacer1 = {
							type = "description",
							order = 3,
							name = ""
						},
						hideKeybindsMode = {
							order = 4,
							type = "select",
							name = L['Keybinds Visibility'],
							desc = L['KEYBINDS_VISIBILITY_OPTIONS_SELECT_DESC'],
							width = 2.25,
							confirm = function(_, newValue)
								if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
									if ((ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode >= 2) and (newValue < 2)) then
										return L['RELOADUI_MSG']
									else
										return false
									end
								else
									return false
								end
							end,
							values = {
								[0] = L['Default - Show all keybinds'],
								[1] = L['Hide completly all keybinds'],
								[2] = L['Hide keybinds but show dot range'],
								[3] = L['Hide keybinds but show a permanent dot range']
							},
							get = function()
								return ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode
							end,
							set = function(_, value)
								if ((ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode >= 2) and (value < 2)) then
									ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode = value
									ClassicUI.cached_db_profile.extraConfigs_KeybindsConfig_hideKeybindsMode = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:ToggleVisibilityKeybinds(value)
										ReloadUI()
									end
								else
									ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode = value
									ClassicUI.cached_db_profile.extraConfigs_KeybindsConfig_hideKeybindsMode = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:ToggleVisibilityKeybinds(value)
									end
								end
							end
						},
						Spacer2 = {
							type = "description",
							order = 5,
							name = ""
						},
						hideActionButtonName = {
							order = 6,
							type = "toggle",
							name = L['Hide ActionButtons Name'],
							desc = L['HIDE_ACTIONBUTTONS_NAME_DESC'],
							width = "double",
							get = function()
								return ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideActionButtonName
							end,
							set = function(_,value)
								ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideActionButtonName = value
								ClassicUI:ToggleVisibilityActionButtonNames(value)
							end
						}
					}
				},
				redRangeOptions = {
					order = 11,
					name = L['RedRange & GreyOnCooldown'],
					type = "group",
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['RedRange']
						},
						Comment1 = {
							type = 'description',
							order = 2,
							name = L['REDRANGE_OPTIONS_DESC']
						},
						Spacer1 = {
							type = "description",
							order = 3,
							name = ""
						},
						enabled1 = {
							order = 4,
							type = "toggle",
							name = L['Enable'],
							desc = L['Enable RedRange'],
							confirm = function(_, newValue)
								if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
									if ((not newValue) and (ClassicUI.db.profile.extraConfigs.RedRangeConfig.enabled)) then
										return L['RELOADUI_MSG']
									else
										return false
									end
								else
									return false
								end
							end,
							get = function()
								return ClassicUI.db.profile.extraConfigs.RedRangeConfig.enabled
							end,
							set = function(_,value)
								if ((not value) and (ClassicUI.db.profile.extraConfigs.RedRangeConfig.enabled)) then
									ClassicUI.db.profile.extraConfigs.RedRangeConfig.enabled = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ReloadUI()
									end
								else
									ClassicUI.db.profile.extraConfigs.RedRangeConfig.enabled = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:HookRedRangeIcons()
									end
								end
							end
						},
						Header2 = {
							type = 'header',
							order = 5,
							name = L['GreyOnCooldown']
						},
						Comment2 = {
							type = 'description',
							order = 6,
							name = L['GREYONCOOLDOWN_OPTIONS_DESC']
						},
						Spacer2 = {
							type = "description",
							order = 7,
							name = ""
						},
						enabled2 = {
							order = 8,
							type = "toggle",
							name = L['Enable'],
							desc = L['Enable GreyOnCooldown'],
							confirm = function(_, newValue)
								if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
									if ((not newValue) and (ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.enabled)) then
										return L['RELOADUI_MSG']
									else
										return false
									end
								else
									return false
								end
							end,
							get = function()
								return ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.enabled
							end,
							set = function(_,value)
								if ((not value) and (ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.enabled)) then
									ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.enabled = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ReloadUI()
									end
								else
									ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.enabled = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:HookGreyOnCooldownIcons()
									end
								end
							end
						},
						Spacer3 = {
							type = "description",
							order = 9,
							name = ""
						},
						minDuration = {
							order = 10,
							type = "range",
							width = "double",
							min = 0.01,
							softMin = 0.01,
							softMax = 12,
							step = 0.01,
							bigStep = 0.05,
							name = L['minDuration'],
							desc = L['minDurationDesc'],
							get = function() return ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.minDuration end,
							set = function(_,value)
								ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.minDuration = value
								ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_minDuration = value
							end
						},
						minDurationToDefault = {
							order = 11,
							type = "execute",
							name = L["Default"],
							desc = L["DefaultDesc"],
							func = function()
								ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.minDuration = ClassicUI.db.defaults.profile.extraConfigs.GreyOnCooldownConfig.minDuration
								ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_minDuration = ClassicUI.db.defaults.profile.extraConfigs.GreyOnCooldownConfig.minDuration
							end
						}
					}
				},
				LossOfControlUIOptions = {
					order = 12,
					name = L['LossOfControlUI CC Remover'],
					type = "group",
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['LossOfControlUI CC Remover']
						},
						Comment1 = {
							type = 'description',
							order = 2,
							name = L['LOSSOFCONTROLUI_OPTION_DESC']
						},
						Spacer1 = {
							type = "description",
							order = 3,
							name = ""
						},
						enabled = {
							order = 4,
							type = "toggle",
							name = L['Enable'],
							desc = L['Enable LossOfControlUI Remover'],
							confirm = function(_, newValue)
								if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
									if ((not newValue) and (ClassicUI.db.profile.extraConfigs.LossOfControlUIConfig.enabled)) then
										return L['RELOADUI_MSG']
									else
										return false
									end
								else
									return false
								end
							end,
							get = function()
								return ClassicUI.db.profile.extraConfigs.LossOfControlUIConfig.enabled
							end,
							set = function(_,value)
								if ((not value) and (ClassicUI.db.profile.extraConfigs.LossOfControlUIConfig.enabled)) then
									ClassicUI.db.profile.extraConfigs.LossOfControlUIConfig.enabled = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ReloadUI()
									end
								else
									ClassicUI.db.profile.extraConfigs.LossOfControlUIConfig.enabled = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:HookLossOfControlUICCRemover()
									end
								end
							end
						}
					}
				}
			}
		}
	}
}
