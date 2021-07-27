

function varargout = NFC_OptoFluidics_NU(varargin)
% NFC_OptoFluidics_NU MATLAB code for NFC_OptoFluidics_NU.fig
%      NFC_OptoFluidics_NU, by itself, creates a new NFC_OptoFluidics_NU or raises the existing
%      singleton*.
%
%      H = NFC_OptoFluidics_NU returns the handle to a new NFC_OptoFluidics_NU or the handle to
%      the existing singleton*.
%
%      NFC_OptoFluidics_NU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NFC_OptoFluidics_NU.M with the given input arguments.
%
%      NFC_OptoFluidics_NU('Property','Value',...) creates a new NFC_OptoFluidics_NU or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NFC_OptoFluidics_NU_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NFC_OptoFluidics_NU_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NFC_OptoFluidics_NU

% Last Modified by GUIDE v2.5 13-Mar-2021 18:15:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @NFC_OptoFluidics_NU_OpeningFcn, ...
    'gui_OutputFcn',  @NFC_OptoFluidics_NU_OutputFcn, ...
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

% --- Executes just before NFC_OptoFluidics_NU is made visible.
function NFC_OptoFluidics_NU_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NFC_OptoFluidics_NU (see VARARGIN)

% Choose default command line output for NFC_OptoFluidics_NU
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% pos = get(gcf,'Position');
% pos(1:2) = [-700 300];
% set(gcf,'Position',pos);
% axes(handles.pulses_fig);
% plot_pulses(100,50,'00');

initialize_gui(hObject, handles, false);

% UIWAIT makes NFC_OptoFluidics_NU wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = NFC_OptoFluidics_NU_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)

SetScreen(handles);

% defile colors
handles.ONColor = [0.85 0.33 0.1];%color.reddevil;
handles.OFFColor = 240*[1 1 1]/255;
handles.ONColorLED = [0.07 0.62 1];
ports = seriallist;
[~,b] = size(ports);
set(handles.serial_port,'String',ports);
set(handles.serial_port,'Value',b);

% Set up serial port
handles.serial.s = serial(' ','BaudRate',38400);
handles.serial.s.InputBufferSize = 128;
handles.serial.s.Timeout = 5;
handles.serial.s.Parity = 'even';
handles.serial.s.StopBits = 1;
handles.serial.s.DataBits = 8;
handles.serial.s.port = ports{b};

% Initializes some flags
handles.flags.receiving = 0;
handles.flags.serial_active = 0;

set(handles.Ch1,'BackgroundColor',handles.OFFColor);
set(handles.Ch2,'BackgroundColor',handles.OFFColor);

set(handles.Ch1,      'Enable','Off');
set(handles.Ch2,      'Enable','Off');
set(handles.Ch3,      'Enable','Off');
set(handles.Ch4,      'Enable','Off');
set(handles.ch1,      'Enable','Off');
set(handles.ch2,      'Enable','Off');
set(handles.ch3,      'Enable','Off');
set(handles.ch4,      'Enable','Off');
set(handles.LED1,     'Enable','Off');
set(handles.dual_IN,  'Enable','Off');
set(handles.dual_OUT, 'Enable','Off');
set(handles.cmd_run,  'Enable','Off');

set(handles.UDID_devices,'Enable','Off');
set(handles.txt_devSelected, 'Enable','Off');
set(handles.opt_optofluidic,'Visible','Off');
setEnvironment(handles);

set(handles.opt_dualLED_IN,     'Enable','Off');
set(handles.opt_dualLED_OUT,    'Enable','Off');
set(handles.opt_dualPump,       'Enable','Off');
set(handles.cmd_read_UDID,  'Enable','Off');
set(handles.cmd_read,       'Enable','Off');
set(handles.cmd_write,      'Enable','Off');
set(handles.cmd_set_rfpower,'Enable','Off');
set(handles.cmd_RF_restart, 'Enable','Off');

set(handles.T,              'Enable','Off');
set(handles.DC,             'Enable','Off');
set(handles.rf_power,       'Enable','Off');

set(handles.rf_power,       'String',4);
set(handles.T,              'String','---');
set(handles.DC,             'String','---');

% Initializes NFC values
handles.NFC.mode = 0;           % Mode of operation
handles.NFC.ChON = 0;        
handles.NFC.RFON = 0;

handles.NFC.T = 500;        % Two bytes of data for the period
handles.NFC.DC = 50;
handles.NFC.addressedmode = 1;  % Addressed mode of operation
handles.NFC.UDID = '';          % Unique device identifier for addressed mode
handles.NFC.address = 0;
handles.NFC.data = [0 0 0 0];
handles.NFC.nAttempts = 5;      % Number of attempts to read or write
handles.NFC.P = 4;
handles.NFC.error = 0;          % If there is an error in the comm
guidata(handles.figure1, handles);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%                         Callback functions
function serial_connect_Callback(hObject, eventdata, handles)

disp(handles.serial.s.port)
if handles.flags.serial_active == 0
    if ~strcmp(handles.serial.s.port,' ') % Connect
        fclose(instrfind)
        fopen(handles.serial.s);
        handles.flags.serial_active = 1;
        fprintf('Port open.\n');
        
        % Read power on the Feig reader
        P0 = dec2hex(handles.NFC.P,2);
        msg = '02000DFF8A020101000301';
        msg0 = [];
        
        for j0=1:(length(msg)/2)
            msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
        end
        crc = CRC16(msg0);
        handles.NFC.message = [msg0 crc];
        handles.NFC.waittime = 0.5;
        dataReceived = send_commands(handles);
        
        if dataReceived == 0
            disp('Wrong port');
            fclose(handles.serial.s);
            fprintf('Port closed.\n');
            handles.flags.serial_active = 0;
            guidata(hObject,handles);
            return;
        end  
        
        set(handles.connected,      'Value',1);
        set(handles.cmd_read_UDID,  'Enable','On');
        set(handles.cmd_set_rfpower,'Enable','On');
        set(handles.serial_port,    'Enable','Off');
        set(handles.rf_power,       'Enable','On');
        set(handles.cmd_RF_restart, 'Enable','On');
        set(handles.serial_connect, 'String','Disconnect');
        set(handles.opt_optofluidic,'Enable','Off');
        
        
        P0 = dataReceived(13);
        handles.NFC.P = P0;
        set(handles.rf_power,'String',num2str(P0));
        
        % Make sure the RF is ON
        msg = '020008FF6A01A1AA'; % RF ON
        handles.NFC.RFON = 1;
        
        msg0 = [];
        for j0=1:(length(msg)/2)
            msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
        end
        crc = CRC16(msg0);
        handles.NFC.message = [msg0 crc];
        handles.NFC.waittime = 0.25;
        dataReceived = send_commands(handles);

    else
        disp('Select port first');
    end
else % Disconnect
    fclose(handles.serial.s)
    handles.flags.serial_active = 0;
    
    set(handles.connected,      'Value',0);
    set(handles.serial_port,    'Enable','On');
    set(handles.cmd_write,      'Enable','Off');
    set(handles.cmd_read,       'Enable','Off');
    set(handles.serial_connect, 'String','Connect');
    set(handles.cmd_read_UDID,  'Enable','Off');
    set(handles.Ch1,            'Enable','Off');
    set(handles.Ch2,            'Enable','Off');
    set(handles.Ch3,            'Enable','Off');
    set(handles.Ch4,            'Enable','Off');
    set(handles.LED1,           'Enable','Off');
    set(handles.ch1,            'Enable','Off');
    set(handles.ch2,            'Enable','Off');
    set(handles.ch3,            'Enable','Off');
    set(handles.ch4,            'Enable','Off');
    set(handles.dual_IN,        'Enable','Off');
    set(handles.dual_OUT,       'Enable','Off');
    set(handles.opt_dualLED_IN, 'Enable','Off');
    set(handles.opt_dualLED_OUT,'Enable','Off');
    set(handles.opt_dualPump,   'Enable','Off');
    set(handles.cmd_run,        'Enable','Off');
    set(handles.cmd_set_rfpower','Enable','Off');
    set(handles.cmd_RF_restart, 'Enable','Off');
    set(handles.T,              'Enable','Off');
    set(handles.DC,             'Enable','Off');
    set(handles.rf_power,       'Enable','Off');

    set(handles.Ch1,'BackgroundColor',handles.OFFColor);
    set(handles.Ch2,'BackgroundColor',handles.OFFColor);
    set(handles.Ch3,'BackgroundColor',handles.OFFColor);
    set(handles.Ch4,'BackgroundColor',handles.OFFColor);
    set(handles.LED1,'BackgroundColor',handles.OFFColor);
        
    set(handles.UDID_devices,'Enable','Off');
    set(handles.txt_devSelected, 'Enable','Off');
    set(handles.txt_devSelected,'String','Device selected: xx-xx-xx');
    set(handles.T,              'String','---');
    set(handles.DC,             'String','---');
    
    fprintf('Port closed.\n');
    
end
guidata(hObject,handles)

function cmd_write_Callback(hObject, eventdata, handles)

% Check which of the option buttons is active
% channel will tell the location in memory to store data

if get(handles.ch1,'Value') == 1
    channel = '01';
elseif get(handles.ch2,'Value') == 1
    channel = '03';
elseif get(handles.ch3,'Value') == 1
    channel = '05';
elseif get(handles.ch4,'Value') == 1
    channel = '07';
elseif get(handles.dual_IN,'Value') == 1
    channel = '09';
elseif get(handles.dual_OUT,'Value') == 1
    channel = '0B';
else
    channel = '01';
    set(handles.ch1,'Value',1);
end

str = [];
for j0 = 1:8
    str = [str dec2hex(handles.NFC.UDID(j0),2) '-'];    % UDID in string form
end
str = str(1:(end-1));
temp = strfind(str,'-');
str(temp) = '';
msg = ['020018FFB02401' str];
    
T0 = dec2hex(handles.NFC.T,4);
DC0 = dec2hex(round(handles.NFC.T*handles.NFC.DC/100),4);
msg = [msg channel '0104' T0 DC0];

msg0 = [];
for j0=1:(length(msg)/2)
    msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
end
crc = CRC16(msg0);
handles.NFC.message = [msg0 crc];
handles.NFC.waittime = 0.5;
dataReceived = send_commands(handles);
if dataReceived == 0
    disp('No data saved to device')
end
guidata(hObject, handles);

function cmd_read_Callback(hObject, eventdata, handles)
% Read memory  state with address according to which option button is
% selected
if get(handles.ch1,'Value') == 1
    channel = '01';
elseif get(handles.ch2,'Value') == 1
    channel = '03';
elseif get(handles.ch3,'Value') == 1
    channel = '05';
elseif get(handles.ch4,'Value') == 1
    channel = '07';
elseif get(handles.dual_IN,'Value') == 1
    channel = '09';
elseif get(handles.dual_OUT,'Value') == 1
    channel = '0B';
else
    channel = '01';
    set(handles.ch1,'Value',1);
end

str = [];
for j0 = 1:8
    str = [str dec2hex(handles.NFC.UDID(j0),2) '-'];    % UDID in string form
end
str = str(1:(end-1));
temp = strfind(str,'-');
str(temp) = '';
msg = ['020013FFB02301' str];

msg = [msg channel '01'];
msg0 = [];
for j0=1:(length(msg)/2)
    msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
end
crc = CRC16(msg0);
handles.NFC.message = [msg0 crc];
handles.NFC.waittime = 0.5;
dataReceived = send_commands(handles);

if dataReceived(1) ~= 0
    T = dataReceived(10)*256+dataReceived(11);
    DC = dataReceived(12)*256+dataReceived(13);
    DC = round(100*DC/T);
    
    handles.NFC.T = T;
    handles.NFC.DC = DC;
    set(handles.T,'String',num2str(T));
    set(handles.DC,'String',num2str(DC));
end

guidata(hObject, handles);

function cmd_read_UDID_Callback(hObject, eventdata, handles)
handles.NFC.waittime = 0.25;
[UDID,n] = get_inventory(handles);
if n==0
    disp('No devices found.');
else
handles.NFC.addressed = 1;
if n>1
    disp('Warning: more than two devices detected.');
end
    set(handles.UDID_devices,'String',UDID.str);
    handles.NFC.UDID = UDID.num{1};
    handles.NFC.UDID_n = n;                 % Number of devices
    handles.NFC.UDID_s = UDID.num;          % UDIDs in dec format
    handles.NFC.UDID_str = UDID.str;        % UDIDs in str format
    set(handles.cmd_write,      'Enable','On');
    set(handles.cmd_read,       'Enable','On');
    set(handles.Ch1,            'Enable','On');
    set(handles.Ch2,            'Enable','On');
    set(handles.Ch3,            'Enable','On');
    set(handles.Ch4,            'Enable','On');
    set(handles.LED1,           'Enable','On');
    set(handles.ch1,            'Enable','On');
    set(handles.ch2,            'Enable','On');
    set(handles.ch3,            'Enable','On');
    set(handles.ch4,            'Enable','On');
    set(handles.dual_IN,        'Enable','On');
    set(handles.dual_OUT,       'Enable','On');
    set(handles.T,              'Enable','On');
    set(handles.DC,             'Enable','On');
    set(handles.opt_dualLED_IN, 'Enable','On');
    set(handles.opt_dualLED_OUT,'Enable','On');
    set(handles.opt_dualPump,   'Enable','On');
    set(handles.cmd_run,        'Enable','On');
    set(handles.UDID_devices,   'Enable','On');
    set(handles.txt_devSelected,'String',['Device selected: ... ' UDID.str{1}(10:end)]);
    set(handles.UDID_devices,   'Enable','On');
    set(handles.txt_devSelected,'Enable','On');
    
    %Read current status
    str = [];
    for j0 = 1:8
        str = [str dec2hex(handles.NFC.UDID(j0),2) '-'];    % UDID in string form
    end
    str = str(1:(end-1));
    temp = strfind(str,'-');
    str(temp) = '';
    msg = ['020013FFB02301' str];

    msg = [msg '0001'];
    msg0 = [];
    for j0=1:(length(msg)/2)
        msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
    end
    crc = CRC16(msg0);
    handles.NFC.message = [msg0 crc];
    handles.NFC.waittime = 0.5;
    dataReceived = send_commands(handles);

    if dataReceived(1) ~= 0
        Mode = dataReceived(13);
        Channel = dataReceived(12);
        Indicator = dataReceived(11);
        
        set(handles.Ch1,'BackgroundColor',handles.OFFColor);
        set(handles.Ch2,'BackgroundColor',handles.OFFColor);
        set(handles.Ch3,'BackgroundColor',handles.OFFColor);
        set(handles.Ch4,'BackgroundColor',handles.OFFColor);
        set(handles.LED1,'BackgroundColor',handles.OFFColor);
        
        switch Channel
            case 1
                set(handles.Ch1,'BackgroundColor',handles.ONColor);
            case 2
                set(handles.Ch2,'BackgroundColor',handles.ONColor);
            case 4
                set(handles.Ch3,'BackgroundColor',handles.ONColor);
            case 8
                set(handles.Ch4,'BackgroundColor',handles.ONColor);
            case 16
                set(handles.LED1,'BackgroundColor',handles.ONColorLED);
        end
                
       
    end
end

guidata(hObject, handles);

function ch1_Callback(hObject, eventdata, handles)
set(handles.ch2,'Value',0);
set(handles.ch3,'Value',0);
set(handles.ch4,'Value',0);
set(handles.dual_IN,'Value',0);
set(handles.dual_OUT,'Value',0);
guidata(hObject, handles);

function ch2_Callback(hObject, eventdata, handles)
set(handles.ch1,'Value',0);
set(handles.ch3,'Value',0);
set(handles.ch4,'Value',0);
set(handles.dual_IN,'Value',0);
set(handles.dual_OUT,'Value',0);
guidata(hObject, handles);

function ch3_Callback(hObject, eventdata, handles)
set(handles.ch1,'Value',0);
set(handles.ch2,'Value',0);
set(handles.ch4,'Value',0);
set(handles.dual_IN,'Value',0);
set(handles.dual_OUT,'Value',0);
guidata(hObject, handles);

function ch4_Callback(hObject, eventdata, handles)
set(handles.ch1,'Value',0);
set(handles.ch2,'Value',0);
set(handles.ch3,'Value',0);
set(handles.dual_IN,'Value',0);
set(handles.dual_OUT,'Value',0);
guidata(hObject, handles);

function dual_IN_Callback(hObject, eventdata, handles)
set(handles.ch1,'Value',0);
set(handles.ch2,'Value',0);
set(handles.ch3,'Value',0);
set(handles.ch4,'Value',0);
set(handles.dual_OUT,'Value',0);
guidata(hObject, handles);

function dual_OUT_Callback(hObject, eventdata, handles)
set(handles.ch1,'Value',0);
set(handles.ch2,'Value',0);
set(handles.ch3,'Value',0);
set(handles.ch4,'Value',0);
set(handles.dual_IN,'Value',0);
guidata(hObject, handles);

function Ch1_Callback(hObject, eventdata, handles)
% Ch1 corresponds to Pump1
if handles.NFC.ChON == 0
    ONOFF = '01';
else
    ONOFF = '00';
end

str = [];
for j0 = 1:8
    str = [str dec2hex(handles.NFC.UDID(j0),2) '-'];    % UDID in string form
end
str = str(1:(end-1));
temp = strfind(str,'-');
str(temp) = '';
msg = ['020018FFB02401' str];
msg = [msg '000104' '0001' ONOFF '00'];

msg0 = [];
for j0=1:(length(msg)/2)
    msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
end
crc = CRC16(msg0);
handles.NFC.message = [msg0 crc];
handles.NFC.waittime = 0.15;
dataReceived = send_commands(handles);

if dataReceived(1) ~= 0 
    if handles.NFC.ChON == 0
        handles.NFC.ChON = 1;
        set(handles.Ch1,'BackgroundColor',handles.ONColor);
    else
        handles.NFC.ChON = 0;
        set(handles.Ch1,'BackgroundColor',handles.OFFColor);
    end
end
guidata(hObject, handles);

function Ch2_Callback(hObject, eventdata, handles)
% Ch2 corresponds to Pump2
if handles.NFC.ChON == 0
    ONOFF = '02';
else
    ONOFF = '00';
end

str = [];
for j0 = 1:8
    str = [str dec2hex(handles.NFC.UDID(j0),2) '-'];    % UDID in string form
end
str = str(1:(end-1));
temp = strfind(str,'-');
str(temp) = '';
msg = ['020018FFB02401' str];
msg = [msg '000104' '0001' ONOFF '00'];

msg0 = [];
for j0=1:(length(msg)/2)
    msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
end
crc = CRC16(msg0);
handles.NFC.message = [msg0 crc];
handles.NFC.waittime = 0.15;
dataReceived = send_commands(handles);

if dataReceived(1) ~= 0 
    if handles.NFC.ChON == 0
        handles.NFC.ChON = 1;
        set(handles.Ch2,'BackgroundColor',handles.ONColor);
    else
        handles.NFC.ChON = 0;
        set(handles.Ch2,'BackgroundColor',handles.OFFColor);
    end
end
guidata(hObject, handles);

function Ch3_Callback(hObject, eventdata, handles)
% Ch3 corresponds to Pump3
if handles.NFC.ChON == 0
    ONOFF = '04';
else
    ONOFF = '00';
end

str = [];
for j0 = 1:8
    str = [str dec2hex(handles.NFC.UDID(j0),2) '-'];    % UDID in string form
end
str = str(1:(end-1));
temp = strfind(str,'-');
str(temp) = '';
msg = ['020018FFB02401' str];
msg = [msg '000104' '0001' ONOFF '00'];

msg0 = [];
for j0=1:(length(msg)/2)
    msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
end
crc = CRC16(msg0);
handles.NFC.message = [msg0 crc];
handles.NFC.waittime = 0.15;
dataReceived = send_commands(handles);

if dataReceived(1) ~= 0 
    if handles.NFC.ChON == 0
        handles.NFC.ChON = 1;
        set(handles.Ch3,'BackgroundColor',handles.ONColor);
    else
        handles.NFC.ChON = 0;
        set(handles.Ch3,'BackgroundColor',handles.OFFColor);
    end
end
guidata(hObject, handles);

function Ch4_Callback(hObject, eventdata, handles)
% Ch4 corresponds to Pump4
if handles.NFC.ChON == 0
    ONOFF = '08';
else
    ONOFF = '00';
end

str = [];
for j0 = 1:8
    str = [str dec2hex(handles.NFC.UDID(j0),2) '-'];    % UDID in string form
end
str = str(1:(end-1));
temp = strfind(str,'-');
str(temp) = '';
msg = ['020018FFB02401' str];
msg = [msg '000104' '0001' ONOFF '00'];

msg0 = [];
for j0=1:(length(msg)/2)
    msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
end
crc = CRC16(msg0);
handles.NFC.message = [msg0 crc];
handles.NFC.waittime = 0.15;
dataReceived = send_commands(handles);

if dataReceived(1) ~= 0 
    if handles.NFC.ChON == 0
        handles.NFC.ChON = 1;
        set(handles.Ch4,'BackgroundColor',handles.ONColor);
    else
        handles.NFC.ChON = 0;
        set(handles.Ch4,'BackgroundColor',handles.OFFColor);
    end
end
guidata(hObject, handles);

function LED1_Callback(hObject, eventdata, handles)
% Ch5 corresponds to LED1
if handles.NFC.ChON == 0
    ONOFF = '10';
else
    ONOFF = '00';
end

str = [];
for j0 = 1:8
    str = [str dec2hex(handles.NFC.UDID(j0),2) '-'];    % UDID in string form
end
str = str(1:(end-1));
temp = strfind(str,'-');
str(temp) = '';
msg = ['020018FFB02401' str];
msg = [msg '000104' '0001' ONOFF '00'];

msg0 = [];
for j0=1:(length(msg)/2)
    msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
end
crc = CRC16(msg0);
handles.NFC.message = [msg0 crc];
handles.NFC.waittime = 0.25;
dataReceived = send_commands(handles);

if dataReceived(1) ~= 0 
    if handles.NFC.ChON == 0
        handles.NFC.ChON = 1;
        set(handles.LED1,'BackgroundColor',handles.ONColorLED);
    else
        handles.NFC.ChON = 0;
        set(handles.LED1,'BackgroundColor',handles.OFFColor);
    end
end
guidata(hObject, handles);

function T_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
handles.NFC.T = temp;
guidata(hObject, handles);

function DC_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if temp > 100
    beep;
    set(hObject,'String',100);
    handles.NFC.DC = 100;
else
    handles.NFC.DC = temp;
end

guidata(hObject, handles);

function serial_port_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.serial.s.port = contents{get(hObject,'Value')};
guidata(hObject, handles);

function UDID_devices_Callback(hObject, eventdata, handles)
temp = get(hObject,'Value');
handles.NFC.UDID = handles.NFC.UDID_s{temp};
set(handles.txt_devSelected,'String',['Device selected: ... ' handles.NFC.UDID_str{temp}(10:end)]);
set(hObject,'Value',1);
guidata(hObject, handles);

function rf_power_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if temp < 2 || temp > 12
    disp('   Input integer values from 2 to 12 only.');
    set(hObject,'String',num2str(handles.NFC.P));
elseif temp-floor(temp) > 0
    disp('   Input integer values from 2 to 12 only.');
    set(hObject,'String',num2str(handles.NFC.P));
else
    handles.NFC.P = temp;
end
guidata(hObject, handles);

function cmd_RF_restart_Callback(hObject, eventdata, handles)
if handles.NFC.RFON == 1
    msg = '020008FF6A0028BB'; % RF OFF
    handles.NFC.RFON = 0;
    set(handles.cmd_RF_restart,'String','RF ON');
else
    msg = '020008FF6A01A1AA'; % RF ON
    handles.NFC.RFON = 1;
    set(handles.cmd_RF_restart,'String','RF OFF');
end

msg0 = [];
for j0=1:(length(msg)/2)
    msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
end
handles.NFC.message = msg0;
handles.NFC.waittime = 0.25;
dataReceived = send_commands(handles);
guidata(hObject, handles);

function cmd_set_rfpower_Callback(hObject, eventdata, handles)
P0 = dec2hex(handles.NFC.P,2);
msg = ['02002CFF8B020101011E00030008' P0 '800000000000000000000000000000000000000000000000000000'];
msg0 = [];
for j0=1:(length(msg)/2)
    msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
end
crc = CRC16(msg0);
handles.NFC.message = [msg0 crc];
handles.NFC.waittime = 0.25;
dataReceived = send_commands(handles);

if dataReceived(6) == 0
    disp('Data received.');
    msg = '020007FF63';
    msg0 = [];
    for j0=1:(length(msg)/2)
        msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
    end
    crc = CRC16(msg0);
    handles.NFC.message = [msg0 crc];
    handles.NFC.waittime = 0.5;
    dataReceived = send_commands(handles);
else
end

function opt_optofluidic_Callback(hObject, ~, handles)

function setEnvironment(handles)
set(handles.opt_optofluidic,'String',' Opt1  | [Opt2]');
set(handles.LED1,'Visible','Off');
set(handles.cmd_run,'Visible','On');

set(handles.Ch1,'String','LED 1');
set(handles.Ch2,'String','Pump 1');
set(handles.Ch3,'String','Pump 2');
set(handles.Ch4,'String','LED 2');

function opt_dualPump_Callback(hObject, eventdata, handles)
set(handles.opt_dualLED_IN,'Value',0);
set(handles.opt_dualLED_OUT,'Value',0);
set(handles.opt_dualPump,'Enable','Inactive');
set(handles.opt_dualLED_IN,'Enable','On');
set(handles.opt_dualLED_OUT,'Enable','On');
guidata(hObject, handles);

function opt_dualLED_IN_Callback(hObject, eventdata, handles)
set(handles.opt_dualPump,'Value',0);
set(handles.opt_dualLED_OUT,'Value',0);
set(handles.opt_dualLED_IN,'Enable','Inactive');
set(handles.opt_dualPump,'Enable','On');
set(handles.opt_dualLED_OUT,'Enable','On');
guidata(hObject, handles);

function opt_dualLED_OUT_Callback(hObject, eventdata, handles)
set(handles.opt_dualPump,'Value',0);
set(handles.opt_dualLED_IN,'Value',0);
set(handles.opt_dualLED_OUT,'Enable','Inactive');
set(handles.opt_dualPump,'Enable','On');
set(handles.opt_dualLED_IN,'Enable','On');
guidata(hObject, handles);

function cmd_run_Callback(hObject, eventdata, handles)
IND = '01';
% Run Ch1-Ch4 in phase
MODE = '0000';

if get(handles.opt_dualLED_IN,'Value') == 1
    if handles.NFC.ChON == 0
        ONOFF = '01';
        MODE = '0911';
    else
        ONOFF = '00';
        MODE = '0000';
    end
end

if get(handles.opt_dualLED_OUT,'Value') == 1
    if handles.NFC.ChON == 0
        ONOFF = '01';
        MODE = '0901'
    else
        ONOFF = '00';
        MODE = '0000'
    end
end

if get(handles.opt_dualPump,'Value') == 1
    if handles.NFC.ChON == 0
        ONOFF = '01';
        MODE = '0601'
    else
        ONOFF = '00';
        MODE = '0000'
    end
end

str = [];
for j0 = 1:8
    str = [str dec2hex(handles.NFC.UDID(j0),2) '-'];    % UDID in string form
end
str = str(1:(end-1));
temp = strfind(str,'-');
str(temp) = '';
msg = ['020018FFB02401' str];
msg = [msg '00010400' IND MODE];

msg0 = [];
for j0=1:(length(msg)/2)
    msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
end
crc = CRC16(msg0);
handles.NFC.message = [msg0 crc];
handles.NFC.waittime = 0.5;
dataReceived = send_commands(handles);

if dataReceived(1) ~= 0 
    if handles.NFC.ChON == 0
        handles.NFC.ChON = 1;
        set(handles.cmd_run,'BackgroundColor',handles.ONColor);
    else
        handles.NFC.ChON = 0;
        set(handles.cmd_run,'BackgroundColor',handles.OFFColor);
    end
end

guidata(hObject, handles);


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%                            My funtions
function data = send_commandsxx(handles)
if handles.NFC.waittime == 0
    handles.NFC.waittime = 0.25;
end
flushinput(handles.serial.s);            % Cleans input buffer
fprintf('   |Sent>>  ');

for ia = 1:length(handles.NFC.message)
    fprintf('%s ',dec2hex(handles.NFC.message(ia),2));
end
fprintf('\n');

if handles.flags.serial_active == 1
    for nAttempts = 1:handles.NFC.nAttempts
        fwrite(handles.serial.s,handles.NFC.message);
        handles.flags.receiving = 1;
        pause(handles.NFC.waittime);
        nData = handles.serial.s.BytesAvailable;
        if nData > 0
            data = fread(handles.serial.s,nData)';
            fprintf('<<Received| ');
            for j0 = 1:(length(data))
                fprintf('%s ',dec2hex(data(j0),2));
            end
            switch dec2hex(data(6),2)
                case '00'
%                     handles.NFC.error = 0;
                    fprintf('\n');
                    return
                case '01'
%                     handles.NFC.error = 1;
                    data = 0;
                    fprintf('\nReader: No transponder in the Reader Field');
                    fprintf('| No response, attempt %d of %d',nAttempts, handles.NFC.nAttempts);
                case '84'
                    if data(7) == 0
%                         handles.NFC.error = 1;
                        data = 0;
                        fprintf('\nReader: RF-Warning\n');
                        return
                    end
            end
            fprintf('\n');
        end
%         fprintf('\n');
    end
end

function data = send_commands(handles)
if handles.NFC.waittime == 0
    handles.NFC.waittime = 0.25;
end
flushinput(handles.serial.s);            % Cleans input buffer
fprintf('   |Sent>>  ');

for ia = 1:length(handles.NFC.message)
    fprintf('%s ',dec2hex(handles.NFC.message(ia),2));
end
fprintf('\n');

if handles.flags.serial_active == 1
    for nAttempts = 1:handles.NFC.nAttempts
        
        fwrite(handles.serial.s,handles.NFC.message);
        handles.flags.receiving = 1;
        pause(handles.NFC.waittime);
        nData = handles.serial.s.BytesAvailable;
        
        if nData > 0
            data = fread(handles.serial.s,nData)';
            nLength = data(2)*256+data(3);
            fprintf('<<Received| ');
            
            for j0 = 1:(length(data))
                fprintf('%s ',dec2hex(data(j0),2));
                if mod(j0,30) == 0
                    fprintf('\n            ');
                end
            end
            
            if length(data) >= nLength
                fprintf('| data OK.');
                
                switch dec2hex(data(6),2)
                    case '00'
                        %                     handles.NFC.error = 0;
                        fprintf('\n');
                        return
                    case '01'
                        %                     handles.NFC.error = 1;
                        data = 0;
                        fprintf('\nReader: No transponder in the Reader Field');
                        fprintf('| No response, attempt %d of %d',nAttempts, handles.NFC.nAttempts);
                    case '84'
                        if data(7) == 0
                            %                         handles.NFC.error = 1;
                            data = 0;
                            fprintf('\nReader: RF-Warning\n');
                            return
                        end
                end
                fprintf('\n');
            else
                fprintf('| data loss.');
            end
            
        end
        if nData == 0
            data = 0;
        end
        
    end
end

function data = CRC16(msg)
crc_poly = uint16(hex2dec('8408'));
crc = uint16(hex2dec('FFFF'));
for i=1:length(msg)
    crc = bitxor(crc,msg(i));
    for j=1:8
        if bitand(crc,1)
            crc = bitxor(bitshift(crc,-1),crc_poly);
        else
            crc = bitshift(crc,-1);
        end
    end
end
data = dec2hex(crc,4);
data = [hex2dec(data(3:4)) hex2dec(data(1:2))];

function [UDID,n] = get_inventory(handles)
msg = '020009FFB00100';
msg0 = [];
for j0=1:(length(msg)/2)
    msg0(j0) = hex2dec(msg((j0-1)*2+[1 2]));
end
crc = CRC16(msg0);
handles.NFC.message = [msg0 crc];
data = send_commands(handles);
if data(1) == 0
    n = 0;
    UDID = [];
    str0 = [];
    return;
end

if data(6) == 0   
    n = data(7);                                % Number of devices found
    UDID = [];
    str0 = [];
    for i0 = 1:n

        UDID.num{i0} = data(i0*10-1+(1:8));     % Get the UDID value, dec
        str = [];
        for j0 = 1:8
            str = [str dec2hex(UDID.num{i0}(j0),2) '-'];    % UDID in string form
        end
        UDID.str{i0} = str(1:(end-1));

    end
else
    n = 0;
    UDID = [];
    str0 = [];
end

function txt_messages_Callback(hObject, eventdata, handles)

function SetScreen(handles)
% Screen 600x500 pixels
set(handles.text26,'Units','pixels');
set(handles.text26,'Position',[40 510 400 30]);

set(handles.opt_optofluidic,'Units','pixels');
set(handles.opt_optofluidic,'Position',[450 510 300 30]);

set(handles.connected,'Units','pixels');
set(handles.connected,'Position',[40 465 200 30]);

set(handles.serial_port,'Units','pixels');
set(handles.serial_port,'Position',[70 460 200 30]);

set(handles.serial_connect,'Units','pixels');
set(handles.serial_connect,'Position',[300 450 120 50]);

set(handles.cmd_read_UDID,'Units','pixels');
set(handles.cmd_read_UDID,'Position',[440 450 120 50]);

set(handles.txt_devSelected,'Units','pixels');
set(handles.txt_devSelected,'Position',[300 408 300 30]);

set(handles.UDID_devices,'Units','pixels');
set(handles.UDID_devices,'Position',[70 410 200 30]);

% set(handles.Ch1,'Position',[40 315 250 75]);
% set(handles.Ch2,'Position',[310 315 250 75]);
% set(handles.Ch3,'Position',[310 230 250 75]);
% set(handles.Ch4,'Position',[40 230 250 75]);

set(handles.Ch1,'Units','pixels');
set(handles.Ch1,'Position',[40 315 250 75]);

set(handles.Ch2,'Units','pixels');
set(handles.Ch2,'Position',[310 315 250 75]);

set(handles.Ch3,'Units','pixels');
set(handles.Ch3,'Position',[310 230 250 75]);

set(handles.Ch4,'Units','pixels');
set(handles.Ch4,'Position',[40 230 250 75]);

set(handles.ch1,'Units','pixels');
set(handles.ch1,'Position',[40 170 100 30]);

set(handles.ch4,'Units','pixels');
set(handles.ch4,'Position',[40 140 100 30]);

set(handles.ch2,'Units','pixels');
set(handles.ch2,'Position',[40 110 100 30]);

set(handles.ch3,'Units','pixels');
set(handles.ch3,'Position',[40 80 100 30]);

set(handles.dual_IN,'Units','pixels');
set(handles.dual_IN,'Position',[40 50 120 30]);

set(handles.dual_OUT,'Units','pixels');
set(handles.dual_OUT,'Position',[40 20 120 30]);

set(handles.T,'Units','pixels');
set(handles.T,'Position',[190 170 50 25]);

set(handles.DC,'Units','pixels');
set(handles.DC,'Position',[190 130 50 25]);

set(handles.text8,'Units','pixels');
set(handles.text8,'Position',[250 170 50 22]);

set(handles.text9,'Units','pixels');
set(handles.text9,'Position',[250 130 50 22]);

set(handles.cmd_read,'Units','pixels');
set(handles.cmd_read,'Position',[185 70 100 40]);

set(handles.cmd_write,'Units','pixels');
set(handles.cmd_write,'Position',[185 20 100 40]);

set(handles.rf_power,'Units','pixels');
set(handles.rf_power,'Position',[320 160-85 50 30]);

set(handles.txt2,'Units','pixels');
set(handles.txt2,'Position',[380 155-85 105 30]);

set(handles.cmd_set_rfpower,'Units','pixels');
set(handles.cmd_set_rfpower,'Position',[485 156-85 72 40]);

set(handles.cmd_RF_restart,'Units','pixels');
set(handles.cmd_RF_restart,'Position',[318 20 238 40]);

set(handles.LED1,'Units','pixels');
set(handles.LED1,'Position',[310 145 250 75]);

set(handles.cmd_run,'Units','pixels');
set(handles.cmd_run,'Position',[440 125 120 80]);
set(handles.cmd_run,'Visible','Off');

set(handles.opt_dualLED_IN,'Units','pixels');
set(handles.opt_dualLED_IN,'Position',[310 180 130 30]);

set(handles.opt_dualLED_OUT,'Units','pixels');
set(handles.opt_dualLED_OUT,'Position',[310 150 130 30]);

set(handles.opt_dualPump,'Units','pixels');
set(handles.opt_dualPump,'Position',[310 120 130 30]);


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%                     Functions used by the app
function DC_CreateFcn(hObject, eventdata, handles)
function T_CreateFcn(hObject, eventdata, handles)
function rf_power_CreateFcn(hObject, eventdata, handles)
function serial_port_CreateFcn(hObject, eventdata, handles)
function UDID_devices_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
