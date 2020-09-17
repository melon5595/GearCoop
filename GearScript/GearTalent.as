namespace GearTalent
{
	//天赋：狂野射手
	//效果：累计造成三次暴击，给予两秒的射速加成（攻击速度 == 0.1）
	//槽位：手套 Glove
	void WildShooter(CBasePlayer@ pPlayer)
	{	
		CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
		if(pCustom.GetKeyvalue(g_CustomCritCount).GetInteger() == 3)
		{
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCD, 10);
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCritCount, 0);

			g_Scheduler.SetInterval("NextAttackThink", 0.2, 10, @pPlayer, 0.1f, 0.1f, 0.1f);
		}
	}
	
	//天赋：猛击者
	//效果：每失去10点护甲，增加1点暴击伤害，暴击时可恢复5点血量
	//槽位：护甲 Armor
	void Striker(CBasePlayer@ pPlayer)
	{
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
		
		if(pPlayer.pev.armorvalue == pPlayer.pev.armortype)
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCritDamage, 0);
		
		g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCritDamage, int((pPlayer.pev.armorvalue - pPlayer.pev.armortype) * -0.1f));
	}
	
	//天赋：致命子弹
	//效果：每减少一发弹夹内的子弹，增加5点爆头和暴击伤害，最多叠加10次（可能要限制枪械种类？）
	//槽位：手套 Glove
	void DeadlyBullet(CBasePlayer@ pPlayer)
	{
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
			
		int i = activeItem.iMaxClip() - activeItem.m_iClip;
		if(i > 10)
			i = 10； // dumb way, gotta fix
		
		g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomHeadDamage, int(i * -5.0f));
		g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCritDamage, int(i * -5.0f));
	}

	//天赋：沉着冷静
	//效果：更换弹夹后给予五秒的零后坐力（punchangle.x == punchangle.y == 0）
	//槽位：背包 Backpack
	void CoolnCalm(CBasePlayer@ pPlayer)
	{
		CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
		if(IsReloaded) //找不到办法检测？
		{
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCD, 50);
			g_Scheduler.SetInterval("PunchangleThink", 0.1, 50, @pPlayer, 0, 0);
		}		
	}
	
	//天赋：无尽射击
	//效果：在射击时按住扳机可立即装填弹夹，但会增加后坐力
	//槽位：背包 Backpack
	void NonStopShooting(CBasePlayer@ pPlayer)
	{		
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		if(pPlayer.m_rgAmmo(activeItem.m_iPrimaryAmmoType) >= activeItem.iMaxClip())
		{
			pPlayer.m_rgAmmo(activeItem.m_iPrimaryAmmoType, pPlayer.m_rgAmmo(activeItem.m_iPrimaryAmmoType) - activeItem.iMaxClip());
			activeItem.m_iClip = activeItem.iMaxClip();

			g_Scheduler.SetInterval("PunchangleThink", 0.1, @pPlayer, Math.RandomLong(-5,5), Math.RandomLong(-5,1));
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

void NextAttackThink(CBasePlayer@ pPlayer, float flPrimary = 0.1f, float flSecondary = 0.1f, float flTertiary = 0.1f) 
{
	CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
	if(pPlayer !is null && pPlayer.IsConnected()) 
	{
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		activeItem.m_flNextPrimaryAttack = flPrimary;
		activeItem.m_flNextSecondaryAttack = flSecondary;
		activeItem.m_flNextTertiaryttack = flTertiary;
		
		if(pCustom.GetKeyvalue(g_CustomCD).GetInteger() > 0)
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCD, pCustom.GetKeyvalue(g_CustomCD).GetInteger() - 1);
	}
}

void PunchangleThink(CBasePlayer@ pPlayer, int Punchx, int Punchy) 
{
	CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
	if(pPlayer !is null && pPlayer.IsConnected()) 
	{
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		pPlayer.pev.punchangle.x = Punchx;
		pPlayer.pev.punchangle.y = Punchy;
		
		if(pCustom.GetKeyvalue(g_CustomCD).GetInteger() > 0)
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCD, pCustom.GetKeyvalue(g_CustomCD).GetInteger() - 1);
	}
}


void Ammothink(CBasePlayer@ pPlayer)
{
	CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
	if(pPlayer !is null && pPlayer.IsConnected() && pCustom.GetKeyvalue(g_CustomPlayerRole).GetInteger() == Shotgunner) 
	{
		CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
		
		if(pCustom.GetKeyvalue(g_CustomCD).GetInteger() > 0)
			g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCD, pCustom.GetKeyvalue(g_CustomCD).GetInteger() - 1);
	}
}

