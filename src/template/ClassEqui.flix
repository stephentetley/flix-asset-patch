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
use AssetPatch/ChangeFile/Datatypes.EntityType.{ClassEqui};
use AssetPatch/ChangeFile/Datatypes.Headers.{Headers};
use AssetPatch/ChangeFile/Datatypes.DataRow.{DataRow};
use AssetPatch/ChangeFile/Datatypes.{emptySelection};

use AssetPatch/Template/Common.{EquiId};
use AssetPatch/Template/Common.EquiId.{EquiId};
use AssetPatch/Template/Common.{makeFileHeader};

namespace AssetPatch/Template/ClassEqui {

    type alias ClassEqui = { equi: EquiId, className: String, classType: String, status: Int32 }

    def classEquiHeaders(): Headers =
        Headers("EQUI" :: "CLASS" :: "CLASSTYPE" :: "CLSTATUS1" :: Nil)

    def dataRow(x: ClassEqui): DataRow = 
        let EquiId(equiId) = x.equi;
        DataRow(equiId :: x.className :: x.classType :: Int32.toString(x.status) :: Nil)

    pub def makeChangeFile(user: String, variant: String, xs: List[ClassEqui]): ChangeFile & Impure = 
        let fh = makeFileHeader({ user = user, variant = variant, entityType = ClassEqui});
        { fileHeader = fh 
        , selection = emptySelection() 
        , headers = classEquiHeaders()
        , dataRows = List.map(dataRow, xs)
        }
        
        

}    