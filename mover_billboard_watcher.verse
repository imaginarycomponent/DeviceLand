
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
mover_billboard_watcher_device := class(creative_device):

    @editable var PropMoverDevice : prop_mover_device := prop_mover_device{}
    @editable var PropBillboardDevice : billboard_device := billboard_device{}
    @editable var Moved_Prop : creative_prop = creative_prop{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Billboard Watcher Device OnBegin!")
        PropMoverDevice.MovementModeChangedEvent.Subscribe(SetNewDisplayString)

    SetNewDisplayString():void=
        # Print("Display String Changing")
        MovedPropTransform : transform := Moved_Prop.GetTransform()
        PropBillboardDevice.SetText(GenerateDisplayString(MovedPropTransform, PropMoverDevice))


    GenerateDisplayString(MovedPropTransformIn: transform, PropMoverDeviceIn: prop_mover_device):message=
        return StringToMessage(GetCurrentMoverPositionString(MovedPropTransformIn) + "\n" + GetCurrentMoverSpeed(PropMoverDeviceIn))
        
    GetCurrentMoverPositionString(MovedPropTransformIn: transform ) :string=
        return "Position: {MovedPropTransformIn.Translation.X}, " + 
         "{MovedPropTransformIn.Translation.Y}, {MovedPropTransformIn.Translation.Z}"

    GetCurrentMoverSpeed(PropMoverDeviceIn : prop_mover_device):string=
        return "Current Target Speed: {PropMoverDeviceIn.GetTargetSpeed()}"

    StringToMessage<localizes>(value:string) : message = "{value}"