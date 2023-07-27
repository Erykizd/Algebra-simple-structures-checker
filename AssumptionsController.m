classdef AssumptionsController
    
    properties
        A, assumptions, operations;
    end
    
    methods
        function obj = AssumptionsController(mySet, inputAssumptions, inputOperations)
            obj.A = mySet;
            obj.assumptions = inputAssumptions;
            obj.operations = inputOperations;
        end
        
        function output = splitAssumptions(obj)
            if length(char(obj.assumptions))==1
                switch obj.assumptions
                case "R"
                   assumptionsStr = "in(A,'real')";
                case "Z"
                   assumptionsStr = "in(A,'integer')";
                case "N"
                   assumptionsStr = "in(A,'integer') & in(A,'positive')";
                case "Q"
                   assumptionsStr = "in(A,'rational')";
                case "C"
                   assumptionsStr = "";
                end
            elseif obj.assumptions.contains("\")
                base = obj.assumptions.extractBefore("\");

                switch base
                    case "R"
                       baseStr = 'real';
                    case "Z"
                       baseStr = 'integer';
                    case "Q"
                       baseStr = 'rational';
                end

                obj.assumptions = erase(obj.assumptions, base);
                if startsWith(obj.assumptions, "\{") && endsWith(obj.assumptions, "}")
                        excludedStr = "[" + extractBetween(obj.assumptions, "\{","}") + "]";
                        assumptionsStr = "in(A,'" + baseStr + "') & A~=" + excludedStr;
                end
            elseif startsWith(obj.assumptions, "{") && endsWith(obj.assumptions, "}")
                allowedValues = str2num(extractBetween(obj.assumptions, "{", "}"));
                syms assumption;
                assumptionsStr = "A == " + join(string(allowedValues)," | A == ");
            end

            obj.assumptions = str2sym(assumptionsStr);
            assume(str2sym(assumptionsStr));

            output.value = obj.assumptions;
            output.obj = obj;
        end
    end
end
