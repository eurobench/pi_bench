clear 
close all

t = tcpip('localhost', 30000, 'NetworkRole', 'client');
fopen(t);

%while loop to generate continous streaming 


 s = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

%find number of random characters to choose from
numRands = length(s); 

%specify length of random string to generate
sLength = 50;

%generate random string
data = s( ceil(rand(1,sLength)*numRands) );

    fwrite(t, data, 'char')
    %be careful with Output Buffersize --> 512 default

