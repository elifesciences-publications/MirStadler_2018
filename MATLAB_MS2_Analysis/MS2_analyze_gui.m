function MS2_analyze_gui
    close all
    
    
    % for the dataset see the examples to see how it should be structured
   
   % call initial dialog to get the detaila of the current dataset
    cdetails=[];
    MS2_list=[];
    initial_dialog
    
    f = figure('Visible','on','Position',[100,100,1600,800]);%,'KeyPressFcn', @keyPress);
   
    cmip=loadtiff(cdetails.mipApath); % path for mips
    cfilesA=dir(strcat(cdetails.dat_path,'*CamA*.tif')); %names of all CamA files (lattice format)
    
    cframe=1; %initialize cframe
    mindisp=120;
    maxdisp=800;
    nframes=cdetails.nFrames;
    cstackA=[];
    cslice=25;
    nslices=cdetails.nSlices;
    mindispz=120; 
    maxdispz=250;
    mindispval=1; maxdispval=2000; % min and max values for display sliders
    fps=25; % FPS for playback
    MS2on=0; %initialize value for displaying MS2on or not
    Ignored=0; %initialize value for displaying whether it is ignored or not
    NC=0;
    cMS2_list=[];    
    traj_list{1,1}=0;
    traj_selected =0;
    %% construct the components
    
    %% for mip images
    
    % create the current frame static text box string
    uicontrol('Style','text','String','Current Frame','Position',[10,10,100, 20]);
    % create the current frame editable text box
    hcframetxt= uicontrol('Style','edit','String',num2str(cframe),'Position',[120,15,100, 20]);
    % create the go to frame push button
    hgoto= uicontrol('Style','pushbutton','String','Goto','Position',[220,15,100, 20],...
       'Callback', {@goto_Callback});   
    % create the scroll bar for sliding through images
    hframe = uicontrol('Style', 'slider','String', 'Frame', 'Position', [20,50,512,20],...
       'Callback', {@frame_slider_Callback});
     set(hframe,'Value',1,'min',1,'max',nframes,'SliderStep',[1,5]/(nframes-1));
    addlistener(hframe, 'Value', 'PreSet',@frame_slider_drag_Callback); % for updating while dragging
    
     % create the toggle button for pausing and playing
   hplaypause= uicontrol('Style','togglebutton','String','Play','Position', [540,46,35,30],...
       'Callback', {@playpause_Callback});
   % FPS controls 
    uicontrol('Style','text','String','FPS','Position',[520,22,25,20]);
    hfps= uicontrol('Style','edit','String',num2str(fps),'Position',[548,24,35,20]);
       
    
    % create the axis for maxprojection plots
    hmip = axes('Units','pixels','Position',[50,100,512,512]);
    
    % create the min and max display val controls for mip image
    uicontrol('Style','text','String','Min','Position',[50,648,50,20]);
    uicontrol('Style','text','String','Max','Position',[50,618,50,20]);
    hminval= uicontrol('Style','edit','String',num2str(mindisp),'Position',[90,650,50,20]);
    hmaxval= uicontrol('Style','edit','String',num2str(maxdisp),'Position',[90,620,50,20]);
    hsetdisp= uicontrol('Style','pushbutton','String','Set','Position',[505,622,50,50],...
       'Callback', {@setdisp_Callback});  
   mindispmipslider = uicontrol('Style', 'slider','String', 'Frame', 'Position', [135,650,370,20],...
       'Callback', {@mindispmipslider_Callback});
   set(mindispmipslider,'Value',mindisp,'min',mindispval,'max',maxdispval,'SliderStep',[1,5]/(maxdispval-1));
   addlistener(mindispmipslider, 'Value', 'PreSet',@mindispmipslider_drag_Callback); % for updating while dragging
   maxdispmipslider = uicontrol('Style', 'slider','String', 'Frame', 'Position', [135,620,370,20],...
       'Callback', {@maxdispmipslider_Callback});
   set(maxdispmipslider,'Value',maxdisp,'min',mindispval,'max',maxdispval,'SliderStep',[1,5]/(maxdispval-1));
   addlistener(maxdispmipslider, 'Value', 'PreSet',@maxdispmipslider_drag_Callback); % for updating while dragging
      %% create the axes for displaying ztacks
   % create the push button to load in the zstack for the current frame
    hloadz= uicontrol('Style','pushbutton','String','Load Z-stack','Position',[320,15,100, 20],...
       'Callback', {@loadz_Callback});  
     
   

    hztack = axes('Units','pixels','Position',[612,100,512,512]);
    hzslice = uicontrol('Style', 'slider','String', 'Frame', 'Position', [1130,100,20,512],...
       'Callback', {@slice_slider_Callback});
     set(hzslice,'Value',cslice,'min',1,'max',nslices,'SliderStep',[1,5]/(nslices-1));
    addlistener(hzslice, 'Value', 'PreSet',@slice_slider_drag_Callback); % for updating while dragging
    czstack_frame=uicontrol('Style','text','String',['Stack at Frame: ',num2str(cframe)],'Position',[602,50,512,20],'FontWeight','bold');
    uicontrol('Style','text','String','Current Slice','Position',[602,10,100, 20],'FontWeight','bold');
    hcslicetxt= uicontrol('Style','edit','String',num2str(cslice),'Position',[702,15,100, 20],'FontWeight','bold');
    
     % create the min and max display controls for zstack
    uicontrol('Style','text','String','Min','Position',[605,648,50,20]);
    uicontrol('Style','text','String','Max','Position',[605,618,50,20]);
    hminvalz= uicontrol('Style','edit','String',num2str(mindispz),'Position',[645,650,50,20]);
    hmaxvalz= uicontrol('Style','edit','String',num2str(maxdispz),'Position',[645,620,50,20]);
    hsetdispz= uicontrol('Style','pushbutton','String','Set','Position',[1060,622,50,50],...
       'Callback', {@setdispz_Callback}); 
    mindispzslider = uicontrol('Style', 'slider','String', 'Frame', 'Position', [690,650,370,20],...
       'Callback', {@mindispzslider_Callback});
   set(mindispzslider,'Value',mindispz,'min',mindispval,'max',maxdispval,'SliderStep',[1,5]/(maxdispval-1));
   addlistener(mindispzslider, 'Value', 'PreSet',@mindispzslider_drag_Callback); % for updating while dragging
    maxdispzslider = uicontrol('Style', 'slider','String', 'Frame', 'Position', [690,620,370,20],...
       'Callback', {@maxdispzslider_Callback});
   set(maxdispzslider,'Value',maxdispz,'min',mindispval,'max',maxdispval,'SliderStep',[1,5]/(maxdispval-1));
   addlistener(maxdispzslider, 'Value', 'PreSet',@maxdispzslider_drag_Callback); % for updating while dragging 
   
   
   %% create analysis components
     
  
   hloaddetails= uicontrol('Style','pushbutton','String','Load Details','Position',[1220,630,72,30],'FontWeight','bold','Callback', {@loaddetails_Callback});
   hsavedetails= uicontrol('Style','pushbutton','String','Save Details','Position',[1300,630,72,30],'FontWeight','bold','Callback', {@savedetails_Callback});


   hMS2ONtb = uicontrol('Style','togglebutton','String','MS2','Value',MS2on,'Position',[1160,580,50,30],...
          'BackgroundColor','red','Callback', {@MS2ONtb_Callback});
      
   hIgnoredtb = uicontrol('Style','togglebutton','String','Ignored','Value',Ignored,'Position',[1210,580,70,30],...
          'BackgroundColor','red','Callback', {@Ignoredtb_Callback});
      
   uicontrol('Style','text','String','Nuclear Cycle','Position',[1290,595,70,30]);
   hNCtxt= uicontrol('Style','edit','String',NC,'Position',[1290,580,70,30]);   
   hupdateNC= uicontrol('Style','pushbutton','String','Update NC','Position',[1360,580,70,30],'Callback', {@updateNC_Callback});    
    
   
   hDispTraj= uicontrol('Style','togglebutton','String','Display Trajs','Position',[1265,500,100,30],'BackgroundColor','red',...
   'Callback', {@dispTraj_Callback}); 
   
   hdeleteTraj =uicontrol('Style','pushbutton','String','Delete Trajs','Position',[1265,460,100,30],...
       'Callback', {@delTraj_Callback}); 
   
   hrenumTraj =uicontrol('Style','pushbutton','String','Renumber Trajs','Position',[1265,420,100,30],...
       'Callback', {@renumTraj_Callback});
   
   hconnTraj =uicontrol('Style','pushbutton','String','Connect Trajs','Position',[1265,380,100,30],...
       'Callback', {@connTraj_Callback}); 


   hdispdetect= uicontrol('Style','togglebutton','String','Display Detections','Position',[1365,500,100,30],'BackgroundColor','red',...
   'Callback', {@dispdetect_Callback}); 
   

   haddParticle =uicontrol('Style','pushbutton','String','Add Particle','Value',0,'Position',[1365,460,100,30],...
       'Callback', {@addParticle_Callback}); 
   
   hDeleteParticle =uicontrol('Style','pushbutton','String','Delete Particle','Value',0,'Position',[1365,420,100,30],...
       'Callback', {@delParticle_Callback}); 

   hTrajList =uicontrol('Style','Listbox','max',100,'min',1,'String',traj_list,'Position',[1162,320,100,200],...
    'Callback',@traj_list_Callback);
      
 
   
   hsaveTrajList =uicontrol('Style','pushbutton','String','Save Trajs','Position',[1265,325,100,30],'FontWeight','bold',...
       'Callback', {@saveTraj_Callback});
   
   hloadTrajList =uicontrol('Style','pushbutton','String','Load Trajs','Position',[1365,325,100,30],'FontWeight','bold',...
       'Callback', {@loadTraj_Callback}); 
   
   
   hresetdetsettings =uicontrol('Style','pushbutton','String','Reset Settings','Position',[1462,280,100,30],...
       'Callback', {@resetdetsettings_Callback});
   
   htestdetect =uicontrol('Style','pushbutton','String','Test Detect','Position',[1462,250,100,30],...
       'Callback', {@testdetect_Callback}); 
   
   hdetectcurrent =uicontrol('Style','pushbutton','String','AutoDetect Current','Position',[1462,220,100,30],...
       'Callback', {@detectcurrent_Callback}); 
   
   hdetectall =uicontrol('Style','pushbutton','String','Detect All','Position',[1462,190,100,30],...
       'Callback', {@detectall_Callback},'FontWeight','bold');
   
  
   % detection settigns components
   uicontrol('Style','text','String','Detection Settings','Position',[1300,280,110,30],'FontWeight','bold');
   uicontrol('Style','text','String','Gauss1 xy z','Position',[1158,259,40,30]);
   hdog1xy= uicontrol('Style','edit','String',5,'Position',[1205,262,30,30]);
   hdog1z= uicontrol('Style','edit','String',5,'Position',[1237,262,30,30]);
   uicontrol('Style','text','String','Gauss2 xy z','Position',[1272,259,40,30]);
   hdog2xy= uicontrol('Style','edit','String',0.75,'Position',[1319,262,30,30]);
   hdog2z= uicontrol('Style','edit','String',1,'Position',[1351,262,30,30]);
   
   uicontrol('Style','text','String','Thresh %ile','Position',[1158,225,40,30]);
   hthresh= uicontrol('Style','edit','String',98,'Position',[1205,230,30,30]);
   uicontrol('Style','text','String','Big, Small Sz','Position',[1237,225,40,30]);
   hbigsz= uicontrol('Style','edit','String',7000,'Position',[1272,230,40,30]);
   hsmallsz=uicontrol('Style','edit','String',100,'Position',[1315,230,40,30]);
   
   hchecksurr=uicontrol('Style','checkbox','String','Check Local','Value',1,'Position',[1158,187,80,30]);
   uicontrol('Style','text','String','Surr xy,z','Position',[1240,187,40,30])
   hwsurrxy= uicontrol('Style','edit','String',5,'Position',[1282,192,30,30]);
   hwssurrz=uicontrol('Style','edit','String',3,'Position',[1314,192,30,30]);
   uicontrol('Style','text','String','Ratio','Position',[1356,185,40,30])
   hsurr_thresh=uicontrol('Style','edit','String',0.12,'Position',[1398,192,40,30]);
   

  
 % tracking settings components
   uicontrol('Style','text','String','Tracking Settings','Position',[1300,157,100,30],'FontWeight','bold');
   uicontrol('Style','text','String','MaxLinking Distance(px)','Position',[1150,139,90,30]);
   hMaxLink= uicontrol('Style','edit','String',20,'Position',[1230,139,30,30]);
   uicontrol('Style','text','String','MaxGap','Position',[1280,131,50,30]);
   hMaxGap = uicontrol('Style','edit','String',2,'Position',[1330,139,30,30]);
    uicontrol('Style','text','String','Min Traj Length','Position',[1390,139,60,30]);
   hMinTraj = uicontrol('Style','edit','String',2,'Position',[1440,139,30,30]);
   htrackall =uicontrol('Style','pushbutton','String','Track All','Position',[1505,139,60,30],...
       'Callback', {@trackall_Callback},'FontWeight','bold');
   
  % analysis components
  uicontrol('Style','text','String','Analysis','Position',[1300,103,100,30],'FontWeight','bold');
   uicontrol('Style','text','String','Cent Win xy,z','Position',[1158,85,40,30])
  hcentwsxy= uicontrol('Style','edit','String',3,'Position',[1205,87,30,30]);
  hcentwsz=uicontrol('Style','edit','String',3,'Position',[1237,87,30,30]);
  hreloccent =uicontrol('Style','pushbutton','String','Center All','Position',[1270,87,65,30],...
       'Callback', {@reloccent_Callback});
   

   
    %% initialize
    display_img
    loadz_Callback
    
    
    %% call backs
 
    % callbacks 
    
    % executes on slider movement
    function frame_slider_Callback(hObject,eventdata, handles)
        cframe=round(get(hObject,'Value'));
        set(hcframetxt,'String', num2str(cframe));
        display_img
%         set(findobj('Tag','cframe_val'),'String', num2str(cframe));
    end

    function playpause_Callback(hObject,eventdata, handles)
        if strcmp(get(hObject,'String'),'Play')
            set(hObject,'String','Pause')
        else
             set(hObject,'String','Play')
        end
        fps=str2num(get(hfps,'String'));
        while get(hObject,'Value')
            
            cframe=cframe+1;
            set(hcframetxt,'String',num2str(cframe));
            set(hframe,'Value',cframe);
            display_img
%             drawnow;
            pause(1/fps)     
        end
    end

    function frame_slider_drag_Callback(hObject,event)
        val = get(event.AffectedObject,'Value');
        cframe=round(val);
        set(hcframetxt,'String', num2str(cframe));
        display_img
    end

    % executes on pushbutton press
    function goto_Callback(hObject, eventdata, handles)
        cframe=str2num(get(hcframetxt,'String'));
        set(hframe,'Value',cframe);
        display_img
    end

    function setdisp_Callback(hObject, eventdata, handles)
        mindisp=str2num(get(hminval,'String'));
        maxdisp=str2num(get(hmaxval,'String'));
        display_img
        set(mindispmipslider,'Value',mindisp);
        set(maxdispmipslider,'Value',maxdisp);
    end

    function mindispmipslider_Callback(hObject, eventdata, handles)
        mindisp=round(get(hObject,'Value'));
        set(hminval,'String', num2str(mindisp));
        display_img
    end
    
    function maxdispmipslider_Callback(hObject, eventdata, handles)
        maxdisp=round(get(hObject,'Value'));
        set(hmaxval,'String', num2str(maxdisp));
       display_img
    end

    function maxdispmipslider_drag_Callback(hObject,event)      
        val = get(event.AffectedObject,'Value');
        maxdisp=round(val);
        set(hmaxval,'String', num2str(maxdisp));
        display_img
    end
 
    function mindispmipslider_drag_Callback(hObject,event)      
        val = get(event.AffectedObject,'Value');
        mindisp=round(val);
        set(hminval,'String', num2str(mindisp));
        display_img
    end


    function setdispz_Callback(hObject, eventdata, handles)
        mindispz=str2num(get(hminvalz,'String'));
        maxdispz=str2num(get(hmaxvalz,'String'));
        display_zstack
        set(mindispzslider,'Value',mindisp);
        set(maxdispzslider,'Value',maxdisp);
    end

    function mindispzslider_Callback(hObject, eventdata, handles)
        mindispz=round(get(hObject,'Value'));
        set(hminvalz,'String', num2str(mindispz));
        display_zstack
    end
    
    function maxdispzslider_Callback(hObject, eventdata, handles)
        maxdispz=round(get(hObject,'Value'));
        set(hmaxvalz,'String', num2str(maxdispz));
        display_zstack
    end

    function maxdispzslider_drag_Callback(hObject,event)      
        val = get(event.AffectedObject,'Value');
        maxdispz=round(val);
        set(hmaxvalz,'String', num2str(maxdispz));
        display_zstack
    end
 
    function mindispzslider_drag_Callback(hObject,event)      
        val = get(event.AffectedObject,'Value');
        mindispz=round(val);
        set(hminvalz,'String', num2str(mindispz));
        display_zstack
    end

    function slice_slider_Callback(hObject,eventdata, handles)
        cslice=round(get(hObject,'Value'));
        set(hcslicetxt,'String', num2str(cslice));
        display_zstack
    end


     function slice_slider_drag_Callback(hObject,event)      
        val = get(event.AffectedObject,'Value');
        cslice=round(val);
        set(hcslicetxt,'String', num2str(cslice));
        display_zstack
     end

    

    function loadz_Callback(hObject, eventdata, handles)
        cstackA=loadtiff(strcat(cdetails.dat_path,cfilesA(cframe).name));
        set(czstack_frame,'String',['Stack at Frame: ',num2str(cframe)])
        display_zstack      
    end

%% analysis call backs
    function savedetails_Callback(hObject, eventdata, handles)
        % add most current ms2 file to path and save the cdetails path
        cms2_files=(dir([cdetails.analysispath,'*MS2_list*.mat']));
        if isempty(cms2_files)
            cdetails.MS2_listpath=[];
        else
            [A,I] = max([cms2_files(:).datenum]);
            cms2_name=cms2_files(I).name;        
            cdetails.MS2_listpath=[cdetails.analysispath,cms2_name];
            
        end
        save([cdetails.analysispath,'details_',datestr(datetime('now'),'HH_MM_dd_mm_yyyy'),'.mat'],'cdetails')
    end

    function loaddetails_Callback(hObject, eventdata, handles)
%         cdetails.analysispath
        [file,path] = uigetfile([cdetails.analysispath,'*.mat'],'Select a Details file');        
        if isequal(file,0)
        else
             load([path,file])
             display_img
        end
    end


    function MS2ONtb_Callback(hObject,eventdata, handles)
        if cdetails.MS2on(cframe)==1
            cdetails.MS2on(cframe)=0;
        elseif cdetails.MS2on(cframe)==0
            cdetails.MS2on(cframe)=1;
        end
        display_img
    end

    function Ignoredtb_Callback(hObject,eventdata, handles)
        if cdetails.ignoreframe(cframe)==1
            cdetails.ignoreframe(cframe)=0;
        elseif cdetails.ignoreframe(cframe)==0
            cdetails.ignoreframe(cframe)=1;
        end
        display_img
    end
    

    function updateNC_Callback(hObject,eventdata, handles)
        cdetails.NC(cframe)=str2num(get(hNCtxt,'String'));
    end

    function dispdetect_Callback(hObject, eventdata, handles)
        if get(hdispdetect,'Value')
            set(hdispdetect,'BackgroundColor','green')
        else
            set(hdispdetect,'BackgroundColor','red')
        end
        set(hDispTraj,'Value',0,'BackgroundColor','red')
        display_img
        display_zstack
        
    end


    function dispTraj_Callback(hObject, eventdata, handles)
        if get(hDispTraj,'Value')
            set(hDispTraj,'BackgroundColor','green')
            set(hdispdetect,'Value',0,'BackgroundColor','red')
 
        else
            set(hDispTraj,'BackgroundColor','red')
        end
        

        display_img
        display_zstack
    end

 
   function traj_list_Callback(hObject, eventdata, handles)
        if length(get(hTrajList,'Value'))==1
            traj_selected = cMS2_list(get(hTrajList,'Value'),4);
            display_zstack
        else
            traj_selected = cMS2_list(get(hTrajList,'Value'),4);
        end
   end 

  function delTraj_Callback(hObject, eventdata, handles)            
      traj_selected = cMS2_list(get(hTrajList,'Value'),4);
      for ctraj=1:length(traj_selected)
          MS2_listtemp=MS2_list(MS2_list(:,4)~=traj_selected(ctraj),:);
          MS2_list=MS2_listtemp;
      end
      MS2_list=sortrows(MS2_list,4);
      MS2_list=sortrows(MS2_list,5);
      set(hTrajList,'Value',1)
      display_img            
  end 

  function renumTraj_Callback(hObject, eventdata, handles) 
       MS2_list3=MS2_list;
       MS2_list3(:,4)=0;
       [C,~,~] = unique(MS2_list(:,4));
       ctr=1;
       for cid=1:length(C)
        MS2_list3(MS2_list(:,4)==C(cid),4)=ctr;
        ctr=ctr+1;
       end
       
       MS2_list=sortrows(MS2_list3,5);
       set(hTrajList,'Value',1)
       display_img 
  end

  function connTraj_Callback(hObject, eventdata, handles)
    prompt = {'1st Traj Number';'2nd Traj Number'};
    title = 'Enter two trajectories too connect';
    answer = inputdlg(prompt,title);
    c1=str2num(answer{1});
    c2=str2num(answer{2});
    MS2_list(MS2_list(:,4)==c2,4)=c1;
    MS2_list=sortrows(MS2_list,4);
    MS2_list=sortrows(MS2_list,5);
    display_img
    
  end


    function loadTraj_Callback(hObject, eventdata, handles)
%         cdetails.analysispath
        [file,path] = uigetfile([cdetails.analysispath,'*.mat'],'Select a traj list file');
        
        if isequal(file,0)
        else
             load([path,file])
             display_img
        end
    end

    function saveTraj_Callback(hObject, eventdata, handles)
        save([cdetails.analysispath,'MS2_list_',datestr(datetime('now'),'HH_MM_dd_mm_yyyy'),'.mat'],'MS2_list')
        
%         [file,path] = uiputfile([cdetails.analysispath,'.mat'],'Save the current traj list');
%         if isequal(file,0)
%         else
%              save([path,file]','MS2_list')
%         end
    end

    function addParticle_Callback(hObject, eventdata, handles)            
            axes(hztack)
            [r,c] = ginput(1);
            z=cslice;
            seg_particle(r,c,z);
            display_img
    end

    function delParticle_Callback(hObject, eventdata, handles)
        traj_selected = cMS2_list(get(hTrajList,'Value'),4);
        if size(traj_selected,1)==1
          for k=1:size(MS2_list,1)
              if MS2_list(k,4)==traj_selected && MS2_list(k,5)==cframe
                  MS2_list(k,:)
                  MS2_list(k,:)=[];
              else
                  
              end
          end
        end
      set(hTrajList,'Value',1)
      display_img            
        
    end

    function testdetect_Callback(hObject, eventdata, handles)
        
        set(f, 'pointer', 'watch') 
        drawnow;
        
        dog1=[str2num(get(hdog1xy,'String')), str2num(get(hdog1xy,'String')), str2num(get(hdog1z,'String'))];
        dog2=[str2num(get(hdog2xy,'String')), str2num(get(hdog2xy,'String')), str2num(get(hdog2z,'String'))];
        thresh=str2num(get(hthresh,'String')); 
        bigsz=str2num(get(hbigsz,'String')); smallsz=str2num(get(hsmallsz,'String'));
        check_surr=get(hchecksurr,'Value'); wsurrxy=str2num(get(hwsurrxy,'String')); wssurrz=str2num(get(hwssurrz,'String'));
        surr_thresh=str2num(get(hsurr_thresh,'String'));
        disp=1;
        particle_list=autodetect_parts(cstackA, dog1, dog2, thresh, bigsz, smallsz, cslice, check_surr,...
            wsurrxy, wssurrz, surr_thresh, disp);
        
        set(f, 'pointer', 'arrow') 
        drawnow;
    end




    function detectall_Callback(hObject, eventdata, handles)
        answer = questdlg('This will take a while and will generate a new MS2 list, click No and save the current list  for back up if needed.', ...
            'Detect All', 'Continue', 'No','No');

        switch answer
            case 'Continue'
                set(f, 'pointer', 'watch') 
                drawnow;
                dog1=[str2num(get(hdog1xy,'String')), str2num(get(hdog1xy,'String')), str2num(get(hdog1z,'String'))];
                dog2=[str2num(get(hdog2xy,'String')), str2num(get(hdog2xy,'String')), str2num(get(hdog2z,'String'))];
                thresh=str2num(get(hthresh,'String')); 
                bigsz=str2num(get(hbigsz,'String')); smallsz=str2num(get(hsmallsz,'String'));
                check_surr=get(hchecksurr,'Value'); wsurrxy=str2num(get(hwsurrxy,'String')); wssurrz=str2num(get(hwssurrz,'String'));
                surr_thresh=str2num(get(hsurr_thresh,'String'));
                disp=0;
                tic
                parfor ct=1:size(cfilesA,1)
                    ct
                    if cdetails.ignoreframe(ct)==0 && cdetails.MS2on(ct)==1
                        cstackA=loadtiff(strcat(cdetails.dat_path,cfilesA(ct).name));
                        particle_list=autodetect_parts(cstackA, dog1, dog2, thresh, bigsz, smallsz, 1, check_surr,...
                        wsurrxy, wssurrz, surr_thresh, disp);
                        particle_list(:,5)=ct;
                        MS2_list2{ct}=particle_list;
                    end
                end
                toc
                MS2_list= vertcat(MS2_list2{:});
                ID_list=(1:1:size(MS2_list,1))';
                MS2_list(:,4)=ID_list;
                 set(f, 'pointer', 'arrow') 
                 drawnow;
            case 'No'
                'No'
        end
    end

    function detectcurrent_Callback(hObject, eventdata, handles)
        answer = questdlg( ...
            'This will overwrite the current detections on this frame and remove this particles from trajectories. Run test detections first to check parameters. Re run track all after doing this or manually fix the trajectories.', ...
            'Detect All', 'Continue', 'No','No');

        switch answer
            case 'Continue'
                set(f, 'pointer', 'watch') 
                drawnow;
                dog1=[str2num(get(hdog1xy,'String')), str2num(get(hdog1xy,'String')), str2num(get(hdog1z,'String'))];
                dog2=[str2num(get(hdog2xy,'String')), str2num(get(hdog2xy,'String')), str2num(get(hdog2z,'String'))];
                thresh=str2num(get(hthresh,'String')); 
                bigsz=str2num(get(hbigsz,'String')); smallsz=str2num(get(hsmallsz,'String'));
                check_surr=get(hchecksurr,'Value'); wsurrxy=str2num(get(hwsurrxy,'String')); wssurrz=str2num(get(hwssurrz,'String'));
                surr_thresh=str2num(get(hsurr_thresh,'String'));
                disp=0;
                particle_list=autodetect_parts(cstackA, dog1, dog2, thresh, bigsz, smallsz, cslice, check_surr,...
                    wsurrxy, wssurrz, surr_thresh, disp);
                
                % delete the existing detections on this frame
                MS2_list(MS2_list(:,5)==cframe,:)=[];
                % get new numbers
                cid=max(MS2_list(:,4));
                newids=(cid+1:1:cid+size(particle_list,1))';
                particle_list(:,4)=newids;
                particle_list(:,5)=cframe;
                MS2_list=vertcat(MS2_list,particle_list);
                set(f, 'pointer', 'arrow') 
                drawnow;
                display_img
                
            case 'No'
                'No'
        end
        
    end

    function resetdetsettings_Callback(hObject, eventdata, handles)
        set(hdog1xy,'String',5),set(hdog1z,'String',5);
                set(hdog2xy,'String',0.75); set(hdog2z,'String',1);
                set(hthresh,'String',98); 
                set(hbigsz,'String',7000); set(hsmallsz,'String',100);
                set(hchecksurr,'Value',1); set(hwsurrxy,'String',5); set(hwssurrz,'String',3);
                set(hsurr_thresh,'String',0.12);
    end

    function trackall_Callback(hObject, eventdata, handles)
         set(f, 'pointer', 'watch') 
         drawnow;
        max_linking_distance = str2num(get(hMaxLink,'String')); % distance over which to link
        max_gap_closing = str2num(get(hMaxGap,'String')); % number of frames that a dot can be missing
        debug = false;
        trajmin=str2num(get(hMinTraj,'String'));
        clear points MS2_list2
        % make a cell array version for tracking, one cell per movie frame
        for cfr=1:cdetails.nFrames
            clear cMS2_list2
            cMS2_list2=MS2_list(MS2_list(:,5)==cfr,:); %get detections in current frame
            if ~isempty(cMS2_list2) 
                points{cfr}=cMS2_list2(:,1:3); %format for simple tracker
                MS2_list2{cfr}=cMS2_list2(:,:); % make adummy MS2 list for adding the tracked IDs back to
            else
                points{cfr}=[10000 10000 10000]; % if no detections in this frame add 10000 as dummy as required by simple tracker
                MS2_list2{cfr}=[10000 10000 10000 10000 cfr];
            end
        end
        
        
        [ tracks, adjacency_tracks ] = simpletracker(points,...
        'MaxLinkingDistance', max_linking_distance, ...
        'MaxGapClosing', max_gap_closing, ...
        'Debug', debug);
        MS2_list2= vertcat(MS2_list2{:}); % make the cell array into a matrix
        for i_track = 1 : size(adjacency_tracks,1) % now add the track IDs to the right column

            track = adjacency_tracks{i_track};
            MS2_list2(track,4)=i_track;   
        end
        MS2_list2=MS2_list2(MS2_list2(:,1)~=10000,:); % remove the dummy IDs
        MS2_list2=MS2_list2(MS2_list2(:,1)~=0,:); % and things that are 0
        % remove short trajectories
        [C,ia,ic] = unique(MS2_list2(:,4));

        for cid=1:length(C)
            if size(MS2_list2(MS2_list2(:,4)==C(cid),:),1)<2
                MS2_list2=MS2_list2(MS2_list2(:,4)~=C(cid),:);
            end
        end
        % renumber trajetories
        MS2_list3=MS2_list2;
        MS2_list3(:,4)=0;
        [C,ia,ic] = unique(MS2_list2(:,4));
        ctr=1;
        for cid=1:length(C)
               MS2_list3(MS2_list2(:,4)==C(cid),4)=ctr;
               ctr=ctr+1;
        end
        MS2_list=MS2_list3;
        MS2_list = sortrows(MS2_list,5); 
         set(f, 'pointer', 'arrow') 
         drawnow;
         display_img
    end

    function reloccent_Callback(hObject, eventdata, handles) 
        set(f, 'pointer', 'watch') 
        drawnow;
        xy_ws=str2num(get(hcentwsxy,'String'));
        z_ws=str2num(get(hcentwsz,'String'));
        hwait = waitbar(0,'Please wait...');

        for c=1:size(MS2_list,1)
            waitbar(c/size(MS2_list,1),hwait)
            cfr=MS2_list(c,5);
            cstackA=loadtiff(strcat(cdetails.dat_path,cfilesA(cfr).name)); 
            cent_row=round(MS2_list(c,2)); cent_col=round(MS2_list(c,1)); centz=round(MS2_list(c,3));  % get center positions for cropping
            croppedA=crop_around_dot(xy_ws,z_ws,cent_row, cent_col, centz,cstackA);
            [new_cent_row, new_cent_col, new_centz]=relocalize_dot(cent_row, cent_col, centz,croppedA,xy_ws,z_ws);
            MS2_list(c,2)=new_cent_row;
            MS2_list(c,1)=new_cent_col;
            MS2_list(c,3)=new_centz;
        end
        close(hwait)
         set(f, 'pointer', 'arrow') 
         drawnow;
         display_img
    end


%% initialization functions
    function initial_dialog
        %%
        cdetailfiles=dir('*details*.m');
        [indx,tf] = listdlg('PromptString','Select a file:','SelectionMode','single','ListString',{cdetailfiles.name},'ListSize',[300 500]);    
        cdata=cdetailfiles(indx).name; 
        fh = str2func(cdata(1:end-2)); 
        cdetails=fh();
        if ~exist(cdetails.analysispath,'dir')
            mkdir(cdetails.analysispath)
        end
        if ~exist([cdetails.analysispath,'details.mat'],'file')
            save([cdetails.analysispath,'details.mat'],'cdetails')
        else
            cdetails_files=(dir([cdetails.analysispath,'*details*.mat']));
            [A,I] = max([cdetails_files(:).datenum]);
            cdetails_name=cdetails_files(I).name;
            load([cdetails.analysispath,cdetails_name]);
        end
        
        
        cms2_files=(dir([cdetails.analysispath,'*MS2_list*.mat']));
        if isempty(cms2_files)
            errordlg('No MS2_list trajectory file found, run localization and tracking first','No Trajectory List');
        else
            [A,I] = max([cms2_files(:).datenum]);
            cms2_name=cms2_files(I).name;
            cdetails.MS2_listpath=[cdetails.analysispath,cms2_name];
            load(cdetails.MS2_listpath);

        end
        
    end
%% display functions
    % replot the image
    function display_img
        axes(hmip)
        imagesc(cmip(:,:,cframe),[mindisp,maxdisp]),axis image;
        colormap gray
        
        set(hNCtxt,'String',cdetails.NC(cframe))
        if cdetails.MS2on(cframe)==1
            set(hMS2ONtb,'Value',1,'BackgroundColor','green')
        else
            set(hMS2ONtb,'Value',0,'BackgroundColor','red')
        end
        
        if cdetails.ignoreframe(cframe)==0
            set(hIgnoredtb,'Value',1,'BackgroundColor','green','String','Not Ignored')
        else
            set(hIgnoredtb,'Value',0,'BackgroundColor','red','String','Ignored')
        end
        
        if get(hdispdetect,'Value')           
            cMS2_list=MS2_list(MS2_list(:,5)==cframe,:);
            if ~isempty(cMS2_list)
                set(hTrajList,'Value',1)
                populate_trajlist
                colormap gray
                hold on
                scatter(cMS2_list(:,1),cMS2_list(:,2),3,'r')
                text(cMS2_list(:,1),cMS2_list(:,2),num2str(cMS2_list(:,4)),'Color','red')
                hold off
             else
                cMS2_list=[];
                populate_trajlist
            end
        end
        
        
        if get(hDispTraj,'Value')           
            cMS2_list=MS2_list(MS2_list(:,5)==cframe,:);
            if ~isempty(cMS2_list)
                set(hTrajList,'Value',1)
                populate_trajlist
                colormap gray
                hold on
                scatter(cMS2_list(:,1),cMS2_list(:,2),3,'r')
                text(cMS2_list(:,1)+1,cMS2_list(:,2)+1,num2str(cMS2_list(:,4)),'Color','red')
                for k=1:size(cMS2_list,1)
                    clear ctraj
                    ctraj=MS2_list(MS2_list(:,4)==cMS2_list(k,4),:);
                    ctraj=ctraj(ctraj(:,5)<=cframe,:);
                    ctraj=sortrows(ctraj,5); 
                    plot(ctraj(:,1),ctraj(:,2));
                end                        
                hold off  
            else
                cMS2_list=[];
                populate_trajlist
            end
        end
        
    end


    function display_zstack
        mindispz= str2num(get(hminvalz,'String')); maxdispz=str2num(get(hmaxvalz,'String'));
        if isempty(cslice)
            cslice=25;
        end

        if get(hDispTraj,'Value') && traj_selected ~=0
            clear ctraj
            ctraj=MS2_list(MS2_list(:,4)==traj_selected,:);
            cslice=round(ctraj(ctraj(:,5)==cframe,3));
            if isempty(cslice)
                cslice=25;
            end
            cstackA=loadtiff(strcat(cdetails.dat_path,cfilesA(cframe).name));
            set(czstack_frame,'String',['Stack at Frame: ',num2str(cframe)])
            set(hcslicetxt,'String', num2str(cslice));
            axes(hztack)
            hold on
            imagesc(cstackA(:,:,cslice),[mindispz,maxdispz]),axis image;
            colormap gray
            ctraj=ctraj(ctraj(:,5)<=cframe,:);
            ctraj=sortrows(ctraj,5); 
            plot(ctraj(:,1),ctraj(:,2),'LineWidth',2);
            text(ctraj(end,1)+1,ctraj(end,2)+1,num2str(ctraj(end,4)),'Color','red')
            hold off
            
        elseif get(hdispdetect,'Value')
                axes(hztack)
                cstackA=loadtiff(strcat(cdetails.dat_path,cfilesA(cframe).name));
                imagesc(cstackA(:,:,cslice),[mindispz,maxdispz]),axis image;   
                if ~isempty(cMS2_list)
                    colormap gray
                    hold on
                    scatter(cMS2_list(:,1),cMS2_list(:,2),3,'r')
                    text(cMS2_list(:,1),cMS2_list(:,2),num2str(cMS2_list(:,4)),'Color','red')
                    hold off   
                end
        else
            axes(hztack)
            imagesc(cstackA(:,:,cslice),[mindispz,maxdispz]),axis image;
            colormap gray
        end
    end


%% trajectory editing functions
function populate_trajlist
    if ~isempty(cMS2_list)
        set(hTrajList,'String',cMS2_list(:,4))
    else
        set(hTrajList,'String',0)
    end
end

function seg_particle(r,c,z)
    % 1x 2y 3z 4min 5max 6mean 7vol 8frame 9index
    r=round(r); c=round(c);  z=round(z);
    wnxy=7; wnz=3;
    if z-wnz<1 || z+wnz>size(cstackA,3)
        errordlg('Particle too close to end of z-stack','Particle Error');
    else
        cstackseg=zeros(size(cstackA));
        cstackseg(c-wnxy:c+wnxy,r-wnxy:r+wnz,z-wnz:z+wnz)=cstackA(c-wnxy:c+wnxy,r-wnxy:r+wnz,z-wnz:z+wnz);
        [~,max_idx] = max(cstackseg(:));
        [r, c, z]=ind2sub(size(cstackseg),max_idx);
        MS2_list(end+1,1:3)=[c,r,z];
%         MS2_list(end,4:7)=0;
        MS2_list(end,5)=cframe;
        prompt = {'Enter trajectory number to add particle to (0 if new):',};
        title = 'Add Particle';
        definput = {'0'};
        answer = inputdlg(prompt,title,[1 35],definput);
        c1=str2num(answer{1});
        if c1==0
            MS2_list(end,4)=max(MS2_list(:,4))+1;
        else
            MS2_list(end,4)=c1;           
        end
        MS2_list(end,:);
        MS2_list=sortrows(MS2_list,4);
        MS2_list=sortrows(MS2_list,5);
    end
    
%     cstack1=imgaussfilt3(cstackseg,5); %apply median filter (figure 2) 
%     cstack2 = imgaussfilt3(cstackseg,0.5); %apply gaussian filter
%     cstack3 = cstack2-cstack1; %apply gaussian filter
%     BW = edge3(cstack3,'Sobel',0.25,'nothinning');
%     figure, imagesc(max(cstack3,[],3));
end

%% analysis functions
function [new_cent_row, new_cent_col, new_centz]=relocalize_dot(cent_row, cent_col,centz,croppedI,xy_ws,z_ws)

    cdotIxy = max(croppedI,[],3); % max projection
    cdotIxz = max(croppedI,[],2); % max projection
    cdotIxz=reshape(cdotIxz,size(cdotIxz,1),size(cdotIxz,3),1);
                         
    cdotProfrow=smooth(mean(cdotIxy,2),3); %mean intensity profile
    cdotProfcol=smooth(mean(cdotIxy,1),3); %mean intensity profile
    cdotProfxz=smooth(mean(cdotIxz,1),3); %mean intensity profile
          
    [~,Irow]=max(cdotProfrow);
    [~,Icol]=max(cdotProfcol);
    [~,Ixz]=max(cdotProfxz);
         
    offrow=xy_ws+1-Irow;
    offcol=xy_ws+1-Icol;
    offz=z_ws+1-Ixz;
          
    new_cent_row=cent_row-offrow;
    new_cent_col=cent_col-offcol;
    new_centz=centz-offz;

end



function croppedI=crop_around_dot(xy_ws,z_ws,cent_row, cent_col, centz,cstack)
%loc should be row, column, z position
   
    croppedI=uint16(zeros(xy_ws*2+1,xy_ws*2+1, z_ws*2+1));  % intialize matrices for cropped image
    zmin=centz-z_ws; zmax=centz+z_ws; zmin_crop=1; zmax_crop=z_ws*2+1; % initialize cropping indices for z
    colmin=cent_col-xy_ws; colmax=cent_col+xy_ws; colmin_crop=1; colmax_crop=xy_ws*2+1; % initialize cropping indices for columns
    rowmin=cent_row-xy_ws; rowmax=cent_row+xy_ws; rowmin_crop=1; rowmax_crop=xy_ws*2+1; % initialize cropping indices for rows
    if (centz-z_ws)<1 
        zmin=1;
        zmin_crop=zmin_crop-(centz-z_ws)+1;
    end

    if (centz+z_ws)>size(cstack,3)
        zmax=size(cstackA,3);
        zmax_crop=zmax_crop+zmax-centz-z_ws;
    end

    if (cent_row+xy_ws) > size(cstack,1)  
        rowmax=size(cstackA,1);
        rowmax_crop=rowmax_crop+rowmax-cent_row-xy_ws;
    end

    if (cent_row-xy_ws) <1
        rowmin=1;
        rowmin_crop=rowmin_crop-(cent_row-xy_ws)+1;
    end 

    if (cent_col-xy_ws)<1
        colmin=1;
        colmin_crop=colmin_crop-(cent_col-xy_ws)+1;
    end

    if (cent_col+xy_ws) > size(cstack,2) 
        colmax=size(cstackA,2);
        colmax_crop=colmax_crop+colmax-cent_col-xy_ws;
    end

    croppedI(rowmin_crop:rowmax_crop,colmin_crop:colmax_crop,zmin_crop:zmax_crop) = cstack(rowmin:rowmax, colmin:colmax,zmin:zmax);
    
end



    
end