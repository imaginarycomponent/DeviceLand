
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

threat_level_manager_device := class(creative_device):

    @editable TeamOnePlayerCounter : player_counter_device := player_counter_device{}
    @editable TeamTwoPlayerCounter : player_counter_device := player_counter_device{}
    @editable TestingSetup : logic := false
    # NOTE : Ideally this code would be built to handle lots of teams, and use an array.
    # That would make it much more complex, because arrays are reassigned completely in Verse.
    var TeamCountOne : int = 0
    var TeamCountTwo : int = 0
    
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Threat Level Manager Device OnBegin!")
        TeamOnePlayerCounter.CountedEvent.Subscribe(AddTeamOneCount)
        TeamTwoPlayerCounter.CountedEvent.Subscribe(AddTeamTwoCount)
        TeamOnePlayerCounter.RemovedEvent.Subscribe(AddTeamOneCount)
        TeamTwoPlayerCounter.RemovedEvent.Subscribe(AddTeamTwoCount)
        
    # A testing function. If testing = true, the threat will be calculated with the target count
    # from the counters rather than the actual player count.
    
    GetCurrentThreatLevel<public>(TeamIn : int) : int =
        TeamCount: int = GetCurrentTeamCount(TeamIn)
        OpponentCount : int = GetOpposingTeamCount(TeamIn)
        return CalculateThreat(TeamCount, OpponentCount)
    
    # This ended up being simpler than I thought when I did the math on what I'd define the tiers with.
    CalculateThreat(TeamCountIn : int, OpponentCountIn : int) : int =
        var MemberCountRatio : float = ((TeamCountIn * 1.0) / (OpponentCountIn * 1.0))
        var TotalPlayerCount : int = TeamCountIn + OpponentCountIn
        if (TeamCountIn < 5 or MemberCountRatio < 0.25) then: 
            return 6
        if (TeamCountIn < 6 or MemberCountRatio < 0.4) then:
            return 5
        if (TeamCountIn < 7 or MemberCountRatio < 0.5) then: 
            return 4
        if (TeamCountIn < 8 or MemberCountRatio < 0.64) then: 
            return 3
        if (TeamCountIn < 10 or MemberCountRatio < 0.78) then: 
            return 2            
        if (TeamCountIn < 12 or MemberCountRatio < 0.9) then: 
            return 1
        else:
            return 0

    # I hate these two functions. I'd really like to get them chopped down, not sure how to do it.
    GetCurrentTeamCount<public>(TeamIn : int) : int =
        if (TestingSetup = true):
            if (TeamIn = 1):
                TeamOnePlayerCounter.GetTargetCount()
            else:
                TeamTwoPlayerCounter.GetTargetCount()
        else:
            if (TeamIn = 1):
                TeamCountOne
            else:
                TeamCountTwo

    GetOpposingTeamCount(TeamIn: int) : int =
        if (TestingSetup = true):
            if (TeamIn = 1):
                TeamTwoPlayerCounter.GetTargetCount()
            else:
                TeamOnePlayerCounter.GetTargetCount()
        else:
            if (TeamIn = 1):
                TeamCountTwo
            else:
                TeamCountOne


    GetTeamDiff(TeamIn : int) : int =

        if (TeamIn = 1):
            TeamCountOne - TeamCountTwo
        else:
            TeamCountTwo - TeamCountOne


    AddTeamOneCount(Agent: agent) : void =
        set TeamCountOne = TeamCountOne + 1

    AddTeamTwoCount(Agent: agent) : void =
        set TeamCountTwo = TeamCountTwo + 1
                    
    SubtractTeamOneCount(Agent: agent) : void =
        set TeamCountOne = TeamCountOne - 1

    SubtractTeamTwoCount(Agent: agent) : void =
        set TeamCountTwo = TeamCountTwo - 1
    