using { /Verse.org/Random }

direction := enum {west, north, east, south}
ToInt(DirIn : direction): int =
    case (DirIn):
        direction.west => 0
        direction.north => 1
        direction.east => 2
        direction.south => 3

# A cell in a 2D maze
maze_cell := class():
    var Xloc : int = 0
    var Yloc : int = 0
    var Zloc : int = 0
    var Visited : logic = false
    var Walls : []logic := {true, true, true, true} 

    GetVisited() : string = 
        if (Visited = true):
            return "true"
        return "false"

    WallsToString(): string =
        var CurrentString : string = ""
        if (Walls[0] = true):
            set CurrentString = CurrentString + "West "
        if (Walls[1] = true):
            set CurrentString = CurrentString + "North "
        if (Walls[2] = true):
            set CurrentString = CurrentString + "East "
        if (Walls[3] = true):
            set CurrentString = CurrentString + "South "
        return CurrentString

    PrintCell(): string =
        var CurrentString : string = ""
        set CurrentString = CurrentString + "Xloc: {Xloc} Yloc: {Yloc}, Zloc: {Zloc}, Visited: {GetVisited()}, Walls: {WallsToString()}"
        return CurrentString

maze := class():
    var Cells : [][][]maze_cell := array{} # Note: This is organized by [Z][Y][X]
    var XSize : int = 8
    var YSize : int = 8
    var ZSize : int = 4
    
    GetXYCells(ZIn : int) : ?[][]maze_cell =
        return option{Cells[ZIn]}

    GetSize() : tuple(int, int, int) = 
        return (XSize, YSize, ZSize)
    
    InitializeMaze() : void =
        var Count : int = 0
        Print("Maze Initializing.")
        set Cells  =
            for (IndexZ := 0..ZSize - 1):
                for (IndexY := 0..YSize - 1):
                    for (IndexX := 0..XSize-1):
                        maze_cell{Xloc:= IndexX, Yloc:= IndexY, Zloc:= IndexZ,
                            Visited:=false}
        for (IndexZ := 0..ZSize - 1):
            for (IndexY := 0..YSize - 1):
                for (IndexX := 0..XSize-1):
                    if (CurrentCell := Cells[IndexZ][IndexY][IndexX]):
                        CleanExternalWalls(CurrentCell)


    CleanExternalWalls(MazeCell: maze_cell): void =
        if(MazeCell.Xloc = 0):
            if (set MazeCell.Walls[0] = false) {}
        if(MazeCell.Xloc = XSize - 1):
            if (set MazeCell.Walls[2] = false) {}
        if(MazeCell.Yloc = 0):
            if (set MazeCell.Walls[3] = false) {}
        if(MazeCell.Yloc = YSize - 1):
            if (set MazeCell.Walls[1] = false) {}

    
    GetUnvisitedNeighbors2D(CurrentCell : maze_cell) : []maze_cell =
        var UnvisitedNeighbors : []maze_cell = array{}
        if (CurrentCell.Xloc > 0 and 
            (Cells[CurrentCell.Zloc][CurrentCell.Yloc][CurrentCell.Xloc-1]).Visited <> true):
                if (CellToAdd := Cells[CurrentCell.Zloc][CurrentCell.Yloc][CurrentCell.Xloc-1]):
                    set UnvisitedNeighbors = UnvisitedNeighbors + array{CellToAdd}
        if (CurrentCell.Xloc < (XSize-1) and 
            ((Cells[CurrentCell.Zloc][CurrentCell.Yloc][CurrentCell.Xloc+1]).Visited <> true) ):
                if (CellToAdd := Cells[CurrentCell.Zloc][CurrentCell.Yloc][CurrentCell.Xloc+1]):
                    set UnvisitedNeighbors = UnvisitedNeighbors + array{CellToAdd}
        if (CurrentCell.Yloc > 0 and 
            ((Cells[CurrentCell.Zloc][CurrentCell.Yloc-1][CurrentCell.Xloc]).Visited <> true) ):
                if (CellToAdd := Cells[CurrentCell.Zloc][CurrentCell.Yloc-1][CurrentCell.Xloc]):
                    set UnvisitedNeighbors = UnvisitedNeighbors + array{CellToAdd}
        if (CurrentCell.Yloc < (YSize+1) and 
            ((Cells[CurrentCell.Zloc][CurrentCell.Yloc+1][CurrentCell.Xloc]).Visited <> true) ):
                if (CellToAdd := Cells[CurrentCell.Zloc][CurrentCell.Yloc+1][CurrentCell.Xloc]):
                    set UnvisitedNeighbors = UnvisitedNeighbors + array{CellToAdd}
        return UnvisitedNeighbors

    GetVisitedNeighbors2D(CurrentCell : maze_cell) : []maze_cell =
        var VisitedNeighbors : []maze_cell = array{}
        if (CurrentCell.Xloc > 0 and 
            (Cells[CurrentCell.Zloc][CurrentCell.Yloc][CurrentCell.Xloc-1]).Visited <> false):
                if (CellToAdd := Cells[CurrentCell.Zloc][CurrentCell.Yloc][CurrentCell.Xloc-1]):
                    set VisitedNeighbors = VisitedNeighbors + array{CellToAdd}
        if (CurrentCell.Xloc < (XSize-1) and 
            ((Cells[CurrentCell.Zloc][CurrentCell.Yloc][CurrentCell.Xloc+1]).Visited <> false) ):
                if (CellToAdd := Cells[CurrentCell.Zloc][CurrentCell.Yloc][CurrentCell.Xloc+1]):
                    set VisitedNeighbors = VisitedNeighbors + array{CellToAdd}
        if (CurrentCell.Yloc > 0 and 
            ((Cells[CurrentCell.Zloc][CurrentCell.Yloc-1][CurrentCell.Xloc]).Visited <> false) ):
                if (CellToAdd := Cells[CurrentCell.Zloc][CurrentCell.Yloc-1][CurrentCell.Xloc]):
                    set VisitedNeighbors = VisitedNeighbors + array{CellToAdd}
        if (CurrentCell.Yloc < (YSize+1) and 
            ((Cells[CurrentCell.Zloc][CurrentCell.Yloc+1][CurrentCell.Xloc]).Visited <> false) ):
                if (CellToAdd := Cells[CurrentCell.Zloc][CurrentCell.Yloc+1][CurrentCell.Xloc]):
                    set VisitedNeighbors = VisitedNeighbors + array{CellToAdd}
        return VisitedNeighbors

    RemoveWallsBetween(CellA : maze_cell, CellB : maze_cell) : void =
        # Print ("RemoveWallsBetween Called.")
        # Print ("CellA: {CellA.PrintCell()} CellB: {CellB.PrintCell()}")
        if (CellA.Xloc > CellB.Xloc): # A's west wall is removed.
            if (set CellA.Walls[0] = false) {}
            if (set CellB.Walls[2] = false) {}
        if (CellB.Xloc > CellA.Xloc): # A's east wall is removed.
            if (set CellA.Walls[2] = false) {}
            if (set CellB.Walls[0] = false) {}
        if (CellA.Yloc > CellB.Yloc): # A's south wall is removed.
            if (set CellA.Walls[3] = false) {}
            if (set CellB.Walls[1] = false) {}
        if (CellB.Yloc > CellA.Yloc): # A's north wall is removed.
            if (set CellA.Walls[1] = false) {}
            if (set CellB.Walls[3] = false) {}
        # Print ("CellA: {CellA.PrintCell()} CellB: {CellB.PrintCell()}")
        
    RemoveLikelyWall(CellIn: maze_cell): void=
        if (CellIn.Xloc < XSize-1):
            if (OtherCell := Cells[CellIn.Zloc][CellIn.Yloc][CellIn.Xloc-1]):
                RemoveWallsBetween(CellIn, OtherCell)
        if (CellIn.Yloc > YSize-1):
            if (OtherCell := Cells[CellIn.Zloc][CellIn.Yloc-1][CellIn.Xloc]):
                RemoveWallsBetween(CellIn, OtherCell)
        set CellIn.Visited = true
        return

    GenerateOneFloor(start_cell: maze_cell, current_floor: int): void=
        var CellStack:stack(maze_cell) = stack(maze_cell){}
        set CellStack = CellStack.Push(start_cell)
        var CurrentCell : maze_cell = maze_cell{}
        var NextCell : maze_cell = maze_cell{}
        var CellCounter : int = 0

        loop: 
            if (CellTuple := CellStack.Pop[]):
                set CurrentCell = CellTuple(1)
                set CellStack = CellTuple(0)
                set CellCounter = CellCounter + 1
                CurrentUnvisited := GetUnvisitedNeighbors2D(CurrentCell)
                # Print ("CurrentUnvisited.Length {CurrentUnvisited.Length}")
                if (CurrentUnvisited.Length > 0):
                    # Print ("Unvisited Length > 0")
                    if (set NextCell = CurrentUnvisited[GetRandomInt(0, CurrentUnvisited.Length-1)]):
                        # Print ("NextCell Set Up. {NextCell.PrintCell()}")
                        RemoveWallsBetween(CurrentCell, NextCell)
                        # Print ("Remove Walls Between Complete. Updating NextCell.")
                        set NextCell.Visited = true
                        set CellStack = CellStack.Push(CurrentCell)
                        set CellStack = CellStack.Push(NextCell)
                        # Print ("Pushed to stack, should iterate to next cell stack pop. Stack Length: {CellStack.Items.Length}")
            if (CellStack.Items.Length = 0):
                Print ("Maze Complete. Cell stack processed count : {CellCounter}") 
                break
        CleanUpUnvisited(current_floor)
        return

    CleanUpUnvisited(current_floor : int) : void =
        var CurrentCell : maze_cell = maze_cell{}
        var NextCell : maze_cell = maze_cell{}
        var CellStack:stack(maze_cell) = stack(maze_cell){}
        for (IndexY := 0..YSize - 1):
            for (IndexX := 0..XSize-1):
                if (Cells[current_floor][IndexY][IndexX].Visited = false):
                    if (CurrCell := Cells[current_floor][IndexY][IndexX]):
                        set CellStack = CellStack.Push(CurrCell)

        Print("Cleaning up unvisited cells; unvisited cell count: {CellStack.Items.Length}" )
        if (CellStack.Items.Length > 0):
            loop:
                if (CellTuple := CellStack.Pop[]):
                    set CurrentCell = CellTuple(1)
                    set CellStack = CellTuple(0)
                CurrentVisited := GetVisitedNeighbors2D(CurrentCell)
                if (CurrentVisited.Length > 0):
                    # Print ("Unvisited Length > 0")
                    if (set NextCell = CurrentVisited[GetRandomInt(0, CurrentVisited.Length-1)]):
                        # Print ("NextCell Set Up. {NextCell.PrintCell()}")
                        RemoveWallsBetween(CurrentCell, NextCell)
                        # Print ("Remove Walls Between Complete. Updating NextCell.")
                        set NextCell.Visited = true
                        set CellStack = CellStack.Push(CurrentCell)
                        set CellStack = CellStack.Push(NextCell)
                        # Print ("Pushed to stack, should iterate to next cell stack pop. Stack Length: {CellStack.Items.Length}")
                else:
                    RemoveLikelyWall(CurrentCell)

                if (CellStack.Items.Length = 0):
                    break
        Print ("Maze Complete.") 
