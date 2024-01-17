
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
maze_maker_device := class(creative_device):
    @editable Spacing : float := 2.0
    @editable FullWidth : float := 512.0
    @editable WallDepth : float := 24.0
    @editable FloorHeight : float := 384.0
    @editable InitialLocation : teleporter_device = teleporter_device{};
    @editable MakeMazeButtonDevice: button_device = button_device{}
    @editable PlaceWallsDevice: place_walls_device = place_walls_device{}
    var AbstractMaze : maze = maze{}
    var MazeStartCellPerFloor : []maze_cell = array{}
    var WallPlacementCount : int = 0
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        MakeMazeButtonDevice.InteractedWithEvent.Subscribe(DesignAndBuildMaze)

    DesignAndBuildMaze(AgentIn : agent) : void =
        AbstractMaze.InitializeMaze()
        var CurrentStartPoint : maze_cell = maze_cell{}
        if (set CurrentStartPoint = AbstractMaze.Cells[0][0][0]) {}
        AbstractMaze.GenerateOneFloor(CurrentStartPoint, 0)
        TestDisplayMazeFloor(0)
        PlaceWallsDevice.SetupTransformStart()
        SpawnMazeWalls(0)
        #SpawnMazeWallsTest(0)
        return

    TestDisplayMazeFloor(FloorIn : int) : void =
        var XSize : int = AbstractMaze.XSize
        var YSize : int = AbstractMaze.YSize
        var CurrentCell : maze_cell = maze_cell{}
        for (IndexY := 0..YSize - 1):
            for (IndexX := 0..XSize-1):
                if (set CurrentCell = AbstractMaze.Cells[FloorIn][IndexY][IndexX]) {}
                Print("CellData: {CurrentCell.PrintCell()}")         
        return

    SpawnMazeWalls(FloorIn: int) : void =
        var XSize : int = AbstractMaze.XSize
        var YSize : int = AbstractMaze.YSize
        var CurrentCell : maze_cell = maze_cell{}
        var NorthVal : logic = false
        var EastVal : logic = false
        
        for (IndexY := 0..YSize - 1):
            for (IndexX := 0..XSize-1):
                if (set CurrentCell = AbstractMaze.Cells[FloorIn][IndexY][IndexX]) {}
                if (set NorthVal = CurrentCell.Walls[1]) {}
                if (set EastVal = CurrentCell.Walls[2]) {}
                PlaceWallsDevice.PlaceMazeSpot(IndexX, IndexY, FloorIn, 
                    NorthVal, EastVal)
                set WallPlacementCount = WallPlacementCount + 1
        return

    SpawnMazeWallsTest(FloorIn: int) : void =
        var XSize : int = AbstractMaze.XSize
        var YSize : int = AbstractMaze.YSize
        var CurrentCell : maze_cell = maze_cell{}
        var NorthVal : logic = false
        var EastVal : logic = false
        var SouthVal : logic = false
        var WestVal : logic = false
        
        for (IndexY := 0..YSize - 1):
            for (IndexX := 0..XSize-1):
                if (set CurrentCell = AbstractMaze.Cells[FloorIn][IndexY][IndexX]) {}
                if (set NorthVal = CurrentCell.Walls[1]) {}
                if (set EastVal = CurrentCell.Walls[2]) {}
                if (set SouthVal = CurrentCell.Walls[3]) {}
                if (set WestVal = CurrentCell.Walls[0]) {}
                Print("IndexX : {IndexX}, IndexY : {IndexY}")
                PlaceWallsDevice.PlaceMazeSpotTest(IndexX, IndexY, FloorIn, 
                    NorthVal, EastVal, SouthVal, WestVal)
                set WallPlacementCount = WallPlacementCount + 1
        return

    