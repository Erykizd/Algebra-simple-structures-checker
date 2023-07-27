classdef GuiController
    properties
        figs = {};
        labels = {};
        textFields = {};
        lamps = {};
        btns = {};
        g = {};
        nrOfRows = 0;
    end
    
    methods
        function obj = GuiController(title, x, y, dx, dy)
            % Tworzenie głównego okna aplikacji
            obj.figs{1} = uifigure('Name', title, 'Position', [x, y, dx, dy]);
            obj.g{1} = uigridlayout(obj.figs{1},'backgroundColor',[0,0.3,0]);
        end
        
        function obj = addFirstKit(obj)         
            ind = obj.nrOfRows + 1;
            
            obj.labels{end+1} = uilabel(obj.g{1});
            obj.labels{end}.Layout.Row = ind;
            obj.labels{end}.Layout.Column = [1,6];
            
            obj.textFields{end+1} = uieditfield(obj.g{1});
            obj.textFields{end}.Layout.Row = ind+1;
            obj.textFields{end}.Layout.Column = [1,6];
            obj.textFields{end}.Tag = "first";
            
            obj.nrOfRows = obj.nrOfRows + 2;
        end
        
        function obj = addSecondKit(obj)                        
            ind = obj.nrOfRows + 1;
            
            %lewa kolumna
            obj.labels{end+1} = uilabel(obj.g{1});
            obj.labels{end}.Layout.Row = ind;
            obj.labels{end}.Layout.Column = [1,3];
            
            obj.textFields{end+1} = uieditfield(obj.g{1});
            obj.textFields{end}.Layout.Row = ind+1;
            obj.textFields{end}.Layout.Column = [1,3];
            obj.textFields{end}.Tag = "secondL";
            
            %prawa kolumna
            obj.labels{end+1} = uilabel(obj.g{1});
            obj.labels{end}.Layout.Row = ind;
            obj.labels{end}.Layout.Column = [4,6];
            
            obj.textFields{end+1} = uieditfield(obj.g{1});
            obj.textFields{end}.Layout.Row = ind+1;
            obj.textFields{end}.Layout.Column = [4,6];
            obj.textFields{end}.Tag = "secondR";
            
            obj.nrOfRows = obj.nrOfRows + 2;
        end

        function obj = addNormalKit(obj)                        
            ind = obj.nrOfRows + 1;
            
            %lewa kolumna
            obj.labels{end+1} = uilabel(obj.g{1});
            obj.labels{end}.Layout.Row = [ind, ind+1];
            obj.labels{end}.Layout.Column = [1,2];
            
            obj.lamps{end+1} = uilamp(obj.g{1});
            obj.lamps{end}.Color = "black";
            obj.lamps{end}.Layout.Row = [ind, ind+1];
            obj.lamps{end}.Layout.Column = 3;
            
            %prawa kolumna
            obj.labels{end+1} = uilabel(obj.g{1});
            obj.labels{end}.Layout.Row = [ind, ind+1];
            obj.labels{end}.Layout.Column = [4,5];
            
            obj.lamps{end+1} = uilamp(obj.g{1});
            obj.lamps{end}.Color = "black";
            obj.lamps{end}.Layout.Row = [ind, ind+1];
            obj.lamps{end}.Layout.Column = 6;
            
            obj.nrOfRows = obj.nrOfRows + 2;
        end

        
        function obj = style(obj)           
            for ind = 1 : length(obj.labels)
                obj.labels{ind}.BackgroundColor = [0,0,0];
                obj.labels{ind}.FontColor = [0,1,0];
                obj.labels{ind}.FontSize = 16;
                obj.labels{ind}.WordWrap = true;
                
                obj.textFields{ind}.BackgroundColor = [0.3,0.3,0.3];
                obj.textFields{ind}.FontColor = [0,1,0];
                obj.textFields{ind}.FontSize = 16;
            end
        end
        
        function obj = fill(obj, fieldType, nr, txt)           
            switch fieldType
                case "label"
                    obj.labels{nr}.Text = txt;
                case "textField"
                    obj.textFields{nr}.Value = txt;
            end
        end
        
        function obj = light(obj, nr, sw) 
            if sw
                obj.lamps{nr}.Color = "green";
                obj.labels{nr+3}.FontColor = "green";
            else
                obj.lamps{nr}.Color = "red";
                obj.labels{nr+3}.FontColor = [1,0.3,0.3]; %brighter red
            end
        end
        
        function obj = clear(obj) 
            for i = 1 : length(obj.labels)
                obj.labels{i}.Text = "";
            end
            
            for i = 1 : length(obj.textFields)
                obj.textFields{i}.Value = "";
            end
            
            for i = 1 : length(obj.lamps)
                obj.lamps{i}.Color = "black";
            end
        end
    end
end
