/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Creator : SeriousHD-
*	 Project : Arena
*    Mode : Zombies
*	 Date : 2016/01/25 - 07:16:00	
*	 If you use this gamemode or edit, please give credit to SeriousHD-. Thank you.
*/	

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init()
{
	setDvar("party_connectToOthers" , "0");
	setDvar("partyMigrate_disabled" , "1");
	setDvar("party_mergingEnabled" , "0");
	level.player_too_many_players_check = 0;
	level.player_too_many_players_check_func = ::player_too_many_players_check;
	_zm_arena_initialize_level_variables(); //This MUST occur before anything else.
    level thread onPlayerConnect();
    level thread _zm_arena_InitializeGamemode();
}
player_too_many_players_check()
{


}
onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
	level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
        
		if(level._arena_initialized)
		{
		self thread _zm_arena_player_init();
		level thread _zm_arena_player_spawned_penalty();
		}
    }
}

