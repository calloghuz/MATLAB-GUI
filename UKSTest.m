function varargout = UKSTest(varargin)
% UKSTEST MATLAB code for UKSTest.fig
%      UKSTEST, by itself, creates a new UKSTEST or raises the existing
%      singleton*.
%
%      H = UKSTEST returns the handle to a new UKSTEST or the handle to
%      the existing singleton*.
%
%      UKSTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UKSTEST.M with the given input arguments.
%
%      UKSTEST('Property','Value',...) creates a new UKSTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UKSTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UKSTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UKSTest

% Last Modified by GUIDE v2.5 07-Mar-2019 16:38:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UKSTest_OpeningFcn, ...
                   'gui_OutputFcn',  @UKSTest_OutputFcn, ...
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


% --- Executes just before UKSTest is made visible.
function UKSTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UKSTest (see VARARGIN)

% Choose default command line output for UKSTest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UKSTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UKSTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnOpen.
function btnOpen_Callback(hObject, eventdata, handles)

global a;
global fs;
global L;
global af;
global yukleme;
yukleme =1;
global f;
global THDNmax
global THDNmin
global SNRmax
global SNRmin
global RMSmax
global RMSmin
global THDN
global SNR
global RMS

mv=0;



Tmax=get(handles.txtTHDN3,'String');
THDNmax = str2num(Tmax);
Tmin=get(handles.txtTHDN2,'String');
THDNmin = str2num(Tmin);

Smax=get(handles.txtSNR3,'String');
SNRmax = str2num(Smax);
Smin=get(handles.txtSNR2,'String');
SNRmin = str2num(Smin);

Rmax=get(handles.txtRMS3,'String');
RMSmax = str2num(Rmax);
Rmin=get(handles.txtRMS2,'String');
RMSmin = str2num(Rmin);

if THDNmax<=THDNmin
m = msgbox('Please check the ranges');
mv=1;
end

if SNRmax<=SNRmin
m = msgbox('Please check the ranges');
mv=1;
end

if RMSmax<=RMSmin
m = msgbox('Please check the ranges');
mv=1;
end




%--------------------------------------------------------------
if mv==0
    
        
    [file,path] = uigetfile('*.wav', 'Select a wav file');
    if isequal(file,0) 
else
       
    f=fullfile(path, file)
   
    [a, fs] = audioread(f);
    a=a(:,1);
    L = length(a);
    af = abs(fft(a, fs));
    af = af(1:end/2); % 1 Hz çözünürlük
    
    
    axes(handles.graph1);
    plot((0:1/fs:(L-1)/fs), a);
    grid on;
    xlabel('Time (s)') 
    ylabel('RMS')
    title('Amplitude')
    xlim(handles.graph1, [2, 2.01]);
    
    
    axes(handles.graph2);
    pwelch(a, [], [], [], fs, 'onesided');


    axes(handles.graph3);
    plot((0:fs/2-1), af);
    grid on;
    xlabel('Frequency (Hz)') 
    title('Power Spectral Density (Linear Scale)')
   
    
%     figure, plot((0:1/fs:(L-1)/fs), a);
%     figure, plot((0:fs/2-1), af);
%     figure, pwelch(a, [], [], [], fs, 'onesided');

    signal_power = sum(af(999:1003).^2); % [998-1002] Hz enerji toplamý
    noise_power = sum(af.^2) - signal_power % Geri kalan tümünün toplamý

    THDN = 100 * noise_power / signal_power  % total harmonic distortion + noise, yüzde olarak
    SNR = 10 * log10(signal_power / noise_power)
    RMS = rms(a)

    txt1 = mat2str(THDN);
    txt2 = mat2str(SNR);
    txt3 = mat2str(RMS);

    set(handles.txtTHDN, 'String', txt1);
    set(handles.txtSNR, 'String', txt2);
    set(handles.txtRMS, 'String', txt3);
    
    try
        if THDN<=THDNmax && THDN>=THDNmin
            set(handles.lblTHDN, 'Visible', 'on')
            set(handles.lblTHDN2, 'Visible', 'off')
            %set(handles.lblTHDN,'ForegroundColor','green')
            %set(handles.lblTHDN, 'String','?')

        else
            set(handles.lblTHDN2, 'Visible', 'on')
            set(handles.lblTHDN, 'Visible', 'off')
            %set(handles.lblTHDN,'ForegroundColor','red')
            %set(handles.lblTHDN, 'String','X')
        end
    catch
        set(handles.lblTHDN2, 'Visible', 'on')
        set(handles.lblTHDN, 'Visible', 'off')
    end
    
    try
        if SNR<=SNRmax && SNR>=SNRmin
            set(handles.lblSNR, 'Visible', 'on')
            set(handles.lblSNR2, 'Visible', 'off')
            %set(handles.lblSNR,'ForegroundColor','green')
        else
            set(handles.lblSNR2, 'Visible', 'on')
            set(handles.lblSNR, 'Visible', 'off')
            %set(handles.lblSNR,'ForegroundColor','red')
            %set(handles.lblSNR, 'String','X')
        end
    catch
        set(handles.lblSNR2, 'Visible', 'on')
        set(handles.lblSNR, 'Visible', 'off')
    end
    
    
    try
        if RMS<=RMSmax && RMS>=RMSmin
            set(handles.lblRMS, 'Visible', 'on')
            set(handles.lblRMS2, 'Visible', 'off')
            %set(handles.lblRMS,'ForegroundColor','green')
        else
            set(handles.lblRMS2, 'Visible', 'on')
            set(handles.lblRMS, 'Visible', 'off')
            %set(handles.lblRMS,'ForegroundColor','red')
            %set(handles.lblRMS, 'String','X')
        end
    catch
        set(handles.lblRMS2, 'Visible', 'on')
        set(handles.lblRMS, 'Visible', 'off')
    end
    
    end

elseif mv==1
    
end




function txtTHDN_Callback(hObject, eventdata, handles)
% hObject    handle to txtTHDN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTHDN as text
%        str2double(get(hObject,'String')) returns contents of txtTHDN as a double


% --- Executes during object creation, after setting all properties.
function txtTHDN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTHDN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function txtSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function txtRMS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btnOpen.
function btnOpen_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to btnOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnClear.
function btnClear_Callback(hObject, eventdata, handles)
% hObject    handle to btnClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   
    global f;
    f='';
    set(handles.txtTHDN, 'String', '');
    set(handles.txtSNR, 'String', '');
    set(handles.txtRMS, 'String', '');
    set(handles.lblTHDN, 'Visible', 'off')
    set(handles.lblSNR, 'Visible', 'off')
    set(handles.lblRMS, 'Visible', 'off')
    set(handles.lblTHDN2, 'Visible', 'off')
    set(handles.lblSNR2, 'Visible', 'off')
    set(handles.lblRMS2, 'Visible', 'off')
    
    cla(handles.graph1,'reset');
    cla(handles.graph2,'reset');
    cla(handles.graph3,'reset');

    clear values    
    clear all
    clc    
   

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function txtTHDN2_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function txtTHDN2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTHDN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtTHDN3_Callback(hObject, eventdata, handles)
% hObject    handle to txtTHDN3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTHDN3 as text
%        str2double(get(hObject,'String')) returns contents of txtTHDN3 as a double


% --- Executes during object creation, after setting all properties.
function txtTHDN3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTHDN3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtSNR2_Callback(hObject, eventdata, handles)
% hObject    handle to txtSNR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSNR2 as text
%        str2double(get(hObject,'String')) returns contents of txtSNR2 as a double


% --- Executes during object creation, after setting all properties.
function txtSNR2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSNR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtSNR3_Callback(hObject, eventdata, handles)
% hObject    handle to txtSNR3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSNR3 as text
%        str2double(get(hObject,'String')) returns contents of txtSNR3 as a double


% --- Executes during object creation, after setting all properties.
function txtSNR3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSNR3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtRMS2_Callback(hObject, eventdata, handles)
% hObject    handle to txtRMS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRMS2 as text
%        str2double(get(hObject,'String')) returns contents of txtRMS2 as a double


% --- Executes during object creation, after setting all properties.
function txtRMS2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRMS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtRMS3_Callback(hObject, eventdata, handles)
% hObject    handle to txtRMS3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRMS3 as text
%        str2double(get(hObject,'String')) returns contents of txtRMS3 as a double


% --- Executes during object creation, after setting all properties.
function txtRMS3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRMS3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkRange.
function chkRange_Callback(hObject, eventdata, handles)
value = get(handles.chkRange, 'Value')
if value==1
    set(handles.text16, 'Visible', 'on')
    set(handles.text19, 'Visible', 'on')
    set(handles.text20, 'Visible', 'on')
    set(handles.text17, 'Visible', 'on')
    set(handles.text21, 'Visible', 'on')
    set(handles.text22, 'Visible', 'on')
    set(handles.text18, 'Visible', 'on')
    set(handles.text23, 'Visible', 'on')
    set(handles.text24, 'Visible', 'on')
    set(handles.txtTHDN2, 'Visible', 'on')
    set(handles.txtTHDN3, 'Visible', 'on')
    set(handles.txtSNR2, 'Visible', 'on')
    set(handles.txtSNR3, 'Visible', 'on')
    set(handles.txtRMS2, 'Visible', 'on')
    set(handles.txtRMS3, 'Visible', 'on')
elseif value==0
    set(handles.text16, 'Visible', 'off')
    set(handles.text19, 'Visible', 'off')
    set(handles.text20, 'Visible', 'off')
    set(handles.text17, 'Visible', 'off')
    set(handles.text21, 'Visible', 'off')
    set(handles.text22, 'Visible', 'off')
    set(handles.text18, 'Visible', 'off')
    set(handles.text23, 'Visible', 'off')
    set(handles.text24, 'Visible', 'off')
    set(handles.txtTHDN2, 'Visible', 'off')
    set(handles.txtTHDN3, 'Visible', 'off')
    set(handles.txtSNR2, 'Visible', 'off')
    set(handles.txtSNR3, 'Visible', 'off')
    set(handles.txtRMS2, 'Visible', 'off')
    set(handles.txtRMS3, 'Visible', 'off')
end



function txtG1_Callback(hObject, eventdata, handles)
% hObject    handle to txtG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtG1 as text
%        str2double(get(hObject,'String')) returns contents of txtG1 as a double


% --- Executes during object creation, after setting all properties.
function txtG1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSetG.
function btnSetG_Callback(hObject, eventdata, handles)


try
a=get(handles.txtG1, 'String');
b=get(handles.txtG11, 'String');
a2=str2num(a);
b2=str2num(b);
xlim(handles.graph1, [a2, b2]);
catch
    m = msgbox('Wrong values');
end


function txtG11_Callback(hObject, eventdata, handles)
% hObject    handle to txtG11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtG11 as text
%        str2double(get(hObject,'String')) returns contents of txtG11 as a double


% --- Executes during object creation, after setting all properties.
function txtG11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtG11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
