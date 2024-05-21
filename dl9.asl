state("Duck Life 9") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Duck Life 9";
    vars.Helper.LoadSceneManager = true;

    vars.tournamentWins = new bool[] {false, false, false, false, false, false, false, false, false, false};
    vars.areaNames = new Dictionary<int, string>() {
        {0, "The Flock"},
        {1, "Fishing Beach"},
        {2, "Spring Meadows"},
        {3, "Quackbeard's Cove"},
        {4, "Toadstool Towers"},
        {5, "Crystal Desert"},
        {6, "Sunflower Ravine"},
        {7, "Cloud Republic"},
        {8, "Volcano Town"},
        {9, "Volcano Interior"},
        {10, "News Room"},
    };

    settings.Add("credits", true, "Split on the final fadeout before the credits.");
    settings.Add("tournaments", false, "Split on tournament wins.");
    settings.Add("recruit", false, "Split on recruiting ducks.");
    settings.CurrentDefaultParent = "tournaments";
    for (int i = 2; i < 9; i++) {
        settings.Add(vars.areaNames[i], true);
    }
    settings.CurrentDefaultParent = "recruit";
    settings.Add("Walter", false);
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["isLoading"] = mono.Make<bool>("Wix.Transition", "transitioning");

        vars.Helper["duckList"] = mono.MakeList<IntPtr>("SaveData", "_profile", "flockDucks");
        vars.duckNameOffset = mono["Duck"]["name"];

        vars.Helper["visitedAreas"] = mono.MakeList<IntPtr>("SaveData", "_profile", "overworldAreas");
        vars.tournamentOffset = mono["OverworldArea"]["beatenTournamentChampion"];
        vars.areaObjectOffset = mono["OverworldArea"]["area"];
        vars.areaNameOffset = mono["Area"]["value__"];

        return true;
    });
}

split
{
    // Split on tournament wins.
    for (int i = 0; i < current.visitedAreas.Count; i++) {
        vars.areaIndex = vars.Helper.Read<int>(current.visitedAreas[i] + vars.areaObjectOffset + vars.areaNameOffset);
        vars.hasBeatenTournament = vars.Helper.Read<bool>(current.visitedAreas[i] + vars.tournamentOffset);

        if (vars.tournamentWins[vars.areaIndex] == false && vars.hasBeatenTournament) {
            vars.tournamentWins[vars.areaIndex] = true;
            print("Beaten " + vars.areaNames[vars.areaIndex] + " tournament!");
            return settings[vars.areaNames[vars.areaIndex]];
        }
    }

    // Split on duck recruitment.
    current.lastRecruitedDuck = vars.Helper.ReadString(current.duckList[current.duckList.Count - 1] + vars.duckNameOffset);
    if (current.lastRecruitedDuck != old.lastRecruitedDuck) {
        print("Recruited " + current.lastRecruitedDuck + "!");
        return settings[current.lastRecruitedDuck];
    }

    // Split on credits.
    return (vars.Helper.Scenes.Active.Name == "Credits" && settings["credits"]);
}

start 
{
    if (current.duckList.Count == 1 && old.duckList.Count == 0) {
        vars.tournamentWins = new bool[] {false, false, false, false, false, false, false, false, false, false};
        return true;
    }
}

isLoading
{
    return current.isLoading;
}

exit
{
    timer.IsGameTimePaused = true;
}