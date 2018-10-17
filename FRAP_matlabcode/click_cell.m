function points=click_cell(img,CircleRadius,min_disp, max_disp)
%%
close all;
% bsz=box_size/2;
%imagesc(img,[min_disp max_disp]), axis image;
imagesc(img), axis image;
hold all
i=2;
point=zeros(1,2);
key=waitforbuttonpress;

ImWidth=size(img,2);
ImHeight=size(img,1);
[rr cc] = meshgrid(1:ImWidth,1:ImHeight);

% while (key == 0)    
while (i <= 2)   
    temp=get(gca,'CurrentPoint');       
    point=vertcat(point,temp(1,1:2));

    
    text(point(i,1),point(i,2), num2str(i),'Color','b');     
%     plot([point(i,1)-bsz point(i,1)-bsz point(i,1)+bsz point(i,1)+bsz point(i,1)-bsz],[point(i,2)-bsz point(i,2)+bsz point(i,2)+bsz point(i,2)-bsz point(i,2)-bsz], 'r');      
    i=i+1;      
%     key=waitforbuttonpress;
end
hold off


close all
    points = point(2:end,:);
%     figure

    BW_circle = sqrt((rr-points(1,1)).^2+(cc-points(1,2)).^2)<=CircleRadius;    
    
    overlay=img;
    overlay(bwperim(BW_circle))=60000;
%     labelled_img(:,:,cimg)=cslice2;
    
%     overlay1 = imoverlay(mat2gray(img), bwperim(BW_circle), [.3 1 .3]);
%     overlay1 = imoverlay(img, bwperim(BW_circle), [.3 1 .3]);
    imagesc(overlay,[min_disp max_disp]), axis image;
% imagesc(img(point(i-1,2)-bsz:point(i-1,2)+bsz,point(i-1,1)-bsz:point(i-1,1)+bsz))

end
