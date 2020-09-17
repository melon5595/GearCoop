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
		
	}
}
