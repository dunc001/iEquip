Scriptname iEquip_InventoryEventsListener extends Quest Hidden 

Import iEquip_InventoryExt

iEquip_WidgetCore Property WC Auto

function initialise(bool bEnabled)
	iEquip_InventoryExt.UnregisterForOnRefHandleInvalidatedEvent(self)
	if bEnabled
		iEquip_InventoryExt.RegisterForOnRefHandleInvalidatedEvent(self)
	endIf
endFunction

Event OnRefHandleInvalidated(Form a_item, Int a_refHandle)
	;debug.trace("iEquip_InventoryEventsListener OnRefHandleInvalidated event received - form: " + a_item + "(" + a_item.GetName() + "), refHandle: " + a_refHandle)
	
	if WC.bAutoEquipHardcore && WC.bJustDroppedCurrentItem && a_item == WC.fLastDroppedItem
		WC.bJustDroppedCurrentItem = false
	else
		int foundAt = JArray.FindInt(WC.iRefHandleArray, a_refHandle)
		if foundAt != -1
			int i
			int index
			while i < 2
				index = WC.findInQueue(i, "", none, a_refHandle)
				if index != -1
					WC.removeItemFromQueue(i, index, false, false, true)
				endIf
				i += 1
			endWhile
			JArray.EraseIndex(WC.iRefHandleArray, foundAt)
		endIf
	endIf
EndEvent
