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
use AssetPatch/ChangeFile.{ChangeFile, Headers, DataRow};
use AssetPatch/ChangeFile.EntityType.{ValuaEqui};
use AssetPatch/ChangeFile.Headers.{Headers};
use AssetPatch/ChangeFile.DataRow.{DataRow};
use AssetPatch/ChangeFile.{emptySelection};

use AssetPatch/Template/Common.{EquiId};
use AssetPatch/Template/Common.EquiId.{EquiId};
use AssetPatch/Template/Common.{makeFileHeader};

namespace AssetPatch/Template/ValuaEqui {

    type alias ValuaEqui = { equi: EquiId, classType: Int32, charId: String,  charValue: String
                            , code: Int32, valueDescription: String, intCounterValue: Int32
                            , valueFrom: String, valueTo: String
                            }

    /// TODO - smart constructors for text or number ValuaEquis

    def valuaEquiHeaders(): Headers =
        Headers("EQUI" :: "CLASSTYPE" :: "CHARID" :: "ATWRT" :: "ATCOD"	:: "TEXTBEZ" :: "VALCNT" :: "ATFLV" :: "ATFLB" :: Nil)

    def dataRow(x: ValuaEqui): DataRow = 
        let EquiId(equiId) = x.equi;
        let classType = String.padLeft(3, '0', Int32.toString(x.classType));
        let intCounterValue = String.padLeft(3, '0', Int32.toString(x.intCounterValue));
        DataRow(equiId :: classType :: x.charId :: x.charValue :: Int32.toString(x.code) 
                :: x.valueDescription :: intCounterValue :: x.valueFrom :: x.valueTo :: Nil)

    pub def makeChangeFile(user: String, variant: String, xs: List[ValuaEqui]): ChangeFile & Impure = 
        let fh = makeFileHeader({ user = user, variant = variant, entityType = ValuaEqui});
        { fileHeader = fh 
        , selection = emptySelection() 
        , headers = valuaEquiHeaders()
        , dataRows = List.map(dataRow, xs)
        }

}