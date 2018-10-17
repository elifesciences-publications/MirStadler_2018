function [top, left, h, w] = read_iJROI(filename)
%function modified from roiread.m  give filename as x.ROI, the ROI has to

% assumes a single ROI per file

%%

% filename='E:\Lattice Data\Bicoid Analysis\0412cs2\4_3\n1.ROI';
fid = fopen(filename,'r','ieee-be'); %'IEEE floating point with big-endian byte ordering'
hd = fread(fid,8,'uint8');
   
    
    coord = fread(fid,5,'int16'); 
    top = coord(1);
    left = coord(2);
    bottom=coord(3);
    right = coord(4);
    w= right-left;
    h = bottom-top;
    
    %top and left are flipped from MATLAB convention.
    

        
end