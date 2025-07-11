local L = LibStub("AceLocale-3.0"):NewLocale("ClassicUI","enUS",true)
if not L then return end

L[''] = true
L['ClassicUI'] = true
L['Version'] = true
L['Author: Millán-Sanguino'] = true
L['Enable'] = true
L['Enable ClassicUI'] = true
L['Enable ClassicUI core'] = true
L['EnableClassicUICoreDesc'] = 'Enables the main features of ClassicUI that are related to the action bars and their buttons. The ClassicUI settings for \'Extra Frames\' continue to operate even if this option is disabled. For the \'Extra Options\', these will also be executed even if this option is disabled, but only if the \'Force Extra Options\' option is enabled.'
L['Force Extra Options'] = true
L['Enable Extra Options even ClassicUI core is disabled'] = true
L['DisableAddonCompartmentIntegration'] = 'Disable AddonCompartment integration'
L['DisableAddonCompartmentIntegrationDesc'] = 'Check this option to not list the ClassicUI addon in the addon compartment dropdown menu (accessible from the minimap)'
L['Hide'] = true
L['Hide for:'] = true
L['Enabled'] = true
L['Disabled'] = true
L['enabled'] = true
L['disabled'] = true
L['General Settings'] = true
L['Profiles'] = true
L['Extra Frames'] = true
L['Extra Options'] = true
L['ReloadUI'] = true
L['Scale'] = true
L['ScaleDesc'] = 'Scale (Default: $$**$$)'
L['Alpha'] = true
L['AlphaDesc'] = 'Alpha (Default: $$**$$)'
L['xOffset'] = true
L['yOffset'] = true
L['xSize'] = true
L['ySize'] = true
L['xSizeDesc'] = 'xSize (Default: $$**$$)'
L['ySizeDesc'] = 'ySize (Default: $$**$$)'

L['Default'] = true
L['DefaultDesc'] = 'Set option to the default value'
L['DefaultOrderDesc'] = 'Reset the order to the default values'
L['Configure Frames'] = true
L['MainMenuBar'] = true
L['GargoyleFrames'] = true
L['OverrideActionBar'] = true
L['PetBattleFrameBar'] = true
L['MultiActionBar'] = true
L['PetActionBar'] = true
L['StanceBar'] = true
L['PossessBar'] = true
L['StatusBar'] = true
L['StatusBar General Configuration'] = true
L['BottomMultiActionBars'] = true
L['RightMultiActionBars'] = true
L['SingleStatusBar'] = true
L['DoubleStatusBar'] = true
L['UpperStatusBar'] = true
L['LowerStatusBar'] = true
L['MicroButtons'] = true
L['Character'] = true
L['Profession'] = true
L['PlayerSpells'] = true
L['Achievement'] = true
L['QuestLog'] = true
L['Guild'] = true
L['LFD'] = true
L['Collections'] = true
L['EJ'] = true
L['Help'] = true
L['Store'] = true
L['MainMenu'] = true
L['CharacterMicroButton'] = true
L['ProfessionMicroButton'] = true
L['PlayerSpellsMicroButton'] = true
L['AchievementMicroButton'] = true
L['QuestLogMicroButton'] = true
L['GuildMicroButton'] = true
L['LFDMicroButton'] = true
L['CollectionsMicroButton'] = true
L['EJMicroButton'] = true
L['HelpMicroButton'] = true
L['StoreMicroButton'] = true
L['MainMenuMicroButton'] = true
L['BagsIcons'] = true
L['SpellFlyoutButtons'] = true
L['Hide Small Latency Bar'] = true
L['Left Gargoyle'] = true
L['Hide Left Gargoyle'] = true
L['Left Gargoyle Model'] = true
L['Select the model of the Left Gargoyle'] = true
L['Right Gargoyle'] = true
L['Hide Right Gargoyle'] = true
L['Right Gargoyle Model'] = true
L['Select the model of the Right Gargoyle'] = true
L['Default - Gryphon'] = true
L['Lion'] = true
L['New Gryphon'] = true
L['New Wyvern'] = true
L['Disable auto-yOffset [*]'] = true
L['Disable auto-yOffset when StatusBar are shown'] = true
L['yOffset - 1 StatusBar Shown'] = true
L['yOffset when One Status Bar is shown'] = true
L['yOffset - 2 StatusBar Shown'] = true
L['yOffset when Two Status Bars are shown'] = true
L['xOffset - StanceBar Shown'] = true
L['xOffset when StanceBar is shown'] = true
L['Normalize spacing of PetActionButtons'] = true
L['Hide on OverrideActionBar'] = true
L['Hide on PetBattleFrameBar'] = true
L['Do not move on OverrideActionBar'] = true
L['Do not move on PetBattleFrameBar'] = true
L['ArtFrame'] = true
L['OverlayFrame'] = true
L['Hide ArtFrame'] = true
L['Hide OverlayFrame'] = true
L['xOffsetArt'] = true
L['yOffsetArt'] = true
L['xSizeArt'] = true
L['ySizeArt'] = true
L['xSizeArtDesc'] = 'xSizeArt (Default: $$**$$)'
L['ySizeArtDesc'] = 'ySizeArt (Default: $$**$$)'
L['xOffsetOverlay'] = true
L['yOffsetOverlay'] = true
L['alphaOverlay'] = true
L['alphaOverlayDesc'] = 'alphaOverlay (Default: $$**$$)'
L['alphaArt'] = true
L['alphaArtDesc'] = 'alphaArt (Default: $$**$$)'
L['expBarAlwaysShowRestedBar'] = '[ExpBar] Show the rested bar even if is exceeds the level'
L['xOffsetReagentBag'] = true
L['yOffsetReagentBag'] = true
L['xOffsetFreeSlotsCounter'] = true
L['yOffsetFreeSlotsCounter'] = true
L['freeSlotsCounterFontSize'] = true
L['freeSlotsCounterFontSizeDesc'] = 'freeSlotsCounterFontSize (Default: $$**$$)'
L['IconBorder Alpha'] = true
L['IconBorderAlphaDesc'] = 'IconBorder Alpha (Default: $$**$$)'
L['General configuration of StatusBar that applies regardless of how many StatusBars are visible'] = true
L['Configuration for 1 visible StatusBar'] = true
L['Configuration for 2 visible StatusBars'] = true
L['Hide SingleStatusBar for the selected StatusBar types'] = true
L['Hide DoubleStatusBar for the selected StatusBar types'] = true
L['Select this option to make the spacing of all PetActionButtons the same, since by default the spacing between button 6 and 7 is 1px less than the rest'] = true
L['Hide the PetActionBar when the OverrideActionBar is shown instead of moving it to a new spot'] = true
L['Hide the PetActionBar when the PetBattleFrameBar is shown instead of moving it to a new spot'] = true
L['Hide the PetActionBar when the OverrideActionBar is shown'] = true
L['Hide the PetActionBar when the PetBattleFrameBar is shown'] = true
L['Do not move PetActionBar when OverrideActionBar is shown'] = true
L['Do not move PetActionBar when PetBattleFrameBar is shown'] = true
L['ExpBar'] = true
L['HonorBar'] = true
L['AzeriteBar'] = true
L['ArtifactBar'] = true
L['ReputationBar'] = true
L['ExpBar+HonorBar'] = true
L['ExpBar+AzeriteBar'] = true
L['ExpBar+ArtifactBar'] = true
L['ExpBar+ReputationBar'] = true
L['HonorBar+AzeriteBar'] = true
L['HonorBar+ArtifactBar'] = true
L['HonorBar+ReputationBar'] = true
L['AzeriteBar+ArtifactBar'] = true
L['AzeriteBar+ReputationBar'] = true
L['ArtifactBar+ReputationBar'] = true
L['expBarAlwaysShowRestedBarDesc'] = 'Check this option to always show the rested bar from the ExpBar that indicates how much rested experience remains, since by default Blizzard does not show it if it exceeds the current level of the player.'
L['Use the classic Quest MicroButton Icon'] = true
L['Use the classic Guild MicroButton Icon'] = true
L['Make Guild Emblem bigger'] = true
L['Use the classic MainMenu MicroButton Icon'] = true
L['Replaces the Quest MicroButton icon with its classic texture'] = true
L['Replaces the dynamic Guild MicroButton (with its emblem) with its classic static texture'] = true
L['Enlarges the Guild Emblem on the MicroButton to make it bigger and more visible'] = true
L['Replaces the Quest Main Menu icon with its classic texture'] = true
L['ActionButtons Layout'] = true
L['BLStyle0'] = 'Main Layout (MainMenuBar AB):'
L['BLStyle1'] = 'Main Layout (BottomMultiActionBars AB):'
L['BLStyle2'] = 'Main Layout (RightMultiActionBars AB):'
L['BLStyle3'] = 'Main Layout (PetActionBar AB):'
L['BLStyle4'] = 'Main Layout (StanceBar AB):'
L['BLStyle5'] = 'Main Layout (PossessBar AB):'
L['BLStyle6'] = 'Main Layout (SpellFlyoutButtons):'
L['BLStyle7'] = 'Main Layout (OverrideActionBar AB):'
L['Default - Classic Layout'] = true
L['Dragonflight Layout'] = true
L['Modern Layout'] = true
L['NormalTexture Alpha'] = true
L['NormalTextureAlphaDesc'] = 'NormalTexture Alpha (Default: $$**$$)'
L['BLStyle0AllowNewBackgroundArt'] = 'Allow to show the new background art'
L['BLStyle0UseOldHotKeyTextStyle'] = 'Use the old style for the Keybinds text'
L['BLStyle0UseNewPushedTexture'] = 'Use the new PushedTexture instead of the classic one'
L['BLStyle0UseNewCheckedTexture'] = 'Use the new CheckedTexture instead of the classic one'
L['BLStyle0UseNewHighlightTexture'] = 'Use the new HighlightTexture instead of the classic one'
L['BLStyle0UseNewSpellHighlightTexture'] = 'Use the new SpellHighlightTexture instead of the classic one'
L['BLStyle0UseNewFlyoutBorder'] = 'Use the new FlyoutBorder instead of the classic one'
L['BLStyle0UseNewSpellActivationAlert'] = 'Use the new SpellActivationAlert animation instead of the classic one'
L['BLStyle0UseNewTargetReticleAnimFrame'] = 'Use the new TargetReticleAnim animation'
L['BLStyle0UseNewInterruptDisplay'] = 'Use the new InterruptDisplay animation'
L['BLStyle0UseNewSpellCastAnimFrame'] = 'Use the new SpellCastAnim animation'
L['BLStyle0UseNewAutoCastOverlay'] = 'Use the new AutoCastOverlay animation'
L['BLStyle0UseNewCooldownFlash'] = 'Use the CooldownFlash animation from patch 10.1.5'
L['BLStyle0HideCooldownBlingAnim'] = 'Hide CooldownBling animation like the new modern layout does since Dragonflight'
L['BLStyle0UseNewChargeCooldownEdgeTexture'] = 'Use the new ChargeCooldownEdge texture instead of the classic one'
L['BLStyleDesc0'] = 'Select the main layout of the ActionButtons from MainMenuBar'
L['BLStyleDesc1'] = 'Select the main layout of the ActionButtons from BottomMultiActionBars'
L['BLStyleDesc2'] = 'Select the main layout of the ActionButtons from RightMultiActionBars'
L['BLStyleDesc3'] = 'Select the main layout of the ActionButtons from PetActionBar'
L['BLStyleDesc4'] = 'Select the main layout of the ActionButtons from StanceBar'
L['BLStyleDesc5'] = 'Select the main layout of the ActionButtons from PossessBar'
L['BLStyleDesc6'] = 'Select the main layout of the SpellFlyoutButtons'
L['BLStyleDesc7'] = 'Select the main layout of the ActionButtons from OverrideActionBar'
L['BLStyle0AllowNewBackgroundArtDesc'] = 'Shows the new ActionButton background included since Dragonflight (visible when the button has no action assigned). It will only be shown if the button belongs to an ActionBar that has an art background available and this art background is not hidden from Edit Mode.'
L['BLStyle0UseOldHotKeyTextStyleDesc'] = 'Use the old Monochrome and Thick Outline style for Keybinds text (the pre-9.1.5 style) instead of the new (softer and more modern).'
L['BLStyle0UseNewPushedTextureDesc'] = 'Use the new PushedTexture introduced in Dragonflight while still using the classic layout as the main layout.'
L['BLStyle0UseNewCheckedTextureDesc'] = 'Use the new CheckedTexture introduced in Dragonflight while still using the classic layout as the main layout.'
L['BLStyle0UseNewHighlightTextureDesc'] = 'Use the new HighlightTexture introduced in Dragonflight while still using the classic layout as the main layout.'
L['BLStyle0UseNewSpellHighlightTextureDesc'] = 'Use the new SpellHighlightTexture introduced in Dragonflight while still using the classic design as the main layout.'
L['BLStyle0UseNewFlyoutBorderDesc'] = 'Use the new FlyoutBorder introduced in Dragonflight while still using the classic layout as the main layout.'
L['BLStyle0UseNewSpellActivationAlertDesc'] = 'Use the new SpellActivationAlert animation introduced in Dragonflight patch 10.1.5 while still using the classic layout as the main layout.'
L['BLStyle0UseNewTargetReticleAnimFrameDesc'] = 'Use the new TargetReticleAnim animation introduced in Dragonflight patch 10.1.5 while still using the classic layout as the main layout.'
L['BLStyle0UseNewInterruptDisplayDesc'] = 'Use the new InterruptDisplay animation introduced in Dragonflight patch 10.1.5 while still using the classic layout as the main layout.'
L['BLStyle0UseNewSpellCastAnimFrameDesc'] = 'Use the new SpellCastAnim animation introduced in Dragonflight patch 10.1.5 while still using the classic layout as the main layout.'
L['BLStyle0UseNewAutoCastOverlayDesc'] = 'Use the new AutoCastOverlay animation introduced in The War Within patch 11.0.0 while still using the classic layout as the main layout.'
L['BLStyle0UseNewCooldownFlashDesc'] = 'Use the CooldownFlash animation introduced in Dragonflight patch 10.1.5 (and removed as of patch 10.1.7) while still using the classic layout as the main layout.'
L['BLStyle0HideCooldownBlingAnimDesc'] = 'Hide the CooldownBling animation (the animation at the end of the cooldown) in the same way as it is done in the new modern layout since Dragonflight patch 10.1.5'
L['BLStyle0UseNewChargeCooldownEdgeTextureDesc'] = 'Use the new ChargeCooldownEdge texture (the texture which \'follows\' the moving edge of the cooldown) (only for spells with charges) introduced in Dragonflight patch 10.1.5 while still using the classic layout as the main layout.'
L['alphaMicroButton'] = true
L['alphaMicroButtonDesc'] = 'alphaMicroButton (Default: $$**$$)'
L['MicroButtons Order'] = true
L['UP'] = true
L['DOWN'] = true
L['Hide MicroButton'] = true
L['Keep MicroButton Gap'] = true
L['KeepMicroButtonGapDesc'] = 'If this option is checked, the MicroButton will continue to occupy its space even if it is hidden'
L['Disable MicroButton'] = true
L['Disable Mouse'] = true
L['DisableMouseMicroButtonDesc'] = 'Disables all MicroButton mouse interactions'
L['classicNotificationMicroButton'] = 'Use classic notification marker'
L['classicNotificationMicroButtonDesc'] = 'Use the classic marker overlay for pending notifications'
L['xOffsetMicroButton'] = true
L['yOffsetMicroButton'] = true
L['helpOpenWebTicketButtonAnchor'] = 'Anchor WebTicketButton to...'
L['helpOpenWebTicketButtonAnchorDesc'] = 'Select which MicroButton the WebTicketButton will anchor to'
L['Default - MainMenuMicroButton'] = 'Default - MainMenuMicroButton'
L['goToGuildPanelOptionsPanel'] = 'Go to the Guild Panel Mode options'
L['goToGuildPanelOptionsPanelDesc'] = 'Press the button to go to the options panel that allows you to recover the old guild panel for access with certain mouse buttons and/or keybinds'
L['goToGuildPanelOptionsPanelErr'] = 'An error has occurred, you can access to the section manually:'
L['iconMicroButton'] = 'MicroButton Icon (|cffc90076[*]|r = dynamic, |cffd78900[D]|r = default)'
L['Character Portrait'] = true
L['Class Icon'] = true
L['Profession Icon'] = true
L['Achievement Icon'] = true
L['BFA Achievement Icon'] = true
L['Quest Icon'] = true
L['Guild Emblem'] = true
L['Bigger Guild Emblem'] = true
L['LFD Icon'] = true
L['Collections Icon'] = true
L['EJ Icon'] = true
L['Help Icon'] = true
L['Store Icon'] = true
L['MainMenu Icon'] = true
L['SpellBook Icon'] = true
L['Talents Icon'] = true
L['Classic Quest Icon'] = true
L['Classic Social Icon'] = true
L['Classic MainMenu Icon'] = true
L['Classic Perf-MM Icon'] = true
L['Abilities Icon'] = true
L['Raid Icon'] = true
L['World Icon'] = true
L['SpellBook/Talents Icon'] = true
L['Talents/SpellBook Icon'] = true
L['SB/T Variable Icon'] = true
L['LFD Normalized Icon'] = true
L['PvP Variable Icon'] = true
L['PvP Horde Icon'] = true
L['PvP Alliance Icon'] = true
L['PvP Neutral Icon'] = true
L['Bug Icon'] = true
L['Character Portrait [*]'] = 'Character Portrait |cffc90076[*]|r'
L['Class Icon [*]'] = 'Class Icon |cffc90076[*]|r'
L['Guild Emblem [*]'] = 'Guild Emblem |cffc90076[*]|r'
L['Bigger Guild Emblem [*]'] = 'Bigger Guild Emblem |cffc90076[*]|r'
L['Classic Perf-MM Icon [*]'] = 'Classic Perf-MM Icon |cffc90076[*]|r'
L['SB/T Variable Icon [*]'] = 'SB/T Variable Icon |cffc90076[*]|r'
L['PvP Variable Icon [*]'] = 'PvP Variable Icon |cffc90076[*]|r'
L['Character Portrait [*][D]'] = 'Character Portrait |cffc90076[*]|r|cffe69138[D]|r'
L['Class Icon [*][D]'] = 'Class Icon |cffc90076[*]|r|cffe69138[D]|r'
L['Profession Icon [D]'] = 'Profession Icon |cffe69138[D]|r'
L['Achievement Icon [D]'] = 'Achievement Icon |cffe69138[D]|r'
L['BFA Achievement Icon [D]'] = 'BFA Achievement Icon |cffe69138[D]|r'
L['Quest Icon [D]'] = 'Quest Icon |cffe69138[D]|r'
L['Guild Emblem [*][D]'] = 'Guild Emblem |cffc90076[*]|r|cffe69138[D]|r'
L['Bigger Guild Emblem [*][D]'] = 'Bigger Guild Emblem |cffc90076[*]|r|cffe69138[D]|r'
L['LFD Icon [D]'] = 'LFD Icon |cffe69138[D]|r'
L['Collections Icon [D]'] = 'Collections Icon |cffe69138[D]|r'
L['EJ Icon [D]'] = 'EJ Icon |cffe69138[D]|r'
L['Help Icon [D]'] = 'Help Icon |cffe69138[D]|r'
L['Store Icon [D]'] = 'Store Icon |cffe69138[D]|r'
L['MainMenu Icon [D]'] = 'MainMenu Icon |cffe69138[D]|r'
L['SpellBook Icon [D]'] = 'SpellBook Icon |cffe69138[D]|r'
L['Talents Icon [D]'] = 'Talents Icon |cffe69138[D]|r'
L['Classic Quest Icon [D]'] = 'Classic Quest Icon |cffe69138[D]|r'
L['Classic Social Icon [D]'] = 'Classic Social Icon |cffe69138[D]|r'
L['Classic MainMenu Icon [D]'] = 'Classic MainMenu Icon |cffe69138[D]|r'
L['Classic Perf-MM Icon [*][D]'] = 'Classic Perf-MM Icon |cffc90076[*]|r|cffe69138[D]|r'
L['Abilities Icon [D]'] = 'Abilities Icon |cffe69138[D]|r'
L['Raid Icon [D]'] = 'Raid Icon |cffe69138[D]|r'
L['World Icon [D]'] = 'World Icon |cffe69138[D]|r'
L['SpellBook/Talents Icon [D]'] = 'SpellBook/Talents Icon |cffe69138[D]|r'
L['Talents/SpellBook Icon [D]'] = 'Talents/SpellBook Icon |cffe69138[D]|r'
L['SB/T Variable Icon [*][D]'] = 'SB/T Variable Icon |cffc90076[*]|r|cffe69138[D]|r'
L['LFD Normalized Icon [D]'] = 'LFD Normalized Icon |cffe69138[D]|r'
L['PvP Variable Icon [*][D]'] = 'PvP Variable Icon |cffc90076[*]|r|cffe69138[D]|r'
L['PvP Horde Icon [D]'] = 'PvP Horde Icon |cffe69138[D]|r'
L['PvP Alliance Icon [D]'] = 'PvP Alliance Icon |cffe69138[D]|r'
L['PvP Neutral Icon [D]'] = 'PvP Neutral Icon |cffe69138[D]|r'
L['Bug Icon [D]'] = 'Bug Icon |cffe69138[D]|r'

L['Minimap'] = true
L['QueueButton'] = true
L['QueueButton (LFG)'] = true
L['Bags'] = true
L['BuffAndDebuffFrames'] = true
L['Chat'] = true
L['FreeSlots Counter'] = true
L['ExpansionLandingPage (ELP) Button'] = true
L['AddonCompartment Frame Button'] = true
L['Anchor QueueButton (LFG) to Minimap'] = true
L['Use a big QueueButton (LFG)'] = true
L['xOffsetELPButton'] = true
L['yOffsetELPButton'] = true
L['ScaleELP-DF-Button'] = true
L['ScaleELP-DF-ButtonDesc'] = 'Scale ELP Dragonflight Button (ClassicUI Default: $$**$$)'
L['ScaleELP-TWW-Button'] = true
L['ScaleELP-TWW-ButtonDesc'] = 'Scale ELP The War Within Button (ClassicUI Default: $$**$$)'
L['HideAddonCompartmentDesc'] = 'Hide AddonCompartment Frame Button'
L['xOffsetACFrame'] = true
L['yOffsetACFrame'] = true
L['ScaleACFrame'] = true
L['ScaleACFrameDesc'] = 'Scale AddonCompartment Frame Button (Default: $$**$$)'
L['xOffsetQueueButton'] = true
L['yOffsetQueueButton'] = true
L['Restore the old Minimap'] = true
L['Use the default Big QueueButton (LFG) introduced in Dragonflight'] = true
L['FreeSlots Counter Mod'] = true
L['Select what text is shown in the FreeSlots Counter in the bag'] = true
L['Blizzard-Default - Free slots of All Bags'] = true
L['ClassicUI-Default - Free slots of All Bags excluding the Reagent Bag'] = true
L['Free slots of Normal Bags in one number and free slots of reagent bag in another'] = true
L['Hide the CollapseAndExpandButton'] = true
L['Hide the arrow button to the right of the Buffs that allows to show/hide these Buffs and keeps the Buffs always visible'] = true
L['MailIconPriority'] = 'Mail Icon Priority'
L['MailIconPriorityDesc'] = 'If there are Crafting Orders and Mail pending, only one icon can be shown, select the priority'
L['Default - Crafting Order Icon > Mail Icon'] = true
L['Mail Icon > Crafting Order Icon'] = true
L['Calendar, Mail and Clock Configuration'] = true
L['minimapArrangementType'] = 'Preferred base arrangement type for Minimap elements'
L['minimapArrangementTypeDesc'] = 'Select your preferred arrangement for some Minimap elements. This option will determine their main position. Some of the other options relative to these elements will also be restored to their preferred values, although you can always change them later.'
L['Legion (default)'] = true
L['Legion'] = true
L['Classic'] = true
L['Cataclysm'] = true
L['calendarIconType'] = 'Calendar Icon Type'
L['calendarIconTypeDesc'] = 'Select a dynamic icon type for the Calendar button. The Calendar Icon is the default option for Legion/Cataclysm, the Day/Night Icon is the default option for Classic.'
L['Calendar Icon'] = true
L['Day/Night Icon'] = true
L['calendarIconSize'] = 'Calendar Icon Size'
L['calendarIconSizeDesc'] = 'Select a size for the Calendar Icon Button. 40x40 is the default value for Legion/Cataclysm, 50x50 is the default for Classic.'
L['40x40'] = true
L['50x50'] = true
L['zoomButtonsPositions'] = 'Zoom Buttons Position'
L['zoomButtonsPositionsDesc'] = 'Select the position for the Minimap Zoom Buttons. Position 1 is the default option for Legion, Position 2 is the default option for Classic/TBC, Position 3 is the default option for WotLK/Cataclysm.'
L['Position 1'] = true
L['Position 2'] = true
L['Position 3'] = true
L['useClassicTimeClock'] = 'Use the classic clock'
L['useClassicTimeClockDesc'] = 'Check this option to use the classic clock style on the Minimap'
L['restoreScrollButtons'] = 'Restore Chat Scroll Buttons'
L['restoreScrollButtonsDesc'] = 'Restore the old Chat Arrow Scroll Buttons'
L['restoreBottomScrollButton'] = 'Restore the Bottom Chat Scroll Button'
L['restoreBottomScrollButtonDesc'] = 'Restore the old \'Go to Bottom\' Chat Arrow Scroll Button, which allows you to move the chat scroll directly to the bottom position. Even if this option is selected, this button will only be displayed if the chat window is large enough to fit.'
L['socialButtonToBottom'] = 'Move the Social Button to Bottom'
L['socialButtonToBottomDesc'] = 'Enable this option to move the Social Button to below the Scroll Buttons. With this option disabled the Social Button will be displayed above the Scroll Buttons.'

L['Guild Panel Mode'] = true
L['Defauilt - Show the new social guild panel'] = true
L['Show the old guild panel'] = true
L['Keybinds Visibility'] = true
L['Hide ActionButtons Name'] = true
L['Default - Show all keybinds'] = true
L['Hide completly all keybinds'] = true
L['Hide keybinds but show dot range'] = true
L['Hide keybinds but show a permanent dot range'] = true
L['RedRange & GreyOnCooldown'] = true
L['RedRange'] = true
L['Enable RedRange'] = true
L['GreyOnCooldown'] = true
L['Enable GreyOnCooldown'] = true
L['DesaturateUnusableActions'] = 'Desaturate unusable actions'
L['DesaturateUnusableActionsDesc'] = 'Desaturate unusable actions (such as unlearned talents) regardless of their cooldown status'
L['minDuration'] = true
L['minDurationDesc'] = 'Set the minimum value (in seconds) of the cooldown to be desaturated'
L['LossOfControlUI CC Remover'] = true
L['Enable LossOfControlUI Remover'] = true

L['RELOADUI_MSG'] = '|cffffd200ClassicUI|r\n\n|cffff0000ReloadUI:|r To apply this action an interface reload is needed. If you wish to continue with this operation, push \'Accept\', otherwise push \'Cancel\' or the \'Escape\' key'
L['EXTRA_OPTIONS_DESC'] = 'Some Addons already incorporate these extra features. Before activating any extra functionality in ClassicUI check that no other Addon already performs the same function, otherwise some errors or unexpected behaviours could occur.'
L['EXTRA_FRAMES_DESC'] = 'This addon allows restore/modify some Additional Frames that are not directly related to the Action Bars, such as the Minimap, the PlayerFrame, or the TargetFrame. The options related to these Additional Frames are independent of the rest of the addon and can be enabled/disabled individually and and are taken into account even if the main ClassicUI addon is disabled.'
L['GUILD_PANEL_MODE_OPTIONS_DESC'] = 'This additional functionality allows you to recover the old guild panel. You can select open the old guild panel by means of some access modes (keybind, left, middle or right click on the guild microbutton, ...) and conserve other access modes to continue accessing the new social guild panel. If we are in combat the new social guild panel is always opened because the old guild panel frame is protected by Blizzard and can not be opened in combat.'
L['OPEN_GUILD_PANEL_NORMAL'] = 'Default mode to open guild panel...'
L['OPEN_GUILD_PANEL_NORMAL_DESC'] = 'Select how the default guild panel is opened (when open it with keybind for example)'
L['OPEN_GUILD_PANEL_LEFT_MICROBUTTON_CLICK'] = 'By left clicking the guild microbutton...'
L['OPEN_GUILD_PANEL_LEFT_MICROBUTTON_CLICK_DESC'] = 'Select how the guild panel is opened when you left click the guild microbutton'
L['OPEN_GUILD_PANEL_RIGHT_MICROBUTTON_CLICK'] = 'By right clicking the guild microbutton...'
L['OPEN_GUILD_PANEL_RIGHT_MICROBUTTON_CLICK_DESC'] = 'Select how the guild panel is opened when you right click the guild microbutton'
L['OPEN_GUILD_PANEL_MIDDLE_MICROBUTTON_CLICK'] = 'By middle clicking the guild microbutton...'
L['OPEN_GUILD_PANEL_MIDDLE_MICROBUTTON_CLICK_DESC'] = 'Select how the guild panel is opened when you middle click the guild microbutton'
L['KEYBINDS_VISIBILITY_OPTIONS_DESC'] = 'This extra option allows hide the Keybinds Text from Action Buttons. You can hide keybinds but show the dot range or hide completly all keybinds. You can also select hide the ActionButtons Names.'
L['KEYBINDS_VISIBILITY_OPTIONS_SELECT_DESC'] = 'Select if you want hide the keybinds from action bars'
L['HIDE_ACTIONBUTTONS_NAME_DESC'] = 'Select if you want hide the ActionButtons Names, which is usually shown when a macro is assigned to an ActionButton'
L['REDRANGE_OPTIONS_DESC'] = 'Enable this option to show the entire icon in red when the spell is not at range instead of only show in red the keybind text.'
L['GREYONCOOLDOWN_OPTIONS_DESC'] = 'Enable this option to show the icon desaturated when the spell is on cooldown.'
L['LOSSOFCONTROLUI_OPTION_DESC'] = 'When you suffer a CC effect, the default behaviour of your action bars is to establish a Cooldown according to the time of the CC. This can be annoying for some players. You can enable this extra option to remove the cooldown on bars for CC effects.'
L['MINIMAP_OPTIONS_DESC'] = 'Enable this option to restore the old Minimap. You can control the position of the old restored Minimap with the options provided. If you don\'t use this option and keep the new Modern Minimap, the position and other properties of the Minimap are completely controlled by the game Edit Mode.'
L['CHAT_OPTIONS_DESC'] = 'With these options you can restore old chat features, such as scroll arrows.'
L['CUI_GUILD_PROTECTEDFUNC'] = 'Functionality not available from ClassicUI Guild Panel, please use Blizzard\'s default Guild UI for this action'

L['CLASSICUI_HELP_LINE1'] = 'Available slash commands:'
L['CLASSICUI_HELP_LINE2'] = '-----------------'
L['CLASSICUI_HELP_LINE3'] = '/ClassicUI: Shows the main ClassicUI config panel.'
L['CLASSICUI_HELP_LINE4'] = '/ClassicUI <enable|disable> or /ClassicUI <on|off>: Enable or disable ClassicUI.'
L['CLASSICUI_HELP_LINE5'] = '/ClassicUI extraFrames or /ClassicUI ef: Shows the extra frames ClassicUI config panel.'
L['CLASSICUI_HELP_LINE6'] = '/ClassicUI extraOptions or /ClassicUI eo: Shows the extra options ClassicUI config panel.'
L['CLASSICUI_HELP_LINE7'] = '/ClassicUI forceextraOptions <enable|disable|on|off> or /ClassicUI feo <enable|disable|on|off>: Enable or disable extra options even ClassicUI is disable.'
L['CLASSICUI_HELP_LINE8'] = '/ClassicUI profiles: Shows the profiles ClassicUI config panel.'
L['CLASSICUI_HELP_LINE9'] = '/ClassicUI reset: Resets the current profile to the default values.'
