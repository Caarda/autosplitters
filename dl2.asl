state("flashplayer_32_sa") {
	int scene : 0xC95B64, 0x24, 0xA8C, 0x4, 0x2C, 0x50, 0x264, 0x4C;
}

init {
	vars.currRunState = 0;
	vars.prevRunState = 0;
	vars.tourneyEnd = false;
}

startup {
	refreshRate = 100;

	settings.Add("minigames", false, "Split when entering or exiting minigames.");
	settings.CurrentDefaultParent = "minigames";
	settings.Add("12", false, "Enter Flying");
	settings.Add("15", false, "Enter Running");
	settings.Add("18", false, "Enter Swimming");
	settings.Add("21", false, "Enter Climbing");

	settings.Add("100", false, "Exit Flying");
	settings.Add("101", false, "Exit Running");
	settings.Add("102", false, "Exit Swimming");
	settings.Add("103", false, "Exit Climbing");

	settings.CurrentDefaultParent = null;

	settings.Add("finals", false, "Split when finishing area finals.");
	settings.CurrentDefaultParent = "finals";
	settings.Add("30", false, "Scotland");
	settings.Add("37", false, "England");
	settings.Add("44", false, "Egypt");
	settings.Add("51", false, "Hawaii");
	settings.Add("56", false, "Japan");

	settings.SetToolTip("minigames", "These are intended for No Tab and Any% No Major Glitches.");
	settings.SetToolTip("finals", "These are intended for ALU, (note all runs use flagpole timing).");
}

update {
	vars.prevRunState = vars.currRunState;

	if (old.scene == 12 && current.scene == 12) {vars.currRunState = 2;} 		// In Flying
	else if (old.scene == 13 && current.scene == 13 && vars.prevRunState == 2) {vars.currRunState = 2;} //r
	else if (old.scene == 11 && current.scene == 11 && vars.prevRunState == 2) {vars.currRunState = 2;} //r

	else if (old.scene == 15 && current.scene == 15) {vars.currRunState = 3;} 	// In Running
	else if (old.scene == 16 && current.scene == 16 && vars.prevRunState == 3) {vars.currRunState = 3;} //r
	else if (old.scene == 14 && current.scene == 14 && vars.prevRunState == 3) {vars.currRunState = 3;} //r

	else if (old.scene == 18 && current.scene == 18) {vars.currRunState = 4;} 	// In Swimming
	else if (old.scene == 19 && current.scene == 19 && vars.prevRunState == 4) {vars.currRunState = 4;} //r
	else if (old.scene == 17 && current.scene == 17 && vars.prevRunState == 4) {vars.currRunState = 4;} //r

	else if (old.scene == 21 && current.scene == 21) {vars.currRunState = 5;} 	// In Climbing
	else if (old.scene == 22 && current.scene == 22 && vars.prevRunState == 5) {vars.currRunState = 5;} //r
	else if (old.scene == 20 && current.scene == 20 && vars.prevRunState == 5) {vars.currRunState = 5;} //r

	else if (old.scene == 8 && current.scene == 8) {vars.currRunState = 6; vars.tourneyEnd = false;} // In menu 
}

start {
	if (old.scene == 7 && current.scene == 8) {
		vars.currRunState = 6;
		vars.tourneyEnd = false;
		return true;
	}
}

split {
	// Split for finishing tournaments
	if (settings[current.scene.ToString()] && current.scene == old.scene && vars.tourneyEnd == false) {
		if (current.scene == 30 || current.scene == 37 || current.scene == 44 || current.scene == 51 || current.scene == 56) {
			vars.tourneyEnd = true;
			return true;
		}
	}

	// Split for entering minigames
	if (vars.currRunState == 2 && vars.prevRunState != 2) {
		return settings["12"];
	} else if (vars.currRunState == 3 && vars.prevRunState != 3) {
		return settings["15"];
	} else if (vars.currRunState == 4 && vars.prevRunState != 4) {
		return settings["18"];
	} else if (vars.currRunState == 5 && vars.prevRunState != 5) {
		return settings["21"];
	}

	// Split for exiting minigames
	if (vars.currRunState != 2 && vars.prevRunState == 2) {
		return settings["100"];
	} else if (vars.currRunState != 3 && vars.prevRunState == 3) {
		return settings["101"];
	} else if (vars.currRunState != 4 && vars.prevRunState == 4) {
		return settings["102"];
	} else if (vars.currRunState != 5 && vars.prevRunState == 5) {
		return settings["103"];
	}
}