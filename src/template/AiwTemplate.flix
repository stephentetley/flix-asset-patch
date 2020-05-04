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

use AssetPatch/ChangeFile/Printer.{writeChangeFile};
use AssetPatch/ChangeFile/ExportCsv.{exportCsv};
use AssetPatch/Template/ClassEqui.ClassEqui;
use AssetPatch/Template/ValuaEqui.ValuaEqui;

namespace AssetPatch/Template/AiwTemplate {

    // Templates only have a limited number of patch types to 
    // generate.
    // (Rewrites are different - in theory they can rewrite any combination of fields)

    enum Entity {
        case ClassEquiE(ClassEqui),
        case ValuaEquiE(ValuaEqui)
    }


    type alias TemplateResult = { classEquis: List[ClassEqui], valuaEquis: List[ValuaEqui] }

    opaque type Attrs = List[Entity] -> List[Entity]

    def append(x: Attrs, y: Attrs): Attrs = 
        let Attrs(f) = x;
        let Attrs(g) = y;
        Attrs(xs -> f(g(xs)))
    
    def empty(): Attrs = Attrs(xs -> xs)

    def class1(x: ClassEqui): Attrs = 
        Attrs(xs -> ClassEquiE(x) :: xs)

    def valua1(x: ValuaEqui): Attrs = 
        Attrs(xs -> ValuaEquiE(x) :: xs)
    
    def attrsToTemplateResult (x: Attrs): TemplateResult = 
        let Attrs(f) = x;
        let xs = f(Nil);
        let step = (e, r) -> match e { 
            case ClassEquiE(ce) => { classEquis = ce :: r.classEquis | r }
            case ValuaEquiE(ve) => { valuaEquis = ve :: r.valuaEquis | r }
        };
        List.foldRight(step, { classEquis = Nil, valuaEquis = Nil }, xs)

    /// AiwTemplate is a Writer monad
    pub opaque type AiwTemplate[t] = (t, Attrs)


    pub def runAiwTemplate(ma: AiwTemplate[a]): (a, TemplateResult) = 
        let AiwTemplate((a, w)) = ma;
        (a, attrsToTemplateResult(w))

    pub def execAiwTemplate(ma: AiwTemplate[a]): TemplateResult = 
        let AiwTemplate((_, w)) = ma;
        attrsToTemplateResult(w)

    pub def generatePatches(ma: AiwTemplate[a], username: String, classpath: String, valuapath: String): Result[Unit, String] & Impure = 
        use Result.flatMap; 
        let r = execAiwTemplate(ma);
        let* _ = AssetPatch/Template/ClassEqui.makeChangeFile(username, "Asset Patch Create ClassEquis", r.classEquis).writeChangeFile(classpath);
        let* _ = AssetPatch/Template/ValuaEqui.makeChangeFile(username, "Asset Patch Create ValuaEquis", r.valuaEquis).writeChangeFile(valuapath);
        Ok(())

    pub def return(x: t): AiwTemplate[t] = 
        AiwTemplate((x, empty()))

    pub def map(f: a -> b, ma: AiwTemplate[a]): AiwTemplate[b] = 
        let AiwTemplate((a,w)) = ma;
        AiwTemplate((f(a), w))

    pub def bind(ma: AiwTemplate[a], k: a -> AiwTemplate[b]): AiwTemplate[b] = 
        let AiwTemplate((a,w)) = ma;
        let AiwTemplate((b,w1)) = k(a);
        AiwTemplate((b, w `append` w1))

    pub def flatMap(k: a -> AiwTemplate[b], ma: AiwTemplate[a]): AiwTemplate[b] = bind(ma, k)

    pub def tellClassEqui(x: ClassEqui): AiwTemplate[Unit] = 
        AiwTemplate(((), class1(x)))
    
    pub def tellValuaEqui(x: ValuaEqui): AiwTemplate[Unit] = 
        AiwTemplate(((), valua1(x)))

    pub def mapM(f: a -> AiwTemplate[b], xs: List[a]): AiwTemplate[List[b]] = 
        mapMHelper(f, xs, empty(), ks -> ks)
        
    def mapMHelper(f: a -> AiwTemplate[b], xs: List[a], w: Attrs, k: List[b] -> List[b]): AiwTemplate[List[b]] = 
        match xs { 
            case Nil => AiwTemplate(k(Nil), w)
            case x :: rs => { 
                let AiwTemplate((a,w1)) = f(x);
                mapMHelper(f, rs, w `append` w1, ks -> a :: ks)
            }
        }

    pub def sequence_(xs: List[AiwTemplate[a]]): AiwTemplate[Unit] = sequenceHelper_(xs, empty())
    
    def sequenceHelper_(xs: List[AiwTemplate[a]], w: Attrs): AiwTemplate[Unit] = 
        match xs { 
            case Nil => AiwTemplate((), w)
            case mx :: rs => { 
                let AiwTemplate((_,w1)) = mx;
                sequenceHelper_(rs, w `append` w1)
            }
        }
        
}