enum PBXItems_ePowerupTipFlags
{
	PBXItems_Tip_BlackBlur			    = 1 << 0,
	PBXItems_Tip_DeflectSphere          = 1 << 1,
	PBXItems_Tip_ElectricAura           = 1 << 2,
	PBXItems_Tip_GoldInvul              = 1 << 3,
	PBXItems_Tip_LegendSPhere           = 1 << 4,
	PBXItems_Tip_TerrorSphere           = 1 << 6,
	PBXItems_Tip_AmmoSphere             = 1 << 7,
	PBXItems_Tip_GuardSphere            = 1 << 8,

	PBXItems_Tip_RedSoul                = 1 << 9,
	PBXItems_Tip_DarkMega               = 1 << 10,

	PBXItems_Tip_FrostAura              = 1 << 11,
	PBXItems_Tip_FireAura               = 1 << 12
}

enum PBXItems_eItemTipFlags
{
	PBXItems_Tip_RepairKit			    = 1 << 0,
	PBXItems_Tip_Adrenaline             = 1 << 1,
	PBXItems_Tip_ShoulderCannon         = 1 << 2,
	PBXItems_Tip_JetPack         		= 1 << 3
}

enum PBXItems_Values
{
    MEGABERSERK_HP      = 200,
    MEGABERSERK_MAX     = 200,

    SUPERSPHERE_HP      = 100,
    SUPERSPHERE_MAX     = 200,

    ULTRAARMOR_SV       = 70,
    ULTRAARMOR_AMT      = 100,

    HYPERSPHERE_HP      = 200,
    HYPERSPHERE_MAX     = 200,
    HYPERARMOR_SV       = 100,
    HYPERARMOR_AMT      = 200,

    MINISPHERE_HP       = 50,
    MINISPHERE_MAX      = 200,
    MINIARMOR_SV        = 60,
    MINIARMOR_AMT       = 50,

    REDSOUL_HP   		= 150,
    REDSOUL_MAX   		= 200,

	DARKMEGA_HP   		= 200,
    DARKMEGA_MAX   		= 200,

    AURASPHERE_HP   	= 100,
    AURASPHERE_MAX   	= 200

	// Items

}

mixin class PBXItems_Duration
{
    override void BeginPlay()
	{
		super.BeginPlay();
		EffectTics = CVar.FindCVar(getDuration(self)).GetInt() * TICRATE;
	}

    name getDuration(actor mActor)
	{
		switch(mActor.getClassName())
		{
			case 'PBXItems_InvulTaintedGiver': 	    return 'pbxitems_goldinv_duration';
			case 'PBXItems_FrightenerGiver': 		return 'pbxitems_terror_duration';
			case 'PBXItems_InfiniteAmmoGiver': 	    return 'pbxitems_infammo_duration';
			case 'PBXItems_TimeFreezeGiver': 		return 'pbxitems_timefreeze_duration';
			case 'PBXItems_AdreSpdGiver':
			case 'PBXItems_AdrePowGiver': 			return 'pbxitems_adrenaline_duration';
		}
		return '';
	}

}

class PBXItems_Handler : EventHandler
{
	// Handles the Shoulder Cannon and JetPack input
	override void NetworkProcess(ConsoleEvent e)
	{
		if (e.Player < 0 || !playeringame[e.Player]) 
			return;

		let pmo = players[e.Player].mo;
		if (!pmo) return;

		checkShoulderCannon(e,pmo);
		checkJetpack(e,pmo);
		
	}

	void checkShoulderCannon(ConsoleEvent e, PlayerPawn pmo)
	{
		let cannon = PBX_ShoulderCannon(pmo.FindInventory("PBX_ShoulderCannon"));
		if (!cannon) return;

		if (e.Name ~== "PBX_UseFlameBelch")
			cannon.RequestFire(PBX_ShoulderCannon.EQUIP_FLAMEBELCH);
		else if (e.Name ~== "PBX_UseIceBomb")
			cannon.RequestFire(PBX_ShoulderCannon.EQUIP_ICEBOMB);
	}

	void checkJetpack(ConsoleEvent e, PlayerPawn pmo)
	{
		let jetpack = PBX_Jetpack(pmo.FindInventory("PBX_Jetpack"));
		if (!jetpack) return;

		if (e.Name ~== "PBX_ToggleJetpack")
			jetpack.toggleJetpack();
	}

	// Gives the player shoulder cannon if enabled
	Override void PlayerEntered(PlayerEvent e)
    {
		// Get player pointer
        let pm = players[e.PlayerNumber].mo;
		if(!pm) return;

		// Dont continue if its the titlemap
        if (level.MapName == "TITLEMAP") return;

        if(pbxitems_startwithshouldercannon && !PBXCore_GlorykillLoaded) 
			PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBX_ShoulderCannon', diffCheck:false);
    }
}