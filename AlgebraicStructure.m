classdef AlgebraicStructure
    
    properties
        a, b, c, d, oper=["";""], neutral=[sym('x');sym('y')], inverse1, inverse2;
    end
    
    methods
        function obj = AlgebraicStructure(A, op)
            syms a b c d neutral;
            obj.a = a;
            obj.b = b;
            obj.c = c;
            obj.d = d;
            
            assumptionsStr = join(string(assumptions(A))," & ");
            negAssumptionsStr = join(string(~assumptions(A))," | ");
            assume(str2sym(replace(assumptionsStr,"A","a")))
            assume(str2sym(replace(assumptionsStr,"A","b")))
            assume(str2sym(replace(assumptionsStr,"A","c")))
            assume(~str2sym(replace(assumptionsStr,"A","d")))
            
            obj.oper(1) = replace(op(1),"b","obj.b");
            obj.oper(1) = replace(obj.oper(1),"a","obj.a");
            obj.oper(1) = replace(obj.oper(1),"c","obj.c");
            obj.oper(1) = replace(obj.oper(1),"d","obj.d");
            
            obj.oper(2) = replace(op(2),"b","obj.b");
            obj.oper(2) = replace(obj.oper(2),"a","obj.a");
            obj.oper(2) = replace(obj.oper(2),"c","obj.c");
            obj.oper(2) = replace(obj.oper(2),"d","obj.d");
        end
        
        function O = isClosed(obj,opNr)
            global GUItexts GUIlamps
            
            switch opNr
                case 1
                    op = str2sym(obj.oper(1) + " == obj.d"); % a dizałanie_1 b = d gdzie d jest dopełnieniem
                case 2
                    op = str2sym(obj.oper(2) + " == obj.d"); % a dizałanie_1 b = d
            end
            sol = solve(op,[obj.a, obj.b, obj.d]); %szukamy a b oraz d
            emp = isempty(sol) | isempty(sol.a);
            notNr = min(isnan(double(string(sol.a))));
            if isempty(notNr)
                notNr = true;
            end
            
            out = emp | notNr;
            if out
                GUItexts(opNr,1) = ("Zbiór zamknięty ze względu na działanie: " + erase(string(op), " == d"));
            else
                GUItexts(opNr,1) = ("Zbiór nie zamknięty ze względu na działanie: "...
                    + erase(string(op), " == d")...
                    + " Kontrprzykłady: ");
                for ind = 1 : length(sol.a)
                    GUItexts(opNr,1)= GUItexts(opNr,1) + "; " + (string(sol.a(ind)) + " + " + string(sol.b(ind)) + " = " + string(sol.d(ind)));
                end
            end
            
            O.value = out;
            O.obj = obj;
        end
        
        function O = hasNeutralElement(obj,opNr)
            global GUItexts GUIlamps
            
            switch opNr
                case 1
                    op = str2sym(obj.oper(1) + " == obj.a"); % a dizałanie_1 b = a
                case 2
                    op = str2sym(obj.oper(2) + " == obj.a"); % a dizałanie_2 b = a
            end
            
            sol = solve(op,[obj.b]); % szukamy elementu netralnego b
            emp = isempty(sol);
            notNr = min(isnan(double(string(sol))));
            if isempty(notNr)
                notNr = true;
            end
            out = ~emp & ~notNr;
            if out
                GUItexts(opNr,2) = ("Element netralny ze względu na działanie: " + erase(string(op), " == a"));
                for ind = 1 : length(sol)
                    GUItexts(opNr,2) = GUItexts(opNr,2) + " " + (string(sol(ind)));
                end
                
                obj.neutral(opNr) = sol;    
                
            else
                GUItexts(opNr,2) = ("Brak elementu neutralnego ze względu na działanie: " + erase(string(op), " == a"));
            end
            
            O.value = out;
            O.obj = obj;
        end
        
        function O = hasInverseElement(obj,opNr)
            global GUItexts GUIlamps
            
            op = str2sym(obj.oper(opNr))==obj.neutral(opNr); % a dizałanie_1 b = neutral(1)
            
            sol = solve(op,[obj.b]); % szukamy elementu odwrotnego b
            emp = isempty(sol);
            out = ~emp;
            
            if out
                GUItexts(opNr,3) = ("Element odwrotny ze względu na działanie: " + erase(string(op), [" == 0"," == 1"]));
                for ind = 1 : length(sol)
                    GUItexts(opNr,3) = GUItexts(opNr,3) + "; " + (string(sol(ind)));
                end
                
                switch opNr
                    case 1
                        obj.inverse1 = sol;
                    case 2
                        obj.inverse2 = sol;
                end
                
            else
                GUItexts(opNr,3) = ("Są elementy odwrotne ze względu na działanie: " ...
                    + erase(string(op), [" == 0"," == 1"]) ...
                    + " wychodzące poza zbiór np.: ");
                assumptions_of_b = assumptions(obj.b);
                assume(obj.b, 'clear');
                counterargument = solve(op,[obj.b]);
                assume(assumptions_of_b);
                GUItexts(opNr,3) = GUItexts(opNr,3) + string(counterargument);
            end
            
            O.value = out;
            O.obj = obj;
        end
        
        function O = isAssociative(obj,opNr) % czy jest łączne
            global GUItexts GUIlamps
            
            syms A B L P;
            switch opNr
                case 1
                    op = obj.oper(1); % a dizałanie_1 b	(a+b)
                case 2
                    op = obj.oper(2); % a dizałanie_2 b (a*b)
            end
            
            A = str2sym(op); % A = a działanie b
            B = obj.c; % B = c
            L = str2sym(replace(op, ["obj.a","obj.b"],[string(A),string(B)]));  % L = A działanie B

            A = obj.a; % A = a
            B = str2sym(replace(op,["obj.a","obj.b"],["b","c"])); % B = b działanie c
            P = str2sym(replace(op, ["obj.a","obj.b"],[string(A),string(B)]));  % P = A działanie B
                        
            out = isAlways(L==P);
            
            if out
                GUItexts(opNr,4) = ("W zbiorze zachodzi łączność ze względu na działanie: " + string(str2sym(op)));
            else
                GUItexts(opNr,4) = ("W zbiorze nie zachodzi łączności ze względu na działanie: " + string(str2sym(op)));
            end
            
            O.value = out;
            O.obj = obj;
        end
        
        function O = isCommutative(obj,opNr) % czy jest przemienne   
            global GUItexts GUIlamps
            
            syms L P;
            switch opNr
                case 1
                    op = obj.oper(1); % a dizałanie_1 b	(a+b)
                case 2
                    op = obj.oper(2); % a dizałanie_2 b (a*b)
            end
            
            L = str2sym(op);  % L = a działanie b
            P = str2sym(replace(op, ["obj.a","obj.b"],[string(obj.b),string(obj.a)]));  % P = b działanie a
                        
            out = isAlways(L==P);
            
            if out
                GUItexts(opNr,5) = ("W zbiorze zachodzi przemienność ze względu na działanie: " + string(str2sym(op)));
            else
                GUItexts(opNr,5) = ("W zbiorze nie zachodzi przemienność ze względu na działanie: " + string(str2sym(op)));
            end
            
            O.value = out;
            O.obj = obj;
        end
        
        function O = isGroup(obj,opNr)
            global GUItexts GUIlamps
            
            cl = obj.isClosed(opNr);
            obj = cl.obj;
            hn = obj.hasNeutralElement(opNr);
            obj = hn.obj;
            hie = obj.hasInverseElement(opNr);
            obj = hie.obj;
            ia = obj.isAssociative(opNr);
            obj = ia.obj;
            
            GUIlamps(opNr,1) = cl.value;
            GUIlamps(opNr,2) = hn.value;
            GUIlamps(opNr,3) = hie.value;
            GUIlamps(opNr,4) = ia.value;
            
            out = (cl.value & hn.value & hie.value & ia.value);
            GUIlamps(opNr,6) = out;
            
            if out
                GUItexts(opNr,6) = ("Jest to grupa z działaniem: " + string(str2sym(obj.oper(opNr))));
            else
                GUItexts(opNr,6) = ("To nie jest grupa z działaniem: " + string(str2sym(obj.oper(opNr))));
            end
            
            O.value = out;
            O.obj = obj;
        end
        
        function O = isAbelianGroup(obj,opNr)
            global GUItexts GUIlamps
            
            ig = obj.isGroup(opNr);
            obj = ig.obj;
            ic = obj.isCommutative(opNr);
            obj = ic.obj;
            out = (ig.value & ic.value);
            
            GUIlamps(opNr,5) = ic.value;
            GUIlamps(opNr,7) = out;
            
            if out
               GUItexts(opNr,7) = ("Jest to grupa abelowa z działaniem: " + string(str2sym(obj.oper(opNr))));
            else
                GUItexts(opNr,7) = ("To nie jest grupa abelowa z działaniem: " + string(str2sym(obj.oper(opNr))));
            end
            
            O.value = out;
            O.obj = obj;
        end
        
    end
end
