%%TEST OpenSim Results
%==========================================================================
%
%
%
%==========================================================================
model_file = 'C:\Users\csmith\github\kneemos_matlab\opensim\simulation_analysis\testing\opensim_results\subject01_simbody_adjusted.osim';
ik_file = 'C:\Users\csmith\github\kneemos_matlab\opensim\simulation_analysis\testing\opensim_results\subject01_walk1_ik.mot';
id_file = 'C:\Users\csmith\github\kneemos_matlab\opensim\simulation_analysis\testing\opensim_results\inverse_dynamics.sto';
result = opensim_results(model_file,'ik_file',ik_file);
result = opensim_results(model_file,'ik_file',ik_file,'id_file',id_file);
