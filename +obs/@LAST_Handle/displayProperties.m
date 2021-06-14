function displayProperties(X)
% Displays on shell the values of all properties, visible and hidden,
%  without distinction. The trick comes from
%  https://undocumentedmatlab.com/articles/accessing-private-object-properties
%
% Note: properties whose values cannot be displayed (e.g. because their getter
%  silently errors out) are not shown at all. Use .listAllProperties
%  instead, to discover about their existence

    % temporarily squelch the warning on casting class to structure
    id='MATLAB:structOnObject';
    presentstate=warning('query',id);
    warning('off',id)
    disp(struct(X))
    warning(presentstate.state,id); %restore warning state
end