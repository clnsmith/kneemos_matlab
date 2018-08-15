classdef opensim_results
    %======================================================================
    % OpenSim Motion Class
    %----------------------------------------------------------------------
    %Author: Colin Smith 
    %----------------------------------------------------------------------
    %Reads a motion file and calculates the properties listed below
    %======================================================================
    
    properties
        model_file
        ik
        id
        
        model
        

        
        %Coordinate : stores pos, vel, acc, torque for each coordinate
        coord
      

        
    end
    
    methods
        function obj = opensim_results(model_file,varargin)
            %==================================================================
            %CLASS CONSTRUCTER
            %------------------------------------------------------------------
            %mot_file : full path to .mot file to read and analyze 
            %(include .mot extension)
            %==================================================================
            import org.opensim.modeling.*
            
            %Parse Inputs
            for i = 1:length(varargin)
                if(strcmp(varargin{i},'ik_file'))
                    obj.ik.file = varargin{i+1};
                elseif(strcmp(varargin{i},'id_file'))
                    obj.id.file = varargin{i+1};
                end
            end
            
            %Model
            %-----
            if (exist(obj.ik.file,'file') ~=2)
                fprintf('Model File: %s',mot_file);
                error('Model file does not exist!')                
            end
            
            obj.model_file = model_file;
            obj.model = Model(model_file);
            

            
            
            %Inverse Kinematics
            %------------------
            if ~isempty(obj.ik)
            	if(exist(obj.ik.file,'file') ~=2)
                    fprintf('IK File: %s',obj.ik.file)
                    error('IK file does not exist!')                
                end
                [obj.ik.data, obj.ik.labels, obj.ik.header] = read_opensim_mot(obj.ik.file);                
            end

            obj.ik.time = obj.ik.data(:,1);
            obj.ik.frame_number = 1:length(obj.ik.time);
            obj.ik.nFrames = length(obj.ik.frame_number);
            
            %Inverse Dynamics
            %----------------
            if ~isempty(obj.id)
            	if(exist(obj.id.file,'file') ~=2)
                    fprintf('ID File: %s',obj.id.file)
                    error('ID file does not exist!')                
                end
                [obj.id.data, obj.id.labels, obj.id.header] = read_opensim_mot(obj.id.file);                
            end
            
            
            %-----------
            %Coordinates
            %-----------
            obj.coord.num_coord = obj.model.getNumCoordinates();
            
            coord_set = obj.model.getCoordinateSet();
            
            obj.coord.list = cell(obj.coord.num_coord,1);
                        
            for i = 0:obj.coord.num_coord-1
                coord_name = char(coord_set.get(i).getName());
                obj.coord.list{i+1} = coord_name;
                                
                %pos (position)
                if ~isempty(obj.ik);
                    coord_pos_ind = find(strcmpi(coord_name,obj.ik.labels));
                    if ~isempty(coord_pos_ind)
                        obj.coord.(coord_name).('value').('data') = obj.ik.data(:,coord_pos_ind);
                        [obj.coord.(coord_name).('value').('max'), obj.coord.(coord_name).('pos').('max_frame_num')] = max(obj.ik.data(:,coord_pos_ind));
                        [obj.coord.(coord_name).('value').('min'), obj.coord.(coord_name).('pos').('min_frame_num')] = min(obj.ik.data(:,coord_pos_ind));

                    end
                end
                
                %gen_frc (generalize force: force or moment from ID)
                if ~isempty(obj.id)
                    coord_gen_frc_ind = find(contains(obj.id.labels,coord_name));
                    if ~isempty(coord_pos_ind)
                        obj.coord.(coord_name).('gen_frc').('data') = obj.id.data(:,coord_gen_frc_ind);
                        [obj.coord.(coord_name).('gen_frc').('max'), obj.coord.(coord_name).('gen_frc').('max_frame_num')] = max(obj.id.data(:,coord_gen_frc_ind));
                        [obj.coord.(coord_name).('gen_frc').('min'), obj.coord.(coord_name).('gen_frc').('min_frame_num')] = min(obj.id.data(:,coord_gen_frc_ind));

                    end
                end
            end
            

            
%                 %vel (velocity)
%                 coord_vel_ind = find(strcmpi([coord_name '_vel'],mot.hdr));
%                 if ~isempty(coord_vel_ind)
%                     obj.coord.(coord_name).('vel').('data') = mot.data(:,coord_vel_ind);
%                     [obj.coord.(coord_name).('vel').('max'), obj.coord.(coord_name).('vel').('max_frame_num')] = max(mot.data(:,coord_vel_ind));
%                 end
%                 
%                 %acc (acceleration)
%                 coord_acc_ind = find(strcmpi([coord_name '_acc'],mot.hdr));
%                 if ~isempty(coord_acc_ind)
%                     obj.coord.(coord_name).('acc').('data') = mot.data(:,coord_acc_ind);
%                     [obj.coord.(coord_name).('acc').('max'), obj.coord.(coord_name).('acc').('max_frame_num')] = max(mot.data(:,coord_acc_ind));
%                 end
%                 
%                 %torque
%                 coord_torque_ind = find(strcmpi([coord_name '_torque'],mot.hdr));
%                 if ~isempty(coord_torque_ind)
%                     obj.coord.(coord_name).('torque').('data') = mot.data(:,coord_torque_ind);
%                     [obj.coord.(coord_name).('torque').('max'), obj.coord.(coord_name).('torque').('max_frame_num')] = max(mot.data(:,coord_torque_ind));
%                 end
            
        end

    end
        
end
    


