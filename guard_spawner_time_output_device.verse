
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
guard_spawner_time_output_device := class(creative_device):

    @editable SpawnOneTimer :timer_device = timer_device{}
    @editable SpawnTwoTimer :timer_device = timer_device{}
    @editable GuardSpawnerOne : guard_spawner_device = guard_spawner_device{}
    @editable GuardSpawnerTwo : guard_spawner_device = guard_spawner_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        GuardSpawnerOne.SpawnedEvent.Subscribe(ResetAndStartTimerOne)
        GuardSpawnerTwo.SpawnedEvent.Subscribe(ResetAndStartTimerTwo)
        return

    ResetAndStartTimerOne(CurrentAgent:agent):void=
        ResetAndStartTimer(SpawnOneTimer)

    ResetAndStartTimerTwo(CurrentAgent:agent):void=
        ResetAndStartTimer(SpawnTwoTimer)
    
    ResetAndStartTimer(TimerDevice: timer_device):void=
        TimerDevice.Reset()
        TimerDevice.Start()