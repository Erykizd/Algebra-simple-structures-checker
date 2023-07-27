clear; close all; clc;

global GUItexts GUIlamps setOfNrs GUI;
GUItexts = "";
GUIlamps = true;
opers = "a + b";
opers(2) = "a * b";

% window
GUI = GuiController("Algebra", 350, 150, 800, 600);
GUI = GUI.addFirstKit();
GUI = GUI.addSecondKit();
for ind = 1 : 7
    GUI = GUI.addNormalKit();
end
GUI = GUI.style();
GUI = GUI.clear();

%logic
onConditionsChanged(GUI.textFields{1},"");
GUI = dispInGUI(GUI, GUItexts, GUIlamps, setOfNrs, opers);
setListener = addlistener([GUI.textFields{1},...
    GUI.textFields{2}, GUI.textFields{2}],...
    "ValueChanged", @onConditionsChanged);

function GUI = dispInGUI(GUI, GUItexts, GUIlamps, setOfNrs, opers)
    GUI = GUI.fill("label", 1, "Podaj zbiór (typu np. Z lub R\{0,4,13} lub {1,2+i,-8.5})");
    GUI = GUI.fill("textField", 1, setOfNrs);
    
    GUI = GUI.fill("label", 2, "Podaj zbiór działanie 1 np. a + b");
    GUI = GUI.fill("textField", 2, opers(1));
    
    GUI = GUI.fill("label", 3, "Podaj zbiór działanie 2 np. a * b");
    GUI = GUI.fill("textField", 3, opers(2));
    
    for ind = 1 : length(GUItexts)
        GUI = GUI.fill("label", 2*ind+2, GUItexts(1,ind));
        GUI = GUI.fill("label", 2*ind+3, GUItexts(2,ind));
    end
    
    for ind = 1 : length(GUIlamps)
        GUI = GUI.light(2*ind-1, GUIlamps(1,ind));
        GUI = GUI.light(2*ind, GUIlamps(2,ind));
    end
end

function onConditionsChanged(field,changedData)
    global GUItexts GUIlamps setOfNrs opers GUI
       
    switch string(field.Tag)
        case "first"
            setOfNrs = string(field.Value);
        case "secondL"
            opers(1) = string(field.Value);
        case "secondR"
            opers(2) = string(field.Value);
    end
        
    
    if setOfNrs == ""
       setOfNrs = "{-1,0,1}";
    end
    
    if opers(1) == ""
       opers(1) = "a + b"
    end
    
    if opers(1) == ""
       opers(1) = "a * b"
    end
        
    syms A;

    AC = AssumptionsController(A, setOfNrs, opers);
    spl = AC.splitAssumptions();
    AC = spl.obj;
    assumptions = spl.value;

    assume(assumptions);

    AS = AlgebraicStructure(A,opers);
    AS = AS.isAbelianGroup(1).obj;
    AS = AS.isAbelianGroup(2).obj;

    GUI = dispInGUI(GUI, GUItexts, GUIlamps,  setOfNrs, opers);
end
