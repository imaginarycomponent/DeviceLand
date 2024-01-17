
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
teleport_up_device := class(creative_device):

    @editable TeleportButton : button_device = button_device{}
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        TeleportButton.InteractedWithEvent.Subscribe(TeleportVictim)

    TeleportVictim(AgentIn : agent) : void =
        if (FortChar := AgentIn.GetFortCharacter[]):
             PlayerTrans := FortChar.GetTransform().Translation
             PlayerNewPos := vector3 {
                X:= PlayerTrans.X, 
                Y:= PlayerTrans.Y, 
                Z:= PlayerTrans.Z + 10000.0
                }
            if (FortChar.TeleportTo[PlayerNewPos, IdentityRotation()]) {}
        
