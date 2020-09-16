abstract class CBaseGear
{
    //用于标记分类
    protected string szName;
    protected string szSlot;
    /*用于保存基础类型的自定义数值
    * Key规定
    * iXX 整数型
    * flXX 浮点型
    * szXX 字符串型
    * vecXX 三维坐标
    * vec2XX 二维坐标
    * bXX 布尔值
    */
    protected dictionary dicCustomVal;

    int GetKeyInt(string key)
    {
        return int(dicCustomVal[key]);
    }
    
    //用于继承覆盖
    HookReturnCode PlayerSpawn( CBasePlayer@ pPlayer ){ return HOOK_CONTINUE; }
    HookReturnCode PlayerKilled( CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib ){ return HOOK_CONTINUE; }
    HookReturnCode PlayerUse( CBasePlayer@ pPlayer, uint& out uiFlags ){ return HOOK_CONTINUE; }
    HookReturnCode PlayerPreThink( CBasePlayer@ pPlayer, uint& out uiFlags ){ return HOOK_CONTINUE; }
    HookReturnCode PlayerPostThink( CBasePlayer@ pPlayer ){ return HOOK_CONTINUE; }
    HookReturnCode PlayerTakeDamage( DamageInfo@ pDamageInfo ){ return HOOK_CONTINUE; }
    HookReturnCode WeaponPrimaryAttack( CBasePlayer@ pPlayer, CBasePlayerWeapon@ pWeapon ){ return HOOK_CONTINUE; }
    HookReturnCode WeaponSecondaryAttack( CBasePlayer@ pPlayer, CBasePlayerWeapon@ pWeapon ){ return HOOK_CONTINUE; }
    HookReturnCode WeaponTertiaryAttack( CBasePlayer@ pPlayer, CBasePlayerWeapon@ pWeapon ){ return HOOK_CONTINUE; }
}