function [Obj,OutStruct]=writePropToFile(Obj,ListProp,varargin)
    % write a list of Object properties into a status file
    % Input  : - An object
    %          - A cell array ocontaining the list of properties
    %          * ...,key,val,...
    %            'Path' - File path. Default is '~'.
    %            'FileName' - File name. Default is 'status.txt'.
    %            'WriteTimeTagJD' - Default is true.
    %            'WriteTimeTagStr' - Default is true.
    %            'Permission' - Write permission. Default is 'w'.
    %            'DiscardBeforeWriting' - Default is true.
    % Output : - An object.
    %          - A structure containing the printed properties.


    InPar = inputParser;
    addOptional(InPar,'Path','~');  
    addOptional(InPar,'FileName','status.txt');  
    addOptional(InPar,'WriteTimeTagJD',true);  
    addOptional(InPar,'WriteTimeTagStr',true);  
    addOptional(InPar,'Permission','a');  
    addOptional(InPar,'DiscardBeforeWriting','a');  
    parse(InPar,varargin{:});
    InPar = InPar.Results;

    FullFileName = sprintf('%s%s%s',InPar.Path,filesep,InPar.FileName);
    if InPar.DiscardBeforeWriting
        delete(FullFileName);
    end
    FID = fopen(FullFileName,InPar.Permission);
    JD = celestial.time.julday;
    if InPar.WriteTimeTagJD
        % write time tag
        OutStruct.TimeTagJD = JD;
        fprintf(FID,'TimeTagJD     : %22.16f : \n',OutStruct.TimeTagJD);
    end
    if InPar.WriteTimeTagStr
        % write time tag
        StrDate = convert.time(JD,'JD','StrDate');
        OutStruct.TimeTagStr = StrDate;
        fprintf(FID,'TimeTagStr    : %s : \n',OutStruct.TimeTagStr{1});
    end

    Nprop = numel(ListProp);
    for Iprop=1:1:Nprop
        OutStruct.(ListProp{Iprop}) = Obj.(ListProp{Iprop});
        if ischar(OutStruct.(ListProp{Iprop}))
            fprintf(FID,'%s     : %s : \n',ListProp{Iprop},OutStruct.(ListProp{Iprop}));
        elseif isnumeric(OutStruct.(ListProp{Iprop})) && numel(OutStruct.(ListProp{Iprop}))==1
            fprintf(FID,'%s     : %22.16f : \n',ListProp{Iprop},OutStruct.(ListProp{Iprop}));
        else
            error('Proprty must contain a string or a single elemet numeric array');
        end
    end
    fclose(FID);
end
