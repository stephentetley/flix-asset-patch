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


use AssetPatch/Template/Common.{EquiId};
use AssetPatch/Template/AiwTemplate.{AiwTemplate};
use AssetPatch/Template/AiwTemplate.{return, tellClassFloc, tellValuaFloc};
use AssetPatch/Template/ValuaFloc.{stringValuaFloc, int64ValuaFloc};

namespace AssetPatch/Template/FlocCatalogue {


    /// 
    /// AIB_REFERENCE
    ///
    pub def aib_reference[r](x : { floc: FlocId, sai_ref: String | r }): AiwTemplate[Unit] = 
        use AssetPatch/Template/AiwTemplate.{flatMap};
        let* _ = tellClassFloc({ equi = x.equiId, className = "AIB_REFERENCE", classType = "003", status = 1 });
        let* _ = ai2_aib_reference(x);
        let* _ = s4_aib_reference(x);
        return()


    pub def ai2_aib_reference[r](x: { floc: FlocId, sai_ref: String | r }): AiwTemplate[Unit] = 
        tellValuaFloc(stringValuaFloc(x.equiId, "003", "AI2_AIB_REFERENCE", 1, x.sai_ref))

    pub def s4_aib_reference[r](x: { floc: FlocId | r }): AiwTemplate[Unit] = 
        tellValuaFloc(stringValuaEqui(x.equiId, "003", "S4_AIB_REFERENCE", 1, ""))

    ///
    /// EAST_NORTH
    ///
    pub def east_north[r](x : { floc: FlocId, easting: Int32, northing: Int32 | r }): AiwTemplate[Unit] = 
        use AssetPatch/Template/AiwTemplate.{flatMap};
        let* _ = tellClassFloc( { equi = x.equiId, className = "EAST_NORTH", classType = "003", status = 1 });
        let* _ = easting(x);
        let* _ = northing(x);
        return()


    def easting[r](x : { floc: FlocId, easting: Int32 | r }): AiwTemplate[Unit] = 
        tellValuaFloc(int64ValuaFloc(x.equiId, "003", "EASTING", 1, Int32.toInt64(x.easting)))

    def northing[r](x : { floc: FlocId, northing: Int32 | r }): AiwTemplate[Unit] = 
        tellValuaFloc(int64ValuaFloc(x.equiId, "003", "NORTHING", 1, Int32.toInt64(x.northing)))


    ///
    /// EAST_NORTH
    ///
    pub def uniclass[r](x : { floc: FlocId | r }): AiwTemplate[Unit] = 
        use AssetPatch/Template/AiwTemplate.{flatMap};
        let* _ = tellClassFloc( { equi = x.equiId, className = "UNICLASS_CODE", classType = "003", status = 1 });
        let* _ = easting(x);
        let* _ = northing(x);
        return()

    pub def uniclass_code[r](x: { floc: FlocId | r }): AiwTemplate[Unit] = 
        tellValuaFloc(stringValuaFloc(x.equiId, "003", "UNICLASS_CODE", 1, "")) 

    pub def uniclass_desc[r](x: { floc: FlocId | r }): AiwTemplate[Unit] = 
        tellValuaFloc(stringValuaFloc(x.equiId, "003", "UNICLASS_DESC", 1, "")) 

 
}