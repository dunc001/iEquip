﻿import skyui.widgets.iEquip.iEquipWidgetBase;
import skyui.widgets.iEquip.iEquipSoulGem;
import skyui.widgets.iEquip.iEquipMeter;
import skyui.widgets.iEquip.iEquipRadialMeter;
import skyui.widgets.iEquip.iEquipPositionIndicator;
import skyui.widgets.iEquip.iEquipEditMode;

import gfx.io.GameDelegate;

import com.iequip.TimelineLite;
import com.iequip.TweenLite;
import com.iequip.easing.*;
import com.iequip.plugins.TweenPlugin;
import com.iequip.plugins.DirectionalRotationPlugin;

import flash.geom.ColorTransform;
import flash.geom.Transform;

import flash.filters.DropShadowFilter;

import skyui.util.Debug;

class skyui.widgets.iEquip.iEquipWidget extends iEquipWidgetBase
{	
  /* STAGE ELEMENTS */

	//Widget MovieClips
	public var widgetMaster: MovieClip;
	public var LeftHandWidget: MovieClip;
	public var RightHandWidget: MovieClip;
	public var ShoutWidget: MovieClip;
	public var ConsumableWidget: MovieClip;
	public var PoisonWidget: MovieClip;
	public var EditModeGuide: iEquipEditMode;

	//Widget background MovieClips
	public var leftBg_mc: MovieClip;
	public var rightBg_mc: MovieClip;
	public var shoutBg_mc: MovieClip;
	public var leftPreselectBg_mc: MovieClip;
	public var rightPreselectBg_mc: MovieClip;
	public var shoutPreselectBg_mc: MovieClip;
	public var consumableBg_mc: MovieClip;
	public var poisonBg_mc: MovieClip;
	
	//Widget graphical element MovieClips
	public var leftIcon_mc: MovieClip;
	public var leftPoisonIcon_mc: MovieClip;
	public var leftAttributeIcons_mc: MovieClip;
	public var leftEnchantmentMeter_mc: MovieClip;
	public var leftRadialMeter_mc: MovieClip;
	public var leftSoulgem_mc: MovieClip;
	public var leftTierIndicator_mc: MovieClip;
	public var leftPositionIndicator_mc: MovieClip;
	public var leftPreselectIcon_mc: MovieClip;
	public var leftPreselectAttributeIcons_mc: MovieClip;
	public var leftPreselectTierIndicator_mc: MovieClip;
	public var rightIcon_mc: MovieClip;
	public var rightPoisonIcon_mc: MovieClip;
	public var rightAttributeIcons_mc: MovieClip;
	public var rightEnchantmentMeter_mc: MovieClip;
	public var rightRadialMeter_mc: MovieClip;
	public var rightSoulgem_mc: MovieClip;
	public var rightTierIndicator_mc: MovieClip;
	public var rightPositionIndicator_mc: MovieClip;
	public var rightPreselectIcon_mc: MovieClip;
	public var rightPreselectAttributeIcons_mc: MovieClip;
	public var rightPreselectTierIndicator_mc: MovieClip;
	public var shoutIcon_mc: MovieClip;
	public var shoutPositionIndicator_mc: MovieClip;
	public var shoutPreselectIcon_mc: MovieClip;
	public var consumableIcon_mc: MovieClip;
	public var poisonIcon_mc: MovieClip;
	
	//Widget text field holder MovieClips
	public var leftName_mc: MovieClip;
	public var leftPoisonName_mc: MovieClip;
	public var leftCount_mc: MovieClip;
	public var leftPreselectName_mc: MovieClip;
	public var rightName_mc: MovieClip;
	public var rightPoisonName_mc: MovieClip;
	public var rightCount_mc: MovieClip;
	public var rightPreselectName_mc: MovieClip;
	public var shoutName_mc: MovieClip;
	public var shoutPreselectName_mc: MovieClip;
	public var consumableName_mc: MovieClip;
	public var consumableCount_mc: MovieClip;
	public var poisonName_mc: MovieClip;
	public var poisonCount_mc: MovieClip;
	
	//Widget Text Fields
	public var leftName: TextField;
	public var leftPoisonName: TextField;
	public var leftCount: TextField;
	public var leftPreselectName: TextField;
	public var rightName: TextField;
	public var rightPoisonName: TextField;
	public var rightCount: TextField;
	public var rightPreselectName: TextField;
	public var shoutName: TextField;
	public var shoutPreselectName: TextField;
	public var consumableName: TextField;
	public var consumableCount: TextField;
	public var poisonName: TextField;
	public var poisonCount: TextField;

	//Potion Selector Elements
	public var potionSelector_mc: MovieClip;
	public var selector: MovieClip;
	//public var selectorRight: MovieClip;
	public var restoreText: TextField;
	public var fortifyText: TextField;
	public var regenText: TextField;

	public var leftIcon: MovieClip;
	public var leftPoisonIcon: MovieClip;
	public var leftAttributeIcons: MovieClip;
	public var rightIcon: MovieClip;
	public var rightPoisonIcon: MovieClip;
	public var rightAttributeIcons: MovieClip;
	public var shoutIcon: MovieClip;
	public var leftPreselectIcon: MovieClip;
	public var leftPreselectAttributeIcons: MovieClip;
	public var rightPreselectIcon: MovieClip;
	public var rightPreselectAttributeIcons: MovieClip;
	public var shoutPreselectIcon: MovieClip;
	public var consumableIcon: MovieClip;
	public var potionFlashAnim: MovieClip;
	public var poisonIcon: MovieClip;
	public var poisonFlashAnim: MovieClip;

	public var leftMeter: iEquipMeter;
	public var rightMeter: iEquipMeter;
	public var leftSoulGem: iEquipSoulGem;
	public var rightSoulGem: iEquipSoulGem;
	public var leftRadialMeter: iEquipRadialMeter;
	public var rightRadialMeter: iEquipRadialMeter;

	public var leftPositionIndicator: iEquipPositionIndicator;
	public var rightPositionIndicator: iEquipPositionIndicator;
	public var shoutPositionIndicator: iEquipPositionIndicator;

	public var leftTierIndicator: MovieClip;
	public var rightTierIndicator: MovieClip;
	public var leftPreselectTierIndicator: MovieClip;
	public var rightPreselectTierIndicator: MovieClip;

	// Variables containing the currently selected movieclip or textfield
	public var clip: MovieClip;
	public var selectedText: TextField;
	
	// Arrays containing every movieclip and textfield, etc
	public var clipArray: Array;
	public var textElementArray: Array;
	public var textFieldArray: Array;
	public var posIndArray: Array;
	public var temperTierStyleArray: Array;
	public var backgroundStyleArray: Array;
	public var backgroundClipArray: Array;
	public var enchantmentMeterArray: Array;
	
  /* INITIALIZATION */

	public function iEquipWidget()
	{
		super();

		TweenPlugin.activate([DirectionalRotationPlugin]);

		_visible = false;

		Mouse.addListener(this);
		GameDelegate.addCallBack("InvalidateListData", this, "InvalidateListData");
		
		//Set up the sub widget MovieClips
		LeftHandWidget = widgetMaster.LeftHandWidget
		RightHandWidget = widgetMaster.RightHandWidget
		ShoutWidget = widgetMaster.ShoutWidget
		ConsumableWidget = widgetMaster.ConsumableWidget
		PoisonWidget = widgetMaster.PoisonWidget

		//Set up the background MovieClips
		leftBg_mc = widgetMaster.LeftHandWidget.leftBg_mc;
		rightBg_mc = widgetMaster.RightHandWidget.rightBg_mc;
		shoutBg_mc = widgetMaster.ShoutWidget.shoutBg_mc;
		leftPreselectBg_mc = widgetMaster.LeftHandWidget.leftPreselectBg_mc;
		rightPreselectBg_mc = widgetMaster.RightHandWidget.rightPreselectBg_mc;
		shoutPreselectBg_mc = widgetMaster.ShoutWidget.shoutPreselectBg_mc;
		consumableBg_mc = widgetMaster.ConsumableWidget.consumableBg_mc;
		poisonBg_mc = widgetMaster.PoisonWidget.poisonBg_mc;
		
		//Backgrounds are hidden by default
		leftBg_mc.gotoAndStop("Hidden");
		rightBg_mc.gotoAndStop("Hidden");
		shoutBg_mc.gotoAndStop("Hidden");
		leftPreselectBg_mc.gotoAndStop("Hidden");
		rightPreselectBg_mc.gotoAndStop("Hidden");
		shoutPreselectBg_mc.gotoAndStop("Hidden");
		consumableBg_mc.gotoAndStop("Hidden");
		poisonBg_mc.gotoAndStop("Hidden");

		//Set up the graphical element and text field holder MovieClips
		leftIcon_mc = widgetMaster.LeftHandWidget.leftIcon_mc;
		leftPoisonIcon_mc = widgetMaster.LeftHandWidget.leftPoisonIcon_mc;
		leftAttributeIcons_mc = widgetMaster.LeftHandWidget.leftAttributeIcons_mc;
		leftEnchantmentMeter_mc = widgetMaster.LeftHandWidget.leftEnchantmentMeter_mc;
		leftRadialMeter_mc = widgetMaster.LeftHandWidget.leftRadialMeter_mc;
		leftTierIndicator_mc = widgetMaster.LeftHandWidget.leftTierIndicator_mc;
		leftPositionIndicator_mc = widgetMaster.LeftHandWidget.leftPositionIndicator_mc;
		leftSoulgem_mc = widgetMaster.LeftHandWidget.leftSoulgem_mc;
		rightIcon_mc = widgetMaster.RightHandWidget.rightIcon_mc;
		rightPoisonIcon_mc = widgetMaster.RightHandWidget.rightPoisonIcon_mc;
		rightAttributeIcons_mc = widgetMaster.RightHandWidget.rightAttributeIcons_mc;
		rightEnchantmentMeter_mc = widgetMaster.RightHandWidget.rightEnchantmentMeter_mc;
		rightRadialMeter_mc = widgetMaster.RightHandWidget.rightRadialMeter_mc;
		rightTierIndicator_mc = widgetMaster.RightHandWidget.rightTierIndicator_mc;
		rightPositionIndicator_mc = widgetMaster.RightHandWidget.rightPositionIndicator_mc;
		rightSoulgem_mc = widgetMaster.RightHandWidget.rightSoulgem_mc;
		shoutIcon_mc = widgetMaster.ShoutWidget.shoutIcon_mc;
		shoutPositionIndicator_mc = widgetMaster.ShoutWidget.shoutPositionIndicator_mc;
		consumableIcon_mc = widgetMaster.ConsumableWidget.consumableIcon_mc;
		poisonIcon_mc = widgetMaster.PoisonWidget.poisonIcon_mc;
		leftName_mc = widgetMaster.LeftHandWidget.leftName_mc;
		leftPoisonName_mc = widgetMaster.LeftHandWidget.leftPoisonName_mc;
		leftCount_mc = widgetMaster.LeftHandWidget.leftCount_mc;
		rightName_mc = widgetMaster.RightHandWidget.rightName_mc;
		rightPoisonName_mc = widgetMaster.RightHandWidget.rightPoisonName_mc;
		rightCount_mc = widgetMaster.RightHandWidget.rightCount_mc;
		shoutName_mc = widgetMaster.ShoutWidget.shoutName_mc;
		consumableName_mc = widgetMaster.ConsumableWidget.consumableName_mc;
		consumableCount_mc = widgetMaster.ConsumableWidget.consumableCount_mc;
		poisonName_mc = widgetMaster.PoisonWidget.poisonName_mc;
		poisonCount_mc = widgetMaster.PoisonWidget.poisonCount_mc;

		//Set up the queue position indicator paths
		leftPositionIndicator = widgetMaster.LeftHandWidget.leftPositionIndicator_mc.leftPositionIndicator;
		rightPositionIndicator = widgetMaster.RightHandWidget.rightPositionIndicator_mc.rightPositionIndicator;
		shoutPositionIndicator = widgetMaster.ShoutWidget.shoutPositionIndicator_mc.shoutPositionIndicator;

		//Set up the temper tier indicator paths
		leftTierIndicator = widgetMaster.LeftHandWidget.leftTierIndicator_mc.leftTierIndicator;
		rightTierIndicator = widgetMaster.RightHandWidget.rightTierIndicator_mc.rightTierIndicator;
		leftPreselectTierIndicator = widgetMaster.LeftHandWidget.leftPreselectTierIndicator_mc.leftPreselectTierIndicator;
		rightPreselectTierIndicator = widgetMaster.RightHandWidget.rightPreselectTierIndicator_mc.rightPreselectTierIndicator;

		//Set up the potion selector paths
		potionSelector_mc = widgetMaster.ConsumableWidget.potionSelector_mc;
		selector = widgetMaster.ConsumableWidget.potionSelector_mc.selector;
		//selectorRight = widgetMaster.ConsumableWidget.potionSelector_mc.selectorRight;
		restoreText = widgetMaster.ConsumableWidget.potionSelector_mc.restoreText;
		fortifyText = widgetMaster.ConsumableWidget.potionSelector_mc.fortifyText;
		regenText = widgetMaster.ConsumableWidget.potionSelector_mc.regenText;
		potionSelector_mc.gotoAndStop("left");
		selector.gotoAndStop("_left");

		//Set up the preselect icon and text field holder MovieClips
		leftPreselectIcon_mc = widgetMaster.LeftHandWidget.leftPreselectIcon_mc;
		leftPreselectAttributeIcons_mc = widgetMaster.LeftHandWidget.leftPreselectAttributeIcons_mc;
		leftPreselectTierIndicator_mc = widgetMaster.LeftHandWidget.leftPreselectTierIndicator_mc;
		rightPreselectIcon_mc = widgetMaster.RightHandWidget.rightPreselectIcon_mc;
		rightPreselectAttributeIcons_mc = widgetMaster.RightHandWidget.rightPreselectAttributeIcons_mc;
		rightPreselectTierIndicator_mc = widgetMaster.RightHandWidget.rightPreselectTierIndicator_mc;
		shoutPreselectIcon_mc = widgetMaster.ShoutWidget.shoutPreselectIcon_mc;
		leftPreselectName_mc = widgetMaster.LeftHandWidget.leftPreselectName_mc;
		rightPreselectName_mc = widgetMaster.RightHandWidget.rightPreselectName_mc;
		shoutPreselectName_mc = widgetMaster.ShoutWidget.shoutPreselectName_mc;
		
		//Set up the icon object paths
		leftIcon = widgetMaster.LeftHandWidget.leftIcon_mc.leftIcon;
		leftPoisonIcon = widgetMaster.LeftHandWidget.leftPoisonIcon_mc.leftPoisonIcon;
		leftAttributeIcons = widgetMaster.LeftHandWidget.leftAttributeIcons_mc.leftAttributeIcons;
		leftSoulGem = widgetMaster.LeftHandWidget.leftSoulgem_mc.leftSoulGem;
		leftMeter = widgetMaster.LeftHandWidget.leftEnchantmentMeter_mc.leftMeter;
		leftRadialMeter = widgetMaster.LeftHandWidget.leftRadialMeter_mc.leftRadialMeter;
		rightIcon = widgetMaster.RightHandWidget.rightIcon_mc.rightIcon;
		rightPoisonIcon = widgetMaster.RightHandWidget.rightPoisonIcon_mc.rightPoisonIcon;
		rightAttributeIcons = widgetMaster.RightHandWidget.rightAttributeIcons_mc.rightAttributeIcons;
		rightSoulGem = widgetMaster.RightHandWidget.rightSoulgem_mc.rightSoulGem;
		rightMeter = widgetMaster.RightHandWidget.rightEnchantmentMeter_mc.rightMeter;
		rightRadialMeter = widgetMaster.RightHandWidget.rightRadialMeter_mc.rightRadialMeter;
		shoutIcon = widgetMaster.ShoutWidget.shoutIcon_mc.shoutIcon;
		consumableIcon = widgetMaster.ConsumableWidget.consumableIcon_mc.consumableIcon;
		potionFlashAnim = widgetMaster.ConsumableWidget.consumableIcon_mc.potionFlashAnim;
		poisonIcon = widgetMaster.PoisonWidget.poisonIcon_mc.poisonIcon;
		poisonFlashAnim = widgetMaster.PoisonWidget.poisonIcon_mc.poisonFlashAnim;

		//Set up the preselect icon object paths
		leftPreselectIcon = widgetMaster.LeftHandWidget.leftPreselectIcon_mc.leftPreselectIcon;
		leftPreselectAttributeIcons = widgetMaster.LeftHandWidget.leftPreselectAttributeIcons_mc.leftPreselectAttributeIcons;
		rightPreselectIcon = widgetMaster.RightHandWidget.rightPreselectIcon_mc.rightPreselectIcon;
		rightPreselectAttributeIcons = widgetMaster.RightHandWidget.rightPreselectAttributeIcons_mc.rightPreselectAttributeIcons;
		shoutPreselectIcon = widgetMaster.ShoutWidget.shoutPreselectIcon_mc.shoutPreselectIcon;
		
		//Set up text fields, initial empty string and auto resize attributes
		leftName = widgetMaster.LeftHandWidget.leftName_mc.leftName;
		leftPoisonName = widgetMaster.LeftHandWidget.leftPoisonName_mc.leftPoisonName;
		leftCount = widgetMaster.LeftHandWidget.leftCount_mc.leftCount;
		leftPreselectName = widgetMaster.LeftHandWidget.leftPreselectName_mc.leftPreselectName;
		rightName = widgetMaster.RightHandWidget.rightName_mc.rightName;
		rightPoisonName = widgetMaster.RightHandWidget.rightPoisonName_mc.rightPoisonName;
		rightCount = widgetMaster.RightHandWidget.rightCount_mc.rightCount;
		rightPreselectName = widgetMaster.RightHandWidget.rightPreselectName_mc.rightPreselectName;
		shoutName = widgetMaster.ShoutWidget.shoutName_mc.shoutName;
		shoutPreselectName = widgetMaster.ShoutWidget.shoutPreselectName_mc.shoutPreselectName;
		consumableName = widgetMaster.ConsumableWidget.consumableName_mc.consumableName;
		consumableCount = widgetMaster.ConsumableWidget.consumableCount_mc.consumableCount;
		poisonName = widgetMaster.PoisonWidget.poisonName_mc.poisonName;
		poisonCount = widgetMaster.PoisonWidget.poisonCount_mc.poisonCount;
		leftName.text = " ";
		leftPoisonName.text = " ";
		leftCount.text = " ";
		leftPreselectName.text = " ";
		rightName.text = " ";
		rightPoisonName.text = " ";
		rightCount.text = " ";
		rightPreselectName.text = " ";
		shoutName.text = " ";
		shoutPreselectName.text = " ";
		consumableName.text = " ";
		consumableCount.text = " ";
		poisonName.text = " ";
		poisonCount.text = " ";
		leftName.verticalAutoSize = "top";
		leftPoisonName.verticalAutoSize = "top";
		leftCount.verticalAutoSize = "top";
		leftPreselectName.verticalAutoSize = "top";
		rightName.verticalAutoSize = "top";
		rightPoisonName.verticalAutoSize = "top";
		rightCount.verticalAutoSize = "top";
		rightPreselectName.verticalAutoSize = "top";
		shoutName.verticalAutoSize = "top";
		shoutPreselectName.verticalAutoSize = "top";
		consumableName.verticalAutoSize = "top";
		consumableCount.verticalAutoSize = "top";
		poisonName.verticalAutoSize = "top";
		poisonCount.verticalAutoSize = "top";
		leftIcon.gotoAndStop("Empty");
		leftPoisonIcon.gotoAndStop("Hidden");
		leftAttributeIcons.gotoAndStop("Hidden");
		rightIcon.gotoAndStop("Empty");
		rightPoisonIcon.gotoAndStop("Hidden");
		rightAttributeIcons.gotoAndStop("Hidden");
		shoutIcon.gotoAndStop("Empty");
		consumableIcon.gotoAndStop("Empty");
		potionFlashAnim.gotoAndStop("Hide");
		potionFlashAnim._alpha = 0.0;
		poisonIcon.gotoAndStop("Empty");
		poisonFlashAnim.gotoAndStop("Hide");
		poisonFlashAnim._alpha = 0.0;
		leftPreselectIcon.gotoAndStop("Empty");
		leftPreselectAttributeIcons.gotoAndStop("Hidden");
		rightPreselectIcon.gotoAndStop("Empty");
		rightPreselectAttributeIcons.gotoAndStop("Hidden");
		shoutPreselectIcon.gotoAndStop("Empty");

		leftEnchantmentMeter_mc._xscale = 25;
		leftEnchantmentMeter_mc._yscale = 25;
		leftEnchantmentMeter_mc._visible = false;
		leftSoulgem_mc._visible = false;
		leftRadialMeter_mc._visible = false;
		rightEnchantmentMeter_mc._xscale = 25;
		rightEnchantmentMeter_mc._yscale = 25;
		rightEnchantmentMeter_mc._visible = false;
		rightSoulgem_mc._visible = false;
		rightRadialMeter_mc._visible = false;
		
		//Set up arrays of MovieClips and text elements ready for use in Edit Mode etc
		clipArray = new Array(widgetMaster, LeftHandWidget, RightHandWidget, ShoutWidget, ConsumableWidget, PoisonWidget, leftBg_mc, leftIcon_mc, leftName_mc, leftCount_mc, leftPoisonIcon_mc, leftPoisonName_mc, leftAttributeIcons_mc, leftEnchantmentMeter_mc, leftSoulgem_mc, leftRadialMeter_mc, leftTierIndicator_mc, leftPositionIndicator_mc, leftPreselectBg_mc, leftPreselectIcon_mc, leftPreselectName_mc, leftPreselectAttributeIcons_mc, leftPreselectTierIndicator_mc, rightBg_mc, rightIcon_mc, rightName_mc, rightCount_mc, rightPoisonIcon_mc, rightPoisonName_mc, rightAttributeIcons_mc, rightEnchantmentMeter_mc, rightSoulgem_mc, rightRadialMeter_mc, rightTierIndicator_mc, rightPositionIndicator_mc, rightPreselectBg_mc, rightPreselectIcon_mc, rightPreselectName_mc, rightPreselectAttributeIcons_mc, rightPreselectTierIndicator_mc, shoutBg_mc, shoutIcon_mc, shoutName_mc, shoutPositionIndicator_mc, shoutPreselectBg_mc, shoutPreselectIcon_mc, shoutPreselectName_mc, consumableBg_mc, consumableIcon_mc, consumableName_mc, consumableCount_mc, potionSelector_mc, poisonBg_mc, poisonIcon_mc, poisonName_mc, poisonCount_mc);
		
		textElementArray = new Array(null, null, null, null, null, null, null, null, leftName, leftCount, null, leftPoisonName, null, null, null, null, null, null, null, null, leftPreselectName, null, null, null, null, rightName, rightCount, null, rightPoisonName, null, null, null, null, null, null, null, null, rightPreselectName, null, null, null, null, shoutName, null, null, null, shoutPreselectName, null, null, consumableName, consumableCount, null, null, null, poisonName, poisonCount);

		textFieldArray = new Array(leftName, leftCount, leftPoisonName, leftPreselectName, rightName, rightCount, rightPoisonName, rightPreselectName, shoutName, shoutPreselectName, consumableName, consumableCount, restoreText, fortifyText, regenText, poisonName, poisonCount);
		posIndArray = new Array(leftPositionIndicator, rightPositionIndicator, shoutPositionIndicator);

		temperTierStyleArray = new Array("Uniform", "Increasing", "Diamond", "Star", "Hammer", "Anvil", "Asterisk", "Caret");
		
		backgroundStyleArray = new Array("Hidden", "Square", "SquareNoBorder", "Round", "RoundNoBorder", "RoundFade", "Dialogue", "DarkSouls", "DarkSoulsSimple");
		backgroundClipArray = new Array(leftBg_mc, rightBg_mc, shoutBg_mc, leftPreselectBg_mc, rightPreselectBg_mc, shoutPreselectBg_mc, consumableBg_mc, poisonBg_mc);

		enchantmentMeterArray = new Array(leftEnchantmentMeter_mc, leftSoulgem_mc, leftRadialMeter_mc, rightEnchantmentMeter_mc, rightSoulgem_mc, rightRadialMeter_mc);

		handleTextFieldDropShadow(false);
	}
	
	public function setWidgetToEmpty(): Void
	{
		leftIcon.gotoAndStop("Add")
		rightIcon.gotoAndStop("Add")
		shoutIcon.gotoAndStop("Add")
		consumableIcon.gotoAndStop("Add")
		poisonIcon.gotoAndStop("Add")
		shoutName.text = "--Empty--";
		leftName.text = "--Empty--";
		rightName.text = "--Empty--";
		consumableName.text = "--Empty--";
		poisonName.text = "--Empty--";
	}

  	//PUBLIC FUNCTIONS
	//@Papyrus
	//Main widget update function
	//sSlot: 0 = Left Hand, 1 = Right Hand, 2 = Shout, 3 = Consumable, 4 = Poison, 5 = Left Preselect, 6 = Right Preselect, 7 = Shout Preselect
	public function updateWidget(iSlot: Number, sIcon: String, sName: String, iNameAlpha: Number, currAlpha: Number, currScale: Number): Void
	{
		//skyui.util.Debug.log("iEquipWidget updateWidget - iSlot: " + iSlot + ", sIcon: " + sIcon + ", sName: " + sName);
		if (sName == undefined || sName == ""){
			sName = " ";
		}

		var iconClip: MovieClip;
		var itemIcon: MovieClip;
		var nameClip: MovieClip;
		var itemName: TextField;

		switch(iSlot) {
			case 0:
				iconClip = leftIcon_mc
				itemIcon = leftIcon
				nameClip = leftName_mc
				itemName = leftName
				break;
			case 1:
				iconClip = rightIcon_mc
				itemIcon = rightIcon
				nameClip = rightName_mc
				itemName = rightName
				break;
			case 2:
				iconClip = shoutIcon_mc
				itemIcon = shoutIcon
				nameClip = shoutName_mc
				itemName = shoutName
				break;
			case 3:
				iconClip = consumableIcon_mc
				itemIcon = consumableIcon
				nameClip = consumableName_mc
				itemName = consumableName
				break;
			case 4:
				iconClip = poisonIcon_mc
				itemIcon = poisonIcon
				nameClip = poisonName_mc
				itemName = poisonName
				break;
			case 5:
				iconClip = leftPreselectIcon_mc
				itemIcon = leftPreselectIcon
				nameClip = leftPreselectName_mc
				itemName = leftPreselectName
				break;
			case 6:
				iconClip = rightPreselectIcon_mc
				itemIcon = rightPreselectIcon
				nameClip = rightPreselectName_mc
				itemName = rightPreselectName
				break;
			case 7:
				iconClip = shoutPreselectIcon_mc
				itemIcon = shoutPreselectIcon
				nameClip = shoutPreselectName_mc
				itemName = shoutPreselectName
				break;
			};

		//skyui.util.Debug.log("iEquipWidget updateWidget - currAlpha: " + currAlpha + ", currScale: " + currScale)
		//skyui.util.Debug.log("iEquipWidget updateWidget - currently displayed item name: " + itemName.text)

		if(currAlpha == undefined){
			currAlpha = iconClip._alpha;
		}

		if(currScale == undefined){
			currScale = iconClip._xscale;
		}
		
		//skyui.util.Debug.log("iEquipWidget updateWidget - iSlot: " + iSlot + ", currAlpha: " + currAlpha + ", currScale: " + currScale)
		//Create the animation timeline
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});

		if (isAlreadyOnFrame(itemIcon, sIcon) && ((itemName.text == sName) || (sIcon == "Fist" && sName == "$iEquip_common_Unarmed"))){
			//Fade and scale the current icon - won't do anything if the values match current
			tl.to(iconClip, 0.10, {_alpha:currAlpha, _xscale:currScale, _yscale:currScale, ease:Quad.easeOut}, 0.08)
			//And the same with the name
			.to(nameClip, 0.10, {_alpha:iNameAlpha, ease:Quad.easeOut}, 0.08);
		} else {
			//Fade out and shrink the icon
			tl.to(iconClip, 0.05, {_alpha:0, _xscale:0.25, _yscale:0.25, ease:Quad.easeOut}, 0)
			//Fade out the name
			.to(nameClip, 0.05, {_alpha:0, ease:Quad.easeOut}, 0)
			//Set the new icon and name and update the icon colour if potion/poison whilst not visible
			.call(updateIconAndName, [itemIcon, itemName, sIcon, sName])
			//Fade and scale the new icon back in
			.to(iconClip, 0.10, {_alpha:currAlpha, _xscale:currScale, _yscale:currScale, ease:Quad.easeOut}, 0.08)
			//Finally fade the new name back in
			.to(nameClip, 0.10, {_alpha:iNameAlpha, ease:Quad.easeOut}, 0.08);
		}
		//And ACTION!
		tl.play();
	}

	public function isAlreadyOnFrame(itemIcon: MovieClip, sIcon: String):Boolean 
	{		
		var currentFrame:Number = itemIcon._currentframe;
		var mc:MovieClip = itemIcon.duplicateMovieClip("_tempMC", itemIcon._parent.getNextHighestDepth()); 
		mc.gotoAndStop(sIcon);
		var endFrame:Number = mc._currentframe;
		mc.removeMovieClip();
		
		return (currentFrame == endFrame);
	}

	public function updateAttributeIcons(iSlot: Number, sAttributes: String): Void
	{
		var attributesClip: MovieClip;
		var attributeIcons: MovieClip;

		switch(iSlot) {
			case 0:
				attributesClip = leftAttributeIcons_mc
				attributeIcons = leftAttributeIcons
				break;
			case 1:
				attributesClip = rightAttributeIcons_mc
				attributeIcons = rightAttributeIcons
				break;
			case 5:
				attributesClip = leftPreselectAttributeIcons_mc
				attributeIcons = leftPreselectAttributeIcons		
				break;
			case 6:
				attributesClip = rightPreselectAttributeIcons_mc
				attributeIcons = rightPreselectAttributeIcons
				break;
			};
		//Store current alpha and scale values so we fade back in to the same settings
		var currAttributesAlpha = attributesClip._alpha
		//Fade out
		TweenLite.to(attributesClip, 0.05, {_alpha:0, ease:Quad.easeOut});
		//Set new attribute icons
		attributeIcons.gotoAndStop(sAttributes);
		//Fade in
		TweenLite.to(attributesClip, 0.1, {_alpha:currAttributesAlpha, ease:Quad.easeOut});
	}

	public function updateIconAndName(itemIcon: MovieClip, itemName: TextField, sIcon: String, sName: String): Void
	{
		if (sName == undefined || sName == ""){
			sName = " ";
		}

		//Set the Icon
		itemIcon.gotoAndStop(sIcon);
		//Save the current text formatting to preserve any Edit Mode changes
		var textFormat:TextFormat = itemName.getTextFormat();
		//Set the Name
		itemName.text = sName;
		//Restore the text formatting
		itemName.setTextFormat(textFormat);
	}

	public function updateDisplayedText(iIndex: Number, sString: String): Void
	{
		//skyui.util.Debug.log("iEquipWidget updateDisplayedText - iSlot: " + iIndex + ", sString: " + sString)

		if (sString == undefined || sString == ""){
			sString = " ";
		}

		var targetText: TextField = textElementArray[iIndex];
		var textFormat:TextFormat = targetText.getTextFormat();
		targetText.text = sString;
		targetText.setTextFormat(textFormat);
	}

	// Called from TemperedItemHandler updateIcon()
	public function updateIcon(iSlot: Number, sIcon: String): Void
	{
		var itemIcon: MovieClip = iSlot == 0 ? leftIcon : rightIcon;
		itemIcon.gotoAndStop(sIcon);
	}

	public function updateTemperTierIndicator(iSlot: Number, iTier: Number, iStyle: Number, bShowFade: Boolean): Void
	{
		//skyui.util.Debug.log("iEquipWidget updateTemperTierIndicator - iSlot: " + iSlot + ", iTier: " + iTier + ", iStyle: " + iStyle + ", bShowFade: " + bShowFade)

		var targetIndicator: MovieClip;
		switch(iSlot) {
			case 0:
				targetIndicator = leftTierIndicator;
				break;
			case 1:
				targetIndicator = rightTierIndicator;
				break;
			case 5:
				targetIndicator = leftPreselectTierIndicator;
				break;
			case 6:
				targetIndicator = rightPreselectTierIndicator;
				break;
			}

		var sFrame: String = iTier == 0 ? "Hidden" : temperTierStyleArray[iStyle];
		if (iTier > 0){
			if (!bShowFade) {
				sFrame += "NoFade";
			}
			sFrame += iTier.toString();
		}

		//skyui.util.Debug.log("iEquipWidget updateTemperTierIndicator - sFrame: " + sFrame)

		targetIndicator.gotoAndStop(sFrame);
	}

	// Used when a bound weapon is equipped to switch from the spell school icon to the bound weapon icon
	public function updateIconOnly(iSlot: Number, sIcon: String): Void
	{
		var itemIcon: MovieClip = iSlot == 0 ? leftIcon : rightIcon;

		if(isAlreadyOnFrame(itemIcon, sIcon) == false){
			var iconClip: MovieClip = iSlot == 0 ? leftIcon_mc : rightIcon_mc;
			var tl = new TimelineLite({paused:true, autoRemoveChildren:true});

			tl.to(iconClip, 1.2, {_rotation:"+=1080", ease:Strong.easeInOut}, 0)
			.call(switchToBoundItemIcon, [iSlot, sIcon], this, 0.7);
			tl.play();
		}
	}

	public function switchToBoundItemIcon(iSlot: Number, sIcon: String): Void
	{
		var itemIcon: MovieClip = iSlot == 0 ? leftIcon : rightIcon;
		itemIcon.gotoAndStop(sIcon);
	}

	public function setBackgrounds(iStyle: Number): Void
	{
		var backgroundName: String = backgroundStyleArray[iStyle];

		for (var i:Number = 0; i < backgroundClipArray.length; i++){
			backgroundClipArray[i].gotoAndStop(backgroundName);
		}
	}

	public function setWidgetBackground(iSlot: Number, iStyle: Number): Void
	{
		var backgroundClip: MovieClip;
		var backgroundName: String = backgroundStyleArray[iStyle];

		switch(iSlot) {
			case 0:
				backgroundClip = leftBg_mc;
				break;
			case 1:
				backgroundClip = rightBg_mc;
				break;
			case 2:
				backgroundClip = shoutBg_mc;
				break;
			case 3:
				backgroundClip = consumableBg_mc;
				break;
			case 4:
				backgroundClip = poisonBg_mc;
				break;
			case 5:
				backgroundClip = leftPreselectBg_mc;
				break;
			case 6:
				backgroundClip = rightPreselectBg_mc;
				break;
			case 7:
				backgroundClip = shoutPreselectBg_mc;
				break;
			};

		backgroundClip.gotoAndStop(backgroundName);
	}

	public function togglePreselect(leftEnabled: Boolean, rightEnabled: Boolean, shoutEnabled: Boolean, ammoMode: Boolean): Void
	{
		if(!ammoMode){
			leftPreselectIcon._alpha = 0
			leftPreselectName_mc._alpha = 0
			leftPreselectBg_mc._alpha = 0
		}
		shoutPreselectIcon._alpha = 0
		shoutPreselectName_mc._alpha = 0
		rightPreselectIcon._alpha = 0
		rightPreselectName_mc._alpha = 0
		shoutPreselectBg_mc._alpha = 0
		rightPreselectBg_mc._alpha = 0

		if(!ammoMode){
			leftPreselectBg_mc._visible = leftEnabled
			leftPreselectIcon_mc._visible = leftEnabled
			leftPreselectName_mc._visible = leftEnabled
		}
		shoutPreselectBg_mc._visible = shoutEnabled
		shoutPreselectIcon_mc._visible = shoutEnabled
		shoutPreselectName_mc._visible = shoutEnabled
		rightPreselectBg_mc._visible = rightEnabled
		rightPreselectIcon_mc._visible = rightEnabled
		rightPreselectName_mc._visible = rightEnabled
	}

	public function PreselectModeAnimateIn(leftEnabled: Boolean, shoutEnabled: Boolean, rightEnabled: Boolean, bgAlpha: Number, iconAlpha: Number, nameAlpha: Number): Void
	{
		//Create the preselect element arrays then add elements to the arrays depending on whether they are shown or not. Sequence for animation is left to right
		var preselectIcons: Array = new Array();
		var preselectBackgrounds: Array = new Array();
		var preselectNames: Array = new Array();

		if (leftEnabled == true){
			preselectIcons.push(leftPreselectIcon)
			preselectBackgrounds.push(leftPreselectBg_mc)
			preselectNames.push(leftPreselectName_mc)
		}
		if (shoutEnabled == true){
			preselectIcons.push(shoutPreselectIcon)
			preselectBackgrounds.push(shoutPreselectBg_mc)
			preselectNames.push(shoutPreselectName_mc)
		}
		if (rightEnabled == true){
			preselectIcons.push(rightPreselectIcon)
			preselectBackgrounds.push(rightPreselectBg_mc)
			preselectNames.push(rightPreselectName_mc)
		}
		//Set up the animation timeline
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:PreselectModeAnimateInComplete});
		//var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.staggerTo(preselectIcons, 0.6, {_rotation:"+=360", _alpha:iconAlpha, _xscale:100, _yscale:100, immediateRender:false, ease:Back.easeOut}, 0.2, 0)
		tl.staggerTo(preselectBackgrounds, 0.6, {_rotation:"+=360", _alpha:bgAlpha, immediateRender:false, ease:Back.easeOut}, 0.2, 0.1)
		tl.staggerTo(preselectNames, 0.25, {_alpha:nameAlpha, immediateRender:false}, 0.2, 0.4);
		//And action!
		tl.play();
	}

	public function PreselectModeAnimateInComplete(): Void
	{		
		skse.SendModEvent("iEquip_PreselectModeAnimationComplete", null);
	}

	public function PreselectModeAnimateOut(rightEnabled: Boolean, shoutEnabled: Boolean, leftEnabled: Boolean): Void
	{
		var preselectIcons: Array = new Array();
		var preselectBackgrounds: Array = new Array();
		var preselectNames: Array = new Array();
		// This time animation sequence is right to left, the opposite of animate in
		if (rightEnabled == true){
			preselectIcons.push(rightPreselectIcon)
			preselectBackgrounds.push(rightPreselectBg_mc)
			preselectNames.push(rightPreselectName_mc)
		}
		if (shoutEnabled == true){
			preselectIcons.push(shoutPreselectIcon)
			preselectBackgrounds.push(shoutPreselectBg_mc)
			preselectNames.push(shoutPreselectName_mc)
		}
		if (leftEnabled == true){
			preselectIcons.push(leftPreselectIcon)
			preselectBackgrounds.push(leftPreselectBg_mc)
			preselectNames.push(leftPreselectName_mc)
		}

		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.staggerTo(preselectIcons, 0.8, {_rotation:"-=360", _alpha:0, _xscale:20, _yscale:20, immediateRender:false, ease:Quad.easeOut}, 0.3, 0)
		tl.staggerTo(preselectBackgrounds, 0.8, {_rotation:"-=360", _alpha:0, immediateRender:false, ease:Quad.easeOut}, 0.3, 0.2)
		tl.staggerTo(preselectNames, 0.4, {_alpha:0, immediateRender:false}, 0.3, 0);

		tl.play();
	}

	public function prepareForPreselectAnimation(): Void
	{
		//Called on load from Papyrus and when entering Preselect Mode (preselectAnimateIn onComplete)
		//This function checks if the preselect icons are to the left or right of their main icon and sets the animate out direction to the opposite side. It also stores current main icon x/y as the target values for the preselect icons to animate to. Finally it gets and stores all necessary current scale and alpha values to ensure everything returns to the exact state it was in prior to starting the animation
		
		//skyui.util.Debug.log("iEquipWidget prepareForPreselectAnimation called")
		
		var leftIconLTG:Object = {x:0, y:0};
		var leftPreselectIconLTG:Object = {x:0, y:0};
		var rightIconLTG:Object = {x:0, y:0};
		var rightPreselectIconLTG:Object = {x:0, y:0};
		var shoutIconLTG:Object = {x:0, y:0};
		var shoutPreselectIconLTG:Object = {x:0, y:0};

		leftIcon.localToGlobal(leftIconLTG);
		leftPreselectIcon.localToGlobal(leftPreselectIconLTG);
		rightIcon.localToGlobal(rightIconLTG);
		rightPreselectIcon.localToGlobal(rightPreselectIconLTG);
		shoutIcon.localToGlobal(shoutIconLTG);
		shoutPreselectIcon.localToGlobal(shoutPreselectIconLTG);

		var leftPIconTarget:Object = {x:0, y:0};
		var rightPIconTarget:Object = {x:0, y:0};
		var shoutPIconTarget:Object = {x:0, y:0};

		leftIcon.localToGlobal(leftPIconTarget);
		leftPreselectIcon.globalToLocal(leftPIconTarget);
		rightIcon.localToGlobal(rightPIconTarget);
		rightPreselectIcon.globalToLocal(rightPIconTarget);
		shoutIcon.localToGlobal(shoutPIconTarget);
		shoutPreselectIcon.globalToLocal(shoutPIconTarget);


		if (leftIconLTG.x > leftPreselectIconLTG.x){
			leftTargetX = (leftIcon_mc._width); //If preselect icon is to the left of the main icon animate main icon out to right
		} else {
			leftTargetX = -(leftIcon_mc._width); //If preselect icon is to the right of the main icon animate main icon out to left
		}
		if (rightIconLTG.x > rightPreselectIconLTG.x){
			rightTargetX = -(rightIcon_mc._width);
		} else {
			rightTargetX = (rightIcon_mc._width);
		}
		if (shoutIconLTG.x > shoutPreselectIconLTG.x){
			shoutTargetX = (shoutIcon_mc._width);
		} else {
			shoutTargetX = -(shoutIcon_mc._width);
		}
		
		leftPTargetX = leftPIconTarget.x;
		leftPTargetY = leftPIconTarget.y;
		rightPTargetX = rightPIconTarget.x;
		rightPTargetY = rightPIconTarget.y;
		shoutPTargetX = shoutPIconTarget.x;
		shoutPTargetY = shoutPIconTarget.y;

		//Store current alpha and scale values ready to reapply
		leftIconAlpha = leftIcon_mc._alpha;
		leftTargetScale = ((leftIcon_mc._xscale / leftPreselectIcon_mc._xscale) * 100);
		leftPTargetRotation = leftIcon_mc._rotation - leftPreselectIcon_mc._rotation;
		leftPIconAlpha = leftPreselectIcon_mc._alpha;
		leftPIconScale = leftPreselectIcon._xscale;
		rightIconAlpha = rightIcon_mc._alpha;
		rightTargetScale = ((rightIcon_mc._xscale / rightPreselectIcon_mc._xscale) * 100);
		rightPTargetRotation = rightIcon_mc._rotation - rightPreselectIcon_mc._rotation;
		rightPIconAlpha = rightPreselectIcon_mc._alpha;
		rightPIconScale = rightPreselectIcon._xscale;
		shoutIconAlpha = shoutIcon_mc._alpha;
		shoutTargetScale = ((shoutIcon_mc._xscale / shoutPreselectIcon_mc._xscale) * 100);
		shoutPTargetRotation = shoutIcon_mc._rotation - shoutPreselectIcon_mc._rotation;
		shoutPIconAlpha = shoutPreselectIcon_mc._alpha;
		shoutPIconScale = shoutPreselectIcon._xscale;
		leftNameAlpha = leftName_mc._alpha;
		leftPNameAlpha = leftPreselectName_mc._alpha;
		rightNameAlpha = rightName_mc._alpha;
		rightPNameAlpha = rightPreselectName_mc._alpha;
		shoutNameAlpha = shoutName_mc._alpha;
		shoutPNameAlpha = shoutPreselectName_mc._alpha;

		//skse.SendModEvent("iEquip_ReadyForPreselectAnimation", null);
	}

	public function equipPreselectedItem(iSlot: Number, currIcon: String, newIcon: String, newName: String, currPIcon: String, newPIcon: String, newPName: String): Void
	{
		//skyui.util.Debug.log("iEquipWidget equipPreselectedItem - iSlot: " + iSlot + ", currIcon: " + currIcon + ", newIcon: " + newIcon + ", newName: " + newName + ", currPIcon: " + currPIcon + ", newPIcon: " + newPIcon + ", newPName: " + newPName)

		var iconClip: MovieClip;
		var iconClip_mc: MovieClip;
		var pIconClip: MovieClip;
		var pIconClip_mc: MovieClip;
		var itemName_mc: MovieClip;
		var preselectName_mc: MovieClip;
		var itemName: TextField;
		var pItemName: TextField;
		var targetX: Number;
		var pTargetX: Number;
		var pTargetY: Number;
		var pTargetRotation: Number;
		var pIconAlpha: Number;
		var pIconScale: Number;
		var pIconTargetScale: Number
		var iconAlpha: Number;
		var itemNameAlpha: Number;
		var preselectNameAlpha: Number;
		
		switch(iSlot) {
			case 0:
				iconClip = leftIcon;
				iconClip_mc = leftIcon_mc;
				pIconClip = leftPreselectIcon;
				pIconClip_mc = leftPreselectIcon_mc;
				itemName_mc = leftName_mc;
				preselectName_mc = leftPreselectName_mc;
				itemName = leftName;
				pItemName = leftPreselectName;
				targetX = leftTargetX;
				pTargetX = leftPTargetX;
				pTargetY = leftPTargetY;
				pTargetRotation = leftPTargetRotation;
				pIconAlpha = leftPIconAlpha;
				pIconScale = leftPIconScale;
				iconAlpha = leftIconAlpha;
				pIconTargetScale = leftTargetScale;
				itemNameAlpha = leftNameAlpha;
				preselectNameAlpha = leftPNameAlpha;
				break;
			case 1:
				iconClip = rightIcon;
				iconClip_mc = rightIcon_mc;
				pIconClip = rightPreselectIcon;
				pIconClip_mc = rightPreselectIcon_mc;
				itemName_mc = rightName_mc;
				preselectName_mc = rightPreselectName_mc;
				itemName = rightName;
				pItemName = rightPreselectName;
				targetX = rightTargetX;
				pTargetX = rightPTargetX;
				pTargetY = rightPTargetY;
				pTargetRotation = rightPTargetRotation;
				pIconAlpha = rightPIconAlpha;
				pIconScale = rightPIconScale;
				iconAlpha = rightIconAlpha;
				pIconTargetScale = rightTargetScale;
				itemNameAlpha = rightNameAlpha;
				preselectNameAlpha = rightPNameAlpha;
				break;
			case 2:
				iconClip = shoutIcon;
				iconClip_mc = shoutIcon_mc;
				pIconClip = shoutPreselectIcon;
				pIconClip_mc = shoutPreselectIcon_mc;
				itemName_mc = shoutName_mc;
				preselectName_mc = shoutPreselectName_mc;
				itemName = shoutName;
				pItemName = shoutPreselectName;
				targetX = shoutTargetX;
				pTargetX = shoutPTargetX;
				pTargetY = shoutPTargetY;
				pTargetRotation = shoutPTargetRotation;
				pIconAlpha = shoutPIconAlpha;
				pIconScale = shoutPIconScale;
				iconAlpha = shoutIconAlpha;
				pIconTargetScale = shoutTargetScale;
				itemNameAlpha = shoutNameAlpha;
				preselectNameAlpha = shoutPNameAlpha;
				break;
			}

		if (itemNameAlpha < 1.0){
			itemNameAlpha = 100
		}
		if (preselectNameAlpha < 1.0){
			preselectNameAlpha = 100
		}

		tempIcon = iconClip.duplicateMovieClip("tempIcon", this.getNextHighestDepth());
		tempIcon.gotoAndStop(currIcon);
		iconClip._alpha = 0;
		iconClip.gotoAndStop(newIcon);
		tempPIcon = pIconClip.duplicateMovieClip("tempPIcon", this.getNextHighestDepth());
		tempPIcon._xscale = pIconClip_mc._xscale;
		tempPIcon._yscale = pIconClip_mc._yscale;
		tempPIcon.gotoAndStop(currPIcon);
		pIconClip._alpha = 0;
		pIconClip._xscale = 25;
		pIconClip._yscale = 25;
		pIconClip.gotoAndStop(newPIcon);
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:equipPreselectedItemComplete, onCompleteParams:[iconClip_mc, tempIcon, pIconClip_mc, tempPIcon]});
		tl.to(itemName_mc, 0.2, {_alpha:0, ease:Quad.easeOut}, 0)
		.to(preselectName_mc, 0.2, {_alpha:0, ease:Quad.easeOut}, 0)
		.call(updateNamesForEquipPreselect, [itemName, pItemName, newName, newPName])
		.to(tempIcon, 0.4, {_x:targetX, _y:((tempIcon._height) / 2), _rotation:"+=90", _alpha:0, _xscale:25, _yscale:25, ease:Quad.easeOut}, 0)
		.to(tempPIcon, 0.4, {_x:pTargetX, _y:pTargetY, _rotation: pTargetRotation, _alpha:iconAlpha, _xscale:pIconTargetScale, _yscale:pIconTargetScale, ease:Quad.easeOut}, 0)
		.to(iconClip, 0, {_alpha:iconAlpha, ease:Linear.easeNone})
		.to(tempPIcon, 0, {_alpha:0, ease:Linear.easeNone})
		.to(pIconClip, 0.3, {_alpha:pIconAlpha, _xscale:pIconScale, _yscale:pIconScale, ease:Elastic.easeOut}, 0.3)
		.to(itemName_mc, 0.2, {_alpha:itemNameAlpha, ease:Quad.easeOut}, 0.4)
		.to(preselectName_mc, 0.2, {_alpha:preselectNameAlpha, ease:Quad.easeOut}, 0.4);

		tl.play();
	}

	public function updateNamesForEquipPreselect(itemName: TextField, pItemName: TextField, newName: String, newPName: String): Void
	{
		//Save the current text formatting to preserve any Edit Mode changes
		var textFormat:TextFormat = itemName.getTextFormat();
		var pTextFormat:TextFormat = pItemName.getTextFormat();
		//Set the new names
		itemName.text = newName;
		pItemName.text = newPName;
		//Restore the text formatting
		itemName.setTextFormat(textFormat);
		pItemName.setTextFormat(pTextFormat);
	}

	public function equipAllPreselectedItems(swapLeft: Boolean, swapRight: Boolean, swapShout: Boolean, leftCurrIcon: String, leftPCurrIcon: String, leftNewName: String, leftPNewIcon: String, leftPNewName: String, rightCurrIcon: String, rightPCurrIcon: String, rightNewName: String, rightPNewIcon: String, rightPNewName: String, shoutCurrIcon: String, shoutPCurrIcon: String, shoutNewName: String, shoutPNewIcon: String, shoutPNewName: String): Void
	{
		//Set the counter at +1 per slot being animated
		EquipAllCounter = 0
		if (swapRight){
			EquipAllCounter += 1
		}
		if (swapLeft){
			EquipAllCounter += 1
		}
		if (swapShout){
			EquipAllCounter += 1
		}
		//Play the animations
		if (swapRight){
			equipPreselectedItem(1, rightCurrIcon, rightPCurrIcon, rightNewName, rightPCurrIcon, rightPNewIcon, rightPNewName)
		}
		if (swapLeft){
			equipPreselectedItem(0, leftCurrIcon, leftPCurrIcon, leftNewName, leftPCurrIcon, leftPNewIcon, leftPNewName)
		}
		if (swapShout){
			equipPreselectedItem(2, shoutCurrIcon, shoutPCurrIcon, shoutNewName, shoutPCurrIcon, shoutPNewIcon, shoutPNewName)
		}
	}

	public function equipPreselectedItemWithoutNewPreselect(iSlot: Number, currIcon: String, newIcon: String, newName: String, currPIcon: String): Void
	{
		
		var iconClip: MovieClip;
		var iconClip_mc: MovieClip;
		var pIconClip: MovieClip;
		var pIconClip_mc: MovieClip;
		var itemName_mc: MovieClip;
		var preselectName_mc: MovieClip;
		var itemName: TextField;
		var pItemName: TextField;
		var targetX: Number;
		var pTargetX: Number;
		var pTargetY: Number;
		var pTargetRotation: Number;
		var pIconAlpha: Number;
		var pIconScale: Number;
		var pIconTargetScale: Number
		var iconAlpha: Number;
		var itemNameAlpha: Number;
		
		switch(iSlot) {
			case 0:
				iconClip = leftIcon;
				iconClip_mc = leftIcon_mc;
				pIconClip = leftPreselectIcon;
				pIconClip_mc = leftPreselectIcon_mc;
				itemName_mc = leftName_mc;
				preselectName_mc = leftPreselectName_mc;
				itemName = leftName;
				pItemName = leftPreselectName;
				targetX = leftTargetX;
				pTargetX = leftPTargetX;
				pTargetY = leftPTargetY;
				pTargetRotation = leftPTargetRotation;
				pIconAlpha = leftPIconAlpha;
				pIconScale = leftPIconScale;
				iconAlpha = leftIconAlpha;
				pIconTargetScale = leftTargetScale;
				itemNameAlpha = leftNameAlpha;
				break;
			case 1:
				iconClip = rightIcon;
				iconClip_mc = rightIcon_mc;
				pIconClip = rightPreselectIcon;
				pIconClip_mc = rightPreselectIcon_mc;
				itemName_mc = rightName_mc;
				preselectName_mc = rightPreselectName_mc;
				itemName = rightName;
				pItemName = rightPreselectName;
				targetX = rightTargetX;
				pTargetX = rightPTargetX;
				pTargetY = rightPTargetY;
				pTargetRotation = rightPTargetRotation;
				pIconAlpha = rightPIconAlpha;
				pIconScale = rightPIconScale;
				iconAlpha = rightIconAlpha;
				pIconTargetScale = rightTargetScale;
				itemNameAlpha = rightNameAlpha;
				break;
			case 2:
				iconClip = shoutIcon;
				iconClip_mc = shoutIcon_mc;
				pIconClip = shoutPreselectIcon;
				pIconClip_mc = shoutPreselectIcon_mc;
				itemName_mc = shoutName_mc;
				preselectName_mc = shoutPreselectName_mc;
				itemName = shoutName;
				pItemName = shoutPreselectName;
				targetX = shoutTargetX;
				pTargetX = shoutPTargetX;
				pTargetY = shoutPTargetY;
				pTargetRotation = shoutPTargetRotation;
				pIconAlpha = shoutPIconAlpha;
				pIconScale = shoutPIconScale;
				iconAlpha = shoutIconAlpha;
				pIconTargetScale = shoutTargetScale;
				itemNameAlpha = shoutNameAlpha;
				break;
			}

		if (itemNameAlpha < 1.0){
			itemNameAlpha = 100
		}

		tempIcon = iconClip.duplicateMovieClip("tempIcon", this.getNextHighestDepth());
		tempIcon.gotoAndStop(currIcon);
		iconClip._alpha = 0;
		iconClip.gotoAndStop(newIcon);
		tempPIcon = pIconClip.duplicateMovieClip("tempPIcon", this.getNextHighestDepth());
		tempPIcon._xscale = pIconClip_mc._xscale;
		tempPIcon._yscale = pIconClip_mc._yscale;
		tempPIcon.gotoAndStop(currPIcon);
		pIconClip._alpha = 0;
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:equipPreselectedItemComplete, onCompleteParams:[iconClip_mc, tempIcon, pIconClip_mc, tempPIcon]});
		tl.to(itemName_mc, 0.2, {_alpha:0, ease:Quad.easeOut}, 0)
		.to(preselectName_mc, 0.2, {_alpha:0, ease:Quad.easeOut}, 0)
		.call(updateNamesForEquipPreselectWithoutNewPreselect, [itemName, newName])
		.to(tempIcon, 0.4, {_x:targetX, _y:((tempIcon._height) / 2), _rotation:"+=90", _alpha:0, _xscale:25, _yscale:25, ease:Quad.easeOut}, 0)
		.to(tempPIcon, 0.4, {_x:pTargetX, _y:pTargetY, _rotation: pTargetRotation, _alpha:iconAlpha, _xscale:pIconTargetScale, _yscale:pIconTargetScale, ease:Quad.easeOut}, 0)
		.to(iconClip, 0, {_alpha:iconAlpha, ease:Linear.easeNone})
		.to(tempPIcon, 0, {_alpha:0, ease:Linear.easeNone})
		.to(itemName_mc, 0.2, {_alpha:itemNameAlpha, ease:Quad.easeOut}, 0.4)

		tl.play();
	}

	public function updateNamesForEquipPreselectWithoutNewPreselect(itemName: TextField, newName: String): Void
	{
		//Save the current text formatting to preserve any Edit Mode changes
		var textFormat:TextFormat = itemName.getTextFormat();
		//Set the new names
		itemName.text = newName;
		//Restore the text formatting
		itemName.setTextFormat(textFormat);
	}

	public function equipAllPreselectedItemsAndTogglePreselect(swapLeft: Boolean, swapRight: Boolean, swapShout: Boolean, leftCurrIcon: String, leftPCurrIcon: String, leftNewName: String, rightCurrIcon: String, rightPCurrIcon: String, rightNewName: String, shoutCurrIcon: String, shoutPCurrIcon: String, shoutNewName: String): Void
	{
		//Set the counter at +1 per slot being animated
		EquipAllCounter = 0
		if (swapRight){
			EquipAllCounter += 1
		}
		if (swapLeft){
			EquipAllCounter += 1
		}
		if (swapShout){
			EquipAllCounter += 1
		}
		//Play the animations
		if (swapRight){
			equipPreselectedItemWithoutNewPreselect(1, rightCurrIcon, rightPCurrIcon, rightNewName, rightPCurrIcon)
		}
		if (swapLeft){
			equipPreselectedItemWithoutNewPreselect(0, leftCurrIcon, leftPCurrIcon, leftNewName, leftPCurrIcon)
		}
		if (swapShout){
			equipPreselectedItemWithoutNewPreselect(2, shoutCurrIcon, shoutPCurrIcon, shoutNewName, shoutPCurrIcon)
		}
	}

	public function equipPreselectedItemComplete(iconClip_mc: MovieClip, tempIcon: MovieClip, pIconClip_mc: MovieClip, tempPIcon: MovieClip): Void
	{		
		//Delete the temporary movieclips
		iconClip_mc.tempIcon.removeMovieClip();
		pIconClip_mc.tempPIcon.removeMovieClip();
		//Check the counter to see if we're equipping all preselected
		if (EquipAllCounter > 0){
			//Count down until all calls are made
			EquipAllCounter -= 1
			if (EquipAllCounter == 0){
				//And let Papyrus know so the function can complete
				skse.SendModEvent("iEquip_EquipAllComplete")
			}
		}
	}

	//public function prepareForAmmoModeAnimation(animateIn: Boolean, backgroundsShown: Boolean): Void
	public function prepareForAmmoModeAnimation(animateIn: Boolean): Void
	{		
		var leftIconLTG:Object = {x:0, y:0};
		var leftPreselectIconLTG:Object = {x:0, y:0};

		leftIcon.localToGlobal(leftIconLTG);
		leftPreselectIcon.localToGlobal(leftPreselectIconLTG);

		var leftPIconTarget:Object = {x:0, y:0};
		var leftIconTarget:Object = {x:0, y:0};

		leftIcon.localToGlobal(leftPIconTarget);
		leftPreselectIcon.globalToLocal(leftPIconTarget);

		leftPreselectIcon.localToGlobal(leftIconTarget);
		leftIcon.globalToLocal(leftIconTarget);

		if (!animateIn){
			if (leftIconLTG.x > leftPreselectIconLTG.x){
				leftTargetX = (leftIcon_mc._width); //If preselect icon is to the left of the main widget animate main widget out to right
			} else {
				leftTargetX = -(leftIcon_mc._width); //If preselect icon is to the right of the main widget animate main widget out to left
			}
		} else {
			leftTargetX = leftIconTarget.x;
			leftTargetY = leftIconTarget.y;
		}
				
		leftPTargetX = leftPIconTarget.x;
		leftPTargetY = leftPIconTarget.y;

		//Reset the preselect icon scale
		leftPreselectIcon._xscale = 100;
		leftPreselectIcon._yscale = 100;

		//Store current alpha and scale values ready to reapply
		leftIconAlpha = leftIcon_mc._alpha;
		if (!animateIn){
			leftTargetScale = ((leftIcon_mc._xscale / leftPreselectIcon_mc._xscale) * 100);
		} else {
			leftTargetScale = ((leftPreselectIcon_mc._xscale / leftIcon_mc._xscale) * 100);
		}
		leftPIconAlpha = 100;
		leftPIconScale = 100;
		//leftPIconAlpha = leftPreselectIcon_mc._alpha;
		//leftPIconScale = leftPreselectIcon_mc._xscale;
		leftNameAlpha = leftName_mc._alpha;
		leftPNameAlpha = leftPreselectName_mc._alpha;

		skse.SendModEvent("iEquip_ReadyForAmmoModeAnimation", null);
	}

	public function ammoModeAnimateIn(currIcon: String, currName: String, newIcon: String, newName: String): Void
	{		
		leftPreselectBg_mc._alpha = 0;
		leftPreselectBg_mc._visible = true;

		if (leftNameAlpha < 1.0){
			leftNameAlpha = 100;
		}
		if (leftPNameAlpha < 1.0){
			leftPNameAlpha = 100;
		}
		var targetRotation: Number = leftPreselectIcon_mc._rotation - leftIcon_mc._rotation;
		tempIcon = leftIcon.duplicateMovieClip("tempIcon", this.getNextHighestDepth());
		tempIcon.gotoAndStop(currIcon);
		leftIcon._alpha = 0;
		leftIcon._xscale = 25;
		leftIcon._yscale = 25;
		leftIcon.gotoAndStop(newIcon);
		leftPreselectIcon._alpha = 0;
		leftPreselectName_mc._alpha = 0;
		leftPreselectIcon.gotoAndStop(currIcon);
		leftPreselectIcon_mc._visible = true
		leftPreselectName_mc._visible = true
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:AmmoModeAnimateInComplete, onCompleteParams:[leftIcon_mc, tempIcon]});
		tl.to(leftName_mc, 0.2, {_alpha:0, ease:Quad.easeOut}, 0)
		.call(updateNamesForEquipPreselect, [leftName, leftPreselectName, newName, currName])
		.to(tempIcon, 0.4, {_x:leftTargetX, _y:leftTargetY, _rotation:targetRotation, _alpha:leftPIconAlpha, _xscale:leftTargetScale, _yscale:leftTargetScale, ease:Quad.easeOut}, 0)
		.to(leftPreselectIcon, 0, {_alpha:leftPIconAlpha, ease:Linear.easeNone}, 0.4)
		.to(leftIcon, 0.25, {_alpha:leftIconAlpha, _xscale:100, _yscale:100, ease:Elastic.easeOut}, 0.2)
		.to(leftPreselectBg_mc, 0.25, {_rotation:"+=360", _alpha:100, ease:Back.easeOut}, 0.25)
		.to(leftName_mc, 0.2, {_alpha:leftNameAlpha, ease:Quad.easeOut}, 0.4)
		.to(leftPreselectName_mc, 0.2, {_alpha:leftPNameAlpha, ease:Quad.easeOut}, 0.4);

		tl.play();
	}

	public function ammoModeAnimateOut(currIcon: String, currPIcon: String, newName: String): Void
	{
		if (leftNameAlpha < 1.0){
			leftNameAlpha = 100
		}
		var targetRotation: Number = leftIcon_mc._rotation - leftPreselectIcon_mc._rotation;
		tempIcon = leftIcon.duplicateMovieClip("tempIcon", this.getNextHighestDepth());
		tempIcon.gotoAndStop(currIcon);
		leftIcon._alpha = 0;
		leftIcon.gotoAndStop(currPIcon);
		tempPIcon = leftPreselectIcon.duplicateMovieClip("tempPIcon", this.getNextHighestDepth());
		tempPIcon._xscale = leftPreselectIcon_mc._xscale;
		tempPIcon._yscale = leftPreselectIcon_mc._yscale;
		tempPIcon.gotoAndStop(currPIcon);
		leftPreselectIcon._alpha = 0;
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:AmmoModeAnimateOutComplete, onCompleteParams:[leftIcon_mc, tempIcon, leftPreselectIcon_mc, tempPIcon]});
		tl.to(leftName_mc, 0.2, {_alpha:0, ease:Quad.easeOut}, 0)
		.to(leftPreselectName_mc, 0.2, {_alpha:0, ease:Quad.easeOut}, 0)
		.call(updateNamesForEquipPreselect, [leftName, leftPreselectName, newName, ""])
		.to(tempIcon, 0.4, {_x:leftTargetX, _y:((tempIcon._height) / 2), _rotation:"+=90", _alpha:0, _xscale:25, _yscale:25, ease:Quad.easeOut}, 0)
		.to(tempPIcon, 0.4, {_x:leftPTargetX, _y:leftPTargetY, _rotation:targetRotation, _alpha:leftIconAlpha, _xscale:leftTargetScale, _yscale:leftTargetScale, ease:Quad.easeOut}, 0)
		.to(leftPreselectBg_mc, 0.25, {_rotation:"-=360", _alpha:0, ease:Back.easeOut}, 0)
		.to(leftIcon, 0, {_alpha:leftIconAlpha, ease:Linear.easeNone})
		.to(tempPIcon, 0, {_alpha:0, ease:Linear.easeNone})
		.to(leftName_mc, 0.2, {_alpha:leftNameAlpha, ease:Quad.easeOut}, 0.4);

		tl.play();
	}

	public function AmmoModeAnimateInComplete(iconClip_mc: MovieClip, tempIcon: MovieClip): Void
	{		
		//Delete the temporary movieclip
		iconClip_mc.tempIcon.removeMovieClip();
		skse.SendModEvent("iEquip_AmmoModeAnimationComplete", null);
	}

	public function AmmoModeAnimateOutComplete(iconClip_mc: MovieClip, tempIcon: MovieClip, pIconClip_mc: MovieClip, tempPIcon: MovieClip): Void
	{		
		//Delete the temporary movieclip
		iconClip_mc.tempIcon.removeMovieClip();
		pIconClip_mc.tempPIcon.removeMovieClip();
		leftPreselectBg_mc._visible = false;
		skse.SendModEvent("iEquip_AmmoModeAnimationComplete", null);
	}
	
	public function fadeOut(a_alpha: Number, duration: Number): Void
	{
		TweenLite.to(this, duration, {_alpha:a_alpha});
	}

	public function handleTextFieldDropShadow(removeFilters: Boolean): Void
	{
		var tf: TextField;
		for (var i:Number = 0; i < textFieldArray.length; i++){
			tf = textFieldArray[i];
			if (removeFilters){
				tf.filters = [];
			} else {
				tf.filters = [filter_shadow];
			}
		}	
	}

	public function updateTextFieldDropShadow(newAlpha: Number, newAngle: Number, newBlur: Number, newDistance: Number, newStrength: Number, bShow: Boolean): Void
	{
		//Remove current drop shadow effect
		handleTextFieldDropShadow(true)
		//Update the filter
		filter_shadow.alpha = newAlpha;
		filter_shadow.angle = newAngle;
		filter_shadow.blurX = newBlur;
		filter_shadow.blurY = newBlur;
		filter_shadow.distance = newDistance;
		filter_shadow.strength = newStrength;
		if(bShow) {
			//Add back the updated effect
			handleTextFieldDropShadow(false)
		}
	}

	public function tweenLeftIconAlpha(bgAlpha: Number, iconAlpha: Number, nameAlpha: Number, countAlpha: Number, poisonIconAlpha: Number, poisonNameAlpha: Number, i_target: Number, enchantmentAlpha: Number, tierIndicatorAlpha: Number): Void
	{
		var bgClip: MovieClip = leftBg_mc
		var iconClip: MovieClip = leftIcon_mc
		var nameClip: MovieClip = leftName_mc
		var countClip: MovieClip = leftCount_mc
		var poisonIconClip: MovieClip = leftPoisonIcon_mc
		var poisonNameClip: MovieClip = leftPoisonName_mc
		var enchantmentClip: MovieClip = enchantmentMeterArray[i_target];
		var tierIndicatorClip: MovieClip = leftTierIndicator_mc;
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.to(bgClip, 0.25, {_alpha:bgAlpha, ease:Quad.easeOut}, 0)
		.to(iconClip, 0.25, {_alpha:iconAlpha, ease:Quad.easeOut}, 0)
		.to(nameClip, 0.25, {_alpha:nameAlpha, ease:Quad.easeOut}, 0)
		.to(countClip, 0.25, {_alpha:countAlpha, ease:Quad.easeOut}, 0)
		.to(poisonIconClip, 0.25, {_alpha:poisonIconAlpha, ease:Quad.easeOut}, 0)
		.to(poisonNameClip, 0.25, {_alpha:poisonNameAlpha, ease:Quad.easeOut}, 0)
		.to(enchantmentClip, 0.25, {_alpha:enchantmentAlpha, ease:Quad.easeOut}, 0)
		.to(tierIndicatorClip, 0.25, {_alpha:tierIndicatorAlpha, ease:Quad.easeOut}, 0);
		tl.play();
	}

	public function tweenConsumableIconAlpha(bgAlpha: Number, iconAlpha: Number, nameAlpha: Number, countAlpha: Number): Void
	{
		var bgClip: MovieClip = consumableBg_mc
		var iconClip: MovieClip = consumableIcon_mc
		var nameClip: MovieClip = consumableName_mc
		var countClip: MovieClip = consumableCount_mc
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.to(bgClip, 0.25, {_alpha:bgAlpha, ease:Quad.easeOut}, 0)
		.to(iconClip, 0.25, {_alpha:iconAlpha, ease:Quad.easeOut}, 0)
		.to(nameClip, 0.25, {_alpha:nameAlpha, ease:Quad.easeOut}, 0)
		.to(countClip, 0.25, {_alpha:countAlpha, ease:Quad.easeOut}, 0);
		tl.play();
	}

	public function tweenPoisonIconAlpha(bgAlpha: Number, iconAlpha: Number, nameAlpha: Number, countAlpha: Number): Void
	{
		var bgClip: MovieClip = poisonBg_mc
		var iconClip: MovieClip = poisonIcon_mc
		var nameClip: MovieClip = poisonName_mc
		var countClip: MovieClip = poisonCount_mc
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.to(bgClip, 0.25, {_alpha:bgAlpha, ease:Quad.easeOut}, 0)
		.to(iconClip, 0.25, {_alpha:iconAlpha, ease:Quad.easeOut}, 0)
		.to(nameClip, 0.25, {_alpha:nameAlpha, ease:Quad.easeOut}, 0)
		.to(countClip, 0.25, {_alpha:countAlpha, ease:Quad.easeOut}, 0);
		tl.play();
	}

	public function setPotionSelectorAlignment(bPotionSelectorOnLeft: Boolean): Void
    {
        if (bPotionSelectorOnLeft) {
            potionSelector_mc.gotoAndStop("left");
            selector.gotoAndStop("_left");
        } else {
            potionSelector_mc.gotoAndStop("right");
            selector.gotoAndStop("_right");
        }
    }

    public function updatePotionSelectorText(sRestoreText: String, sFortifyText: String, sRegenText: String): Void
    {
    	var textFormat:TextFormat = restoreText.getTextFormat();
    	restoreText.text = sRestoreText;
    	fortifyText.text = sFortifyText;
    	regenText.text = sRegenText;
    	restoreText.setTextFormat(textFormat);
    	fortifyText.setTextFormat(textFormat);
    	regenText.setTextFormat(textFormat);
    }

    public function tweenPotionSelectorAlpha(targetAlpha: Number): Void
    {
        TweenLite.to(potionSelector_mc, 0.2, {_alpha:targetAlpha, ease:Quad.easeOut});
    }
 
    public function cyclePotionSelector(potionType: Number): Void
    {
        var targetY: Number;
         
        switch(potionType) {
            case 0:
                targetY = restoreText._y + (restoreText._height/2);
                break;
            case 1:
                targetY = fortifyText._y + (fortifyText._height/2);
                break;
            case 2:
                targetY = regenText._y + (regenText._height/2);
                break;
            }
 
        TweenLite.to(selector, 0.2, {_y:targetY, ease:Quad.easeOut});
        //TweenLite.to(selectorRight, 0.2, {_y:targetY, ease:Quad.easeOut});
    }

	public function runPotionFlashAnimation(potionType: Number): Void
	{
		//skyui.util.Debug.log("iEquipWidget runPotionFlashAnimation - potionType: " + potionType)
		var potionFlash: MovieClip = potionFlashAnim;
		
		switch(potionType) {
			case 0:
				potionFlash.gotoAndStop("Health");
				break;
			case 1:
				potionFlash.gotoAndStop("Stamina");
				break;
			case 2:
				potionFlash.gotoAndStop("Magicka");
				break;
			}
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:onPotionFlashComplete});
		tl.to(potionFlash, 0.3, {_alpha:100, ease:Quad.easeOut}, 0)
		.to(potionFlash, 0.3, {_alpha:0, ease:Quad.easeOut})
		.to(potionFlash, 0.3, {_alpha:100, ease:Quad.easeOut})
		.to(potionFlash, 0.3, {_alpha:0, ease:Quad.easeOut})
		.to(potionFlash, 0.3, {_alpha:100, ease:Quad.easeOut})
		.to(potionFlash, 0.3, {_alpha:0, ease:Quad.easeOut});
		tl.play();
	}

	public function onPotionFlashComplete(): Void
	{
		potionFlashAnim.gotoAndStop("Hide");
	}

	public function runPoisonFlashAnimation(): Void
	{
		var poisonFlash: MovieClip = poisonFlashAnim;
		poisonFlash.gotoAndStop("Flash");

		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:onPoisonFlashComplete});
		tl.to(poisonFlash, 0.3, {_alpha:100, ease:Quad.easeOut}, 0)
		.to(poisonFlash, 0.3, {_alpha:0, ease:Quad.easeOut})
		.to(poisonFlash, 0.3, {_alpha:100, ease:Quad.easeOut})
		.to(poisonFlash, 0.3, {_alpha:0, ease:Quad.easeOut})
		.to(poisonFlash, 0.3, {_alpha:100, ease:Quad.easeOut})
		.to(poisonFlash, 0.3, {_alpha:0, ease:Quad.easeOut});
		tl.play();
	}

	public function onPoisonFlashComplete(): Void
	{
		poisonFlashAnim.gotoAndStop("Hide");
	}
 
	public function tweenWidgetCounterAlpha(clipIndex: Number, endValue: Number, secs: Number): Void
	{
		var counterClip: MovieClip;
		switch(clipIndex) {
			case 0:
				counterClip = leftCount_mc;
				break;
			case 1:
				counterClip = rightCount_mc;
				break;
			case 3:
				counterClip = consumableCount_mc;
				break;
			case 4:
				counterClip = poisonCount_mc;
				break;
			}
		TweenLite.to(counterClip, secs, {_alpha:endValue, ease:Quad.easeOut});
	}

	public function updateCounter(iTarget: Number, iCount: Number, bIsPotionGroup: Boolean, iRestoreCount: Number, iColor: Number): Void
	{
		var targetCount: TextField;
		switch(iTarget) {
			case 0:
				targetCount = leftCount;
				break;
			case 1:
				targetCount = rightCount;
				break;
			case 3:
				targetCount = consumableCount;
				break;
			case 4:
				targetCount = poisonCount;
			}
		var textFormat:TextFormat = targetCount.getTextFormat();
		//If we're in the consumable queue
		if (iTarget == 3) {
			//If we're displaying a potion group count set the text colour for the counter depending on number of restore potions left in the group (yellow/orange/red early warning system)
			if (bIsPotionGroup) {
				switch(iRestoreCount) {
					case 0:
						textFormat.color = 0xFF0000; //Red
						break;
					case 1:
					case 2:
						textFormat.color = 0xFF9016; //Orange
						break;
					case 3:
					case 4:
					case 5:
						textFormat.color = 0xFFDB00; //Yellow
						break;
					default:
						textFormat.color = iColor;
					}
			} else {
				textFormat.color = iColor;
			}
		}
		targetCount.text = String(iCount);
		targetCount.setTextFormat(textFormat);
	}

	public function updatePoisonIcon(iTarget: Number, sIcon: String): Void
	{
		var _poisonIcon: MovieClip = iTarget == 0 ? leftPoisonIcon : rightPoisonIcon;
		var _poisonIcon_mc: MovieClip = iTarget == 0 ? leftPoisonIcon_mc : rightPoisonIcon_mc;
		var currAlpha = _poisonIcon_mc._alpha; 

		//skyui.util.Debug.log("iEquipWidget updatePoisonIcon - currAlpha: " + currAlpha)

		if (currAlpha < 1.0){
			currAlpha = 100
		}
		
		TweenLite.to(_poisonIcon_mc, 0.15, {_alpha:0, ease:Quad.easeOut});
		_poisonIcon.gotoAndStop(sIcon);
		TweenLite.to(_poisonIcon_mc, 0.2, {_alpha:currAlpha, ease:Quad.easeOut});
	}
	
	// @overrides WidgetBase
	public function getWidth(): Number
	{
		return _width;
	}

	// @overrides WidgetBase
	public function getHeight(): Number
	{
		return _height;
	}
	public function setRootScale(scale: Number): Void
	{
		_xscale = scale;
		_yscale = scale;
	}

	//Enchantment display functions

	public function hideAllEnchantmentMeters(Q: Number): Void
	{
		var targetClip: MovieClip

		tweenChargeMeterAlpha(Q, 0);
		targetClip = Q == 0 ? leftEnchantmentMeter_mc : rightEnchantmentMeter_mc;
		targetClip._visible = false
		tweenSoulGemAlpha(Q, 0);
		targetClip = Q == 0 ? leftSoulgem_mc : rightSoulgem_mc;
		targetClip._visible = false
		tweenRadialMeterAlpha(Q, 0);
		targetClip = Q == 0 ? leftRadialMeter_mc : rightRadialMeter_mc;
		targetClip._visible = false
	}

	//Charge Meter functions

	public function initChargeMeter(i_meter: Number, nWidth: Number, nHeight: Number, primaryColor: Number, secondaryColor: Number, flashColor: Number, newPercent: Number, sFillDirection: String, forceUpdate: Boolean, bVisible: Boolean): Void
	{
		// Set the meter being targeted for this update
		var targetMeter: iEquipMeter = i_meter == 0 ? leftMeter : rightMeter;
		// Hide
		targetMeter._visible = false;
		// Update size
		targetMeter.setSize(nWidth, nHeight);
		// Update fill colours
		targetMeter.setColors(primaryColor, secondaryColor);
		// Update the flash colour
		targetMeter.flashColor = flashColor;
		// Update fill percent
		targetMeter.setPercent(newPercent, forceUpdate);
		// Update fill direction
		targetMeter.setFillDirection(sFillDirection, forceUpdate); //Reset fill Direction and force percentage back
		// Show
		targetMeter._visible = true;
	}

	public function setChargeMeterFillDirection(i_meter: Number, sFillDirection: String): Void
	{
		//skyui.util.Debug.log("iEquipWidget setChargeMeterFillDirection called - i_meter: " + i_meter + ", sFillDirection: " + sFillDirection)
		var targetMeter: iEquipMeter = i_meter == 0 ? leftMeter : rightMeter;
		//targetMeter.fillDirection = sFillDirection;
		targetMeter.setFillDirection(sFillDirection, true); //Reset fill Direction and force percentage back
	}

	public function setChargeMeterPercent(i_meter: Number, newPercent: Number, primaryColor: Number, gradientEnabled: Boolean, secondaryColor: Number, forceUpdate: Boolean): Void
	{
		//skyui.util.Debug.log("iEquipWidget setChargeMeterPercent called - i_meter: " + i_meter + ", newPercent: " + newPercent + ", primaryColor: " + primaryColor + ", secondaryColor: " + secondaryColor + ", forceUpdate: " + forceUpdate)
		var targetMeter: iEquipMeter = i_meter == 0 ? leftMeter : rightMeter;
		if (gradientEnabled) {
			targetMeter.setColors(primaryColor, secondaryColor);
		} else {
			targetMeter.color = primaryColor;
		}
		targetMeter.setPercent(newPercent, forceUpdate);
	}

	public function startChargeMeterFlash(i_meter: Number, flashColor: Number, forceUpdate: Boolean): Void
	{	
		var targetMeter: iEquipMeter = i_meter == 0 ? leftMeter : rightMeter;
		targetMeter.flashColor = flashColor;
		targetMeter.startFlash(forceUpdate);
	}

	public function tweenChargeMeterAlpha(i_meter: Number, targetAlpha: Number): Void
	{
		var meterClip: MovieClip = i_meter == 0 ? leftEnchantmentMeter_mc : rightEnchantmentMeter_mc;
		TweenLite.to(meterClip, 0.5, {_alpha:targetAlpha, ease:Quad.easeOut});
	}

	//Dynamic Soulgem functions

	public function initSoulGem(i_gem: Number, primaryColor: Number, flashColor: Number, newPercent: Number, forceUpdate: Boolean, bVisible: Boolean): Void
	{
		// Set the meter being targeted for this update
		var targetGem: iEquipSoulGem = i_gem == 0 ? leftSoulGem : rightSoulGem;
		// Hide
		targetGem._visible = false;
		// Update fill colours
		targetGem.color = primaryColor;
		// Update the flash colour
		targetGem.flashColor = flashColor;
		// Update fill percent
		targetGem.setPercent(newPercent, forceUpdate);
		// Show
		targetGem._visible = true
	}

	public function setSoulGemPercent(i_gem: Number, newPercent: Number, primaryColor: Number, forceUpdate: Boolean): Void
	{
		//skyui.util.Debug.log("iEquipWidget setSoulGemPercent called - i_gem: " + i_gem + ", newPercent: " + newPercent + ", primaryColor: " + primaryColor + ", forceUpdate: " + forceUpdate)
		var targetGem: iEquipSoulGem = i_gem == 0 ? leftSoulGem : rightSoulGem;
		targetGem.color = primaryColor;
		targetGem.setPercent(newPercent, forceUpdate);
	}

	public function startSoulGemFlash(i_gem: Number, flashColor: Number, forceUpdate: Boolean): Void
	{	
		var targetGem: iEquipSoulGem = i_gem == 0 ? leftSoulGem : rightSoulGem;
		targetGem.flashColor = flashColor;
		targetGem.startFlash(forceUpdate);
	}

	public function tweenSoulGemAlpha(i_gem: Number, targetAlpha: Number): Void
	{
		var soulGemClip: MovieClip = i_gem == 0 ? leftSoulgem_mc : rightSoulgem_mc;
		TweenLite.to(soulGemClip, 0.5, {_alpha:targetAlpha, ease:Quad.easeOut});
	}

	//Radial Meter functions

	public function initRadialMeter(i_meter: Number, primaryColor: Number, flashColor: Number, newPercent: Number, forceUpdate: Boolean): Void
	{
		// Set the meter being targeted for this update
		var targetMeter: iEquipRadialMeter = i_meter == 0 ? leftRadialMeter : rightRadialMeter;
		// Hide
		targetMeter._visible = false;
		// Update fill colours
		targetMeter.color = primaryColor;
		// Update the flash colour
		targetMeter.flashColor = flashColor;
		// Update fill percent
		targetMeter.setPercent(newPercent, forceUpdate);
		// Show
		targetMeter._visible = true
	}

	public function setRadialMeterPercent(i_meter: Number, newPercent: Number, primaryColor: Number, forceUpdate: Boolean): Void
	{
		//skyui.util.Debug.log("iEquipWidget setRadialMeterPercent called - i_meter: " + i_meter + ", newPercent: " + newPercent + ", primaryColor: " + primaryColor + ", forceUpdate: " + forceUpdate)
		var targetMeter: iEquipRadialMeter = i_meter == 0 ? leftRadialMeter : rightRadialMeter;
		targetMeter.color = primaryColor;
		targetMeter.setPercent(newPercent, forceUpdate);
	}

	public function startRadialMeterFlash(i_meter: Number, flashColor: Number, forceUpdate: Boolean): Void
	{	
		var targetMeter: iEquipRadialMeter = i_meter == 0 ? leftRadialMeter : rightRadialMeter;
		targetMeter.flashColor = flashColor;
		targetMeter.startFlash(forceUpdate);
	}

	public function tweenRadialMeterAlpha(i_meter: Number, targetAlpha: Number): Void
	{
		var radialMeterClip: MovieClip = i_meter == 0 ? leftRadialMeter_mc : rightRadialMeter_mc;
		TweenLite.to(radialMeterClip, 0.5, {_alpha:targetAlpha, ease:Quad.easeOut});
	}


	//Called from OnWidgetLoad
	public function initQueuePositionIndicator(Q: Number, primaryColor: Number, markerAlpha: Number, currPosColor: Number, currPosAlpha: Number,currentQueueLength: Number, currentPosition: Number): Void
	{
		//skyui.util.Debug.log("iEquipWidget initQueuePositionIndicator - Q: " + Q + ", color: " + primaryColor + ", alpha: " + markerAlpha + ", currColor: " + currPosColor + ", currAlpha: " + currPosAlpha + ", count: " + currentQueueLength + ", pos: " + currentPosition)
		// Set the position indicator being targeted being targeted for this update
		var targetIndicator: iEquipPositionIndicator = posIndArray[Q];
		// Creates the full width position marker and fills it with a light to dark gradient of the specified colour
		targetIndicator.color = primaryColor;
		// Set the alpha value for the position indicator
		targetIndicator.indAlpha = markerAlpha;
		// Set the colour for the currently equipped position marker
		targetIndicator.currColor = currPosColor;
		// Set the alpha value for the currently equipped position marker
		targetIndicator.currAlpha = currPosAlpha;
		// Set the starting queue length, which then adjusts the initial width of the position marker accordingly
		targetIndicator.queueLen = currentQueueLength;
		// Set the starting queue position, which then places the position marker at the correct point on the indicator bar
		targetIndicator.currPos = currentPosition;
	}

	public function updateQueuePositionMarkers(primaryColor: Number, markerAlpha: Number, currPosColor: Number, currPosAlpha: Number): Void
	{
		//skyui.util.Debug.log("iEquipWidget updateQueuePositionMarkers -  color: " + primaryColor + ", alpha: " + markerAlpha + ", currColor: " + currPosColor + ", currAlpha: " + currPosAlpha)
		var targetIndicator: iEquipPositionIndicator;
		for (var i:Number = 0; i < posIndArray.length; i++){
			targetIndicator = posIndArray[i];
			targetIndicator.color = primaryColor;
			targetIndicator.indAlpha = markerAlpha;
			targetIndicator.currColor = currPosColor;
			targetIndicator.currAlpha = currPosAlpha;
			}
	}

	public function updateQueuePositionIndicator(Q: Number, currentQueueLength: Number, currPosition: Number, newPosition: Number, bCycling: Boolean, bPreselectMode: Boolean, currPreselectPosition: Number): Void
	{
		var targetIndicator: iEquipPositionIndicator = posIndArray[Q];
		targetIndicator.update(currentQueueLength, currPosition, newPosition, bCycling, bPreselectMode, currPreselectPosition);
	}

	public function hideQueuePositionIndicator(Q: Number): Void
	{
		//skyui.util.Debug.log("iEquipWidget hideQueuePositionIndicator - Q: " + Q)
		var targetIndicator: iEquipPositionIndicator = posIndArray[Q];
		targetIndicator.hideIndicator();
	}

	// Called when toggling in and out of Edit Mode
	public function showQueuePositionIndicators(bShow: Boolean): Void
	{
		//skyui.util.Debug.log("iEquipWidget showQueuePositionIndicators - show: " + bShow)
		var targetIndicator: iEquipPositionIndicator;
		for (var i:Number = 0; i < posIndArray.length; i++){
			targetIndicator = posIndArray[i];
			if(bShow){
				targetIndicator.showIndicator();
			}else{
				targetIndicator.hideIndicator();
			}
		}
	}

	//EDIT MODE FUNCTIONS
	function setEditModeHighlightColor(_color: Number): Void
	{
		//skyui.util.Debug.log("iEquipEditMode setEditModeHighlightColor - _color: " + _color)
		highlightColor = _color;
		colorTrans.rgb = highlightColor;
		EditModeGuide.SelectedElementText.textColor = highlightColor;
	}

	public function setCurrentClip(a_clip: Number): Void
	{
		//skyui.util.Debug.log("iEquipEditMode setCurrentClip - a_clip: " + a_clip)
		clip = clipArray[a_clip];
	}

	public function tweenIt(tweenType: Number, endValue: Number, secs: Number): Void
	{
		//tweenType = Attribute to change: 0 = _x, 1 = _y, 2 = _xscale/_yscale, 3 =  _rotation, 4 = _alpha
		switch(tweenType) {
			case 0:
				TweenLite.to(clip, secs, {_x:endValue, ease:Quad.easeOut});
				break;
			case 1:
				TweenLite.to(clip, secs, {_y:endValue, ease:Quad.easeOut});
				break;
			case 2:
				TweenLite.to(clip, secs, {_xscale:endValue, _yscale:endValue, ease:Quad.easeOut});
				break;
			case 3:
				TweenLite.to(clip, secs, {directionalRotation:{_rotation: endValue + "_short"}, ease:Quad.easeOut});
				break;
			case 4:
				TweenLite.to(clip, secs, {_alpha:endValue, ease:Quad.easeOut});
				break;
			}
	}

	public function tweenWidgetNameAlpha(clipIndex: Number, endValue: Number, secs: Number): Void
	{
		var nameClip: MovieClip = clipArray[clipIndex];
		TweenLite.to(nameClip, secs, {_alpha:endValue, ease:Quad.easeOut});
	}

		public function swapItemDepths(iItemToMoveToFront: Number, iItemToSendToBack: Number): Void
	{
		var clip1: MovieClip = clipArray[iItemToMoveToFront];
		var clip2: MovieClip = clipArray[iItemToSendToBack];
		clip1.swapDepths(clip2);
	}

	public function highlightSelectedElement(isText:Number, arrayIndex:Number, currentColor:Number): Void
	{
		if (isText == 1){
			selectedText = textElementArray[arrayIndex];
			var new_format:TextFormat = selectedText.getTextFormat();
			new_format.color = highlightColor;
			selectedText.setTextFormat(new_format);
			//selectedText.textColor = highlightColor;
		}
		else {
			colorTrans.rgb = highlightColor;
			var trans:Transform = new Transform(clip);
			trans.colorTransform = colorTrans;
		}
	}

	public function removeCurrentHighlight(isText:Number, textElement:Number, currentColor:Number): Void
	{
		if (isText == 1){
			selectedText = textElementArray[textElement];
			var new_format:TextFormat = selectedText.getTextFormat();
			new_format.color = currentColor;
			selectedText.setTextFormat(new_format);
			//selectedText.textColor = currentColor;
		} else {
			colorTrans = new ColorTransform(1,1,1,1,0,0,0,0);
			var trans:Transform = new Transform(clip);
			trans.colorTransform = colorTrans;
		}
	}
	
	public function setTextColor(textElement: Number, newColor: Number): Void
	{
		//skyui.util.Debug.log("iEquipWidget setTextColor - textElement: " + textElement + ", newColor: " + newColor)
		var new_format:TextFormat = new TextFormat();
		//potionSelector_mc
		if (textElement == 51){
			new_format = potionSelector_mc.restoreText.getTextFormat();
			new_format.color = newColor;
			potionSelector_mc.restoreText.setTextFormat(new_format);
			potionSelector_mc.fortifyText.setTextFormat(new_format);
			potionSelector_mc.regenText.setTextFormat(new_format);
		} else {
			selectedText = textElementArray[textElement];
			new_format = selectedText.getTextFormat();
			new_format.color = newColor;
			selectedText.setTextFormat(new_format);
		}
	}

	public function setTextAlignment(textElement: Number, a_align: Number): Void
	{
		//skyui.util.Debug.log("iEquipWidget setTextAlignment - textElement: " + textElement + ", a_align: " + a_align)
		selectedText = textElementArray[textElement];
		var new_format:TextFormat = selectedText.getTextFormat();
		switch(a_align) {
			case 0:
				new_format.align = "left";
				break;
			case 1:
				new_format.align = "center";
				break;
			case 2:
				new_format.align = "right";
				break;
		}
		selectedText.setTextFormat(new_format);
	}

	public function setTextColorAndAlignment(textElement: Number, a_align: Number, newColor: Number): Void
	{
		//skyui.util.Debug.log("iEquipWidget setTextColorAndAlignment - textElement: " + textElement + ", a_align: " + a_align + ", newColor: " + newColor)
		selectedText = textElementArray[textElement];
		if (selectedText.text == ""){
			selectedText.text = " ";
		}
		var new_format:TextFormat = selectedText.getTextFormat();

		switch(a_align) {
			case 0:
				new_format.align = "left";
				break;
			case 1:
				new_format.align = "center";
				break;
			case 2:
				new_format.align = "right";
				break;
		}
		new_format.color = newColor;
		selectedText.setTextFormat(new_format);
	}
}
