
using { /Fortnite.com/Devices }
using { /Fortnite.com/Teams } 
using { /Fortnite.com/Playspaces }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


# A Verse-authored creative device that can be placed in a level
color_switch_manager := class(creative_device):


    @editable ManagedTile : color_changing_tiles_device := color_changing_tiles_device{}
    @editable Prop_Manipulator : prop_manipulator_device := prop_manipulator_device{}
    @editable TeamOne : int := 1
    @editable TeamTwo : int := 2
    @editable ScoreManager : score_manager_device := score_manager_device{}
    var CurrentTeamIndex : int := -1
 
    OnBegin<override>()<suspends>:void=
        Prop_Manipulator.DamagedEvent.Subscribe(ProcessHitPropManipulatorTarget)

    ProcessHitPropManipulatorTarget(AgentIn : agent):void= 
        Print("Hit taken by prop")
        AgentTeam := GetAgentTeam(AgentIn)
        Print ("Current Team: {CurrentTeamIndex} ; AgentTeamIndex: {AgentTeam}")
        if (CurrentTeamIndex <> AgentTeam):
            set CurrentTeamIndex = AgentTeam
            ProcessChangeColor(AgentIn)
        Prop_Manipulator.RestoreHealth()

    GetAgentTeam(AgentIn : agent) : int =
        if:
            TeamCollection := GetPlayspace().GetTeamCollection()
            Team := TeamCollection.GetTeam[AgentIn] 
            TeamIndex := TeamCollection.GetTeams().Find[Team]
        then:
            return TeamIndex
        return -1

    ProcessChangeColor(AgentIn: agent): void=
        ManagedTile.SetTeam(AgentIn)
        ScoreManager.Activate(AgentIn)

    ResetAll(): void=
        ManagedTile.Reset()
        set CurrentTeamIndex = -1