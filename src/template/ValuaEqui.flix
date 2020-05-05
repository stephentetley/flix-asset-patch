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

use AssetPatch/ChangeFile/Datatypes.{ChangeFile, Headers, DataRow};
use AssetPatch/ChangeFile/Datatypes.EntityType.{ValuaEqui};
use AssetPatch/ChangeFile/Datatypes.Headers.{Headers};
use AssetPatch/ChangeFile/Datatypes.DataRow.{DataRow};
use AssetPatch/ChangeFile/Datatypes.{emptySelection};

use AssetPatch/Template/Common.{EquiId};
use AssetPatch/Template/Common.EquiId.{EquiId};
use AssetPatch/Template/Common.{makeFileHeader, toDecimalString, showS4Date};

namespace AssetPatch/Template/ValuaEqui {

    type alias ValuaEqui = { equi: EquiId, classType: String, charId: String,  charValue: String
                            , code: Int32, valueDescription: String, intCounterValue: Int32
                            , valueFrom: String, valueTo: String
                            }
                          

    /// smart constructors for text or number ValuaEquis

    pub def stringValuaEqui[r](x: {equi: EquiId, classType: String, charId: String, counter: Int32, value: String | r}): ValuaEqui = 
        { equi = x.equi
        , classType = x.classType
        , charId = x.charId
        , charValue = x.value
        , code = 1
        , valueDescription = x.value
        , intCounterValue = x.counter
        , valueFrom = ""
        , valueTo = ""
        }
    
    pub def dateValuaEqui[r](x: {equi: EquiId, classType: String, charId: String, counter: Int32, value: LocalDate | r}): ValuaEqui = 
        stringValuaEqui({ value = showS4Date(x.value) | x })
        
    pub def int64ValuaEqui[r](x: { equi: EquiId, classType: String, charId: String, counter: Int32, value: Int64 | r }): ValuaEqui = 
        { equi = x.equi
        , classType = x.classType
        , charId = x.charId
        , charValue = ""
        , code = 1
        , valueDescription = ""
        , intCounterValue = x.counter
        , valueFrom = Int64.toString(x.value)
        , valueTo = "0"
        }
    
    pub def float64ValuaEqui[r](x: { equi: EquiId, classType: String, charId: String, counter: Int32, value: Float64 | r }): ValuaEqui = 
        { equi = x.equi
        , classType = x.classType
        , charId = x.charId
        , charValue = ""
        , code = 1
        , valueDescription = ""
        , intCounterValue = x.counter
        , valueFrom = toDecimalString(5, x.value)
        , valueTo = "0"
        }



    def valuaEquiHeaders(): Headers =
        Headers("EQUI" :: "CLASSTYPE" :: "CHARID" :: "ATWRT" :: "ATCOD"	:: "TEXTBEZ" :: "VALCNT" :: "ATFLV" :: "ATFLB" :: Nil)

    def dataRow(x: ValuaEqui): DataRow = 
        let EquiId(equiId) = x.equi;
        let intCounterValue = String.padLeft(3, '0', Int32.toString(x.intCounterValue));
        DataRow(equiId :: x.classType :: x.charId :: x.charValue :: Int32.toString(x.code) 
                :: x.valueDescription :: intCounterValue :: x.valueFrom :: x.valueTo :: Nil)

    pub def makeChangeFile(user: String, variant: String, xs: List[ValuaEqui]): ChangeFile & Impure = 
        let fh = makeFileHeader({ user = user, variant = variant, entityType = ValuaEqui});
        { fileHeader = fh 
        , selection = emptySelection() 
        , headers = valuaEquiHeaders()
        , dataRows = List.map(dataRow, xs)
        }

}