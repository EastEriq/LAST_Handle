function displayProperties(X)
% Displays on shell the values of all properties, visible and hidden,
%  without distinction. The trick comes from
%  https://undocumentedmatlab.com/articles/accessing-private-object-properties

    % temporarily squelch the warning on casting  class to structure
    id='MATLAB:structOnObject';
    presentstate=warning('query',id);
    warning('off',id)
    disp(struct(X))
    warning(presentstate.state,id); %restore state
end