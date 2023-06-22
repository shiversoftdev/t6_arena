_zm_arena_reward_system() //Reward an item on round end
{
	level endon("game_ended");
	
	for(;;)
	{
		level waittill("between_round_over");
		level thread _zm_arena_give_reward();
		level._arena_distancefrommax *= .95;
		if(level._arena_distancefrommax < 600) level._arena_distancefrommax = 600;
	}
}

_zm_arena_give_reward()
{
	/* Reward a random item or perk by generating an int
	 * and checking the index of the int.
	 * All functions are called by the level.
	*/
	rewards = [];
	chance = [];
	frewards = [];
	
	rewards[0] = "Pack a Punch";
	chance[0] = 7; //7% chance
	frewards[0] = ::_zm_arena_pap_all;

	rewards[1] = "Ammo Refill";
	chance[1] = 57; //50% chance
	frewards[1] = ::_zm_arena_fill_ammo;
	
	rewards[2] = "Random Perk";
	chance[2] = 75; //18% chance
	frewards[2] = ::_zm_arena_random_perk;
	
	rewards[3] = "Random Weapon";
	chance[3] = 80; // 15% chance
	frewards[3] = ::_zm_arena_random_weapon;
	
	rewards[4] = "Random Item";
	chance[4] = 100; //20% chance
	frewards[4] = ::_zm_arena_random_equipment;
	
	randomreward = randomintrange(1,101);
	i = 0;
	if(randomreward <= chance[0]) i = 0;
	else if( randomreward <= chance[1] ) i = 1;
	else if( randomreward <= chance[2] ) i = 2;
	else if( randomreward <= chance[3] ) i = 3;
	else if( randomreward <= chance[4] ) i = 4;
	
	iprintlnbold("Round complete. You will be granted: "+rewards[i]);
	funct = frewards[i]; //Due to a GSC studio error
	level thread [[funct]]();
}

_zm_arena_penalize_players()
{
	/* Penalize a random item or perk by generating an int
	 * and checking the index of the int.
	 * All functions are called by the level.
	*/
	penalties = [];
	chance = [];
	fpenalties = [];
	
	penalties[0] = "Random Perk";
	chance[0] = 10; //10% chance
	fpenalties[0] = ::_zm_arena_take_random_perk;

	penalties[1] = "Pack A Punch";
	chance[1] = 15; //5% chance
	fpenalties[1] = ::_zm_arena_take_packapunch;
	
	penalties[2] = "25% Movement Speed";
	chance[2] = 80;//65% chance
	fpenalties[2] = ::_zm_arena_slower_players;
	
	randompenalty = randomintrange(1,101);
	i = 0;
	if( randompenalty <= chance[0] ) i = 0;
	else if( randompenalty <= chance[1] ) i = 1;
	else if( randompenalty <= chance[2] ) i = 2;
	else i = 3;
	
	if( i!=3 )
	{
		iprintlnbold("You have lost: "+penalties[i]);
		funct = fpenalties[i]; //Due to a GSC studio error
		level thread [[funct]]();
	}
	else
	{
		iprintlnbold("You have been given another chance... For now...");
	}
}
_zm_arena_openalldoors()
{
	setdvar( "zombie_unlock_all", 1 );
	flag_set( "power_on" );
	players = get_players();
	zombie_doors = getentarray( "zombie_door", "targetname" );
	i = 0;
	while ( i < zombie_doors.size )
	{
		zombie_doors[ i ] notify( "trigger" );
		if ( is_true( zombie_doors[ i ].power_door_ignore_flag_wait ) )
		{
			zombie_doors[ i ] notify( "power_on" );
		}
		wait 0.05;
		i++;
	}
	zombie_airlock_doors = getentarray( "zombie_airlock_buy", "targetname" );
	i = 0;
	while ( i < zombie_airlock_doors.size )
	{
		zombie_airlock_doors[ i ] notify( "trigger" );
		wait 0.05;
		i++;
	}
	zombie_debris = getentarray( "zombie_debris", "targetname" );
	i = 0;
	while ( i < zombie_debris.size )
	{
		zombie_debris[ i ] notify("trigger");
		wait 0.05;
		i++;
	}
	level notify( "open_sesame" );
	wait 1;
	setdvar( "zombie_unlock_all", 0 );
}
