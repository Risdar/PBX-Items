#include "./RepairKit.zs" // Repait Kit
#include "./ShoulderCannon.zs" // Shoulder Cannon
#include "./Jetpack.zs" // Jetpack
#include "./UpgradeBot.zs" // Upgrade Bot

// --- Adrenaline ---
class PBX_Adrenaline : PB_Inventory
{
	Default
	{
		Inventory.AltHudIcon "ADRNA0";
		Inventory.PickupMessage "$ADRENAL_PICKUP";
		Inventory.PickupSound "misc/p_pkup";
		Tag "$ADRENAL_TAG";
	}

	override bool Use(bool pickup)
	{
		if(PBXItems_SendTip)
		{
			Array<String> tips;
			tips.Push("$PBX_Adrenaline_Tip1");
			PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXItems_itemHelpFlags",PBXItems_Tip_Adrenaline);
		}
		owner.A_SetBlend("Red",0.75,16);
		owner.A_GiveInventory("PBXItems_AdreSpdGiver");
		owner.A_GiveInventory("PBXItems_AdrePowGiver");
		return true;
	}

	States
	{
		Spawn:
			ADRN A -1;
			stop;
	}
}
class PBXItems_AdreSpdGiver : PB_HasteGiver {mixin PBXItems_Duration;}
class PBXItems_AdrePowGiver : PB_DoomGiver  {mixin PBXItems_Duration;}