use Time.{LocalDateTime};
use Time.{DayOfWeek};
use Text/SimpleFormat.{toString};
use Text/HtmlDoc.{Html};


use AssetPatch/ChangeFile.{ChangeFile, FileType, Headers};
use AssetPatch/ChangeFile.FileType.{Download, Upload};
use AssetPatch/ChangeFile.Headers.{Headers};
use AssetPatch/ChangeFile/Printer.{ppFileType, ppDateTime, ppHeaders};

@test
def test01(): String = 
    ppFileType(Download).toString()


@test
def test02(): LocalDateTime & Impure = 
    Time/LocalDateTime.now()

@test
def test03(): String & Impure = 
    let date = Time/LocalDateTime.now();
    ppDateTime(date).toString()

@test
def test04(): Result[String, String] & Impure = 
    use Result.flatMap;
    let date = Time/LocalDateTime.now();
    let* fmt = Time/Format/DateTimeFormatter.fromPattern("yyyyMMdd");
    Ok(Time/LocalDateTime.format(date, fmt))

@test
def test05(): Result[String, String] & Impure = 
    use Result.flatMap;
    let date = Time/LocalDateTime.now();
    let* fmt = Time/Format/DateTimeFormatter.fromPattern("HHmmss");
    Ok(Time/LocalDateTime.format(date, fmt))

@test
def test06(): String = 
    ppHeaders(Headers("TXT" :: "VALZ" :: Nil)).toString()


@test
def test07(): Result[ChangeFile, String] & Impure = 
    let src = 
        "G:\work\Projects\assets\asset_patch\file_download_edm\car36_outstation_valuaequi.txt" |> System/FilePath.new;
    match TextParser.parseFile(AssetPatch/ChangeFile/Parser.pChangeFile(), src, System/Charset.utf_8() ) { 
        case Err(e) => Err(TextParser.showParserError(e))
        case Ok(a) => Ok(a)
    }

@test
def test08(): String = 
    AssetPatch/ChangeFile/Report.linkToTop() |> Text/HtmlDoc.toString

