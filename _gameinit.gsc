_zm_arena_InitializeGamemode() //Full initialization of game mode
{
	for(i=30;i>0;i--)
	{
		iprintlnbold("Arena will begin in "+i);
		wait 1;
	}
	//Everyone should be spawned in at this point.
	foreach(player in level.players)
	{
		player thread _zm_arena_player_init();
	}
	wait 2;
	_zm_arena_intializespawndata();
	level thread _zm_arena_reward_system();
	level.players[0] maps\mp\zombies\_zm_game_module::turn_power_on_and_open_doors();
	level thread _zm_arena_openalldoors();
	level._arena_initialized = 1;// This is so new players or repeat players still initialize on spawn
	wait 2;
	iprintlnbold("Stay within the Arena... Survive.");
}

_zm_arena_initialize_level_variables() //Set up all initial variables
{
	level._arena_initialized = 0; //Prep variable to allow delayed spawners to participate properly
	level._arena_start = []; //Central origin for the entire game mode.
	level.player_out_of_playable_area_monitor = 0;
	level.player_intersection_tracker_override = :: _zm_arena_intersection_override;
	level._arena_initialized = 0;
	level._arena_items_list = [];
	map = getdvar("mapname");
	if(map=="zm_transit")
	{
		level._arena_start = (5246,6890,-24);
		level.start_weapon = "m16_zm";
		level.start_weapon_arena = "m16_zm";
		level._arena_items_list[0] = "sticky_grenade_zm";
		level._arena_items_list[1] = "claymore_zm";
		level._arena_items_list[2] = "cymbal_monkey_zm";
		level._arena_items_list[3] = "emp_grenade_zm";
		level._arena_items_list[4] = "riotshield_zm";
		level._arena_items_list[5] = "jetgun_zm";
		level._arena_items_list[6] = "tazer_knuckles_zm";
		level._arena_items_list[7] = "bowie_knife_zm";
		level._arena_items_list[8] = "equip_turbine_zm";
		level._arena_items_list[9] = "equip_turret_zm";
		level._arena_items_list[10] = "equip_electrictrap_zm";
	}
	else if(map=="zm_nuked")
	{
		level._arena_start = (1942,412,-63);
		level.start_weapon = "m16_zm";
		level.start_weapon_arena = "m16_zm";
		level._arena_items_list[0] = "claymore_zm";
		level._arena_items_list[1] = "sticky_grenade_zm";
		level._arena_items_list[2] = "cymbal_monkey_zm";
		level._arena_items_list[3] = "tazer_knuckles_zm";
		level._arena_items_list[4] = "bowie_knife_zm";
	}
	else if(map=="zm_highrise")
	{
		level._arena_start = (2848,1391,2722);
		level.start_weapon = "m16_zm";
		level.start_weapon_arena = "m16_zm";
		level._arena_items_list[0] = "sticky_grenade_zm";
		level._arena_items_list[1] = "claymore_zm";
		level._arena_items_list[2] = "cymbal_monkey_zm";
		level._arena_items_list[3] = "tazer_knuckles_zm";
		level._arena_items_list[4] = "equip_springpad_zm";
		level._arena_items_list[5] = "bowie_knife_zm";
	}
	else if(map=="zm_prison")
	{
		level._arena_start = (399,9604,1104);
		level.start_weapon = "uzi_zm";
		level.start_weapon_arena = "uzi_zm";
		level._arena_items_list[0] = "claymore_zm";
		level._arena_items_list[1] = "spork_zm_alcatraz";
		level._arena_items_list[2] = "alcatraz_shield_zm";
	}
	else if(map=="zm_buried")
	{
		level._arena_start = (5104,567,4);
		level.start_weapon = "m16_zm";
		level.start_weapon_arena = "m16_zm";
		level._arena_items_list[0] = "cymbal_monkey_zm";
		level._arena_items_list[1] = "time_bomb_zm";
		level._arena_items_list[2] = "claymore_zm";
		level._arena_items_list[3] = "bowie_knife_zm";
		level._arena_items_list[4] = "tazer_knuckles_zm";
		level._arena_items_list[5] = "equip_turbine_zm";
		level._arena_items_list[6] = "equip_springpad_zm";
		level._arena_items_list[7] = "equip_subwoofer_zm";
		level._arena_items_list[8] = "equip_headchopper_zm";
	}
	else if(map=="zm_tomb")
	{
		level._arena_start = (607,2310,-123);
		level.start_weapon = "mp44_zm";
		level.start_weapon_arena = "mp44_zm";
		level._arena_items_list[0] = "sticky_grenade_zm";
		level._arena_items_list[1] = "beacon_zm";
		level._arena_items_list[2] = "claymore_zm";
		level._arena_items_list[3] = "cymbal_monkey_zm";
		level._arena_items_list[4] = "tomb_shield_zm";
		level._arena_items_list[5] = "bowie_knife_zm";
	}
	level._arena_default_weapon = level.start_weapon;
	
	level._arena_distancefrommax = 3000; //Lets start with a pretty good distance.
}

_zm_arena_intersection_override(player) //Override intersection tracker by endless wait
{
	self waittill("forever");
	return true;
}

_zm_arena_intializespawndata() //set zombie variables
{
	level.is_player_in_screecher_zone = ::_zm_arena_false_function;
	level.screecher_should_runaway = ::_zm_arena_true_function;
	level.perk_purchase_limit = 8;
	level.zombie_vars[ "zombie_new_runner_interval" ] = 1;
	//level.zombie_actor_limit = 20;
	//level.zombie_ai_limit = 52;
	//level.zombie_vars[ "zombie_max_ai" ] = 52;
	//level.zombie_vars[ "zombie_ai_per_player" ] = 13;
	level.zombie_vars[ "zombie_move_speed_multiplier" ] = 90;
	level.zombie_vars[ "zombie_between_round_time" ] = .01;
	level.zombie_vars[ "zombie_spawn_delay" ] = 0.01;
}

_zm_arena_false_function(player)
{
return false;
}

_zm_arena_true_function(player)
{
return true;
}


