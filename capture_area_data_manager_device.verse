
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

capture_area_data_manager_device := class(creative_device):

    @editable ScoreManagerDevice : score_manager_device := score_manager_device{}

    ScorePointsForAgent<public> (AgentIn : agent, PointsIn : int, TeamIDIn : int):void=
        ScoreManagerDevice.SetScoreAward(PointsIn)
        ScoreManagerDevice.Activate(AgentIn)
