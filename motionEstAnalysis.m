
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

%     % Three Step Search
%     [motionVect,computations ] = motionEstTSS(imgP,imgI,mbSize,p);
%     imgComp = motionComp(imgI, motionVect, mbSize);
%     TSSpsnr(i+1) = imgPSNR(imgP, imgComp, 255);
%     TSScomputations(i+1) = computations;
% 
%     % Simple and Efficient Three Step Search
%     [motionVect, computations] = motionEstSESTSS(imgP,imgI,mbSize,p);
%     imgComp = motionComp(imgI, motionVect, mbSize);
%     SESTSSpsnr(i+1) = imgPSNR(imgP, imgComp, 255);
%     SESTSScomputations(i+1) = computations;
% 
%     % New Three Step Search
%     [motionVect,computations ] = motionEstNTSS(imgP,imgI,mbSize,p);
%     imgComp = motionComp(imgI, motionVect, mbSize);
%     NTSSpsnr(i+1) = imgPSNR(imgP, imgComp, 255);
%     NTSScomputations(i+1) = computations;
% 
%     % Four Step Search
%     [motionVect, computations] = motionEst4SS(imgP,imgI,mbSize,p);
%     imgComp = motionComp(imgI, motionVect, mbSize);
%     SS4psnr(i+1) = imgPSNR(imgP, imgComp, 255);
%     SS4computations(i+1) = computations;
% 
%     % Diamond Search
%     [motionVect, computations] = motionEstDS(imgP,imgI,mbSize,p);
%     imgComp = motionComp(imgI, motionVect, mbSize);
%     DSpsnr(i+1) = imgPSNR(imgP, imgComp, 255);
%     DScomputations(i+1) = computations;
%     
%     % Adaptive Rood Patern Search
%     [motionVect, computations] = motionEstARPS(imgP,imgI,mbSize,p);
%     imgComp = motionComp(imgI, motionVect, mbSize);
%     ARPSpsnr(i+1) = imgPSNR(imgP, imgComp, 255); 
%     ARPScomputations(i+1) = computations;



% save dsplots2 DSpsnr DScomputations ESpsnr EScomputations TSSpsnr ...
%       TSScomputations SS4psnr SS4computations NTSSpsnr NTSScomputations ...
%        SESTSSpsnr SESTSScomputations ARPSpsnr ARPScomputations