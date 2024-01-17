
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
player_counter_manager_device := class(creative_device):

    @editable var PlayerCounterDevice : player_counter_device := player_counter_device{}
    @editable var AddPlayerButton : button_device := button_device{}
    @editable var AddTenPlayerButton : button_device := button_device{}
    @editable var ClearPlayerButton : button_device := button_device{}
    
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Player Counter Manager Device OnBegin!")
        AddPlayerButton.InteractedWithEvent.Subscribe(AddPlayer)
        AddTenPlayerButton.InteractedWithEvent.Subscribe(AddTenPlayer)
        ClearPlayerButton.InteractedWithEvent.Subscribe(Reset)
        
    AddPlayer(Agent: agent):void =
        PlayerCounterDevice.IncrementTargetCount()

    AddTenPlayer(Agent: agent): void =
        for (step := 0..9):
            PlayerCounterDevice.IncrementTargetCount()
            
    Reset(Agent: agent): void =
        PlayerCounterDevice.Reset()



