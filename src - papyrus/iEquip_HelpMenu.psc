ScriptName iEquip_HelpMenu Extends Quest

Actor property PlayerRef auto

Message property iEquip_HelpMenuMain Auto
Message property iEquip_HelpMenuProMode Auto
Message property iEquip_MessageNextPageExit Auto

Quest property iEquip_MessageQuest auto ; populated by CK
ReferenceAlias property iEquip_MessageAlias auto ; populated by CK, but Alias is filled by script, not by CK
MiscObject property iEquip_MessageObject auto ; populated by CK
ObjectReference property iEquip_MessageObjectReference auto ; populated by script

function showHelpMenuMain()
    bool bShowAgain = true
    
    while bShowAgain
        int iAction = iEquip_HelpMenuMain.Show()      
        
        if iAction != 7             ; Exit
            if iAction == 0         ; Controls
                iAction = showHelpPage("$iEquip_help_controls1")
                if iAction == 0
                    iAction = showHelpPage("$iEquip_help_controls2")
                    if iAction == 0
                        iAction = showHelpPage("$iEquip_help_controls3")
                        if iAction == 0
                            debug.MessageBox("$iEquip_help_controls4")
                        endIf
                    endIf
                endIf

            elseif iAction == 1     ; Adding Items
                iAction = showHelpPage("$iEquip_help_addingItems1")
                if iAction == 0
                    debug.MessageBox("$iEquip_help_addingItems2")
                endIf
            
            elseif iAction == 2     ; Ammo Mode
                iAction = showHelpPage("$iEquip_help_AmmoMode1")
                if iAction == 0
                    debug.MessageBox("$iEquip_help_AmmoMode2")
                endIf
            
            elseif iAction == 3     ; Recharging
                iAction = showHelpPage("$iEquip_help_recharging1")
                if iAction == 0
                    debug.MessageBox("$iEquip_help_recharging2")
                endIf
            
            elseif iAction == 4     ; Using Poisons
                iAction = showHelpPage("$iEquip_help_poisoning1")
                if iAction == 0
                    debug.MessageBox("$iEquip_help_poisoning2")
                endIf
            
            elseif iAction == 5     ; Potion Groups
                debug.MessageBox("$iEquip_help_potionGroups")
            
            elseif iAction == 6     ; Pro Mode
                bShowAgain = showHelpMenuProMode()
            endIf
        else
            bShowAgain = false
        endIf
    endWhile
endFunction

bool function showHelpMenuProMode() ; Return false to exit
    bool bShowAgain = true
    bool bShowAgainMain = true
    
    while bShowAgain
        int iAction = iEquip_HelpMenuProMode.Show()
        
        if iAction  != 6            ; Exit
            
            if iAction == 0         ; Back
                bShowAgain = false
            elseif iAction == 1     ; Preselect
                iAction = showHelpPage("$iEquip_help_preselect1")
                if iAction == 0
                    iAction = showHelpPage("$iEquip_help_preselect2")
                    if iAction == 0
                        debug.MessageBox("$iEquip_help_preselect3")
                    endIf
                endIf
            
            elseif iAction == 2     ; QuickRanged
                debug.MessageBox("$iEquip_help_quickranged")
            
            elseif iAction == 3     ; QuickShield
                iAction = showHelpPage("$iEquip_help_quickshield1")
                if iAction == 0
                    iAction = showHelpPage("$iEquip_help_quickshield2")
                    if iAction == 0
                        debug.MessageBox("$iEquip_help_quickshield3")
                    endIf
                endIf
            
            elseif iAction == 4     ; QuickHeal
                iAction = showHelpPage("$iEquip_help_quickheal1")
                if iAction == 0
                    debug.MessageBox("$iEquip_help_quickheal2")
                endIf

            elseif iAction == 4     ; QuickDualCast
                debug.MessageBox("$iEquip_help_quickdualcast")
            endIf
        else
            bShowAgain = false
            bShowAgainMain = false
        endIf
    endWhile
    
    return bShowAgainMain
endFunction

int function showHelpPage(string theString)
    iEquip_MessageObjectReference = PlayerRef.PlaceAtMe(iEquip_MessageObject)
    iEquip_MessageAlias.ForceRefTo(iEquip_MessageObjectReference)
    iEquip_MessageAlias.GetReference().GetBaseObject().SetName(theString)
    int iButton = iEquip_MessageNextPageExit.Show()
    iEquip_MessageAlias.Clear()
    iEquip_MessageObjectReference.Disable()
    iEquip_MessageObjectReference.Delete()
    return iButton
endFunction