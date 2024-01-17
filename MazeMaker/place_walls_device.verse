
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
place_walls_device := class(creative_device):
    @editable Spacing : float := 2.0
    @editable FullWidth : float := 512.0
    @editable WallDepth : float := 24.0
    @editable FloorHeight : float := 384.0
    @editable WallToPlace : creative_prop_asset = DefaultCreativePropAsset;
    @editable FloorToPlace : creative_prop_asset = DefaultCreativePropAsset;
    @editable InitialLocation : vector3 = vector3{};
    var CeilingOffset : vector3 = vector3{}
    var FloorOffset : vector3 = vector3{}
    var WestOffset : vector3 = vector3{}
    var EastOffset : vector3 = vector3{}
    var SouthOffset : vector3 = vector3{}
    var NorthOffset : vector3 = vector3{}
    var InitialTransform : transform = transform{}
    var CeilingFloorRotation : rotation = rotation{}
    var WestRotation : rotation = rotation{}
    var NorthRotation : rotation = rotation{}
    var EastRotation : rotation = rotation{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Print("Here we go with the placing of some wallz!")
        SetupOffsets()
        SetupRotations()
        SetupTransformStart()
        Print("InitialTransform Translation: {InitialTransform.Translation}")
        # PlaceCube()
        # PlaceWallOrFloorPiece(WallToPlace, vector3{ X := 0.0, Y := 0.0, Z := 1000.0 }, rotation{})

#Region Offset and Rotation Setup. In this region all the offsets for spawning walls are initialized. 
    SetupOffsets(): void=
        set CeilingOffset =  vector3{ X := FullWidth * 0.5,
            Y := 0.0, 
            Z := FloorHeight + WallDepth }
        set FloorOffset = vector3{ X := FullWidth * 0.5,
            Y := 0.0, 
            Z := 0.0 }
        set EastOffset =  vector3{ X := FullWidth ,
            Y := 0.0, 
            Z := WallDepth } 
        set WestOffset = vector3{ X := 0.0,
            Y := 0.0,
            Z := WallDepth }
        set NorthOffset =  vector3{ X := FullWidth * 0.5,
            Y := FullWidth * 0.5, 
            Z := WallDepth } 
        set SouthOffset =  vector3{ X := FullWidth * 0.5,
            Y := FullWidth * -0.5, 
            Z := WallDepth } 
        

    SetupRotations(): void=
        set CeilingFloorRotation = rotation{}
        set EastRotation = MakeRotationFromYawPitchRollDegrees(-90.0, 00.0, 00.0)
        set WestRotation = MakeRotationFromYawPitchRollDegrees(90.0, 00.0, 00.0)
        set NorthRotation = MakeRotationFromYawPitchRollDegrees(0.0, 00.0, 00.0)
        Print("WestRotation: Axis: {WestRotation.GetAxis()} Angle : {WestRotation.GetAngle()}")

    SetupTransformStart(): void=
        set InitialTransform = CalculateStartPoint(InitialLocation)
        Print("InitialTransform Translation: {InitialTransform.Translation}")


#EndRegion

    PlaceMazeSpot(XOffsetIn: int, YOffsetIn: int, ZOffsetIn: int, North: logic, East: logic) : void=
        StartTransform := GenerateStartTransformFromXYZ(XOffsetIn, YOffsetIn, ZOffsetIn)
        Print("StartTransform Translations: {StartTransform.Translation}, XOffset : {XOffsetIn}, YOffset : {YOffsetIn}")
        if (North=true):
            PlaceWallOrFloorPiece(WallToPlace, 
                (StartTransform.Translation + NorthOffset), 
                StartTransform.Rotation.RotateBy( NorthRotation ))
        if (East=true):
            PlaceWallOrFloorPiece(WallToPlace, 
                (StartTransform.Translation + EastOffset),
                StartTransform.Rotation.RotateBy( EastRotation))
        return

    PlaceMazeSpotTest(XOffsetIn: int, YOffsetIn: int, ZOffsetIn: int, North: logic, East: logic, South: logic, West: logic) : void =
        StartTransform := GenerateStartTransformFromXYZ(XOffsetIn, YOffsetIn, ZOffsetIn)
        Print("StartTransform Translations: {StartTransform.Translation}")
        if (North=true):
            PlaceWallOrFloorPiece(WallToPlace, 
                (StartTransform.Translation + NorthOffset), 
                StartTransform.Rotation.RotateBy( NorthRotation ))
        if (East=true):
            PlaceWallOrFloorPiece(WallToPlace, 
                (StartTransform.Translation + EastOffset),
                StartTransform.Rotation.RotateBy( EastRotation))
        if (South=true):
            PlaceWallOrFloorPiece(WallToPlace, 
                (StartTransform.Translation + SouthOffset), 
                IdentityRotation())
        if (West=true):
            PlaceWallOrFloorPiece(WallToPlace, 
                (StartTransform.Translation + WestOffset),
                StartTransform.Rotation.RotateBy( WestRotation))
        return

    GenerateStartTransformFromXYZ(XOffsetIn: int, YOffsetIn : int, ZOffsetIn: int) : transform =
        Print("Generating Start Transform Offset : {InitialLocation} ")
        var StartTransform : transform = transform{ Scale := vector3{X:=1.0,Y:= 1.0, Z:= 1.0},
            Rotation := IdentityRotation(),
            Translation := vector3{X := InitialLocation.X + (XOffsetIn * FullWidth),
                Y := (InitialLocation.Y + (YOffsetIn * FullWidth)), 
                Z := InitialLocation.Z + (ZOffsetIn * FloorHeight) + (ZOffsetIn * WallDepth)}
            }
        return StartTransform

    PlaceCeiling(TransformIn : transform) : void =
        Print("Placing Ceiling!")
        PlaceWallOrFloorPiece(FloorToPlace, 
            TransformIn.Translation + CeilingOffset,
            TransformIn.Rotation.RotateBy( CeilingFloorRotation))
        return 

    PlaceFloor(TransformIn : transform) : void = # ?creative_device =
        Print("Placing Floor!")
        PlaceWallOrFloorPiece(FloorToPlace, 
            TransformIn.Translation + FloorOffset,
            TransformIn.Rotation.RotateBy( CeilingFloorRotation))
        return 

    PlaceAllNonStartingWalls(TransformIn : transform) : void = #?creative_device =
        Print("Placing Some Walls! ")
        PlaceWallOrFloorPiece(WallToPlace, 
            TransformIn.Translation + NorthOffset, 
            TransformIn.Rotation.RotateBy( NorthRotation))
        PlaceWallOrFloorPiece(WallToPlace, 
            TransformIn.Translation + SouthOffset,
            TransformIn.Rotation)
        PlaceWallOrFloorPiece(WallToPlace, 
            TransformIn.Translation + WestOffset,
            TransformIn.Rotation.RotateBy( WestRotation))
        PlaceWallOrFloorPiece(WallToPlace, 
            TransformIn.Translation + EastOffset,
            TransformIn.Rotation.RotateBy( EastRotation))
        return 
            
    CalculateStartPoint(TranslationIn : vector3) : transform =
        var PivotTransform : transform = transform{ Scale := {1.0,1.0,1.0}, Rotation:= IdentityRotation()
            Translation := vector3{ X := TranslationIn.X - FullWidth / 2.0,
             Y := TranslationIn.Y- WallDepth / 2.0, 
             Z := TranslationIn.Z - FloorHeight / 2.0 } 
        }
        return PivotTransform

    PlaceWallOrFloorPiece(PropIn: creative_prop_asset, TranslationIn: vector3, RotationIn: rotation): void =
        Result := SpawnProp(PropIn, TranslationIn, RotationIn)
        return

    SpawnPropResultToString(SpawnPropResultIn : spawn_prop_result): string =
        case (SpawnPropResultIn):
            spawn_prop_result.Ok => return "Ok"
            spawn_prop_result.UnknownError => return "UnknownError"
            spawn_prop_result.InvalidSpawnPoint => return "InvalidSpawnPoint"
            spawn_prop_result.SpawnPointOutOfBounds => return "SpawnPointOutOfBounds"
            spawn_prop_result.InvalidAsset => return "InvalidAsset"
            spawn_prop_result.TooManyProps => return "TooManyProps"
            # spawn_prop_result.
    

    