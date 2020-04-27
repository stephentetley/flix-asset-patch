
use AssetPatch/ChangeFile.ChangeFile;
use AssetPatch/ChangeFile/Printer.{printChangeFile};
use AssetPatch/Template/Common.EquiId;
use AssetPatch/Template/Common.EquiId.{EquiId};
use AssetPatch/Template/ClassEqui.ClassEqui;
use AssetPatch/Template/ValuaEqui.ValuaEqui;
use AssetPatch/Template/EquiTemplate.{EquiTemplate};
use AssetPatch/Template/EquiTemplate.{execEquiTemplate, return, tellClassEqui, tellValuaEqui, mapM};
use AssetPatch/Template/EquiCatalogue.{east_north};

/// Are Easting and Northing Strings or Ints in the DB?
/// Possibly Strings to preserve their 6 digits...






@test
def test01(): Unit & Impure = 
    let src =      { equiId = EquiId("101208938"), easting = 421152, northing = 426938} 
                :: { equiId = EquiId("101208945"), easting = 475652, northing = 518653} 
                :: Nil;
    let (xs, ys) = execEquiTemplate <| mapM(east_north, src);    
    let s1 = AssetPatch/Template/ClassEqui.makeChangeFile("TETLEYS", "Asset Patch Create ClassEquis", xs).printChangeFile();
    let s2 = AssetPatch/Template/ValuaEqui.makeChangeFile("TETLEYS", "Asset Patch Create ValuaEquis", ys).printChangeFile();
    Console.printLine(s1);
    Console.printLine(s2)


