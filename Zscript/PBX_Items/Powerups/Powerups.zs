#include "./AuraSpheres.zs" // Aura Spheres
#include "./TaintedSpheres.zs" // Tainted Spheres

// ============================================================
// PBX Powerups - From PB's More Items mod by HyperExia
// ============================================================
// --- Mega Berserk ---
class PBX_MegaBerserk : PB_Berserk
{
	Default
	{
		Inventory.AltHudIcon "PSTRC0";
		Tag "$MEGABERSERK_TAG";
	}

	override bool Use(bool pickup)
	{
        if(!PB_HelpNotificationsHandler.CheckTipEvent(1 << 6, CVar.GetCvar("pb_helpflags", owner.Player)))
		{
			Array<String> pbTipsBuf;
			pbTipsBuf.Push("$PB_BERSERK_TIP_1");
			pbTipsBuf.Push(string.format(StringTable.Localize("$PB_BERSERK_TIP_2"), PB_HelpNotificationsHandler.PB_FormatKeybinds("+pb_specialwheel")));
			PB_HelpNotificationsHandler.PB_SendTipArray(pbTipsBuf, "pb_helpflags", 1 << 6);
		}
		owner.A_GiveInventory("PB_PowerStrength");
		owner.GiveBody(MEGABERSERK_HP,MEGABERSERK_MAX);
		owner.A_SetBlend("Red",0.75,16);
		if(pb_newmugshot) owner.A_SetMugshotState("BerserkGrin");
		return true;
	}

	override string PickupMessage() 
	{
		string msg = StringTable.Localize("$MEGABERSERK_PICKUP");
		if(ownHP < 25) msg = StringTable.Localize("$MEGABERSERK_PICKUP_LOW");
		return string.format(msg, max(0, 100 - ownHP));
	}

	States
	{
		Spawn:
			PSTR C -1;
			stop;
	}
}

// --- Super Sphere ---
class PBX_SuperSphere : PB_Soulsphere
{
	Default
	{
		Inventory.AltHudIcon "SPRSA0";
		Inventory.Amount SUPERSPHERE_HP;
		Inventory.MaxAmount SUPERSPHERE_MAX;
		Inventory.PickupMessage "$SUPERSPHERE_PICKUP";
		Health.LowMessage 25, "$SUPERSPHERE_PICKUP_LOW";
		Tag "$SUPERSPHERE_TAG";
	}

	override bool TryPickup (in out Actor other) 
	{
		other.A_SetBlend("Blue",0.75,16);
		if(other.player && CVar.GetCVar("pb_newmugshot", other.player).GetBool())
			other.A_SetMugshotState("SoulsphereGrin");
		return super.TryPickup(other);
	}
	
	States
	{
		Spawn:
			SPRS ABCDEFGHIJ 3;
			loop;
	}
}

// --- Ultra Sphere ---
class PBX_UltraSphere : PB_Inventory
{	
	Default
	{
		Inventory.AltHudIcon "ULTSA0";
		Inventory.PickupMessage "$ULTRASPHERE_PICKUP";
		Tag "$ULTRASPHERE_TAG";
	}

	int ownHP, ownAP;

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("White",0.75,16);
		ownHP = clamp(200 - owner.health, 0, 200);
		ownAP = clamp(200 - owner.CountInv("BasicArmor"), 0, 200);
		owner.A_GiveInventory(GetReplacement("PB_Soulsphere").getClassName());
		owner.A_GiveInventory("PBX_UltraArmor");
		if(pb_newmugshot) owner.A_SetMugshotState("MegasphereGrin");
		return true;
	}
	
	override string PickupMessage()
	{
		string msg = string.format(StringTable.Localize(Super.PickupMessage()), ownHP, ownAP);
		return msg;
	}
	
	States
	{
		Spawn:
			ULTS ABCDEFGHIJ 3;
			loop;
	}
}
class PBX_UltraArmor : PBXCore_ArmorBase
{
	Default
    {
		Armor.SavePercent ULTRAARMOR_SV;
		Armor.SaveAmount ULTRAARMOR_AMT;
		Inventory.PickupMessage "$ULTRAARMOR_PICKUP";
        Inventory.AltHudIcon "ULTSA0";
		Tag "$ULTRAARMOR_TAG";
	}
}

// --- Hyper Sphere ---
class PBX_HyperSphere : PB_Inventory
{
	Default
	{
		Inventory.AltHudIcon "HYPSA0";
		Inventory.PickupMessage "$HYPERSPHERE_PICKUP";
		Tag "$HYPERSPHERE_TAG";
	}

	int ownHP, ownAP;

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("White",0.75,16);
		ownHP = clamp(200 - owner.health, 0, 200);
		ownAP = clamp(200 - owner.CountInv("BasicArmor"), 0, 200);
		owner.GiveBody(HYPERSPHERE_HP,HYPERSPHERE_MAX);
		owner.A_GiveInventory("PBX_HyperArmor");
		if(pb_newmugshot) owner.A_SetMugshotState("MegasphereGrin");
		return true;
	}
	
	override string PickupMessage()
	{
		string msg = string.format(StringTable.Localize(Super.PickupMessage()), ownHP, ownAP);
		return msg;
	}
	
	States
	{
		Spawn:
			HYPS ABCDEFGHIJ 3;
			loop;
	}
}
class PBX_HyperArmor : PBXCore_ArmorBase
{
	Default
    {
		Armor.SavePercent HYPERARMOR_SV;
		Armor.SaveAmount HYPERARMOR_AMT;
		Inventory.PickupMessage "$HYPERARMOR_PICKUP";
        Inventory.AltHudIcon "HYPSA0";
		Tag "$HYPERARMOR_TAG";
	}
}

// --- Mini Sphere ---
class PBX_MiniSphere : PB_Inventory
{
	Default
	{
		Inventory.AltHudIcon "MINIA0";
		Inventory.PickupMessage "$MINISPHERE_PICKUP";
		Inventory.PickupSound "SSPH";
		Tag "$MINISPHERE_TAG";
	}

	int ownHP, ownAP;

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("White",0.75,16);
		ownHP = clamp(200 - owner.health, 0, 200);
		ownAP = clamp(200 - owner.CountInv("BasicArmor"), 0, 200);
		owner.GiveBody(MINISPHERE_HP,MINISPHERE_MAX);
		owner.A_GiveInventory("PBX_MiniArmor");
		if(pb_newmugshot) owner.A_SetMugshotState("MegasphereGrin");
		return true;
	}
	
	override string PickupMessage()
	{
		string msg = string.format(StringTable.Localize(Super.PickupMessage()), ownHP, ownAP);
		return msg;
	}
	
	States
	{
		Spawn:
			MINI ABCDEFGHIJ 3;
			loop;
	}
}
class PBX_MiniArmor : PBXCore_ArmorBase
{
	Default
    {
		Armor.SavePercent MINIARMOR_SV;
		Armor.SaveAmount MINIARMOR_AMT;
		Inventory.PickupMessage "$MINIARMOR_PICKUP";
        Inventory.AltHudIcon "MINIA0";
		Tag "$MINIARMOR_TAG";
	}
}

// ============================================================
// PBX Powerups - From Unless You Got Powah
// ============================================================
// --- Deflect Sphere ---
class PBX_DeflectSphere : PB_Inventory
{
	Default
	{
		RenderStyle "Translucent";
		Inventory.AltHudIcon "PDFSA0";
		Inventory.PickupMessage "$DEFLECTSPHERE_PICKUP";
		Inventory.PickupSound "INVISIBL";
		+FLOATBOB
		floatbobstrength .4;
		Tag "$DEFLECTSPHERE_PICKUP";
	}

	override bool Use(bool pickup)
	{
		if(PBXItems_SendTip)
		{
			Array<String> tips;
			tips.Push("$PBX_Deflect_Tip1");
			PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXItems_powerupHelpFlags",PBXItems_Tip_DeflectSphere);
		}
		owner.A_SetBlend("LightGreen",0.75,16);
		owner.A_GiveInventory("PBX_DeflectGiver");
		return true;
	}

	States
	{
		Spawn:
			PDFS ABCD 6 bright;
			loop;
	}
}

// ============================================================
// PBX Powerups - Based on Vanilla Doom's Powerups
// ============================================================

// --- Legend Sphere ---
class PBX_LegendSphere : PB_Inventory
{
	Default
	{
		Inventory.AltHudIcon "LESPA0";
		Inventory.PickupMessage "$LEGENDSPHERE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
		Scale .73;
		Tag "$LEGENDSPHERE_PICKUP";
	}

	override bool Use(bool pickup)
	{
		if(PBXItems_SendTip)
		{
			Array<String> tips;
			tips.Push("$PBX_Legend_Tip1");
			PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXItems_powerupHelpFlags",PBXItems_Tip_LegendSPhere);
		}
		owner.A_SetBlend("DarkOrange",0.75,16);
		owner.A_GiveInventory("PBXItems_BuddhaGiver");
		if(pb_newmugshot) owner.A_SetMugshotState("Grin");
		return true;
	}

	States
	{
		Spawn:
			LESP ABCD 6 bright;
			loop;
	}
}
class PBXItems_BuddhaGiver : PBX_BuddhaGiver 
{Default{Powerup.Color "00 00 128", 0.3;}}


// --- Lifesteal Orb ---
class PBX_LifestealOrb : PB_Inventory
{
	Default
	{
		Inventory.AltHudIcon "RAGEA0";
		Inventory.PickupMessage "$LFSTEALORB_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
		Tag "$LFSTEALORB_PICKUP";
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("firebrick",0.75,16);
		owner.A_GiveInventory("PBX_DrainGiver");
		return true;
	}

	States
	{
		Spawn:
			RAGE ABCDCB 6 bright;
			loop;
	}
}

// --- Terror Sphere ---
class PBX_TerrorSphere : PB_Inventory
{
	Default
	{
		Inventory.AltHudIcon "TERRA0";
		Inventory.PickupMessage "$TERRORSPHERE_PICKUP";
		Inventory.PickupSound "BERSPKUP";
		+FLOATBOB
		floatbobstrength .4;
		Tag "$TERRORSPHERE_PICKUP";
	}

	override bool Use(bool pickup)
	{
		if(PBXItems_SendTip)
		{
			Array<String> tips;
			tips.Push("$PBX_Terror_Tip1");
			PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXItems_powerupHelpFlags",PBXItems_Tip_TerrorSphere);
		}
		owner.A_SetBlend("DarkRed",0.75,16);
		owner.A_GiveInventory("PBXItems_FrightenerGiver");
		if(pb_newmugshot) owner.A_SetMugshotState("BerserkGrin");
		return true;
	}

	States
	{
		Spawn:
			TERR ABCD 6 bright;
			loop;
	}
}
class PBXItems_FrightenerGiver : PBX_FrightenerGiver 
{
	mixin PBXItems_Duration;
	Default{Powerup.Color "GoldMap";}
}

// --- Ammo Sphere ---
class PBX_AmmoSphere : PB_Inventory
{
	Default
	{
		Inventory.AltHudIcon "AMSPA0";
		Inventory.PickupMessage "$AMMOSPHERE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
		Tag "$AMMOSPHERE_PICKUP";
	}

	override bool Use(bool pickup)
	{
		if(PBXItems_SendTip)
		{
			Array<String> tips;
			tips.Push("$PBX_Ammo_Tip1");
			PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXItems_powerupHelpFlags",PBXItems_Tip_AmmoSphere);
		}
		owner.A_SetBlend("yellow",0.75,16);
		owner.A_GiveInventory("PBXItems_InfiniteAmmoGiver");
		if(pb_newmugshot) owner.A_SetMugshotState("Grin");
		return true;
	}

	States
	{
		Spawn:
			AMSP ABCD 6 bright;
			loop;
	}
}
class PBXItems_InfiniteAmmoGiver : PBX_InfiniteAmmoGiver 
{
	mixin PBXItems_Duration;
	Default{Powerup.Color "255 0 0", 0.4;}
}

// --- Guard Sphere  ---
class PBX_GuardSphere : PB_Inventory
{
	Default
	{
		Inventory.AltHudIcon "GARDA0";
		Inventory.PickupMessage "$GUARDSPHERE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
		Tag "$GUARDSPHERE_PICKUP";
	}

	override bool Use(bool pickup)
	{
		if(PBXItems_SendTip)
		{
			Array<String> tips;
			tips.Push("$PBX_Guard_Tip1");
			PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXItems_powerupHelpFlags",PBXItems_Tip_GuardSphere);
		}
		owner.A_SetBlend("PaleTurquoise1",0.75,16);
		owner.A_GiveInventory("PBXItems_ProtectionGiver");
		return true;
	}

	States
	{
		Spawn:
			GARD ABCD 6 bright;
			loop;
	}
}
class PBXItems_ProtectionGiver : PBX_ProtectionGiver 
{Default{Powerup.Color "GreenMap"; Damagefactor "Normal", 0.25;}}

// --- PowerRegeneration ---
class PBX_RegenSphere : PB_Inventory
{
	Default
	{
		Inventory.AltHudIcon "REGNA0";
		Inventory.PickupMessage "$REGENSPHERE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
		Tag "$REGENSPHERE_PICKUP";
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("Cyan",0.75,16);
		owner.A_GiveInventory("PBX_RegenerationGiver");
		return true;
	}

	States
	{
		Spawn:
			REGN ABCD 6 bright;
			loop;
	}
}

// --- PowerTimeFreezer ---
class PBX_TimeSphere : PB_Inventory
{
	Default
	{
		Inventory.AltHudIcon "TIMEA0";
		Inventory.PickupMessage "$TIMEFREEZE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
		Tag "$TIMEFREEZE_TAG";
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("DarkOrange",0.75,16);
		owner.A_GiveInventory("PBXItems_TimeFreezeGiver");
		return true;
	}

	States
	{
		Spawn:
			TIME ABCD 6 bright;
			loop;
	}
}
class PBXItems_TimeFreezeGiver : PBX_TimeFreezeGiver 
{
	mixin PBXItems_Duration;
	Default{Powerup.Color "Goldmap";}
}

// --- PowerFlight ---
class PBX_FlightSphere : PB_Inventory
{
	Default
	{
		Inventory.AltHudIcon "FLYTA0";
		Inventory.PickupMessage "$FLIGHTSPHERE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
		Tag "$FLIGHTSPHERE_PICKUP";
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("SteelBlue1",0.75,16);
		owner.A_GiveInventory("PBX_FlightGiver");
		return true;
	}

	States
	{
		Spawn:
			FLYT ABCD 6 bright;
			loop;
	}
}