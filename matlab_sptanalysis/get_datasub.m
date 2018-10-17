function cdata_list=get_datasub(data_list,field_name,val1,condit)
% the data structure
% data_list the data structure
% field_name: name of the field in the structure on which to select the data subset
% val1 and val2 the value of the fields to compare 
% condit what condition to apply '==', '<=', '>=', for strings only '==' or
% matching will be done

%%
% field_name='set_name';

% figure out what kind of variable it is
if ~isempty(data_list)
tst=data_list(1).(field_name);
if ischar(tst)==1
    typ='String';
elseif isnumeric(tst)==1
    typ='Num';
end
ctr=1;
    for cnuc=1:size(data_list,2)
        switch typ
            case 'String'
                if strcmp(data_list(cnuc).(field_name),val1)       
                    cdata_list(ctr)=data_list(cnuc);        
                    ctr=ctr+1;  
                end
            case 'Num'
                switch condit
                    case '=='
                      if data_list(cnuc).(field_name) == val1      
                        cdata_list(ctr)=data_list(cnuc);        
                        ctr=ctr+1;  
                      end  
                    case '<='
                      if data_list(cnuc).(field_name) <= val1      
                        cdata_list(ctr)=data_list(cnuc);        
                        ctr=ctr+1;  
                      end
                    case '>='
                      if data_list(cnuc).(field_name) >= val1      
                        cdata_list(ctr)=data_list(cnuc);        
                        ctr=ctr+1;  
                      end
                    case '<'
                      if data_list(cnuc).(field_name) < val1      
                        cdata_list(ctr)=data_list(cnuc);        
                        ctr=ctr+1;  
                      end
                    case '>'
                      if data_list(cnuc).(field_name) > val1      
                        cdata_list(ctr)=data_list(cnuc);        
                        ctr=ctr+1;  
                      end
                end
        end
    end
if ctr==1 %no data found
    cdata_list=[];
end
else
    cdata_list=[];
end

end

