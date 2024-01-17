using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

prop_rotator_device := class(creative_device):

    @editable var PropToRotate : creative_prop = creative_prop{}
    @editable var RotateYaw : float = 0.0
    @editable var RotatePitch : float = 0.0
    @editable var RotateRoll : float = 0.0
    @editable var RotateTime : float = 1.0
    @editable var RepeatRotate : logic = true

    OnBegin<override>()<suspends>:void=
        spawn:
            RotateProp(PropToRotate)

    RotateProp<private>(Prop : creative_prop)<suspends> : void=
        Transform := Prop.GetTransform()
        Position := Transform.Translation
        Rotation := Transform.Rotation
        var RotationAmount : rotation = Rotation
        if (RotateYaw <>0.0, set RotationAmount = RotationAmount.ApplyYaw(RotateYaw)) {}
        if (RotatePitch <>0.0, set RotationAmount = RotationAmount.ApplyPitch(RotatePitch)) {}
        if (RotateRoll <>0.0, set RotationAmount = RotationAmount.ApplyRoll(RotateRoll)) {}
        MoveResult := Prop.MoveTo(Position, RotationAmount, RotateTime)
        if (MoveResult = move_to_result.DestinationReached and RepeatRotate):
            RotateProp(Prop)
    