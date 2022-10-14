/*
	Dynamic Menus (dynMenus)
	by MX_Master

	it's include file for "GTA San Andreas Multiplayer" scripts

	(!) a_samp.inc (<a_samp>) file must be included before this file
	(!) place onPlayerExitedMenu(playerid); into OnPlayerExitedMenu callback
	(!) place onPlayerSelectedMenuRow(playerid,row); into OnPlayerSelectedMenuRow callback

	(?) use showMenuForPlayer and hideMenuForPlayer functions wherever you want
*/




//
//	current menu data for each player ..........
//
enum playerMenuParams
{
	menuClass,
	menuID,

	Menu:menu
}

stock playerMenu[MAX_PLAYERS][playerMenuParams]; // current menu data for each player











//
//	your menu options ..........
//
#define NO_MENU					0 // no menu ID or class ID
#define FREEZE_PLAYER_IN_MENU	1 // freeze or not freeze player until he browsing any menu

// eat menu position and width (example)
#define EAT_MENU_COLS			1 // for buy menu (food,cost) uses 2 and this value will be ignored
#define EAT_MENU_POSX			30.0
#define EAT_MENU_POSY			140.0
#define EAT_MENU_COL1_WIDTH		120.0
#define EAT_MENU_COL2_WIDTH		50.0

// ammu menu position and width (example)
#define AMMU_MENU_COLS			1 // for buy menu (weapon,cost) uses 2 and this value will be ignored
#define AMMU_MENU_POSX			30.0
#define AMMU_MENU_POSY			140.0
#define AMMU_MENU_COL1_WIDTH	120.0
#define AMMU_MENU_COL2_WIDTH	50.0











//
//	your menu classes ..........
//
enum // menu classes
{
	menuClassNo, // no menu
	menuClassEat, // eat menu class (example)
	menuClassAmmu // ammu menu class (example)
	// ... insert here your own menu classes
}











//
//	your menus IDs ..........
//

// eat menu IDs (example)
enum
{
	menuEatNo, // no menu

	menuEatMain, // main eat menu

	menuEatPizza, // pizza buy menu
	menuEatChicken, // chicken buy menu
	menuEatSalad // salad buy menu
}




// ammu menu IDs (example)
enum
{
	menuAmmuNo, // no menu

	// main
	menuAmmuMain, // main ammu menu

	// lists
	menuAmmuMelee, // ammu menu with melee weapons list
	menuAmmuSpecial, // ammu menu with special weapons list
	menuAmmuPistols, // ammu menu with pistols list
	menuAmmuShotguns, // ammu menu with shotguns list
	menuAmmuRifles, // ammu menu with .. list
	menuAmmuAssault, // ..
	menuAmmuMicroSMGs,
	menuAmmuArmors,
	menuAmmuThrown,
	menuAmmuHeavy,

	// melee buy menus
	menuAmmuNiteStick, // ammu buy menu for NiteStick only
	menuAmmuBat, // ammu buy menu for Bat only
	menuAmmuCane, // ammu buy menu for .. only
	menuAmmuFlower, // ..
	menuAmmuDildo,
	menuAmmuBrassknuckle,
	menuAmmuKnife,
	menuAmmuGolfClub,
	menuAmmuPoolStick,
	menuAmmuShovel,
	menuAmmuKatana,
	menuAmmuChainSaw,

	// special weapons buy menus
	menuAmmuCamera,
	menuAmmuSpraycan,
	menuAmmuFireExtinguisher,
	menuAmmuParachute,

	// pistols buy menus
	menuAmmuColt45,
	menuAmmuSilenced,
	menuAmmuDeagle,

	// .. buy menus
	menuAmmuShotgun,
	menuAmmuSawnoff,
	menuAmmuCombatShotgun,

	// ..
	menuAmmuTec9,
	menuAmmuUzi,

	menuAmmuRifle,
	menuAmmuSniper,

	menuAmmuMP5,
	menuAmmuAK47,
	menuAmmuM4,

	menuAmmuArmor,

	menuAmmuGrenade,
	menuAmmuTearGas,
	menuAmmuMolotov,

	menuAmmuFlameThrower,
	menuAmmuRocketLauncher,
	menuAmmuHeatSeeker,
	menuAmmuMinigun
}





















//
//	4 menu tools ..........
//

#define plMenu playerMenu[playerid][menu] // (!) short code optimization ;)




//
//	use this function if you want to hide any menu for player
//
stock hideMenuForPlayer ( playerid )
{
	if ( playerMenu[playerid][menuClass] == NO_MENU ) return;

	HideMenuForPlayer( plMenu, playerid );
	DestroyMenu( plMenu );

	playerMenu[playerid][menuClass] = NO_MENU;
	playerMenu[playerid][menuID] = NO_MENU;
}











//
//	use this function if you want to show any menu for player
//
//	(!) playerMenuClass must be correct! See ^ "your menu classes"
//	(!) playerMenuID must be correct! See ^ "your menu IDs"
//
stock showMenuForPlayer ( playerid, playerMenuClass, playerMenuID )
{
	hideMenuForPlayer(playerid); // hide any menu for player




	// freeze player
	#if FREEZE_PLAYER_IN_MENU == 1
		TogglePlayerControllable( playerid, 0 );
	#endif




	// choosing player menu class
	switch ( playerMenuClass )
	{
		case menuClassAmmu : // it's one of ammu menus
		{
			// create menu for player
			switch ( playerMenuID )
			{
				// if it's buy menu we must use 2 columns instead of 1
				// also we can add culumn headers
				case menuAmmuNiteStick..menuAmmuMinigun :
				{
					plMenu = CreateMenu( "Ammu", 2, AMMU_MENU_POSX, AMMU_MENU_POSY, AMMU_MENU_COL1_WIDTH, AMMU_MENU_COL2_WIDTH );

					SetMenuColumnHeader( plMenu, 0, "weapon" );
					SetMenuColumnHeader( plMenu, 1, "cost" );
				}

				// if it's just list of items, we must use 1 column
				default :
					plMenu = CreateMenu( "Ammu", AMMU_MENU_COLS, AMMU_MENU_POSX, AMMU_MENU_POSY, AMMU_MENU_COL1_WIDTH, AMMU_MENU_COL2_WIDTH );
			}




			// add some rows to created menu
			switch ( playerMenuID )
			{
				// main ammu menu

				case menuAmmuMain : // ammu menu with weapon groups
				{
					AddMenuItem( plMenu, 0, "Melee" );
					AddMenuItem( plMenu, 0, "Special" );
					AddMenuItem( plMenu, 0, "Pistols" );
					AddMenuItem( plMenu, 0, "Shotguns" );
					AddMenuItem( plMenu, 0, "Rifles" );
					AddMenuItem( plMenu, 0, "Assault" );
					AddMenuItem( plMenu, 0, "Micro SMGs" );
					AddMenuItem( plMenu, 0, "Armours" );
					AddMenuItem( plMenu, 0, "Thrown" );
					AddMenuItem( plMenu, 0, "Heavy" );

					// dynamic menu rows EXAMPLES

					// disable armours if player have less than 5 score points
					if ( GetPlayerScore(playerid) < 5 ) DisableMenuRow( plMenu, 7 );

					// disable thrown weapons if player have less than 10 score points
					if ( GetPlayerScore(playerid) < 10 ) DisableMenuRow( plMenu, 8 );

					// disable heavy weapons if player have less than 20 score points
					if ( GetPlayerScore(playerid) < 20 ) DisableMenuRow( plMenu, 9 );
				}

				// ammu menus with weapons lists

				case menuAmmuMelee : // ammu menu with melee weapons list
				{
					AddMenuItem( plMenu, 0, "Nite Stick" );
					AddMenuItem( plMenu, 0, "Bat" );
					AddMenuItem( plMenu, 0, "Cane" );
					AddMenuItem( plMenu, 0, "Flower" );
					AddMenuItem( plMenu, 0, "Dildo" );
					AddMenuItem( plMenu, 0, "Brassknuckle" );
					AddMenuItem( plMenu, 0, "Knife" );
					AddMenuItem( plMenu, 0, "Golf Club" );
					AddMenuItem( plMenu, 0, "Pool Stick" );
					AddMenuItem( plMenu, 0, "Shovel" );
					AddMenuItem( plMenu, 0, "Katana" );
					AddMenuItem( plMenu, 0, "Chain Saw" );
				}
				case menuAmmuSpecial : // ammu menu with special weapons list
				{
					AddMenuItem( plMenu, 0, "Camera" );
					AddMenuItem( plMenu, 0, "Spraycan" );
					AddMenuItem( plMenu, 0, "Fire Extinguisher" );
					AddMenuItem( plMenu, 0, "Parachute" );
				}
				case menuAmmuPistols : // ammu menu with pistols list
				{
					AddMenuItem( plMenu, 0, "Colt 45" );
					AddMenuItem( plMenu, 0, "Silenced Colt" );
					AddMenuItem( plMenu, 0, "Deagle" );
				}
				case menuAmmuShotguns : // ammu menu with shotguns list
				{
					AddMenuItem( plMenu, 0, "Shotgun" );
					AddMenuItem( plMenu, 0, "Sawnoff" );
					AddMenuItem( plMenu, 0, "Combat Shotgun" );
				}
				case menuAmmuRifles : // ammu menu with rifles list
				{
					AddMenuItem( plMenu, 0, "Rifle" );
					AddMenuItem( plMenu, 0, "Sniper" );
				}
				case menuAmmuAssault : // ammu menu with assault weapons list
				{
					AddMenuItem( plMenu, 0, "MP5" );
					AddMenuItem( plMenu, 0, "AK47" );
					AddMenuItem( plMenu, 0, "M4" );
				}
				case menuAmmuMicroSMGs : // ammu menu with micro smgs list
				{
					AddMenuItem( plMenu, 0, "Tec9" );
					AddMenuItem( plMenu, 0, "Uzi" );
				}
				case menuAmmuArmors : // ammu menu with armours list
				{
					AddMenuItem( plMenu, 0, "Body Armour" );
				}
				case menuAmmuThrown : // ammu menu with thrown weapons list
				{
					AddMenuItem( plMenu, 0, "Grenade" );
					AddMenuItem( plMenu, 0, "Tear Gas" );
					AddMenuItem( plMenu, 0, "Molotov" );
				}
				case menuAmmuHeavy : // ammu menu with heavy weapons list
				{
					AddMenuItem( plMenu, 0, "Flame Thrower" );
					AddMenuItem( plMenu, 0, "Rocket Launcher" );
					AddMenuItem( plMenu, 0, "Heat Seeker" );

					// dynamic menu row EXAMPLE

					// add minigun row only if player is admin
					if ( IsPlayerAdmin(playerid) ) AddMenuItem( plMenu, 0, "Minigun" );
				}

				// ammu buy menus

				case menuAmmuBrassknuckle : // ammu brassknuckles buy menu
				{
					AddMenuItem( plMenu, 0, "Brassknuckle" );
					AddMenuItem( plMenu, 1, "$50" );
				}
				case menuAmmuGolfClub : // ammu golf club buy menu
				{
					AddMenuItem( plMenu, 0, "GolfClub" );
					AddMenuItem( plMenu, 1, "$100" );
				}
				case menuAmmuNiteStick : // ammu .. buy menu
				{
					AddMenuItem( plMenu, 0, "Nite Stick" );
					AddMenuItem( plMenu, 1, "$100" );
				}
				case menuAmmuKnife :  // ..
				{
					AddMenuItem( plMenu, 0, "Knife" );
					AddMenuItem( plMenu, 1, "$50" );
				}
				case menuAmmuBat :
				{
					AddMenuItem( plMenu, 0, "Bat" );
					AddMenuItem( plMenu, 1, "$100" );
				}
				case menuAmmuShovel :
				{
					AddMenuItem( plMenu, 0, "Shovel" );
					AddMenuItem( plMenu, 1, "$100" );
				}
				case menuAmmuPoolStick :
				{
					AddMenuItem( plMenu, 0, "Pool Stick" );
					AddMenuItem( plMenu, 1, "$100" );
				}
				case menuAmmuKatana :
				{
					AddMenuItem( plMenu, 0, "Katana" );
					AddMenuItem( plMenu, 1, "$200" );
				}
				case menuAmmuChainSaw :
				{
					AddMenuItem( plMenu, 0, "Chain Saw" );
					AddMenuItem( plMenu, 1, "$250" );
				}
				case menuAmmuDildo :
				{
					AddMenuItem( plMenu, 0, "Dildo" );
					AddMenuItem( plMenu, 1, "$50" );
				}
				case menuAmmuFlower :
				{
					AddMenuItem( plMenu, 0, "Flower" );
					AddMenuItem( plMenu, 1, "$50" );
				}
				case menuAmmuCane :
				{
					AddMenuItem( plMenu, 0, "Cane" );
					AddMenuItem( plMenu, 1, "$50" );
				}

				case menuAmmuGrenade :
				{
					AddMenuItem( plMenu, 0, "Grenade" );
					AddMenuItem( plMenu, 1, "$300" );
				}
				case menuAmmuTearGas :
				{
					AddMenuItem( plMenu, 0, "TearGas" );
					AddMenuItem( plMenu, 1, "$250" );
				}
				case menuAmmuMolotov :
				{
					AddMenuItem( plMenu, 0, "Molotov" );
					AddMenuItem( plMenu, 1, "$200" );
				}

				case menuAmmuColt45 :
				{
					AddMenuItem( plMenu, 0, "Colt 45" );
					AddMenuItem( plMenu, 1, "$500" );
				}
				case menuAmmuSilenced :
				{
					AddMenuItem( plMenu, 0, "Silenced Colt" );
					AddMenuItem( plMenu, 1, "$600" );
				}
				case menuAmmuDeagle :
				{
					AddMenuItem( plMenu, 0, "Deagle" );
					AddMenuItem( plMenu, 1, "$800" );
				}

				case menuAmmuShotgun :
				{
					AddMenuItem( plMenu, 0, "Shotgun" );
					AddMenuItem( plMenu, 1, "$1000" );
				}
				case menuAmmuSawnoff :
				{
					AddMenuItem( plMenu, 0, "Sawnoff" );
					AddMenuItem( plMenu, 1, "$1200" );
				}
				case menuAmmuCombatShotgun :
				{
					AddMenuItem( plMenu, 0, "Combat Shotgun" );
					AddMenuItem( plMenu, 1, "$1500" );
				}

				case menuAmmuTec9 :
				{
					AddMenuItem( plMenu, 0, "Tec9" );
					AddMenuItem( plMenu, 1, "$600" );
				}
				case menuAmmuUzi :
				{
					AddMenuItem( plMenu, 0, "Uzi" );
					AddMenuItem( plMenu, 1, "$700" );
				}
				case menuAmmuMP5 :
				{
					AddMenuItem( plMenu, 0, "MP5" );
					AddMenuItem( plMenu, 1, "$900" );
				}

				case menuAmmuAK47 :
				{
					AddMenuItem( plMenu, 0, "AK47" );
					AddMenuItem( plMenu, 1, "$2500" );
				}
				case menuAmmuM4 :
				{
					AddMenuItem( plMenu, 0, "M4" );
					AddMenuItem( plMenu, 1, "$3000" );
				}

				case menuAmmuRifle :
				{
					AddMenuItem( plMenu, 0, "Rifle" );
					AddMenuItem( plMenu, 1, "$2000" );
				}
				case menuAmmuSniper :
				{
					AddMenuItem( plMenu, 0, "Sniper" );
					AddMenuItem( plMenu, 1, "$4000" );
				}

				case menuAmmuRocketLauncher :
				{
					AddMenuItem( plMenu, 0, "Rocket Launcher" );
					AddMenuItem( plMenu, 1, "$10000" );
				}
				case menuAmmuHeatSeeker :
				{
					AddMenuItem( plMenu, 0, "Heat Seeker" );
					AddMenuItem( plMenu, 1, "$15000" );
				}
				case menuAmmuFlameThrower :
				{
					AddMenuItem( plMenu, 0, "Flame Thrower" );
					AddMenuItem( plMenu, 1, "$5000" );
				}
				case menuAmmuMinigun :
				{
					AddMenuItem( plMenu, 0, "Minigun" );
					AddMenuItem( plMenu, 1, "$25000" );
				}

				case menuAmmuSpraycan :
				{
					AddMenuItem( plMenu, 0, "Spraycan" );
					AddMenuItem( plMenu, 1, "$50" );
				}
				case menuAmmuFireExtinguisher :
				{
					AddMenuItem( plMenu, 0, "Fire Extinguisher" );
					AddMenuItem( plMenu, 1, "$100" );
				}
				case menuAmmuCamera :
				{
					AddMenuItem( plMenu, 0, "Camera" );
					AddMenuItem( plMenu, 1, "$50" );
				}
				case menuAmmuParachute :
				{
					AddMenuItem( plMenu, 0, "Parachute" );
					AddMenuItem( plMenu, 1, "$150" );
				}

				case menuAmmuArmor :
				{
					AddMenuItem( plMenu, 0, "Body Armour" );
					AddMenuItem( plMenu, 1, "$250" );
				}
			}
		}




		case menuClassEat : // it's one of eat menus
		{
			// create menu for player
			switch ( playerMenuID )
			{
				// if it's buy menu we must use 2 columns instead of 1
				// also we can add culumn headers
				case menuEatPizza..menuEatSalad :
				{
					plMenu = CreateMenu( "Food", 2, EAT_MENU_POSX, EAT_MENU_POSY, EAT_MENU_COL1_WIDTH, EAT_MENU_COL2_WIDTH );

					SetMenuColumnHeader( plMenu, 0, "food" );
					SetMenuColumnHeader( plMenu, 1, "cost" );
				}

				// if it's just list of items, we must use 1 column
				default :
					plMenu = CreateMenu( "Food", EAT_MENU_COLS, EAT_MENU_POSX, EAT_MENU_POSY, EAT_MENU_COL1_WIDTH, EAT_MENU_COL2_WIDTH );
			}




			// add some rows to created menu
			switch ( playerMenuID )
			{
				// main eat menu
				case menuEatMain :
				{
					AddMenuItem( plMenu, 0, "Pizza" );
					AddMenuItem( plMenu, 0, "Chicken" );
					AddMenuItem( plMenu, 0, "Salad" );
				}

				// eat buy menus
				case menuEatPizza :
				{
					AddMenuItem( plMenu, 0, "Pizza" );
					AddMenuItem( plMenu, 1, "$10" );
				}
				case menuEatChicken :
				{
					AddMenuItem( plMenu, 0, "Chicken" );
					AddMenuItem( plMenu, 1, "$20" );
				}
				case menuEatSalad :
				{
					AddMenuItem( plMenu, 0, "Salad" );
					AddMenuItem( plMenu, 1, "$40" );
				}
			}
		}
	}




	ShowMenuForPlayer( plMenu, playerid ); // show created menu for player

	playerMenu[playerid][menuClass] = playerMenuClass;
	playerMenu[playerid][menuID] = playerMenuID;
}











//
//	(!) place this function into OnPlayerExitedMenu callback
//
stock onPlayerExitedMenu ( playerid )
{
	// selecting current player's menu class
	switch ( playerMenu[playerid][menuClass] )
	{
		// player exited one of ammu menu
		case menuClassAmmu :
		{
			// selecting current player's menu ID
			switch ( playerMenu[playerid][menuID] )
			{
				// player exited main ammu menu
				case menuAmmuMain :
				{
					hideMenuForPlayer(playerid); // hide any menu for player

					// unfreeze player
					#if FREEZE_PLAYER_IN_MENU == 1
						TogglePlayerControllable( playerid, 1 );
					#endif
				}

				// player exited from any weapons group menu to main menu
				case menuAmmuMelee..menuAmmuHeavy : 			showMenuForPlayer( playerid, menuClassAmmu, menuAmmuMain );

				// player exited from one of buy menu to group weapons list menu
				case menuAmmuNiteStick..menuAmmuChainSaw : 		showMenuForPlayer( playerid, menuClassAmmu, menuAmmuMelee );
				case menuAmmuCamera..menuAmmuParachute : 		showMenuForPlayer( playerid, menuClassAmmu, menuAmmuSpecial );
				case menuAmmuColt45..menuAmmuDeagle : 			showMenuForPlayer( playerid, menuClassAmmu, menuAmmuPistols );
				case menuAmmuShotgun..menuAmmuCombatShotgun : 	showMenuForPlayer( playerid, menuClassAmmu, menuAmmuShotguns );
				case menuAmmuTec9, menuAmmuUzi : 				showMenuForPlayer( playerid, menuClassAmmu, menuAmmuMicroSMGs );
				case menuAmmuRifle, menuAmmuSniper : 			showMenuForPlayer( playerid, menuClassAmmu, menuAmmuRifles );
				case menuAmmuMP5..menuAmmuM4 : 					showMenuForPlayer( playerid, menuClassAmmu, menuAmmuAssault );
				case menuAmmuArmor : 							showMenuForPlayer( playerid, menuClassAmmu, menuAmmuArmors );
				case menuAmmuGrenade..menuAmmuMolotov : 		showMenuForPlayer( playerid, menuClassAmmu, menuAmmuThrown );
				case menuAmmuFlameThrower..menuAmmuMinigun : 	showMenuForPlayer( playerid, menuClassAmmu, menuAmmuHeavy );
			}
		}




		// player exited one of eat menu
		case menuClassEat :
		{
			switch ( playerMenu[playerid][menuID] )
			{
				// player exited main ammu menu
				case menuEatMain :
				{
					hideMenuForPlayer(playerid); // hide any menu for player

					// unfreeze player
					#if FREEZE_PLAYER_IN_MENU == 1
						TogglePlayerControllable( playerid, 1 );
					#endif
				}

				// player exited from any eat buy menu to main menu
				case menuEatPizza..menuEatSalad : showMenuForPlayer( playerid, menuClassEat, menuEatMain );
			}
		}
	}
}











//
//	(!) place this function into OnPlayerSelectedMenuRow callback
//
stock onPlayerSelectedMenuRow ( playerid, row )
{
	// selecting current player's menu class
	switch ( playerMenu[playerid][menuClass] )
	{
		// it's one of ammu menus
		case menuClassAmmu :
		{
			// selecting current player's menu ID
			switch ( playerMenu[playerid][menuID] )
			{
				// selected one of the main menu rows

				case menuAmmuMain :
				{
					switch ( row )
					{
						case 0 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuMelee );
						case 1 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuSpecial );
						case 2 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuPistols );
						case 3 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuShotguns );
						case 4 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuRifles );
						case 5 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuAssault );
						case 6 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuMicroSMGs );
						case 7 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuArmors );
						case 8 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuThrown );
						case 9 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuHeavy );
					}
				}

				// selected one of the weapons group menu rows

				case menuAmmuMelee :
				{
					switch ( row )
					{
						case 0 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuNiteStick );
						case 1 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuBat );
						case 2 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuCane );
						case 3 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuFlower );
						case 4 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuDildo );
						case 5 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuBrassknuckle );
						case 6 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuKnife );
						case 7 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuGolfClub );
						case 8 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuPoolStick );
						case 9 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuShovel );
						case 10 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuKatana );
						case 11 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuChainSaw );
					}
				}
				case menuAmmuSpecial :
				{
					switch ( row )
					{
						case 0 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuCamera );
						case 1 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuSpraycan );
						case 2 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuFireExtinguisher );
						case 3 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuParachute );
					}
				}
				case menuAmmuPistols :
				{
					switch ( row )
					{
						case 0 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuColt45 );
						case 1 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuSilenced );
						case 2 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuDeagle );
					}
				}
				case menuAmmuShotguns :
				{
					switch ( row )
					{
						case 0 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuShotgun );
						case 1 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuSawnoff );
						case 2 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuCombatShotgun );
					}
				}
				case menuAmmuRifles :
				{
					switch ( row )
					{
						case 0 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuRifle );
						case 1 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuSniper );
					}
				}
				case menuAmmuAssault :
				{
					switch ( row )
					{
						case 0 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuMP5 );
						case 1 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuAK47 );
						case 2 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuM4 );
					}
				}
				case menuAmmuMicroSMGs :
				{
					switch ( row )
					{
						case 0 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuTec9 );
						case 1 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuUzi );
					}
				}
				case menuAmmuArmors :
				{
					showMenuForPlayer( playerid, menuClassAmmu, menuAmmuArmor );
				}
				case menuAmmuThrown :
				{
					switch ( row )
					{
						case 0 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuGrenade );
						case 1 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuTearGas );
						case 2 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuMolotov );
					}
				}
				case menuAmmuHeavy :
				{
					switch ( row )
					{
						case 0 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuFlameThrower );
						case 1 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuRocketLauncher );
						case 2 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuHeatSeeker );
						case 3 : showMenuForPlayer( playerid, menuClassAmmu, menuAmmuMinigun );
					}
				}

				// selected one of the buy menu rows

				case menuAmmuNiteStick..menuAmmuMinigun :
				{
					new wID, wAmmo, wCost;

					switch ( playerMenu[playerid][menuID] )
					{
						case menuAmmuBrassknuckle : { wID = WEAPON_BRASSKNUCKLE; wAmmo = 1; wCost = 50; }
						case menuAmmuGolfClub : { wID = WEAPON_GOLFCLUB; wAmmo = 1; wCost = 100; }
						case menuAmmuNiteStick : { wID = WEAPON_NITESTICK; wAmmo = 1; wCost = 100; }
						case menuAmmuKnife : { wID = WEAPON_KNIFE; wAmmo = 1; wCost = 50; }
						case menuAmmuBat : { wID = WEAPON_BAT; wAmmo = 1; wCost = 100; }
						case menuAmmuShovel : { wID = WEAPON_SHOVEL; wAmmo = 1; wCost = 100; }
						case menuAmmuPoolStick : { wID = WEAPON_POOLSTICK; wAmmo = 1; wCost = 100; }
						case menuAmmuKatana : { wID = WEAPON_KATANA; wAmmo = 1; wCost = 200; }
						case menuAmmuChainSaw : { wID = WEAPON_CHAINSAW; wAmmo = 1; wCost = 250; }
						case menuAmmuDildo : { wID = WEAPON_DILDO; wAmmo = 1; wCost = 50; }
						case menuAmmuFlower : { wID = WEAPON_FLOWER; wAmmo = 1; wCost = 50; }
						case menuAmmuCane : { wID = WEAPON_CANE; wAmmo = 1; wCost = 50; }
						case menuAmmuGrenade : { wID = WEAPON_GRENADE; wAmmo = 1; wCost = 300; }
						case menuAmmuTearGas : { wID = WEAPON_TEARGAS; wAmmo = 1; wCost = 250; }
						case menuAmmuMolotov : { wID = WEAPON_MOLTOV; wAmmo = 1; wCost = 200; }
						case menuAmmuColt45 : { wID = WEAPON_COLT45; wAmmo = 30; wCost = 500; }
						case menuAmmuSilenced : { wID = WEAPON_SILENCED; wAmmo = 30; wCost = 600; }
						case menuAmmuDeagle : { wID = WEAPON_DEAGLE; wAmmo = 30; wCost = 800; }
						case menuAmmuShotgun : { wID = WEAPON_SHOTGUN; wAmmo = 20; wCost = 1000; }
						case menuAmmuSawnoff : { wID = WEAPON_SAWEDOFF; wAmmo = 20; wCost = 1200; }
						case menuAmmuCombatShotgun : { wID = WEAPON_SHOTGSPA; wAmmo = 20; wCost = 1500; }
						case menuAmmuUzi : { wID = WEAPON_UZI; wAmmo = 50; wCost = 700; }
						case menuAmmuMP5 : { wID = WEAPON_MP5; wAmmo = 50; wCost = 900; }
						case menuAmmuAK47 : { wID = WEAPON_AK47; wAmmo = 50; wCost = 2500; }
						case menuAmmuM4 : { wID = WEAPON_M4; wAmmo = 50; wCost = 3000; }
						case menuAmmuTec9 : { wID = WEAPON_TEC9; wAmmo = 50; wCost = 600; }
						case menuAmmuRifle : { wID = WEAPON_RIFLE; wAmmo = 20; wCost = 2000; }
						case menuAmmuRocketLauncher : { wID = WEAPON_ROCKETLAUNCHER; wAmmo = 1; wCost = 10000; }
						case menuAmmuSniper : { wID = WEAPON_SNIPER; wAmmo = 20; wCost = 4000; }
						case menuAmmuHeatSeeker : { wID = WEAPON_HEATSEEKER; wAmmo = 1; wCost = 15000; }
						case menuAmmuFlameThrower : { wID = WEAPON_FLAMETHROWER; wAmmo = 100; wCost = 5000; }
						case menuAmmuMinigun : { wID = WEAPON_MINIGUN; wAmmo = 100; wCost = 25000; }
						case menuAmmuSpraycan : { wID = WEAPON_SPRAYCAN; wAmmo = 50; wCost = 50; }
						case menuAmmuFireExtinguisher : { wID = WEAPON_FIREEXTINGUISHER; wAmmo = 50; wCost = 100; }
						case menuAmmuCamera : { wID = WEAPON_CAMERA; wAmmo = 20; wCost = 50; }
						case menuAmmuParachute : { wID = WEAPON_PARACHUTE; wAmmo = 1; wCost = 150; }
						case menuAmmuArmor : // if player want to buy armour
						{
							new Float:pArmour;
							GetPlayerArmour( playerid, pArmour );

							if
							(
								GetPlayerMoney(playerid) < 250 || // if player have no money
								pArmour >= 100.0 // or player already have enough armour
							)
							{
								showMenuForPlayer( playerid, menuClassAmmu, menuAmmuMain ); // show player main ammu menu
							}
							else
							{
								showMenuForPlayer( playerid, menuClassAmmu, menuAmmuMain ); // show player main ammu menu
								SetPlayerArmour( playerid, 100.0 ); // set player armour
								GivePlayerMoney( playerid, - 250 ); // take player's money
							}

							return;
						}
					}

					if ( GetPlayerMoney(playerid) < wCost ) // if player have no money
					{
						showMenuForPlayer( playerid, menuClassAmmu, menuAmmuMain ); // sho to player main ammu menu
					}
					else
					{
						ShowMenuForPlayer( plMenu, playerid ); // show player his current menu
						GivePlayerMoney( playerid, - wCost ); // take player's money
						GivePlayerWeapon( playerid, wID, wAmmo ); // give player selected weapon
					}
				}
			}
		}




		// it's one of ammu menus
		case menuClassEat :
		{
			// selecting current player's menu ID
			switch ( playerMenu[playerid][menuID] )
			{
				// selected one of the main menu rows
				case menuEatMain :
				{
					switch ( row )
					{
						case 0 : showMenuForPlayer( playerid, menuClassEat, menuEatPizza );
						case 1 : showMenuForPlayer( playerid, menuClassEat, menuEatChicken );
						case 2 : showMenuForPlayer( playerid, menuClassEat, menuEatSalad );
					}
				}

				// selected one of the buy menu rows
				case menuEatPizza..menuEatSalad :
				{
					new Float:pHealth, Float:eatHealth, eatCost;
					GetPlayerHealth( playerid, pHealth );

					switch ( playerMenu[playerid][menuID] )
					{
						case menuEatPizza : { eatHealth = 10.0; eatCost = 10; }
						case menuEatChicken : { eatHealth = 20.0; eatCost = 20; }
						case menuEatSalad : { eatHealth = 40.0; eatCost = 40; }
					}

					if
					(
						GetPlayerMoney(playerid) < eatCost || // if player have no money
						pHealth >= 100.0 // or player already have enough health
					)
					{
						showMenuForPlayer( playerid, menuClassEat, menuEatMain ); // show player main eat menu
					}
					else
					{
						ShowMenuForPlayer( plMenu, playerid ); // show player his current menu
						GivePlayerMoney( playerid, - eatCost ); // take player's money

						if ( ( pHealth + eatHealth ) > 100.0 ) eatHealth = 100.0 - pHealth;
						SetPlayerHealth( playerid, pHealth + eatHealth ); // set player health
					}
				}
			}
		}
	}
}




#undef plMenu
