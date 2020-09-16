//用于存储Gear标准数据
namespace GearBank
{
    dictionary dicGears = {};
    bool AddGear(CBaseGear@ pGear)
    {
        if(@pGear is null)
            return false;
        if(dicGears.exists(pGear.szSlot))
        {
            dictionary@ dicTemp = cast<dictionary@>(dicGears[pGear.szSlot]);
            if(!dicTemp.exists(pGear.szName))
                dicTemp.set(pGear.szName, @pGear)
            else
            {
                g_Log.PrintF("已存在该装备%1-%2, 将不会添加", pGear.szSlot, pGear.szName);
                return false;
            }
        }
        else
        {
            dictionary dicTemp = { {pGear.szName, @pGear} };
            dicGears.set(pGear.szSlot, @dicTemp);
        }
        return true
    }

    CBaseGear@ GetGear(string szSlot, string szName)
    {
        if(dicGears.exists(szSlot))
        {
            dictionary@ dicTemp = cast<dictionary@>(dicGears[szSlot]);
            if(dicTemp.exists(szName))
                return cast<CBaseGear@>(dicTemp[szName]);
        }
        return null;
    }
}