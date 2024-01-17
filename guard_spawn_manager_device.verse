
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
guard_spawn_manager_device := class(creative_device):

    @editable ThreatLevelManager : threat_level_manager_device := threat_level_manager_device{}
    @editable GuardSpawner : []guard_spawner_device := array{}
    @editable SniperSpawner : []guard_spawner_device := array{}
    # This is a magic number. Cope.
    @editable TeamNumber : int := 1
    var LastSpawnTime : float := 0.0
    var LastSniperSpawnTime : float := 0.0
    var SpawnInterval : float := 15.0
    # Sniper spawn interval is used directly without any modification.
    var SniperSpawnInterval : float := 30.0

    OnBegin<override>()<suspends>:void=
        Task := spawn{(RecursiveCheckSpawnsNecessaryAndSpawn())}
        return

    RemoveAllGuards():void=
        for (Index := 0..GuardSpawner.Length - 1):
            if (Element := GuardSpawner[Index]):
                #Print ("Theoretical Guard Spawning")
                Element.Despawn()
        return

    RecursiveCheckSpawnsNecessaryAndSpawn()<suspends>:void =
        SetSpawnsForThreatLevel()
        if ((GetSimulationElapsedTime() - LastSpawnTime) > SpawnInterval):
            SpawnGuardSet()
        if ((GetSimulationElapsedTime() - LastSniperSpawnTime) > SniperSpawnInterval):
            SpawnSniperSet()
        Sleep(1.0)
        Task := spawn{(RecursiveCheckSpawnsNecessaryAndSpawn())}
        

    SpawnGuardSet():void =
        for (Index := 0..GuardSpawner.Length - 1):
            if (Element := GuardSpawner[Index]):
                #Print ("Theoretical Guard Spawning")
                Element.Spawn()
        set LastSpawnTime = GetSimulationElapsedTime()

    SpawnSniperSet():void =
        for (Index := 0..SniperSpawner.Length - 1):
            if (Element := SniperSpawner[Index]):
                #Print ("Theoretical Sniper Spawning")
                Element.Spawn()
        set LastSniperSpawnTime = GetSimulationElapsedTime()
    

    SetSpawnsForThreatLevel():void=
        ThreatLevel : int = ThreatLevelManager.GetCurrentThreatLevel(TeamNumber)
        # Print("Threat Level set. Threat Level : {ThreatLevel} Team Number: {TeamNumber}")
        if (ThreatLevel = 6):
            set SpawnInterval = 7.0
            return
        if (ThreatLevel = 5):
            set SpawnInterval = 10.0
            return
        if (ThreatLevel = 4):
            set SpawnInterval = 14.0
            return
        if (ThreatLevel = 3):
            set SpawnInterval = 18.0
            return
        if (ThreatLevel = 2):
            set SpawnInterval = 20.0
            return
        if (ThreatLevel = 1):
            set SpawnInterval = 30.0
            return
        set SpawnInterval = 999.0
            return
                                                                                            