/*
 * Copyright 2020 Stephen Tetley
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

use Time.LocalDateTime;
use Text/SimpleFormat.{Doc};
use Text/SimpleFormat.{toString, besideSpace, beside, below, hcat, vcat, text, char, colon, punctuate, tab, line};

use AssetPatch/ChangeFile.{FileType, DataModel, EntityType, Headers, Selection, DataRow, FileHeader, ChangeFile};
use AssetPatch/ChangeFile.FileType.{Download, Upload};
use AssetPatch/ChangeFile.DataModel.{U1};
use AssetPatch/ChangeFile.EntityType.{FuncLoc, ClassFloc, ValuaFloc, Iflotx, Equi, ClassEqui, ValuaEqui, Eqmltxt};
use AssetPatch/ChangeFile.Headers.{Headers};
use AssetPatch/ChangeFile.Selection.{Selection};
use AssetPatch/ChangeFile.DataRow.{DataRow};


namespace AssetPatch/ChangeFile/Printer {

    /// Remake operators
    def <<>>(x: Doc, y:Doc): Doc = besideSpace(x,y)
    def <>(x: Doc, y:Doc): Doc = beside(x,y)
    pub def <!>(x: Doc, y: Doc): Doc = below(x, y)

    def comment(s: String): Doc = char('*') <<>> text(s)

    def commentDoc(d: Doc): Doc = char('*') <<>> d

    def defines(name: String, value: String): Doc = 
        char('*') <<>> text(name) <> colon() <<>> text(value)
        
    def ppFileType(x: FileType): Doc = match x {
        case Download => comment("Download")
        case Upload => comment("Upload")
    }

    def ppDataModel(x: DataModel): Doc =  match x {
        case U1 => defines("Data Model", "U1")
    }

    def ppEntityType (x : EntityType): Doc =
        let name = match x {
            case FuncLoc    => "FUNCLOC"
            case ClassFloc  => "CLASSFLOC"
            case ValuaFloc  => "VALUAFLOC"
            case Iflotx     => "IFOLTX"
            case Equi       => "EQUI"
            case ClassEqui  => "CLASSEQUI" 
            case ValuaEqui  => "VALUAEQUI"
            case Eqmltxt    => "EQMLTXT"
        };
        defines("Entity Type", name)
    
    def ppVariant (name: String): Doc = defines("Variant", name)

    def ppUser (name : String): Doc = defines("User", name)

    def ppDateTime (dt : LocalDateTime) : Doc = 
        use Result.flatMap;
        let step = () -> {
            let* dfmt = Time/Format/DateTimeFormatter.fromPattern("yyyyMMdd");
            let* tfmt = Time/Format/DateTimeFormatter.fromPattern("HHmmss");
            let date = Time/LocalDateTime.format(dt, dfmt);
            let time = Time/LocalDateTime.format(dt, tfmt);
            Ok(commentDoc(text("Date:") <<>> text(date) <<>> char('/') <<>> text("Time:") <<>> text(time)))
        };
        Result.getWithDefault(step(), comment("Date: ____ / Time: ____"))   


    def ppSelection (x: Selection): Doc = 
        let Selection(xs) = x;
        let rows = List.map(comment, xs);
        defines("Selection", "") <!> vcat(rows)

    def ppHeaders(x: Headers): Doc = 
        let Headers(xs) = x;
        let names = punctuate(tab(), List.map(x -> text(x), xs));
        char('*') <> hcat(names)

    def ppDataRow(x: DataRow): Doc = 
        let DataRow(xs) = x;
        hcat(List.map(x -> text(x) <> tab(), xs))

    def ppFileHeader (x: FileHeader): Doc = 
        vcat(
                ppFileType(x.fileType)
            :: ppDataModel(x.dataModel)
            :: ppEntityType(x.entityType)
            :: ppVariant(x.variant)
            :: ppUser(x.user)
            :: ppDateTime(x.dateTime)
            :: Nil
        )
    
    def ppChangeFile (x: ChangeFile): Doc = 
        vcat(
                ppFileHeader(x.fileHeader)
            :: ppSelection(x.selection)
            :: ppHeaders(x.headers)
            :: List.map(ppDataRow, x.dataRows)
        ) <> line()

    
    pub def printChangeFile(x: ChangeFile): String = 
        ppChangeFile(x).toString()
}