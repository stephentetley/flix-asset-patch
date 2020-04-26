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

use Text/HtmlDoc.{Html};
use Text/HtmlDoc.{append, concat, html, head, body, title, link, text, anchor, table, tr, td, th, h1};
use Text/HtmlDoc.{href_, type_, colspan_, rel_};

use AssetPatch/ChangeFile.{FileType, DataModel, EntityType, Headers, Selection, DataRow, FileHeader, ChangeFile};
use AssetPatch/ChangeFile.{showEntityType};
use AssetPatch/ChangeFile.FileType.{Download, Upload};
use AssetPatch/ChangeFile.DataModel.{U1};
use AssetPatch/ChangeFile.EntityType.{FuncLoc, ClassFloc, ValuaFloc, Iflotx, Equi, ClassEqui, ValuaEqui, Eqmltxt};
use AssetPatch/ChangeFile.Headers.{Headers};
use AssetPatch/ChangeFile.Selection.{Selection};
use AssetPatch/ChangeFile.DataRow.{DataRow};

namespace AssetPatch/ChangeFile/Report {


    def <&>(x: Html, y: Html) : Html = append(x, y)

    def linkToTop(): Html = 
        anchor(href_("#top") :: Nil, text("Back to top"))

    def pFileType(x: FileType): Html = text <| match x {
        case Download   => "Download"
        case Upload     => "Upload"
    }

    def pDataModel(x: DataModel): Html = text <| match x {
        case U1 => "U1"
    }


    def pEntityType(x: EntityType) : Html = text <| match x {
        case FuncLoc    => "FUNCLOC"
        case ClassFloc  => "CLASSFLOC"
        case ValuaFloc  => "VALUAFLOC"
        case Iflotx     => "IFLOTX"
        case Equi       => "EQUI"
        case ClassEqui  => "CLASSEQUI"
        case ValuaEqui  => "VALUAEQUI"
        case Eqmltxt    => "EQMLTXT"
    }
    
        
    
    pub def fileHeaderTable(x: FileHeader): Html = 
        use Time/LocalDateTime.toString;
        let makeRow = (name, value) ->  
            tr(Nil, 
                    td(Nil, text(name)) 
                <&> td(Nil, value)
            );
        table(Nil, 
                tr(Nil, td(colspan_("2") :: Nil, pFileType(x.fileType)))
            <&> makeRow("Data Model:",      pDataModel(x.dataModel))
            <&> makeRow("Entity Type:",     pEntityType(x.entityType))
            <&> makeRow("Variant:",         text(x.variant))
            <&> makeRow("User:",            text(x.user))
            <&> makeRow("Date:",            text(toString(x.dateTime)))
        )
    

    def headersTableRow(xs: Headers): Html = 
        let Headers(xs1) = xs;
        tr(Nil, concat(List.map(s -> th(Nil, text(s)), "Index" :: xs1)))

    def dataTableRow(x: DataRow, ix: Int32): Html = 
        let DataRow(xs1) = x;
        tr(Nil, concat(List.map(s -> th(Nil, text(s)), Int32.toString(ix + 1) :: xs1)))

    def dataTable(xs: Headers, ys: List[DataRow]): Html = 
        table(Nil, 
                headersTableRow(xs)
            <&> concat(List.mapWithIndex(dataTableRow, ys))
        )

    pub def changeFileReport(x: ChangeFile) : Html =
        let titleText = "Patch Summary (" + showEntityType(x.fileHeader.entityType) + ")";
        html(Nil,
                head(Nil,
                        title(Nil, text(titleText))
                    <&> link(
                            rel_("stylesheet")
                        ::  type_("text/css")
                        ::  href_("github.css")
                        ::  Nil)
                )
            <&> body(Nil, 
                        h1(Nil, text("Patch Report"))
                    <&> fileHeaderTable(x.fileHeader)
                    <&> dataTable(x.headers, x.dataRows)
                    <&> linkToTop()
                )
        )

}