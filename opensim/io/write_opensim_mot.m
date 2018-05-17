function done=write_opensim_mot(file_path,data,labels,header)
%%=========================================================================
%READ_OPENSIM_MOT
%--------------------------------------------------------------------------
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
%--------------------------------------------------------------------------
%file_path : str
%   option 1: only path, name comes from header.filename, must end with '\'
%       file_path = 'C:\path\to\folder\'
%   option 2: full file path, must include extension (.mot or .sto)
%       file_path = 'C:\path\to\folder\example.mot' 
%
%data : [nFrames x nLabels] matrix
%
%
%labels : {1 x nLabels} cell of strings 
%
%
%header : Struct with following fields
%     filename: 'subject01_walk1_grf.mot'
%     version: 1
%     indegrees: 'yes'
%
%
%==========================================================================

%% Check if file path includes file name
[path,name,ext] = fileparts(file_path);

if(isempty(name))
    name = header.filename;
    full_path = [path,filesep, name];
else
    if(isempty(ext))
        error('You must include extension in file_path: %s',file_path)
    end
    name = [name,ext];
    header.filename = name;
    full_path = file_path;
end

fid = fopen(full_path,'w');

%% Write Header
[nRow,nCol]=size(data);

fprintf(fid,'%s\n',name);
fprintf(fid,'version=%d\n',header.version);
fprintf(fid,'nRows %4d\n',nRow);
fprintf(fid,'nColumns %3d\n',nCol);
fprintf(fid,'inDegrees=%s\n',header.indegrees);
fprintf(fid,'endheader\n');

%% Write Data
sfmt='%16s ';
dfmt='%16.8f ';

%Print column labels
for i=1:nCol
   fprintf(fid,sfmt,char(labels(i)));
end
fprintf(fid,'\n');

%Print Data
for i=1:nRow
   fprintf(fid,dfmt,data(i,:));
   fprintf(fid,'\n');
end
fclose(fid);
fprintf('Wrote file: %s\n',full_path);
done=1;
