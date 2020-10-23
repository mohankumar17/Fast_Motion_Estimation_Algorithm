
close all
clear all


folder_name = 'hall_pics';  %30 frames for encoding
imageName = 'hall_cif_';
image_format = 'bmp';
mbSize = 4;
p = 6; 
tic
for i = 0:30

    imgINumber = i;       %Reference frame
    imgPNumber = i+1;       %Current frame
  
    if imgINumber < 10
        imgIFile = sprintf('./%s/%s00%d.%s',folder_name,imageName, imgINumber, image_format);
    elseif imgINumber < 100 
        imgIFile = sprintf('./%s/%s0%d.%s',folder_name,imageName, imgINumber, image_format);
    end

    if imgPNumber < 10
        imgPFile = sprintf('./%s/%s00%d.%s',folder_name,imageName, imgPNumber, image_format);
    elseif imgPNumber < 100
        imgPFile = sprintf('./%s/%s0%d.%s',folder_name,imageName, imgPNumber, image_format);
    end
    
%         if img_ref_frm_num < 10
%         img_ref_frm_file = sprintf('./%s/%s00%d.%s',folder_name, image_name, img_ref_frm_num,image_format);
%     elseif img_ref_frm_num < 100
%         img_ref_frm_file = sprintf('./%s/%s0%d.%s',folder_name, image_name, img_ref_frm_num,image_format);
%     end
% 
%     if img_curr_frm_num < 10
%         img_cur_frm_file = sprintf('./%s/%s00%d.%s',folder_name, image_name, img_curr_frm_num,image_format);
%     elseif img_curr_frm_num < 100
%         img_cur_frm_file = sprintf('./%s/%s0%d.%s',folder_name, image_name, img_curr_frm_num,image_format);
%     end

    imgI = double(imread(imgIFile));
    imgP = double(imread(imgPFile));
    imgI = imgI(:,1:352);
    imgP = imgP(:,1:352);
    
    % Exhaustive Search
    [motionVect, computations] = motionEstES(imgP,imgI,mbSize,p);
    toc
    imgComp = motionComp(imgI, motionVect, mbSize);
    ESpsnr(i+1) = imgPSNR(imgP, imgComp, 255);          
    EScomputations(i+1) = computations;
end

fprintf('Average PSNR: %f\n',(mean(ESpsnr)));
fprintf('Average EScomputations: %f\n',(sum(EScomputations)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

 % Cross Hexagonal Search
    [motionVect, computations] = motionEstNHS(imgP,imgI,mbSize,p);
    toc
    imgComp = motionComp(imgI, motionVect, mbSize);
    NHSpsnr(i+1) = imgPSNR(imgP, imgComp, 255);          
    NHScomputations(i+1) = computations;
end

fprintf('Average PSNR: %f\n',(mean(NHSpsnr)));
fprintf('Average EScomputations: %f\n',(sum(NHScomputations)));


