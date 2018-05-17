%% Test Read-Write OpenSim Motion Files
%==========================================================================
%Author(s): Colin Smith
%Date: 5/14/2018

%The kneemos_matlab toolkit is a collection of code for developing and 
%analyzing musculoskeletal simulations in SIMM and OpenSIM. The developers
%are based at the University of Wisconsin-Madison and ETH Zurich. Please
%see the README.md file for more details. It is your responsibility to
%ensure this code works correctly for your use cases. 
%
%Licensed under the Apache License, Version 2.0 (the "License"); you may
%not use this file except in compliance with the License. You may obtain a 
%copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
%Unless required by applicable law or agreed to in writing, software 
%distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
%WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
%License for the specific language governing permissions and limitations 
%under the License.
%
%==========================================================================
in_file = 'C:\Users\csmith\github\kneemos_matlab\opensim\io\testing\read_write_mot\subject01_walk1_grf.mot';
out_file = 'C:\Users\csmith\github\kneemos_matlab\opensim\io\testing\read_write_mot\subject01_walk1_grf_output.mot';

[data, labels, header] = read_opensim_mot(in_file);

write_opensim_mot(out_file,data,labels,header);

header.filename = 'subject01_walk1_grf_output2.mot';
out_path = 'C:\Users\csmith\github\kneemos_matlab\opensim\io\testing\read_write_mot\';
write_opensim_mot(out_path,data,labels,header);
