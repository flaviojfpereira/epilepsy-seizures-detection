function [net] = trainNetworks(handles,net,treinoFeat,treinoTrg,ds)
    if (ds == 1)
        load('NewDataTrg.mat','Trg','FeatVectSel');
    else
        load('115002.mat','Trg','FeatVectSel');
    end
    
    
    interIctalInd = find(treinoTrg(1,:)==1);
    preIctalInd = find(treinoTrg(2,:)==1);
    crysisInd = find(treinoTrg(3,:)==1);
    posIctalInd = find(treinoTrg(4,:)==1);
    
    if(handles.arquitectura.Value < 3)
        %treino FeedForward/Layrec
        pesos = ones(1,length(FeatVectSel));

        if(handles.type.Value == 1)
            %Para prever temos de dar maior valor ao preIctal
            pesos(preIctalInd) = 1;
            if(handles.specialization.Value == 1)
                %High specialization
                pesos(interIctalInd)= 0.01;
                pesos(crysisInd)= 0.02;
                pesos(posIctalInd)= 0.03;
            else
                pesos(interIctalInd)= 0.7;
                pesos(crysisInd)= 0.8;
                pesos(posIctalInd)= 0.9;
            end
        else
            %Para detectar temos de dar maior valor ao crysisInd
            pesos(crysisInd) = 1;
            if(handles.specialization.Value == 1)
                %High specialization
                pesos(interIctalInd)= 0.01;
                pesos(preIctalInd)= 0.02;
                pesos(posIctalInd)= 0.03;
            else
                pesos(interIctalInd)= 0.7;
                pesos(preIctalInd)= 0.8;
                pesos(posIctalInd)= 0.9;
            end

        end

        net = train(net,treinoFeat,treinoTrg,[],[],pesos,'useParallel','yes','useGPU','yes');
        disp(handles.nLayers.String);
        filename = strcat(num2str(handles.arquitectura.Value), '_numberLayers=',  handles.nLayers.String, '_nNeurons=', handles.nNeurons.String, '_preference=', num2str(handles.type.Value), '_specialization=', num2str(handles.specialization.Value), '_balance=', num2str(handles.balance.Value), '.mat');
        disp(filename)
        save(filename, 'net');
    elseif(handles.arquitectura.Value == 3)
        %%treino CNN
        treinoFeatCNN = treinoFeat';
        lengthFeatures = round(length(treinoFeatCNN)/29);
        T = treinoTrg';
        
        treinoTrg = treinoTrg';
         for i=1:length(treinoTrg)
             for j=1:4
                 if(treinoTrg(i,j) == 1)
                    treinoTrg(i,1) = j;
                 end
             end
         end
         aux = treinoTrg(:,1);
         trg = categorical(aux);
        
        imagensAdicionadas=1;

        for i=1:lengthFeatures-29
            aux = T((i-1)*29+1:i*29,:);
            soma1 = sum(aux(:,1));  
            soma2 = sum(aux(:,2));
            soma3 = sum(aux(:,3));
            soma4 = sum(aux(:,4));
            if soma1 == 29 || soma2 == 29 || soma3 == 29 || soma4 == 29
                %So entra se a "imagem" toda contiver a mesma classe
                Xtrain(:,:,1,imagensAdicionadas) = treinoFeatCNN((i-1)*29+1:i*29,:);
                Ytrain(imagensAdicionadas,1) = trg((i-1)*29+1,:); 
                imagensAdicionadas = imagensAdicionadas + 1;
            end                     
        end
        
        YtrainCategorical = categorical(Ytrain);
        
        options = trainingOptions('sgdm', ...
                                  'InitialLearnRate',0.001, ...
                                  'ExecutionEnvironment','cpu', ...
                                  'Verbose',false, ...
                                  'Plots','training-progress');
        %%Train
        net = trainNetwork(Xtrain,YtrainCategorical, net, options);
        filename = strcat(num2str(handles.arquitectura.Value), '_numberLayers=',  handles.nLayers.String, '_nNeurons=', handles.nNeurons.String, '_preference=', num2str(handles.type.Value), '_specialization=', num2str(handles.specialization.Value), '_balance=', num2str(handles.balance.Value), '.mat');
        disp(filename)
        save(filename, 'net');
        
    elseif(handles.arquitectura.Value == 4)
        disp("training LSTM....");
        %%treino LSTM
        maxEpochs = 100;

        options = trainingOptions('adam', ...
            'ExecutionEnvironment','cpu', ...
            'GradientThreshold',1, ...
            'MaxEpochs',maxEpochs, ...
            'SequenceLength','longest', ...
            'Shuffle','never', ...
            'Verbose',0, ...
            'Plots','training-progress');
  
         treinoTrg = treinoTrg';
         for i=1:length(treinoTrg)
             for j=1:4
                 if(treinoTrg(i,j) == 1)
                    treinoTrg(i,1) = j;
                 end
             end
         end
         aux = treinoTrg(:,1);
         trg = categorical(aux);

         trainCell = {};
         for i=1:length(treinoFeat)
             trainCell{i,1} = treinoFeat(:,i); 
         end
       
        
        net = trainNetwork(trainCell,trg,net,options);
        
        filename = strcat(num2str(handles.arquitectura.Value), '_numberLayers=',  handles.nLayers.String, '_nNeurons=', handles.nNeurons.String, '_preference=', num2str(handles.type.Value), '_specialization=', num2str(handles.specialization.Value), '_balance=', num2str(handles.balance.Value), '.mat');
        disp(filename)
        save('LSTMtrained.mat', 'net');
    end

end