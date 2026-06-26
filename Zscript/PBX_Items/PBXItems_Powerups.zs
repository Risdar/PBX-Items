// ============================================================
// PBX Powerups - From PB's More Items mod by HyperExia
// ============================================================
// --- Mega Berserk ---
class PBX_MegaBerserk : PB_Berserk
{
	Override Void PostBeginPlay()
    {
		string invString = "PB_Berserk";
		class<actor> invActor = invString;
		if(invActor){
			let def = GetDefaultByType(invActor);
			if (!def){Destroy();return;}
			self.scale.x = def.scale.x;
			self.scale.y = def.scale.y;
		}
		Super.PostBeginPlay();
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
		return string.format(ownrhp < 25 ? "Mega Berserk Pack (+%u much needed HP)" : "Mega Berserk Pack (+%u HP)",max(0,100 - ownrhp));
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
	override bool Use(bool pickup)
	{
		owner.A_SetBlend("Blue",0.75,16);
		owner.GiveBody(SUPERSPHERE_HP,SUPERSPHERE_MAX);
		if(pb_newmugshot) owner.A_SetMugshotState("SoulsphereGrin");
		return true;
	}
	
    override string PickupMessage()
	{
		return string.format(String.Format(ownrhp < 25 ? "SuperSphere (+%u much needed HP)" : "SuperSphere (+%u HP)",clamp(min(100, 200 - ownrhp), 0, 100)));
	}

	States
	{
	Spawn:
		SPRS ABCDEFGHIJ 3;
		loop;
	}
}

// --- Ultra Sphere ---
class PBX_UltraSphere : PB_Megasphere
{
	Default
	{
		Inventory.PickupMessage "$ULTRASPHERE_PICKUP";
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("White",0.75,16);
		owner.A_GiveInventory(GetReplacement("PBX_SuperArmor").getClassName());
		owner.A_GiveInventory(GetReplacement("PB_Soulsphere").getClassName());
		if(pb_newmugshot) owner.A_SetMugshotState("MegasphereGrin");
		return true;
	}
	
	States
	{
	Spawn:
		ULTS ABCDEFGHIJ 3;
		loop;
	}
}
class PBX_SuperArmor : PB_Armor
{
	Default
    {
		Armor.SavePercent SUPERARMOR_SV;
		Armor.SaveAmount SUPERARMOR_AMT;
		Inventory.PickupMessage "$SUPERARMOR_PICKUP";
        Inventory.AltHudIcon "ULTSA0";
	}
}

// --- Hyper Sphere ---
class PBX_HyperSphere : PB_Megasphere
{
	Default
	{
		Inventory.PickupMessage "$HYPERSPHERE_PICKUP";
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("White",0.75,16);
		owner.A_GiveInventory(GetReplacement("PBX_HyperArmor").getClassName());
		owner.GiveBody(HYPERSPHERE_HP,HYPERSPHERE_MAX);
		if(pb_newmugshot) owner.A_SetMugshotState("MegasphereGrin");
		return true;
	}
	
	States
	{
	Spawn:
		HYPS ABCDEFGHIJ 3;
		loop;
	}
}
class PBX_HyperArmor : PB_Armor
{
	Default
    {
		Armor.SavePercent HYPERARMOR_SV;
		Armor.SaveAmount HYPERARMOR_AMT;
		Inventory.PickupMessage "$HYPERARMOR_PICKUP";
        Inventory.AltHudIcon "HYPSA0";
	}
}

// --- Mini Sphere ---
class PBX_MiniSphere : PB_Megasphere
{
	Default
	{
		Inventory.PickupMessage "$MINISPHERE_PICKUP";
		Inventory.PickupSound "SSPH";
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("White",0.75,16);
		owner.A_GiveInventory(GetReplacement("PBX_MiniArmor").getClassName());
		owner.GiveBody(MINISPHERE_HP,MINISPHERE_MAX);
		if(pb_newmugshot) owner.A_SetMugshotState("MegasphereGrin");
		return true;
	}
	
	States
	{
	Spawn:
		MINI ABCDEFGHIJ 3;
		loop;
	}
}
class PBX_MiniArmor : PB_Armor
{
	Default
    {
		Armor.SavePercent MINIARMOR_SV;
		Armor.SaveAmount MINIARMOR_AMT;
		Inventory.PickupMessage "$MINIARMOR_PICKUP";
		Inventory.PickupSound "ARMOR";
        Inventory.AltHudIcon "MINIA0";
		//Scale .28;
	}
}

// ============================================================
// PBX Powerups - From Unless You Got Powah
// ============================================================
// --- BlackBur ---
Class PBX_BlackBlur : PB_Inventory
{
	Default
	{
        //$Category Powerups/Tainted
        //%Tag Tainted Invisibility Sphere
        RenderStyle "Translucent";
        Inventory.PickupMessage "$BLACKBLUR_PICKUP";
		Inventory.PickupSound "INVISIBL";
		+FLOATBOB
		floatbobstrength .4;
	}
	
    override bool Use(bool pickup)
	{
		owner.A_SetBlend("DarkSlateBlue",0.75,16);
		owner.A_GiveInventory("PBX_InvisTaintedGiver");
		return true;
	}

	action void VisCheck()
    {
		BlockThingsIterator it = BlockThingsIterator.Create(self, 512);
		while(it.Next())
		{
			let obj = it.thing;
						
			if(obj.bISMONSTER && obj.health > 0 && Distance3D(obj) <= 256 && !obj.bSTEALTH)
			{
				obj.bSTEALTH = TRUE;
			}
			else if(obj.bISMONSTER && obj.health > 0 && Distance3D(obj) > 256 && obj.bSTEALTH)
			{
				obj.bSTEALTH = FALSE;
				obj.Alpha = 1.0;
			}
		}
    }
	
	override void Tick()
	{
		super.Tick();
		
		double a = FRandom(1, 360);
		double b = (FRandom(-40, 40) + FRandom(-40, 40));
		
		A_SpawnParticleEx(
			"0000AA",
			TexMan.CheckForTexture("FLAKA0"),
			style: STYLE_Add,
			flags: SPF_FULLBRIGHT,
			lifetime: 35,
			size: 8.0,
			angle: a,
			xoff: cos(a) * cos(b) * 40,
			yoff: sin(a) * cos(b) * 40,
			zoff: sin(b) * 40 + 26,
			velx: -cos(a) * cos(b) * 0.6,
			vely: -sin(a) * cos(b) * 0.6,
			velz: -sin(b) * 0.6,
			startalphaf: 1.0,
			fadestepf: -0.05,
			sizestep: -0.2,
			startroll: 0
		);
	}
	
	override bool CanPickup(Actor toucher)
	{
		if(toucher)
		{
			BlockThingsIterator it = BlockThingsIterator.Create(self, 512);
			while(it.Next())
			{
				let obj = it.thing;
						
				if(obj && obj is "PB_Monster" && obj.bISMONSTER && obj.bSTEALTH)
				{
					obj.bSTEALTH = FALSE;
					obj.Alpha = 1.0;
				}
			}
		}
		
		super.CanPickup(toucher);
		return TRUE;
	}

    States
	{
		Spawn:
			TVIS ABCD 6 Bright VisCheck();
			Loop;
	}
}


// --- Deflect Sphere ---
class PBX_DeflectSphere : PB_Inventory
{
	Default
	{
		RenderStyle "Translucent";
		Inventory.PickupMessage "$DEFLECTSPHERE_PICKUP";
		Inventory.PickupSound "INVISIBL";
		+FLOATBOB
		floatbobstrength .4;
		//Scale .22;
	}

	override bool Use(bool pickup)
	{
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

// --- ElectricAura ---
class PBX_ElectricAuraSphere : PB_Inventory
{
	Default
	{
		Inventory.PickupMessage "$ELECTAURA_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
		//Scale .22;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("RoyalBlue1",0.75,16);
		owner.A_GiveInventory("PBX_ElectricAuraGiver");
		return true;
	}

	States
	{
        Spawn:
            VELA ABCDEFGHDEF 3 bright;
            Loop;
	}
}

// --- Tainted Invulnerability (Gold Invul)  ---
class PBX_GoldInvul : PB_Inventory
{
	Default
	{
		Inventory.PickupMessage "$GOLDINV_PICKUP";
		Inventory.PickupSound "INVUL";
		+FLOATBOB
		floatbobstrength .4;
		//Scale .22;
	}
	double n;

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("PaleGoldenrod",0.75,16);
		owner.A_GiveInventory("PBXItems_InvulTaintedGiver");
		if(pb_newmugshot) owner.A_SetMugshotState("Grin");
		return true;
	}

    action void InvCheck()
    {
		BlockThingsIterator it = BlockThingsIterator.Create(self, 512);	
		while(it.Next())
		{
			let obj = it.thing;
						
			if(obj && obj is "PB_Monster" && obj.bISMONSTER && obj.health > 0 && Distance3D(obj) <= 256 && !obj.bINVULNERABLE)
			{
				obj.bINVULNERABLE = TRUE;
			}
			else if(obj && obj is "PB_Monster" && obj.bISMONSTER && obj.health > 0 && Distance3D(obj) > 256 && obj.bINVULNERABLE)
			{
				obj.bINVULNERABLE = FALSE;
			}
		}
    }
	
	override bool CanPickup(Actor toucher)
	{
		if(toucher)
		{
			BlockThingsIterator it = BlockThingsIterator.Create(self, 512);
			while(it.Next())
			{
				let obj = it.thing;
						
				if(obj && obj is "PB_Monster" && obj.bISMONSTER && obj.bINVULNERABLE)
				{
					obj.bINVULNERABLE = FALSE;
				}
			}
		}
		
		super.CanPickup(toucher);
		return TRUE;
	}
		
	override void Tick()
	{
		super.Tick();
		if(n > 359)
			n = 0;
			
		double a = n;
		double b = (FRandom(-20, 20) + FRandom(-20, 20));
	
		A_SpawnParticleEx(
			"00AA00",
			TexMan.CheckForTexture ("BFE1E0"),
			style: STYLE_Add,
			flags: SPF_FULLBRIGHT,
			lifetime: 105,
			size: 2.0,
			angle: n,
			xoff: cos(a) * cos(b) * 20,
			yoff: sin(a) * cos(b) * 20,
			zoff: 26,
			startalphaf: 1.0,
			fadestepf: -0.03,
			sizestep: -0.05,
			startroll: 0
		);
			
		n = n + 4;
		
		BlockThingsIterator it = BlockThingsIterator.Create(self, 256);
		
		while(it.Next())
		{
			let obj = it.thing;
			if(obj && obj is "PB_Monster" && obj.bISMONSTER && Distance3D(obj) <= 256 && !obj.bCORPSE)
			{
				obj.A_SpawnParticleEx(
                    "00AA00",
                    TexMan.CheckForTexture ("BFE1E0"),
                    style: STYLE_Add,
                    flags: SPF_FULLBRIGHT,
                    lifetime: 105,
                    size: 3.0,
                    angle: n,
                    xoff: cos(a) * cos(FRandom(-obj.radius, obj.radius) + FRandom(-obj.radius, obj.radius)) * obj.radius,
                    yoff: sin(a) * cos(FRandom(-obj.radius, obj.radius) + FRandom(-obj.radius, obj.radius)) * obj.radius,
                    zoff: obj.height / 2,
                    startalphaf: 1.0,
                    fadestepf: -0.03,
                    sizestep: -0.05,
                    startroll: 0
				);
			}
		}
	}

	States
	{
        Spawn:
            TINV ABCD 6 Bright InvCheck();
		    Loop;
	}
}
class PBXItems_InvulTaintedGiver : PBX_InvulTaintedGiver 
{Default{Powerup.Color "GoldMap";}}


// ============================================================
// PBX Powerups - Based on Vanilla Doom's Powerups
// ============================================================

// --- Legend Sphere ---
class PBX_LegendSphere : PB_Inventory
{
	Default
	{
		Inventory.PickupMessage "$LEGENDSPHERE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
		Scale .73;
	}

	override bool Use(bool pickup)
	{
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
		Inventory.PickupMessage "$LFSTEALORB_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
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

// --- PowerFlight ---
// class PBX_BuddhaSphere : PB_Inventory
// {
// 	Default
// 	{
// 		Inventory.PickupMessage "Legend Sphere";
// 		Inventory.PickupSound "MEGASPH";
// 		+FLOATBOB
// 		floatbobstrength .4;
// 		Scale .73;
// 	}

// 	override bool Use(bool pickup)
// 	{
// 		owner.A_SetBlend("DarkOrange",0.75,16);
// 		owner.A_GiveInventory("PBXItems_BuddhaGiver");
// 		return true;
// 	}

// 	States
// 	{
// 	Spawn:
// 		LESP ABCD 6 bright;
// 		loop;
// 	}
// }

// --- Terror Sphere ---
class PBX_TerrorSphere : PB_Inventory
{
	Default
	{
		Inventory.PickupMessage "$TERRORSPHERE_PICKUP";
		Inventory.PickupSound "BERSPKUP";
		+FLOATBOB
		floatbobstrength .4;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("DarkRed",0.75,16);
		owner.A_GiveInventory("PBXItems_FrightenerGiver");
		if(pb_newmugshot) owner.A_SetMugshotState("BerserkGrin");
		return true;
	}

	States
	{
		Spawn:
			TERR ABCDE 6 bright;
			loop;
	}
}
class PBXItems_FrightenerGiver : PBX_FrightenerGiver 
{Default{Powerup.Color "GoldMap"; Powerup.Duration TERROR_DURATION;}}

// --- PowerHighJump ---
// class PBX_BuddhaSphere : PB_Inventory
// {
// 	Default
// 	{
// 		Inventory.PickupMessage "Legend Sphere";
// 		Inventory.PickupSound "MEGASPH";
// 		+FLOATBOB
// 		floatbobstrength .4;
// 		Scale .73;
// 	}

// 	override bool Use(bool pickup)
// 	{
// 		owner.A_SetBlend("DarkOrange",0.75,16);
// 		owner.A_GiveInventory("PBXItems_BuddhaGiver");
// 		return true;
// 	}

// 	States
// 	{
// 	Spawn:
// 		LESP ABCD 6 bright;
// 		loop;
// 	}
// }

// --- Ammo Sphere ---
class PBX_AmmoSphere : PB_Inventory
{
	Default
	{
		Inventory.PickupMessage "$AMMOSPHERE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
	}

	override bool Use(bool pickup)
	{
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
{Default{Powerup.Color "255 0 0", 0.4; Powerup.Duration INFAMMO_DURATION;}}

// --- Guard Sphere  ---
class PBX_GuardSphere : PB_Inventory
{
	Default
	{
		Inventory.PickupMessage "$GUARDSPHERE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
	}

	override bool Use(bool pickup)
	{
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

// --- PowerReflection ---
// class PBX_BuddhaSphere : PB_Inventory
// {
// 	Default
// 	{
// 		Inventory.PickupMessage "Legend Sphere";
// 		Inventory.PickupSound "MEGASPH";
// 		+FLOATBOB
// 		floatbobstrength .4;
// 		Scale .73;
// 	}

// 	override bool Use(bool pickup)
// 	{
// 		owner.A_SetBlend("DarkOrange",0.75,16);
// 		owner.A_GiveInventory("PBXItems_BuddhaGiver");
// 		return true;
// 	}

// 	States
// 	{
// 	Spawn:
// 		LESP ABCD 6 bright;
// 		loop;
// 	}
// }

// --- PowerRegeneration ---
class PBX_RegenSphere : PB_Inventory
{
	Default
	{
		Inventory.PickupMessage "$REGENSPHERE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("DarkOrchid1",0.75,16);
		owner.A_GiveInventory("PBX_ReflectionGiver");
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
		Inventory.PickupMessage "$TIMEFREEZE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		floatbobstrength .4;
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
{Default{Powerup.Color "Goldmap"; Powerup.Duration TMFREEZE_DURATION;}}


// --- Red Soulsphere ---
class PBX_RedSoulSphere : PB_Inventory
{
	Default
	{
		Inventory.PickupMessage "$REDSOUL_PICKUP";
		Inventory.PickupSound "SSPH";
		+FLOATBOB
		floatbobstrength .4;
	}

	int damageTimer;
    int corpseTimer;

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("Red",0.75,16);
		owner.GiveBody(150,200);
		return true;
	}

    override void Tick()
    {
		super.Tick();

		if(level.isFrozen()) return;

		damageTimer++;
        corpseTimer++;

        if(GetAge() % Random(17, 28) == 0)
            SpawnParticle();

        if(damageTimer >= 35)
        {
            damageTimer = 0;
            DamageNearbyPlayers();
        }

        if(corpseTimer >= 175)
        {
            corpseTimer = 0;
            SpawnSoulsFromCorpses();
        }
		
    }

	void SpawnParticle()
	{
		A_SpawnParticleEx(
            "FF0000",
            TexMan.CheckForTexture("DROPA0"),
            style: STYLE_Add,
            flags: SPF_FULLBRIGHT|SPF_RELATIVE,
            lifetime: 15,
            size: 2.0,
            angle: 0,
            xoff: FRandom(-3, 3),
            yoff: FRandom(-3, 3),
            zoff: 15,
            velz: -0.01,
            accelz: -0.4,
            startalphaf: 1.0,
            fadestepf: -0.2,
            sizestep: 0,
            startroll: 0
        );
	}

	void DamageNearbyPlayers()
    {
        BlockThingsIterator it = BlockThingsIterator.Create(self, 256);
        while(it.Next())
        {
            let obj = it.thing;
            if(obj.player && obj.health > 0 && Distance3D(obj) <= 256)
                obj.DamageMobj(self, self, 1, "");
        }
    }

	void SpawnSoulsFromCorpses()
    {
        BlockThingsIterator it = BlockThingsIterator.Create(self, 256);
        while(it.Next())
        {
            let obj = it.thing;
            if((obj is "PB_CurbstompedMarine")
                && obj.bISMONSTER
                && obj.health <= 0
                && obj.GetClassName() != "PB_LostSoul"
                && obj.GetClassName() != "PB_PainElemental"
                && Distance3D(obj) <= 256
                && !obj.CheckInventory("CorpseDrained", 1))
            {
                obj.Spawn("PB_LostSoul", obj.Vec3Offset(0, 0, 20), NO_REPLACE);
                obj.Spawn("TeleportFog", obj.Vec3Offset(0, 0, 20), NO_REPLACE);
                obj.GiveInventory("CorpseDrained", 1);
                obj.A_SetRenderStyle(0.4, STYLE_Translucent);
            }
        }
	}

	States
	{
		Spawn:
			TSOU ABCDCB 6 bright;
			loop;
	}
}
Class CorpseDrained : Inventory
{Default{Inventory.MaxAmount 1;+INVENTORY.UNDROPPABLE;}}

// --- Dark Megasphere ---
class PBX_DarkMegaSphere : PB_Inventory
{
	Default
	{
		Inventory.PickupMessage "$DARKMEGA_PICKUP";
		Inventory.PickupSound "MEGASPH";
	    +VISIBILITYPULSE;
		+FLOATBOB
		floatbobstrength .4;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("DarkOrange",0.75,16);
		owner.A_GiveInventory("PBX_SuperArmor");
		owner.A_GiveInventory("PBX_TaintedRegenGiver");
		return true;
	}

    override void Tick()
	{
		super.Tick();
		
		double a = FRandom(1, 360);
		double b = (FRandom(-20, 20) + FRandom(-20, 20));
		
		A_SpawnParticleEx(
			"BB0055",
			TexMan.CheckForTexture ("STARA0"),
			style: STYLE_Add,
			flags: SPF_FULLBRIGHT,
			lifetime: 35,
			size: 3.0,
			angle: a,
			xoff: cos(a) * cos(b) * 20,
			yoff: sin(a) * cos(b) * 20,
			zoff: sin(b) * 20 + 26,
			velx: cos(a) * cos(b) * 0.2,
			vely: sin(a) * cos(b) * 0.2,
			velz: sin(b) * 0.2,
			startalphaf: 1.0,
			fadestepf: -0.1,
			sizestep: -0.1,
			startroll: 0
		);
		
		BlockThingsIterator it = BlockThingsIterator.Create(self, 256);
		
		while(it.Next())
		{
			let obj = it.thing;
			if(obj && obj is "PB_Monster" && obj.bISMONSTER && Distance3D(obj) <= 256 && !obj.bCORPSE && obj.health < obj.SpawnHealth())
			{
				obj.A_SpawnParticleEx(
					"BB0055",
					TexMan.CheckForTexture ("STARA0"),
					style: STYLE_Add,
					flags: SPF_FULLBRIGHT|SPF_RELATIVE|SPF_ROLL,
					lifetime: 50,
					size: 0.5,
					angle: 0,
					xoff: FRandom (obj.radius,-obj.radius),
					yoff: FRandom (obj.radius,-obj.radius),
					zoff: 0,
					velx: FRandom (0.5,-0.5),
					vely: FRandom (0.5,-0.5),
					velz: FRandom (0.4,3.0),
					accelz: -0.001,
					startalphaf: 1.25,
					fadestepf: -0.002,
					sizestep: 0.15,
					startroll: 180/2,
					rollvel: 0,
					rollacc: 0
				);
				obj.health++;
			}
		}
	}

	States
	{
		Spawn:
			TMEG ABCDCB 6 bright;
			loop;
	}
}


// --- Adrenaline ---
class PBX_Adrenaline : PB_Inventory
{
	Default
	{
		Inventory.PickupMessage "$ADRENAL_PICKUP";
		Inventory.PickupSound "misc/p_pkup";
	}

	override bool Use(bool pickup)
	{
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