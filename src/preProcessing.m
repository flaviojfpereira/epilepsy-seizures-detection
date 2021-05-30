function [testeTrg, testeFeat, treinoTrg,treinoFeat, target] = preProcessing( handles)
    if (handles.dataset.Value == 1)
        load('NewDataTrg.mat','Trg','FeatVectSel');
    else
        load('115002.mat','Trg','FeatVectSel');
    end
    
    % Para identificar as 4 classes -> 1- interictal | 2- preictal | 3- ictal | 4- posictal    
    target = Trg;
    dif = diff(target); 
    
    startPoint = find( dif == 1);
    endPoint = find( dif ==-1);
    
    for i = 1:length(startPoint)
        aux = startPoint(i);
        startPreIctal = aux-600;
        target(startPreIctal:aux) = 2;
        aux1 = endPoint(i)+1;
        startPosIctal =  aux1+301;
        target(aux1:startPosIctal)=4;
        target(startPoint(i):endPoint(i))= 3;
    end
    
    startPoint = startPoint-600;
    endPoint = endPoint +301;
    inter_ictal=find(target == 0);
    
    for i = 1:length(inter_ictal)
        target(inter_ictal(i))=1;
    end
    
    
    %Para colocar cada classe de acordo com o output do classificador ->
    %por exemplo- interictal -> 1000
    T = zeros(length(target), 4);     
    for j=1:length(target)
        T(j,target(j))=1;
    end
    
    trainPercentage = str2num(handles.trainingPerc.String);    
    nCris = round(length(startPoint)*trainPercentage);
    
    %Vai buscar x crises para o treino
    crisesTreino = [];
    for k=1:nCris
        crisesTreino = [crisesTreino startPoint(k):1:endPoint(k)];
        %crisesTreino = cat(1,crisesTreino,startPoint(k):1:endPoint(k));
    end
    
    
    tamanhoInter = length(target) - length(crisesTreino);
    
    %%Balanceamento 
    if (handles.balance.Value == 1)
        tamanhoInter = length(crisesTreino);
    end
    
    %%Vai buscar os pontos inter, para dps adicionar aos casos de treino
    pontosInter = transpose(find(target == 1));
    pontosInter = pontosInter(1:tamanhoInter);
    
    %Casos para treino
    treinoInd = [pontosInter crisesTreino];
    treinoInd = sort(treinoInd);
    treinoFeat = transpose(FeatVectSel(treinoInd, : ));
    treinoTrg = transpose(T(treinoInd,:));
   
    %Casos para teste    
    indices = 1:length(FeatVectSel);   
    testeInd = setdiff(indices, treinoInd); %%vai buscar os casos que faltam => os que não estão para treino
    testeFeat = transpose(FeatVectSel(testeInd, : ));
    testeTrg = transpose(T(testeInd,:));
    
    
    
    
   %save('target.mat','target','startPoint','endPoint','T', 'testeTrg', 'testeFeat', 'treinoTrg','treinoFeat','pontosInter');
end
    
