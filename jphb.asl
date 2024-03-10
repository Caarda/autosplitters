state("Jumphobia Homeward Bound") {
	float sceneTime : "mono-2.0-bdwgc.dll", 0x0A69FB8, 0x278, 0xC70, 0x420, 0xFC8, 0x618;
	float resultsTime : "mono-2.0-bdwgc.dll", 0x0A69FB8, 0x278, 0xC70, 0x420, 0xFC8, 0x61C;
	float startCheck : "mono-2.0-bdwgc.dll", 0x07CA5C0, 0x990, 0x750;
}

init {
	vars.totalTime = 0.0;
	refreshRate = 100;
}

isLoading {
	return true;
}

gameTime {
	return new TimeSpan(0, 0, 0, 0, Convert.ToInt32(10*Math.Truncate(vars.totalTime*100 + current.sceneTime*100)));
}

split {
	if (current.sceneTime == 0 && old.sceneTime != 0 ) {
		vars.totalTime += old.sceneTime;
	}
	return (old.resultsTime != current.resultsTime && current.resultsTime != 0);
}

start {
	if (current.startCheck != 0) {
		vars.totalTime = 0.0;
		return current.sceneTime == 0;
	}
}
