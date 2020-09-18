//保存玩家自定义Keyvalue和方便获取玩家自定义Keyvalue
//玩家的可用的装备栏
class CPlayerData
{
    //保存装备的引用CBaseGear
    //不可添加或减少栏位
    const dictionary Slot = {
        {"HeadSet", null},
        {"Belt", null}
    };
    //库存的装备
    array<CBaseGear@>@ Inventory;
}
namespace PlayerData
{
    dictionary PlayerData;
    CPlayerData@ GetPlayerData(string szSteamID)
    {
        if(PlayerData.exists(szSteamID))
            return cast<CPlayerData@>(PlayerData[szSteamID]);
        return null;
    }
    CPlayerData@ AddPlayerData(string szSteamID)
    {
        PlayerData.set(szSteamID, CPlayerData());
        return cast<CPlayerData@>(PlayerData[szSteamID]);
    }
    int GetInt(string szSteamID, string key)
    {

    }
    int GetInt(CBasePlayer@ pPlayer, string key)
    {

    }
    string GetString(string szSteamID, string key)
    {

    }
    string GetString(CBasePlayer@ pPlayer, string key)
    {

    }
}