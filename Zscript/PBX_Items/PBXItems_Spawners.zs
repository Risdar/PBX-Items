enum PBXItems_eItemSpawns
{
	DisableMegaBerserk			= 1 << 0,
	DisableSuperSphere			= 1 << 1,
	DisableUltraSphere			= 1 << 2,
	DisableHyperSphere			= 1 << 3,
	DisableMiniSphere			= 1 << 4,

	DisableBlackBlur			= 1 << 5,
	DisableDeflectSphere        = 1 << 6,
	DisableElectricAura         = 1 << 7,
	DisableGoldInvul            = 1 << 8,
	DisableLegendSPhere         = 1 << 9,
	DisableLifestealOrb         = 1 << 10,
	DisableTerrorSphere         = 1 << 11,
	DisableAmmoSphere           = 1 << 12,
	DisableGuardSphere          = 1 << 13,
	DisableRegenSphere          = 1 << 14,
	DisableTimeSphere           = 1 << 15,

	DisableRedSoul              = 1 << 16,
	DisableDarkMega             = 1 << 17,
	DisableAdrenaline           = 1 << 18

}

class PBItems_Injector : PBInjector	//your injector needs to inherit from PBInjector
{
	override void Init(PB_EventHandler handler)		//override this
	{
        if(!CheckFlag(DisableMegaBerserk))
        {
            handler.InjectSpawn('PB_BerserkSpawnerT2', 'PBX_MegaBerserk', 255, 1);
            handler.InjectSpawn('PB_BerserkSpawnerT3', 'PBX_MegaBerserk', 255, 1);
            handler.InjectSpawn('PB_BerserkSpawnerT4', 'PBX_MegaBerserk', 255, 1);
        }

        if(!CheckFlag(DisableSuperSphere))
        {
            handler.InjectSpawn('PB_SoulSphereSpawnerT2', 'PBX_SuperSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT3', 'PBX_SuperSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT4', 'PBX_SuperSphere', 255, 1);
        }

        if(!CheckFlag(DisableUltraSphere))
        {
            handler.InjectSpawn('PB_SoulSphereSpawnerT3', 'PBX_UltraSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT4', 'PBX_UltraSphere', 255, 1);
        }

        if(!CheckFlag(DisableHyperSphere))
        {
            handler.InjectSpawn('PB_MegaSpawnerT2', 'PBX_HyperSphere', 255, 1);
            handler.InjectSpawn('PB_MegaSpawnerT3', 'PBX_HyperSphere', 255, 1);
            handler.InjectSpawn('PB_MegaSpawnerT4', 'PBX_HyperSphere', 255, 1);
        }

        if(!CheckFlag(DisableMiniSphere))
        {
		    handler.InjectSpawn('PB_GreenSpawnerT3', 'PBX_MiniSphere', 255, 1);
		    handler.InjectSpawn('PB_GreenSpawnerT4', 'PBX_MiniSphere', 255, 1);
        }

        if(!CheckFlag(DisableBlackBlur))
        {
            handler.InjectSpawn('PB_BlurSpawnerT1', 'PBX_BlackBlur', 255, 1);
            handler.InjectSpawn('PB_BlurSpawnerT2', 'PBX_BlackBlur', 255, 1);
            handler.InjectSpawn('PB_BlurSpawnerT3', 'PBX_BlackBlur', 255, 1);
            handler.InjectSpawn('PB_BlurSpawnerT4', 'PBX_BlackBlur', 255, 1);
        }

        if(!CheckFlag(DisableDeflectSphere))
        {
            handler.InjectSpawn('PB_SoulSphereSpawnerT1', 'PBX_DeflectSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT2', 'PBX_DeflectSphere', 255, 1);
        }

        if(!CheckFlag(DisableElectricAura))
        {
            handler.InjectSpawn('PB_SoulSphereSpawnerT3', 'PBX_ElectricAuraSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT4', 'PBX_ElectricAuraSphere', 255, 1);
            handler.InjectSpawn('PB_MegaSpawnerT2', 'PBX_ElectricAuraSphere', 255, 1);
            handler.InjectSpawn('PB_MegaSpawnerT3', 'PBX_ElectricAuraSphere', 255, 1);
        }

        
        if(!CheckFlag(DisableGoldInvul))
        {
            handler.InjectSpawn('PB_InvulSpawnerT1', 'PBX_GoldInvul', 255, 1);
            handler.InjectSpawn('PB_InvulSpawnerT2', 'PBX_GoldInvul', 255, 1);
            handler.InjectSpawn('PB_InvulSpawnerT3', 'PBX_GoldInvul', 255, 1);
            handler.InjectSpawn('PB_InvulSpawnerT4', 'PBX_GoldInvul', 255, 1);
        }
        
        if(!CheckFlag(DisableLegendSPhere))
        {
            handler.InjectSpawn('PB_InvulSpawnerT1', 'PBX_LegendSphere', 255, 1);
            handler.InjectSpawn('PB_InvulSpawnerT2', 'PBX_LegendSphere', 255, 1);
            handler.InjectSpawn('PB_InvulSpawnerT3', 'PBX_LegendSphere', 255, 1);
            handler.InjectSpawn('PB_InvulSpawnerT4', 'PBX_LegendSphere', 255, 1);
        }
        
        if(!CheckFlag(DisableLifestealOrb))
        {
            handler.InjectSpawn('PB_BerserkSpawnerT1', 'PBX_MegaBerserk', 255, 1);
            handler.InjectSpawn('PB_BerserkSpawnerT2', 'PBX_MegaBerserk', 255, 1);
            handler.InjectSpawn('PB_BerserkSpawnerT3', 'PBX_MegaBerserk', 255, 1);
            handler.InjectSpawn('PB_BerserkSpawnerT4', 'PBX_MegaBerserk', 255, 1);
        }
        
        if(!CheckFlag(DisableTerrorSphere))
        {
            handler.InjectSpawn('PB_SoulSphereSpawnerT1', 'PBX_TerrorSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT2', 'PBX_TerrorSphere', 255, 1);

        }
        
        if(!CheckFlag(DisableAmmoSphere))
        {
            handler.InjectSpawn('PB_SoulSphereSpawnerT1', 'PBX_AmmoSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT2', 'PBX_AmmoSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT3', 'PBX_AmmoSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT4', 'PBX_AmmoSphere', 255, 1);
        }
        
        if(!CheckFlag(DisableGuardSphere))
        {
            handler.InjectSpawn('PB_SoulSphereSpawnerT1', 'PBX_GuardSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT2', 'PBX_GuardSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT3', 'PBX_GuardSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT4', 'PBX_GuardSphere', 255, 1);
        }
        
        if(!CheckFlag(DisableRegenSphere))
        {
            handler.InjectSpawn('PB_SoulSphereSpawnerT1', 'PBX_RegenSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT2', 'PBX_RegenSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT3', 'PBX_RegenSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT4', 'PBX_RegenSphere', 255, 1);

            handler.InjectSpawn('PB_MediSpawnerT3', 'PBX_RegenSphere', 255, 1);
            handler.InjectSpawn('PB_MediSpawnerT4', 'PBX_RegenSphere', 255, 1);
        }
        
        if(!CheckFlag(DisableTimeSphere))
        {
            handler.InjectSpawn('PB_SoulSphereSpawnerT4', 'PBX_TimeSphere', 255, 1);
            handler.InjectSpawn('PB_MegaSpawnerT4', 'PBX_TimeSphere', 255, 1);
            handler.InjectSpawn('PB_InvulSpawnerT4', 'PBX_TimeSphere', 255, 1);
        }

        if(!CheckFlag(DisableRedSoul))
        {
            handler.InjectSpawn('PB_SoulSphereSpawnerT1', 'PBX_RedSoulSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT2', 'PBX_RedSoulSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT3', 'PBX_RedSoulSphere', 255, 1);
            handler.InjectSpawn('PB_SoulSphereSpawnerT4', 'PBX_RedSoulSphere', 255, 1);
        }

        if(!CheckFlag(DisableDarkMega))
        {
            handler.InjectSpawn('PB_MegaSpawnerT1', 'PBX_DarkMegaSphere', 255, 1);
            handler.InjectSpawn('PB_MegaSpawnerT2', 'PBX_DarkMegaSphere', 255, 1);
            handler.InjectSpawn('PB_MegaSpawnerT3', 'PBX_DarkMegaSphere', 255, 1);
            handler.InjectSpawn('PB_MegaSpawnerT4', 'PBX_DarkMegaSphere', 255, 1);

        }

        if(!CheckFlag(DisableAdrenaline))
        {
            handler.InjectSpawn('PB_BerserkSpawnerT1', 'PBX_Adrenaline', 255, 1);
            handler.InjectSpawn('PB_BerserkSpawnerT2', 'PBX_Adrenaline', 255, 1);
        }
		
	}

    bool CheckFlag(int tipFlag)
    {
        let check = CVar.FindCVar("PBXItems_filter");
        return (check.GetInt() & tipflag) == tipflag;
    }
}