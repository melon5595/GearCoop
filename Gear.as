const string g_CustomCritDamage = "$i_critdamage";
const string g_CustomCritChance = "$i_critchance";
const string g_CustomHeadDamage = "$i_headdamage";
const string g_CustomCritCount = "$i_critcount";
const string g_CustomHeadCount = "$i_headcount";
const string g_CustomCD = "$i_cooldown";

const string dirGearFile = "scripts/plugins/Gear/Gear.txt"; //temporary yet

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor("aaaa");
	g_Module.ScriptInfo.SetContactInfo("ahhh");
}

void MapInit()
{
	Precache();
}

void Precache() 
{
	g_SoundSystem.PrecacheSound("misc/crit.wav");
	g_SoundSystem.PrecacheSound("misc/head1.wav");
}