namespace GearCommands
{
    CClientCommand g_GiveGear("givegear", "Give gears with specific value to a player (ADMIN)", @GiveGear);

    void GiveGear(const CCommand@ args)
    {
        CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();
        CBaseEntity@ pEntity = null;
        if(g_PlayerFuncs.AdminLevel(pPlayer) >= ADMIN_YES) 
        {
            if(args.ArgC() >= 1) 
            {
                do {
                    @pEntity = g_EntityFuncs.FindEntityByClassname(args.ArgC(1).ToLowercase(), "player");
                    if(pEntity !is null)
                    {
                        CBasePlayer@ pTarget  = cast<CBasePlayer@>(pEntity);
                        string pTargetName = string(pTarget.pev.netname).ToLowercase();
                        string pTargetID = getPlayerUniqueId(pTarget).ToLowercase();

                        if(pTargetName == args.ArgC(1).ToLowercase())
                        {
                            AddtoInventory();
                            g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "[Gear] Gave" + pTarget.pev.netname + args.Arg(1) + "\n");
                        }
                        
                    }

                } while(pEntity !is null);

                if(pEntity is null)
                {
                    g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "[Gear] No or invalid player name/ID given.\n");
                }
            }
            else 
            {
                g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "[Gear] No or invalid value given.\n");
            }
        }
        else
        {
            g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "[Gear] You have no access to this command.\n");
        }
    }
}
