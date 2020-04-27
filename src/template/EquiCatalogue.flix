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
use AssetPatch/Template/EquiTemplate.{EquiTemplate};
use AssetPatch/Template/EquiTemplate.{return, tellClassEqui, tellValuaEqui};
use AssetPatch/Template/ValuaEqui.{stringValuaEqui, int64ValuaEqui};

namespace AssetPatch/Template/EquiCatalogue {

    pub def east_north[r](x : { equiId: EquiId, easting:Int32, northing: Int32 | r }): EquiTemplate[Unit] = 
        use AssetPatch/Template/EquiTemplate.{flatMap};
        let* _ = tellClassEqui( { equi = x.equiId, className = "EAST_NORTH", classType = "002", status = 1 });
        let* _ = easting(x);
        let* _ = northing(x);
        return()


    def easting[r](x : { equiId: EquiId, easting: Int32 | r }): EquiTemplate[Unit] = 
        tellValuaEqui(int64ValuaEqui(x.equiId, "002", "EASTING", 1, Int32.toInt64(x.easting)))

    def northing[r](x : { equiId: EquiId, northing: Int32 | r }): EquiTemplate[Unit] = 
        tellValuaEqui(int64ValuaEqui(x.equiId, "002", "NORTHING", 1, Int32.toInt64(x.northing)))


}