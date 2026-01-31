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
				disabledAddonCompartmentIntegration = {
					order = 5,
					type = "toggle",
					name = L['DisableAddonCompartmentIntegration'],
					desc = L['DisableAddonCompartmentIntegrationDesc'],
					width = "double",
					get = function() return ClassicUI.db.profile.disabledAddonCompartmentIntegration end,
					set = function(_,value)
						ClassicUI.db.profile.disabledAddonCompartmentIntegration = value
						ClassicUI:AddonCompartmentIntegration(not(value))
					end
				},
				Header1 = {
					type = 'header',
					order = 6,
					name = L['Configure Frames']
				},
				MainMenuBarOptions = {
					order = 7,
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
								ClassicUI.cached_db_profile.barsConfig_MainMenuBar_xOffset = value
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
								ClassicUI.cached_db_profile.barsConfig_MainMenuBar_yOffset = value
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
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MainMenuBar.scale, 1),
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
										[1] = L['Modern Layout']
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = function()
										if (ClassicUI.db ~= nil) then
											if (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle == 1) then
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.MainMenuBar.BLStyle1NormalTextureAlpha, 1)
											else
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.MainMenuBar.BLStyle0NormalTextureAlpha, 1)
											end
										else
											return L['NormalTexture Alpha']
										end
									end,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewSpellActivationAlert = {
									order = 11,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellActivationAlert'],
									desc = L['BLStyle0UseNewSpellActivationAlertDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewSpellActivationAlert end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewSpellActivationAlert = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewTargetReticleAnimFrame = {
									order = 12,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewTargetReticleAnimFrame'],
									desc = L['BLStyle0UseNewTargetReticleAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewTargetReticleAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewTargetReticleAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewInterruptDisplay = {
									order = 13,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewInterruptDisplay'],
									desc = L['BLStyle0UseNewInterruptDisplayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewInterruptDisplay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewInterruptDisplay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewSpellCastAnimFrame = {
									order = 14,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellCastAnimFrame'],
									desc = L['BLStyle0UseNewSpellCastAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewSpellCastAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewSpellCastAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewAutoCastOverlay = {
									order = 15,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewAutoCastOverlay'],
									desc = L['BLStyle0UseNewAutoCastOverlayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewAutoCastOverlay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewAutoCastOverlay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewCooldownFlash = {
									order = 16,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCooldownFlash'],
									desc = L['BLStyle0UseNewCooldownFlashDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewCooldownFlash end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewCooldownFlash = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0HideCooldownBlingAnim = {
									order = 17,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0HideCooldownBlingAnim'],
									desc = L['BLStyle0HideCooldownBlingAnimDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0HideCooldownBlingAnim end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0HideCooldownBlingAnim = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								},
								BLStyle0UseNewChargeCooldownEdgeTexture = {
									order = 18,
									disabled = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewChargeCooldownEdgeTexture'],
									desc = L['BLStyle0UseNewChargeCooldownEdgeTextureDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewChargeCooldownEdgeTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MainMenuBar.BLStyle0UseNewChargeCooldownEdgeTexture = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[0]=true})
										end
									end
								}
							}
						},
						Spacer2 = {
							type = "description",
							order = 7,
							name = ""
						},
						Header3 = {
							type = 'header',
							order = 8,
							name = L['BagsIcons']
						},
						iconBorderAlphaBags = {
							order = 9,
							type = "range",
							softMin = 0,
							softMax = 1,
							min = 0,
							max = 1,
							step = 0.01,
							bigStep = 0.02,
							name = L['IconBorder Alpha'],
							desc = string.gsub(L['IconBorderAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.BagsIcons.iconBorderAlpha, 1),
							get = function() return ClassicUI.db.profile.barsConfig.BagsIcons.iconBorderAlpha end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.BagsIcons.iconBorderAlpha = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:ReloadMainFramesSettings()
								end
							end
						},
						xOffsetReagentBag = {
							order = 10,
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
							order = 11,
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
							order = 12,
							name = ""
						},
						Header4 = {
							type = 'header',
							order = 13,
							name = L['SpellFlyoutButtons']
						},
						ActionButtonsLayoutGroup2 = {
							order = 14,
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
										[1] = L['Modern Layout']
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = function()
										if (ClassicUI.db ~= nil) then
											if (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle == 1) then
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.SpellFlyoutButtons.BLStyle1NormalTextureAlpha, 1)
											else
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.SpellFlyoutButtons.BLStyle0NormalTextureAlpha, 1)
											end
										else
											return L['NormalTexture Alpha']
										end
									end,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewSpellActivationAlert = {
									order = 11,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellActivationAlert'],
									desc = L['BLStyle0UseNewSpellActivationAlertDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewSpellActivationAlert end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewSpellActivationAlert = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewTargetReticleAnimFrame = {
									order = 12,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewTargetReticleAnimFrame'],
									desc = L['BLStyle0UseNewTargetReticleAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewTargetReticleAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewTargetReticleAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewInterruptDisplay = {
									order = 13,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewInterruptDisplay'],
									desc = L['BLStyle0UseNewInterruptDisplayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewInterruptDisplay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewInterruptDisplay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewSpellCastAnimFrame = {
									order = 14,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellCastAnimFrame'],
									desc = L['BLStyle0UseNewSpellCastAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewSpellCastAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewSpellCastAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewAutoCastOverlay = {
									order = 15,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewAutoCastOverlay'],
									desc = L['BLStyle0UseNewAutoCastOverlayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewAutoCastOverlay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewAutoCastOverlay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewCooldownFlash = {
									order = 16,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCooldownFlash'],
									desc = L['BLStyle0UseNewCooldownFlashDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewCooldownFlash end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewCooldownFlash = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0HideCooldownBlingAnim = {
									order = 17,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0HideCooldownBlingAnim'],
									desc = L['BLStyle0HideCooldownBlingAnimDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0HideCooldownBlingAnim end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0HideCooldownBlingAnim = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[6]=true})
										end
									end
								},
								BLStyle0UseNewChargeCooldownEdgeTexture = {
									order = 18,
									disabled = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewChargeCooldownEdgeTexture'],
									desc = L['BLStyle0UseNewChargeCooldownEdgeTextureDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewChargeCooldownEdgeTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.SpellFlyoutButtons.BLStyle0UseNewChargeCooldownEdgeTexture = value
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
					order = 8,
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
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.OverrideActionBar.scale, 1),
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
										[1] = L['Modern Layout']
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = function()
										if (ClassicUI.db ~= nil) then
											if (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle == 1) then
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.OverrideActionBar.BLStyle1NormalTextureAlpha, 1)
											else
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.OverrideActionBar.BLStyle0NormalTextureAlpha, 1)
											end
										else
											return L['NormalTexture Alpha']
										end
									end,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewSpellActivationAlert = {
									order = 11,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellActivationAlert'],
									desc = L['BLStyle0UseNewSpellActivationAlertDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewSpellActivationAlert end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewSpellActivationAlert = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewTargetReticleAnimFrame = {
									order = 12,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewTargetReticleAnimFrame'],
									desc = L['BLStyle0UseNewTargetReticleAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewTargetReticleAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewTargetReticleAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewInterruptDisplay = {
									order = 13,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewInterruptDisplay'],
									desc = L['BLStyle0UseNewInterruptDisplayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewInterruptDisplay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewInterruptDisplay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewSpellCastAnimFrame = {
									order = 14,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellCastAnimFrame'],
									desc = L['BLStyle0UseNewSpellCastAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewSpellCastAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewSpellCastAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewAutoCastOverlay = {
									order = 15,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewAutoCastOverlay'],
									desc = L['BLStyle0UseNewAutoCastOverlayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewAutoCastOverlay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewAutoCastOverlay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewCooldownFlash = {
									order = 16,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCooldownFlash'],
									desc = L['BLStyle0UseNewCooldownFlashDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewCooldownFlash end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewCooldownFlash = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0HideCooldownBlingAnim = {
									order = 17,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0HideCooldownBlingAnim'],
									desc = L['BLStyle0HideCooldownBlingAnimDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0HideCooldownBlingAnim end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0HideCooldownBlingAnim = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[7]=true})
										end
									end
								},
								BLStyle0UseNewChargeCooldownEdgeTexture = {
									order = 18,
									disabled = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewChargeCooldownEdgeTexture'],
									desc = L['BLStyle0UseNewChargeCooldownEdgeTextureDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewChargeCooldownEdgeTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.OverrideActionBar.BLStyle0UseNewChargeCooldownEdgeTexture = value
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
					order = 9,
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
							min = 0,
							max = 1,
							step = 0.01,
							bigStep = 0.02,
							name = L['Alpha'],
							desc = string.gsub(L['AlphaDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.LeftGargoyleFrame.alpha, 1),
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
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.LeftGargoyleFrame.scale, 1),
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
							min = 0,
							max = 1,
							step = 0.01,
							bigStep = 0.02,
							name = L['Alpha'],
							desc = string.gsub(L['AlphaDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.RightGargoyleFrame.alpha, 1),
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
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.RightGargoyleFrame.scale, 1),
							get = function() return ClassicUI.db.profile.barsConfig.RightGargoyleFrame.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.RightGargoyleFrame.scale = value
								if (ClassicUI:IsEnabled()) then
									CUI_MainMenuBarRightEndCap:SetScale(value)
								end
							end
						}
					}
				},
				MicroButtonsOptions = {
					order = 10,
					type = "group",
					name = L['MicroButtons'],
					desc = L['MicroButtons'],
					childGroups = "tree",
					args = {
						Header1 = {
							type = 'header',
							order = 1,
							name = L['MicroButtons']
						},
						xOffsetMicroButtons = {
							order = 2,
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
							order = 3,
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
							order = 4,
							type = "range",
							min = 0.01,
							softMin = 0.01,
							softMax = 4,
							step = 0.01,
							bigStep = 0.03,
							name = L['Scale'],
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.scale, 1),
							get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.scale end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MicroButtons.scale = value
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
						maxMicroButtonsShown = {
							order = 6,
							type = "range",
							min = 0,
							softMin = 0,
							softMax = 13,
							step = 1,
							bigStep = 1,
							name = L['maxMicroButtonsShown'],
							desc = string.gsub(L['maxMicroButtonsShownDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.maxMicroButtonsShown, 1),
							get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI.SetOrderInfoMicroButtons()
									ClassicUI.SetPointsMicroButtons()
								end
							end
						},
						Spacer2 = {
							type = "description",
							order = 7,
							name = "",
							width = 0.55
						},
						helpOpenWebTicketButtonAnchor = {
							order = 8,
							type = "select",
							style = "dropdown",
							name = L['helpOpenWebTicketButtonAnchor'],
							desc = L['helpOpenWebTicketButtonAnchorDesc'],
							width = 1.45,
							sorting = function()
								return {
									[ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.order] = 'CharacterMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.order] = 'ProfessionMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.order] = 'PlayerSpellsMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.order] = 'AchievementMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.order] = 'QuestLogMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.order] = 'HousingMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.order] = 'GuildMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.order] = 'LFDMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.order] = 'CollectionsMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.order] = 'EJMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.order] = 'HelpMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.order] = 'StoreMicroButton',
									[ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.order] = 'MainMenuMicroButton'
								}
							end,
							values = {
								['CharacterMicroButton'] = L['CharacterMicroButton'],
								['ProfessionMicroButton'] = L['ProfessionMicroButton'],
								['PlayerSpellsMicroButton'] = L['PlayerSpellsMicroButton'],
								['AchievementMicroButton'] = L['AchievementMicroButton'],
								['QuestLogMicroButton'] = L['QuestLogMicroButton'],
								['HousingMicroButton'] = L['HousingMicroButton'],
								['GuildMicroButton'] = L['GuildMicroButton'],
								['LFDMicroButton'] = L['LFDMicroButton'],
								['CollectionsMicroButton'] = L['CollectionsMicroButton'],
								['EJMicroButton'] = L['EJMicroButton'],
								['HelpMicroButton'] = L['HelpMicroButton'],
								['StoreMicroButton'] = L['StoreMicroButton'],
								['MainMenuMicroButton'] = L['Default - MainMenuMicroButton']
							},
							get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.helpOpenWebTicketButtonAnchor end,
							set = function(_,value)
								if (ClassicUI.db.profile.barsConfig.MicroButtons.helpOpenWebTicketButtonAnchor ~= value) then
									ClassicUI.db.profile.barsConfig.MicroButtons.helpOpenWebTicketButtonAnchor = value
									if (ClassicUI:IsEnabled()) then
										if (HelpOpenWebTicketButton ~= nil) then
											HelpOpenWebTicketButton:SetParent(_G[ClassicUI.db.profile.barsConfig.MicroButtons.helpOpenWebTicketButtonAnchor] or MainMenuMicroButton)
											HelpOpenWebTicketButton:ClearAllPoints()
											HelpOpenWebTicketButton:SetPoint("CENTER", HelpOpenWebTicketButton:GetParent(), "TOPRIGHT", -3, -4)
										end
										if (ClassicUI.showingTempWebTicketButton or (not(ClassicUI.showingTempWebTicketButton) and not(HelpOpenWebTicketButton:IsShown()))) then
											HelpOpenWebTicketButton:Show()
											ClassicUI.showingTempWebTicketButton = GetTime() + 1.9
											C_Timer.After(2, function()
												if (GetTime() > ClassicUI.showingTempWebTicketButton) then
													HelpOpenWebTicketButton:Hide()
													ClassicUI.showingTempWebTicketButton = nil
												end
											end)
										end
									end
								end
							end
						},
						Spacer3 = {
							type = "description",
							order = 9,
							name = ""
						},
						CharacterMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['Character'] end,
							desc = L['CharacterMicroButton'],
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("CharacterMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("CharacterMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("CharacterMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("CharacterMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['CharacterMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.hideMicroButton) then
												CharacterMicroButton:Hide()
											else
												if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[CharacterMicroButton]) then
													CharacterMicroButton:Show()
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_CharacterMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												CharacterMicroButton:Disable()
											else
												local enable = true
												if ( StoreFrame and StoreFrame_IsShown() ) or ( ( GameMenuFrame and GameMenuFrame:IsShown() ) or ( SettingsPanel:IsShown() ) or Kiosk.IsEnabled() ) then
													enable = false
												end
												if (enable) then
													CharacterMicroButton:Enable()
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.disableMouseMicroButton) then
												CharacterMicroButton:EnableMouse(false)
											else
												CharacterMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								xOffsetMicroButton = {
									order = 20,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 21,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 22,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.CharacterMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_CharacterMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.CharacterMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													CharacterMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													CharacterMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_CharacterMicroButton_OnEnableOnDisable = true
												end
											end
											if (CharacterMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(CharacterMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(CharacterMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 23,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 0, 1, 16, 27, 28, 29, 30, 15, 2, 3, 4, 5, 26, 6, 32, 9, 24, 10, 11, 12, 13, 17, 18, 19, 20, 31 },
									values = {
										[0] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Character Portrait']..L['Character Portrait [*][D]'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.CharacterMicroButton.iconMicroButton = value
											if (ClassicUI:IsEnabled()) then
												CharacterMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
												CharacterMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
												CharacterMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
												if (value == 0) then	-- Character Portrait
													CharacterMicroButton.Portrait:Show()
												else
													CharacterMicroButton.Portrait:Hide()
												end
											end
										end
									end
								}
							}
						},
						ProfessionMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['Profession'] end,
							desc = L['ProfessionMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("ProfessionMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("ProfessionMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("ProfessionMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("ProfessionMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['ProfessionMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.hideMicroButton) then
												ProfessionMicroButton:Hide()
											else
												if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[ProfessionMicroButton]) then
													ProfessionMicroButton:Show()
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_ProfessionMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												ProfessionMicroButton:Disable()
											else
												local enable = true
												if ( StoreFrame and StoreFrame_IsShown() ) or ( ( GameMenuFrame and GameMenuFrame:IsShown() ) or ( SettingsPanel:IsShown() ) or Kiosk.IsEnabled() ) then
													enable = false
												end
												if (enable) then
													ProfessionMicroButton:Enable()
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.disableMouseMicroButton) then
												ProfessionMicroButton:EnableMouse(false)
											else
												ProfessionMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								xOffsetMicroButton = {
									order = 20,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 21,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 22,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.ProfessionMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_ProfessionMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.ProfessionMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													ProfessionMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													ProfessionMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_ProfessionMicroButton_OnEnableOnDisable = true
												end
											end
											if (ProfessionMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(ProfessionMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(ProfessionMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 23,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 4, 2, 15, 16, 17, 18, 19, 11, 3, 12, 1, 5, 26, 6, 32, 9, 24, 10, 13, 20, 27, 28, 29, 30, 31 },
									values = {
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon [D]'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.ProfessionMicroButton.iconMicroButton = value
											if (ClassicUI:IsEnabled()) then
												ProfessionMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
												ProfessionMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
												ProfessionMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
											end
										end
									end
								}
							}
						},
						PlayerSpellsMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['PlayerSpells'] end,
							desc = L['PlayerSpellsMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("PlayerSpellsMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("PlayerSpellsMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("PlayerSpellsMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("PlayerSpellsMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['PlayerSpellsMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.hideMicroButton) then
												PlayerSpellsMicroButton:Hide()
											else
												if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[PlayerSpellsMicroButton]) then
													PlayerSpellsMicroButton:Show()
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												PlayerSpellsMicroButton:Disable()
											else
												local enable = true
												if ( StoreFrame and StoreFrame_IsShown() ) or ( ( GameMenuFrame and GameMenuFrame:IsShown() ) or ( SettingsPanel:IsShown() ) or Kiosk.IsEnabled() ) then
													enable = false
												end
												if (enable) then
													PlayerSpellsMicroButton:Enable()
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.disableMouseMicroButton) then
												PlayerSpellsMicroButton:EnableMouse(false)
											else
												PlayerSpellsMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								xOffsetMicroButton = {
									order = 20,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 21,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 22,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_PlayerSpellsMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													PlayerSpellsMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													PlayerSpellsMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_PlayerSpellsMicroButton_OnEnableOnDisable = true
												end
											end
											if (PlayerSpellsMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(PlayerSpellsMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(PlayerSpellsMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 23,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 23, 21, 22, 3, 2, 15, 16, 11, 1, 27, 28, 29, 30, 4, 17, 18, 19, 12, 5, 26, 6, 32, 9, 24, 10, 13, 20, 31 },
									values = {
										[23] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SB/T Variable Icon']..L['SB/T Variable Icon [*][D]'],
										[21] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook/Talents Icon']..L['SpellBook/Talents Icon'],
										[22] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents/SpellBook Icon']..L['Talents/SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.PlayerSpellsMicroButton.iconMicroButton = value
											ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton = value
											if (value == 23) then	-- SB/T Variable Icon
												ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_normalTextureSB = ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTextureSB
												ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_pushedTextureSB = ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTextureSB
												ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_disabledTextureSB = ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTextureSB
												ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_normalTextureTT = ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTextureTT
												ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_pushedTextureTT = ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTextureTT
												ClassicUI.cached_db_profile.barsConfig_MicroButtons_PlayerSpellsMicroButton_iconMicroButton_disabledTextureTT = ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTextureTT
											end
											if (ClassicUI:IsEnabled()) then
												if (value == 23) then	-- SB/T Variable Icon
													if (PlayerSpellsFrame ~= nil and PlayerSpellsUtil ~= nil) then
														if (PlayerSpellsFrame.frameTabsToTabID[PlayerSpellsUtil.FrameTabs.SpellBook] == PlayerSpellsFrame.internalTabTracker.tabID) then
															PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTextureSB)
															PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTextureSB)
															PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTextureSB)
														else
															PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTextureTT)
															PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTextureTT)
															PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTextureTT)
														end
														if (ClassicUI.HookPlayerSpellsFrame_Tabs ~= nil) then
															ClassicUI.HookPlayerSpellsFrame_Tabs()
														end
													else
														PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
														PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
														PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
													end
												else
													PlayerSpellsMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
													PlayerSpellsMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
													PlayerSpellsMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
												end
											end
										end
									end
								}
							}
						},
						AchievementMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['Achievement'] end,
							desc = L['AchievementMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("AchievementMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("AchievementMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("AchievementMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("AchievementMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['AchievementMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.hideMicroButton) then
												AchievementMicroButton:Hide()
											else
												if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[AchievementMicroButton]) then
													AchievementMicroButton:Show()
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_AchievementMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												if not(ClassicUI.hooked_AchievementMicroButton_UpdateMicroButton) then
													hooksecurefunc(AchievementMicroButton, "UpdateMicroButton", ClassicUI.hook_AchievementMicroButton_UpdateMicroButton)
													ClassicUI.hooked_AchievementMicroButton_UpdateMicroButton = true
												end
												AchievementMicroButton:Disable()
											else
												local enable = true
												if ( StoreFrame and StoreFrame_IsShown() ) or ( ( GameMenuFrame and GameMenuFrame:IsShown() ) or ( SettingsPanel:IsShown() ) or Kiosk.IsEnabled() ) then
													enable = false
												else
													if (not( AchievementFrame and AchievementFrame:IsShown() ) and not( ( HasCompletedAnyAchievement() or IsInGuild() ) and CanShowAchievementUI() )) then
														enable = false
													end
												end
												if (enable) then
													AchievementMicroButton:Enable()
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.disableMouseMicroButton) then
												AchievementMicroButton:EnableMouse(false)
											else
												AchievementMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								xOffsetMicroButton = {
									order = 20,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 21,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 22,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.AchievementMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_AchievementMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.AchievementMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													AchievementMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													AchievementMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_AchievementMicroButton_OnEnableOnDisable = true
												end
											end
											if (AchievementMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(AchievementMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(AchievementMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 23,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 5, 26, 15, 16, 17, 4, 1, 18, 19, 11, 2, 3, 12, 6, 32, 9, 24, 10, 13, 20, 27, 28, 29, 30, 31 },
									values = {
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon [D]'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.AchievementMicroButton.iconMicroButton = value
											if (ClassicUI:IsEnabled()) then
												AchievementMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
												AchievementMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
												AchievementMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
											end
										end
									end
								}
							}
						},
						QuestLogMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['QuestLog'] end,
							desc = L['QuestLogMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("QuestLogMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("QuestLogMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("QuestLogMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("QuestLogMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['QuestLogMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.hideMicroButton) then
												QuestLogMicroButton:Hide()
											else
												if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[QuestLogMicroButton]) then
													QuestLogMicroButton:Show()
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_QuestLogMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												QuestLogMicroButton:Disable()
											else
												local enable = true
												if ( StoreFrame and StoreFrame_IsShown() ) or ( ( GameMenuFrame and GameMenuFrame:IsShown() ) or ( SettingsPanel:IsShown() ) or Kiosk.IsEnabled() ) then
													enable = false
												end
												if (enable) then
													QuestLogMicroButton:Enable()
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.disableMouseMicroButton) then
												QuestLogMicroButton:EnableMouse(false)
											else
												QuestLogMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								xOffsetMicroButton = {
									order = 20,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 21,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 22,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.QuestLogMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_QuestLogMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.QuestLogMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													QuestLogMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													QuestLogMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_QuestLogMicroButton_OnEnableOnDisable = true
												end
											end
											if (QuestLogMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(QuestLogMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(QuestLogMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 23,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 6, 18, 15, 16, 17, 19, 1, 4, 11, 2, 3, 12, 5, 26, 32, 9, 24, 10, 13, 20, 27, 28, 29, 30, 31 },
									values = {
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon [D]'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.QuestLogMicroButton.iconMicroButton = value
											if (ClassicUI:IsEnabled()) then
												QuestLogMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
												QuestLogMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
												QuestLogMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
											end
										end
									end
								}
							}
						},
						HousingMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['Housing'] end,
							desc = L['HousingMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("HousingMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("HousingMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("HousingMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("HousingMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['HousingMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.hideMicroButton) then
												HousingMicroButton:Hide()
											else
												if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[HousingMicroButton]) then
													HousingMicroButton:Show()
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_HousingMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												HousingMicroButton:Disable()
											else
												local enable = true
												if ( StoreFrame and StoreFrame_IsShown() ) or ( ( GameMenuFrame and GameMenuFrame:IsShown() ) or ( SettingsPanel:IsShown() ) or Kiosk.IsEnabled() ) then
													enable = false
												else
													if ( PlayerIsTimerunning() ) then
														enable = false
													end
												end
												if (enable) then
													HousingMicroButton:Enable()
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.disableMouseMicroButton) then
												HousingMicroButton:EnableMouse(false)
											else
												HousingMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								classicNotificationMicroButton = {
									order = 20,
									type = "toggle",
									name = L['classicNotificationMicroButton'],
									desc = L['classicNotificationMicroButtonDesc'],
									width = "double",
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.classicNotificationMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.classicNotificationMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_HousingMicroButton_classicNotificationMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (value) then
												if not(ClassicUI.hooked_HousingMicroButton_HousingTutorialsNewPipMixin_Init) then
													hooksecurefunc(HousingTutorialsNewPipMixin, "Init", ClassicUI.hook_HousingMicroButton_HousingTutorialsNewPipMixin_Init)
													ClassicUI.hooked_HousingMicroButton_HousingTutorialsNewPipMixin_Init = true
												end
												if not(ClassicUI.hooked_HousingMicroButton_HousingTutorialsNewPipMixin_OnHousingDashboardToggled) then
													hooksecurefunc(HousingTutorialsNewPipMixin, "OnHousingDashboardToggled", ClassicUI.hook_HousingMicroButton_HousingTutorialsNewPipMixin_OnHousingDashboardToggled)
													ClassicUI.hooked_HousingMicroButton_HousingTutorialsNewPipMixin_OnHousingDashboardToggled = true
												end
												HousingMicroButton.CUI_NotificationOverlay:SetAlpha(1)
												HousingMicroButton.CUI_NotificationOverlay:SetShown(HousingMicroButton.NotificationOverlay:IsShown())
												HousingMicroButton.NotificationOverlay:SetAlpha(0)
												HousingMicroButton.NotificationOverlay:Hide()
												if (ClassicUI.showingTempHousingNotification or (not(ClassicUI.showingTempHousingNotification) and not(HousingMicroButton.CUI_NotificationOverlay:IsShown()))) then
													HousingMicroButton.CUI_NotificationOverlay:Show()
													ClassicUI.showingTempHousingNotification = GetTime() + 1.9
													C_Timer.After(2, function()
														if (GetTime() > ClassicUI.showingTempHousingNotification) then
															HousingMicroButton.CUI_NotificationOverlay:Hide()
															ClassicUI.showingTempHousingNotification = nil
														end
													end)
												end
											else
												HousingMicroButton.NotificationOverlay:SetAlpha(1)
												HousingMicroButton.NotificationOverlay:SetShown(HousingMicroButton.CUI_NotificationOverlay:IsShown())
												HousingMicroButton.CUI_NotificationOverlay:SetAlpha(0)
												HousingMicroButton.CUI_NotificationOverlay:Hide()
												if (ClassicUI.showingTempHousingNotification or (not(ClassicUI.showingTempHousingNotification) and not(HousingMicroButton.NotificationOverlay:IsShown()))) then
													HousingMicroButton.NotificationOverlay:Show()
													ClassicUI.showingTempHousingNotification = GetTime() + 1.9
													C_Timer.After(2, function()
														if (GetTime() > ClassicUI.showingTempHousingNotification) then
															HousingMicroButton.NotificationOverlay:Hide()
															ClassicUI.showingTempHousingNotification = nil
														end
													end)
												end
											end
										end
									end,
								},
								xOffsetMicroButton = {
									order = 21,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 22,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 23,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.HousingMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_HousingMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.HousingMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													HousingMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													HousingMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_HousingMicroButton_OnEnableOnDisable = true
												end
											end
											if (HousingMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(HousingMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(HousingMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 24,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 32, 17, 15, 16, 18, 19, 1, 4, 11, 2, 3, 12, 5, 26, 6, 9, 24, 10, 13, 20, 27, 28, 29, 30, 31 },
									values = {
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon [D]'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.iconMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HousingMicroButton.iconMicroButton = value
										if (ClassicUI:IsEnabled()) then
											HousingMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
											HousingMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
											HousingMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
										end
									end
								}
							}
						},
						GuildMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['Guild'] end,
							desc = L['GuildMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("GuildMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("GuildMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("GuildMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("GuildMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['GuildMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.hideMicroButton) then
												GuildMicroButton:Hide()
											else
												if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[GuildMicroButton]) then
													GuildMicroButton:Show()
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												GuildMicroButton:Disable()
											else
												local enable = true
												if ( StoreFrame and StoreFrame_IsShown() ) or ( ( GameMenuFrame and GameMenuFrame:IsShown() ) or ( SettingsPanel:IsShown() ) or Kiosk.IsEnabled() ) then
													enable = false
												else
													if IsCommunitiesUIDisabledByTrialAccount() or UnitFactionGroup("player") == "Neutral" or (C_Club.IsEnabled() and ((not BNConnected()) or (C_Club.IsRestricted() ~= Enum.ClubRestrictionReason.None))) then
														enable = false
													end
												end
												if (enable) then
													GuildMicroButton:Enable()
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.disableMouseMicroButton) then
												GuildMicroButton:EnableMouse(false)
											else
												GuildMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								classicNotificationMicroButton = {
									order = 20,
									type = "toggle",
									name = L['classicNotificationMicroButton'],
									desc = L['classicNotificationMicroButtonDesc'],
									width = "double",
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.classicNotificationMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.classicNotificationMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_classicNotificationMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (value) then
												if not(ClassicUI.hooked_GuildMicroButton_UpdateNotificationIcon) then
													hooksecurefunc(GuildMicroButton, "UpdateNotificationIcon", ClassicUI.hook_GuildMicroButton_UpdateNotificationIcon)
													ClassicUI.hooked_GuildMicroButton_UpdateNotificationIcon = true
												end
												GuildMicroButton.CUI_NotificationOverlay:SetAlpha(1)
												GuildMicroButton.CUI_NotificationOverlay:SetShown(GuildMicroButton.NotificationOverlay:IsShown())
												GuildMicroButton.NotificationOverlay:SetAlpha(0)
												GuildMicroButton.NotificationOverlay:Hide()
												if (ClassicUI.showingTempGuildNotification or (not(ClassicUI.showingTempGuildNotification) and not(GuildMicroButton.CUI_NotificationOverlay:IsShown()))) then
													GuildMicroButton.CUI_NotificationOverlay:Show()
													ClassicUI.showingTempGuildNotification = GetTime() + 1.9
													C_Timer.After(2, function()
														if (GetTime() > ClassicUI.showingTempGuildNotification) then
															GuildMicroButton.CUI_NotificationOverlay:Hide()
															ClassicUI.showingTempGuildNotification = nil
														end
													end)
												end
											else
												GuildMicroButton.NotificationOverlay:SetAlpha(1)
												GuildMicroButton.NotificationOverlay:SetShown(GuildMicroButton.CUI_NotificationOverlay:IsShown())
												GuildMicroButton.CUI_NotificationOverlay:SetAlpha(0)
												GuildMicroButton.CUI_NotificationOverlay:Hide()
												if (ClassicUI.showingTempGuildNotification or (not(ClassicUI.showingTempGuildNotification) and not(GuildMicroButton.NotificationOverlay:IsShown()))) then
													GuildMicroButton.NotificationOverlay:Show()
													ClassicUI.showingTempGuildNotification = GetTime() + 1.9
													C_Timer.After(2, function()
														if (GetTime() > ClassicUI.showingTempGuildNotification) then
															GuildMicroButton.NotificationOverlay:Hide()
															ClassicUI.showingTempGuildNotification = nil
														end
													end)
												end
											end
										end
									end,
								},
								goToGuildPanelOptionsPanel = {
									order = 21,
									type = "execute",
									name = L['goToGuildPanelOptionsPanel'],
									desc = L['goToGuildPanelOptionsPanelDesc'],
									width = 1.75,
									func = function()
										local openErr = false
										local aceTab
										ClassicUI:ShowConfig(2)
										for i = 1, 20 do
											for j = 1, 20 do
												local aceTabIt = _G['AceGUITabGroup'..i..'Tab'..j]
												if (aceTabIt ~= nil and type(aceTabIt.GetText) == "function" and aceTabIt:GetText() == L['Guild Panel Mode']) then
													aceTab = aceTabIt
													break
												end
											end
											if (aceTab ~= nil) then
												break
											end
										end
										if (aceTab ~= nil) then
											aceTab:Click()
											if not(ClassicUI.optionsFrames.extraOptions:IsShown()) then
												openErr = true
											end
										else
											openErr = true
										end
										if (openErr) then
											message(L['goToGuildPanelOptionsPanelErr']..' \''..L['ClassicUI']..'\' => \''..L['Extra Options']..'\' => \''..L['Guild Panel Mode']..'\'')
										end
									end
								},
								xOffsetMicroButton = {
									order = 22,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 23,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 24,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.GuildMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_GuildMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.GuildMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													GuildMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													GuildMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_GuildMicroButton_OnEnableOnDisable = true
												end
											end
											if (GuildMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(GuildMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(GuildMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 25,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 7, 8, 19, 15, 16, 17, 18, 1, 4, 11, 2, 3, 12, 5, 26, 6, 32, 9, 24, 10, 13, 20, 27, 28, 29, 30, 31, 32 },
									values = {
										[7] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Guild Emblem']..L['Guild Emblem [*][D]'],
										[8] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bigger Guild Emblem']..L['Bigger Guild Emblem [*]'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.GuildMicroButton.iconMicroButton = value
											ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton = value
											ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_normalTexture = ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture
											ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_pushedTexture = ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture
											ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_disabledTexture = ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture
											if (value == 7 or value == 8) then	-- Guild Emblem / Bigger Guild Emblem
												ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_normalTextureGuild = ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTextureGuild
												ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_pushedTextureGuild = ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTextureGuild
												ClassicUI.cached_db_profile.barsConfig_MicroButtons_GuildMicroButton_iconMicroButton_disabledTextureGuild = ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTextureGuild
											end
											if (ClassicUI:IsEnabled()) then
												GuildMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
												GuildMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
												GuildMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
												local tabard = GuildMicroButtonTabard
												if (value == 7 or value == 8) then	-- Guild Emblem / Bigger Guild Emblem
													local emblemFilename = select(10, GetGuildLogoInfo())
													if (emblemFilename) then
														GuildMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTextureGuild)
														GuildMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTextureGuild)
														if (not tabard:IsShown()) then
															tabard:Show()
														end
														SetSmallGuildTabardTextures("player", tabard.emblem, tabard.background)
													else
														GuildMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
														GuildMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
														if (tabard:IsShown()) then
															tabard:Hide()
														end
													end
													if IsInGuild() then
														GuildMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTextureGuild)
													else
														GuildMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
													end
													GuildMicroButtonTabardEmblem:SetAlpha(1)
													GuildMicroButtonTabardEmblem:Show()
													GuildMicroButtonTabardBackground:SetAlpha(1)
													GuildMicroButtonTabardBackground:Show()
													GuildMicroButtonTabard:SetAlpha(1)
												else
													GuildMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
													GuildMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
													GuildMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
													GuildMicroButtonTabardEmblem:SetAlpha(0)
													GuildMicroButtonTabardEmblem:Hide()
													GuildMicroButtonTabardBackground:SetAlpha(0)
													GuildMicroButtonTabardBackground:Hide()
													tabard:SetAlpha(0)
													tabard:Hide()
												end
												if (value ~= 8) then	-- Bigger Guild Emblem
													GuildMicroButtonTabardEmblem:SetSize(14, 14)
												else
													GuildMicroButtonTabardEmblem:SetSize(16, 16)
												end
												ClassicUI.GuildMicroButton_UpdateTabard(true)
											end
										end
									end
								}
							}
						},
						LFDMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['LFD'] end,
							desc = L['LFDMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("LFDMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("LFDMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("LFDMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("LFDMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['LFDMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.hideMicroButton) then
												LFDMicroButton:Hide()
											else
												if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[LFDMicroButton]) then
													LFDMicroButton:Show()
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_LFDMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												if not(ClassicUI.hooked_LFDMicroButton_UpdateMicroButton) then
													hooksecurefunc(LFDMicroButton, "UpdateMicroButton", ClassicUI.hook_LFDMicroButton_UpdateMicroButton)
													ClassicUI.hooked_LFDMicroButton_UpdateMicroButton = true
												end
												LFDMicroButton:Disable()
											else
												local enable = true
												if ( StoreFrame and StoreFrame_IsShown() ) or ( ( GameMenuFrame and GameMenuFrame:IsShown() ) or ( SettingsPanel:IsShown() ) or Kiosk.IsEnabled() ) then
													enable = false
												else
													if not( PVEFrame and PVEFrame:IsShown() ) and ( not LFDMicroButton:IsActive() ) then
														enable = false
													end
												end
												if (enable) then
													LFDMicroButton:Enable()
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.disableMouseMicroButton) then
												LFDMicroButton:EnableMouse(false)
											else
												LFDMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								xOffsetMicroButton = {
									order = 20,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 21,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 22,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.LFDMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_LFDMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.LFDMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													LFDMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													LFDMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_LFDMicroButton_OnEnableOnDisable = true
												end
											end
											if (LFDMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(LFDMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(LFDMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 23,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 9, 24, 27, 28, 29, 30, 15, 4, 16, 17, 18, 19, 1, 11, 12, 2, 3, 5, 26, 6, 32, 10, 13, 20, 31 },
									values = {
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon [D]'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.LFDMicroButton.iconMicroButton = value
											if (ClassicUI:IsEnabled()) then
												LFDMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
												LFDMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
												LFDMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
											end
										end
									end
								}
							}
						},
						CollectionsMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['Collections'] end,
							desc = L['CollectionsMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("CollectionsMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("CollectionsMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("CollectionsMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("CollectionsMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['CollectionsMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.hideMicroButton) then
												CollectionsMicroButton:Hide()
											else
												if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[CollectionsMicroButton]) then
													CollectionsMicroButton:Show()
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_CollectionsMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												if not(ClassicUI.hooked_CollectionsMicroButton_UpdateMicroButton) then
													hooksecurefunc(CollectionsMicroButton, "UpdateMicroButton", ClassicUI.hook_CollectionsMicroButton_UpdateMicroButton)
													ClassicUI.hooked_CollectionsMicroButton_UpdateMicroButton = true
												end
												CollectionsMicroButton:Disable()
											else
												local enable = true
												if ( StoreFrame and StoreFrame_IsShown() ) or ( ( GameMenuFrame and GameMenuFrame:IsShown() ) or ( SettingsPanel:IsShown() ) or Kiosk.IsEnabled() ) then
													enable = false
												end
												if (enable) then
													CollectionsMicroButton:Enable()
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.disableMouseMicroButton) then
												CollectionsMicroButton:EnableMouse(false)
											else
												CollectionsMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								xOffsetMicroButton = {
									order = 20,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 21,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 22,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.CollectionsMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_CollectionsMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.CollectionsMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													CollectionsMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													CollectionsMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_CollectionsMicroButton_OnEnableOnDisable = true
												end
											end
											if (CollectionsMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(CollectionsMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(CollectionsMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 23,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 10, 15, 4, 16, 17, 18, 19, 1, 11, 2, 3, 12, 5, 26, 6, 32, 9, 24, 13, 20, 27, 28, 29, 30, 31 },
									values = {
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon [D]'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.CollectionsMicroButton.iconMicroButton = value
											if (ClassicUI:IsEnabled()) then
												CollectionsMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
												CollectionsMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
												CollectionsMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
											end
										end
									end
								}
							}
						},
						EJMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['EJ'] end,
							desc = L['EJMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("EJMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("EJMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("EJMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("EJMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['EJMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.hideMicroButton) then
												EJMicroButton:Hide()
											else
												if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[EJMicroButton]) then
													EJMicroButton:Show()
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_EJMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												if not(ClassicUI.hooked_EJMicroButton_UpdateMicroButton) then
													hooksecurefunc(EJMicroButton, "UpdateMicroButton", ClassicUI.hook_EJMicroButton_UpdateMicroButton)
													ClassicUI.hooked_EJMicroButton_UpdateMicroButton = true
												end
												EJMicroButton:Disable()
											else
												local enable = true
												if ( StoreFrame and StoreFrame_IsShown() ) or ( ( GameMenuFrame and GameMenuFrame:IsShown() ) or ( SettingsPanel:IsShown() ) or Kiosk.IsEnabled() ) then
													enable = false
												else
													if Kiosk.IsEnabled() or (not( EncounterJournal and EncounterJournal:IsShown() ) and ( not AdventureGuideUtil.IsAvailable() )) then
														enable = false
													end
												end
												if (enable) then
													EJMicroButton:Enable()
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.disableMouseMicroButton) then
												EJMicroButton:EnableMouse(false)
											else
												EJMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								classicNotificationMicroButton = {
									order = 20,
									type = "toggle",
									name = L['classicNotificationMicroButton'],
									desc = L['classicNotificationMicroButtonDesc'],
									width = "double",
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.classicNotificationMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.classicNotificationMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_EJMicroButton_classicNotificationMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (value) then
												if not(ClassicUI.hooked_EJMicroButton_UpdateNotificationIcon) then
													hooksecurefunc(EJMicroButton, "UpdateNotificationIcon", ClassicUI.hook_EJMicroButton_UpdateNotificationIcon)
													ClassicUI.hooked_EJMicroButton_UpdateNotificationIcon = true
												end
												EJMicroButton.CUI_NotificationOverlay:SetAlpha(1)
												EJMicroButton.CUI_NotificationOverlay:SetShown(EJMicroButton.NotificationOverlay:IsShown())
												EJMicroButton.NotificationOverlay:SetAlpha(0)
												EJMicroButton.NotificationOverlay:Hide()
												if (ClassicUI.showingTempEJNotification or (not(ClassicUI.showingTempEJNotification) and not(EJMicroButton.CUI_NotificationOverlay:IsShown()))) then
													EJMicroButton.CUI_NotificationOverlay:Show()
													ClassicUI.showingTempEJNotification = GetTime() + 1.9
													C_Timer.After(2, function()
														if (GetTime() > ClassicUI.showingTempEJNotification) then
															EJMicroButton.CUI_NotificationOverlay:Hide()
															ClassicUI.showingTempEJNotification = nil
														end
													end)
												end
											else
												EJMicroButton.NotificationOverlay:SetAlpha(1)
												EJMicroButton.NotificationOverlay:SetShown(EJMicroButton.CUI_NotificationOverlay:IsShown())
												EJMicroButton.CUI_NotificationOverlay:SetAlpha(0)
												EJMicroButton.CUI_NotificationOverlay:Hide()
												if (ClassicUI.showingTempEJNotification or (not(ClassicUI.showingTempEJNotification) and not(EJMicroButton.NotificationOverlay:IsShown()))) then
													EJMicroButton.NotificationOverlay:Show()
													ClassicUI.showingTempEJNotification = GetTime() + 1.9
													C_Timer.After(2, function()
														if (GetTime() > ClassicUI.showingTempEJNotification) then
															EJMicroButton.NotificationOverlay:Hide()
															ClassicUI.showingTempEJNotification = nil
														end
													end)
												end
											end
										end
									end,
								},
								xOffsetMicroButton = {
									order = 21,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 22,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 23,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.EJMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_EJMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.EJMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													EJMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													EJMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_EJMicroButton_OnEnableOnDisable = true
												end
											end
											if (EJMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(EJMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(EJMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 24,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 11, 16, 15, 17, 4, 18, 19, 1, 2, 3, 12, 5, 26, 6, 32, 9, 24, 10, 13, 20, 27, 28, 29, 30, 31 },
									values = {
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon [D]'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.EJMicroButton.iconMicroButton = value
											if (ClassicUI:IsEnabled()) then
												EJMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
												EJMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
												EJMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
											end
										end
									end
								}
							}
						},
						HelpMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['Help'] end,
							desc = L['HelpMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("HelpMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("HelpMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("HelpMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("HelpMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['HelpMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.hideMicroButton) then
												HelpMicroButton:Hide()
												-- keep the HelpMicroButton hidden
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.disableMicroButton) then
												HelpMicroButton:Disable()
												-- keep the HelpMicroButton disabled
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.disableMouseMicroButton) then
												HelpMicroButton:EnableMouse(false)
											else
												HelpMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								xOffsetMicroButton = {
									order = 20,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 21,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 22,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.HelpMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_HelpMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.HelpMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													HelpMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													HelpMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_HelpMicroButton_OnEnableOnDisable = true
												end
											end
											if (HelpMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(HelpMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(HelpMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 23,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 14, 20, 15, 4, 16, 17, 1, 18, 19, 2, 3, 12, 5, 26, 6, 32, 9, 24, 10, 11, 27, 28, 29, 30, 31 },
									values = {
										[14] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Help Icon']..L['Help Icon [D]'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.HelpMicroButton.iconMicroButton = value
											if (ClassicUI:IsEnabled()) then
												HelpMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
												HelpMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
												HelpMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
											end
										end
									end
								}
							}
						},
						StoreMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['Store'] end,
							desc = L['StoreMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("StoreMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("StoreMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("StoreMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("StoreMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['StoreMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.hideMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_StoreMicroButton_hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.hideMicroButton) then
												StoreMicroButton:Hide()
											else
												local show = true
												if not(C_StorePublic.IsDisabledByParentalControls()) and not(Kiosk.IsEnabled()) and
													((not C_StorePublic.IsEnabled() and GetCurrentRegionName() == "CN") or
													(C_StorePublic.IsEnabled() and C_PlayerInfo.IsPlayerNPERestricted() and (TutorialLogic and TutorialLogic.Tutorials) and (TutorialLogic and TutorialLogic.Tutorials).UI_Watcher and (TutorialLogic and TutorialLogic.Tutorials).UI_Watcher.IsActive)) then
													show = false
												end
												if (show) then
													if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[StoreMicroButton]) then
														StoreMicroButton:Show()
													end
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_StoreMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												StoreMicroButton:Disable()
											else
												local enable = true
												if Kiosk.IsEnabled() or ( C_StorePublic.IsDisabledByParentalControls() ) or ( not(C_StorePublic.IsEnabled()) and not( GetCurrentRegionName() == "CN" ) ) then
													enable = false
												end
												if (enable) then
													StoreMicroButton:Enable()
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.disableMouseMicroButton) then
												StoreMicroButton:EnableMouse(false)
											else
												StoreMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								xOffsetMicroButton = {
									order = 20,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 21,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 22,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.StoreMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_StoreMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.StoreMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													StoreMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													StoreMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_StoreMicroButton_OnEnableOnDisable = true
												end
											end
											if (StoreMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(StoreMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(StoreMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 23,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 12, 15, 16, 17, 4, 18, 19, 1, 27, 28, 29, 30, 2, 3, 5, 26, 6, 32, 9, 24, 10, 11, 13, 20, 31 },
									values = {
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon [D]'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.StoreMicroButton.iconMicroButton = value
											if (ClassicUI:IsEnabled()) then
												StoreMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
												StoreMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
												StoreMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
											end
										end
									end
								}
							}
						},
						MainMenuMicroButton = {
							order = function() return 9 + ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.order end,
							type = "group",
							name = function() return '|cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.order..'|r|cffeda55f] - |r'..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton].name],':32:24:',':20:15:',1)..' '..L['MainMenu'] end,
							desc = L['MainMenuMicroButton'],
							width = 4.0,
							args = {
								Header1 = {
									type = 'header',
									order = 1,
									name = L['MicroButtons Order']
								},
								orderValueText = {
									order = 2,
									type = "description",
									width = 0.20,
									name = function() return ' |cffeda55f[|r|cffff6720'..(ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.order < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.order..'|r|cffeda55f]|r' end
								},
								buttonOrderUp = {
									order = 3,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.order <= ClassicUI.MICROBUTTONS_MIN_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("MainMenuMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonOrderDown = {
									order = 4,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.order >= ClassicUI.MICROBUTTONS_MAX_ORDER end,
									width = 0.26,
									func = function()
										ClassicUI:ReorderMicroButtonsDB("MainMenuMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 5,
									name = "",
									width = 0.05
								},
								buttonOrderDefault = {
									order = 6,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsOrderDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultOrderDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsOrderDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:ReorderMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Header2 = {
									type = 'header',
									order = 7,
									name = L['MicroButtons Priority']
								},
								prioritySectionDesc = {
									order = 8,
									type = "description",
									name = L['MICROBUTTONS_PRIORITY_DESC']
								},
								priorityValueText = {
									order = 9,
									type = "description",
									width = 0.20,
									name = function() return ' |cffbad152[|r|cff62e632'..(ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.priority < 10 and '0' or '')..ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.priority..'|r|cffbad152]|r' end
								},
								buttonPriorityUp = {
									order = 10,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-u'..((ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['UP'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.priority <= ClassicUI.MICROBUTTONS_MIN_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("MainMenuMicroButton", "UP")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								buttonPriorityDown = {
									order = 11,
									type = "execute",
									name = function() return '|TInterface\\Addons\\ClassicUI\\Textures\\arrow-custom-1-d'..((ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY) and '-disabled' or '')..':0|t' end,
									desc = L['DOWN'],
									disabled = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.priority >= ClassicUI.MICROBUTTONS_MAX_PRIORITY end,
									width = 0.26,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB("MainMenuMicroButton", "DOWN")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								Spacer2 = {
									type = "description",
									order = 12,
									name = "",
									width = 0.05
								},
								buttonPriorityDefault = {
									order = 13,
									type = "execute",
									name = function() return '|T'..(ClassicUI:IsMicroButtonsPriorityDefaultDB() and 'Interface\\Addons\\ClassicUI\\Textures\\UI-RefreshButton-Disabled-custom' or '851904')..':0|t '..L['Default'] end,
									desc = L['DefaultPriorityDesc'],
									disabled = function() return ClassicUI:IsMicroButtonsPriorityDefaultDB() end,
									width = 0.72,
									func = function()
										ClassicUI:RepriorizeMicroButtonsDB(nil, "DEFAULT")
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								priorityIconList = {
									order = 14,
									type = "description",
									name = function()
										local prioOrderedArray = {}
										for k, v in pairs(ClassicUI.db.profile.barsConfig.MicroButtons) do
											if ((type(v) == 'table') and (type(v.priority) == 'number')) then
												table.insert(prioOrderedArray, { k, v.priority } )
											end
										end
										table.sort(prioOrderedArray, function(a, b) return a[2] < b[2] end)
										local str = ""
										local count = 0
										for _, v in ipairs(prioOrderedArray) do
											if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
												str = str.."I"
											end
											str = str..string.gsub(ClassicUI.MICROBUTTONS_OPTION_ICONS[ClassicUI.MICROBUTTONS_ARRAYINFO[ClassicUI.db.profile.barsConfig.MicroButtons[v[1]].iconMicroButton].name],':32:24:',':28:21:',1)
											count = count + 1
										end
										if (count == ClassicUI.db.profile.barsConfig.MicroButtons.maxMicroButtonsShown) then
											str = str.."I"
										end
										return str
									end
								},
								Header3 = {
									type = 'header',
									order = 15,
									name = L['MainMenuMicroButton']
								},
								hideMicroButton = {
									order = 16,
									type = "toggle",
									name = L['Hide MicroButton'],
									desc = L['Hide MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.hideMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.hideMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.hideMicroButton) then
												MainMenuMicroButton:Hide()
											else
												if not(ClassicUI.MicroButtonsGroupOrderInfo.forceHidden[MainMenuMicroButton]) then
													MainMenuMicroButton:Show()
												end
											end
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								keepGapMicroButton = {
									order = 17,
									type = "toggle",
									name = L['Keep MicroButton Gap'],
									desc = L['KeepMicroButtonGapDesc'],
									disabled = function() return not(ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.hideMicroButton) end,
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.keepGapMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.keepGapMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetOrderInfoMicroButtons()
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								disableMicroButton = {
									order = 18,
									type = "toggle",
									name = L['Disable MicroButton'],
									desc = L['Disable MicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.disableMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.disableMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_disableMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.disableMicroButton) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton) then
													hooksecurefunc(MainMenuMicroButton, "UpdateMicroButton", ClassicUI.hook_MainMenuMicroButton_UpdateMicroButton)
													ClassicUI.hooked_MainMenuMicroButton_UpdateMicroButton = true
												end
												MainMenuMicroButton:Disable()
												if (MainMenuMicroButton.MainMenuBarPerformanceBar2 ~= nil) then
													MainMenuMicroButton.MainMenuBarPerformanceBar2:SetPoint("TOPLEFT", MainMenuMicroButton, "TOPLEFT", 9.6, -13.5)
												end
											else
												local enable = true
												if ( StoreFrame and StoreFrame_IsShown() ) then
													enable = false
												end
												if (enable) then
													MainMenuMicroButton:Enable()
													if ( ( GameMenuFrame and GameMenuFrame:IsShown() )
														or ( SettingsPanel:IsShown())
														or ( KeyBindingFrame and KeyBindingFrame:IsShown())
														or ( MacroFrame and MacroFrame:IsShown()) ) then
														MainMenuMicroButton:SetPushed()
													end
												end
											end
										end
									end,
								},
								disableMouseMicroButton = {
									order = 19,
									type = "toggle",
									name = L['Disable Mouse'],
									desc = L['DisableMouseMicroButtonDesc'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.disableMouseMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.disableMouseMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.disableMouseMicroButton) then
												MainMenuMicroButton:EnableMouse(false)
											else
												MainMenuMicroButton:EnableMouse(true)
											end
										end
									end,
								},
								classicNotificationMicroButton = {
									order = 20,
									type = "toggle",
									name = L['classicNotificationMicroButton'],
									desc = L['classicNotificationMicroButtonDesc'],
									width = "double",
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.classicNotificationMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.classicNotificationMicroButton = value
										ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_classicNotificationMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if (value) then
												if not(ClassicUI.hooked_MainMenuMicroButton_UpdateNotificationIcon) then
													hooksecurefunc(MainMenuMicroButton, "UpdateNotificationIcon", ClassicUI.hook_MainMenuMicroButton_UpdateNotificationIcon)
													ClassicUI.hooked_MainMenuMicroButton_UpdateNotificationIcon = true
												end
												MainMenuMicroButton.CUI_NotificationOverlay:SetAlpha(1)
												MainMenuMicroButton.CUI_NotificationOverlay:SetShown(MainMenuMicroButton.NotificationOverlay:IsShown())
												MainMenuMicroButton.NotificationOverlay:SetAlpha(0)
												MainMenuMicroButton.NotificationOverlay:Hide()
												if (ClassicUI.showingTempMainMenuNotification or (not(ClassicUI.showingTempMainMenuNotification) and not(MainMenuMicroButton.CUI_NotificationOverlay:IsShown()))) then
													MainMenuMicroButton.CUI_NotificationOverlay:Show()
													ClassicUI.showingTempMainMenuNotification = GetTime() + 1.9
													C_Timer.After(2, function()
														if (GetTime() > ClassicUI.showingTempMainMenuNotification) then
															MainMenuMicroButton.CUI_NotificationOverlay:Hide()
															ClassicUI.showingTempMainMenuNotification = nil
														end
													end)
												end
											else
												MainMenuMicroButton.NotificationOverlay:SetAlpha(1)
												MainMenuMicroButton.NotificationOverlay:SetShown(MainMenuMicroButton.CUI_NotificationOverlay:IsShown())
												MainMenuMicroButton.CUI_NotificationOverlay:SetAlpha(0)
												MainMenuMicroButton.CUI_NotificationOverlay:Hide()
												if (ClassicUI.showingTempMainMenuNotification or (not(ClassicUI.showingTempMainMenuNotification) and not(MainMenuMicroButton.NotificationOverlay:IsShown()))) then
													MainMenuMicroButton.NotificationOverlay:Show()
													ClassicUI.showingTempMainMenuNotification = GetTime() + 1.9
													C_Timer.After(2, function()
														if (GetTime() > ClassicUI.showingTempMainMenuNotification) then
															MainMenuMicroButton.NotificationOverlay:Hide()
															ClassicUI.showingTempMainMenuNotification = nil
														end
													end)
												end
											end
										end
									end,
								},
								hideLatencyBar = {
									order = 21,
									type = "toggle",
									name = L['Hide Small Latency Bar'],
									desc = L['Hide Small Latency Bar'],
									width = "double",
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.hideLatencyBar end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.hideLatencyBar = value
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
								xOffsetMicroButton = {
									order = 22,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xOffsetMicroButton'],
									desc = L['xOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.xOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.xOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								yOffsetMicroButton = {
									order = 23,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['yOffsetMicroButton'],
									desc = L['yOffsetMicroButton'],
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.yOffsetMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.yOffsetMicroButton = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.SetPointsMicroButtons()
										end
									end
								},
								alphaMicroButton = {
									order = 24,
									type = "range",
									softMin = 0,
									softMax = 1,
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaMicroButton'],
									desc = string.gsub(L['alphaMicroButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.MicroButtons.MainMenuMicroButton.alphaMicroButton, 1),
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.alphaMicroButton end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.alphaMicroButton = value
										if (ClassicUI:IsEnabled()) then
											if not(ClassicUI.hooked_MainMenuMicroButton_OnEnableOnDisable) then
												if (math.abs(ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.alphaMicroButton-ClassicUI.db.defaults.profile.barsConfig.MicroButtons.MainMenuMicroButton.alphaMicroButton) > ClassicUI.STANDARD_EPSILON) then
													MainMenuMicroButton:HookScript("OnEnable", ClassicUI.hookscript_MicroButtonOnEnable)
													MainMenuMicroButton:HookScript("OnDisable", ClassicUI.hookscript_MicroButtonOnDisable)
													ClassicUI.hooked_MainMenuMicroButton_OnEnableOnDisable = true
												end
											end
											if (MainMenuMicroButton:IsEnabled()) then
												ClassicUI.hookscript_MicroButtonOnEnable(MainMenuMicroButton)
											else
												ClassicUI.hookscript_MicroButtonOnDisable(MainMenuMicroButton)
											end
										end
									end
								},
								iconMicroButton = {
									order = 25,
									type = "select",
									style = "radio",
									name = L['iconMicroButton'],
									width = 1.12,
									sorting = { 13, 25, 20, 4, 15, 16, 17, 1, 27, 28, 29, 30, 18, 19, 2, 3, 12, 5, 26, 6, 32, 9, 24, 10, 11, 31 },
									values = {
										[13] = ClassicUI.MICROBUTTONS_OPTION_ICONS['MainMenu Icon']..L['MainMenu Icon [D]'],
										[25] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Perf-MM Icon']..L['Classic Perf-MM Icon [*]'],
										[20] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic MainMenu Icon']..L['Classic MainMenu Icon'],
										[4] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Profession Icon']..L['Profession Icon'],
										[15] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Abilities Icon']..L['Abilities Icon'],
										[16] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Raid Icon']..L['Raid Icon'],
										[17] = ClassicUI.MICROBUTTONS_OPTION_ICONS['World Icon']..L['World Icon'],
										[1] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Class Icon']..L['Class Icon [*]'],
										[27] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Variable Icon']..L['PvP Variable Icon [*]'],
										[28] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Horde Icon']..L['PvP Horde Icon'],
										[29] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Alliance Icon']..L['PvP Alliance Icon'],
										[30] = ClassicUI.MICROBUTTONS_OPTION_ICONS['PvP Neutral Icon']..L['PvP Neutral Icon'],
										[18] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Quest Icon']..L['Classic Quest Icon'],
										[19] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Classic Social Icon']..L['Classic Social Icon'],
										[2] = ClassicUI.MICROBUTTONS_OPTION_ICONS['SpellBook Icon']..L['SpellBook Icon'],
										[3] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Talents Icon']..L['Talents Icon'],
										[12] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Store Icon']..L['Store Icon'],
										[5] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Achievement Icon']..L['Achievement Icon'],
										[26] = ClassicUI.MICROBUTTONS_OPTION_ICONS['BFA Achievement Icon']..L['BFA Achievement Icon'],
										[6] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Quest Icon']..L['Quest Icon'],
										[32] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Housing Icon']..L['Housing Icon'],
										[9] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Icon']..L['LFD Icon'],
										[24] = ClassicUI.MICROBUTTONS_OPTION_ICONS['LFD Normalized Icon']..L['LFD Normalized Icon'],
										[10] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Collections Icon']..L['Collections Icon'],
										[11] = ClassicUI.MICROBUTTONS_OPTION_ICONS['EJ Icon']..L['EJ Icon'],
										[31] = ClassicUI.MICROBUTTONS_OPTION_ICONS['Bug Icon']..L['Bug Icon']
									},
									get = function() return ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton ~= value) then
											ClassicUI.db.profile.barsConfig.MicroButtons.MainMenuMicroButton.iconMicroButton = value
											ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton = value
											ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton_normalTexture = ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture
											ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton_pushedTexture = ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture
											ClassicUI.cached_db_profile.barsConfig_MicroButtons_MainMenuMicroButton_iconMicroButton_disabledTexture = ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture
											if (ClassicUI:IsEnabled()) then
												local status = GetFileStreamingStatus()
												if (status == 0) then
													status = (GetBackgroundLoadingStatus()~=0) and 1 or 0
												end
												if (status == 0) then
													MainMenuMicroButton:SetNormalTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].normalTexture)
													MainMenuMicroButton:SetPushedTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].pushedTexture)
													MainMenuMicroButton:SetDisabledTexture(ClassicUI.MICROBUTTONS_ARRAYINFO[value].disabledTexture)
													MainMenuMicroButton:GetPushedTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
													MainMenuMicroButton:GetHighlightTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
													MainMenuMicroButton:GetDisabledTexture():SetTexCoord(0/32, 32/32, 22/64, 64/64)
													if (value == 25) then	-- Classic Perf-MM Icon
														ClassicUI.CreateMainMenuBarPerformanceBar2Texture(MainMenuMicroButton)
													else
														if (MainMenuMicroButton.MainMenuBarPerformanceBar2 ~= nil) then
															MainMenuMicroButton.MainMenuBarPerformanceBar2:Hide()
														end
													end
												end
											end
										end
									end
								}
							}
						}
					}
				},
				PetBattleFrameBarOptions = {
					order = 11,
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
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.PetBattleFrameBar.scale, 1),
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
					order = 12,
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
								ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_xOffset = value
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
								ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset = value
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
										ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_ignoreyOffsetStatusBar = value
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
										ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset1StatusBar = value
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
										ClassicUI.cached_db_profile.barsConfig_BottomMultiActionBars_yOffset2StatusBar = value
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
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.BottomMultiActionBars.scale, 1),
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
										[1] = L['Modern Layout']
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = function()
										if (ClassicUI.db ~= nil) then
											if (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle == 1) then
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.BottomMultiActionBars.BLStyle1NormalTextureAlpha, 1)
											else
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.BottomMultiActionBars.BLStyle0NormalTextureAlpha, 1)
											end
										else
											return L['NormalTexture Alpha']
										end
									end,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewSpellActivationAlert = {
									order = 11,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellActivationAlert'],
									desc = L['BLStyle0UseNewSpellActivationAlertDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewSpellActivationAlert end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewSpellActivationAlert = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewTargetReticleAnimFrame = {
									order = 12,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewTargetReticleAnimFrame'],
									desc = L['BLStyle0UseNewTargetReticleAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewTargetReticleAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewTargetReticleAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewInterruptDisplay = {
									order = 13,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewInterruptDisplay'],
									desc = L['BLStyle0UseNewInterruptDisplayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewInterruptDisplay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewInterruptDisplay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewSpellCastAnimFrame = {
									order = 14,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellCastAnimFrame'],
									desc = L['BLStyle0UseNewSpellCastAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewSpellCastAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewSpellCastAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewAutoCastOverlay = {
									order = 15,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewAutoCastOverlay'],
									desc = L['BLStyle0UseNewAutoCastOverlayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewAutoCastOverlay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewAutoCastOverlay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewCooldownFlash = {
									order = 16,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCooldownFlash'],
									desc = L['BLStyle0UseNewCooldownFlashDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewCooldownFlash end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewCooldownFlash = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0HideCooldownBlingAnim = {
									order = 17,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0HideCooldownBlingAnim'],
									desc = L['BLStyle0HideCooldownBlingAnimDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0HideCooldownBlingAnim end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0HideCooldownBlingAnim = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[1]=true})
										end
									end
								},
								BLStyle0UseNewChargeCooldownEdgeTexture = {
									order = 18,
									disabled = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewChargeCooldownEdgeTexture'],
									desc = L['BLStyle0UseNewChargeCooldownEdgeTextureDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewChargeCooldownEdgeTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.BottomMultiActionBars.BLStyle0UseNewChargeCooldownEdgeTexture = value
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
								ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_xOffset = value
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
								ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_yOffset = value
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
										ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_ignoreyOffsetStatusBar = value
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
										ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_yOffset1StatusBar = value
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
										ClassicUI.cached_db_profile.barsConfig_RightMultiActionBars_yOffset2StatusBar = value
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
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.RightMultiActionBars.scale, 1),
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
										[1] = L['Modern Layout']
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = function()
										if (ClassicUI.db ~= nil) then
											if (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle == 1) then
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.RightMultiActionBars.BLStyle1NormalTextureAlpha, 1)
											else
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.RightMultiActionBars.BLStyle0NormalTextureAlpha, 1)
											end
										else
											return L['NormalTexture Alpha']
										end
									end,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewSpellActivationAlert = {
									order = 11,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellActivationAlert'],
									desc = L['BLStyle0UseNewSpellActivationAlertDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewSpellActivationAlert end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewSpellActivationAlert = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewTargetReticleAnimFrame = {
									order = 12,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewTargetReticleAnimFrame'],
									desc = L['BLStyle0UseNewTargetReticleAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewTargetReticleAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewTargetReticleAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewInterruptDisplay = {
									order = 13,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewInterruptDisplay'],
									desc = L['BLStyle0UseNewInterruptDisplayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewInterruptDisplay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewInterruptDisplay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewSpellCastAnimFrame = {
									order = 14,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellCastAnimFrame'],
									desc = L['BLStyle0UseNewSpellCastAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewSpellCastAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewSpellCastAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewAutoCastOverlay = {
									order = 15,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewAutoCastOverlay'],
									desc = L['BLStyle0UseNewAutoCastOverlayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewAutoCastOverlay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewAutoCastOverlay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewCooldownFlash = {
									order = 16,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCooldownFlash'],
									desc = L['BLStyle0UseNewCooldownFlashDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewCooldownFlash end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewCooldownFlash = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0HideCooldownBlingAnim = {
									order = 17,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0HideCooldownBlingAnim'],
									desc = L['BLStyle0HideCooldownBlingAnimDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0HideCooldownBlingAnim end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0HideCooldownBlingAnim = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[2]=true})
										end
									end
								},
								BLStyle0UseNewChargeCooldownEdgeTexture = {
									order = 18,
									disabled = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewChargeCooldownEdgeTexture'],
									desc = L['BLStyle0UseNewChargeCooldownEdgeTextureDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewChargeCooldownEdgeTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.RightMultiActionBars.BLStyle0UseNewChargeCooldownEdgeTexture = value
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
					order = 13,
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
								ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_xOffset = value
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
								ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_yOffset = value
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
								ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_xOffsetIfStanceBar = value
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
										ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_ignoreyOffsetStatusBar = value
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
										ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_yOffset1StatusBar = value
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
										ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_yOffset2StatusBar = value
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
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.PetActionBarFrame.scale, 1),
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
										[1] = L['Modern Layout']
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = function()
										if (ClassicUI.db ~= nil) then
											if (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle == 1) then
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.PetActionBarFrame.BLStyle1NormalTextureAlpha, 1)
											else
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.PetActionBarFrame.BLStyle0NormalTextureAlpha, 1)
											end
										else
											return L['NormalTexture Alpha']
										end
									end,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewSpellActivationAlert = {
									order = 11,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellActivationAlert'],
									desc = L['BLStyle0UseNewSpellActivationAlertDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewSpellActivationAlert end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewSpellActivationAlert = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewTargetReticleAnimFrame = {
									order = 12,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewTargetReticleAnimFrame'],
									desc = L['BLStyle0UseNewTargetReticleAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewTargetReticleAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewTargetReticleAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewInterruptDisplay = {
									order = 13,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewInterruptDisplay'],
									desc = L['BLStyle0UseNewInterruptDisplayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewInterruptDisplay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewInterruptDisplay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewSpellCastAnimFrame = {
									order = 14,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellCastAnimFrame'],
									desc = L['BLStyle0UseNewSpellCastAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewSpellCastAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewSpellCastAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewAutoCastOverlay = {
									order = 15,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewAutoCastOverlay'],
									desc = L['BLStyle0UseNewAutoCastOverlayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewAutoCastOverlay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewAutoCastOverlay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewCooldownFlash = {
									order = 16,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCooldownFlash'],
									desc = L['BLStyle0UseNewCooldownFlashDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewCooldownFlash end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewCooldownFlash = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0HideCooldownBlingAnim = {
									order = 17,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0HideCooldownBlingAnim'],
									desc = L['BLStyle0HideCooldownBlingAnimDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0HideCooldownBlingAnim end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0HideCooldownBlingAnim = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[3]=true})
										end
									end
								},
								BLStyle0UseNewChargeCooldownEdgeTexture = {
									order = 18,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewChargeCooldownEdgeTexture'],
									desc = L['BLStyle0UseNewChargeCooldownEdgeTextureDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewChargeCooldownEdgeTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PetActionBarFrame.BLStyle0UseNewChargeCooldownEdgeTexture = value
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
							desc = L['Hide the PetActionBar when the OverrideActionBar is shown'],
							width = "double",
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnOverrideActionBar end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnOverrideActionBar = value
								ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_hideOnOverrideActionBar = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end,
						},
						dontMoveOnOverrideActionBar = {
							order = 13,
							type = "toggle",
							name = L['Do not move on OverrideActionBar'],
							desc = L['Do not move PetActionBar when OverrideActionBar is shown'],
							disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnOverrideActionBar) end,
							width = "double",
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.dontMoveOnOverrideActionBar end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.dontMoveOnOverrideActionBar = value
								ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_dontMoveOnOverrideActionBar = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end,
						},
						hideOnPetBattleFrameBar = {
							order = 14,
							type = "toggle",
							name = L['Hide on PetBattleFrameBar'],
							desc = L['Hide the PetActionBar when the PetBattleFrameBar is shown'],
							width = "double",
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnPetBattleFrameBar end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnPetBattleFrameBar = value
								ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_hideOnPetBattleFrameBar = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end,
						},
						dontMoveOnPetBattleFrameBar = {
							order = 15,
							type = "toggle",
							name = L['Do not move on PetBattleFrameBar'],
							desc = L['Do not move PetActionBar when PetBattleFrameBar is shown'],
							disabled = function() return (ClassicUI.db.profile.barsConfig.PetActionBarFrame.hideOnPetBattleFrameBar) end,
							width = "double",
							get = function() return ClassicUI.db.profile.barsConfig.PetActionBarFrame.dontMoveOnPetBattleFrameBar end,
							set = function(_,value)
								ClassicUI.db.profile.barsConfig.PetActionBarFrame.dontMoveOnPetBattleFrameBar = value
								ClassicUI.cached_db_profile.barsConfig_PetActionBarFrame_dontMoveOnPetBattleFrameBar = value
								if (ClassicUI:IsEnabled()) then
									ClassicUI:UpdatedStatusBarsEvent()
								end
							end,
						}
					}
				},
				StanceBarOptions = {
					order = 14,
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
								ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_xOffset = value
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
								ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_yOffset = value
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
										ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_ignoreyOffsetStatusBar = value
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
										ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_yOffset1StatusBar = value
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
										ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_yOffset2StatusBar = value
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
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.StanceBarFrame.scale, 1),
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
										[1] = L['Modern Layout']
									},
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle end,
									set = function(_,value)
										if (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= value) then
											ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle = value
											ClassicUI.cached_db_profile.barsConfig_StanceBarFrame_BLStyle = value
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = function()
										if (ClassicUI.db ~= nil) then
											if (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle == 1) then
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.StanceBarFrame.BLStyle1NormalTextureAlpha, 1)
											else
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.StanceBarFrame.BLStyle0NormalTextureAlpha, 1)
											end
										else
											return L['NormalTexture Alpha']
										end
									end,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewSpellActivationAlert = {
									order = 11,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellActivationAlert'],
									desc = L['BLStyle0UseNewSpellActivationAlertDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewSpellActivationAlert end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewSpellActivationAlert = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewTargetReticleAnimFrame = {
									order = 12,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewTargetReticleAnimFrame'],
									desc = L['BLStyle0UseNewTargetReticleAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewTargetReticleAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewTargetReticleAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewInterruptDisplay = {
									order = 13,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewInterruptDisplay'],
									desc = L['BLStyle0UseNewInterruptDisplayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewInterruptDisplay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewInterruptDisplay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewSpellCastAnimFrame = {
									order = 14,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellCastAnimFrame'],
									desc = L['BLStyle0UseNewSpellCastAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewSpellCastAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewSpellCastAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewAutoCastOverlay = {
									order = 15,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewAutoCastOverlay'],
									desc = L['BLStyle0UseNewAutoCastOverlayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewAutoCastOverlay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewAutoCastOverlay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewCooldownFlash = {
									order = 16,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCooldownFlash'],
									desc = L['BLStyle0UseNewCooldownFlashDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewCooldownFlash end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewCooldownFlash = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0HideCooldownBlingAnim = {
									order = 17,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0HideCooldownBlingAnim'],
									desc = L['BLStyle0HideCooldownBlingAnimDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0HideCooldownBlingAnim end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0HideCooldownBlingAnim = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[4]=true})
										end
									end
								},
								BLStyle0UseNewChargeCooldownEdgeTexture = {
									order = 18,
									disabled = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewChargeCooldownEdgeTexture'],
									desc = L['BLStyle0UseNewChargeCooldownEdgeTextureDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewChargeCooldownEdgeTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.StanceBarFrame.BLStyle0UseNewChargeCooldownEdgeTexture = value
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
					order = 15,
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
								ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_xOffset = value
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
								ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_yOffset = value
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
										ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_ignoreyOffsetStatusBar = value
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
										ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_yOffset1StatusBar = value
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
										ClassicUI.cached_db_profile.barsConfig_PossessBarFrame_yOffset2StatusBar = value
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
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.PossessBarFrame.scale, 1),
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
										[1] = L['Modern Layout']
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['NormalTexture Alpha'],
									desc = function()
										if (ClassicUI.db ~= nil) then
											if (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle == 1) then
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.PossessBarFrame.BLStyle1NormalTextureAlpha, 1)
											else
												return string.gsub(L['NormalTextureAlphaDesc'], "%$%$%*%*%$%$", ClassicUI.db.defaults.profile.barsConfig.PossessBarFrame.BLStyle0NormalTextureAlpha, 1)
											end
										else
											return L['NormalTexture Alpha']
										end
									end,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
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
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewFlyoutBorder end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewFlyoutBorder = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewSpellActivationAlert = {
									order = 11,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellActivationAlert'],
									desc = L['BLStyle0UseNewSpellActivationAlertDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewSpellActivationAlert end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewSpellActivationAlert = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewTargetReticleAnimFrame = {
									order = 12,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewTargetReticleAnimFrame'],
									desc = L['BLStyle0UseNewTargetReticleAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewTargetReticleAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewTargetReticleAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewInterruptDisplay = {
									order = 13,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewInterruptDisplay'],
									desc = L['BLStyle0UseNewInterruptDisplayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewInterruptDisplay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewInterruptDisplay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewSpellCastAnimFrame = {
									order = 14,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewSpellCastAnimFrame'],
									desc = L['BLStyle0UseNewSpellCastAnimFrameDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewSpellCastAnimFrame end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewSpellCastAnimFrame = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewAutoCastOverlay = {
									order = 15,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewAutoCastOverlay'],
									desc = L['BLStyle0UseNewAutoCastOverlayDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewAutoCastOverlay end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewAutoCastOverlay = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewCooldownFlash = {
									order = 16,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewCooldownFlash'],
									desc = L['BLStyle0UseNewCooldownFlashDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewCooldownFlash end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewCooldownFlash = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0HideCooldownBlingAnim = {
									order = 17,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0HideCooldownBlingAnim'],
									desc = L['BLStyle0HideCooldownBlingAnimDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0HideCooldownBlingAnim end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0HideCooldownBlingAnim = value
										if (ClassicUI:IsEnabled()) then
											ClassicUI.LayoutGroupActionButtons({[5]=true})
										end
									end
								},
								BLStyle0UseNewChargeCooldownEdgeTexture = {
									order = 18,
									disabled = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									hidden = function() return (ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle ~= 0) end,
									type = "toggle",
									name = L['BLStyle0UseNewChargeCooldownEdgeTexture'],
									desc = L['BLStyle0UseNewChargeCooldownEdgeTextureDesc'],
									width = 2.95,
									get = function() return ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewChargeCooldownEdgeTexture end,
									set = function(_,value)
										ClassicUI.db.profile.barsConfig.PossessBarFrame.BLStyle0UseNewChargeCooldownEdgeTexture = value
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
					order = 16,
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
							width = 2.75,
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
								[4] = L['ReputationBar'],
								[5] = L['HouseFavorBar']
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
							min = 0,
							max = 1,
							step = 0.01,
							bigStep = 0.02,
							name = L['Alpha'],
							desc = string.gsub(L['AlphaDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.SingleStatusBar.alpha, 1),
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
							desc = string.gsub(L['xSizeDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.SingleStatusBar.xSize, 1),
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
							desc = string.gsub(L['ySizeDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.SingleStatusBar.ySize, 1),
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaArt'],
									desc = string.gsub(L['alphaArtDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.SingleStatusBar.artAlpha, 1),
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
									disabled = function() return (ClassicUI.db.profile.barsConfig.SingleStatusBar.artHide) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['xSizeArt'],
									desc = string.gsub(L['xSizeArtDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.SingleStatusBar.xSizeArt, 1),
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
									disabled = function() return (ClassicUI.db.profile.barsConfig.SingleStatusBar.artHide) end,
									type = "range",
									softMin = -500,
									softMax = 500,
									step = 1,
									bigStep = 10,
									name = L['ySizeArt'],
									desc = string.gsub(L['ySizeArtDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.SingleStatusBar.ySizeArt, 1),
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['alphaOverlay'],
									desc = string.gsub(L['alphaOverlayDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.SingleStatusBar.overlayAlpha, 1),
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
								[9] = L['ArtifactBar+ReputationBar'],
								[10] = L['ExpBar+HouseFavorBar'],
								[11] = L['HonorBar+HouseFavorBar'],
								[12] = L['AzeriteBar+HouseFavorBar'],
								[13] = L['ArtifactBar+HouseFavorBar'],
								[14] = L['ReputationBar+HouseFavorBar']
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['Alpha'],
									desc = string.gsub(L['AlphaDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleUpperStatusBar.alpha, 1),
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
									desc = string.gsub(L['xSizeDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleUpperStatusBar.xSize, 1),
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
									desc = string.gsub(L['ySizeDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleUpperStatusBar.ySize, 1),
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
											min = 0,
											max = 1,
											step = 0.01,
											bigStep = 0.02,
											name = L['alphaArt'],
											desc = string.gsub(L['alphaArtDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleUpperStatusBar.artAlpha, 1),
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
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['xSizeArt'],
											desc = string.gsub(L['xSizeArtDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleUpperStatusBar.xSizeArt, 1),
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
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.artHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['ySizeArt'],
											desc = string.gsub(L['ySizeArtDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleUpperStatusBar.ySizeArt, 1),
											get = function() return ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySizeArt end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleUpperStatusBar.ySizeArt = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
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
											min = 0,
											max = 1,
											step = 0.01,
											bigStep = 0.02,
											name = L['alphaOverlay'],
											desc = string.gsub(L['alphaOverlayDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleUpperStatusBar.overlayAlpha, 1),
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
									min = 0,
									max = 1,
									step = 0.01,
									bigStep = 0.02,
									name = L['Alpha'],
									desc = string.gsub(L['AlphaDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleLowerStatusBar.alpha, 1),
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
									desc = string.gsub(L['xSizeDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleLowerStatusBar.xSize, 1),
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
									desc = string.gsub(L['ySizeDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleLowerStatusBar.ySize, 1),
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
											min = 0,
											max = 1,
											step = 0.01,
											bigStep = 0.02,
											name = L['alphaArt'],
											desc = string.gsub(L['alphaArtDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleLowerStatusBar.artAlpha, 1),
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
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['xSizeArt'],
											desc = string.gsub(L['xSizeArtDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleLowerStatusBar.xSizeArt, 1),
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
											disabled = function() return (ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.artHide) end,
											type = "range",
											softMin = -500,
											softMax = 500,
											step = 1,
											bigStep = 10,
											name = L['ySizeArt'],
											desc = string.gsub(L['ySizeArtDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleLowerStatusBar.ySizeArt, 1),
											get = function() return ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySizeArt end,
											set = function(_,value)
												ClassicUI.db.profile.barsConfig.DoubleLowerStatusBar.ySizeArt = value
												if (ClassicUI:IsEnabled()) then
													ClassicUI:StatusTrackingBarManager_UpdateBarsShown()
												end
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
											min = 0,
											max = 1,
											step = 0.01,
											bigStep = 0.02,
											name = L['alphaOverlay'],
											desc = string.gsub(L['alphaOverlayDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.barsConfig.DoubleLowerStatusBar.overlayAlpha, 1),
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
								ClassicUI.cached_db_profile.extraFrames_Minimap_enabled = value
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
							desc = string.gsub(L['ScaleDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.extraFrames.Minimap.scale, 1),
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
						CalendarAndMailIcons = {
							order = 10,
							disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
							inline = true,
							type = "group",
							name = L['Calendar, Mail and Clock Configuration'],
							desc = "",
							args = {
								MailIconPriority = {
									order = 1,
									disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
									type = "select",
									name = L['MailIconPriority'],
									desc = L['MailIconPriorityDesc'],
									width = 2.30,
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
								minimapArrangementType = {
									order = 2,
									disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
									type = "select",
									style = "radio",
									name = L['minimapArrangementType'],
									desc = L['minimapArrangementTypeDesc'],
									width = "normal",
									values = {
										[0] = '|T1450455:28:28:0:0:56:56:0:56:0:56|t '..'|cffbd7d11'..L['Legion (default)']..'|r',
										[1] = '|T4279397:28:28:0:0:56:56:0:56:0:56|t '..'|cffbd7d11'..L['Classic']..'|r',
										[2] = '|T630784:28:28:0:0:56:56:0:56:0:56|t '..'|cffbd7d11'..L['Cataclysm']..'|r'
									},
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.minimapArrangementType end,
									set = function(_,value)
										if (ClassicUI.db.profile.extraFrames.Minimap.minimapArrangementType ~= value) then
											ClassicUI.db.profile.extraFrames.Minimap.minimapArrangementType = value
											ClassicUI.cached_db_profile.extraFrames_Minimap_minimapArrangementType = value
											if (value == 1) then
												ClassicUI.db.profile.extraFrames.Minimap.calendarIconType = 1
												ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize = 50
												ClassicUI.db.profile.extraFrames.Minimap.useClassicTimeClock = true
											else
												ClassicUI.db.profile.extraFrames.Minimap.calendarIconType = 0
												ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize = 40
												ClassicUI.db.profile.extraFrames.Minimap.useClassicTimeClock = false
											end
											ClassicUI.db.profile.extraFrames.Minimap.zoomButtonsPositions = value
											if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
												GameTimeFrame:ClearAllPoints()
												MinimapCluster.IndicatorFrame:ClearAllPoints()
												TimeManagerClockTicker:ClearAllPoints()
												Minimap.ZoomIn:ClearAllPoints()
												Minimap.ZoomOut:ClearAllPoints()
												if (value == 1) then
													GameTimeFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 4, -19)
													MinimapCluster.IndicatorFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 7, -59)
													GameTimeFrame:SetSize(50, 50)
													GameTimeFrame:GetFontString():SetScale(1.25)
													GameTimeTexture:Show()
													GameTimeFrame:GetNormalTexture():SetAlpha(0)
													TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 1, 0)
													TimeManagerClockButtonBackground:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\ClockBackground-classic")
													Minimap.ZoomIn:SetPoint("CENTER", MinimapBackdrop, "CENTER", 77, -13)
													Minimap.ZoomOut:SetPoint("CENTER", MinimapBackdrop, "CENTER", 51, -41)
												elseif (value == 2) then
													GameTimeFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 4, -37)
													MinimapCluster.IndicatorFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 7, -74)
													GameTimeFrame:SetSize(40, 40)
													GameTimeFrame:GetFontString():SetScale(1)
													GameTimeTexture:Hide()
													GameTimeFrame:GetNormalTexture():SetAlpha(1)
													TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 3, 1)
													TimeManagerClockButtonBackground:SetTexture("Interface\\TimeManager\\ClockBackground")
													Minimap.ZoomIn:SetPoint("CENTER", MinimapBackdrop, "CENTER", 71, -20)
													Minimap.ZoomOut:SetPoint("CENTER", MinimapBackdrop, "CENTER", 51, -39)
												else
													GameTimeFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 3, -24)
													MinimapCluster.IndicatorFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 7, -59)
													GameTimeFrame:SetSize(40, 40)
													GameTimeFrame:GetFontString():SetScale(1)
													GameTimeTexture:Hide()
													GameTimeFrame:GetNormalTexture():SetAlpha(1)
													TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 3, 1)
													TimeManagerClockButtonBackground:SetTexture("Interface\\TimeManager\\ClockBackground")
													Minimap.ZoomIn:SetPoint("CENTER", MinimapBackdrop, "CENTER", 72, -25)
													Minimap.ZoomOut:SetPoint("CENTER", MinimapBackdrop, "CENTER", 50, -43)
												end
												ClassicUI:RepositionAddonCompartmentFrame()
											end
										end
									end
								},
								calendarIconType = {
									order = 3,
									disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
									type = "select",
									style = "radio",
									name = L['calendarIconType'],
									desc = L['calendarIconTypeDesc'],
									width = "normal",
									values = {
										[0] = '|T652159:24:24:0:0:56:56:0:56:0:56|t '..L['Calendar Icon'],
										[1] = '|T1033477:24:24:0:0:56:56:0:56:0:56|t '..L['Day/Night Icon']
									},
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.calendarIconType end,
									set = function(_,value)
										if (ClassicUI.db.profile.extraFrames.Minimap.calendarIconType ~= value) then
											ClassicUI.db.profile.extraFrames.Minimap.calendarIconType = value
											if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
												if (value == 1) then
													GameTimeTexture:Show()
													GameTimeFrame:GetNormalTexture():SetAlpha(0)
												else
													GameTimeTexture:Hide()
													GameTimeFrame:GetNormalTexture():SetAlpha(1)
												end
											end
										end
									end
								},
								calendarIconSize = {
									order = 4,
									disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
									type = "select",
									style = "radio",
									name = L['calendarIconSize'],
									desc = L['calendarIconSizeDesc'],
									width = "normal",
									values = {
										[40] = '|T236565:24:24:0:0:56:56:17:43:18:44|t '..L['40x40'],
										[50] = '|T236566:24:24:0:0:56:56:17:43:18:44|t '..L['50x50']
									},
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize end,
									set = function(_,value)
										if (ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize ~= value) then
											ClassicUI.db.profile.extraFrames.Minimap.calendarIconSize = value
											if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
												if (value == 40) then
													GameTimeFrame:SetSize(40, 40)
													GameTimeFrame:GetFontString():SetScale(1)
												elseif (value == 50) then
													GameTimeFrame:SetSize(50, 50)
													GameTimeFrame:GetFontString():SetScale(1.25)
												elseif (type(value)=="number") then
													GameTimeFrame:SetSize(value, value)
													GameTimeFrame:GetFontString():SetScale(value / 40)
												else
													GameTimeFrame:SetSize(40, 40)
													GameTimeFrame:GetFontString():SetScale(1)
												end
												ClassicUI:RepositionAddonCompartmentFrame()
											end
										end
									end
								},
								zoomButtonsPositions = {
									order = 5,
									disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
									type = "select",
									style = "radio",
									name = L['zoomButtonsPositions'],
									desc = L['zoomButtonsPositionsDesc'],
									width = "normal",
									values = {
										[0] = '|T6033346:24:24:0:0:56:56:0:56:0:56|t '..L['Position 1'],
										[1] = '|T6033347:24:24:0:0:56:56:0:56:0:56|t '..L['Position 2'],
										[2] = '|T6033348:24:24:0:0:56:56:0:56:0:56|t '..L['Position 3']
									},
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.zoomButtonsPositions end,
									set = function(_,value)
										if (ClassicUI.db.profile.extraFrames.Minimap.zoomButtonsPositions ~= value) then
											ClassicUI.db.profile.extraFrames.Minimap.zoomButtonsPositions = value
											if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
												Minimap.ZoomIn:ClearAllPoints()
												Minimap.ZoomOut:ClearAllPoints()
												if (value == 1) then
													Minimap.ZoomIn:SetPoint("CENTER", MinimapBackdrop, "CENTER", 77, -13)
													Minimap.ZoomOut:SetPoint("CENTER", MinimapBackdrop, "CENTER", 51, -41)
												elseif (value == 2) then
													Minimap.ZoomIn:SetPoint("CENTER", MinimapBackdrop, "CENTER", 71, -20)
													Minimap.ZoomOut:SetPoint("CENTER", MinimapBackdrop, "CENTER", 51, -39)
												else
													Minimap.ZoomIn:SetPoint("CENTER", MinimapBackdrop, "CENTER", 72, -25)
													Minimap.ZoomOut:SetPoint("CENTER", MinimapBackdrop, "CENTER", 50, -43)
												end
											end
										end
									end
								},
								useClassicTimeClock = {
									order = 6,
									disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
									type = "toggle",
									name = function() return (ClassicUI.db.profile.extraFrames.Minimap.useClassicTimeClock and '|TInterface\\Addons\\ClassicUI\\Textures\\ClockBackground-classic:28:60:0:0:64:64:1:52:1:25|t ' or '|TInterface\\TimeManager\\ClockBackground:28:60:0:0:64:64:1:52:1:25|t ')..L['useClassicTimeClock'] end,
									desc = L['useClassicTimeClockDesc'],
									width = "double",
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.useClassicTimeClock end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Minimap.useClassicTimeClock = value
										if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
											TimeManagerClockTicker:ClearAllPoints()
											if (value) then
												TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 1, 0)
												TimeManagerClockButtonBackground:SetTexture("Interface\\Addons\\ClassicUI\\Textures\\ClockBackground-classic")
											else
												TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 3, 1)
												TimeManagerClockButtonBackground:SetTexture("Interface\\TimeManager\\ClockBackground")
											end
										end
									end,
								}
							}
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
							name = L['ExpansionLandingPage (ELP) Button'],
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
											elseif (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "warwithin-landingbutton-up") then
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
											elseif (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "warwithin-landingbutton-up") then
												ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 4 + 26.5 + value, -105 - 6 - 26.5 + ClassicUI.db.profile.extraFrames.Minimap.yOffsetExpansionLandingPage)
											else
												ExpansionLandingPageMinimapButton:SetPoint("CENTER", MinimapBackdrop, "TOPLEFT", 32 + 6 + 26.5 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetExpansionLandingPage, -105 - 7 - 26.5 + value)
											end
										end
									end
								},
								Spacer1 = {
									type = "description",
									order = 3,
									name = ""
								},
								scaleExpansionLandingPageDragonflight = {
									order = 4,
									disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
									type = "range",
									min = 0.01,
									softMin = 0.01,
									softMax = 4,
									step = 0.01,
									bigStep = 0.03,
									name = L['ScaleELP-DF-Button'],
									desc = string.gsub(L['ScaleELP-DF-ButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.extraFrames.Minimap.scaleExpansionLandingPageDragonflight, 1),
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.scaleExpansionLandingPageDragonflight end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Minimap.scaleExpansionLandingPageDragonflight = value
										ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageDragonflight = value
										if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
											if (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "dragonflight-landingbutton-up") then
												if (ClassicUI.elpmbSizes.dragonflight.w == 0 or ClassicUI.elpmbSizes.dragonflight.h == 0) then
													ClassicUI.elpmbSizes.dragonflight.w = ExpansionLandingPageMinimapButton:GetWidth()
													ClassicUI.elpmbSizes.dragonflight.h = ExpansionLandingPageMinimapButton:GetHeight()
												end
												ExpansionLandingPageMinimapButton:SetSize(math.floor(ClassicUI.elpmbSizes.dragonflight.w * value + 0.5), math.floor(ClassicUI.elpmbSizes.dragonflight.h * value + 0.5))
											end
										end
									end
								},
								scaleExpansionLandingPageTheWarWithin = {
									order = 5,
									disabled = function() return not(ClassicUI.db.profile.extraFrames.Minimap.enabled) end,
									type = "range",
									min = 0.01,
									softMin = 0.01,
									softMax = 4,
									step = 0.01,
									bigStep = 0.03,
									name = L['ScaleELP-TWW-Button'],
									desc = string.gsub(L['ScaleELP-TWW-ButtonDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.extraFrames.Minimap.scaleExpansionLandingPageTheWarWithin, 1),
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.scaleExpansionLandingPageTheWarWithin end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Minimap.scaleExpansionLandingPageTheWarWithin = value
										ClassicUI.cached_db_profile.extraFrames_Minimap_scaleExpansionLandingPageTheWarWithin = value
										if (ClassicUI.db.profile.extraFrames.Minimap.enabled) then
											if (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "warwithin-landingbutton-up") then
												if (ClassicUI.elpmbSizes.warwithin.w == 0 or ClassicUI.elpmbSizes.warwithin.h == 0) then
													ClassicUI.elpmbSizes.warwithin.w = ExpansionLandingPageMinimapButton:GetWidth()
													ClassicUI.elpmbSizes.warwithin.h = ExpansionLandingPageMinimapButton:GetHeight()
												end
												ExpansionLandingPageMinimapButton:SetSize(math.floor(ClassicUI.elpmbSizes.warwithin.w * value + 0.5), math.floor(ClassicUI.elpmbSizes.warwithin.h * value + 0.5))
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
							name = L['AddonCompartment Frame Button'],
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
											local xCUIACFExtraOffset, yCUIACFExtraOffset = ClassicUI:GetCUIOffsetsAddonCompartmentFrame()
											AddonCompartmentFrame:ClearAllPoints()
											AddonCompartmentFrame:SetPoint("TOPRIGHT", GameTimeFrame, "TOPLEFT", 5 + xCUIACFExtraOffset + value, 0 + yCUIACFExtraOffset + ClassicUI.db.profile.extraFrames.Minimap.yOffsetAddonCompartment)
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
											local xCUIACFExtraOffset, yCUIACFExtraOffset = ClassicUI:GetCUIOffsetsAddonCompartmentFrame()
											AddonCompartmentFrame:ClearAllPoints()
											AddonCompartmentFrame:SetPoint("TOPRIGHT", GameTimeFrame, "TOPLEFT", 5 + xCUIACFExtraOffset + ClassicUI.db.profile.extraFrames.Minimap.xOffsetAddonCompartment, 0 + yCUIACFExtraOffset + value)
										end
									end
								},
								scaleAddonCompartment = {
									order = 5,
									disabled = function() return (not(ClassicUI.db.profile.extraFrames.Minimap.enabled) or ClassicUI.db.profile.extraFrames.Minimap.hideAddonCompartment) end,
									type = "range",
									min = 0.01,
									softMin = 0.01,
									softMax = 4,
									step = 0.01,
									bigStep = 0.03,
									name = L['ScaleACFrame'],
									desc = string.gsub(L['ScaleACFrameDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.extraFrames.Minimap.scaleAddonCompartment, 1),
									get = function() return ClassicUI.db.profile.extraFrames.Minimap.scaleAddonCompartment end,
									set = function(_,value)
										ClassicUI.db.profile.extraFrames.Minimap.scaleAddonCompartment = value
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
								ClassicUI.cached_db_profile.extraFrames_Minimap_anchorQueueButtonToMinimap = value
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
										QueueStatusButton:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -45 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, 4 - ClassicUI.MICROBUTTONANDBAGSBAR_CUI_OFFSET_Y + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
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
										QueueStatusButton:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -45 + value, 4 - ClassicUI.MICROBUTTONANDBAGSBAR_CUI_OFFSET_Y + ClassicUI.db.profile.extraFrames.Minimap.yOffsetQueueButton)
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
										QueueStatusButton:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -45 + ClassicUI.db.profile.extraFrames.Minimap.xOffsetQueueButton, 4 - ClassicUI.MICROBUTTONANDBAGSBAR_CUI_OFFSET_Y + value)
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
							name = L['FreeSlots Counter'],
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
									desc = string.gsub(L['freeSlotsCounterFontSizeDesc'], "%$%$%*%*%$%$", ClassicUI.defaults.profile.extraFrames.Bags.freeSlotsCounterFontSize, 1),
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
								ClassicUI.cached_db_profile.extraFrames_Chat_restoreScrollButtons = value
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
						}
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
							width = 2.30,
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
									ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_enabled = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ReloadUI()
									end
								else
									ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.enabled = value
									ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_enabled = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ClassicUI:GOC_MainFunction()
									end
								end
							end
						},
						Spacer3 = {
							type = "description",
							order = 9,
							name = ""
						},
						desaturateUnusableActions = {
							order = 10,
							type = "toggle",
							name = L['DesaturateUnusableActions'],
							desc = L['DesaturateUnusableActionsDesc'],
							width = "double",
							get = function() return ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.desaturateUnusableActions end,
							set = function(_,value)
								ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.desaturateUnusableActions = value
								ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_desaturateUnusableActions = value
								if ((ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) and (ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.enabled)) then
									if (GREYONCOOLDOWN_HOOKED == ClassicUI) then
										ClassicUI:GOC_UpdateAllActionButtons()
									end
								end
							end
						},
						desaturatePetActionButtons = {
							order = 11,
							type = "toggle",
							name = L['DesaturatePetActionButtons'],
							desc = L['DesaturatePetActionButtonsDesc'],
							width = "double",
							get = function() return ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.desaturatePetActionButtons end,
							set = function(_,value)
								ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.desaturatePetActionButtons = value
								ClassicUI.cached_db_profile.extraConfigs_GreyOnCooldownConfig_desaturatePetActionButtons = value
								if ((ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) and (ClassicUI.db.profile.extraConfigs.GreyOnCooldownConfig.enabled)) then
									if (GREYONCOOLDOWN_HOOKED == ClassicUI) then
										ClassicUI:GOC_HookGOCPetActionButtons()
									end
								end
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
									ClassicUI.cached_db_profile.extraConfigs_LossOfControlUIConfig_enabled = value
									if (ClassicUI:IsEnabled() or ClassicUI.db.profile.forceExtraOptions) then
										ReloadUI()
									end
								else
									ClassicUI.db.profile.extraConfigs.LossOfControlUIConfig.enabled = value
									ClassicUI.cached_db_profile.extraConfigs_LossOfControlUIConfig_enabled = value
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
