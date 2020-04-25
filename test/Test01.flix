use Time.{LocalDateTime};
use Time.{DayOfWeek};
use Text/SimpleFormat.{toString};

use AssetPatch/ChangeFile.{FileType, Headers};
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
