
use AssetPatch/ChangeFile.ChangeFile;
use AssetPatch/ChangeFile/Printer.{printChangeFile};
use AssetPatch/Template/Common.EquiId;
use AssetPatch/Template/Common.EquiId.{EquiId};
use AssetPatch/Template/ClassEqui.ClassEqui;
use AssetPatch/Template/ValuaEqui.ValuaEqui;
use AssetPatch/Template/EquiTemplate.{EquiTemplate};
use AssetPatch/Template/EquiTemplate.{execEquiTemplate, return, tellClassEqui, tellValuaEqui};


/// Are Easting and Northing Strings or Ints in the DB?
/// Possibly Strings to preserve their 6 digits...


def east_north[r](x : { equiId: EquiId, easting:Int32, northing: Int32 | r }): EquiTemplate[Unit] = 
    use AssetPatch/Template/EquiTemplate.{flatMap};
    let* _ = tellClassEqui( { equi = x.equiId, className = "EAST_NORTH", classType = 2, status = 1 });
    let* _ = easting(x);
    let* _ = northing(x);
    return()


def easting[r](x : { equiId: EquiId, easting: Int32 | r }): EquiTemplate[Unit] = 
    use AssetPatch/Template/ValuaEqui.{stringValuaEqui};
    let value = String.padLeft(6, '0', Int32.toString(x.easting));
    tellValuaEqui(stringValuaEqui(x.equiId, 2, "EASTING", 1, value))

def northing[r](x : { equiId: EquiId, northing: Int32 | r }): EquiTemplate[Unit] = 
    use AssetPatch/Template/ValuaEqui.{stringValuaEqui};
    let value = String.padLeft(6, '0', Int32.toString(x.northing));
    tellValuaEqui(stringValuaEqui(x.equiId, 2, "NORTHING", 1, value))



@test
def test01(): Unit & Impure = 
    let (xs, ys) = execEquiTemplate <| east_north({ equiId = EquiId("101208938"), easting = 421152, northing = 426938});
    let s1 = AssetPatch/Template/ClassEqui.makeChangeFile("TETLEYS", "Asset Patch Create ClassEquis", xs).printChangeFile();
    let s2 = AssetPatch/Template/ValuaEqui.makeChangeFile("TETLEYS", "Asset Patch Create ValuaEquis", ys).printChangeFile();
    Console.printLine(s1);
    Console.printLine(s2)


