
scriptName iEquip_RechargeScript extends Quest

import iEquip_SoulSeeker
import iEquip_StringExt
Import WornObject

iEquip_ChargeMeters Property CM Auto

actor Property PlayerRef Auto
sound Property iEquip_Recharge_SFX Auto
Spell property LFX Auto
Spell property RFX Auto
Perk Property Enchanter00 Auto ; Used if Requiem detected - Requiem renames this perk to REQ_Perk_Enchanting_EnchantersInsight1

bool Property bRechargingEnabled = true Auto Hidden
bool Property bUseLargestSoul = true Auto Hidden
bool Property bUsePartFilledGems Auto Hidden
bool Property bAllowOversizedSouls Auto Hidden
bool Property bIsRequiemLoaded Auto Hidden
int property iRechargeFX = 3 auto hidden

bool property bShowNotifications = true auto hidden
bool property bShowGemUseNotifications = true auto hidden

float[] afAmountToRecharge
float[] afSkillPointsToAdd

string[] asSoulNames
string[] asHandNames

event OnInit()
	;debug.trace("iEquip_RechargeScript OnInit start")

	afAmountToRecharge = new float[6]
	afAmountToRecharge[0] = 0.0 ;Empty
	afAmountToRecharge[1] = 250.0 ;Petty
	afAmountToRecharge[2] = 500.0 ;Lesser
	afAmountToRecharge[3] = 1000.0 ;Common
	afAmountToRecharge[4] = 2000.0 ;Greater
	afAmountToRecharge[5] = 3000.0 ;Grand

	afSkillPointsToAdd = new float[6]
	afSkillPointsToAdd[0] = 0.0
	afSkillPointsToAdd[1] = 0.05
	afSkillPointsToAdd[2] = 0.1
	afSkillPointsToAdd[3] = 0.2
	afSkillPointsToAdd[4] = 0.4
	afSkillPointsToAdd[5] = 0.6

    asSoulNames = new string[6]
    asSoulNames[0] = ""
    asSoulNames[1] = iEquip_StringExt.LocalizeString("$iEquip_RC_not_petty")
    asSoulNames[2] = iEquip_StringExt.LocalizeString("$iEquip_RC_not_lesser")
    asSoulNames[3] = iEquip_StringExt.LocalizeString("$iEquip_RC_not_common")
    asSoulNames[4] = iEquip_StringExt.LocalizeString("$iEquip_RC_not_greater")
    asSoulNames[5] = iEquip_StringExt.LocalizeString("$iEquip_RC_not_grand")

    asHandNames = new string[2]
    asHandNames[0] = "$iEquip_common_left"
    asHandNames[1] = "$iEquip_common_right"
    ;debug.trace("iEquip_RechargeScript OnInit end")
endEvent

function onVersionUpdate(float version)
    if version == 1.5
        asHandNames = new string[2]
        asHandNames[0] = "$iEquip_common_left"
        asHandNames[1] = "$iEquip_common_right"
    endIf
endFunction

function rechargeWeapon(int Q)
    ;debug.trace("iEquip_RechargeScript rechargeWeapon start - Q: " + Q)
    form currentItem = PlayerRef.GetEquippedObject(Q)
	if !bRechargingEnabled
		; Do nothing
    elseIf !currentItem
        if bShowNotifications
            debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_RC_not_nothingEquipped{"+asHandNames[Q]+"}"))
        endIf
    elseIf !currentItem as weapon
        if bShowNotifications
            debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_RC_not_notAWeapon{"+asHandNames[Q]+"}"))
        endIf
    elseIf !(currentItem as weapon).GetEnchantment() && !wornobject.GetEnchantment(PlayerRef, Q, 0)
        if bShowNotifications
            debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_RC_not_notEnchanted{"+currentItem.GetName()+"}{"+asHandNames[Q]+"}"))
        endIf
    elseIf bIsRequiemLoaded && !PlayerRef.HasPerk(Enchanter00)
        if bShowNotifications
            debug.notification(iEquip_StringExt.LocalizeString("$iEquip_RequiemEnchantingPerkMissing"))
        endIf
    else
        string weaponToRecharge = CM.asItemCharge[Q]
        float currentCharge = PlayerRef.GetActorValue(weaponToRecharge)
        float maxCharge = WornObject.GetItemMaxCharge(PlayerRef, Q, 0)
        float requiredCharge = maxCharge - currentCharge

        ;debug.trace("iEquip_RechargeScript rechargeWeapon - maxCharge: " + maxCharge + ", currentCharge: " + currentCharge + ", requiredCharge: " + requiredCharge)
        if requiredCharge < 1.0
            if bShowNotifications
                debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_RC_not_alreadyFull{"+currentItem.GetName()+"}{"+asHandNames[Q]+"}"))
            endIf
        else
            int requiredSoul = getRequiredSoul(Q, requiredCharge)
            if requiredSoul > 0
                int soulSize = iEquip_SoulSeeker.bringMeASoul(requiredSoul, bUseLargestSoul as int, bUsePartFilledGems, bAllowOversizedSouls)
                ;debug.trace("iEquip_RechargeScript rechargeWeapon - bringMeASoul returned me a size " + soulSize + " soul")
                if soulSize > 0
                    if iRechargeFX == 1 || iRechargeFX == 3
                        iEquip_Recharge_SFX.Play(PlayerRef)
                    endIf
                    if PlayerRef.IsWeaponDrawn() && iRechargeFX > 1
                        if Q == 0 || PlayerRef.GetEquippedItemType(0) == 7
    						LFX.cast(PlayerRef, PlayerRef)
                        else
    						RFX.cast(PlayerRef, PlayerRef)
                        endIf
                    endIf
                    ;Just in case it's possible to overcharge a weapon ensure we never recharge more than requiredCharge
                    if afAmountToRecharge[soulSize] < requiredCharge
                        PlayerRef.ModActorValue(weaponToRecharge, afAmountToRecharge[soulSize])
                    else
                        PlayerRef.ModActorValue(weaponToRecharge, requiredCharge)
                    endIf
                    game.AdvanceSkill("Enchanting", afSkillPointsToAdd[soulSize])
                    if bShowGemUseNotifications
                        debug.Notification(asSoulNames[soulSize])
                    endIf
                    CM.checkAndUpdateChargeMeter(Q, true)
                elseif bShowGemUseNotifications
                    debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_RC_not_noSoul"))
                endIf
            endIf
        endIf
    endIf
    ;debug.trace("iEquip_RechargeScript rechargeWeapon end")
endFunction

int function getRequiredSoul(int Q, float requiredCharge)
    ;debug.trace("iEquip_RechargeScript getRequiredSoul start - Q: " + Q)
    int bestFitSoul
    if requiredCharge > 0
        if requiredCharge < 251.0
        	bestFitSoul = 1 ;Petty
        elseIf requiredCharge < 501.0
        	bestFitSoul = 2 ;Lesser
        elseIf requiredCharge < 1001.0
        	bestFitSoul = 3 ;Common
        elseIf requiredCharge < 2001.0
        	bestFitSoul = 4 ;Greater
        else
        	bestFitSoul = 5 ;Grand
        endIf
    endIf
    if bestFitSoul > 1 && !bAllowOversizedSouls
        bestFitSoul -= 1
    endIf
    ;debug.trace("iEquip_RechargeScript getRequiredSoul - returning bestFitSoul: " + bestFitSoul)
    return bestFitSoul
endFunction    
