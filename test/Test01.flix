use Time.{LocalDateTime};
use Time.{DayOfWeek};
use Text/SimpleFormat.{toString};
use Text/HtmlDoc.{Html};


use AssetPatch/ChangeFile/Datatypes.{ChangeFile, FileType, Headers, DataRow};
use AssetPatch/ChangeFile/Datatypes.FileType.{Download, Upload};
use AssetPatch/ChangeFile/Datatypes.Headers.{Headers};
use AssetPatch/ChangeFile/Datatypes.DataRow.{DataRow};
use AssetPatch/ChangeFile/Printer.{printChangeFile};
use AssetPatch/ChangeFile/ExportReport.{exportReport};
use AssetPatch/ChangeFile/ExportCsv.{exportCsv};

@test
def test01(): Result[String, String] & Impure = 
    let src = 
        "G:/work/Projects/assets/asset_patch/file_download_edm/car36_outstation_valuaequi.txt" |> System/FilePath.new;
    TextScanner.parseFile(AssetPatch/ChangeFile/Parser.pChangeFile(), src, System/Charset.utf_8())
        |> Result.map(printChangeFile)

@test
def test02(): Result[Unit, String] & Impure = 
    use Result.flatMap;
    let src = 
        "G:/work/Projects/assets/flix_asset_patch/car36_outstation_valuaequi.txt" |> System/FilePath.new;
    let csv = 
        "G:/work/Projects/assets/flix_asset_patch/car36_outstation_valuaequi_output.csv";
    let html = 
        "G:/work/Projects/assets/flix_asset_patch/car36_outstation_valuaequi_output.html";
    
    let* ans = TextScanner.parseFile(AssetPatch/ChangeFile/Parser.pChangeFile(), src, System/Charset.utf_8());    
    let* _ = exportReport(ans, html);
    let* _ = exportCsv(ans, csv);
    Ok()

@test
def test02a(): Result[Unit, String] & Impure = 
    use Result.flatMap;
    let src = 
        "G:/work/Projects/assets/flix_asset_patch/bbmed_cr_equipment_file_download_stage1.txt" |> System/FilePath.new;
    let csv = 
        "G:/work/Projects/assets/flix_asset_patch/bbmed_cr_equipment_file_download_stage1.csv";
    let html = 
        "G:/work/Projects/assets/flix_asset_patch/bbmed_cr_equipment_file_download_stage1.html";
    
    let* ans = TextScanner.parseFile(AssetPatch/ChangeFile/Parser.pChangeFile(), src, System/Charset.utf_8());    
    let* _ = exportReport(ans, html);
    let* _ = exportCsv(ans, csv);
    Ok()

def showHeaders(x: ChangeFile): Unit & Impure = 
    let Headers(xs) = x.headers;
    let i = ref 1;
    Console.printLine("Size: " + Int32.toString(List.length(xs)));
    List.foreach(x -> { Console.printLine(Int32.toString(deref i) + "<" + x + ">"); i := 1 + deref i}, xs)

@test
def test03(): Result[Unit, String] & Impure = 
    use Result.flatMap;
    let src = 
        "G:\work\Projects\assets\asset_patch\file_download_edm\car36_outstation_valuaequi.txt" |> System/FilePath.new;
    let* x = TextScanner.parseFile(AssetPatch/ChangeFile/Parser.pChangeFile(), src, System/Charset.utf_8());
    let _ = showHeaders(x);
    Ok()

def showDataRow(x: DataRow): Unit & Impure = 
    let DataRow(xs) = x;
    let i = ref 1;
    Console.printLine("DataRow Size: " + Int32.toString(List.length(xs)));
    List.foreach(x -> { Console.printLine(Int32.toString(deref i) + "<<" + x + ">>"); i := 1 + deref i}, xs)

@test
def test04(): Result[Unit, String] & Impure = 
    use Result.flatMap;
    let src = 
        "G:\work\Projects\assets\asset_patch\file_download_edm\car36_outstation_valuaequi.txt" |> System/FilePath.new;
    let* x = TextScanner.parseFile(AssetPatch/ChangeFile/Parser.pChangeFile(), src, System/Charset.utf_8());
    let _ = Console.printLine("DataRow count: "+ Int32.toString(List.length(x.dataRows)));
    let _ = List.foreach(showDataRow, x.dataRows);
    Ok()