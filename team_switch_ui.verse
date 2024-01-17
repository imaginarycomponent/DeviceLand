using { /Fortnite.com/Devices }
using { /Fortnite.com/Teams }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

team_switch_ui := class(creative_device):

    # Connect this trigger device to your event of choice



    OnBegin<override>()<suspends>:void=
        var x : int = 0

    ChangeTeams(Agent : agent, Team: int):void=
        if:
            TeamCollection := GetPlayspace().GetTeamCollection()
            Teams : []team = TeamCollection.GetTeams()
            TeamCollection.AddToTeam[Agent, Teams[Team-1]]
