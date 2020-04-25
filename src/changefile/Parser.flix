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

use TextParser.Parser;
use TextParser.{return, map, nestError, alt, swapError, liftResult};
use TextParser/Combinators.{optional, seqLeft, seqRight, count, many, many1, manyTill, ignore, tuple2, sepBy, endBy, choice};
use TextParser/Text.{char, string, space, lower, oneOf, noneOf, newline, byteOrderMark, tab, restOfLine, many1Chars, 
                        padded, rightPadded, digit, digits, manyChars, manyChars2, endOfLine, upper, spaces};

use AssetPatch/ChangeFile.{FileType, DataModel, EntityType, Headers, Selection, DataRow, FileHeader, ChangeFile};
use AssetPatch/ChangeFile.FileType.{Download, Upload};
use AssetPatch/ChangeFile.DataModel.{U1};
use AssetPatch/ChangeFile.EntityType.{FuncLoc, ClassFloc, ValuaFloc, Iflotx, Equi, ClassEqui, ValuaEqui, Eqmltxt};
use AssetPatch/ChangeFile.Headers.{Headers};
use AssetPatch/ChangeFile.Selection.{Selection};
use AssetPatch/ChangeFile.DataRow.{DataRow};


namespace AssetPatch/ChangeFile/Parser {

    

    def nameValue(name: String, pValue: Parser[a]): Parser[a] =
        use TextParser.flatMap; 
        let* _ = string(name);
        let* _ = char(':');
        let* _ = optional(space());
        pValue

    def token(s: String): Parser[String] = 
        string(s) `seqLeft` spaces()

    ///
    /// This consumes end-of-line.
    /// 
    def pCommentLine(p: Parser[a]): Parser[a] = 
        use TextParser.flatMap;
        let* _ = char('*');
        let* ans = p;
        let* _ = endOfLine();
        return(ans)

    
    pub def pFileType(): Parser[FileType] = 
        let download = string("Download")     `seqRight` return(Download);
        let upload   = string("Upload")       `seqRight` return(Upload);
        pCommentLine(download `alt` upload)

    pub def pDataModel(): Parser[DataModel] = 
        let u1 = token("U1") `seqRight` return(U1);
        pCommentLine(nameValue("Data Model", u1))
        

    pub def pEntityType(): Parser[EntityType] =
        let inner =choice( 
                (token("FUNCLOC")   `seqRight` return(FuncLoc))
            :: (token("CLASSFLOC")  `seqRight` return(ClassFloc))
            :: (token("VALUAFLOC")  `seqRight` return(ValuaFloc))
            :: (token("IFLOTX")     `seqRight` return(Iflotx))
            :: (token("EQUI")       `seqRight` return(Equi))
            :: (token("CLASSEQUI")  `seqRight` return(ClassEqui))
            :: (token("VALUAEQUI")  `seqRight` return(ValuaEqui))
            :: (token("EQMLTXT")    `seqRight` return(Eqmltxt))
            :: Nil
        );
        pCommentLine(nameValue("Entity Type", inner))



    pub def pVariant(): Parser[String] = 
        pCommentLine(nameValue("Variant", restOfLine(false)))
    
    pub def pUser(): Parser[String] = 
        pCommentLine(nameValue("User", restOfLine(false)))

    pub def pDateTime(): Parser[LocalDateTime] = 
        use TextParser.flatMap;
        let inner = { 
            let* d = nameValue("Date", digits());
            let* _ = padded(char('/'));
            let* t = nameValue("Time", digits());
            let* patt = liftResult(Time/Format/DateTimeFormatter.fromPattern("yyyyMMdd HHmmss"));
            let* ans = liftResult(Time/LocalDateTime.fromStringWithFormat(d + "  " + t, patt));
            return(ans)
        };
        pCommentLine(inner)
        
    pub def pHeader(): Parser[FileHeader] = 
        use TextParser.flatMap;
        let* ft = pFileType();
        let* dm = pDataModel();
        let* et = pEntityType();
        let* v = pVariant();
        let* u = pUser();
        let* dt = pDateTime();
        return({ fileType = ft, dataModel = dm, entityType = et, 
                    variant = v, user = u, dateTime = dt })

    pub def pSelectionHeader(): Parser[Unit] = 
        pCommentLine(nameValue("Selection", restOfLine(false))) |> ignore

    pub def pSelectionLine(): Parser[String] = 
        pCommentLine(restOfLine(false))

    pub def pSelection(): Parser[Selection] = 
        use TextParser.flatMap;
        let inner = {
            let* _ = pSelectionHeader();
            let* xs = many(pSelectionLine());
            return(Selection(xs))
        };
        inner |> nestError("selection")

    def pColumnName(): Parser[String] = 
        manyChars2(
            upper(),
            choice(upper() :: char('_') :: digit() :: Nil)
        ) |> nestError("ColumnName")

    pub def pColumnHeaders(): Parser[Headers] = 
        use TextParser.flatMap;
        let inner = {
            let* _ = char('*');
            let* xs = sepBy(pColumnName(), tab());
            let* _ = endOfLine();
            return(Headers(xs))
        };
        inner |> nestError("ColumnHeaders") 

    def pCellValue(): Parser[String] = 
        manyChars(noneOf('\t' :: '\r' :: '\n' :: Nil))
            |> swapError("cellValue")

    pub def pDataRow(): Parser[DataRow] = 
         map(DataRow, endBy(pCellValue(), tab())) |> swapError("valueRow")


    pub def pChangeFile(): Parser[ChangeFile] = 
        use TextParser.flatMap;
        let* hdr = pHeader();
        let* sel = pSelection();
        let* cols = pColumnHeaders();
        let* rows = manyTill(pDataRow(), TextParser.endOfInput());
        return({ fileHeader = hdr, selection = sel, headers = cols, dataRows = rows })


}