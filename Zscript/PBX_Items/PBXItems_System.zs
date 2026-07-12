enum PBXItems_ePowerupTipFlags
{
	PBXItems_Tip_BlackBlur			    = 1 << 0,
	PBXItems_Tip_DeflectSphere          = 1 << 1,
	PBXItems_Tip_ElectricAura           = 1 << 2,
	PBXItems_Tip_GoldInvul              = 1 << 3,
	PBXItems_Tip_LegendSPhere           = 1 << 4,
	PBXItems_Tip_LifestealOrb           = 1 << 5,
	PBXItems_Tip_TerrorSphere           = 1 << 6,
	PBXItems_Tip_AmmoSphere             = 1 << 7,
	PBXItems_Tip_GuardSphere            = 1 << 8,
	PBXItems_Tip_RegenSphere            = 1 << 9,

	PBXItems_Tip_RedSoul                = 1 << 10,
	PBXItems_Tip_DarkMega               = 1 << 11,

	PBXItems_Tip_FrostAura              = 1 << 12,
	PBXItems_Tip_FireAura               = 1 << 13
}

enum PBXItems_eItemTipFlags
{
	PBXItems_Tip_RepairKit			    = 1 << 0,
	PBXItems_Tip_Adrenaline             = 1 << 1,
	PBXItems_Tip_ShoulderCannon         = 1 << 2
}

enum PBXItems_Values{
    MEGABERSERK_HP      = 200,
    MEGABERSERK_MAX     = 200,

    SUPERSPHERE_HP      = 100,
    SUPERSPHERE_MAX     = 200,

    //Given by Ultra Sphere
    SUPERARMOR_SV       = 70,
    SUPERARMOR_AMT      = 100,

    HYPERSPHERE_HP      = 300,
    HYPERSPHERE_MAX     = 300,
    HYPERARMOR_SV       = 70,
    HYPERARMOR_AMT      = 300,

    MINISPHERE_HP       = 50,
    MINISPHERE_MAX      = 200,
    MINIARMOR_SV        = 60,
    MINIARMOR_AMT       = 50,

    GOLDINV_DURATION    = -60,
    TERROR_DURATION     = -45,
    INFAMMO_DURATION    = -30,
    TMFREEZE_DURATION   = -45,

    REDSOUL_HP   		= 150,
    REDSOUL_MAX   		= 200,

	DARKMEGA_HP   		= 200,
    DARKMEGA_MAX   		= 200,

    ADRENAL_DURATION    = -15
}

class PBXItems_ShouldCanHandler : EventHandler
{
	override void NetworkProcess(ConsoleEvent e)
	{
		if (e.Player < 0 || !playeringame[e.Player]) return;

		let pmo = players[e.Player].mo;
		if (pmo == null) return;

		let cannon = PBX_ShoulderCannon(pmo.FindInventory("PBX_ShoulderCannon"));
		if (cannon == null) return;

		if (e.Name ~== "UseFlameBelch")
			cannon.RequestFire(PBX_ShoulderCannon.EQUIP_FLAMEBELCH);
		else if (e.Name ~== "UseIceBomb")
			cannon.RequestFire(PBX_ShoulderCannon.EQUIP_ICEBOMB);
	}
}