_zm_arena_player_init() // Initialize player variables
{
	
	self notify( "stop_player_out_of_playable_area_monitor" );
	self notify( "stop_player_too_many_weapons_monitor" );
	self setorigin(level._arena_start);
	self takeallweapons();
	self giveweapon(level._arena_default_weapon);
	self switchtoweapon(level._arena_default_weapon);
	self DisableInvulnerability();
	self thread _zm_arena_toofar_monitor();
	self thread _zm_arena_regendefault();
}

_zm_arena_toofar_monitor() //Monitor player distance
{
	
	self endon("spawned_player"); //back up callback.
	for(;isAlive(self);)
	{
		if(Distance(self.origin, level._arena_start) > level._arena_distancefrommax)
		{
		for(i=10;i>0;i--)
		{
		if(Distance(self.origin, level._arena_start) <= level._arena_distancefrommax) break;
		self iprintlnbold("You have ^1"+i+"^7 to return to the arena.");
		wait 1;
		}
		if(Distance(self.origin, level._arena_start) > level._arena_distancefrommax)
		{ 
			self notify("specialty_quickrevive_stop");
			wait 1;
			RadiusDamage(self.origin,15,500,500,self);
			self thread maps/mp/zombies/_zm_laststand::laststand_bleedout(.5);
			return;
		}
		}
	wait .1;
	}
}

_zm_arena_player_spawned_penalty()
{
	iprintlnbold("A player has re-entered the battle. You will be taxed for his/her life.");
	wait 2;
	level thread _zm_arena_penalize_players();
}

_zm_arena_regendefault()
{
	self endon("spawned_player");
	self.firedsecs = 0;
	self thread _zm_arena_countsecsnotfired();
	self thread _zm_arena_resetsecsnotfired();
	for(;isAlive(self);)
	{
		while(!self hasweapon(level._arena_default_weapon)) wait .05;
		wait .5;
		if(self.firedsecs > 5)
		{
			Ammo = self GetAmmoCount(level._arena_default_weapon) - WeaponClipSize(level._arena_default_weapon);
			if(Ammo < WeaponMaxAmmo( level._arena_default_weapon ) )
			{
				if(Ammo < 0 )
				{
				clipammo = self GetAmmoCount(level._arena_default_weapon);
				self setweaponammoclip( level._arena_default_weapon, clipammo + 1 );
				continue;
				}
				self setweaponammostock( level._arena_default_weapon, Ammo+1 );
			}
		}
	}
}

_zm_arena_countsecsnotfired()
{
	self endon("spawned_player");
	for(;;)
	{
		wait 1;
		self.firedsecs++;
	}
}

_zm_arena_resetsecsnotfired()
{
	self endon("spawned_player");
	for(;;)
	{
		self waittill("weapon_fired",weapon);
		if(weapon == level._arena_default_weapon) self.firedsecs = 0;
	}
}



