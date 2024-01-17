
using { /Fortnite.com/Devices }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }



# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
smash_box_device := class(creative_device):

    var CurrentFire : int = 0
    var CurrentFortCharacter : []player = array{}
    var CurrentBoxes : []creative_prop = array{}
    var ClassSelector : class_selector_ui_device = class_selector_ui_device{}
    var BurnDist : float = 10.0

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        ClassSelector.ClassSelectedEvent.Subscribe(AddPlayer)

    CheckPlayerDistance<private>(InFortCharacter : fort_character, CurrentBox : int)<suspends> : logic=
        #if (InFortCharacter.GetTargetDistance(CurrentBoxes[CurrentBox] < BurnDist)):
        #    Print("Burna Da Box.")
        #    return true
        return false

    AddPlayer(InPlayer : agent):void=
        AllPlayers := GetPlayspace().GetPlayers()
        #Player := AllPlayers[InPlayer]
        #FortCharacter := Player.GetFortCharacter[]
        #set CurrentFortCharacter = CurrentFortCharacter + FortCharacter
