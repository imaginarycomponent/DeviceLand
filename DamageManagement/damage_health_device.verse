
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
damage_health_device := class(creative_device):
    @editable ButtonIn : button_device = button_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        ButtonIn.InteractedWithEvent.Subscribe(DamagePlayerHealth)

    DamagePlayerHealth(AgentIn: agent) : void =
        if (MyPlayer := AgentIn.GetFortCharacter[]):
            MyPlayer.SetHealth(0.0)