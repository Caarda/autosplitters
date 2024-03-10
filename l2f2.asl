state("flashplayer_32_sa") {
	int scene : 0xC95B64, 0x24, 0xA8C, 0x4, 0x2C, 0x50, 0x264, 0x4C;
}

startup {
	refreshRate = 33;

	vars.gameMode = "";
	vars.currentDay = 0;
	vars.splitDays = new int[] { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 };

	settings.Add("anySplits", true, "Enables splits (Please only use one split file).");
	settings.Add("endDay", true, "Use a split file that splits upon ending each day.", "anySplits");
	settings.Add("SR_1", false, "Use a split file for Story Mode that follows the current WR route.", "anySplits");

	settings.Add("Story", false, "Split when starting or ending Story Mode.");
	settings.Add("Classic", false, "Split when starting or ending Classic Mode.");
}

update { print(current.scene.ToString()); }

start {
	if (current.scene == 10 && old.scene != 10 && settings["Story"])
		{
		vars.gameMode = "Story";
		vars.currentDay = -2;
		if (settings["SR_1"])
			{
			vars.splitDays[0] = 0;
			vars.splitDays[1] = 1;
			vars.splitDays[2] = 3;
			vars.splitDays[3] = 5;
		}
		return true;
	}
	else if (current.scene == 10 && old.scene != 10 && settings["Classic"])
		{
		vars.gameMode = "Classic";
		vars.currentDay = -2;
		return true;
	}
}

split {
	if (settings["endDay"])
		{
		if (old.scene == 10)
			{ 
			return current.scene != 10;
		}
	}
	else if (current.scene == 28)
		{
		return true;
	}
	else if (current.scene == 29)
		{
		return true;
	}
	else if (current.scene == 12 && old.scene != 12)
		{
		if (Array.IndexOf(vars.splitDays, vars.currentDay) > -1)
			{
			vars.currentDay += 1;
			return true;
		}
		else vars.currentDay += 1;
	}
}
