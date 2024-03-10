state("flashplayer_32_sa") {
	int scene : 0xC95B64, 0x24, 0xA8C, 0x4, 0x2C, 0x50, 0x264, 0x4C;
}

startup {
	refreshRate = 100;

	settings.Add("22-23", false, "1-1");
	settings.Add("24-25", false, "1-2");
	settings.Add("26-27", false, "1-3");
	settings.Add("28-29", false, "1-4");
	settings.Add("31-32", false, "2-1");
	settings.Add("33-34", false, "2-2");
	settings.Add("35-36", false, "2-3");
	settings.Add("37-38", false, "2-4");
	settings.Add("40-41", false, "3-1");
	settings.Add("42-43", false, "3-2");
	settings.Add("44-45", false, "3-3");
	settings.Add("46-47", false, "3-4");
	settings.Add("51-52", true, "Split upon beating the Champion.");
}

start {
	return current.scene != 10 && old.scene == 10;
}

split {
	return settings[old.scene.ToString() + "-" + current.scene.ToString()];
}
