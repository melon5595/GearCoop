CTextMenu@ SlotMenu = CTextMenu(SlotMenuCallback);
CTextMenu@ InventoryMenu = CTextMenu(InventoryMenuCallback);

CTextMenu@ HelmetMenu = CTextMenu(HelmetMenuCallback);
CTextMenu@ ArmorMenu = CTextMenu(ArmorMenuCallback);
CTextMenu@ BackpackMenu = CTextMenu(BackpackMenuCallback);
CTextMenu@ GloveMenu = CTextMenu(GloveMenuCallback);
CTextMenu@ HolsterMenu = CTextMenu(HolsterMenuCallback);

void Init()
{
    for(int i = 0; i <= int(GearType::GearSlotType.length() - 1); i++)
		SlotMenu.AddItem(GearType::GearSlotType[i], null);
	
	SlotMenu.SetTitle("[Gear]\nChange your gear below:");
	SlotMenu.Register();
}

void SlotMenuCallback(CTextMenu@ mMenu, CBasePlayer@ pPlayer, int iPage, const CTextMenuItem@ mItem)
{
	if(mItem !is null && pPlayer !is null)
	{
		if(mItem.m_szName == GearType::GearSlotType[0])
		{
			HelmetMenu.Open(0, 0, pPlayer);
		}
		if(mItem.m_szName == GearType::GearSlotType[1])
		{
			ArmorMenu.Open(0, 0, pPlayer);
		}
		if(mItem.m_szName == GearType::GearSlotType[2])
		{
			BackpackMenu.Open(0, 0, pPlayer);
		}
		if(mItem.m_szName == GearType::GearSlotType[3])
		{
			GloveMenu.Open(0, 0, pPlayer);
		}
		if(mItem.m_szName == GearType::GearSlotType[04])
		{
			HolsterMenu.Open(0, 0, pPlayer);
		}
	}
}
