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
					name = '\124cfffb5e26' .. L['Author: Millán-C\'Thun'] .. '\124r'
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
							return L['ReloadUI']
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
						}
					}
				},
				GargoyleOptions = {
					order = 7,
					type = "group",
					name = L['GargoyleFrames'],
					desc = L['GargoyleFrames'],
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['Left Gargoyle']
						},
						enabledLeftGargoyle = {
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
						Spacer1 = {
							type = "description",
							order = 5,
							name = ""
						},
						Header2 = {
							type = 'header',
							order = 6,
							name = L['Right Gargoyle']
						},
						enabledRightGargoyle = {
							order = 7,
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
							order = 8,
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
							order = 9,
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
						}
					},
				},
				MultiActionBarOptions = {
					order = 8,
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
						OffsetsStatusBar1 = {
							order = 4,
							inline = true,
							type = "group",
							name = " ",
							desc = "",
							args = {
								ignoreyOffsetStatusBar = {
									order = 1,
									type = "toggle",
									name = L['Disable auto-yOffset [*]'],
									desc = L['Disable auto-yOffset when StatusBar are showed'],
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
									name = L['yOffset - 1 StatusBar Showed'],
									desc = L['yOffset when One Status Bar is showed'],
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
									name = L['yOffset - 2 StatusBar Showed'],
									desc = L['yOffset when Two Status Bars are showed'],
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset2StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.yOffset2StatusBar = value
										ClassicUI.Update_MultiActionBar()
									end
								}
							}
						},
						Spacer1 = {
							type = "description",
							order = 5,
							name = ""
						},
						Header2 = {
							type = 'header',
							order = 6,
							name = L['RightMultiActionBars']
						},
						xOffsetRightMultiActionBars = {
							order = 7,
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
							order = 8,
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
							order = 9,
							inline = true,
							type = "group",
							name = " ",
							desc = "",
							args = {
								ignoreyOffsetStatusBar = {
									order = 1,
									type = "toggle",
									name = L['Disable auto-yOffset [*]'],
									desc = L['Disable auto-yOffset when StatusBar are showed'],
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
									name = L['yOffset - 1 StatusBar Showed'],
									desc = L['yOffset when One Status Bar is showed'],
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
									name = L['yOffset - 2 StatusBar Showed'],
									desc = L['yOffset when Two Status Bars are showed'],
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset2StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.yOffset2StatusBar = value
										ClassicUI.Update_MultiActionBar()
									end
								}
							}
						}
					}
				},
				PetActionBarOptions = {
					order = 9,
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
							name = L['xOffset - StanceBar Showed'],
							desc = L['xOffset when StanceBar is showed'],
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
									desc = L['Disable auto-yOffset when StatusBar are showed'],
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
									name = L['yOffset - 1 StatusBar Showed'],
									desc = L['yOffset when One Status Bar is showed'],
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
									name = L['yOffset - 2 StatusBar Showed'],
									desc = L['yOffset when Two Status Bars are showed'],
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset2StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.yOffset2StatusBar = value
										ClassicUI.Update_PetActionBar()
									end
								}
							}
						}
					}
				},
				StanceBarOptions = {
					order = 10,
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
									desc = L['Disable auto-yOffset when StatusBar are showed'],
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
									name = L['yOffset - 1 StatusBar Showed'],
									desc = L['yOffset when One Status Bar is showed'],
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
									name = L['yOffset - 2 StatusBar Showed'],
									desc = L['yOffset when Two Status Bars are showed'],
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset2StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.yOffset2StatusBar = value
										ClassicUI.Update_StanceBar()
									end
								}
							}
						}
					}
				},
				PossessBarOptions = {
					order = 11,
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
									desc = L['Disable auto-yOffset when StatusBar are showed'],
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
									name = L['yOffset - 1 StatusBar Showed'],
									desc = L['yOffset when One Status Bar is showed'],
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
									name = L['yOffset - 2 StatusBar Showed'],
									desc = L['yOffset when Two Status Bars are showed'],
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset2StatusBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.yOffset2StatusBar = value
										ClassicUI.Update_PossessBar()
									end
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
					name = '\124cfffb5e26' .. L['Author: Millán-C\'Thun'] .. '\124r'
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
							return L['ReloadUI']
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
					name = L['Extra Options']
				},
				Comment1 = {
					type = 'description',
					order = 6,
					name = L['EXTRA_OPTIONS_DESC']
					
				},
				Spacer2 = {
					type = "description",
					order = 7,
					name = ""
				},
				keybindsVisibilityOptions = {
					order = 8,
					name = L['Keybinds Visibility Options'],
					type = "group",
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['Keybinds Visibility Options']
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
							name = L['Keybinds Visibility Options'],
							desc = L['KEYBINDS_VISIBILITY_OPTIONS_SELECT_DESC'],
							width = "double",
							confirm = function(_, newValue)
								if (ClassicUI:IsEnabled()) then
									if ((ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode == 2) and (newValue ~= 2)) then
										return L['ReloadUI']
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
								[2] = L['Hide keybinds but show dot range']
							},
							get = function()
								return ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode
							end,
							set = function(_, value)
								if ((ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode == 2) and (value ~= 2)) then
									ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode = value
									if (ClassicUI:IsEnabled()) then
										ClassicUI:ToggleVisibilityKeybinds(value)
										ReloadUI()
									end
								else
									ClassicUI.db.profile.extraConfigs.KeybindsConfig.hideKeybindsMode = value
									if (ClassicUI:IsEnabled()) then
										ClassicUI:ToggleVisibilityKeybinds(value)
									end
								end
							end
						}
					}
				},
				redRangeOptions = {
					order = 9,
					name = L['RedRange Options'],
					type = "group",
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['RedRange Options']
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
						enabled = {
							order = 4,
							type = "toggle",
							name = L['Enable'],
							desc = L['Enable RedRange'],
							confirm = function(_, newValue)
								if (ClassicUI:IsEnabled()) then
									if ((not newValue) and (ClassicUI.db.profile.extraConfigs.RedRangeConfig.enabled)) then
										return L['ReloadUI']
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
									if (ClassicUI:IsEnabled()) then
										ReloadUI()
									end
								else
									ClassicUI.db.profile.extraConfigs.RedRangeConfig.enabled = value
									if (ClassicUI:IsEnabled()) then
										ClassicUI:HookRedRangeIcons()
									end
								end
							end
						}
					}
				},
				LossOfControlUIOptions = {
					order = 10,
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
								if (ClassicUI:IsEnabled()) then
									if ((not newValue) and (ClassicUI.db.profile.extraConfigs.LossOfControlUIConfig.enabled)) then
										return L['ReloadUI']
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
									if (ClassicUI:IsEnabled()) then
										ReloadUI()
									end
								else
									ClassicUI.db.profile.extraConfigs.LossOfControlUIConfig.enabled = value
									if (ClassicUI:IsEnabled()) then
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
