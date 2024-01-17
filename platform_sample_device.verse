using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
lesson_07 := class(creative_device):

    Roasts : []string = array{"Dude, you suck!", "You call that a kill?", "My grandma has better hops than you!"}
    var Boasts : []string = array{"You are amazing!", "GOAT", "King Killer!"}
    EmptyArray : []string = array{}

    # Do Last
    @editable var TileAsset : creative_prop_asset := DefaultCreativePropAsset
    var TileGrid : [][]?creative_prop = array{array{}}
    
    OnBegin<override>()<suspends>:void=
        #RandomRoast := Roasts[0]

        if (RandomRoats := Roasts[0]):
            Print(RandomRoats)

        if (ThirdElement := EmptyArray[2]):
            #Will not get here
            Print("Third Element {ThirdElement}")

        # if (set Roasts[0] = "Kid ain't got skillz"):
        
        # Editing elements
        if (Boast := Boasts[0], set Boasts[0] = "Crushing it!"):
            Print("Boast: {Boast}")
        
        # How to add items to an array?
        # You can't!

        set Boasts += array{"Love it!", "You Da Man", "Shredding!"}

        #Loop Array #1
        for (Word : Boasts):
            Print("Word")
        
        #Loop Array #2
        for (Index := 0..Roasts.Length - 1):
            if (Roast := Roasts[Index]):
                Print("{Roast} at index {Index}")
        
        GenerateTiles()
        Sleep(5.0)
        RemoveRandomTiles()
    
    GenerateTiles():void=
        set TileGrid =
            for (Row := 0..5):
                for(Column := 0..5):
                    CreateTileForIndex(Row, Column)

    CreateTileForIndex(XIdx : int, YIdx : int) : ?creative_prop=
        Spacer := 700.0
        if (XPos := float[XIdx * Spacer], YPos := float[YIdx * Spacer]):
            return SpawnProp(TileAsset, vector3{X := XPos, Y := YPos, Z := 10.0}, IdentityRotation())(0)
        else:
            return false

    RemoveRandomTiles():void=
        if (NumberOfColumns : int = TileGrid[0].Length):
            for (Row := 0..TileGrid.Length - 1, Column := 0..NumberOfColumns):
                if (Tile := TileGrid[Row][Column]?):
                    Rand := GetRandomInt(0,1)
                    if (Rand = 0):
                        Tile.Dispose()
