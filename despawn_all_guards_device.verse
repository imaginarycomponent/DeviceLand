
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
despawn_all_guards_device := class(creative_device):
    @editable DespawnButton : button_device = button_device{}
    @editable GuardSpawnerOne : guard_spawner_device = guard_spawner_device{}
    @editable GuardSpawnerTwo : guard_spawner_device = guard_spawner_device{}


    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        DespawnButton.InteractedWithEvent.Subscribe(DespawnAllGuards)

    DespawnAllGuards(AgentIn : agent) : void =
        GuardSpawnerOne.Despawn()
        GuardSpawnerTwo.Despawn()
        