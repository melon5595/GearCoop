namespace GearUtility
{
	bool IsHead(CBasePlayer@ pPlayer, Vector&in vecSrc, Vector&in vecAim, Vector&in vecSpread, float&in flDistance)
	{
		/**
			@pPlayer 射线属主
			@VecSrc 射线起点
			@VecSrc 射线发射方向
			@vecSpread 射线随机扩散度
			@flDistance 射线长度
		**/
		
		//作射线
		TraceResult tr;
		float x, y;
		
		g_Utility.GetCircularGaussianSpread( x, y );
		//获取射线重点坐标
		Vector vecDir = vecAim + x * vecSpread.x * g_Engine.v_right + y * vecSpread.y * g_Engine.v_up;
		Vector vecEnd = vecSrc + vecDir * flDistance;
		//正常完成射线计算
		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, pPlayer.edict(), tr );
		//如果射线确实已发射 flFraction >= 1.0
		if ( tr.flFraction >= 1.0 )
		{
			//做hullshape射线计算
			g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, pPlayer.edict(), tr );
		}
		
		//返回是否击中头部
		return tr.iHitgroup == HITGROUP_HEAD;
		
		/** HITGROUP_GENERIC 击中整体部位
			HITGROUP_HEAD 头部
			HITGROUP_CHEST 胸部
			HITGROUP_STOMACH 腹部
			HITGROUP_LEFTARM 左手
			HITGROUP_RIGHTARM 右手
			HITGROUP_LEFTLEG 左腿
			HITGROUP_RIGHTLEG 右腿
		**/		
	}

	bool IsDead(CBasePlayer@ pPlayer, CBaseEntity@ pHit, Vector&in vecSrc, Vector&in vecEnd, float&in flDistance)
	{
		TraceResult tr;
		
		vecSrc = pPlayer.GetGunPosition();
		vecEnd = vecSrc + g_Engine.v_forward * flDistance;

		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, pPlayer.edict(), tr );
		
		if(tr.flFraction < 1.0)
		{
			@pHit = g_EntityFuncs.Instance( tr.pHit );
			if ( pHit is null || pHit.IsBSPModel() )
				g_Utility.FindHullIntersection( vecSrc, tr, tr, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX, pPlayer.edict() );
			vecEnd = tr.vecEndPos;
		}
		if(tr.flFraction >= 1.0)
		{
			g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, pPlayer.edict(), tr );
		}
		
		if(pHit is null || pHit.IsBSPModel() == true && pHit.GetClassname() == "monster_furniture")
		{
			return false;
		}
		
		return !pHit.IsAlive();
	}

	bool IsCrit(CBasePlayer@ pPlayer, CBaseEntity@ pHit, Vector&in vecSrc, Vector&in vecEnd, float&in flDistance)
	{
		TraceResult tr;
		
		vecSrc = pPlayer.GetGunPosition();
		vecEnd = vecSrc + g_Engine.v_forward * flDistance;

		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, pPlayer.edict(), tr );
		
		if(tr.flFraction < 1.0)
		{
			@pHit = g_EntityFuncs.Instance( tr.pHit );
			if ( pHit is null || pHit.IsBSPModel() )
				g_Utility.FindHullIntersection( vecSrc, tr, tr, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX, pPlayer.edict() );
			vecEnd = tr.vecEndPos;
		}
		if(tr.flFraction >= 1.0)
		{
			g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, pPlayer.edict(), tr );
		}
		
		if(pHit is null || pHit.IsBSPModel() == true && pHit.GetClassname() == "monster_furniture")
		{
			return false;
		}
		
		int i = g_PlayerFuncs.SharedRandomLong pPlayer.random_seed, 0, 100 );
		int TempBasicCritChance = 20;
		int TempBasicCritDamage = 10;
		if(i < TempCritChance)
		{	
			pHit.TakeDamage(pHit.pev, pPlayer.pev, TempBasicCritDamage + pCustom.GetKeyvalue(g_CustomCritDamage).GetInteger(), DMG_GENERIC);

			g_SoundSystem.EmitSoundDyn(pPlayer.edict(), CHAN_ITEM, "misc/crit.wav", 0.7f, ATTN_NORM, 0, PITCH_NORM);
			GearFX::CritEffect(pPlayer, pHit.pev.origin + g_Engine.v_up * 72)
		}
		
		return !pHit.IsAlive();
	}
}