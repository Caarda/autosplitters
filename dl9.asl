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
        return true;
    });
}

isLoading
{
    return current.isLoading;
}