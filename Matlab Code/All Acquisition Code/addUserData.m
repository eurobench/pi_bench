
function addUserData(src,evt)
data = [evt.TimeStamps, evt.Data];
src.UserData.signals = [src.UserData.signals;data];
end