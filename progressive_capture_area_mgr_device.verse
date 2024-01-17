
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/Diagnostics }

# A Verse-authored creative device that can be placed in a level
progressive_capture_areas_mgr_device := class(creative_device):

    @editable var ClockwiseCaptureArea : capture_area_device := capture_area_device{}
    @editable var ClockwiseItemSpawner : capture_item_spawner_device := capture_item_spawner_device{}
    @editable var CounterClockwiseCaptureArea : capture_area_device := capture_area_device{}
    @editable var CounterClockwiseItemSpawner : capture_item_spawner_device := capture_item_spawner_device{}
    @editable var PrimaryCaptureArea : capture_area_device := capture_area_device{}
    @editable var PrimaryItemSpawner : capture_item_spawner_device := capture_item_spawner_device{}
    # @editable var CaptureAreaDataManager : capture_area_data_manager_device := capture_area_data_manager_device{}
    @editable var TeamID : int := 1


    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Billboard Watcher Device OnBegin!")
        ClockwiseCaptureArea.ItemIsDeliveredEvent.Subscribe(CaptureClockwiseArea)
        CounterClockwiseCaptureArea.ItemIsDeliveredEvent.Subscribe(CaptureCounterClockwiseArea)
        PrimaryCaptureArea.ItemIsDeliveredEvent.Subscribe(CapturePrimaryArea)

    
    CaptureClockwiseArea(AgentIn: agent):void=
        CaptureProgressiveArea(ClockwiseCaptureArea, ClockwiseItemSpawner, AgentIn)

    CaptureCounterClockwiseArea(AgentIn: agent):void=
        CaptureProgressiveArea(CounterClockwiseCaptureArea, CounterClockwiseItemSpawner, AgentIn)
            
    CaptureProgressiveArea(CaptureAreaDeviceIn: capture_area_device, ItemSpawner : capture_item_spawner_device , AgentIn : agent):void=
        Print("Progressive Area Capture Complete.")
        CaptureAreaDeviceIn.DisallowCapture()
        ItemSpawner.Enable()
    
    CapturePrimaryArea(AgentIn : agent):void=
        Print("Primary Capture Achived. Disabling Secondary Spawners, enabling secondary captures.")
        ClockwiseItemSpawner.Disable()
        CounterClockwiseItemSpawner.Disable()
        ClockwiseCaptureArea.AllowCapture()
        CounterClockwiseCaptureArea.AllowCapture()
        
    RaiseScorePoints(AgentIn : agent, PointsScored : int):void=
        Print("Points Scored! PointsScored : {PointsScored} ")
        # CaptureAreaDataManager.ScorePointsForAgent(AgentIn, PointsScored, TeamID)
