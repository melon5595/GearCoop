namespace GearHandler
{
	void CoreAttributes(CBasePlayer@ pPlayer, float fHealth, float fArmor, float fGravity, float fMaxspeed)
	{
		pPlayer.pev.health = pPlayer.pev.max_health = fHealth;
		pPlayer.pev.armorvalue = pPlayer.pev.armortype = fArmor;
		pPlayer.pev.gravity = fGravity;
		pPlayer.pev.maxspeed = fMaxspeed;
	}

	void AdditionalAttributes(CBasePlayer@ pPlayer, int iCritDamage, int iCritChance, int iHeadDamage)
	{
		g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCritDamage, iCritDamage);
		g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomCritChance, iCritChance);
		g_EntityFuncs.DispatchKeyValue(pPlayer.edict(), g_CustomHeadDamage, iHeadDamage);
	}
	
	void TalentAttributes(CBasePlayer@ pPlayer)
	{

	}
}