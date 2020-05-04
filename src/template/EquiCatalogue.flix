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
use AssetPatch/Template/AiwTemplate.{return, tellClassEqui, tellValuaEqui};
use AssetPatch/Template/ValuaEqui.{stringValuaEqui, int64ValuaEqui};

namespace AssetPatch/Template/EquiCatalogue {


    /// 
    /// AIB_REFERENCE
    ///
    pub def aib_reference[r](x : { equiId: EquiId, pli_ref: String, sai_ref: String | r }): AiwTemplate[Unit] = 
        use AssetPatch/Template/AiwTemplate.{flatMap};
        let* _ = tellClassEqui({ equi = x.equiId, className = "AIB_REFERENCE", classType = "002", status = 1 });
        let* _ = ai2_aib_reference({ equiId = x.equiId, aib_ref = x.pli_ref }, 1);
        let* _ = ai2_aib_reference({ equiId = x.equiId, aib_ref = x.sai_ref }, 2);
        let* _ = s4_aib_reference(x);
        return()


    pub def ai2_aib_reference[r](x: { equiId: EquiId, aib_ref: String | r }, ix: Int): AiwTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui({ equi = x.equiId,
                                        classType = "002", 
                                        charId = "AI2_AIB_REFERENCE", 
                                        counter = ix, 
                                        value = x.aib_ref}))

    pub def s4_aib_reference[r](x: { equiId: EquiId | r }): AiwTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui({ equi = x.equiId, 
                                        classType = "002",
                                        charId = "S4_AIB_REFERENCE",
                                        counter = 1, 
                                        value = ""}))

    ///
    /// EAST_NORTH
    ///
    pub def east_north[r](x : { equiId: EquiId, easting: Int32, northing: Int32 | r }): AiwTemplate[Unit] = 
        use AssetPatch/Template/AiwTemplate.{flatMap};
        let* _ = tellClassEqui( { equi = x.equiId, className = "EAST_NORTH", classType = "002", status = 1 });
        let* _ = easting(x);
        let* _ = northing(x);
        return()


    def easting[r](x : { equiId: EquiId, easting: Int32 | r }): AiwTemplate[Unit] = 
        tellValuaEqui(int64ValuaEqui({  equi = x.equiId, 
                                        classType = "002", 
                                        charId = "EASTING", 
                                        counter = 1, 
                                        value = Int32.toInt64(x.easting)}))

    def northing[r](x : { equiId: EquiId, northing: Int32 | r }): AiwTemplate[Unit] = 
        tellValuaEqui(int64ValuaEqui({  equi = x.equiId, 
                                        classType = "002", 
                                        charId = "NORTHING", 
                                        counter = 1, 
                                        value = Int32.toInt64(x.northing)}))


    pub def uniclass_code[r](x: { equiId: EquiId | r }): AiwTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui({ equi = x.equiId, 
                                        classType = "002", 
                                        charId = "UNICLASS_CODE", 
                                        counter = 1, 
                                        value = ""})) 

    pub def uniclass_desc[r](x: { equiId: EquiId | r }): AiwTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui({ equi = x.equiId, 
                                        classType = "002", 
                                        charId = "UNICLASS_DESC", 
                                        counter = 1, 
                                        value = ""})) 

    ///
    /// crhtFamily
    ///
    def crhtFamily[r](objectClass: String, x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String| r }): AiwTemplate[Unit] = 
        use AssetPatch/Template/AiwTemplate.{flatMap};
        let* _ = tellClassEqui( { equi = x.equiId, className = objectClass, classType = "002", status = 1 });
        let* _ = uniclass_code(x);
        let* _ = uniclass_desc(x);
        let* _ = chrt_safe_working_load(x);
        let* _ = chrt_safe_working_load_units(x);
        let* _ = statutory_reference_number(x);
        let* _ = test_cert_no(x);
        return()

    pub def chrt_safe_working_load[r](x: { equiId: EquiId, load: Int32 | r }): AiwTemplate[Unit] = 
        tellValuaEqui(int64ValuaEqui({  equi = x.equiId, 
                                        classType = "002", 
                                        charId = "CRHT_SAFE_WORKING_LOAD", 
                                        counter = 1, 
                                        value = Int32.toInt64(x.load)})) 

    pub def chrt_safe_working_load_units[r](x: { equiId: EquiId, loadUnits: String | r }): AiwTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui({ equi = x.equiId, 
                                        classType = "002", 
                                        charId = "CRHT_SAFE_WORKING_LOAD_UNITS", 
                                        counter = 1, 
                                        value = x.loadUnits})) 

    pub def statutory_reference_number[r](x: { equiId: EquiId, srNumber: String | r }): AiwTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui({ equi = x.equiId, 
                                        classType = "002", 
                                        charId = "STATUTORY_REFERENCE_NUMBER", 
                                        counter = 1, 
                                        value = x.srNumber})) 

    pub def test_cert_no[r](x: { equiId: EquiId, testCert: String | r }): AiwTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui({ equi = x.equiId, 
                                        classType = "002", 
                                        charId = "TEST_CERT_NO", 
                                        counter = 1, 
                                        value = x.testCert})) 

    ///
    /// CRHTBT (Beam Trolley)
    ///
    pub def crhtbt[r](x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String | r }): AiwTemplate[Unit] =
        crhtFamily("CRHTBT", x)

    ///
    /// CRHTCH (Crane Hoist)
    ///
    pub def crhtch[r](x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String | r }): AiwTemplate[Unit] =
        crhtFamily("CRHTCH", x)

    ///
    /// CRHTCH (Crane)
    ///
    pub def crhtcr[r](x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String | r }): AiwTemplate[Unit] =
        crhtFamily("CRHTCR", x)
    
    ///
    /// CRHTDA (Davit)
    ///
    pub def crhtda[r](x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String | r }): AiwTemplate[Unit] =
        crhtFamily("CRHTDA", x)

    ///
    /// CRHTDS (Davit Socket)
    ///
    pub def crhtds[r](x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String | r }): AiwTemplate[Unit] =
        crhtFamily("CRHTDS", x)


    ///
    /// liacFamily
    ///
    def liacFamily[r](objectClass: String, x: { equiId: EquiId, load: Int32, loadUnits: String, srNumber: String, testCert: String | r }): AiwTemplate[Unit] = 
        use AssetPatch/Template/AiwTemplate.{flatMap};
        let* _ = tellClassEqui( { equi = x.equiId, className = objectClass, classType = "002", status = 1 });
        let* _ = uniclass_code(x);
        let* _ = uniclass_desc(x);
        let* _ = chrt_safe_working_load(x);
        let* _ = chrt_safe_working_load_units(x);
        let* _ = statutory_reference_number(x);
        let* _ = test_cert_no(x);
        return()

    pub def liac_safe_working_load[r](x: { equiId: EquiId, load: Int32 | r }): AiwTemplate[Unit] = 
        tellValuaEqui(int64ValuaEqui({  equi = x.equiId, 
                                        classType = "002", 
                                        charId = "LIAC_SAFE_WORKING_LOAD", 
                                        counter = 1, 
                                        value = Int32.toInt64(x.load)})) 

    pub def liac_safe_working_load_units[r](x: { equiId: EquiId, loadUnits: String | r }): AiwTemplate[Unit] = 
        tellValuaEqui(stringValuaEqui({ equi = x.equiId, 
                                        classType = "002", 
                                        charId = "LIAC_SAFE_WORKING_LOAD_UNITS", 
                                        counter = 1, 
                                        value = x.loadUnits})) 


    ///
    /// LIACDS (D Shackle)
    ///
    pub def liacds[r](x : { equiId: EquiId, load: Int32, loadUnits: String, testCert: String | r }): AiwTemplate[Unit] =
        liacFamily("LIACDS", x)

    ///
    /// LIACMISC (miscellaneous, e.g. fork lift trucks etc.)
    ///
    pub def liacmisc[r](x : { equiId: EquiId, load: Int32, loadUnits: String, testCert: String | r }): AiwTemplate[Unit] =
        liacFamily("LIACMISC", x)

}