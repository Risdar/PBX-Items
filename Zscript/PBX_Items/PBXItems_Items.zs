class PBX_RepairKit : PB_Inventory
{
    Default
    {
		Inventory.AltHudIcon "RPKTA0";
        Inventory.PickupMessage "$REPAIRKIT_PICKUP";
        Inventory.PickupSound "RepairKit/Pickup";
        +FLOORCLIP;
        Tag "$REPAIRKIT_PICKUP";
    }

    override void Touch(Actor toucher)
	{
        Array<String> tips;
        tips.Push("$PBX_Repairkit_Tip1");
        if(PBXCore_WeaponsLoaded)
            tips.Push("$PBX_Repairkit_Tip2");
        PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXItems_itemHelpFlags",PBXItems_Tip_RepairKit);
        CheckWeapon(toucher);
	}

	private
    void CheckWeapon(Actor toucher)
    {
        let player = toucher.player;
        let playerwep = player.ReadyWeapon;
        if (!playerwep || !playerwep.AmmoType1)
        {
            toucher.A_Print("The Supply Kit has no effect on this weapon!");
            return;
        }

		toucher.A_SetBlend("blue",0.75,16);
        Inventory.PrintPickupMessage(true,pickupMsg);
        toucher.A_StartSound("RepairKit/Pickup", CHAN_ITEM);
        toucher.A_StartSound("RepairKit/Use", CHAN_ITEM);

        // Repairs the Player Monster Weapons
        if(PBXCore_WeaponsLoaded)
        {
            name cyberRl = "CyberRLDurability";
            name masterCG = "MastermindCGDurability";

            class <Inventory> hasCyberRL = cyberRl;
            class <Inventory> hasMasterCG = masterCG;

            int giveamt = 500; // hardcoded number since we cant access the MaxAmount

            if(hasCyberRL)
                toucher.GiveInventory(cyberRl,giveamt);

            if(hasMasterCG)
                toucher.GiveInventory(masterCG,giveamt);
        }

	    let wammo = playerwep.AmmoType1.GetClassName();

        FLineTraceData t;
        FTranslatedLineTarget lineTarget;
        bool hit = toucher.LineTrace(toucher.angle,40,toucher.pitch,TRF_NOSKY,32,data:t);
        int offsetpls = 40;
        if(hit) offsetpls = 12;

        switch(wammo)
        {
            case 'PB_DTech':
                RepairKit_SpawnAmmo("PB_DTechLarge","PB_DTech",1,3,offsetpls); break;
            case 'PB_Fuel':
                RepairKit_SpawnAmmo("PB_Fuel","PB_Fuel",1,3,offsetpls); break;
            case 'PB_LowCalMag':
                RepairKit_SpawnAmmo("PB_LowCalMagBox","PB_LowCalMag",1,3,offsetpls); break;	
            case 'PB_HighCalMag':
                RepairKit_SpawnAmmo("PB_HighCalMagBox","PB_HighCalMag",1,3,offsetpls); break;
            case 'PB_Shell':
                RepairKit_SpawnAmmo("PB_ShellBox","PB_Shell",1,2,offsetpls); break;
            case 'PB_RocketAmmo':
                RepairKit_SpawnAmmo("PB_RocketBox","PB_RocketAmmo",1,6,offsetpls); break;
            case 'PB_Cell':
                RepairKit_SpawnAmmo("PB_CellPack","PB_Cell",1,2,offsetpls); break;
            // case 'LesserDemonicEssence':
            //     RepairKit_SpawnAmmo("Nothing","LesserDemonicEssence",0,5,offsetpls); break;
            default: 
                break;
        }
        // goawayanddie();
		bNoInteraction = true;
        SetStateLabel("FinishedGivingAmmo");
	    return;
    }

	private
    void RepairKit_SpawnAmmo(string at1, string at2, int a1, int a2, int xoff)
	{
        self.A_SpawnItemEx("TeleportationFog",xoff);
        for(int i = a1;i>0;i--)
            self.A_SpawnItemEx(at1,xoff,0,32,frandom(0,2),frandom(-2,2),frandom(3,8),frandom(-30,30));
        for(int i = a2;i>0;i--)
            self.A_SpawnItemEx(at2,xoff,0,32,frandom(-2,2),frandom(-2,2),frandom(3,8),frandom(-30,30));
	}

    States
    {
        Spawn:
            RPKT ABCDEF 4;
            Loop;
        Pickup:
        FinishedGivingAmmo:
            "####" "#" 35 A_FadeOut(0.1); 
            stop;
    }
}

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
class PBXItems_AdreSpdGiver : PB_HasteGiver 
{Default{Powerup.Duration ADRENAL_DURATION;}}

class PBXItems_AdrePowGiver : PB_DoomGiver 
{Default{Powerup.Duration ADRENAL_DURATION;}}

// Shoulder Cannon
#include "./HelperFiles/ShoulderCannonHelpers.zs" // Contains the projectiles used by the item
class PBX_ShoulderCannon : CustomInventory
{
	Default
	{
		Inventory.AltHudIcon "SCFMA0";
		Inventory.PickupMessage "$SHOULDCANNON_PICKUP";
		Inventory.PickupSound "7LSPICK";
		Tag "$SHOULDCANNON_TAG";
		+INVENTORY.AUTOACTIVATE;
	}

	// Overlay Layers
	const FLAMEBELCH_LAYER = 51;
	const ICEBOMB_LAYER    = 69;
	const OVERLAY_LAYER    = 871;

	// Default Cooldowns (in seconds)
	const FLAME_DEFAULT_COOLDOWN = 12;
	const ICE_DEFAULT_COOLDOWN   = 35;

	// Ammo Takes
	const FUEL_AMMO       	= "PB_Fuel";
	const ROCKET_AMMO     	= "PB_RocketAmmo";
	const FLAME_AMMO_TAKE 	= 20;
	const ICE_AMMO_TAKE   	= 1;

	// How much ammo given upon pick up
	const FUEL_AMMO_GIVE 	= 100;
	const ROCKET_AMMO_GIVE 	= 15;

	enum EEquipType
	{
		EQUIP_NONE = -1,
		EQUIP_FLAMEBELCH,
		EQUIP_ICEBOMB,
		EQUIP_COUNT // How many equipments are there
	}

	static const String EquipReadySound[]  = {"Equip_flameready",   "Equip_Iceready"};
	static const int    EquipDefaultCool[] = {FLAME_DEFAULT_COOLDOWN, ICE_DEFAULT_COOLDOWN};

	bool isReady[EQUIP_COUNT];
	int  coolTic[EQUIP_COUNT];
	int  pendingSlot;

	override void AttachToOwner(Actor other)
	{
		if (other == null || other.player == null) return;
		for (int i = 0; i < EQUIP_COUNT; i++)
			isReady[i] = true; // Sets Every Type to Ready
		pendingSlot = EQUIP_NONE;
		other.A_GiveInventory(FUEL_AMMO, FUEL_AMMO_GIVE);
		other.A_GiveInventory(ROCKET_AMMO, ROCKET_AMMO_GIVE);
		super.AttachToOwner(other);
	}

	override void DoEffect()
	{
		super.DoEffect();

		if (owner == null || owner.player == null) return;

		// Update every seconds (35 tics)
		if (level.time % TICRATE == 0)
			UpdateEquipCooldowns();
	}

	override bool TryPickup(in out Actor toucher)
    {
        bool pickup = Super.TryPickup(toucher);
        if (pickup)
        {
			if(PBXItems_SendTip)
			{
				Array<String> tips;
				tips.Push("$PBX_ShouldCan_Tip1");
				tips.Push(string.format(
						StringTable.Localize("$PBX_ShouldCan_Tip2"),
						PB_HelpNotificationsHandler.PB_FormatKeybinds("pbx_doflame"), 
						PB_HelpNotificationsHandler.PB_FormatKeybinds("pbx_doice")
					)
				);
				PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXItems_itemHelpFlags",PBXItems_Tip_ShoulderCannon);
			}
        }
        return pickup;
    }

	// Called externally to queue a fire request.
	void RequestFire(int slot)
	{
		if (slot < 0 || slot >= EQUIP_COUNT) return;
		pendingSlot = slot;
	}

	private 
	void UpdateEquipCooldowns()
	{
		// For every equipment
		for (int i = 0; i < EQUIP_COUNT; i++)
		{
			// Skip if its ready to use
			if (isReady[i]) continue;

			// Get the cooldown
			int coolMax = GetEquipCooldown(i);
			coolTic[i]++; // count towards it

			// If it has reached the max cooldown, play a sound and set it to ready
			if (coolTic[i] >= coolMax)
			{
				coolTic[i] = 0;
				isReady[i] = true;
				owner.A_StartSound(EquipReadySound[i], CHAN_AUTO, CHANF_LOCAL, 1.0, ATTN_NONE);
			}
		}
	}

	// Action Functions
	private
	action state initShoulderCannon()
	{
		// console.printf("use state called");
		let ownr = PB_PlayerPrawn(invoker.owner);
		let revLauncherActive = ownr.player.FindPSprite(PB_WeaponBase.PSP_RevenantLauncherLayer);
		if (ownr && !revLauncherActive)
		{
			// console.printf("player found, starting overlay");
			return ResolveState("Startoverlay");
		}
		return ResolveState(null);
	}

	private
	action state checkShoulderCannon()
	{
		// console.printf("checking");
		let revLauncherActive = invoker.owner.player.FindPSprite(PB_WeaponBase.PSP_RevenantLauncherLayer);
		if (invoker.pendingSlot != EQUIP_NONE && !revLauncherActive)
			return handleFireLogic();
		return ResolveState(null);
	}

	private 
	action state handleFireLogic()
	{
		int slot = invoker.pendingSlot;
		invoker.pendingSlot = EQUIP_NONE;

		bool useELAmmo = true;
		let useAmmo = CVAR.GetCvar("be_UseELammo");
		if(useAmmo)
			useELAmmo = useAmmo.GetBool();

		if (slot == EQUIP_FLAMEBELCH)
		{
			bool notEnoughAmmo = CountInv(FUEL_AMMO) < FLAME_AMMO_TAKE;
			if ((useELAmmo && notEnoughAmmo) || !invoker.isReady[EQUIP_FLAMEBELCH])
			{
				A_Print(notEnoughAmmo ? "$SHOULDCANNON_NOFUEL" : "$SHOULDCAN_FLAMNOTREADY");
				emptyCannon();
				return ResolveState("CheckForAction");
			}

			invoker.isReady[EQUIP_FLAMEBELCH] = false;
			if (useELAmmo) TakeInventory(FUEL_AMMO, FLAME_AMMO_TAKE);
			A_Overlay(FLAMEBELCH_LAYER, "FireFlameBelch");
			return ResolveState("CheckForAction");
		}
		if (slot == EQUIP_ICEBOMB)
		{
			bool notEnoughAmmo = CountInv(ROCKET_AMMO) < ICE_AMMO_TAKE;
			if ((useELAmmo && notEnoughAmmo) || !invoker.isReady[EQUIP_ICEBOMB])
			{
				A_Print(notEnoughAmmo ? "$SHOULDCANNON_NOROCKET" : "$SHOULDCAN_ICENOTREADY");
				emptyCannon();
				return ResolveState("CheckForAction");
			}

			invoker.isReady[EQUIP_ICEBOMB] = false;
			if (useELAmmo) TakeInventory(ROCKET_AMMO, ICE_AMMO_TAKE);
			A_Overlay(ICEBOMB_LAYER, "FireIceBomb");
			A_OverlayFlags(ICEBOMB_LAYER, PSPF_FLIP|PSPF_MIRROR, true); // flip the layer so its on the right side
			return ResolveState("CheckForAction");
		}
		return ResolveState(null);
	}

	private 
	action void emptyCannon()
	{
		A_StartSound("Equip_notready");
	}

	// Used by UI scope
	clearscope int GetEquipCooldown(int slot) const
	{
		if (slot < 0 || slot >= EQUIP_COUNT) return 0;
		return EquipDefaultCool[slot];
	}

	clearscope bool IsEquipReady(int slot) const
	{
		if (slot < 0 || slot >= EQUIP_COUNT) return false;
		return isReady[slot];
	}

	clearscope double GetCooldownFraction(int slot) const
	{
		if (slot < 0 || slot >= EQUIP_COUNT || isReady[slot]) return 1.0;
		int coolMax = GetEquipCooldown(slot);
		return coolMax > 0 ? double(coolTic[slot]) / coolMax : 1.0;
	}

	States
	{
		Spawn:
			SCFM A -1;
			loop;

		Use:
			TNT1 A 0 initShoulderCannon();
		Remove:
			stop;

		Startoverlay:
			TNT1 A 0 A_Overlay(OVERLAY_LAYER, "CheckForAction");
			wait;

		// This layer should never be destroyed
		CheckForAction:
			TNT1 A 1 checkShoulderCannon();
			Loop;

		FireFlameBelch:
			SCL0 ABCD 1 A_StartSound("Equip_Activate", CHAN_ITEM);
			SCL0 EFGHIJ 1;
			SCL0 K 1 A_Quake(8, 8, 0, 32);
			TNT1 A 0 A_Recoil(4);
			SCF0 A 3 bright A_GunFlash();
			TNT1 A 0 A_AlertMonsters();
		ActualFireFlameBelch:
			TNT1 A 0 A_StartSound("Flamebelch", CHAN_ITEM);
			SCF0 BCDBCDBCD 1 bright {
				if(pb_performance_fire)
					A_FireProjectile("PBX_FireMissile", -3, 0, Random(-25, -20), 12, FPF_NOAUTOAIM, 0);
				else
					A_FireProjectile("PBX_FireMissileSimple", -3, 0, Random(-25, -20), 12, FPF_NOAUTOAIM, 0);
			}
			SCF0 EF 1;
			SCL0 KJIHGFEDCBA 1;
			Stop;

		FireIceBomb:
			SCL0 ABCD 1 A_StartSound("Equip_Activate", CHAN_ITEM);
			SCL0 EFGHIJ 1;
			SCL0 K 1 A_Quake(8, 8, 0, 32);
			TNT1 A 0 A_Recoil(4);
			SCF0 A 3 bright A_GunFlash();
			TNT1 A 0 A_AlertMonsters();
		ActualFireIceBomb:
			SCF0 BC 1 bright;
			SCF0 D 1 bright {
				A_StartSound("weapons/firegrenade", CHAN_ITEM);
				A_FireProjectile("PBX_CryoGrenade", 1, 0, Random(22, 18), 12, FPF_NOAUTOAIM, 0);
			}
			SCF0 EF 1;
			SCL0 KJIHGFEDCBA 1;
			Stop;
	}
}