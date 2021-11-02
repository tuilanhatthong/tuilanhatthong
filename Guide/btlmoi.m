function varargout = btlmoi(varargin)
% BTLMOI MATLAB code for btlmoi.fig
%      BTLMOI, by itself, creates a new BTLMOI or raises the existing
%      singleton*.
%
%      H = BTLMOI returns the handle to a new BTLMOI or the handle to
%      the existing singleton*.
%
%      BTLMOI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BTLMOI.M with the given input arguments.
%
%      BTLMOI('Property','Value',...) creates a new BTLMOI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before btlmoi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to btlmoi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help btlmoi

% Last Modified by GUIDE v2.5 01-Nov-2021 13:22:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @btlmoi_OpeningFcn, ...
                   'gui_OutputFcn',  @btlmoi_OutputFcn, ...
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


% --- Executes just before btlmoi is made visible.
function btlmoi_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to btlmoi (see VARARGIN)

% Choose default command line output for btlmoi
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global data msg detectedFormat product_data product_label obj sum sumprice name_element price_element sumprice_1;
sum=[];
sumprice=0;
name_element=[];
price_element=[];
data=[];
msg=0;
detectedFormat=0;
product_data=0;
product_label=0;
obj=0;
set(handles.radiobutton_camera,'value',0);
set(handles.radiobutton_read,'value',0);


% UIWAIT makes btlmoi wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = btlmoi_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_data.
function pushbutton_data_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;
[file path]=uigetfile('*.csv;*.edf;*.tsv;*.xlsx;*.txt');
S = strcat(path,file);
path_name=convertCharsToStrings(file);
split_path=split(path_name,".");
number=length(split_path);
final_name=convertStringsToChars(split_path(number));%chon duoi file
%phan loai file csv, txt, xlsx, xls
if strcmp(final_name,'csv') | strcmp(final_name,'txt')
    filetype='text';
elseif strcmp(final_name,'xlsx') | strcmp(final_name,'xls')
    filetype='spreadsheet';
else
    filetype=[];
end
opts=detectImportOptions(S,'FileType',filetype,'PreserveVariableNames',true);%get options of file
data=readtable(S,opts);
set(handles.text_data,'string','OK');
set(handles.uibuttongroup1,'visible','on');
set(handles.text5,'String','Step 2:');

% --- Executes on button press in pushbutton_inputvideo.
function pushbutton_inputvideo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_inputvideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data msg detectedFormat product_data product_label obj sum sumprice name_element price_element sumprice_1;
%% Read barcode by video
adaptorname=imaqhwinfo;% install Image Acquisition Toolbox™ Support Package for OS Generic Video Interface
adaptorname=string(adaptorname.InstalledAdaptors);
info=imaqhwinfo(adaptorname);
dev_ID=info.DeviceInfo.DeviceID;
dev_res_max=string(info.DeviceInfo.SupportedFormats(1,end));
%%%% lenh goi camera
set(handles.axes_video);
obj=videoinput(adaptorname,dev_ID,dev_res_max); %lenh mo camera
set(obj,'ReturnedColorSpace','rgb');%set color to rbg
config = triggerinfo(obj);
triggerconfig(obj,config(2));%trigger in manual=>video chay lien tuc
vid_info=propinfo(obj);%take information of video
vid_res=get(obj,'VideoResolution');%resolution of video
nBands=get(obj,'NumberOfBands');%take 3 colors
hImage=image(zeros(vid_res(2),vid_res(1),nBands),'Parent',handles.axes_video);
start(obj);
preview(obj,hImage);
%% detect the barcode
detect=0;
while detect ~=1
    temp=getsnapshot(obj);
    [msg,detectedFormat,locs] = readBarcode(temp,'1D');
    if strcmp(msg,"")==1
        temp=[];
    else
        set(handles.axes_image);
        % Insert a line to show the scan row of the barcode.
        xyBegin = locs(1,:); imSize = size(temp);
        temp = insertShape(temp,"Line",[1 xyBegin(2) imSize(2) xyBegin(2)],"lineWidth",7);
        % Insert markers at the end locations of the barcode.
        temp = insertShape(temp, "FilledCircle", [locs, repmat(10, length(locs), 1)], "Color", "red", "Opacity", 1);
        imshow(temp);
        detect=1;
        delete(obj);
        obj=0;
        cla(handles.axes_video,'reset')
    end
end
%% Search barcode with database
variableName=data.Properties.VariableNames;%take the VariableNames
length_varName=length(variableName);
temp_data=0;
for i=1:length_varName
    if strcmp(variableName(1,i),detectedFormat)==1
        temp_data=table2array(data(:,i));
    end
end
length_variable=length(temp_data);
count=0;
for i=1:length_variable
    if strcmp(temp_data(i,1),cellstr(msg))==1
        index=i;
        count=1;
    end
end
if count==0
    product_data={convertStringsToChars(msg); 'Khong co database'};
    product_label=[detectedFormat; 'Description'];
else
    product_info=data(index,:);
    product_data=(product_info{1:height(product_info),1:width(product_info)})';
    product_label=product_info.Properties.VariableNames;
end
set(handles.uitable_info,'Data',product_data,'RowName',product_label);
if count ~=0
    set(handles.text_name,'String',cellstr(product_data(4)))    %Column Excel
    set(handles.text_gia,'String',cellstr(product_data(6)))
    name_element=[name_element,product_data(4)];
    price_element=[price_element,product_data(6)];
    sum=[sum,product_data(6)];
    price=str2double(string(sum));
    sumprice=0;
    for i=1:size(price,2)
        sumprice=sumprice+price(i);
        i=i+1;
    end
    sumprice_1=double(sumprice);
    set(handles.text_sum,'String',num2str(sumprice_1))
else
    msgbox('Invalid Value', 'Error','error');
    set(handles.text_name,'String',cellstr(product_data(1)))
    set(handles.text_gia,'String','0')
end
set(handles.uitable_info,'Data',product_data,'RowName',product_label);
set(handles.pushbutton_bill,'visible','on');

% --- Executes on button press in pushbutton_reset.

function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data msg detectedFormat product_data product_label obj sum sumprice name_element price_element sumprice_1;
data=[];
msg=0;
name_element=[];
price_element=[];
detectedFormat=0;
cla(handles.axes_video,'reset');
cla(handles.axes_image,'reset');
set(handles.uitable_info, 'Data', cell(size(get(handles.uitable_info,'Data'))));
set(handles.uitable_info, 'RowName', cell(size(get(handles.uitable_info,'RowName'))));
product_data=0;
product_label=0;
sum=[];
sumprice=0;
if strcmp(class(obj),'videoinput')==1
    delete(obj);
    obj=0;
else
end
set(handles.radiobutton_camera,'value',0);
set(handles.radiobutton_read,'value',0);
set(handles.text_data,'String','');
set(handles.uibuttongroup1,'visible','off');
set(handles.axes_video,'visible','off');
set(handles.axes_image,'visible','off');
set(handles.text5,'String','');
set(handles.text6,'String','');
set(handles.text8,'String','');
set(handles.text_gia,'String','');
set(handles.text_sum,'String','');
set(handles.text_name,'String','');
set(handles.pushbutton_open,'visible','off')
set(handles.pushbutton_inputvideo,'visible','off')
set(handles.pushbutton_bill,'visible','off');


% --- Executes on button press in pushbutton_open.
function pushbutton_open_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data msg detectedFormat product_data product_label obj sum sumprice name_element price_element sumprice_1;
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.jpg';'*.gif'}, 'Pick an Image File');
S = imread([pathname,filename]);
axes(handles.axes_video);
imshow(S);
%% detect the barcode
temp=S;
[msg,detectedFormat,locs] = readBarcode(temp,'1D');
% Insert a line to show the scan row of the barcode.
xyBegin = locs(1,:); imSize = size(temp);
temp = insertShape(temp,"Line",[1 xyBegin(2) imSize(2) xyBegin(2)],"lineWidth",7);
% Insert markers at the end locations of the barcode.
temp = insertShape(temp, "FilledCircle", [locs, repmat(10, length(locs), 1)], "Color", "red", "Opacity", 1);
axes(handles.axes_image);
imshow(temp);
%% Search barcode with database
variableName=data.Properties.VariableNames;%take the VariableNames
length_varName=length(variableName);
temp_data=0;
for i=1:length_varName
    if strcmp(variableName(1,i),detectedFormat)==1
        temp_data=table2array(data(:,i));
    end
end
length_variable=length(temp_data);
count=0;
for i=1:length_variable
    if strcmp(temp_data(i,1),cellstr(msg))==1
        index=i;
        count=1;
    end
end
if count==0
    product_data={convertStringsToChars(msg); 'Khong co database'};
    product_label=[detectedFormat; 'Description'];
else
    product_info=data(index,:);
    product_data=(product_info{1:height(product_info),1:width(product_info)})';
    product_label=product_info.Properties.VariableNames;
end
set(handles.uitable_info,'Data',product_data,'RowName',product_label);
if count ~=0
    set(handles.text_name,'String',cellstr(product_data(4)))    %Column Excel
    set(handles.text_gia,'String',cellstr(product_data(6)))
    name_element=[name_element,product_data(4)];
    price_element=[price_element,product_data(6)];
    sum=[sum,product_data(6)];
    price=str2double(string(sum));
    sumprice=0;
    for i=1:size(price,2)
        sumprice=sumprice+price(i);
        i=i+1;
    end
    sumprice_1=double(sumprice);
    set(handles.text_sum,'String',num2str(sumprice_1))
else
    msgbox('Invalid Value', 'Error','error');
    set(handles.text_name,'String',cellstr(product_data(1)))
    set(handles.text_gia,'String','0')
end
set(handles.uitable_info,'Data',product_data,'RowName',product_label);
set(handles.pushbutton_bill,'visible','on');


% --- Executes on button press in pushbutton_exit.
function pushbutton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Would you like to quit?','Exit','Yes', 'No', 'Yes');
switch choice
    case 'Yes'
        delete(handles.figure1);
    case 'No'
end


% --- Executes on button press in radiobutton_camera.
function radiobutton_camera_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_camera
value = get(hObject,'value');
if value ==1
    set(handles.pushbutton_open,'visible','off');
    set(handles.pushbutton_inputvideo,'visible','on');
    set(handles.text6,'String','Video');
    set(handles.text8,'String','Image Result');
end


% --- Executes on button press in radiobutton_read.
function radiobutton_read_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_read (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_read
value = get(hObject,'value');
if value ==1
    set(handles.pushbutton_inputvideo,'visible','off');
    set(handles.pushbutton_open,'visible','on');
    set(handles.text6,'String','Image');
    set(handles.text8,'String','Image Result');
end


% --------------------------------------------------------------------
function uitable_info_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uitable_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_bill.
function pushbutton_bill_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
global data msg detectedFormat product_data product_label obj sum sumprice name_element price_element sumprice_1;

name_element=string(name_element');
price_element=string(price_element');
extract=["BILL","";"","";"Name","Price";name_element(:),price_element(:)];
extract_total=["","";"Total",num2str(sumprice_1)];
filter = {'*.xlsx'};
[file, path] = uiputfile(filter);
S = strcat(path,file);
writematrix(extract,S);
writematrix(extract_total,S,'WriteMode','append');
