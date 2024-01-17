
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
prop_mover_manager := class(creative_device):

    @editable var PropMoverDevice : prop_mover_device := prop_mover_device{}
    @editable var ButtonDevice : button_device := button_device{}
    # NOTE: THIS MUST MATCH the initial state of the mover device. If it does not, the code will not work right the first runthrough.
    @editable var PropDeviceActive : logic := false

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Hello 2 + 2 = {2 + 2}")
        Print("{PropMoverDevice.GetTargetDistance()}  ,  {PropMoverDevice.GetTargetSpeed()} ")
        PropMoverDevice.EnabledEvent.Subscribe(SetDeviceActive)
        PropMoverDevice.DisabledEvent.Subscribe(SetDeviceInactive)
        ButtonDevice.InteractedWithEvent.Subscribe(ToggleDeviceMove)
        
    # Starts or stops prop_mover_device. This does not reset the movement of the device.
    ToggleDeviceMove(InPlayer : agent):void=
        Print("Device Move Toggle Entered")
        if (PropDeviceActive?):
            # Note: These lines look extraneous. They would be if you could get the current state of the device.
            set PropDeviceActive = false; 
            Print("Prop Mover Device Disabling.")
            PropMoverDevice.End()
        else:
            # Note: These lines look extraneous. They would be if you could get the current state of the device.
            set PropDeviceActive = true;
            Print("Prop Mover Device Enabling.")
            PropMoverDevice.Begin()

    # Enables or disables prop_mover_device. This resets the movement of the device, so it will not 'bounce' if set to do so before.
    # 
    EnableDisableDeviceMove(InPlayer : agent):void=
        Print("Device Move Toggle Entered")
        if (PropDeviceActive?):
            # Note: These lines look extraneous. They would be if you could get the current state of the device.
            set PropDeviceActive = false; 
            Print("Prop Mover Device Disabling.")
            PropMoverDevice.Disable()
        else:
            # Note: These lines look extraneous. They would be if you could get the current state of the device.
            set PropDeviceActive = true;
            Print("Prop Mover Device Enabling.")
            PropMoverDevice.Enable()
        
    SetDeviceActive(): void=
        set PropDeviceActive = true;

    SetDeviceInactive() : void=
        set PropDeviceActive = false;