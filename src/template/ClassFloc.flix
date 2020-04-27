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
use AssetPatch/ChangeFile.EntityType.{ClassFloc};
use AssetPatch/ChangeFile.Headers.{Headers};
use AssetPatch/ChangeFile.DataRow.{DataRow};
use AssetPatch/ChangeFile.{emptySelection};

use AssetPatch/Template/Common.{FlocId};
use AssetPatch/Template/Common.FlocId.{FlocId};
use AssetPatch/Template/Common.{makeFileHeader};

namespace AssetPatch/Template/ClassFloc {

    type alias ClassFloc = { floc: FlocId, className: String, classType: String, status: Int32 }

    def classFlocHeaders(): Headers =
        Headers("FUNCLOC" :: "CLASS" :: "CLASSTYPE" :: "CLSTATUS1" :: Nil)

    def dataRow(x: ClassFloc): DataRow = 
        let FlocId(flocId) = x.floc;
        DataRow(flocId :: x.className :: x.classType :: Int32.toString(x.status) :: Nil)

    pub def makeChangeFile(user: String, variant: String, xs: List[ClassFloc]): ChangeFile & Impure = 
        let fh = makeFileHeader({ user = user, variant = variant, entityType = ClassFloc});
        { fileHeader = fh 
        , selection = emptySelection() 
        , headers = classFlocHeaders()
        , dataRows = List.map(dataRow, xs)
        }
        
        

}    