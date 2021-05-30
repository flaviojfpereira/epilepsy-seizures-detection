function [net] = createNetwork(handles)
   if( handles.arquitectura.Value == 1)
       %FeedFoward
       nNeurons = str2double(handles.nNeurons.String);
       nLayers = str2double(handles.nLayers.String);
       hiddenSizes = nNeurons(:,ones(nLayers-1,1));
       net = feedforwardnet(hiddenSizes);
       %%100 neuronios
   elseif( handles.arquitectura.Value == 2)
       %%Layer Recurrent
       nNeurons = str2double(handles.nNeurons.String);
       nLayers = str2double(handles.nLayers.String);
       hiddenSizes = nNeurons(:,ones(nLayers-1,1));
       net = layrecnet(1:2, hiddenSizes);
       
   elseif( handles.arquitectura.Value == 3)
       
       %2 conv layer c mts filtros
%            net = [
%         imageInputLayer([29 29 1])
% 
%         convolution2dLayer(6,32,'Padding','same')
%         batchNormalizationLayer
%         reluLayer
%         averagePooling2dLayer(2,'Stride',2)
% 
%         convolution2dLayer(6,48,'Padding','same')
%         batchNormalizationLayer
%         reluLayer
% 
%         fullyConnectedLayer(4)
%         softmaxLayer
%         classificationLayer];
%        
% %          %2 conv layer c poucos filtros
%            net = [
%         imageInputLayer([29 29 1])
% 
%         convolution2dLayer(3,8,'Padding','same')
%         batchNormalizationLayer
%         reluLayer
%         averagePooling2dLayer(2,'Stride',2)
% 
%         convolution2dLayer(3,16,'Padding','same')
%         batchNormalizationLayer
%         reluLayer
% 
%         fullyConnectedLayer(4)
%         softmaxLayer
%         classificationLayer];
%     
%         
%        %1 conv layer c mts filtros
%        net = [
%     imageInputLayer([29 29 1])
% 
%     convolution2dLayer(16,64,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     
%     fullyConnectedLayer(4)
%     softmaxLayer
%     classificationLayer];
% 
% 
%        
%        %1 conv layer c poucos filtros
%        net = [
%     imageInputLayer([29 29 1])
% 
%     convolution2dLayer(3,8,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     
%     fullyConnectedLayer(4)
%     softmaxLayer
%     classificationLayer];
% 
% %   6CONVOLUTION LAYERS ( também fizemos com 5 mas piorava)
%             net = [
%     imageInputLayer([29 29 1])
% 
%     convolution2dLayer(3,8,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     averagePooling2dLayer(2,'Stride',2)
%     convolution2dLayer(3,16,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     averagePooling2dLayer(2,'Stride',2)
%     convolution2dLayer(3,32,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     convolution2dLayer(3,32,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     averagePooling2dLayer(2,'Stride',2)
%     convolution2dLayer(3,48,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     convolution2dLayer(3,48,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     fullyConnectedLayer(4)
%     softmaxLayer
%     classificationLayer];
%        
%        %%4 convolution layers
%        net = [
%     imageInputLayer([29 29 1])
% 
%     convolution2dLayer(3,8)
%     batchNormalizationLayer
%     reluLayer
%     averagePooling2dLayer(2,'Stride',2)
% 
%     convolution2dLayer(3,16)
%     batchNormalizationLayer
%     reluLayer
%     averagePooling2dLayer(2,'Stride',2)
%   
%     convolution2dLayer(3,32)
%     batchNormalizationLayer
%     reluLayer
%     
%     convolution2dLayer(3,32)
%     batchNormalizationLayer
%     reluLayer
%     
%     fullyConnectedLayer(4)
%     softmaxLayer
%     classificationLayer];
% 
%     %%%4 conv layers com dropout 20
%    net = [
%     imageInputLayer([29 29 1])
% 
%     convolution2dLayer(3,8,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     
%     averagePooling2dLayer(2,'Stride',2)
% 
%     convolution2dLayer(3,16,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     
%     averagePooling2dLayer(2,'Stride',2)
%   
%     convolution2dLayer(3,32,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     
%     convolution2dLayer(3,32,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     
%     dropoutLayer(0.2)
%     
%     fullyConnectedLayer(4)
%     softmaxLayer
%     classificationLayer];
%        
%        
%        %%3 conv 16 32 48
       net = [
        imageInputLayer([29 29 1]);
        
        convolution2dLayer(5,16,'Padding','same'); %(filterSize,nFilters,..,..);
        batchNormalizationLayer;
        reluLayer;
        maxPooling2dLayer(2,'Stride',2)
    
        convolution2dLayer(3,32,'Padding','same')
        batchNormalizationLayer
        reluLayer

        maxPooling2dLayer(2,'Stride',2)

        convolution2dLayer(3,48,'Padding','same') 
        batchNormalizationLayer
        reluLayer

        fullyConnectedLayer(4) %4 classes
        softmaxLayer
        classificationLayer

        ];     
%     
%     
%     %  PEQUENOS TAMANHOS E NUM DE FILTROS QUE VAO AUMENTANDO, STRIDES TODOS A 1
%      net = [
%         imageInputLayer([29 29 1]);
%         
%         convolution2dLayer(1,5,'Stride',1); %(filterSize,nFilters,..,..);
%         batchNormalizationLayer;
%         reluLayer;
%         maxPooling2dLayer(1,'Stride',1)
%     
%         convolution2dLayer(3,10,'Stride',1)
%         batchNormalizationLayer
%         reluLayer
% 
%         maxPooling2dLayer(1,'Stride',1)
% 
%         convolution2dLayer(5,15,'Stride',1) 
%         batchNormalizationLayer
%         reluLayer
%         
%         maxPooling2dLayer(1,'Stride',1)
% 
%         fullyConnectedLayer(4) %4 classes
%         softmaxLayer
%         classificationLayer
% 
%         ];
% 
%         %NUM BAIXO DE FILTROS E SIZES 
%          net = [
%         imageInputLayer([29 29 1]);
%         
%         convolution2dLayer(1,8,'Stride',1) %(filterSize,nFilters,..,..);
%         batchNormalizationLayer;
%         reluLayer;
%         maxPooling2dLayer(2, 'Stride',2)
%     
%         convolution2dLayer(1,16,'Stride',1)
%         batchNormalizationLayer
%         reluLayer
% 
%         maxPooling2dLayer(2,'Stride',2)
% 
%         convolution2dLayer(1,24,'Stride',1)
%         batchNormalizationLayer
%         reluLayer
% 
%         fullyConnectedLayer(4) %4 classes
%         softmaxLayer
%         classificationLayer
%         ];
% 
% %         NUM BAIXO DE FILTROS E SIZES ALTOS
%          net = [
%         imageInputLayer([29 29 1]);
%         
%         convolution2dLayer(2,32,'Stride',1) %(filterSize,nFilters,..,..);
%         batchNormalizationLayer;
%         reluLayer;
%         maxPooling2dLayer(2, 'Stride',2)
%     
%         convolution2dLayer(1,48,'Stride',1)
%         batchNormalizationLayer
%         reluLayer
% 
%         maxPooling2dLayer(2,'Stride',2)
% 
%         convolution2dLayer(1,64,'Stride',1)
%         batchNormalizationLayer
%         reluLayer
% 
%         fullyConnectedLayer(4) %4 classes
%         softmaxLayer
%         classificationLayer
%         ];
%     
% %         Stride only on CONVOLUTION 
%          net = [
%         imageInputLayer([29 29 1]);
%         
%         convolution2dLayer(5,16,'Stride',1) %(filterSize,nFilters,..,..);
%         batchNormalizationLayer;
%         reluLayer;
%         maxPooling2dLayer(2)
%     
%         convolution2dLayer(3,32,'Stride',1)
%         batchNormalizationLayer
%         reluLayer
% 
%         maxPooling2dLayer(2)
% 
%         convolution2dLayer(3,48,'Stride',1)
%         batchNormalizationLayer
%         reluLayer
% 
%         fullyConnectedLayer(4) %4 classes
%         softmaxLayer
%         classificationLayer
%         ];
    
   elseif ( handles.arquitectura.Value == 4)
       %%LSTM
       numFeatures = 29;
       numHiddenUnits = 600;
       numClasses = 4;
       if(handles.popupmenulstm.Value == 1)
           disp('Com 1 LSTM LAYER')
           net = [ ...
                sequenceInputLayer(numFeatures)
                lstmLayer(numHiddenUnits,'OutputMode','last')
                fullyConnectedLayer(numClasses)
                softmaxLayer
                classificationLayer];
       elseif(handles.popupmenulstm.Value == 2)
           disp('Com 2 LSTM LAYERS')
           net = [ ...
            sequenceInputLayer(numFeatures)
            lstmLayer(numHiddenUnits,'OutputMode','sequence')
            lstmLayer(numHiddenUnits,'OutputMode','last')
            fullyConnectedLayer(numClasses)
            softmaxLayer
            classificationLayer];
       end
        
       %Com 2 LSTM LAYERS DE 300 HIDDENINPUTS --nao sei se devamos fazer isto---
%        net = [ ...
%         sequenceInputLayer(numFeatures)
%         lstmLayer(300,'OutputMode','sequence')
%         lstmLayer(300,'OutputMode','last')
%         fullyConnectedLayer(numClasses)
%         softmaxLayer
%         classificationLayer];
   end
   
   if( handles.arquitectura.Value < 3) %% APENAS PARA FEEDFORWARD E LAYREC
       
       net.trainParam.epochs = str2double(handles.epochs.String);
       net.performParam.lr = str2double(handles.learningRate.String);
       net.divideParam.trainRatio = str2double(handles.trainingPerc.String);

       if (handles.perfFunc.Value == 1)
           net.performFcn = 'sse';
       else
           net.performFcn = 'mse';
       end
   end
   
end