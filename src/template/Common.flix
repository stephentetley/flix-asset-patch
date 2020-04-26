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

use Time.LocalDate;

use AssetPatch/ChangeFile.{ChangeFile, FileType, DataModel, EntityType, Headers, Selection, DataRow, FileHeader};
use AssetPatch/ChangeFile.{showEntityType};
use AssetPatch/ChangeFile.FileType.{Download};
use AssetPatch/ChangeFile.DataModel.{U1};
use AssetPatch/ChangeFile.EntityType.{FuncLoc, ClassFloc, ValuaFloc, Iflotx, Equi, ClassEqui, ValuaEqui, Eqmltxt};
use AssetPatch/ChangeFile.Headers.{Headers};
use AssetPatch/ChangeFile.Selection.{Selection};
use AssetPatch/ChangeFile.DataRow.{DataRow};

namespace AssetPatch/Template/Common {

    ///
    /// Return a decimal representation of `x`.
    ///
    pub def toDecimalString(decimalPlaces: Int32, x: Float64): String =
        toDecimalStringHelper(decimalPlaces, x) as & Pure

    ///
    /// Helper function for `toDecimalString`.
    ///
    def toDecimalStringHelper(decimalPlaces: Int32, x: Float64): String & Impure =
        import new java.text.DecimalFormat() as newDecimalFormat;
        import java.text.DecimalFormat.applyPattern(String);
        import java.text.DecimalFormat.setMaximumFractionDigits(Int32);
        import java.text.NumberFormat.format(Float64);
        let df = newDecimalFormat();
        df.applyPattern("###.###");
        df.setMaximumFractionDigits(decimalPlaces);
        let nf = df as ##java.text.NumberFormat;
        nf.format(x)


    pub opaque type EquiId = String
    

    pub def tryShowDate(x: LocalDate): Result[String, String] = 
        use Result.flatMap;
        let* patt = Time/Format/DateFormatter.fromPattern("dd.MM.yyyy");
        Ok(Time/LocalDate.format(x, patt))
    

    pub def makeFileHeader[r](x: { user: String, variant: String, entityType: EntityType | r }): FileHeader & Impure =     
        { fileType = Download
        , dataModel = U1
        , entityType = x.entityType
        , variant = x.variant
        , user = x.user
        , dateTime = Time/LocalDateTime.now() 
        } 

}    