
use AssetPatch/ChangeFile.ChangeFile;
use AssetPatch/Template/Common.EquiId;
use AssetPatch/Template/Common.EquiId.{EquiId};
use AssetPatch/Template/ClassEqui.ClassEqui;
use AssetPatch/Template/ClassEqui.{makeChangeFile};
use AssetPatch/ChangeFile/Printer.{printChangeFile};

/// Are Easting and Northing Strings or Ints in the DB?
/// Possibly Strings to preserve their 6 digits...

// let east_north(e: Int32, n: Int32): 

def east_northClass(equiId: EquiId): ClassEqui = 
    { equi = equiId
    , className = "EAST_NORTH"
    , classType = 2
    , status = 1
    }

@test
def test01(): String & Impure = 
    let x = east_northClass(EquiId("101208938"));
    makeChangeFile("TETLEYS", "Asset Patch Create ClassEquis", x :: Nil).printChangeFile()