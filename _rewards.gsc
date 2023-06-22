pack_current_weapon() //pack a punch your weapon
{
	wait 1;
	for(i=5;i>0;i--)
	{
	self iprintlnbold("You have "+i+" to switch to your weapon of choice");
	wait 1;
	}
	if ( !self maps/mp/zombies/_zm_laststand::player_is_in_laststand() )
	{
		weap = maps/mp/zombies/_zm_weapons::get_base_name( self getcurrentweapon() );
		weapon = get_upgrade( weap );
		if ( isDefined( weapon ) )
		{
			self.mostrecentgiven = weapon;
			self takeweapon( weap );
			self giveweapon( weapon, 0, self maps/mp/zombies/_zm_weapons::get_pack_a_punch_weapon_options( weapon ) );
			self givestartammo( weapon );
			self switchtoweapon( weapon );
		}
	}

}

get_upgrade( weaponname ) //get upgrade name of a weapon
{

	if ( isDefined( level.zombie_weapons[ weaponname ] ) && isDefined( level.zombie_weapons[ weaponname ].upgrade_name ) )
	{
		return maps/mp/zombies/_zm_weapons::get_upgrade_weapon( weaponname, 0 );
	}
	else
	{
		return maps/mp/zombies/_zm_weapons::get_upgrade_weapon( weaponname, 1 );

	}
}

_zm_arena_pap_all() //Pack a punch all players current weapon in level.players
{
	foreach(player in level.players) player thread pack_current_weapon();
}

_zm_arena_fill_ammo() //Give a max ammo to the first alive player in level.players
{
	foreach(player in level.players) //this is so that if the host is dead, the alive players still get a max ammo.
	{
		if(isAlive(player))
		{
			level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( "full_ammo", player.origin );
			break;
		}
	
	}
}

_zm_arena_random_perk() //Get a random perk by using the level perk logic.
{
	wait 2;
	random_perk = undefined;
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	perks = [];
	i = 0;
	while ( i < vending_triggers.size )
	{
		perk = vending_triggers[ i ].script_noteworthy;
		if ( perk == "specialty_weapupgrade" )
		{
			i++;
			continue;
		}
		else
		{
			perks[ perks.size ] = perk;
		}
		i++;
	}
	
	if ( perks.size > 0 )
	{
		perks = array_randomize( perks );
		random_perk = perks[ 0 ];
		iprintlnbold("Perk: "+random_perk);
		foreach(player in level.players) player maps/mp/zombies/_zm_perks::give_perk( random_perk , 1);
	}
}

_zm_arena_random_weapon() //Give player a random weapon by using the mysterybox logic for each player.
{
	wait 2;
	foreach(player in level.players)
	{
		weaponofchoice = _zm_arena_get_random_weapon(player);
		player iprintlnbold("You have been awarded "+weaponofchoice);
		player giveweapon(weaponofchoice);
		player givestartammo( weaponofchoice );
		player switchtoweapon( weaponofchoice );
	}
}


_zm_arena_get_random_weapon( player ) //Apply mysterybox logic and return the weapon
{
	keys = array_randomize( getarraykeys( level.zombie_weapons ) );
	if ( isDefined( level.customrandomweaponweights ) )
	{
		keys = player [[ level.customrandomweaponweights ]]( keys );
	}
	
	pap_triggers = getentarray( "specialty_weapupgrade", "script_noteworthy" );
	i = 0;
	finalkey = "";
	while ( i < keys.size )
	{
		if ( maps/mp/zombies/_zm_magicbox::treasure_chest_canplayerreceiveweapon( player, keys[ i ], pap_triggers ) )
		{
			finalkey = keys[ i ];
			break;
		}
		i++;
	}
	if(finalkey == "") finalkey = keys[ 0 ];
	return finalkey;
}

_zm_arena_random_equipment() //Give each player in level.players an item from level._arena_items_list
{
	foreach(player in level.players)
	{
		player thread _zm_arena_giveother();
	}
}

_zm_arena_giveother() //Select random item from level._arena_items_list and give it to self
{
	wait 2;
	randomweapon = level._arena_items_list[randomintrange(0,level._arena_items_list.size)];
	self maps/mp/zombies/_zm_weapons::weapon_give( randomweapon, 0, 0 );
	self iprintlnbold("You were gifted: "+randomweapon);
}
