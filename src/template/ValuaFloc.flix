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
use AssetPatch/ChangeFile/Datatypes.EntityType.{ValuaFloc};
use AssetPatch/ChangeFile/Datatypes.Headers.{Headers};
use AssetPatch/ChangeFile/Datatypes.DataRow.{DataRow};
use AssetPatch/ChangeFile/Datatypes.{emptySelection};

use AssetPatch/Template/Common.{FlocId};
use AssetPatch/Template/Common.FlocId.{FlocId};
use AssetPatch/Template/Common.{makeFileHeader, toDecimalString, tryShowDate};

namespace AssetPatch/Template/ValuaFloc {

    type alias ValuaFloc = { floc: FlocId, classType: String, charId: String,  charValue: String
                            , code: Int32, valueDescription: String, intCounterValue: Int32
                            , valueFrom: String, valueTo: String
                            }
                          

    /// smart constructors for text or number ValuaFlocs

    pub def stringValuaFloc(floc: FlocId, classType: String, charId: String, counter: Int32, value: String): ValuaFloc = 
        { floc = floc
        , classType = classType
        , charId = charId
        , charValue = value
        , code = 1
        , valueDescription = value
        , intCounterValue = counter
        , valueFrom = ""
        , valueTo = ""
        }
        
    pub def int64ValuaFloc(floc: FlocId, classType: String, charId: String, counter: Int32, value: Int64): ValuaFloc = 
        { floc = floc
        , classType = classType
        , charId = charId
        , charValue = ""
        , code = 1
        , valueDescription = ""
        , intCounterValue = counter
        , valueFrom = Int64.toString(value)
        , valueTo = "0"
        }
    
    pub def float64ValuaFloc(floc: FlocId, classType: String, charId: String, counter: Int32, value: Float64): ValuaFloc = 
        { floc = floc
        , classType = classType
        , charId = charId
        , charValue = ""
        , code = 1
        , valueDescription = ""
        , intCounterValue = counter
        , valueFrom = toDecimalString(5, value)
        , valueTo = "0"
        }
    
    pub def tryDateValuaFloc(floc: FlocId, classType: String, charId: String, counter: Int32, value: LocalDate): Result[ValuaFloc, String] = 
        use Result.flatMap;
        let* dateValue = tryShowDate(value);
        Ok(stringValuaFloc(floc, classType, charId, counter, dateValue))



    def valuaFlocHeaders(): Headers =
        Headers("FUNCLOC" :: "CLASSTYPE" :: "CHARID" :: "ATWRT" :: "ATCOD"	:: "TEXTBEZ" :: "VALCNT" :: "ATFLV" :: "ATFLB" :: Nil)
                
    def dataRow(x: ValuaFloc): DataRow = 
        let FlocId(flocId) = x.floc;
        let intCounterValue = String.padLeft(3, '0', Int32.toString(x.intCounterValue));
        DataRow(flocId :: x.classType :: x.charId :: x.charValue :: Int32.toString(x.code) 
                :: x.valueDescription :: intCounterValue :: x.valueFrom :: x.valueTo :: Nil)

    pub def makeChangeFile(user: String, variant: String, xs: List[ValuaFloc]): ChangeFile & Impure = 
        let fh = makeFileHeader({ user = user, variant = variant, entityType = ValuaFloc});
        { fileHeader = fh 
        , selection = emptySelection() 
        , headers = valuaFlocHeaders()
        , dataRows = List.map(dataRow, xs)
        }

}