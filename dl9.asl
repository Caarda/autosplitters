state("Duck Life 9") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["isLoading"] = mono.Make<bool>("Wix.Transition", "transitioning");
        vars.Helper["duckList"] = mono.MakeList<IntPtr>("SaveData", "_profile", "flockDucks");
        return true;
    });
}

start 
{
    return (current.duckList.Count == 1 && old.duckList.Count == 0);
}

isLoading
{
    return current.isLoading;
}