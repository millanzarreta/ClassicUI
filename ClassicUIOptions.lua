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
					name = L['Enable ClassicUI'],
					desc = L['Enable ClassicUI'],
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
								ClassicUI:ExtraFunction()
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
								ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
								ClassicUI:ForceExpBarExhaustionTickUpdate()
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
							end
						},
						scale = {
							order = 4,
							type = "range",
							min = 0.0001,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MainMenuBar.scale = value
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
							end
						},
						hideLatencyBar = {
							order = 5,
							type = "toggle",
							name = L['Hide Small Latency Bar'],
							desc = L['Hide Small Latency Bar'],
							width = "double",
							get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.hideLatencyBar end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MainMenuBar.hideLatencyBar = value
								if value then
									MainMenuBarPerformanceBar:SetAlpha(0)
									MainMenuBarPerformanceBar:Hide()
								else
									MainMenuBarPerformanceBar:SetAlpha(1)
									MainMenuBarPerformanceBar:Show()
								end
							end,
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
							end
						},
						scale = {
							order = 4,
							type = "range",
							min = 0.0001,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.OverrideActionBar.scale = value
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
							end
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
							end
						},
						modelLeftGargoyle = {
							order = 5,
							type = "select",
							name = L['Left Gargoyle Model'],
							desc = L['Select the model of the Left Gargoyle'],
							values = {
								[0] = L['Default - Gryphon'],
								[1] = L['Lion']
							},
							get = function() return ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.model end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.model = value
								if (ClassicUI:IsEnabled()) then
									if (value == 1) then
										MainMenuBarArtFrame.LeftEndCap:Hide()
									else
										MainMenuBarArtFrame.LeftEndCap:SetSize(128, 76)
										if (not ClassicUI.UberUIIsPresent) then
											MainMenuBarArtFrame.LeftEndCap:SetTexture("Interface\\MAINMENUBAR\\UI-MainMenuBar-EndCap-Dwarf.blp")
											MainMenuBarArtFrame.LeftEndCap:SetTexCoord(0/128, 128/128, 52/128, 128/128)
										else
											local txInfo = C_Texture.GetAtlasInfo(MainMenuBarArtFrame.LeftEndCap:GetAtlas() or "hud-MainMenuBar-gryphon")
											MainMenuBarArtFrame.LeftEndCap:SetTexture("Interface\\AddOns\\Uber UI\\textures\\MainMenuBar.blp")
											MainMenuBarArtFrame.LeftEndCap:SetTexCoord(txInfo.leftTexCoord, txInfo.rightTexCoord, txInfo.topTexCoord, txInfo.bottomTexCoord)
										end
									end
									ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								MainMenuBarArtFrame.LeftEndCap:SetAlpha(value)
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
							end
						},
						scaleLeftGargoyle = {
							order = 7,
							type = "range",
							min = 0.0001,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.LeftGargoyleFrame.scale = value
								MainMenuBarArtFrame.LeftEndCap:SetScale(value)
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
							end
						},
						modelRightGargoyle = {
							order = 13,
							type = "select",
							name = L['Right Gargoyle Model'],
							desc = L['Select the model of the Right Gargoyle'],
							values = {
								[0] = L['Default - Gryphon'],
								[1] = L['Lion']
							},
							get = function() return ClassicUI.db.profile.barsConfig.RightGargoyleFrame.model end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightGargoyleFrame.model = value
								if (ClassicUI:IsEnabled()) then
									if (value == 1) then
										MainMenuBarArtFrame.RightEndCap:Hide()
									else
										MainMenuBarArtFrame.RightEndCap:SetSize(128, 76)
										if (not ClassicUI.UberUIIsPresent) then
											MainMenuBarArtFrame.RightEndCap:SetTexture("Interface\\MAINMENUBAR\\UI-MainMenuBar-EndCap-Dwarf.blp")
											MainMenuBarArtFrame.RightEndCap:SetTexCoord(128/128, 0/128, 52/128, 128/128)
										else
											local txInfo = C_Texture.GetAtlasInfo(MainMenuBarArtFrame.RightEndCap:GetAtlas() or "hud-MainMenuBar-gryphon")
											MainMenuBarArtFrame.RightEndCap:SetTexture("Interface\\AddOns\\Uber UI\\textures\\MainMenuBar.blp")
											MainMenuBarArtFrame.RightEndCap:SetTexCoord(txInfo.rightTexCoord, txInfo.leftTexCoord, txInfo.topTexCoord, txInfo.bottomTexCoord)
										end
									end
									ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								MainMenuBarArtFrame.RightEndCap:SetAlpha(value)
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
							end
						},
						scaleRightGargoyle = {
							order = 15,
							type = "range",
							min = 0.0001,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.RightGargoyleFrame.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightGargoyleFrame.scale = value
								MainMenuBarArtFrame.RightEndCap:SetScale(value)
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
							end
						},
						scale = {
							order = 4,
							type = "range",
							min = 0.0001,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.PetBattleFrameBar.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetBattleFrameBar.scale = value
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
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
								ClassicUI.Update_MultiActionBar()
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
								ClassicUI.Update_MultiActionBar()
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
										ClassicUI.Update_MultiActionBar()
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
										ClassicUI.Update_MultiActionBar()
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
										ClassicUI.Update_MultiActionBar()
									end
								}
							}
						},
						scaleBottomMultiActionBars = {
							order = 6,
							type = "range",
							min = 0.0001,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.BottomMultiActionBars.scale = value
								ClassicUI.Update_MultiActionBar()
							end
						},
						Spacer2 = {
							type = "description",
							order = 7,
							name = ""
						},
						Header2 = {
							type = 'header',
							order = 8,
							name = L['RightMultiActionBars']
						},
						autoAdjustmentRightMultiActionBarsGroup = {
							order = 9,
							inline = true,
							type = "group",
							name = " ",
							desc = "",
							args = {
								useBlizzardPostBFAAutoAdjustmentRightMultiActionBars = {
									order = 1,
									type = "toggle",
									name = L['UseBlizzardPostBFAAutoAdjustment'],
									desc = L['UseBlizzardPostBFAAutoAdjustmentDesc'],
									width = "full",
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.useBlizzardPostBFAAutoAdjustment end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.useBlizzardPostBFAAutoAdjustment = value
										ClassicUI.Update_MultiActionBar()
									end,
								},
								useMinimapFrameAsTopMarginRightMultiActionBars = {
									order = 2,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.useBlizzardPostBFAAutoAdjustment) end,
									type = "toggle",
									name = L['UseMinimapFrameAsTopMargin'],
									desc = L['UseMinimapFrameAsTopMarginDesc'],
									width = "full",
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.useMinimapFrameAsTopMargin end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.useMinimapFrameAsTopMargin = value
										ClassicUI.Update_MultiActionBar()
									end,
								},
								allowExceedTopMarginWithTwoStatusBarsRightMultiActionBars = {
									order = 3,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.useBlizzardPostBFAAutoAdjustment) end,
									type = "toggle",
									name = L['AllowExceedTopMarginWithTwoStatusBars'],
									desc = L['AllowExceedTopMarginWithTwoStatusBarsDesc'],
									width = "full",
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.allowExceedTopMarginWithTwoStatusBars end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.allowExceedTopMarginWithTwoStatusBars = value
										ClassicUI.Update_MultiActionBar()
									end,
								},
							},
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
								ClassicUI.Update_MultiActionBar()
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
								ClassicUI.Update_MultiActionBar()
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
										ClassicUI.Update_MultiActionBar()
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
										ClassicUI.Update_MultiActionBar()
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
										ClassicUI.Update_MultiActionBar()
									end
								}
							}
						},
						scaleRightMultiActionBars = {
							order = 13,
							type = "range",
							min = 0.0001,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightMultiActionBars.scale = value
								ClassicUI.Update_MultiActionBar()
							end
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
								ClassicUI.Update_PetActionBar()
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
								ClassicUI.Update_PetActionBar()
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
								ClassicUI.Update_PetActionBar()
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
										ClassicUI.Update_PetActionBar()
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
										ClassicUI.Update_PetActionBar()
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
										ClassicUI.Update_PetActionBar()
									end
								}
							}
						},
						scale = {
							order = 7,
							type = "range",
							min = 0.0001,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.scale = value
								ClassicUI.Update_PetActionBar()
							end
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
								ClassicUI.Update_StanceBar()
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
								ClassicUI.Update_StanceBar()
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
										ClassicUI.Update_StanceBar()
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
										ClassicUI.Update_StanceBar()
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
										ClassicUI.Update_StanceBar()
									end
								}
							}
						},
						scale = {
							order = 6,
							type = "range",
							min = 0.0001,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.StanceBarFrame.scale = value
								ClassicUI.Update_StanceBar()
							end
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
								ClassicUI.Update_PossessBar()
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
								ClassicUI.Update_PossessBar()
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
										ClassicUI.Update_PossessBar()
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
										ClassicUI.Update_PossessBar()
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
										ClassicUI.Update_PossessBar()
									end
								}
							}
						},
						scale = {
							order = 6,
							type = "range",
							min = 0.0001,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = L['Scale'],
							get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PossessBarFrame.scale = value
								ClassicUI.Update_PossessBar()
							end
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
							name = L['SingleStatusBar']
						},
						Comment1 = {
							type = 'description',
							order = 2,
							name = L['Configuration for 1 visible StatusBar']
						},
						Spacer1 = {
							type = "description",
							order = 3,
							name = ""
						},
						hideSingleStatusBar = {
							order = 4,
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
								ClassicUI:UpdateStatusBarCache()
								if (not ClassicUI.cached_SingleStatusBar_hide) then
									if (not StatusTrackingBarManager:IsShown()) then
										StatusTrackingBarManager:Show()
									end
								end
								ClassicUI:SetPositionForStatusBars_MainMenuBar()
							end,
						},
						Spacer2 = {
							type = "description",
							order = 5,
							name = ""
						},
						SingleStatusBarxOffset = {
							order = 6,
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
								ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
							end
						},
						SingleStatusBaryOffset = {
							order = 7,
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
								ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
							end
						},
						SingleStatusBarAlpha = {
							order = 8,
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
								ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
							end
						},
						Spacer3 = {
							type = "description",
							order = 9,
							name = ""
						},
						SingleStatusBarxSize = {
							order = 10,
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
								ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
								ClassicUI:ForceExpBarExhaustionTickUpdate()
							end
						},
						SingleStatusBarySize = {
							order = 11,
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
								ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
								ClassicUI:ForceExpBarExhaustionTickUpdate()
							end
						},
						SingleStatusBarArt = {
							order = 12,
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
									end
								}
							}
						},
						SingleStatusBarOverlay = {
							order = 13,
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
									end
								}
							}
						},
						Spacer4 = {
							type = "description",
							order = 14,
							name = ""
						},
						Header2 = {
							type = 'header',
							order = 15,
							name = L['DoubleStatusBar']
						},
						Comment2 = {
							type = 'description',
							order = 16,
							name = L['Configuration for 2 visible StatusBars']
						},
						Spacer5 = {
							type = 'description',
							order = 17,
							name = ""
						},
						hideDoubleStatusBar = {
							order = 18,
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
								ClassicUI:UpdateStatusBarCache()
								if (not ClassicUI.cached_DoubleStatusBar_hide) then
									if (not StatusTrackingBarManager:IsShown()) then
										StatusTrackingBarManager:Show()
									end
								end
								ClassicUI:SetPositionForStatusBars_MainMenuBar()
							end,
						},
						Spacer6 = {
							type = 'description',
							order = 19,
							name = ""
						},
						UpperStatusBar = {
							order = 20,
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										ClassicUI:ForceExpBarExhaustionTickUpdate()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										ClassicUI:ForceExpBarExhaustionTickUpdate()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
											end
										}
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
											end
										}
									}
								}
							}
						},
						LowerStatusBar = {
							order = 21,
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										ClassicUI:ForceExpBarExhaustionTickUpdate()
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
										ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
										ClassicUI:ForceExpBarExhaustionTickUpdate()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
											end
										}
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
												ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
		extraOptions = {
			order = 2,
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
					name = L['Enable ClassicUI'],
					desc = L['Enable ClassicUI'],
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
								ClassicUI:ExtraFunction()
								ClassicUI.SetPositionForStatusBars_MainMenuBar()
								ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
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
					desc = L['Enable Extra Options even ClassicUI is disabled'],
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
								ClassicUI:ExtraFunction()
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
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:HookOpenGuildPanelMode()
									end
								else
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.defaultOpenOldMenu = false
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
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:HookOpenGuildPanelMode()
									end
								else
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.leftClickMicroButtonOpenOldMenu = false
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
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:HookOpenGuildPanelMode()
									end
								else
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.rightClickMicroButtonOpenOldMenu = false
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
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:HookOpenGuildPanelMode()
									end
								else
									ClassicUI.db.profile.extraConfigs.GuildPanelMode.middleClickMicroButtonOpenOldMenu = false
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
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:ToggleVisibilityKeybinds(value)
										ReloadUI()
									end
								else
									ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:ToggleVisibilityKeybinds(value)
									end
								end
							end
						},
						Spacer1 = {
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
							end
						},
						minDurationToDefault = {
							order = 11,
							type = "execute",
							name = L["Default"],
							desc = L["DefaultDesc"],
							func = function() ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.minDuration = ClassicUI.db.defaults.profile.extraConfigs.GreyOnCooldownConfig.minDuration end
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
