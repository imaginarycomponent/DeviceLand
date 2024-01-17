
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
triangle_rotate_device := class(creative_device):
    @editable TestMode : logic = false
    @editable StartFacingDirection : rotation := rotation{}
    @editable var PropToRotate : creative_prop = creative_prop{}
    @editable RotationTime : float = 0.15
    var CurrentPosition : int = 0
    var BlockHits : logic = false 
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        SetupAxis()
        if (TestMode = true):
            branch{TestRotation()}
        return

    SetupAxis() : void =
        return


    TestRotation()<suspends> : void =
        Sleep(1.0)

        Sleep(1.0)

        Sleep(1.0)
        return

    RotatePropBlockHits(RotationTimeIn : float, Direction : int) <suspends>: void =
        set BlockHits = true
        Transform := PropToRotate.GetTransform()
        Position := Transform.Translation
        Rotation := Transform.Rotation

        Sleep(RotationTimeIn)
        set BlockHits = false
        return
