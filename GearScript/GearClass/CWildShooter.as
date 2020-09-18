//由于As的限制
//每个继承类必须自己写上Copy方法
class CWildShooter : CBaseGear, IBaseGear
{
    CWildShooter()
    {
        szName = "WildShooter";
        szSlot = "Gooles"; //?sure?
        dicCustomVal = {
            {"iCD", 5}
        }
    }

    CBaseGear@ Copy()
    {
        return CWildShooter();
    }

    HookReturnCode WeaponPrimaryAttack override ( CBasePlayer@ pPlayer, CBasePlayerWeapon@ pWeapon )
    {
        if(PlayerData::GetInt(pPlayer, g_CustomCD) - g_Engine.time > this.GetKeyInt("iCD"))
            pWeapon.m_flNextPrimaryAttack = g_Engine.time + 0.1f; //?
        return HOOK_CONTINUE; 
    }
    HookReturnCode WeaponSecondaryAttack( CBasePlayer@ pPlayer, CBasePlayerWeapon@ pWeapon )
    {
        pWeapon.m_flNextSecondaryAttack = g_Engine.time + 0.1f;
        return HOOK_CONTINUE;
    }
    HookReturnCode WeaponTertiaryAttack( CBasePlayer@ pPlayer, CBasePlayerWeapon@ pWeapon )
    {
        pWeapon.m_flNextTertiaryAttack = g_Engine.time + 0.1f;
        return HOOK_CONTINUE;
    }
}