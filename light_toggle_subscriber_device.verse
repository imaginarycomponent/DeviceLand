
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
light_toggle_subscriber_device := class(creative_device):

    @editable EliminationWatcher : guard_elimination_watcher_device = guard_elimination_watcher_device{}
    @editable LightDevice : customizable_light_device = customizable_light_device{} 

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        spawn{Subscribe(EliminationWatcher)}

    Subscribe(TaggedDevice:guard_elimination_watcher_device)<suspends>:void=
        TaggedDevice.GuardEliminatedEvent.Await()
        spawn{Subscribe(TaggedDevice)} #if retriggerable
        ToggleLight()

    ToggleLight() : void = 
        LightDevice.Toggle()