function varargout = project2GUI(varargin)
% PROJECT2GUI MATLAB code for project2GUI.fig
%      PROJECT2GUI, by itself, creates a new PROJECT2GUI or raises the existing
%      singleton*.
%
%      H = PROJECT2GUI returns the handle to a new PROJECT2GUI or the handle to
%      the existing singleton*.
%
%      PROJECT2GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT2GUI.M with the given input arguments.
%
%      PROJECT2GUI('Property','Value',...) creates a new PROJECT2GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project2GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project2GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project2GUI

% Last Modified by GUIDE v2.5 13-Nov-2018 21:40:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project2GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @project2GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before project2GUI is made visible.
function project2GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project2GUI (see VARARGIN)

% Choose default command line output for project2GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project2GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project2GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)ckc

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in runBtn.
function runBtn_Callback(hObject, eventdata, handles)
% hObject    handle to runBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
        ds = handles.dataset.Value;

        [testeTrg, testeFeat, treinoTrg,treinoFeat, targetLSTM] = preProcessing(handles);
        if (handles.trainOrTest.Value==1)
            %Para treino
            %Create Network
            net = createNetwork(handles);
            %Train Networkhttps://www.mathworks.com/help/deeplearning/ref/trainnetwork.html
            %ds = handles.dataset.Value;
            trainNetworks(handles,net, treinoFeat, treinoTrg, ds);
        end
        if (handles.trainOrTest.Value==2)
            %TestNetwork
            netToLoad = handles.netToTest.String;
            [ictalTP,ictalTN, ictalFP,ictalFN, ictalSE,ictalSP,preTP,preTN,preFP,preFN,preSE,preSP] = testNetwork( handles, testeFeat,testeTrg, netToLoad);
            %Preictal
            set(handles.sePre,'String', sprintf('Sensivitiy= %f',preSE));
            set(handles.spPre,'String', sprintf('Specificity= %f',preSP));
            set(handles.preTP,'String', sprintf('True Positives= %f',preTP));
            set(handles.preTN,'String', sprintf('True Negatives= %f',preTN));
            set(handles.preFP,'String', sprintf('False Positives= %f',preFP));
            set(handles.preFN,'String', sprintf('False Positives= %f',preFN));
            %Ictal
            set(handles.seIctal,'String', sprintf('Sensivitiy= %f',ictalSE));
            set(handles.spIctal,'String', sprintf('Specificity= %f',ictalSP));
            set(handles.ictalTP,'String', sprintf('True Positives= %f',ictalTP));
            set(handles.ictalTN,'String', sprintf('True Negatives= %f',ictalTN));
            set(handles.ictalFP,'String', sprintf('False Positives= %f',ictalFP));
            set(handles.ictalFN,'String', sprintf('False Positives= %f',ictalFN));
            
        end
       
        
    
    



function nLayers_Callback(hObject, eventdata, handles)
% hObject    handle to nLayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.nLayers = str2double(get(hObject,'String'));
    guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function nLayers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nLayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nNeurons_Callback(hObject, eventdata, handles)
% hObject    handle to nNeurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.nNeurons = str2double(get(hObject,'String'));
    guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function nNeurons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nNeurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epochs_Callback(hObject, eventdata, handles)
% hObject    handle to epochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epochs as text
%        str2double(get(hObject,'String')) returns contents of epochs as a double


% --- Executes during object creation, after setting all properties.
function epochs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function learningRate_Callback(hObject, eventdata, handles)
% hObject    handle to learningRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of learningRate as text
%        str2double(get(hObject,'String')) returns contents of learningRate as a double


% --- Executes during object creation, after setting all properties.
function learningRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to learningRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in perfFunc.
function perfFunc_Callback(hObject, eventdata, handles)
% hObject    handle to perfFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns perfFunc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from perfFunc


% --- Executes during object creation, after setting all properties.
function perfFunc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to perfFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to nFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nFeatures as text
%        str2double(get(hObject,'String')) returns contents of nFeatures as a double


% --- Executes during object creation, after setting all properties.
function nFeatures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trainingPerc_Callback(hObject, eventdata, handles)
% hObject    handle to trainingPerc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trainingPerc as text
%        str2double(get(hObject,'String')) returns contents of trainingPerc as a double


% --- Executes during object creation, after setting all properties.
function trainingPerc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainingPerc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function testingPerc_Callback(hObject, eventdata, handles)
% hObject    handle to testingPerc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testingPerc as text
%        str2double(get(hObject,'String')) returns contents of testingPerc as a double


% --- Executes during object creation, after setting all properties.
function testingPerc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testingPerc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in type.
function type_Callback(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
handles.type = contents{get(hObject,'Value')};
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from type


% --- Executes during object creation, after setting all properties.
function type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dataset.
function dataset_Callback(hObject, eventdata, handles)
% hObject    handle to dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dataset contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataset


% --- Executes during object creation, after setting all properties.
function dataset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in balance.
function balance_Callback(hObject, eventdata, handles)
% hObject    handle to balance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
handles.balance = contents{get(hObject,'Value')};
guidata(hObject, handles);

%handles.nNeurons = str2num(get(hObject,'String'));
%guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns balance contents as cell array
%        contents{get(hObject,'Value')} returns selected item from balance


% --- Executes during object creation, after setting all properties.
function balance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to balance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in trainOrTest.
function trainOrTest_Callback(hObject, eventdata, handles)
% hObject    handle to trainOrTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns trainOrTest contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trainOrTest


% --- Executes during object creation, after setting all properties.
function trainOrTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainOrTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in arquitectura.
function arquitectura_Callback(hObject, eventdata, handles)
% hObject    handle to arquitectura (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
contents{get(hObject,'Value')};
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function arquitectura_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arquitectura (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in specialization.
function specialization_Callback(hObject, eventdata, handles)
% hObject    handle to specialization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
handles.specialization = contents{get(hObject,'Value')};
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns specialization contents as cell array
%        contents{get(hObject,'Value')} returns selected item from specialization


% --- Executes during object creation, after setting all properties.
function specialization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to specialization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in postProcessing.
function postProcessing_Callback(hObject, eventdata, handles)
% hObject    handle to postProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns postProcessing contents as cell array
%        contents{get(hObject,'Value')} returns selected item from postProcessing


% --- Executes during object creation, after setting all properties.
function postProcessing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to postProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenulstm.
function popupmenulstm_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenulstm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenulstm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenulstm


% --- Executes during object creation, after setting all properties.
function popupmenulstm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenulstm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function netToTest_Callback(hObject, eventdata, handles)
% hObject    handle to netToTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of netToTest as text
%        str2double(get(hObject,'String')) returns contents of netToTest as a double


% --- Executes during object creation, after setting all properties.
function netToTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to netToTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
