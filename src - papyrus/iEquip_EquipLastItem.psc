; Equip Last Item by VictorF - An iEquip Add-On

Scriptname iEquip_EquipLastItem extends ReferenceAlias

import iEquip_StringExt

iEquip_WidgetCore Property WC auto
iEquip_PotionScript Property PO auto
iEquip_EquipLastItemUpdate Property ELU auto

Actor Property PlayerRef Auto
Keyword Property ArmorShield Auto
Sound Property vSpellLearned Auto

EquipSlot RightHand
EquipSlot LeftHand
EquipSlot EitherHand
EquipSlot BothHands
EquipSlot VoiceSlot

Form[] addedItems
bool[] persistent
ObjectReference[] addedRefs

int startIndex
int currentIndex

bool bEnabled

bool property DEST auto hidden

;int property defaultBehavior = 0 autoreadonly
int forceRight = 1
int forceLeft = 2

int shieldMask = 0x200

;weapons, ammo and shields
bool property bHandle1HWeapons = true auto hidden
bool property bHandle2HWeapons = true auto hidden
bool property bHandleRanged = true auto hidden
bool property bHandleAmmo = true auto hidden
bool property bHandleStaves = true auto hidden
bool property bHandleShields = true auto hidden
;armor
bool property bHandleLightArmor = true auto hidden
bool property bHandleHeavyArmor = true auto hidden
bool property bHandleClothing = true auto hidden
;potions
bool property bHandlePotions = true auto hidden
bool property bHandlePoisons = true auto hidden
bool property bHandleFood = true auto hidden
;books
bool property bHandleSpellTomes = true auto hidden
bool property bHandlePersistentBooks = false auto hidden
;other
bool property bHandleScrolls = true auto hidden
bool property bHandleIngredients = true auto hidden

float property fQueueTimeout = 30.0 auto hidden

bool clearWhenDone

bool bEquipSlotsSet

function initialise()
	;debug.trace("iEquip_EquipLastItem initialise start")
	setEquipSlots()

	addedItems = new Form[128]
	persistent = new bool[128]
	addedRefs = new ObjectReference[128]
	
	OnWidgetLoad()
	;debug.trace("iEquip_EquipLastItem initialise end")
endFunction

function setEquipSlots()
	;debug.trace("iEquip_EquipLastItem setEquipSlots start")
	LeftHand = WC.EquipSlots[0]
	RightHand = WC.EquipSlots[1]
	EitherHand = WC.EquipSlots[2]
	BothHands = WC.EquipSlots[3]
	VoiceSlot = WC.EquipSlots[4]

	bEquipSlotsSet = true
	;debug.trace("iEquip_EquipLastItem setEquipSlots end")
endFunction

bool property isEnabled 
	bool function Get()
		;debug.trace("iEquip_EquipLastItem isEnabled Get() returning " + bEnabled)
		Return bEnabled
	endFunction
	
	function Set(bool enabled)
        bEnabled = enabled
        ;debug.trace("iEquip_EquipLastItem isEnabled Set() setting bEnabled to " + bEnabled)
		if bEnabled
			GoToState("WAITING")
		else
			GoToState("DISABLED")
		endIf
	endFunction
EndProperty

function OnWidgetLoad()
	;debug.trace("iEquip_EquipLastItem OnWidgetLoad start")
	if bEnabled
		if !bEquipSlotsSet
			setEquipSlots()
		endIf
		if currentIndex < 0
			currentIndex = startIndex
		endIf
		goToState("WAITING")
	else
		goToState("DISABLED")
	endIf
	;debug.trace("iEquip_EquipLastItem OnWidgetLoad end")
endFunction

Form Property lastItem
	Form function get()
		;debug.trace("iEquip_EquipLastItem lastItem get() - looking for item at currentIndex: " + currentIndex)
		ELU.registerForEquipLastItemUpdate(fQueueTimeout)
		return addedItems[currentIndex]
	endFunction
endProperty

bool Property lastItemPersist
	bool function get()
		;debug.trace("iEquip_EquipLastItem lastItemPersist get() - returning " + persistent[currentIndex] + " for item at currentIndex: " + currentIndex)
		return persistent[currentIndex]
	endFunction
endProperty

ObjectReference Property lastItemRef
	ObjectReference function get()
		;debug.trace("iEquip_EquipLastItem lastItemRef get() - looking for ObjectReference at currentIndex: " + currentIndex)
		return addedRefs[currentIndex]
	endFunction
endProperty

state WAITING
	Event OnBeginState()
		;debug.trace("iEquip_EquipLastItem - switched to WAITING state")
	endEvent

	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		;debug.trace("iEquip_EquipLastItem OnItemAdded WAITING start - akBaseItem: " + akBaseItem.getName())
		goToState("ACTIVE")
		bool add = false
		if(akBaseItem as Weapon)
			int wt = (akBaseItem as Weapon).getWeaponType()
			add = (bHandle1HWeapons && (wt >= 1 && wt <= 4)) || (bHandle2HWeapons && (wt == 5 || wt == 6)) || (bHandleRanged && (wt == 7 || wt == 9)) || (bHandleStaves && wt == 8)
		elseif(akBaseItem as Ammo)
			add = bHandleAmmo
		elseif(akBaseItem as Armor)
			int weight = (akBaseItem as Armor).getWeightClass()
			bool notShield = Math.LogicalAnd(shieldMask, (akBaseItem as Armor).getSlotMask()) == 0
			add = (notShield || bHandleShields) && ((bHandleLightArmor && weight == 0) || (bHandleHeavyArmor && weight == 1) || (bHandleClothing && weight == 2))
		elseif(akBaseItem as Potion)
			bool isFood = (akBaseItem as Potion).isFood()
			bool isPoison = (akBaseItem as Potion).isPoison()
			bool isPotion = !isFood && !isPoison
			add = (bHandlePotions && isPotion) || (bHandlePoisons && isPoison) || (bHandleFood && isFood)
		elseif(akBaseItem as Book)
			add = (bHandleSpellTomes && (akBaseItem as Book).getSpell()) || (bHandlePersistentBooks && akItemReference)
		elseif(akBaseItem as Scroll)
			add = bHandleScrolls
		elseif(akBaseItem as Ingredient)
			add = bHandleIngredients
		endIf
		if(add)
			addItemToQueue(akBaseItem, akItemReference)
		endIf

		goToState("WAITING")
		;debug.trace("iEquip_EquipLastItem OnItemAdded WAITING end")
	endEvent
endState

state ACTIVE
	Event OnBeginState()
		;debug.trace("iEquip_EquipLastItem - switched to ACTIVE state")
	endEvent

	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		;player did something too fast, clear lastItem on exit state
		;debug.trace("iEquip_EquipLastItem OnItemAdded ACTIVE start - akBaseItem: " + akBaseItem.getName())
		clearWhenDone = true
		;debug.trace("iEquip_EquipLastItem OnItemAdded ACTIVE end")
	endEvent
	
	Event OnEndState()
		if(clearWhenDone)
			clearWhenDone = false
			clearLastItem()
		endIf
	endEvent
endState

state DISABLED
	Event OnBeginState()
		;debug.trace("iEquip_EquipLastItem - switched to DISABLED state")
	endEvent

	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	endEvent

	function useLast(bool useLeft)
	endFunction
endState

function runUpdate()
	;debug.trace("iEquip_EquipLastItem runUpdate start")
	goToState("ACTIVE")
	restartQueue()
	goToState("WAITING")
	;debug.trace("iEquip_EquipLastItem runUpdate end")
endFunction

function addItemToQueue(Form akBaseItem, ObjectReference akItemReference = None)
	;debug.trace("iEquip_EquipLastItem addItemToQueue start - currentIndex: " + currentIndex + ", startIndex: " + startIndex)
	currentIndex = (currentIndex + 1) % 128
	persistent[currentIndex] = akItemReference != None
	addedRefs[currentIndex] = akItemReference
	addedItems[currentIndex] = akBaseItem
	;if(lastItemPersist) ;not sure if this is necessary
	;	lastItem = lastItemRef.getBaseObject()
	;endIf
	if(currentIndex == startIndex)
		startIndex = (startIndex + 1) % 128
	endIf
	;debug.trace("iEquip_EquipLastItem addItemToQueue end - Added item " + akBaseItem.getName() + " at index " + currentIndex + ".")
	ELU.registerForEquipLastItemUpdate(fQueueTimeout)
endFunction

function clearLastItem()
	;debug.trace("iEquip_EquipLastItem clearLastItem start - currentIndex: " + currentIndex + ", startIndex: " + startIndex)
	addedItems[currentIndex] = None
	persistent[currentIndex] = false
	addedRefs[currentIndex] = None
	int i
	while (addedItems[currentIndex] == None && currentIndex != startIndex) && i < 128
		currentIndex -= 1
		if currentIndex < 0
			currentIndex = 127
		endIf
		i += 1
	endWhile
	;debug.trace("iEquip_EquipLastItem clearLastItem end - currentIndex: " + currentIndex + ", startIndex: " + startIndex)
endFunction

function restartQueue()
	;debug.trace("iEquip_EquipLastItem restartQueue Start")
	startIndex = currentIndex
	addedItems[currentIndex] = None
	persistent[currentIndex] = false
	addedRefs[currentIndex] = None
	;debug.trace("iEquip_EquipLastItem restartQueue end - currentIndex: " + currentIndex + ", startIndex: " + startIndex)
endFunction

function useLast(bool useLeft)
	;debug.trace("iEquip_EquipLastItem useLast start - currentIndex: " + currentIndex)
	form fItem = lastItem
	if fItem ;check if last item hasn't been cleared
		;debug.trace("iEquip_EquipLastItem useLast - item found at currentIndex: " + fItem.GetName())
		bool cleanupWhenDone = true
		if(PlayerRef.getItemCount(fItem) > 0 || PlayerRef.hasSpell(fItem as Spell))
			if(fItem as Weapon) ;weapon - pass to iequip
				Weapon lastWeapon = fItem as Weapon
				int force ; = defaultBehavior
				int wt = lastWeapon.getWeaponType()
				if((wt >= 1 && wt <= 4) || wt == 8) ; one-handed weapons
					if(useLeft)
						force = forceLeft
					else
						force = forceRight
					endIf
				elseif(wt == 5 || wt == 6) ; two handed weapons
					if(WC.bIsCGOLoaded && useLeft)
						force = forceLeft
					else
						force = forceRight
					endIf
				elseif(wt == 7 || wt == 9)
					force = forceRight
				endIf
				WC.onWeaponOrShieldAdded(fItem, force)
			elseif(fItem as Armor && fItem.hasKeyword(ArmorShield)) ;shield - pass to iequip
				WC.onWeaponOrShieldAdded(fItem, forceLeft)
			elseif(fItem as Armor || (fItem as Ammo && (!WC.bAmmoMode || ((PlayerRef.GetEquippedItemType(1) == 7 && !(fItem as Ammo).IsBolt()) || (PlayerRef.GetEquippedItemType(1) == 12 && (fItem as Ammo).IsBolt())))) || fItem as Ingredient) ;simple item - just equip directly
				PlayerRef.equipItem(fItem)
			elseif(fItem as Book) ;only persistent books or spell tomes added, read or add spell to player and queue
				Book lastBook = fItem as Book
				Spell s = lastBook.getSpell()
				if(s) ; the book is a spell tome
					if(DEST); Parapets says can't emit DEST event from papyrus, so ignore that case for now.
					; patch in other mods directly here
					else ; handle spell tome. 
						if !PlayerRef.HasSpell(s) ;code taken from DEST
							PlayerRef.RemoveItem(lastBook, 1, abSilent = true)
							string sSpellAdded = Game.GetGameSettingString("sSpellAdded")
							string sText = sSpellAdded + ": " + s.GetName()
							vSpellLearned.play(PlayerRef)
							PlayerRef.AddSpell(s, abVerbose = false)
							debug.notification(sText)
							addItemToQueue(s)
							clearWhenDone = false
						else
							string sAlreadyKnown = Game.GetGameSettingString("sAlreadyKnown")
							string sText = sAlreadyKnown + " " + s.GetName()
							debug.notification(sText)
						endif
					endIf
				else ; persistent book, most likely from quest, just activate it
					lastItemRef.activate(PlayerRef)
				endif
			elseif(fItem as Spell) ;"wait but spells aren't items" lies. deception.
				Spell lastSpell = fItem as Spell
				EquipSlot usedSlot = lastSpell.getEquipType()
				if(usedSlot == RightHand || (usedSlot == EitherHand && !useLeft) || usedSlot == BothHands)
					PlayerRef.equipSpell(lastSpell, 1)
				elseif(usedSlot == LeftHand || usedSlot == EitherHand)
					PlayerRef.equipSpell(lastSpell, 0)
				elseif(usedSlot == VoiceSlot)
					PlayerRef.equipSpell(lastSpell, 2)
				endIf
			elseif(fItem as Scroll) ; equip to hand by equip type, same as spells.
				Scroll lastScroll = fItem as Scroll
				EquipSlot usedSlot = lastScroll.getEquipType()
				if(usedSlot == RightHand || (usedSlot == EitherHand && !useLeft) || usedSlot == BothHands)
					PlayerRef.EquipItemEx(lastScroll, 1)
				elseif(usedSlot == LeftHand || usedSlot == EitherHand)
					PlayerRef.EquipItemEx(lastScroll, 2)
				endIf
			elseif(fItem as Potion);use potions, queue and cycle to poisons
				Potion lastPotion = fItem as Potion
				if(lastPotion.isPoison()); hand poisons off to iequip because it has way more features than i do
					PO.checkAndAddToPoisonQueue(lastPotion)
					PO.sortPoisonQueue()
					WC.jumpToPoisonQueueIndex(lastPotion.GetName(), lastPotion)
				else
					PlayerRef.EquipItemEx(lastPotion)
					debug.notification(lastPotion.GetName() + " " + iEquip_StringExt.LocalizeString("$iEquip_PO_PotionConsumed"))
				endIf
			endIf
		endIf
		if(cleanupWhenDone)
			clearLastItem()
		endIf
	else
		debug.notification(iEquip_StringExt.LocalizeString("$iEquip_EL_not_noItems"))
	endIf
	;debug.trace("iEquip_EquipLastItem useLast end")
endFunction

; Deprecated
Event OnUpdate()
endEvent