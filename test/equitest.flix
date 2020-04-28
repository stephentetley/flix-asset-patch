
use AssetPatch/ChangeFile.ChangeFile;
use AssetPatch/ChangeFile/Printer.{printChangeFile};
use AssetPatch/Template/Common.EquiId;
use AssetPatch/Template/Common.EquiId.{EquiId};
use AssetPatch/Template/ClassEqui.ClassEqui;
use AssetPatch/Template/ValuaEqui.ValuaEqui;
use AssetPatch/Template/EquiTemplate.{EquiTemplate};
use AssetPatch/Template/EquiTemplate.{generatePatches, execEquiTemplate, return, tellClassEqui, tellValuaEqui, mapM, sequence_};
use AssetPatch/Template/EquiCatalogue.{east_north, aib_reference, crhtds, crhtcr, crhtch};

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

type alias CRHT[r] = { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String | r }

def crane[r](x: CRHT[r]): EquiTemplate[Unit] = 
    sequence_( aib_reference(x) :: crhtcr(x) :: east_north(x) :: Nil)

def runwayBeam[r](x: CRHT[r]): EquiTemplate[Unit] = 
    sequence_(aib_reference(x) :: crhtch(x) :: east_north(x) :: Nil)

@test
def test02(): Result[Unit, String] & Impure = 
    let e1 = 
        { equiId = EquiId("$11284")
        , easting = 421152
        , northing = 426938
        , sai_ref = "SAI00067109"
        , pli_ref = "PLI00008901"
        , load = 1000
        , loadUnits = "KG"
        , srNumber = "L67900"
        , testCert = "UNKNOWN"
    };
    let e2 = 
        { equiId = EquiId("$11286")
        , easting = 421152
        , northing = 426938
        , sai_ref = "SAI00010989"
        , pli_ref = "PLI00023407"
        , load = 500
        , loadUnits = "KG"
        , srNumber = "L10745"
        , testCert = "UNKNOWN"
    };
    let path1 = "G:\work\Projects\assets\flix_asset_patch\classequi-out.txt";
    let path2 = "G:\work\Projects\assets\flix_asset_patch\valuaequi-out.txt";
    let ma = sequence_(crane(e1) :: runwayBeam(e2) :: Nil); 
    generatePatches(ma, "TETLEYS", path1, path2)   


