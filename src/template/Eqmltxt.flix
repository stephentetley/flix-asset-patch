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

use AssetPatch/ChangeFile/Datatypes.{ChangeFile, Headers, DataRow};
use AssetPatch/ChangeFile/Datatypes.EntityType.{Eqmltxt};
use AssetPatch/ChangeFile/Datatypes.Headers.{Headers};
use AssetPatch/ChangeFile/Datatypes.DataRow.{DataRow};
use AssetPatch/ChangeFile/Datatypes.{emptySelection};

use AssetPatch/Template/Common.{EquiId};
use AssetPatch/Template/Common.EquiId.{EquiId};
use AssetPatch/Template/Common.{makeFileHeader, showS4Bool};

namespace AssetPatch/Template/Eqmltxt {

    type alias Eqmltxt = { equi: EquiId, description: String, longText: String, moreTextExists: Bool }

    def eqmltxtHeaders(): Headers =
        Headers("EQUI" :: "SHORTXT" :: "LANGUCODE" :: "EQ_LTXT" :: "LTXTIND" :: Nil)

    def dataRow(x: Eqmltxt): DataRow = 
        let EquiId(equiId) = x.equi;
        DataRow(equiId :: x.description :: "EN" :: x.longText :: showS4Bool(x.moreTextExists) ::  Nil)

    pub def makeChangeFile(user: String, variant: String, xs: List[Eqmltxt]): ChangeFile & Impure = 
        let fh = makeFileHeader({ user = user, variant = variant, entityType = Eqmltxt });
        { fileHeader = fh 
        , selection = emptySelection() 
        , headers = eqmltxtHeaders()
        , dataRows = List.map(dataRow, xs)
        }
        
        

}    