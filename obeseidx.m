

%% read medical records and convert them to characters
fl= dir('*.txt');
n = length(fl);

% read files and comebine the same character
lastrow = 0;
for j = 1:n
    symbolicseq = fileread(fl(j).name);
    text = text_preprocessing(symbolicseq,0);
    tra_text = text.';                           % transpose text  
    uniq_text = unique(tra_text);                % remove repetitions
    row = length(uniq_text);                     % get number of character
    
   for j = 1:row
       common(1,j+lastrow) = uniq_text(1,j);
   end
   
   lastrow = row+lastrow;
end   
Acommon = unique(common);

%% Find apear times in all data
    
for l = 1:2   % 1:capital; 2:lower
    if l == 2
        Acommon = lower(Acommon);
    end
    
    for j = 1:n
        mr = fileread(fl(j).name);
        find(j,:) = cellfun(@(s) ~isempty(strfind(mr, s)), Acommon);
        disp([fl(j).name, ' finish!'])
    end

    frequency = sum(find);
    obesity_fre(1,:) = Acommon;
    obesity_fre(2,:) = num2cell(frequency);
    obesity_tra = obesity_fre.';
    obesity_sort = sortrows(obesity_tra,2,'descend');

    m = length(Acommon);

    for j = 1:m
         score(1,j) = j;
         score(2,j) = sum(find(1:200,j));
         score(3,j) = sum(find(201:400,j));
         score(4,j) = score(3,j)-score(2,j);
         score(5,j) = score(3,j)/(score(2,j)+score(3,j));
    end

    score = score.';
    del = score(:,5)<0.9| (score(:,4)<4 & score(:,5)>=1) | isnan(score(:,5)); 
    score(del,:)=[];
    
    words_result = Acommon.';
    words_result(del,:)=[];
    
    if l == 1
        WORDS = words_result;
        WORDS_score = score;
    else
        words = words_result;
        words_score = score;
    end
end


%% find the best F1-score in different combination

allwords = [WORDS.',words.'];
p = length(allwords); %字串個數

i = 2; % 取多少個字元做組合
com = nchoosek((1:p),i); 
times = length(com);

for k = 1:times
    tested = allwords(com(k,:));

    for j = 1:n
        obese_counts = 0;
        mr = fileread(fl(j).name);
        match = cellfun(@(s) ~isempty(strfind(mr, s)), tested);

        if sum(match) > 0
            obese_counts = obese_counts + 1;
        end

        if obese_counts > 0
            result(j,1) = true;
        else
            result(j,1) = false;
        end

    end 

    TN = length(find(result(1:200)==0));
    FP = length(find(result(1:200)==1));
    TP = length(find(result(201:400)==1));
    FN = length(find(result(201:400)==0));

    Precision = TP/(TP+FP);
    Accuracy = (TP+TN)/(TN+FN+TP+FP);
    Recall = TP/(TP+FN);
    F1score = (2*Precision*Recall)/(Precision+Recall);

    clear match

    wordrecord(k,:) = {tested,Precision,Accuracy,Recall,F1score};
    disp([num2str(k/times*100), '% completed'])
    
    
end

wordrecord_sort= sortrows(wordrecord,5,'descend'); % from high to low
    
%% obesity status detection

filepath = pwd;
fl= dir('*.txt');
n=length(fl);
listing = dir(filepath);

obese_counts = 0;
obesity_wordset = {'obesity','obese','CHRONIC','dentition','ADVAIR','cerebrovascular'}; 

for j = 1:n
    obese_counts = 0;
    mr = fileread(fl(j).name);
    match(j,:) = cellfun(@(s) ~isempty(strfind(mr, s)), obesity_wordset);
   
    if sum(match(j,:)) > 0
        obese_counts = obese_counts + 1;
    end
    
    validation_result{j,1} = fl(j).name;
    
    if obese_counts > 0
        validation_result{j,2} = 1;
    else
        validation_result{j,2} = 0;
    end
end
