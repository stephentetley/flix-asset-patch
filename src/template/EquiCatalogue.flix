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


    /// 
    /// AIB_REFERENCE
    ///
    pub def aib_reference[r](x : { equiId: EquiId, pli_ref: String, sai_ref: String | r }): EquiTemplate[Unit] = 
        use AssetPatch/Template/EquiTemplate.{flatMap};
        let* _ = tellClassEqui({ equi = x.equiId, className = "AIB_REFERENCE", classType = "002", status = 1 });
        let* _ = ai2_aib_reference({ equiId = x.equiId, aib_ref = x.pli_ref }, 1);
        let* _ = ai2_aib_reference({ equiId = x.equiId, aib_ref = x.sai_ref }, 2);
        let* _ = s4_aib_reference(x);
        return()


    pub def ai2_aib_reference[r](x: { equiId: EquiId, aib_ref: String | r }, ix: Int): EquiTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui(x.equiId, "002", "AI2_AIB_REFERENCE", ix, x.aib_ref))

    pub def s4_aib_reference[r](x: { equiId: EquiId | r }): EquiTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui(x.equiId, "002", "S4_AIB_REFERENCE", 1, ""))

    ///
    /// EAST_NORTH
    ///
    pub def east_north[r](x : { equiId: EquiId, easting: Int32, northing: Int32 | r }): EquiTemplate[Unit] = 
        use AssetPatch/Template/EquiTemplate.{flatMap};
        let* _ = tellClassEqui( { equi = x.equiId, className = "EAST_NORTH", classType = "002", status = 1 });
        let* _ = easting(x);
        let* _ = northing(x);
        return()


    def easting[r](x : { equiId: EquiId, easting: Int32 | r }): EquiTemplate[Unit] = 
        tellValuaEqui(int64ValuaEqui(x.equiId, "002", "EASTING", 1, Int32.toInt64(x.easting)))

    def northing[r](x : { equiId: EquiId, northing: Int32 | r }): EquiTemplate[Unit] = 
        tellValuaEqui(int64ValuaEqui(x.equiId, "002", "NORTHING", 1, Int32.toInt64(x.northing)))


    pub def uniclass_code[r](x: { equiId: EquiId | r }): EquiTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui(x.equiId, "002", "UNICLASS_CODE", 1, "")) 

    pub def uniclass_desc[r](x: { equiId: EquiId | r }): EquiTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui(x.equiId, "002", "UNICLASS_DESC", 1, "")) 

    ///
    /// crhtFamily
    ///
    def crhtFamily[r](objectClass: String, x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String| r }): EquiTemplate[Unit] = 
        use AssetPatch/Template/EquiTemplate.{flatMap};
        let* _ = tellClassEqui( { equi = x.equiId, className = objectClass, classType = "002", status = 1 });
        let* _ = uniclass_code(x);
        let* _ = uniclass_desc(x);
        let* _ = chrt_safe_working_load(x);
        let* _ = chrt_safe_working_load_units(x);
        let* _ = statutory_reference_number(x);
        let* _ = test_cert_no(x);
        return()

    pub def chrt_safe_working_load[r](x: { equiId: EquiId, load: Int32 | r }): EquiTemplate[Unit] = 
        tellValuaEqui(int64ValuaEqui(x.equiId, "002", "CRHT_SAFE_WORKING_LOAD", 1, Int32.toInt64(x.load))) 

    pub def chrt_safe_working_load_units[r](x: { equiId: EquiId, loadUnits: String | r }): EquiTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui(x.equiId, "002", "CRHT_SAFE_WORKING_LOAD_UNITS", 1, x.loadUnits)) 

    pub def statutory_reference_number[r](x: { equiId: EquiId, srNumber: String | r }): EquiTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui(x.equiId, "002", "STATUTORY_REFERENCE_NUMBER", 1, x.srNumber)) 

    pub def test_cert_no[r](x: { equiId: EquiId, testCert: String | r }): EquiTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui(x.equiId, "002", "TEST_CERT_NO", 1, x.testCert)) 

    ///
    /// CRHTBT (Beam Trolley)
    ///
    pub def crhtbt[r](x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String | r }): EquiTemplate[Unit] =
        crhtFamily("CHRTBT", x)

    ///
    /// CRHTCH (??? Hoists?)
    ///
    pub def crhtch[r](x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String | r }): EquiTemplate[Unit] =
        crhtFamily("CHRTCH", x)

    
    ///
    /// CRHTDA (Davit)
    ///
    pub def crhtda[r](x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String | r }): EquiTemplate[Unit] =
        crhtFamily("CHRTDA", x)

    ///
    /// CRHTDS (Davit Socket)
    ///
    pub def crhtds[r](x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String | r }): EquiTemplate[Unit] =
        crhtFamily("CHRTDS", x)


    ///
    /// liacFamily
    ///
    def liacFamily[r](objectClass: String, x: { equiId: EquiId, load: Int32, loadUnits: String, testCert: String | r }): EquiTemplate[Unit] = 
        use AssetPatch/Template/EquiTemplate.{flatMap};
        let* _ = tellClassEqui( { equi = x.equiId, className = objectClass, classType = "002", status = 1 });
        let* _ = uniclass_code(x);
        let* _ = uniclass_desc(x);
        let* _ = chrt_safe_working_load(x);
        let* _ = chrt_safe_working_load_units(x);
        let* _ = test_cert_no(x);
        return()

    pub def liac_safe_working_load[r](x: { equiId: EquiId, load: Int32 | r }): EquiTemplate[Unit] = 
        tellValuaEqui(int64ValuaEqui(x.equiId, "002", "LIAC_SAFE_WORKING_LOAD", 1, Int32.toInt64(x.load))) 

    pub def liac_safe_working_load_units[r](x: { equiId: EquiId, loadUnits: String | r }): EquiTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui(x.equiId, "002", "LIAC_SAFE_WORKING_LOAD_UNITS", 1, x.loadUnits)) 


    ///
    /// LIACDS (???)
    ///
    pub def liacds[r](x : { equiId: EquiId, load: Int32, loadUnits: String, testCert: String | r }): EquiTemplate[Unit] =
        liacFamily("LIACDSs", x)

    ///
    /// LIACMISC (Fork lift trucks etc.)
    ///
    pub def liacmisc[r](x : { equiId: EquiId, load: Int32, loadUnits: String, testCert: String | r }): EquiTemplate[Unit] =
        liacFamily("LIACMISC", x)

}