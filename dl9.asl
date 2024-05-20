state("Duck Life 9") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Duck Life 9";
    vars.Helper.LoadSceneManager = true;

    settings.Add("credits", true, "Split on the final fadeout before the credits.");
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["isLoading"] = mono.Make<bool>("Wix.Transition", "transitioning");
        vars.Helper["duckList"] = mono.MakeList<IntPtr>("SaveData", "_profile", "flockDucks");
        // vars.Helper["latestUnlockedArea"] = mono.Make<int>("SaveData", "_profile", "currentArea", "value__");
        return true;
    });
}

split
{
    return (vars.Helper.Scenes.Active.Name == "Credits" && settings["credits"]);
}

start 
{
    return (current.duckList.Count == 1 && old.duckList.Count == 0);
}

isLoading
{
    return current.isLoading;
}