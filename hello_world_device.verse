
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
hello_world_device := class(creative_device):

    @editable var SpinningAsset : creative_prop_asset := DefaultCreativePropAsset
    @editable var MeshToMove : creative_prop = creative_prop{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Hello, We Are Moving this Asset!")
        # var pos MeshToMove.
        