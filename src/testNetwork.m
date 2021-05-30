function [ictalTP,ictalTN, ictalFP,ictalFN, ictalSE,ictalSP,preTP,preTN,preFP,preFN,preSE,preSP] = testNetwork(handles,testeFeat,testeTrg, netToLoad)

    %load('rede','net'); ISTO ERA PARA SHALLOWS
    disp(strcat( netToLoad, ' being tested...'))
    filename = strcat(netToLoad, '.mat');
    load(strcat(filename), 'net');
    
    if(handles.arquitectura.Value < 3)
        output = sim(net,testeFeat);
        
        %%Converter resultados-> em cada coluna, coloca o valor a 1 na linha
        %%indicada-> converte para o sistema 1000/0100/0010/0001
        convertedOutput=zeros(4,length(output));
        for i=1:length(output)
            maior = 1;
            for j=2:4
                if(output(maior,i) < output(j,i))
                    maior = j;
                end
            end
            convertedOutput(:,i)=zeros(4,1);
            convertedOutput(maior,i)=1;
        end

       
        disp("guardou");
    elseif(handles.arquitectura.Value == 3)
        %CONVERSAO TESTEFEAT NO FORMATO NECESS�RIO PARA ENTRAR NUMA CNN
        testeFeatCNN = testeFeat';
        lengthFeatures = round(length(testeFeatCNN)/29);
        T = testeTrg';

        imagensAdicionadas=1;
        for i=1:lengthFeatures-29
            aux = T((i-1)*29+1:i*29,:);
            soma1 = sum(aux(:,1));  
            soma2 = sum(aux(:,2));
            soma3 = sum(aux(:,3));
            soma4 = sum(aux(:,4));
            if soma1 == 29 || soma2 == 29 || soma3 == 29 || soma4 == 29
                %So entra se a "imagem" toda contiver a mesma classe
                Xteste(:,:,1,imagensAdicionadas) = testeFeatCNN((i-1)*29+1:i*29,:);
                testeTrgCNN(:,imagensAdicionadas) = testeTrg(:,(i-1)*29+1); %4xTime
                imagensAdicionadas = imagensAdicionadas + 1;
            end                     
        end
        testeTrg = testeTrgCNN;
        
        output = classify(net,Xteste);

        %CONVERTION TO 0s and 1s
        newoutput = zeros(length(output), 4);     
        for j=1:length(output)
            newoutput(j,output(j))=1;
        end

        convertedOutput = newoutput'; %4xTempo
        
    elseif(handles.arquitectura.Value == 4)
        %CONVERSAO TESTEFEAT NO FORMATO NECESS�RIO PARA ENTRAR NUMA LSTM
        testeCell = {};
        for i=1:length(testeFeat)
            testeCell{i,1} = testeFeat(:,i); 
        end
        
        output = classify(net,testeCell);

        %CONVERTION TO 0s and 1s
        newoutput = zeros(length(output), 4);     
        for j=1:length(output)
            newoutput(j,output(j))=1;
        end

        convertedOutput = newoutput'; %4xTempo
        
    end
    
    

    %Post Processing
    if( handles.postProcessing.Value == 2)
        %a seizure is predicted only if, for example, one finds 10 consecutive points classified as preictal, and
        %  a seizure is detected only if the classifier finds 10 consecutive ictal points
        for i=1:length(convertedOutput)-10
            %auxOutput = [];
            %auxOuput = convertedOutput(:,i:i+9);
            for j=1:9
                if(~isequal(convertedOutput(:,i),convertedOutput(:,i+j)))
                    convertedOutput(:,i) = [1;0;0;0];
                    break;
                end
            end
                    
        end
    elseif( handles.postProcessing.Value == 3)
        % However, a more relaxed hypothesis can be followed, and instead of 10 consecutive one may accept
        %5 among the last 10 points as a tentative threshold.
        for i=1:length(convertedOutput)-10
            %auxOutput = convertedOutput(:,i:i+9);
            contador = 0;
            for j=1:9
                if(isequal(convertedOutput(:,i),convertedOutput(:,i+j)))
                    contador = contador+1;
                end
            end
            if(contador < 5)
                convertedOutput(:,i) = [1;0;0;0];
            end                             
        end
    end
    
%     Sensitivity and Specificity
%     TP- seizures reais que foram corretamente identificadas
%     TN - "não" seizures" que foram corretamente "não" identificadas
%     FP - "não" seizures que foram detectadas incorretamente
%     FN - seizures reais que não foram identificadas
    
%     Para detectar
    ictalTP = 0;
    ictalTN = 0;
    ictalFP = 0;
    ictalFN = 0;
    %Para prever
    preTP = 0; 
    preTN = 0;
    preFP = 0;
    preFN = 0;
    
   
    for i=1:length(convertedOutput)

        if(convertedOutput(3,i) == testeTrg(3,i))
            %TRUE
            if(convertedOutput(3,i)==1)
                ictalTP = ictalTP+1;
            else
                ictalTN = ictalTN+1;
            end
        else
            %False
            if(convertedOutput(3,i)==1)
                ictalFP = ictalFP+1;
            else
                ictalFN = ictalFN+1;
            end
        end

        if(convertedOutput(2,i) == testeTrg(2,i))
            %TRUE
            if(convertedOutput(2,i)==1)
                preTP = preTP+1;
            else
                preTN = preTN +1;
            end
        else
            %FALSE
            if(convertedOutput(2,i)==1)
                preFP = preFP+1;
            else
                preFN = preFN+1;
            end

        end
    end


    
    ictalSE = (ictalTP)/(ictalTP+ictalFN)
    ictalSP = (ictalTN) / (ictalTN + ictalFP)
    
    preSE = (preTP)/(preTP+preFN)
    preSP = (preTN) / (preTN + preFP)
    
    %CHECK ACCURACY ON DETECTING
    equalCountD=0;
    detectCount=0;
    for i=1:length(convertedOutput)
        if isequal(testeTrg(:,i),[0;0;1;0]) 
            detectCount = detectCount + 1;
            if isequal(convertedOutput(:,i), testeTrg(:,i))
                equalCountD = equalCountD + 1;
            end
        end
    end
   % accuracy = equalCount/length(convertedOutput)
   disp('ACCURACY ON DETECTING')
   accuracyDetect = equalCountD / detectCount
   
   
   %CHECK ACCURACY ON PREDICTING
    equalCountP=0;
    predictCount=0;
    for i=1:length(convertedOutput)
        if isequal(testeTrg(:,i),[0;1;0;0]) 
            predictCount = predictCount + 1;
            if isequal(convertedOutput(:,i), testeTrg(:,i))
                equalCountP = equalCountP + 1;
            end
        end
    end
    
    disp('ACCURACY ON PREDICTING')
    accuracyPredict = equalCountP / predictCount
    
    
end