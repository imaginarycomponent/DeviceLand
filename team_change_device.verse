using { /Fortnite.com/Devices }
using { /Fortnite.com/Teams }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

team_change_device := class(creative_device):

    # Connect this trigger device to your event of choice
    @editable
    Button : button_device = button_device{} 

    # Choose the team to change to
    @editable
    var Team : int = 1

    OnBegin<override>()<suspends>:void=

        Button.InteractedWithEvent.Subscribe(ChangeTeams)

    ChangeTeams(Agent : agent):void=
        if:
            TeamCollection := GetPlayspace().GetTeamCollection()
            Teams : []team = TeamCollection.GetTeams()
            TeamCollection.AddToTeam[Agent, Teams[Team-1]]