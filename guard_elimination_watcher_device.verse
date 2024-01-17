
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
guard_elimination_watcher_device := class(creative_device):

    GuardEliminatedEvent<public>:event() = event(){}
    @editable GuardSpawners : []guard_spawner_device = array{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        for (SpawnerDevice : GuardSpawners):
            SpawnerDevice.EliminatedEvent.Subscribe(CallGuardEliminatedEvent)

    CallGuardEliminatedEvent(InteractionResult: device_ai_interaction_result): void=
        GuardEliminatedEvent.Signal()

