namespace GearTalent
{
	void WildShooter(CBasePlayer@ pPlayer)
	{	
		CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
		string szSteamId = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());
		int i = int(g_PlayerRole[szSteamId]);
		if(pCustom.GetKeyvalue(g_CustomCritCount).GetInteger() == 3)
		{
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCD, 5);
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCritCount, 0);

			//g_Scheduler.RemoveTimer(g_pWildShooterThinkFunc);
			@g_pWildShooterThinkFunc = g_Scheduler.SetInterval("WildShooterthink", 0.2, 5, @pPlayer);
		}
	}
	
	void Bloodthirster(CBasePlayer@ pPlayer)
	{
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
		
		if(pPlayer.pev.armortype == pPlayer.pev.armortype)
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCritDamage, 0);
		
		if(shortdistanceweaponlist.find(activeItem.GetClassname()) < 0 && pPlayer.pev.armorvalue < pPlayer.pev.armortype)
		{	
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCritDamage, int((pPlayer.pev.armorvalue - pPlayer.pev.armortype) * -0.1f));
		}
	}
	
	void DeadlyBullet(CBasePlayer@ pPlayer)
	{
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
				
		if(shortdistanceweaponlist.find(activeItem.GetClassname()) < 0)
		{	
			if(activeItem.iMaxClip() - activeItem.m_iClip <= 10) // dumb way, gotta fix
			{
				g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomHeadDamage, int((activeItem.m_iClip - activeItem.iMaxClip()) * -5.0f));
				g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCritDamage, int((activeItem.m_iClip - activeItem.iMaxClip()) * -5.0f));
			}
		}
	}
	
	void NonStopShooting(CBasePlayer@ pPlayer)
	{		
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		if(shortdistanceweaponlist.find(activeItem.GetClassname()) < 0 && pPlayer.m_rgAmmo(activeItem.m_iPrimaryAmmoType) >= activeItem.iMaxClip())
		{
			pPlayer.m_rgAmmo(activeItem.m_iPrimaryAmmoType, pPlayer.m_rgAmmo(activeItem.m_iPrimaryAmmoType) - activeItem.iMaxClip());
			activeItem.m_iClip = activeItem.iMaxClip();
		}
		activeItem.m_bFireOnEmpty = false;
	}	
	
	void WickedRunner(CBasePlayer@ pPlayer)
	{	
		//g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTNOTIFY, pPlayer.pev.maxspeed);
		if(pPlayer.IsMoving() && pPlayer.pev.health < pPlayer.pev.max_health)
		{
			float speedh = sqrt( pow( pPlayer.pev.velocity.x, 2.0 ) + pow( pPlayer.pev.velocity.y, 2.0 ) );
			
			pPlayer.pev.health += 0.1f * (speedh / 200);
		}
		g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCritDamage, int((pPlayer.pev.health - pPlayer.pev.max_health) * -0.2f));
	}
	
	void BladeDance(CBasePlayer@ pPlayer)
	{		
		CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();	

		if(pPlayer.pev.flags & FL_DUCKING != 0 && pPlayer.pev.button & IN_USE != 0 && pCustom.GetKeyvalue(g_CustomCD).GetInteger() == 0)
		{
			NullServerBeamTorus(pPlayer.pev.origin + g_Engine.v_up * 16, 128, "sprites/fun/laserbeam.spr", 0, 16, 8, 8, 0, 255, 0, 0, 155, 0);
			
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCD, 50);
			
			g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_ITEM, "misc/skill.wav", 0.95f, ATTN_NORM, 0, PITCH_NORM);
			
			//g_Scheduler.RemoveTimer(g_pBladeDanceThinkFunc);
			@g_pBladeDanceThinkFunc = g_Scheduler.SetInterval("BladeDancethink", 0.2, 50, @pPlayer);
		}
	}

	void ShotgunSlaughter(CBasePlayer@ pPlayer)
	{		
		
	}
}

void WildShooterthink(CBasePlayer@ pPlayer) 
{
	CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
	if(pPlayer !is null && pPlayer.IsConnected() && pCustom.GetKeyvalue(g_CustomPlayerRole).GetInteger() == Desperado) 
	{
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		activeItem.m_flNextPrimaryAttack = 0.1f;
		activeItem.m_flNextSecondaryAttack = 0.1f;
		
		if(pCustom.GetKeyvalue(g_CustomCD).GetInteger() > 0)
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCD, pCustom.GetKeyvalue(g_CustomCD).GetInteger() - 1);
	}
}

void BladeDancethink(CBasePlayer@ pPlayer) 
{
	CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
	if(pPlayer !is null && pPlayer.IsConnected() && pCustom.GetKeyvalue(g_CustomPlayerRole).GetInteger() == Berserker) 
	{
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		activeItem.m_flNextPrimaryAttack = 0.1f;
		
		//g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTNOTIFY, pCustom.GetKeyvalue(g_CustomCD).GetInteger());
		
		if(pCustom.GetKeyvalue(g_CustomCD).GetInteger() > 0)
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCD, pCustom.GetKeyvalue(g_CustomCD).GetInteger() - 1);
	}
}

void ShotgunSlaughterthink(CBasePlayer@ pPlayer)
{
	CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
	if(pPlayer !is null && pPlayer.IsConnected() && pCustom.GetKeyvalue(g_CustomPlayerRole).GetInteger() == Shotgunner) 
	{
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		activeItem.m_flNextPrimaryAttack = 0.1f;
		activeItem.m_flNextSecondaryAttack = 0.1f;
		
		if(pCustom.GetKeyvalue(g_CustomCD).GetInteger() > 0)
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCD, pCustom.GetKeyvalue(g_CustomCD).GetInteger() - 1);
	}
}

void NonStopthink(CBasePlayer@ pPlayer)
{
	CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
	if(pPlayer !is null && pPlayer.IsConnected() && pCustom.GetKeyvalue(g_CustomPlayerRole).GetInteger() == LoneStar) 
	{
		pPlayer.pev.punchangle.x = 0;
		pPlayer.pev.punchangle.y = 0;
		
		if(pCustom.GetKeyvalue(g_CustomCD).GetInteger() > 0)
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCD, pCustom.GetKeyvalue(g_CustomCD).GetInteger() - 1);
	}
}