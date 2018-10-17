function data_list=parse_cycle_phase(data_list)
     for cstack=1:size(data_list,2)
          %% ctsack
          % make a grouping variable
          % if starts and ends in interphase =1
          % if starts in interphase and ends in prophase =2
          % if starts in prophase and ends in prophase =3
          % if it is a histone movie =5
          % if starts or ends in anything else =4
          
%           cstack=1
          if strcmp(data_list(cstack).phase_s,'interphase') && strcmp(data_list(cstack).phase_e,'interphase')
              data_list(cstack).cycle_group=1;
          elseif strcmp(data_list(cstack).phase_s,'interphase') && strcmp(data_list(cstack).phase_e,'prophase')
               data_list(cstack).cycle_group=2;
          elseif strcmp(data_list(cstack).phase_s,'prophase') && strcmp(data_list(cstack).phase_e,'prophase')
               data_list(cstack).cycle_group=3;
          elseif strcmp(data_list(cstack).phase_s,'histones') && strcmp(data_list(cstack).phase_e,'histones')
               data_list(cstack).cycle_group=5;
          else
               data_list(cstack).cycle_group=4;
          end
          
          if data_list(cstack).EL <= 1/3
              data_list(cstack).EL_bin=1;
          elseif data_list(cstack).EL > 1/3 && data_list(cstack).EL <= 2/3
              data_list(cstack).EL_bin=2;
          elseif data_list(cstack).EL > 2/3
              data_list(cstack).EL_bin=3;
          end
         
     end


end        
