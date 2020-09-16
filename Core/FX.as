namespace GearFX
{
	void CritEffect(CBasePlayer@ pPlayer, Vector&in origin)
	{
		g_SoundSystem.EmitSoundDyn(pPlayer.edict(), CHAN_ITEM, "misc/crit.wav", 0.7f, ATTN_NORM, 0, PITCH_NORM);
		
		NetworkMessage critfx( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY );
			critfx.WriteByte( TE_EXPLOSION );
			critfx.WriteCoord( origin.x );
			critfx.WriteCoord( origin.y );
			critfx.WriteCoord( origin.z );
			critfx.WriteShort( g_EngineFuncs.ModelIndex("sprites/fun/ft_minicrit2.spr") );
			critfx.WriteByte( 4 ); //scale
			critfx.WriteByte( 2 ); //framerate
			critfx.WriteByte( TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES );
		critfx.End();
	}

	void HeadEffect(CBasePlayer@ pPlayer)
	{
		g_SoundSystem.EmitSoundDyn(pPlayer.edict(), CHAN_ITEM, "misc/head1.wav", 0.7f, ATTN_NORM, 0, PITCH_NORM);
	}
}