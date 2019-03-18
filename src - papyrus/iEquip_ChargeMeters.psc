
scriptname iEquip_ChargeMeters extends quest

import UI
import UICallback
Import WornObject
Import iEquip_WeaponExt

iEquip_WidgetCore Property WC Auto
iEquip_LeftChargeMeterUpdateScript Property LU Auto
iEquip_RightChargeMeterUpdateScript Property RU Auto

Actor Property PlayerRef Auto

; PRIVATE VARIABLES -------------------------------------------------------------------------------
String HUD_MENU = "HUD Menu"
String WidgetRoot
float[] afCurrCharge

; PROPERTIES --------------------------------------------------------------------------------------
int property iPrimaryFillColor = 0x8C9EC2 auto hidden
int property iLowChargeFillColor = 0xFF0000 auto hidden
int property iSecondaryFillColor	= -1 auto hidden ;Only used if a gradient fill is required
int	property iFlashColor = -1 auto hidden ;White by default
int property iChargeDisplayType = 1 auto Hidden ; 0 = None, 1 = Charge meters, 2 = Dynamic soulgems
bool property bChargeFadeoutEnabled auto hidden
bool property bCustomFlashColor auto hidden
bool property bEnableLowCharge = true auto hidden
bool property bEnableGradientFill = false auto hidden
float property fChargeFadeoutDelay = 5.0 auto hidden
float property fLowChargeThreshold = 0.20 auto hidden
bool[] property abIsChargeMeterShown auto hidden
string[] property asMeterFillDirection auto hidden
string[] property asItemCharge auto hidden

bool property bSettingsChanged auto hidden

; EVENTS ------------------------------------------------------------------------------------------
event OnInit()
	debug.trace("iEquip_ChargeMeters OnInit start")
	abIsChargeMeterShown = new bool[2]

	asMeterFillDirection = new string[2]
	asMeterFillDirection[0] = "left"
	asMeterFillDirection[1] = "right"

	afCurrCharge = new float[2]

	asItemCharge = new string[2]
	asItemCharge[0] = "LeftItemCharge"
	asItemCharge[1] = "RightItemCharge"
	debug.trace("iEquip_ChargeMeters OnInit end")
endEvent

function OnWidgetLoad() ;Called from WidgetCore
	debug.trace("iEquip_ChargeMeters OnWidgetLoad start")
	WidgetRoot = WC.WidgetRoot
	debug.trace("iEquip_ChargeMeters OnWidgetLoad end")
endFunction

; FUNCTIONS ---------------------------------------------------------------------------------------

function initChargeMeter(int Q)
	debug.trace("iEquip_ChargeMeters initChargeMeter start")
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".initChargeMeter")	
	If(iHandle)
		debug.trace("iEquip_ChargeMeters initChargeMeter - got iHandle for .initChargeMeter")
		UICallback.PushInt(iHandle, Q)
		UICallback.PushFloat(iHandle, 250.0)
		UICallback.PushFloat(iHandle, 30.6)
		UICallback.PushInt(iHandle, iPrimaryFillColor)
		UICallback.PushInt(iHandle, -1)
		UICallback.PushInt(iHandle, -1)
		UICallback.PushFloat(iHandle, 1.0)	
		UICallback.PushString(iHandle, asMeterFillDirection[Q])	
		UICallback.PushBool(iHandle, true)
		UICallback.PushBool(iHandle, abIsChargeMeterShown[Q])
		UICallback.Send(iHandle)
	endIf
	debug.trace("iEquip_ChargeMeters initChargeMeter end")
endFunction

function initSoulGem(int Q)
	debug.trace("iEquip_ChargeMeters initSoulGem start")
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".initSoulGem")	
	If(iHandle)
		debug.trace("iEquip_ChargeMeters initSoulGem - got iHandle for .initSoulGem")
		UICallback.PushInt(iHandle, Q)
		UICallback.PushInt(iHandle, iPrimaryFillColor)
		UICallback.PushInt(iHandle, -1)
		UICallback.PushFloat(iHandle, 1.0)	
		UICallback.PushBool(iHandle, true)
		UICallback.PushBool(iHandle, abIsChargeMeterShown[Q])
		UICallback.Send(iHandle)
	endIf
	debug.trace("iEquip_ChargeMeters initSoulGem end")
endFunction

function updateMeterPercent(int Q, bool forceUpdate = false, bool skipFlash = false) ;Sets the meter percent, a_force sets the meter percent without animation
	debug.trace("iEquip_ChargeMeters updateMeterPercent start")
	debug.trace("iEquip_ChargeMeters updateMeterPercent - Q: " + Q + ", asItemCharge[Q]: " + asItemCharge[Q] + ", forceUpdate: " + forceUpdate + ", skipFlash: " + skipFlash)
	float currentCharge = PlayerRef.GetActorValue(asItemCharge[Q])
	float maxCharge = WornObject.GetItemMaxCharge(PlayerRef, Q, 0)
	float currPercent
	if maxCharge > 0.0 && currentCharge > 0.0
		currPercent = currentCharge / maxCharge
	endIf
	debug.trace("iEquip_ChargeMeters updateMeterPercent - currentCharge: " + currentCharge + ", maxCharge: " + maxCharge + ", currPercent: " + currPercent + ". fLowChargeThreshold: " + fLowChargeThreshold)
	if (currPercent != afCurrCharge[Q]) || forceUpdate
		afCurrCharge[Q] = currPercent
		int fillColor = iPrimaryFillColor
		if bEnableLowCharge && (currPercent <= fLowChargeThreshold)
			fillColor = iLowChargeFillColor
		endIf
		int iHandle
		if iChargeDisplayType == 1
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setChargeMeterPercent")
		elseIf iChargeDisplayType == 2
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setSoulGemPercent")
		endIf
		If(iHandle)
			UICallback.PushInt(iHandle, Q)
			UICallback.PushFloat(iHandle, currPercent)
			UICallback.PushInt(iHandle, fillColor)
			if iChargeDisplayType == 1
				UICallback.PushBool(iHandle, bEnableGradientFill)
				UICallback.PushInt(iHandle, iSecondaryFillColor)
			endIf
			UICallback.PushBool(iHandle, true)
			UICallback.Send(iHandle)
		endIf
		if currPercent <= fLowChargeThreshold
			if !WC.bIsWidgetShown
				WC.updateWidgetVisibility()
			endIf
			if !abIsChargeMeterShown[Q]
				updateChargeMeterVisibility(Q, true)
			endIf
		endIf
		if !skipFlash && currPercent < 0.01
			startMeterFlash(Q, true)
		endIf
	endIf
	debug.trace("iEquip_ChargeMeters updateMeterPercent end")
endFunction

function startMeterFlash(int Q, bool forceFlash = false) ; Starts meter flashing. forceFlash starts the meter flashing if it's already animating
	debug.trace("iEquip_ChargeMeters startMeterFlash start")
	debug.trace("iEquip_ChargeMeters startMeterFlash - Q: " + Q)
	int iHandle
	if iChargeDisplayType == 1
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".startChargeMeterFlash")
	elseIf iChargeDisplayType == 2
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".startSoulGemFlash")
	endIf
	If(iHandle)
		UICallback.PushInt(iHandle, Q)
		UICallback.PushInt(iHandle, iFlashColor)
		UICallback.PushBool(iHandle, forceFlash)
		UICallback.Send(iHandle)
	endIf
	debug.trace("iEquip_ChargeMeters startMeterFlash end")
endFunction

function updateChargeMeters(bool forceUpdate = false)
	debug.trace("iEquip_ChargeMeters updateChargeMeters start")
	debug.trace("iEquip_ChargeMeters updateChargeMeters - forceUpdate: " + forceUpdate)
	int Q
	if iChargeDisplayType > 0
		while Q < 2
			;Force both meters and both gems to hide first then call checkAndUpdate to reshow the relevant one if required
			updateChargeMeterVisibility(Q, false, true) ;hideMeters
			updateChargeMeterVisibility(Q, false, false, true) ;hideGems
			checkAndUpdateChargeMeter(Q, forceUpdate)
			Q += 1
		endWhile
	else
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[13] + "._visible", false) ;leftEnchantmentMeter_mc
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[14] + "._visible", false) ;leftSoulgem_mc
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[27] + "._visible", false) ;rightEnchantmentMeter_mc
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[28] + "._visible", false) ;rightSoulgem_mc
	endIf
	debug.trace("iEquip_ChargeMeters updateChargeMeters end")
endFunction

function updateChargeMetersOnWeaponsDrawn()
	debug.trace("iEquip_ChargeMeters updateChargeMetersOnWeaponsDrawn start")
	int Q
	while Q < 2
		checkAndUpdateChargeMeter(Q, true)
		Q += 1
	endWhile
	debug.trace("iEquip_ChargeMeters updateChargeMetersOnWeaponsDrawn end")
endFunction

function checkAndUpdateChargeMeter(int Q, bool forceUpdate = false)
	debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter start")
	debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - Q: " + Q + ", forceUpdate: " + forceUpdate + ", weapons drawn: " + PlayerRef.IsWeaponDrawn())
	if !PlayerRef.IsWeaponDrawn()
		Utility.WaitMenuMode(0.2)
	endIf
	if PlayerRef.IsWeaponDrawn()
		int isEnchanted
		bool isLeftHand = !(Q as bool)
		weapon currentWeapon = PlayerRef.GetEquippedWeapon(isLeftHand)
		bool isBound
		if currentWeapon
			isBound = iEquip_WeaponExt.IsWeaponBound(currentWeapon)
			debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - weapon name: " + currentWeapon.GetName() + ", isBound: " + isBound)
		endIf
		enchantment currentEnchantment
		if currentWeapon && !isBound
			debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - Q: " + Q + ", isLeftHand: " + isLeftHand + ", currentWeapon: " + currentWeapon.GetName())
			currentEnchantment = currentWeapon.GetEnchantment()
			if !currentEnchantment
				currentEnchantment = wornobject.GetEnchantment(PlayerRef, Q, 0)
			endIf
			if currentEnchantment
				debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - Q: " + Q + ", currentEnchantment: " + currentEnchantment.GetName())
				isEnchanted = 1
			endIf
		endIf
		debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - isEnchanted: " + isEnchanted + ", isBound: " + isBound + ", abIsChargeMeterShown[" + Q + "]: " + abIsChargeMeterShown[Q])
		;Hide first
		if abIsChargeMeterShown[Q]
			updateChargeMeterVisibility(Q, false) ;Hide
		endIf
		;Now as long as meters aren't disabled, and the item is enchanted, and it's not an infinite charge item carry on and update the meters
		if iChargeDisplayType > 0 && isEnchanted == 1 && WornObject.GetItemMaxCharge(PlayerRef, Q, 0) > 0.0
			;Update values
			updateMeterPercent(Q, forceUpdate, true)
			if iChargeDisplayType == 1
				int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setChargeMeterFillDirection")	
				if(iHandle)
					debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - got iHandle for .setChargeMeterFillDirection, Q: " + Q + ", fill direction: " + asMeterFillDirection[Q])
					UICallback.PushInt(iHandle, Q)
					UICallback.PushString(iHandle, asMeterFillDirection[Q])
					UICallback.Send(iHandle)
				endIf
			endIf
			;Show meter
			updateChargeMeterVisibility(Q, true)
			;Flash if empty
			if PlayerRef.GetActorValue(asItemCharge[Q]) < 1
				startMeterFlash(Q, true)
			endIf
		endIf
		;Now update the object keys for the currently equipped item in case anything has changed since we last equipped it
		if currentEnchantment
			jMap.setForm(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "lastKnownEnchantment", currentEnchantment as Form)
		endIf
		jMap.setInt(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "isEnchanted", isEnchanted)
	else
		WC.EH.bWaitingForEnchantedWeaponDrawn = true
	endIf
	debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter end")
endFunction

function updateChargeMeterVisibility(int Q, bool show, bool hideMeters = false, bool hideGems = false)
	debug.trace("iEquip_ChargeMeters updateChargeMeterVisibility start")
	debug.trace("iEquip_ChargeMeters updateChargeMeterVisibility - Q: " + Q + ", show: " + show)
	int element
	int iHandle
	if hideMeters || (iChargeDisplayType == 1 && !hideGems)
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenChargeMeterAlpha")
		element = 13 ;leftEnchantmentMeter_mc
		if Q == 1
			element = 27 ;rightEnchantmentMeter_mc
		endIf
	else
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenSoulGemAlpha")	
		element = 14 ;leftSoulgem_mc
		if Q == 1
			element = 28 ;rightSoulgem_mc
		endIf
	endIf
	float targetAlpha
	if show
		;Just in case the charge meter and the queue position indicator occupy the same screen space hide the position indicator first (does nothing if not currently shown)
		if iChargeDisplayType == 1
			UI.invokeInt(HUD_MENU, WidgetRoot + ".hideQueuePositionIndicator", Q)
		endIf
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[element] + "._visible", true)
		targetAlpha = WC.afWidget_A[element]
		abIsChargeMeterShown[Q] = true
	else
		targetAlpha = 0.0
		abIsChargeMeterShown[Q] = false
	endIf
	If(iHandle)
		UICallback.PushInt(iHandle, Q)
		UICallback.PushFloat(iHandle, targetAlpha)
		UICallback.Send(iHandle)
	endIf
	if show
		if bChargeFadeoutEnabled && (fChargeFadeoutDelay > 0) && (afCurrCharge[Q] > fLowChargeThreshold)
			if Q == 0
				LU.registerForMeterFadeoutUpdate(Q, iChargeDisplayType, fChargeFadeoutDelay)
			else
				RU.registerForMeterFadeoutUpdate(Q, iChargeDisplayType, fChargeFadeoutDelay)
			endIf
		endIf
	else
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[element] + "._visible", false)
	endIf
	debug.trace("iEquip_ChargeMeters updateChargeMeterVisibility end")
endFunction

