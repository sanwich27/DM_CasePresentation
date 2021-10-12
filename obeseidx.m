


%% read medical records and convert them to characters
filepath = pwd;
fl= dir('*.txt');
n=length(fl);

% read files and comebine the same character in each group
lastrow = 0;
for i = 1:200 % unmention obesity
    symbolicseq = fileread(fl(i).name);
    text = text_preprocessing(symbolicseq,0);
    tra_text = text.';                           % transpose text  
    uniq_text = unique(tra_text);                % remove repetitions
    row = length(uniq_text);                     % get number of character
    
    for j = 1:row
        unmention(1,j+lastrow) = uniq_text(1,j);
    end
    
    lastrow = row+lastrow;
end   
uniq_unmention = unique(unmention);

lastrow = 0;
for i = 201:400 % unmention obesity
    symbolicseq = fileread(fl(i).name);
    text = text_preprocessing(symbolicseq,0);
    tra_text = text.';                           % transpose text  
    uniq_text = unique(tra_text);                % remove repetitions
    row = length(uniq_text);                     % get number of character
    
    for j = 1:row
        obesity(1,j+lastrow) = uniq_text(1,j);
    end
    
    lastrow = row+lastrow;
end   
uniq_obesity = unique(obesity);

% Find unique characters in the two groups
Acommon = intersect(uniq_unmention,uniq_obesity); 
Obesity = setxor(uniq_obesity,Acommon);
Unmention = setxor(uniq_unmention,Acommon);


%% obesity status detection

filepath = pwd;
fl= dir('*.txt');
n=length(fl);

obese_counts = 0;
obesity_word = {'obese','obesity'}; % 可使用讀txt檔的方式匯入

for i = 1:n
    obese_counts = 0;
    mr = fileread(fl(i).name);
    match = cellfun(@(s) ~isempty(strfind(mr, s)), obesity_word);
   
    if sum(match) > 0
        obese_counts = obese_counts + 1;
    end
    
    if obese_counts > 0
        obesity(i,1) = true;
    else
        obesity(i,1) = false;
    end
end
