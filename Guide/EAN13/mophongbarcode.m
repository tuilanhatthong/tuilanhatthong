function varargout = mophongbarcode(varargin)
% MOPHONGBARCODE MATLAB code for mophongbarcode.fig
%      MOPHONGBARCODE, by itself, creates a new MOPHONGBARCODE or raises the existing
%      singleton*.
%
%      H = MOPHONGBARCODE returns the handle to a new MOPHONGBARCODE or the handle to
%      the existing singleton*.
%
%      MOPHONGBARCODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOPHONGBARCODE.M with the given input arguments.
%
%      MOPHONGBARCODE('Property','Value',...) creates a new MOPHONGBARCODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mophongbarcode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mophongbarcode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mophongbarcode

% Last Modified by GUIDE v2.5 02-Nov-2021 18:17:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mophongbarcode_OpeningFcn, ...
                   'gui_OutputFcn',  @mophongbarcode_OutputFcn, ...
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


% --- Executes just before mophongbarcode is made visible.
function mophongbarcode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mophongbarcode (see VARARGIN)

% Choose default command line output for mophongbarcode
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes mophongbarcode wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mophongbarcode_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_open.
function pushbutton_open_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global S
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.jpg';'*.gif'}, 'Pick an Image File');
S = imread([pathname,filename]);
axes(handles.axes_video);
imshow(S);
axis on
set(handles.axes_video,'XAxisLocation','top','YAxisLocation','left');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgReaded g
sigma=get(handles.edit_sigma,'String');
g=imgaussfilt(imgReaded,str2num(sigma));
axes(handles.axes_video);
imshow(g);
axis on
set(handles.axes_video,'XAxisLocation','top','YAxisLocation','left');

% --- Executes on button press in pushbutton_Otsu.
function pushbutton_Otsu_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Otsu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g g1
g1=im2bw(g,graythresh(g));
axes(handles.axes_video);
imshow(g1);
axis on
set(handles.axes_video,'XAxisLocation','top','YAxisLocation','left');

% --- Executes on button press in pushbutton_morpho.
function pushbutton_morpho_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_morpho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g1 imgMorph
se = strel ('line', 45, 0);
imgMorph = imtophat (g1, se);
axes(handles.axes_video);
imshow(imgMorph);
axis on
set(handles.axes_video,'XAxisLocation','top','YAxisLocation','left');


function edit_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sigma as text
%        str2double(get(hObject,'String')) returns contents of edit_sigma as a double


% --- Executes during object creation, after setting all properties.
function edit_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_res1.
function pushbutton_res1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_res1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgMorph imgRescaled
[x,y] = size (imgMorph);
midx = round (x/2);

 i = 1;
 yinit = i+1;
 while (imgMorph (midx, i) == 0)
     i=i+1;
     yinit = i;
 end

 i = y;
 yend = i-1;
 while (imgMorph (midx, i) == 0)
      i=i-1;
      yend = i;
 end
 
imgRescaled = imgMorph (midx:midx, yinit:yend);
axes(handles.axes_video);
imshow(imgRescaled);
assignin('base','Rescale_1',imgRescaled)


% --- Executes on button press in pushbutton_res2.
function pushbutton_res2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_res2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgRescaled
imgRescaled = imresize (imgRescaled, [1 10*95]);
axes(handles.axes_video);
imshow(imgRescaled);
assignin('base','Rescale_2',imgRescaled)

% --- Executes on button press in pushbutton_check.
function pushbutton_check_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%  BarCode Decodification
global imgRescaled
% Check C1

digit = 1;
 C1 = imgRescaled (digit:digit+2);
digit = digit + 3;
 if (C1 ~= [1 0 1])
     disp ('Error on C1');
 end;
 
ean13 = [0 0 0 0 0 0 0 0 0 0 0 0 0];


ean13 (2) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (3) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (4) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (5) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (6) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (7) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;

C2 = imgRescaled (digit:digit+4);
digit = digit + 5;
  if (C2 ~= [0 1 0 1 0])
    disp ('Error on C2');   
  end;

ean13 (8) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (9) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (10) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (11) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (12) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (13) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;

%% Check Digit
    
mult = [3 1 3 1 3 1 3 1 3 1 3 1];

checkDigit = ean13 (2:13).*mult;
c_checkDigit = sum(checkDigit);

sub = ceil(c_checkDigit / 10) * 10;
checkDigit = sub - c_checkDigit;

ean13(1) = checkDigit;

ean13str = mat2str (ean13);

disp ('output is: ');
disp (ean13str);
set(handles.text_code,'String',ean13str)


% --- Executes on button press in pushbutton_gray.
function pushbutton_gray_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global S imgReaded
imgReaded = rgb2gray (S);
axes(handles.axes_video);
imshow(imgReaded)
axis on
set(handles.axes_video,'XAxisLocation','top','YAxisLocation','left');


% --- Executes on button press in pushbutton_dao.
function pushbutton_dao_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_dao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g1
axes(handles.axes_video);
imshow(~g1);
axis on
set(handles.axes_video,'XAxisLocation','top','YAxisLocation','left');
g1=~g1;


% --- Executes on button press in pushbutton_ean.
function pushbutton_ean_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgRescaled
imgBits = zeros (95);
for i=1:95
    imgBits(1,i) = imgRescaled(1, 10*(i-1)+5);
end
imgRescaled = imgBits(1,:);
axes(handles.axes_video);
imshow(imgRescaled);
assignin('base','Rescale_95',imgRescaled)


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
