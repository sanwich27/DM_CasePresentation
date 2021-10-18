# Case Presentation 1 of YM_3 of Digit Medicine

Team member: Tsai, W.X., Liu, X.Y., Li, B.Y., Ting, Y.C.

Overview of the task
---------
Design an analysis flow for obesity status classifiers according to textual judgment (presence of obesity or unmentioned)
- Training data based on textual judgement (200 cases obesity vs. 200 cases unmentioned)
- Testing data based on intuitive judgement (200 cases obesity vs. 200 cases absence)
- Validation data based on textual judgement (50 cases)


Prerequisite
------
This script executed under the matlab R2020b environment

Usage
-----
There are 4 sections in this script  
It is recommended to implement each section individually and stage by stage  
Section 4 can be executed separately  

- Section 1：read medical records and convert them to seperate characters
  - Use text_preprocessing function from Information-based Similarity Toolbox
    - Note that after the text-preprocessing process, the characters in outputs are all changed into uppercase
  - Key output:
    - Acommon: non-repeated characters from the files in input folder 

- Section 2: find appear times in all data
  - This section needs processed prior section first
  - Parameter setting：
    ```
    del = score(:,5)<0.9| (score(:,4)<4 & score(:,5)>=1) | isnan(score(:,5));
    ```
    - exclude condition
      - Occurrences proportion lower than 0.9 
      - Less than 4 times
 
  - Key output
    - score:
      - number of each character
      - Occurances in unmentioned data (counted if the data include the character)
      - Occurances in obesity data
      - The difference in frequency between unmentioned and obesity group
      - Percentage of appearances in obesity to all times
    - WORDS: the capital characters fit the condition
    - words: the lower characters fit the condition

- Section 3: find the best F1-score in different combination
    - Used to find out all combination of characters listed in above
    - Note that too many words (i) in the combination may cause too much time
    ```
    p = length(allwords);
    i = 2; 
    com = nchoosek((1:p),i);
    ```
    - Key output:
      - wordrecord_sort: list all combinations from high to low according to F1-score 

- Section 4: obesity status detection
    -  Used to verify data and output judgment results
    -  Enter the keywords used to verify the data
    ```
    obesity_wordset = {'obesity','obese','CHRONIC','dentition','ADVAIR','cerebrovascular'};
    ```
    - Key output:
       - match: show whether there are detected characters in each file
       - validation_result: show the detection result


Experiment results
------------
According to Kaggle result, the highest score we got was 0.65714 

