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


use AssetPatch/Template/ClassEqui.ClassEqui;
use AssetPatch/Template/ValuaEqui.ValuaEqui;

namespace AssetPatch/Template/EquiTemplate {

    opaque type Attrs = (List[ClassEqui], List[ValuaEqui]) -> (List[ClassEqui], List[ValuaEqui])

    def append(x: Attrs, y: Attrs): Attrs = 
        let Attrs(f) = x;
        let Attrs(g) = y;
        Attrs((xs,ys) -> let (xs1,ys1) = g(xs,ys); f(xs1, ys1))
    
    def empty(): Attrs = Attrs((xs,ys) -> (xs,ys))

    def class1(x: ClassEqui): Attrs = 
        Attrs((xs,ys) -> (x :: xs, ys))

    def valua1(y: ValuaEqui): Attrs = 
        Attrs((xs,ys) -> (xs, y :: ys))

    /// EquiTemplate is a Writer monad
    pub opaque type EquiTemplate[t] = (t, Attrs)

    pub def return(x: t): EquiTemplate[t] = 
        EquiTemplate((x, empty()))

    pub def map(f: a -> b, ma: EquiTemplate[a]): EquiTemplate[b] = 
        let EquiTemplate((a,w)) = ma;
        EquiTemplate((f(a), w))

    pub def bind(ma: EquiTemplate[a], k: a -> EquiTemplate[b]): EquiTemplate[b] = 
        let EquiTemplate((a,w)) = ma;
        let EquiTemplate((b,w1)) = k(a);
        EquiTemplate((b, w `append` w1))

    pub def flatMap(k: a -> EquiTemplate[b], ma: EquiTemplate[a]): EquiTemplate[b] = bind(ma, k)

    pub def tellClassEqui(x: ClassEqui): EquiTemplate[Unit] = 
        EquiTemplate(((), class1(x)))
    
    pub def tellValuaEqui(x: ValuaEqui): EquiTemplate[Unit] = 
        EquiTemplate(((), valua1(x)))

    pub def runEquiTemplate(ma: EquiTemplate[a]): (a, List[ClassEqui], List[ValuaEqui]) = 
        let EquiTemplate((a, w)) = ma;
        let Attrs(f) = w;
        let (xs, ys) = f(Nil, Nil);
        (a, xs, ys)

    pub def execEquiTemplate(ma: EquiTemplate[a]): (List[ClassEqui], List[ValuaEqui]) = 
        let EquiTemplate((_, w)) = ma;
        let Attrs(f) = w;
        f(Nil, Nil)
        

}