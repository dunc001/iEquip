
Scriptname iEquip_PlayerEventHandler extends ReferenceAlias

Import iEquip_FormExt
import iEquip_ActorExt
import iEquip_SpellExt
import iEquip_StringExt
import iEquip_InventoryExt
Import Utility
import UI
import AhzMoreHudIE

iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto
iEquip_ProMode Property PM Auto
iEquip_BeastMode Property BM Auto
iEquip_KeyHandler Property KH Auto
iEquip_PotionScript Property PO Auto
iEquip_RechargeScript Property RC Auto
iEquip_ChargeMeters Property CM Auto
iEquip_TemperedItemHandler Property TI Auto
iEquip_InventoryEventsListener Property IE Auto
iEquip_BoundWeaponEventsListener Property BW Auto
iEquip_WidgetVisUpdateScript property WVis auto
iEquip_TorchScript property TO auto
iEquip_ThrowingPoisons property TP auto
iEquip_TempItemCleanupUpdateScript property CU auto

string HUD_MENU = "HUD Menu"
string WidgetRoot

Actor Property PlayerRef Auto
Race property PlayerRace auto hidden

Keyword Property CraftingSmithingSharpeningWheel Auto
Keyword Property CraftingSmithingArmorTable Auto

form property Unarmed auto ; 1F4 Unarmed

light property iEquipTorch auto

weapon property iEquip_ThrowingPoisonWeapon auto

Race PlayerBaseRace

Race Property ArgonianRace auto
Race Property ArgonianRaceVampire auto
Race Property BretonRace auto
Race Property BretonRaceVampire auto
Race Property DarkElfRace auto
Race Property DarkElfRaceVampire auto
Race Property HighElfRace auto
Race Property HighElfRaceVampire auto
Race Property ImperialRace auto
Race Property ImperialRaceVampire auto
Race Property KhajiitRace auto
Race Property KhajiitRaceVampire auto
Race Property NordRace auto
Race Property NordRaceVampire auto
Race Property OrcRace auto
Race Property OrcRaceVampire auto
Race Property RedguardRace auto
Race Property RedguardRaceVampire auto
Race Property WoodElfRace auto
Race Property WoodElfRaceVampire auto

Race[] Property aPlayerBaseRaces auto Hidden
Race[] Property aPlayerBaseVampireRaces auto Hidden

; The Path of Transcendence Lich race properties
Race[] Property aPlayerBasePOTLichRaces auto Hidden

bool bPlayerRaceConfirmed

; Werewolf reference - Vanilla - populated in CK
race property WerewolfBeastRace auto

FormList property iEquip_AllCurrentItemsFLST Auto
FormList property iEquip_AmmoItemsFLST Auto
FormList property iEquip_PotionItemsFLST Auto

Formlist[] property blackListFLSTs auto hidden

Formlist Property iEquip_LeftHandBlacklistFLST Auto
Formlist Property iEquip_RightHandBlacklistFLST Auto
Formlist Property iEquip_GeneralBlacklistFLST Auto ;Shout, Consumable and Poison Queues

FormList Property iEquip_OnObjectEquippedFLST Auto

bool property bPoisonSlotEnabled = true auto hidden
bool bIsBoundSpellEquipped
bool property bWaitingForEnchantedWeaponDrawn auto hidden
bool bWaitingForAnimationUpdate
bool bWaitingForOnObjectEquippedUpdate
bool bWaitingForOnObjectUnequippedUpdate
bool  property bProcessingQueuedForms auto hidden

bool property bIsThunderchildLoaded auto hidden
bool property bIsWintersunLoaded auto hidden
bool property bPlayerIsMeditating auto hidden
bool property bDualCasting auto hidden
bool property bGoingUnarmed auto hidden
bool property bTogglingAmmoMode auto hidden

int dualCastCounter

bool property bAutoAddNewItems auto hidden
bool property bAutoAddShouts auto hidden
bool property bAutoAddPowers auto hidden

bool property bPlayerIsABeast auto hidden
bool property bPlayerIsAVampireOrLich auto hidden
bool property bWaitingForTransform auto hidden

bool[] property abSkipQueueObjectUpdate auto hidden

bool property bRealTimeStaffMeters = true auto hidden

bool property bVanillaHorses = false auto hidden
bool property bRelevantItemsOnlyWhileDragonRiding = true auto hidden

bool property bIsItemDurabilityFound auto hidden

int iSlotToUpdate = -1
int[] itemTypesToProcess
int[] specificHandedItems

Event OnInit()
	;debug.trace("iEquip_PlayerEventHandler OnInit start")
    
    aPlayerBaseRaces = new race[10]
    aPlayerBaseRaces[0] = ArgonianRace
    aPlayerBaseRaces[1] = BretonRace
    aPlayerBaseRaces[2] = DarkElfRace
    aPlayerBaseRaces[3] = HighElfRace
    aPlayerBaseRaces[4] = ImperialRace
    aPlayerBaseRaces[5] = KhajiitRace
    aPlayerBaseRaces[6] = NordRace
    aPlayerBaseRaces[7] = OrcRace
    aPlayerBaseRaces[8] = RedguardRace
    aPlayerBaseRaces[9] = WoodElfRace

    aPlayerBaseVampireRaces = new race[10]
    aPlayerBaseVampireRaces[0] = ArgonianRaceVampire
    aPlayerBaseVampireRaces[1] = BretonRaceVampire
    aPlayerBaseVampireRaces[2] = DarkElfRaceVampire
    aPlayerBaseVampireRaces[3] = HighElfRaceVampire
    aPlayerBaseVampireRaces[4] = ImperialRaceVampire
    aPlayerBaseVampireRaces[5] = KhajiitRaceVampire
    aPlayerBaseVampireRaces[6] = NordRaceVampire
    aPlayerBaseVampireRaces[7] = OrcRaceVampire
    aPlayerBaseVampireRaces[8] = RedguardRaceVampire
    aPlayerBaseVampireRaces[9] = WoodElfRaceVampire

    aPlayerBasePOTLichRaces = new race[10]

    itemTypesToProcess = new int[6]
	itemTypesToProcess[0] = 22 			; Spells or shouts
	itemTypesToProcess[1] = 23 			; Scrolls
	itemTypesToProcess[2] = 31 			; Torches
	itemTypesToProcess[3] = 41 			; Weapons
	itemTypesToProcess[4] = 42 			; Ammo
	itemTypesToProcess[5] = 119 		; Powers

	specificHandedItems = new int[6]
	specificHandedItems[0] = 5 			; Greatswords
	specificHandedItems[1] = 6			; Battleaxes & Warhammers
	specificHandedItems[2] = 7			; Bows
	specificHandedItems[3] = 9			; Crossbows
	specificHandedItems[4] = 26			; Shields
	specificHandedItems[5] = 31			; Torches

	blackListFLSTs = new formlist[3]
	blackListFLSTs[0] = iEquip_LeftHandBlacklistFLST
	blackListFLSTs[1] = iEquip_RightHandBlacklistFLST
	blackListFLSTs[2] = iEquip_GeneralBlacklistFLST

	abSkipQueueObjectUpdate = new bool[2]

	;debug.trace("iEquip_PlayerEventHandler OnInit end")
endEvent

Event OnPlayerLoadGame()
	;debug.trace("iEquip_PlayerEventHandler OnPlayerLoadGame start")
	bool bSafeToInit = WC.isEnabled
	if !JContainers.isInstalled()                                               ; Dependency checks
        debug.messagebox("$iEquip_MCM_gen_mes_jcontmissing")
        bSafeToInit = false
    elseIf !(JContainers.APIVersion() >= 4 && JContainers.featureVersion() >= 1)
        debug.messagebox("$iEquip_MCM_gen_mes_jcontoldversion")
        bSafeToInit = false
    else
		initialise(bSafeToInit)
	endIf
	;debug.trace("iEquip_PlayerEventHandler OnPlayerLoadGame end")
endEvent

function initialise(bool enabled)
	;debug.trace("iEquip_PlayerEventHandler initialise start")	
	if enabled
		gotoState("")
		WidgetRoot = WC.WidgetRoot
		PlayerRace = PlayerRef.GetRace()
		PlayerBaseRace = iEquip_ActorExt.GetBaseRace(PlayerRef)

		if Game.GetModByName("The Path of Transcendence.esp") != 255
			;bPOTLoaded = true
			aPlayerBasePOTLichRaces[0] = Game.GetFormFromFile(0x0024F487, "The Path of Transcendence.esp") as Race 	; POT_ArgonianRaceLich
			aPlayerBasePOTLichRaces[1] = Game.GetFormFromFile(0x0024A378, "The Path of Transcendence.esp") as Race 	; POT_BretonRaceLich
			aPlayerBasePOTLichRaces[2] = Game.GetFormFromFile(0x00240167, "The Path of Transcendence.esp") as Race 	; POT_DarkElfRaceLich
			aPlayerBasePOTLichRaces[3] = Game.GetFormFromFile(0x0024F47D, "The Path of Transcendence.esp") as Race 	; POT_HighElfRaceLich
			aPlayerBasePOTLichRaces[4] = Game.GetFormFromFile(0x00240166, "The Path of Transcendence.esp") as Race 	; POT_ImperialRaceLich
			aPlayerBasePOTLichRaces[5] = Game.GetFormFromFile(0x0024F486, "The Path of Transcendence.esp") as Race 	; POT_KhajiitRaceLich
			aPlayerBasePOTLichRaces[7] = Game.GetFormFromFile(0x0022BD61, "The Path of Transcendence.esp") as Race 	; POT_NordRaceLich
			aPlayerBasePOTLichRaces[7] = Game.GetFormFromFile(0x0024F47E, "The Path of Transcendence.esp") as Race 	; POT_OrcRaceLich
			aPlayerBasePOTLichRaces[8] = Game.GetFormFromFile(0x0024A379, "The Path of Transcendence.esp") as Race 	; POT_RedguardRaceLich
			aPlayerBasePOTLichRaces[9] = Game.GetFormFromFile(0x0024F482, "The Path of Transcendence.esp") as Race 	; POT_WoodElfRaceLich
		else
			;bPOTLoaded = false
			aPlayerBasePOTLichRaces[0] = none
			aPlayerBasePOTLichRaces[1] = none
			aPlayerBasePOTLichRaces[2] = none
			aPlayerBasePOTLichRaces[3] = none
			aPlayerBasePOTLichRaces[4] = none
			aPlayerBasePOTLichRaces[5] = none
			aPlayerBasePOTLichRaces[6] = none
			aPlayerBasePOTLichRaces[7] = none
			aPlayerBasePOTLichRaces[8] = none
			aPlayerBasePOTLichRaces[9] = none
		endIf

		BM.initialise()
		BM.PlayerBaseRace = PlayerBaseRace
		bPlayerIsAVampireOrLich = ((aPlayerBaseRaces.Find(PlayerBaseRace) == aPlayerBaseVampireRaces.Find(PlayerRace)) || (aPlayerBaseRaces.Find(PlayerBaseRace) == aPlayerBasePOTLichRaces.Find(PlayerRace)))
		bPlayerIsABeast = (BM.arBeastRaces.Find(PlayerRace) > -1)
		;debug.trace("iEquip_PlayerEventHandler initialise - current PlayerRace: " + PlayerRace.GetName() + ", original race: " + PlayerBaseRace.GetName() + ", bPlayerIsABeast: " + bPlayerIsABeast)
		
		if bPlayerIsABeast
			registerForBMEvents()
		elseIf PlayerRace == PlayerBaseRace || bPlayerIsAVampireOrLich
			registerForCoreAnimationEvents()
			registerForCoreActorActions()
		endIf

		RegisterForCameraState()
		
		PO.initialise()
		TI.initialise()
		updateAllEventFilters()
	else
		gotoState("DISABLED")
		UnregisterForAllEvents()
	endIf

	IE.initialise(enabled)	
	BW.initialise(enabled)
	TO.initialise(enabled)

	;debug.trace("iEquip_PlayerEventHandler initialise end")
endFunction

function registerForCoreAnimationEvents()
	if bIsThunderchildLoaded || bIsWintersunLoaded
		RegisterForAnimationEvent(PlayerRef, "IdleChairSitting")
		RegisterForAnimationEvent(PlayerRef, "idleChairGetUp")
	endIf
	RegisterForAnimationEvent(PlayerRef, "weaponSwing")
	RegisterForAnimationEvent(PlayerRef, "weaponLeftSwing")
	RegisterForAnimationEvent(PlayerRef, "arrowRelease")
	RegisterForAnimationEvent(PlayerRef, "bashStart")
	RegisterForAnimationEvent(PlayerRef, "bashStop")
	RegisterForAnimationEvent(PlayerRef, "SoundPlay.NPCHumanCombatShieldBash")
	RegisterForAnimationEvent(PlayerRef, "CastStop")
	;Listeners for the beast form transformation sAttributes
	RegisterForAnimationEvent(PlayerRef, "SetRace")
	RegisterForAnimationEvent(PlayerRef, "Soundplay.NPCWerewolfTransformation")
	RegisterForAnimationEvent(PlayerRef, "SoundPlay.NPCHorseMount")
	RegisterForAnimationEvent(PlayerRef, "SoundPlay.NPCHorseDismount")
	RegisterForAnimationEvent(PlayerRef, "HorseEnter")
	RegisterForAnimationEvent(PlayerRef, "HorseEnterInstant")
	RegisterForAnimationEvent(PlayerRef, "HorseEnterSwim")
	RegisterForAnimationEvent(PlayerRef, "HorseExitOut")
	RegisterForAnimationEvent(PlayerRef, "DragonMountEnter")
	RegisterForAnimationEvent(PlayerRef, "DragonMountEnterInstant")
	RegisterForAnimationEvent(PlayerRef, "DragonMountExitOut")
	RegisterForAnimationEvent(PlayerRef, "WerewolfTransformation ")
	RegisterForAnimationEvent(PlayerRef, "VampireLordChangePlayer ")
	RegisterForAnimationEvent(PlayerRef, "pa_VampireLordChangePlayer")
	RegisterForAnimationEvent(PlayerRef, "RemoveCharacterControllerFromWorld")
endFunction

function registerForCoreActorActions()
	RegisterForActorAction(2) ;Spell fire - spells and staves
	RegisterForActorAction(7) ;Draw Begin - weapons only, not spells
	RegisterForActorAction(8) ;Draw End - weapons and spells
	RegisterForActorAction(10) ;Sheathe End - weapons and spells
endFunction

function unregisterForCoreAnimationEvents()
	if bIsThunderchildLoaded || bIsWintersunLoaded
		UnRegisterForAnimationEvent(PlayerRef, "IdleChairSitting")
		UnRegisterForAnimationEvent(PlayerRef, "idleChairGetUp")
	endIf
	UnRegisterForAnimationEvent(PlayerRef, "weaponSwing")
	UnRegisterForAnimationEvent(PlayerRef, "weaponLeftSwing")
	UnRegisterForAnimationEvent(PlayerRef, "arrowRelease")
	UnRegisterForAnimationEvent(PlayerRef, "bashStart")
	UnRegisterForAnimationEvent(PlayerRef, "bashStop")
	UnRegisterForAnimationEvent(PlayerRef, "SoundPlay.NPCHumanCombatShieldBash")
	UnRegisterForAnimationEvent(PlayerRef, "CastStop")
	;Listeners for the beast form transformation sAttributes
	UnRegisterForAnimationEvent(PlayerRef, "SetRace")
	UnRegisterForAnimationEvent(PlayerREF, "Soundplay.NPCWerewolfTransformation")
	UnRegisterForAnimationEvent(PlayerRef, "SoundPlay.NPCHorseMount")
	UnRegisterForAnimationEvent(PlayerRef, "SoundPlay.NPCHorseDismount")
	UnRegisterForAnimationEvent(PlayerRef, "HorseEnter")
	UnRegisterForAnimationEvent(PlayerRef, "HorseEnterInstant")
	UnRegisterForAnimationEvent(PlayerRef, "HorseEnterSwim")
	UnRegisterForAnimationEvent(PlayerRef, "HorseExitOut")
	UnRegisterForAnimationEvent(PlayerRef, "DragonMountEnter")
	UnRegisterForAnimationEvent(PlayerRef, "DragonMountEnterInstant")
	UnRegisterForAnimationEvent(PlayerRef, "DragonMountExitOut")
	UnRegisterForAnimationEvent(PlayerRef, "WerewolfTransformation ")
	UnRegisterForAnimationEvent(PlayerRef, "VampireLordChangePlayer ")
	UnRegisterForAnimationEvent(PlayerRef, "pa_VampireLordChangePlayer")
	UnRegisterForAnimationEvent(PlayerRef, "RemoveCharacterControllerFromWorld")
endFunction

; Register for all of the animation events we care about for beast mode
Function registerForBMEvents()
	RegisterForAnimationEvent(PlayerRef, "SetRace")
    RegisterForAnimationEvent(PlayerRef, "GroundStart")
    RegisterForAnimationEvent(PlayerRef, "LevitateStart")
    RegisterForAnimationEvent(PlayerRef, "LiftoffStart")
    RegisterForAnimationEvent(PlayerRef, "LandStart")
    RegisterForAnimationEvent(PlayerRef, "TransformToHuman" )
    RegisterForAnimationEvent(PlayerREF, "Soundplay.NPCWerewolfTransformation")
    RegisterForAnimationEvent(PlayerRef, "WerewolfTransformation ")
	RegisterForAnimationEvent(PlayerRef, "VampireLordChangePlayer ")
	RegisterForAnimationEvent(PlayerRef, "pa_VampireLordChangePlayer")
	RegisterForAnimationEvent(PlayerRef, "RemoveCharacterControllerFromWorld")
EndFunction

; Unregister for the beast mode animation events we registered for.
Function unregisterForBMEvents()
	UnRegisterForAnimationEvent(PlayerRef, "SetRace")
   	UnRegisterForAnimationEvent(PlayerRef, "GroundStart")
   	UnRegisterForAnimationEvent(PlayerRef, "LevitateStart")
    UnRegisterForAnimationEvent(PlayerRef, "LiftoffStart")
    UnRegisterForAnimationEvent(PlayerRef, "LandStart")
   	UnRegisterForAnimationEvent(PlayerRef, "TransformToHuman" )
   	UnRegisterForAnimationEvent(PlayerREF, "Soundplay.NPCWerewolfTransformation")
   	UnRegisterForAnimationEvent(PlayerRef, "WerewolfTransformation ")
	UnRegisterForAnimationEvent(PlayerRef, "VampireLordChangePlayer ")
	UnRegisterForAnimationEvent(PlayerRef, "pa_VampireLordChangePlayer")
	UnRegisterForAnimationEvent(PlayerRef, "RemoveCharacterControllerFromWorld")
EndFunction

function unregisterForAllEvents()
	;Core animation events
	if bIsThunderchildLoaded || bIsWintersunLoaded
		UnRegisterForAnimationEvent(PlayerRef, "IdleChairSitting")
		UnRegisterForAnimationEvent(PlayerRef, "idleChairGetUp")
	endIf
	UnRegisterForAnimationEvent(PlayerRef, "weaponSwing")
	UnRegisterForAnimationEvent(PlayerRef, "weaponLeftSwing")
	UnRegisterForAnimationEvent(PlayerRef, "arrowRelease")
	UnRegisterForAnimationEvent(PlayerRef, "bashStart")
	UnRegisterForAnimationEvent(PlayerRef, "bashStop")
	UnRegisterForAnimationEvent(PlayerRef, "SoundPlay.NPCHumanCombatShieldBash")
	UnRegisterForAnimationEvent(PlayerRef, "CastStop")
	;Beast Mode animation events
	UnRegisterForAnimationEvent(PlayerRef, "SetRace")
	UnRegisterForAnimationEvent(PlayerRef, "GroundStart")
   	UnRegisterForAnimationEvent(PlayerRef, "LevitateStart")
    UnRegisterForAnimationEvent(PlayerRef, "LiftoffStart")
    UnRegisterForAnimationEvent(PlayerRef, "LandStart")
   	UnRegisterForAnimationEvent(PlayerRef, "TransformToHuman" )
   	UnRegisterForAnimationEvent(PlayerREF, "Soundplay.NPCWerewolfTransformation")
   	UnRegisterForAnimationEvent(PlayerRef, "SoundPlay.NPCHorseMount")
	UnRegisterForAnimationEvent(PlayerRef, "SoundPlay.NPCHorseDismount")
   	UnRegisterForAnimationEvent(PlayerRef, "WerewolfTransformation ")
	UnRegisterForAnimationEvent(PlayerRef, "VampireLordChangePlayer ")
	UnRegisterForAnimationEvent(PlayerRef, "pa_VampireLordChangePlayer")
	UnRegisterForAnimationEvent(PlayerRef, "RemoveCharacterControllerFromWorld")
   	;Actor actions
   	UnregisterForActorAction(2)
   	UnregisterForActorAction(7)
	UnregisterForActorAction(8)
	UnregisterForActorAction(10)
	;Camera State Changes
	UnregisterForCameraState()
endFunction

bool Property boundSpellEquipped
	bool function Get()
		;debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Get - bIsBoundSpellEquipped: " + bIsBoundSpellEquipped)
		return bIsBoundSpellEquipped
	endFunction

	function Set(Bool equipped)
		;debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Set - bIsBoundSpellEquipped: " + equipped)
		bIsBoundSpellEquipped = equipped
		BW.bIsBoundSpellEquipped = equipped
	endFunction
endProperty

bool property bJustQuickDualCast
	bool function Get()
		;debug.trace("iEquip_PlayerEventHandler bJustQuickDualCast Get - bDualCasting: " + bDualCasting)
		return bDualCasting
	endFunction

	function set(bool dualCasting)
		bDualCasting = dualCasting
		if dualCasting
			dualCastCounter = 2
		else
			dualCastCounter = 0
		endIf
		;debug.trace("iEquip_PlayerEventHandler bJustQuickDualCast Set - bDualCasting: " + bDualCasting + ", dualCastCounter: " + dualCastCounter)
	endFunction
endProperty

; Inventory Event Filters filter what we receive OnItemAdded/OnItemRemoved events for, in this case only OnItemRemoved, so we only receive events for items currently known to iEquip (included in one of the three formlists)

function updateAllEventFilters()
	;debug.trace("iEquip_PlayerEventHandler updateAllEventFilters start")
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(iEquip_ThrowingPoisonWeapon as form)
	AddInventoryEventFilter(iEquipTorch as form)
	AddInventoryEventFilter(iEquip_AllCurrentItemsFLST)
	AddInventoryEventFilter(iEquip_AmmoItemsFLST)
	AddInventoryEventFilter(iEquip_PotionItemsFLST)
	;debug.trace("iEquip_PlayerEventHandler updateAllEventFilters end")
endFunction

function updateEventFilter(formlist listToUpdate)
	;debug.trace("iEquip_PlayerEventHandler updateEventFilter start")
	RemoveInventoryEventFilter(listToUpdate)
	AddInventoryEventFilter(listToUpdate)
	;debug.trace("iEquip_PlayerEventHandler updateEventFilter end")
endFunction

bool bMountedRestrictionsApplied

Event OnPlayerCameraState(int oldState, int newState)
	if newState == 10 && PlayerRef.IsOnMount()
		applyMountedRestrictions()
	elseIf oldState == 10 && !PlayerRef.IsOnMount()
		applyMountedRestrictions(false)
	endIf	
EndEvent

function applyMountedRestrictions(bool apply = true, bool dragonRiding = false)
	if apply
		if dragonRiding && bRelevantItemsOnlyWhileDragonRiding
			WC.bDragonRiding = true

		elseIf bVanillaHorses
			WC.bPlayerIsMounted = true
			WC.onPlayerMount()
			KH.UnregisterForLeftKey()
		endIf
		bMountedRestrictionsApplied = true

	elseIf bMountedRestrictionsApplied
		if dragonRiding
			WC.bDragonRiding = false

		else
			WC.bPlayerIsMounted = false
			WC.onPlayerDismount()
			KH.RegisterForLeftKey()
		endIf
		bMountedRestrictionsApplied = false
	endIf
endFunction

;/ Camera States:

	0 - first person
	1 - auto vanity
	2 - VATS
	3 - free
	4 - iron sights
	5 - furniture
	6 - transition
	7 - tweenmenu
	8 - third person 1
	9 - third person 2
	10 - horse
	11 - bleedout
	12 - dragon

/;

Event OnRaceSwitchComplete()
	;debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete start - current state: " + GetState())
	if UI.IsMenuOpen("RaceSex Menu")
		PlayerRace = PlayerRef.GetRace()
	else
		race newRace = PlayerRef.GetRace()
		;debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - current PlayerRace: " + PlayerRace.GetName() + ", newRace: " + newRace.GetName() + ", original race: " + PlayerBaseRace.GetName())
		race baseRace = iEquip_ActorExt.GetBaseRace(PlayerRef)
		;debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - baseRace: " + baseRace.GetName())

		if PlayerRace != newRace
			PlayerRace = newRace
			bPlayerIsAVampireOrLich = ((aPlayerBaseRaces.Find(PlayerBaseRace) == aPlayerBaseVampireRaces.Find(PlayerRace)) || (aPlayerBaseRaces.Find(PlayerBaseRace) == aPlayerBasePOTLichRaces.Find(PlayerRace)))
			bPlayerIsABeast = BM.arBeastRaces.Find(PlayerRace) > -1
			KH.bPlayerIsABeast = bPlayerIsABeast
			if bPlayerIsABeast
				;debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - bPlayerIsABeast: " + bPlayerIsABeast)
				gotoState("BEASTMODE")
				unregisterForCoreAnimationEvents()
				registerForBMEvents()
			elseIf (PlayerRace == PlayerBaseRace) || bPlayerIsAVampireOrLich
				;debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - bPlayerIsAVampireOrLich: " + bPlayerIsAVampireOrLich)
				unregisterForBMEvents()
				registerForCoreAnimationEvents()
				gotoState("")
			else ;If we're not one of the supported beast races, and we're not in our original form then we must be an unsupported transformation so unregister for all events and block all relevant OnXxx events
				;debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - player is in an unsupported form")
				unregisterForAllEvents()
				gotoState("DISABLED")
			endIf
			if WC.isEnabled
				BM.onPlayerTransform(PlayerRace, bPlayerIsAVampireOrLich)
			endIf
		endIf
	endIf
	;debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete end - new state: " + GetState())
EndEvent

Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	;debug.trace("iEquip_PlayerEventHandler OnActorAction start - actionType: " + actionType + ", akActor: " + akActor + ", source: " + source + ", slot: " + slot)
	if akActor == PlayerRef
		if actionType == 2 ;Spell Cast/Spell Fire
			;Check if the action has come from a hand with a staff currently equipped
			if PlayerRef.GetEquippedItemType(slot) == 8
				if CM.iChargeDisplayType > 0 && CM.abIsChargeMeterShown[slot]
					CM.updateMeterPercent(slot)
					if bRealTimeStaffMeters
						updateMeterWhileStaffCasting(slot)
					endIf
				endIf
			elseIf slot == 0
				;Otherwise check if we've just cast Bound Shield (weapons are handled in BoundWeaponEventsListener)
				Utility.WaitMenuMode(0.3)
				armor equippedShield = PlayerRef.GetEquippedShield()
				if equippedShield && ((WC.bIsBEOLoaded && equippedShield.HasKeyword(WC.BoundArmor)) || equippedShield.GetName() == WC.asCurrentlyEquipped[0])
					WC.onBoundWeaponEquipped(26, 0)
					iEquip_AllCurrentItemsFLST.AddForm(PlayerRef.GetEquippedShield() as form)
					updateEventFilter(iEquip_AllCurrentItemsFLST)
				endIf
			endIf
		elseIf actionType == 7 || actionType == 8 ; Draw Begin or Draw End
			;debug.trace("iEquip_PlayerEventHandler OnActorAction - weapon drawn, bIsWidgetShown: " + WC.bIsWidgetShown)
			WC.updateWidgetVisibility()
			int i
			while i < 5
				if !WC.abIsNameShown[i]
					;debug.trace("iEquip_PlayerEventHandler OnActorAction - weapon drawn, name for slot " + i + " not currently visible, showing now")
					WC.showName(i)
				endIf
				if i < 2 && !WC.abIsPoisonNameShown[i] && !(i == 0 && WC.bAmmoMode) && !(TP.bPoisonEquipped && TP.iThrowingPoisonHand == i) && jMap.getInt(jArray.GetObj(WC.aiTargetQ[i], WC.aiCurrentQueuePosition[i]), "isPoisoned") == 1 	; Check and show the poison name if weapon poisoned
					;debug.trace("iEquip_PlayerEventHandler OnActorAction - weapon drawn, weapon in slot " + i + " is poisoned and poison name not currently visible, showing now")
					WC.showName(i, true, true)
				endIf
				i += 1
			endWhile
			if actionType == 8 && bWaitingForEnchantedWeaponDrawn  ; Draw End
				CM.updateChargeMetersOnWeaponsDrawn()
				bWaitingForEnchantedWeaponDrawn = false
			endIf
		elseIf actionType == 10  ; Sheathe End
			if TP.bPoisonEquipped
				TP.OnThrowingPoisonUnequipped(true)
			endIf
			if WC.bIsWidgetShown && WC.bWidgetFadeoutEnabled
				WVis.registerForWidgetFadeoutUpdate()
			endIf
		endIf
	endIf
	;debug.trace("iEquip_PlayerEventHandler OnActorAction end")
endEvent

function updateMeterWhileStaffCasting(int slot)
	;debug.trace("iEquip_PlayerEventHandler updateMeterWhileStaffCasting start - slot: " + slot)
	int fallback = 20
	if slot == 0
		while !(PlayerRef as objectReference).GetAnimationVariableBool("IsCastingLeft") && fallback > 0
		     Utility.WaitMenuMode(0.1)
		     fallback -= 1
		endWhile
		while (PlayerRef as objectReference).GetAnimationVariableBool("IsCastingLeft")
		     Utility.WaitMenuMode(2.0)
		     CM.updateMeterPercent(0)
		endWhile
	else
		while !(PlayerRef as objectReference).GetAnimationVariableBool("IsCastingRight") && fallback > 0
		     Utility.WaitMenuMode(0.1)
		     fallback -= 1
		endWhile
		while (PlayerRef as objectReference).GetAnimationVariableBool("IsCastingRight")
		     Utility.WaitMenuMode(2.0)
		     CM.updateMeterPercent(1)
		endWhile
	endIf
	;debug.trace("iEquip_PlayerEventHandler updateMeterWhileStaffCasting end")
endFunction

Event OnAnimationEvent(ObjectReference aktarg, string EventName)
	;debug.trace("iEquip_PlayerEventHandler OnAnimationEvent received - EventName: " + EventName)

    if EventName == "Soundplay.NPCWerewolfTransformation"
    	BM.OnWerewolfTransformationStart()

    elseIf EventName == "SoundPlay.NPCHorseMount" || EventName == "HorseEnter" || EventName == "HorseEnterInstant" || EventName == "HorseEnterSwim"
    	applyMountedRestrictions()

   	elseIf EventName == "SoundPlay.NPCHorseDismount" || EventName == "HorseExitOut"
   		applyMountedRestrictions(false)

   	elseIf EventName == "DragonMountEnter" || EventName == "DragonMountEnterInstant"
   		applyMountedRestrictions(true, true)

   	elseIf EventName == "DragonMountExitOut"
   		applyMountedRestrictions(false, true)

    elseIf EventName == "IdleChairSitting" 											; We're checking here for Wintersun/Thunderchild meditation to disable iEquip controls while meditating
    	Utility.WaitMenuMode(1.0) 													; Just in case the magic effect isn't added straight away - in testing this took less than 0.25s so 1s should be sufficient for most cases
    	if ((bIsThunderchildLoaded && PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x06CAED, "Thunderchild - Epic Shout Package.esp") as MagicEffect)) || (bIsWintersunLoaded && PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x023dd5, "Wintersun - Faiths of Skyrim.esp") as MagicEffect)))
	    	bPlayerIsMeditating = true
	    	KH.bAllowKeyPress = false
	    endIf

    elseIf EventName == "idleChairGetUp" && bPlayerIsMeditating 					; Restore controls on exiting meditation
    	bPlayerIsMeditating = false
    	KH.bAllowKeyPress = true

    elseIf EventName == "CastStop"													; No way to check which hand has just finished casting so we need to update meters in whichever hands we currently have staffs equipped
    	if CM.iChargeDisplayType > 0
	    	if PlayerRef.GetEquippedItemType(0) == 8 && CM.abIsChargeMeterShown[0]	; Staff
				CM.updateMeterPercent(0)
	    	endIf
	    	if PlayerRef.GetEquippedItemType(1) == 8 && CM.abIsChargeMeterShown[1]
	    		CM.updateMeterPercent(1)
	    	endIf
	    endIf
    else
    	if TP.bPoisonEquipped && ((EventName == "weaponSwing" && (TP.iThrowingPoisonHand == 1 || WC.bPlayerIsMounted)) || (EventName == "weaponLeftSwing" && TP.iThrowingPoisonHand == 0))
	    	TP.onPoisonThrown()
    	else
		    int iTmp = 2 
		    if EventName == "weaponLeftSwing" || EventName == "bashStart" || EventName == "SoundPlay.NPCHumanCombatShieldBash" || EventName == "bashStop"
		        iTmp = 1
		    endIf    
		    if (iSlotToUpdate == -1 || (iSlotToUpdate + iTmp == 2))
		        iSlotToUpdate += iTmp
		        if !bWaitingForAnimationUpdate
		            bWaitingForAnimationUpdate = true
		            RegisterForSingleUpdate(0.8)
		        endIf
		    endIf
		endIf
	endIf
	;debug.trace("iEquip_PlayerEventHandler OnAnimationEvent end")
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	;debug.trace("iEquip_PlayerEventHandler OnHit start")
	If abHitBlocked
		int iTmp = 2
		if PlayerRef.GetEquippedShield()	; We're tracking blocking events here, so if we've got a shield equipped we need to update the left hand, if we don't we must have blocked with our right hand/2H weapon so update right
			iTmp = 1
		endIf
		if (iSlotToUpdate == -1 || (iSlotToUpdate + iTmp == 2))
	        iSlotToUpdate += iTmp
	        if !bWaitingForAnimationUpdate
	            bWaitingForAnimationUpdate = true
	            RegisterForSingleUpdate(0.8)
	        endIf
	    endIf
	endIf
	;debug.trace("iEquip_PlayerEventHandler OnHit end")
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	;debug.trace("iEquip_PlayerEventHandler OnObjectEquipped start - just equipped " + akBaseObject.GetName() + ", akReference: " + akReference + ", WC.bAddingItemsOnFirstEnable: " + WC.bAddingItemsOnFirstEnable + ", bProcessingQueuedForms: " + bProcessingQueuedForms + ", bJustQuickDualCast: " + bJustQuickDualCast)	
	
	int itemType = akBaseObject.GetType()
	;debug.trace("iEquip_PlayerEventHandler OnObjectEquipped - itemType: " + itemType)
	if itemType == 31 && !(TO.bIsTCSLoaded && akBaseObject == TO.Torch01 as form)	; This just handles the finite torch life timer. If Torches Cast Shadows is loaded then ignore the Torch01 equip and wait for the TCS torch to be equipped before proceeding
		;debug.trace("iEquip_PlayerEventHandler OnObjectEquipped - just equipped a torch")
		TO.onTorchEquipped()
	endIf

	if bProcessingQueuedForms 					; Just in case the player has switched items before the previous equip/update has had time to complete
		int countdown = 20
		while bProcessingQueuedForms && countdown > 0
			WaitMenuMode(0.1)
			countdown -= 1
		endWhile
	endIf

	if !WC.bAddingItemsOnFirstEnable && !bGoingUnarmed && !bProcessingQueuedForms && akBaseObject != iEquipTorch as form && akBaseObject != iEquip_ThrowingPoisonWeapon as form && !(akBaseObject as light && Game.GetModName(Math.LogicalAnd(Math.RightShift(akBaseObject.GetFormID(), 24), 0xFF)) == "TorchesCastShadows.esp") && akBaseObject.GetName() != "DummyArrow"
		if akBaseObject as spell && bDualCasting
			dualCastCounter -=1
			if dualCastCounter == 0
				bDualCasting = false
			endIf
		else
			if itemTypesToProcess.Find(itemType) > -1 || (itemType == 26 && (akBaseObject as Armor).GetSlotMask() == 512)
				iEquip_OnObjectEquippedFLST.AddForm(akBaseObject)
				;debug.trace("iEquip_PlayerEventHandler OnObjectEquipped - iEquip_OnObjectEquippedFLST contains " + iEquip_OnObjectEquippedFLST.GetSize() + " entries")
				if !bWaitingForTransform
					if itemType == 31
						processQueuedForms(0)	; Should allow the left slot to be updated if you just re-equipped a torch having previously unequipped it during burnout, before it is switched to an iEquipTorch
					else
						bWaitingForOnObjectEquippedUpdate = true
						registerForSingleUpdate(0.8)
					endIf
				endIf
			endIf
		endIf
	endIf
	;debug.trace("iEquip_PlayerEventHandler OnObjectEquipped end")
endEvent

Event OnUpdate()
	;debug.trace("iEquip_PlayerEventHandler OnUpdate start - bWaitingForAnimationUpdate: " + bWaitingForAnimationUpdate + ", bWaitingForOnObjectEquippedUpdate: " + bWaitingForOnObjectEquippedUpdate + ", bWaitingForOnObjectUnequippedUpdate: " + bWaitingForOnObjectUnequippedUpdate + ", bWaitingForTransform: " + bWaitingForTransform)
	if bWaitingForAnimationUpdate
		bWaitingForAnimationUpdate = false
		updateWidgetOnWeaponSwing()
	endIf
	if bWaitingForOnObjectEquippedUpdate
		bWaitingForOnObjectEquippedUpdate = false
		if !bWaitingForTransform
			processQueuedForms()
		endIf
	endIf
	; This next section is here to catch unequip events from within menus or via vanilla hotkeys or other hotkey mods which leave the hand or shout slots with nothing equipped.
	if bWaitingForOnObjectUnequippedUpdate
		bWaitingForOnObjectUnequippedUpdate = false
		if !Utility.IsInMenuMode()
			Utility.Wait(0.4)
		  	int Q
		  	while Q < 3
		  		if !PlayerRef.GetEquippedObject(Q)
		  			WC.setSlotToEmpty(Q, true, JArray.count(WC.aiTargetQ[Q]) > 0)
		  		endIf
		  		Q += 1
		  	endWhile
		endIf
		CU.registerForCleanupUpdate(0.0)
	endIf
	;debug.trace("iEquip_PlayerEventHandler OnUpdate end")	
EndEvent

function updateWidgetOnWeaponSwing()
	;debug.trace("iEquip_PlayerEventHandler updateWidgetOnWeaponSwing start")
	int slotToUpdate = iSlotToUpdate 	; This is just in case we're swinging wildly and iSlotToUpdate changes from 0 or 1 to 2 before we complete here
	iSlotToUpdate = -1
	
	if slotToUpdate == 0 || slotToUpdate == 1
		If bPoisonSlotEnabled
			WC.checkAndUpdatePoisonInfo(slotToUpdate)
		endIf
		if CM.iChargeDisplayType > 0 && CM.abIsChargeMeterShown[slotToUpdate]
			CM.updateMeterPercent(slotToUpdate)
		endIf
		if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator
			TI.checkAndUpdateTemperLevelInfo(slotToUpdate)
		endIf
	else
		If bPoisonSlotEnabled
			WC.checkAndUpdatePoisonInfo(0)
			WC.checkAndUpdatePoisonInfo(1)
		endIf
		if CM.iChargeDisplayType > 0
			if CM.abIsChargeMeterShown[0]
				CM.updateMeterPercent(0)
			endIf
			if CM.abIsChargeMeterShown[1]
				CM.updateMeterPercent(1)
			endIf
		endIf
		if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator
			TI.checkAndUpdateTemperLevelInfo(0)
			TI.checkAndUpdateTemperLevelInfo(1)
		endIf
	endIf

	;debug.trace("iEquip_PlayerEventHandler updateWidgetOnWeaponSwing end")
endFunction

; This event handles auto-adding newly equipped items to the left, right and shout slots
function processQueuedForms(int equippedSlot = -1)
	;debug.trace("iEquip_PlayerEventHandler processQueuedForms start - equippedSlot: " + equippedSlot + ", number of forms to process: " + iEquip_OnObjectEquippedFLST.GetSize())	
	bProcessingQueuedForms = true
	int i
	form queuedForm
	while i < iEquip_OnObjectEquippedFLST.GetSize()
		queuedForm = iEquip_OnObjectEquippedFLST.GetAt(i)
		;debug.trace("iEquip_PlayerEventHandler processQueuedForms - i: " + i + ", queuedForm: " + queuedForm + " - " + queuedForm.GetName())
		if queuedForm
			if queuedForm as ammo
				if bTogglingAmmoMode
					bTogglingAmmoMode = false
				elseIf (PlayerRef.GetEquippedItemType(1) == 7 || PlayerRef.GetEquippedItemType(1) == 12)
					AM.checkAndEquipAmmo(false, true, true, false, queuedForm)
				endIf
			; Check the item is still equipped, and if it is in the left, right or shout slots which is all we're interested in here. Blocked if equipped item is a bound weapon or an item from Throwing Weapons Lite (to avoid weirdness...)
			elseIf !(queuedForm as weapon && iEquip_WeaponExt.IsWeaponBound(queuedForm as weapon)) && !(Game.GetModName(Math.LogicalAnd(Math.RightShift(queuedForm.GetFormID(), 24), 0xFF)) == "JZBai_ThrowingWpnsLite.esp") && !(queuedForm as Armor && (Game.GetModName(Math.LogicalAnd(Math.RightShift(queuedForm.GetFormID(), 24), 0xFF)) == "Bound Shield.esp" || (WC.bIsBEOLoaded && queuedForm.HasKeyword(WC.BoundArmor))))
				if equippedSlot == -1
					if PlayerRef.GetEquippedObject(0) == queuedForm
						; Now we need to check if we've just equipped the same 1H item/spell in both left and right hand at the same time
						if PlayerRef.GetEquippedObject(1) == queuedForm
							equippedSlot = 3 ;We'll use 3 to indicate the same 1H item has been found in both hands so we can update both queues and widget slots
						else
							equippedSlot = 0 ;Left
						endIf
					elseIf PlayerRef.GetEquippedObject(1) == queuedForm
						equippedSlot = 1 ;Right
					elseIf PlayerRef.GetEquippedObject(2) == queuedForm
						equippedSlot = 2 ;Shout/Power
					endIf
				endIf
				; If the item has been equipped in the left, right or shout slot
				if equippedSlot != -1
					;debug.trace("iEquip_PlayerEventHandler processQueuedForms - " + queuedForm.GetName() + " found in equippedSlot: " + equippedSlot)
					int itemType = queuedForm.GetType()
					int iEquipSlot
					; If it's a 2H or ranged weapon or a BothHands spell we'll receive the event for slot 0 so we need to make sure we add it to the right hand queue instead
					if itemType == 22
						iEquipSlot = WC.EquipSlots.Find((queuedForm as spell).GetEquipType())
					elseIf itemType == 41
						itemType = (queuedForm as Weapon).GetWeaponType()
					endIf
					if ((itemType == 5 || itemType == 6 && !WC.bIsCGOLoaded) || itemType == 7 || itemType == 9 || (itemType == 22 && iEquipSlot == 3))
						equippedSlot = 1
					endIf
					if bPlayerIsABeast
						if equippedSlot == 3
							BM.updateSlotOnObjectEquipped(0, queuedForm, itemType, iEquipSlot)
							BM.updateSlotOnObjectEquipped(1, queuedForm, itemType, iEquipSlot)
						else
							BM.updateSlotOnObjectEquipped(equippedSlot, queuedForm, itemType, iEquipSlot)
						endIf
					elseIf equippedSlot == 3
						updateSlotOnObjectEquipped(0, queuedForm, itemType, iEquipSlot)
						updateSlotOnObjectEquipped(1, queuedForm, itemType, iEquipSlot)
					else
						updateSlotOnObjectEquipped(equippedSlot, queuedForm, itemType, iEquipSlot)
					endIf
				endIf
			endIf
		endIf
		equippedSlot = -1
		i += 1
	endWhile
	iEquip_OnObjectEquippedFLST.Revert()
	;debug.trace("iEquip_PlayerEventHandler processQueuedForms end - all added forms processed, iEquip_OnObjectEquippedFLST count: " + iEquip_OnObjectEquippedFLST.GetSize() + " (should be 0)")
	bProcessingQueuedForms = false
endFunction

function updateSlotOnObjectEquipped(int equippedSlot, form queuedForm, int itemType, int iEquipSlot)
	;debug.trace("iEquip_PlayerEventHandler updateSlotOnObjectEquipped start - equippedSlot: " + equippedSlot + ", queuedForm: " + queuedForm + ", itemType: " + itemType + ", iEquipSlot: " + iEquipSlot)
	bool actionTaken
	int targetIndex
	bool blockCall
	form equippedForm = PlayerRef.GetEquippedObject(equippedSlot)
	bool formFound = iEquip_AllCurrentItemsFLST.HasForm(queuedForm)
	string itemName
	string itemBaseName
	int itemID
	int itemHandle = 0xFFFF

	if equippedSlot < 2 && queuedForm == Unarmed && WC.asCurrentlyEquipped[equippedSlot] != "$iEquip_common_Unarmed"		; If the player is brawling then don't add the fistWeapon to the queue, and if not currently showing Unarmed do so now.

		WC.setSlotToEmpty(equippedSlot, true, true)

	else
		if equippedForm && queuedForm != equippedForm ; Just in case something has gone wrong, make sure we're updating the slot for what is actually equipped
			queuedForm = equippedForm
			itemType = queuedForm.GetType()
			if itemType == 22
				iEquipSlot = WC.EquipSlots.Find((queuedForm as spell).GetEquipType())
			elseIf itemType == 41
				itemType = (queuedForm as Weapon).GetWeaponType()
			endIf
		endIf

		if (queuedForm as weapon || queuedForm as armor)
			itemHandle = WC.getHandle(equippedSlot, itemType, queuedForm)
		endIf

		;debug.trace("iEquip_PlayerEventHandler updateSlotOnObjectEquipped - itemHandle: " + itemHandle)

		if itemHandle != 0xFFFF
			itemName = iEquip_InventoryExt.GetLongName(queuedForm, itemHandle)
			itemBaseName = iEquip_InventoryExt.GetShortName(queuedForm, itemHandle)
			if bIsItemDurabilityFound
				int i = StringUtil.Find(itemName, "[")
				if i != -1
					itemName = StringUtil.Substring(itemName, 0, i - 1)
				endIf
				i = StringUtil.Find(itemBaseName, "(")
				if i == -1
					i = StringUtil.Find(itemBaseName, "[")
				endIf
				if i != -1
					itemBaseName = StringUtil.Substring(itemBaseName, 0, i - 1)
				endIf
			endIf
			;debug.trace("iEquip_PlayerEventHandler updateSlotOnObjectEquipped - attempting to set names from itemHandle: " + itemHandle + ", itemName: " + itemName + ", itemBaseName: " + itemBaseName)
		endIf
		
		if itemName == ""
			itemName = queuedForm.getName()
		endIf

		;debug.trace("iEquip_PlayerEventHandler updateSlotOnObjectEquipped - final names being saved, itemName: " + itemName + ", itemBaseName: " + itemBaseName)

		itemID = CalcCRC32Hash(itemName, Math.LogicalAND(queuedForm.GetFormID(), 0x00FFFFFF))
		;debug.trace("iEquip_PlayerEventHandler updateSlotOnObjectEquipped - received itemID: " + itemID)
																											; Check if we've just manually equipped an item that is already in an iEquip queue
	 	if formFound
																											; If it's been found in the queue for the equippedSlot it's been equipped to
			targetIndex = WC.findInQueue(equippedSlot, itemName, queuedForm, itemHandle)
			if targetIndex != -1
				
				if equippedSlot < 2
					if !abSkipQueueObjectUpdate[equippedSlot]								; Update the item name in case the display name differs from the base item name, and store the new itemID
						if itemHandle != 0xFFFF && jMap.getInt(jArray.GetObj(WC.aiTargetQ[equippedSlot], targetIndex), "iEquipHandle", 0xFFFF) == 0xFFFF
							JArray.AddInt(WC.iRefHandleArray, itemHandle)
							JArray.unique(WC.iRefHandleArray)
							jMap.setInt(jArray.GetObj(WC.aiTargetQ[equippedSlot], targetIndex), "iEquipHandle", itemHandle)
						endIf
						jMap.setStr(jArray.GetObj(WC.aiTargetQ[equippedSlot], targetIndex), "iEquipName", itemName)
						jMap.setStr(jArray.GetObj(WC.aiTargetQ[equippedSlot], targetIndex), "iEquipBaseName", itemBaseName)
						jMap.setStr(jArray.GetObj(WC.aiTargetQ[equippedSlot], targetIndex), "lastDisplayedName", itemName)
						jMap.setInt(jArray.GetObj(WC.aiTargetQ[equippedSlot], targetIndex), "iEquipItemID", itemID)
					else
						abSkipQueueObjectUpdate[equippedSlot] = false
					endIf
				endIf
				
				if WC.bMoreHUDLoaded																		; Send to moreHUD if loaded
					string moreHUDIcon
					if equippedSlot < 2
						AhzMoreHudIE.RemoveIconItem(itemID)
						if specificHandedItems.Find(itemType) == -1 && WC.isAlreadyInQueue((equippedSlot + 1) % 2, queuedForm, itemID, itemHandle)
							moreHUDIcon = WC.asMoreHUDIcons[3]
						else
		            		moreHUDIcon = WC.asMoreHUDIcons[equippedSlot]
		            	endIf
		            else
		            	moreHUDIcon = WC.asMoreHUDIcons[2]
		            endIf
		            AhzMoreHudIE.AddIconItem(itemID, moreHUDIcon)
		        endIf

		        bool bCurrentlyDualCasting = !WC.b2HSpellEquipped && jMap.getInt(jArray.GetObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1]), "iEquipType") == 22 && WC.asCurrentlyEquipped[1] == UI.GetString(HUD_MENU, WidgetRoot + ".widgetMaster.LeftHandWidget.leftName_mc.leftName.text")

				if WC.aiCurrentQueuePosition[equippedSlot] == targetIndex && WC.asCurrentlyEquipped[equippedSlot] != "" && !((equippedSlot == 0 && (WC.bGoneUnarmed || bCurrentlyDualCasting)) || TO.bJustCalledQuickLight)			; If it's somehow already shown in the widget
					if equippedSlot < 2
						if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator																				; Update the name and temper level if required
							TI.checkAndUpdateTemperLevelInfo(equippedSlot)
						else
							int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateDisplayedText")
							If(iHandle)
								UICallback.PushInt(iHandle, TI.aiNameElements[equippedSlot])
								UICallback.PushString(iHandle, itemName)
								UICallback.Send(iHandle)
							endIf
						endIf
					endIf
					if equippedSlot == 0 && (WC.bLeftIconFaded || WC.b2HSpellEquipped || AM.bAmmoMode)
						if WC.bLeftIconFaded
							WC.checkAndFadeLeftIcon(0, itemType)
							blockCall = true
						endIf
					else
						blockCall = true
					endIf
				
				else 																																	; Otherwise update the position and name, then update the widget
					WC.aiCurrentQueuePosition[equippedSlot] = targetIndex
					WC.asCurrentlyEquipped[equippedSlot] = itemName
					if equippedSlot < 2 || WC.bShoutEnabled
						WC.updateWidget(equippedSlot, targetIndex, true, true)
					endIf
					if equippedSlot == 0
						WC.bGoneUnarmed = false
					endIf
				endIf
				actionTaken = true
			endIf
		endIf
	endIf
	;debug.trace("iEquip_PlayerEventHandler updateSlotOnObjectEquipped - equippedSlot: " + equippedSlot + ", formFound: " + formFound + ", targetIndex: " + targetIndex + ", blockCall: " + blockCall)
	if !actionTaken 																			; If it isn't already contained in the AllCurrentItems formlist, or it is but findInQueue has returned -1 meaning it's a 1H item contained in the other hand queue

		targetIndex = jArray.count(WC.aiTargetQ[equippedSlot])

		int iEquipItem = jMap.object()
		string itemIcon = WC.GetItemIconName(queuedForm, itemType, itemName)
		jMap.setForm(iEquipItem, "iEquipForm", queuedForm)
		jMap.setInt(iEquipItem, "iEquipItemID", itemID)
		if queuedForm as weapon || queuedForm as armor
			jMap.setInt(iEquipItem, "iEquipHandle", itemHandle)
		endIf
		jMap.setInt(iEquipItem, "iEquipType", itemType)
		jMap.setStr(iEquipItem, "iEquipName", itemName)
		jMap.setStr(iEquipItem, "iEquipBaseName", itemBaseName)
		jMap.setStr(iEquipItem, "iEquipIcon", itemIcon)
		
		if equippedSlot < 2
			if itemType == 22
				if itemIcon == "DestructionFire" || itemIcon == "DestructionFrost" || itemIcon == "DestructionShock"
					jMap.setStr(iEquipItem, "iEquipSchool", "Destruction")
				else
					jMap.setStr(iEquipItem, "iEquipSchool", itemIcon)
				endIf
				jMap.setInt(iEquipItem, "iEquipSlot", iEquipSlot)
			else
				jMap.setStr(iEquipItem, "iEquipBaseIcon", itemIcon)
				jMap.setStr(iEquipItem, "lastDisplayedName", itemName)
				jMap.setInt(iEquipItem, "lastKnownItemHealth", 100)								; These will be set correctly by WC.CycleHand() and associated functions
				jMap.setInt(iEquipItem, "isEnchanted", 0)
				jMap.setInt(iEquipItem, "isPoisoned", 0)
			endIf
		endIf

		if blackListFLSTs[equippedSlot].HasForm(queuedForm) || (WC.PM.bCurrentlyQuickHealing && itemType == 22 && iEquip_SpellExt.IsHealingSpell(queuedForm as spell)) || !((equippedSlot < 2 && bAutoAddNewItems || queuedForm == TO.realTorchForm) || (equippedSlot == 2 && ((itemType == 22 && bAutoAddShouts) || (itemType == 119 && bAutoAddPowers))))
			jMap.setInt(iEquipItem, "iEquipTempItem", 1)
		endIf

		jArray.addObj(WC.aiTargetQ[equippedSlot], iEquipItem)

		bool bSwitchedQueues

		if !formFound 																			; If it's not already in the AllItems formlist because it's in the other hand queue add it now
			iEquip_AllCurrentItemsFLST.AddForm(queuedForm)
			updateEventFilter(iEquip_AllCurrentItemsFLST)
		elseIf equippedSlot < 2 && !WC.bAllowSingleItemsInBothQueues && queuedForm as weapon
			int otherHand = (equippedSlot + 1) % 2
			int otherHandIndex = WC.findInQueue(otherHand, itemName, queuedForm, itemHandle)
			if PlayerRef.GetItemCount(queuedForm) == 1 && otherHandIndex != -1
				WC.removeItemFromQueue(otherHand, otherHandIndex, false, false, false, false)
				bSwitchedQueues = true
			endIf
		endIf

		if itemHandle != 0xFFFF																	; Add the new itemHandle to the ref handle array
			JArray.AddInt(WC.iRefHandleArray, itemHandle)
			JArray.unique(WC.iRefHandleArray)
		endIf

		if WC.bMoreHUDLoaded 																	; Send to moreHUD if loaded
			AhzMoreHudIE.RemoveIconItem(itemID)													; Reset
			if formFound && !bSwitchedQueues
				AhzMoreHudIE.AddIconItem(itemID, WC.asMoreHUDIcons[3]) 							; Both queues
			else
				AhzMoreHudIE.AddIconItem(itemID, WC.asMoreHUDIcons[equippedSlot])
			endIf
		endIf

		WC.aiCurrentQueuePosition[equippedSlot] = targetIndex 									; Now update the widget to show the equipped item
		WC.asCurrentlyEquipped[equippedSlot] = itemName
		
		if WC.abQueueWasEmpty[equippedSlot] && WC.iBackgroundStyle > 0
			int[] args = new int[2]
			args[0] = equippedSlot
			args[1] = WC.iBackgroundStyle
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setWidgetBackground", args)					; Show the background if required if it was previously hidden
		endIf
		WC.abQueueWasEmpty[equippedSlot] = false

		if equippedSlot < 2 || WC.bShoutEnabled
			WC.updateWidget(equippedSlot, targetIndex, true, true)
		endIf

	endIf

	if equippedSlot < 2 && !blockCall
		WC.checkAndEquipShownHandItem(equippedSlot, false, true)								; And run the rest of the hand equip cycle without actually equipping to toggle ammo mode if needed and update count, poison and charge info
	endIf
	if equippedSlot == 1 && targetIndex > -1 && ((queuedForm as weapon && WC.ai2HWeaponTypes.Find(itemType) == -1) || queuedForm as scroll || (queuedForm as spell && jMap.getInt(jArray.getObj(WC.aiTargetQ[1], targetIndex), "iEquipSlot") != 3 && jMap.getStr(jArray.getObj(WC.aiTargetQ[1], targetIndex), "iEquipSchool") != "Restoration"))
		WC.iLastRH1HItemIndex = targetIndex
	endIf
	;debug.trace("iEquip_PlayerEventHandler updateSlotOnObjectEquipped end")
endFunction

event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	;debug.trace("iEquip_PlayerEventHandler OnObjectUnequipped start - akBaseObject: " + akBaseObject + " - " + akBaseObject.GetName())
	if akBaseObject as weapon && akBaseObject as weapon == iEquip_ThrowingPoisonWeapon
		;debug.trace("iEquip_PlayerEventHandler OnObjectUnequipped - just unequipped a throwing poison, TP.bJustUnequippedThrowingPoison: " + TP.bJustUnequippedThrowingPoison)
		if !TP.bJustUnequippedThrowingPoison
			TP.OnThrowingPoisonUnequipped()
		else
			TP.bJustUnequippedThrowingPoison = false
		endIf

  	elseIf akBaseObject.GetType() == 31 && !(WC.bAddingItemsOnFirstEnable || (TO.bIsTCSLoaded && akBaseObject == TO.Torch01 as form) || (Game.GetModName(Math.LogicalAnd(Math.RightShift(akBaseObject.GetFormID(), 24), 0xFF)) == "Undriel_Everlight.esp") || (WC.bIsLOTDLoaded && akBaseObject == Game.GetFormFromFile(0x7666F4, "LegacyoftheDragonborn.esm")))
  		;debug.trace("iEquip_PlayerEventHandler OnObjectUnequipped - just unequipped a torch")
  		GoToState("PROCESSING")
    	TO.onTorchUnequipped()
  	endIf

  	if akBaseObject.GetName() == "DummyArrow" && PlayerRef.GetEquippedItemType(1) == 12 && !PlayerRef.IsEquipped(AM.currentAmmoForm)
  		PlayerRef.EquipItemEx(AM.currentAmmoForm as Ammo)

  	else
  		if !bGoingUnarmed && !TO.bSettingLightRadius && !(akBaseObject.GetType() == 31 && TO.didATorchJustBurnOut())
		  	bWaitingForOnObjectUnequippedUpdate = true
			registerForSingleUpdate(0.8)
		else
			CU.registerForCleanupUpdate()
		endIf
	endIf
	;debug.trace("iEquip_PlayerEventHandler OnObjectUnequipped end")
endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	;debug.trace("iEquip_PlayerEventHandler OnItemRemoved start - akBaseItem: " + akBaseItem + " - " + akBaseItem.GetName() + ", aiItemCount: " + aiItemCount + ", akItemReference: " + akItemReference)	
	int i
	int itemType = akBaseItem.GetType()

	if akBaseItem == iEquipTorch as form || akBaseItem == iEquip_ThrowingPoisonWeapon as form 		; If the player has just dropped or stored one of these items

		form RealItem																				; Get the equivalent real item
		if akBaseItem == iEquipTorch
			RealItem = TO.Torch01 as form
		else
			RealItem = jMap.getForm(jArray.getObj(WC.aiTargetQ[4], WC.aiCurrentQueuePosition[4]), "iEquipForm")
		endIf
		
		if !akDestContainer 																		; If it has been dropped
			ObjectReference DroppedItem
			if akItemReference  																	; If we've got an ObjectReference use that
				DroppedItem = akItemReference
			else
				DroppedItem = Game.FindClosestReferenceOfTypeFromRef(akBaseItem, PlayerRef, 200)	; Otherwise find the closest one to the player
			endIf
			if DroppedItem
				DroppedItem.delete() 																; Delete and disable the dummy item
				DroppedItem.disable()

				if akBaseItem as light && TO.bDropLitTorchesEnabled 								; If we've dropped an iEquipTorch and we have enabled Drop Lit Torches then run that now
					TO.DropTorch(true)
				
				elseIf PlayerRef.GetItemCount(RealItem) 											; Drop the real item in its place
					PlayerRef.DropObject(RealItem, 1)
				endIf
			endIf
		else 																						; If it has been moved to another container
			akDestContainer.RemoveItem(akBaseItem, 1, true) 										; Remove the dummy item form the destination container
			if PlayerRef.GetItemCount(RealItem)
				PlayerRef.RemoveItem(RealItem, 1, true, akDestContainer) 							; Replace it with the real item from the players inventory
			endIf
		endIf
	endIf

	int weaponType

	If itemType == 41 													; If it is a weapon get the weapon type
		weaponType = (akBaseItem as Weapon).GetWeaponType()
	endIf
																		; Handle potions/consumales/poisons and ammo in AmmoMode first
	if akBaseItem as potion
		PO.onPotionRemoved(akBaseItem)
		if (akBaseItem as potion).IsPoison() && !PlayerRef.GetItemCount(akBaseItem) && TP.bPoisonEquipped
			Utility.WaitMenuMode(0.3)
			TP.onPoisonRemoved(akBaseItem as potion)
		endIf

	elseIf akBaseItem as ammo && Game.GetModName(Math.LogicalAnd(Math.RightShift(akBaseItem.GetFormID(), 24), 0xFF)) != "JZBai_ThrowingWpnsLite.esp"
		AM.onAmmoRemoved(akBaseItem)
																		; Check if a Bound Shield has just been unequipped
	elseIf (itemType == 26) && (akBaseItem.GetName() == WC.asCurrentlyEquipped[0]) && (jMap.getInt(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0]), "iEquipType") == 22)
		WC.onBoundWeaponUnequipped(0, true)
		iEquip_AllCurrentItemsFLST.RemoveAddedForm(akBaseItem)
		updateEventFilter(iEquip_AllCurrentItemsFLST)
    																	; Otherwise handle anything else in left, right or shout queue other than bound weapons
	elseIf !(akBaseItem as weapon && ((TI.aiTemperedItemTypes.Find(weaponType) != -1 && !(weaponType == 4 && iEquip_FormExt.IsGrenade(akBaseItem))) || iEquip_WeaponExt.IsWeaponBound(akBaseItem as weapon)))  ; The aiTemperedItemTypes exclusion here is because they are now removed through OnRefHandleInvalidated
		if itemType == 31	; Torch
			TO.onTorchRemoved(akBaseItem)
		endIf
		i = 0
		int foundAt
		bool actionTaken
		string itemName = akBaseItem.GetName()
		while i < 3 && !actionTaken
			if WC.isItemValidForSlot(i, akBaseItem, itemType, itemName, true)
				foundAt = WC.findInQueue(i, itemName, akBaseItem)
				if foundAt != -1
					if i == 2 												; If it's a shout or power remove it straight away
						WC.removeItemFromQueue(i, foundAt)
						actionTaken = true
					else
						int itemCount = PlayerRef.GetItemCount(akBaseItem)
						int otherHand = (i + 1) % 2
						int foundAtOtherHand = -1

						if itemType == 41
							itemType = weaponType
						endIf
						
						if specificHandedItems.Find(itemType) == -1 || (WC.bIsCGOLoaded && itemType < 7)
							foundAtOtherHand = WC.findInQueue(otherHand, itemName, akBaseItem)
						endIf
																			; If it's ammo, scrolls, torch or other throwing weapons which require a counter update
						if WC.asCurrentlyEquipped[i] == itemName && itemCount > 0 && (itemType == 42 || itemType == 23 || itemType == 31 || (itemType == 4 && iEquip_FormExt.IsGrenade(akBaseItem)))
							WC.setSlotCount(i, itemCount)
							actionTaken = true
																			; Otherwise check if we've removed the last of the currently equipped item, or if we're currently dual wielding it and only have one left make sure we remove the correct one
						elseIf (itemCount == 1 && foundAtOtherHand != -1 && PlayerRef.GetEquippedObject(i) != akBaseItem) || itemCount == 0
							WC.removeItemFromQueue(i, foundAt, false, false, true)
																			; If the removed item was in both queues and we've got none left remove from the other queue as well
							if foundAtOtherHand != -1 && (itemCount == 0 || (itemCount == 1 && PlayerRef.GetEquippedObject(i) == akBaseItem))
								WC.removeItemFromQueue(otherHand, foundAtOtherHand)
							endIf
							actionTaken = true
			    		endIf
			    	endIf
	        	endIf
	        endIf
        	i += 1
        endWhile
	endIf
	;debug.trace("iEquip_PlayerEventHandler OnItemRemoved end")
endEvent

event OnGetUp(ObjectReference akFurniture)
	;debug.trace("iEquip_PlayerEventHandler OnGetUp start")
	if akFurniture.HasKeyword(CraftingSmithingSharpeningWheel) || akFurniture.HasKeyword(CraftingSmithingArmorTable)
		;Check to see if the equipped hand items have been improved
		int i
		int itemType
		form equippedItem
		while i < 2
			equippedItem = PlayerRef.GetEquippedObject(i)
			if equippedItem
				itemType = equippedItem.GetType()
				if itemType == 41
					itemType = (equippedItem as weapon).GetWeaponType()
				endIf
				if TI.aiTemperedItemTypes.Find(itemType) > -1 && !(i == 0 && WC.ai2HWeaponTypes.Find(itemType) > -1 && !(itemType < 7 && WC.bIsCGOLoaded)) && (TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator)
					TI.checkAndUpdateTemperLevelInfo(i)
				endIf
			endIf
			i += 1
		endWhile
	endIf
	;debug.trace("iEquip_PlayerEventHandler OnGetUp end")
endEvent

state BEASTMODE
	event OnActorAction(int actionType, Actor akActor, Form source, int slot)
		;debug.trace("iEquip_PlayerEventHandler OnActorAction BEASTMODE start - actionType: " + actionType + ", slot: " + slot)	
		if akActor == PlayerRef
			if actionType == 7 || actionType == 8 ;Draw Begin or Draw End
				if !WC.bIsWidgetShown && !bWaitingForTransform
					WC.updateWidgetVisibility()
				endIf
				int i
				while i < 2
					if !WC.abIsNameShown[i]
						WC.showName(i)
					endIf
					i += 1
				endWhile
			elseIf actionType == 10 && WC.bIsWidgetShown && WC.bWidgetFadeoutEnabled ;Sheathe End
				WVis.registerForWidgetFadeoutUpdate()
			endIf
		endIf
		;debug.trace("iEquip_PlayerEventHandler OnActorAction BEASTMODE end")
	endEvent

	event OnAnimationEvent(ObjectReference aktarg, string EventName)
	   	;debug.trace("iEquip_PlayerEventHandler OnAnimationEvent BEASTMODE received - EventName: " + EventName)
	    if EventName == "LandStart" || EventName == "GroundStart"
	    	BM.showClaws()
	    elseIf EventName == "LiftoffStart"
	    	BM.showPreviousItems()
	    endIf
	   	;debug.trace("iEquip_PlayerEventHandler OnAnimationEvent BEASTMODE end")
	endEvent

	event OnGetUp(ObjectReference akFurniture)
	endEvent
endState

state PROCESSING
	event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	endEvent
endState

auto state DISABLED
	event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	endEvent

	event OnAnimationEvent(ObjectReference aktarg, string EventName)
	endEvent

	event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	endEvent

	event OnUpdate()
	endEvent

	event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	endEvent

	event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	endEvent

	event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	endEvent

	event OnGetUp(ObjectReference akFurniture)
	endEvent
endState

; Deprecated

bool processingQueuedForms
