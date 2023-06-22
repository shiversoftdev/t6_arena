_zm_arena_take_random_perk() //Removes a random perk using reward logic with a cancel notification
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
		iprintlnbold("Perk Taken: "+random_perk);
		foreach(player in level.players) 
		{
		perk_str = random_perk + "_stop";
		player notify( perk_str );
		}
	}
}


_zm_arena_take_packapunch()
{
	foreach(player in level.players) player thread unpack_current_weapon();
}

unpack_current_weapon()
{
	for(i=5;i>0;i--)
	{
		self iprintlnbold("Your weapon will downgrade in "+i);
		wait 1;
	}
	if ( !self maps/mp/zombies/_zm_laststand::player_is_in_laststand() )
	{
		weap = self getcurrentweapon();
		weapon = maps/mp/zombies/_zm_weapons::get_base_weapon_name( weap, 1 );
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

_zm_arena_slower_players()
{
	foreach(player in level.players) player setmovespeedscale(.75);
}
