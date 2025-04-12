# Data-task
//Vaccine ad Campaign Experiment//

*Software used: Stata-18

Instructions:

1. Download do file called "vaccine_ads.do"
2. Open do file and change "file location" to any desired file directory to store data files
3. Run do file 



Logic and Methodology:

Econometric Methodology-
The experimental design of the ad campaign where 1/3 of the participants are assigned treatment
prompted me to utilize a difference in difference regression design. The DID methodology excels at
obtaining the causal effects of a randomly assigned treatment and is perfect for this vaccine ad campaign. 

Logic of Baseline dataset-
I opted to include characteristic/demographic variables common to survey studies: age, gender, education. As most experimental studies focus on adults, I limit our simulation to adults in the U.S. aged 18-90. In order to achieve realism to the actual U.S. population, I used a uniform distribution random generation where the mean and standard deviation of age, education, and gender mirrors the statistics in real life. More specific to this study is political lean, vaccine confidence, and current vaccination status. As COVID-19 vaccines have become a hot political issue, many people may make decisions about vaccines based on their political views. Vaccine confidence is another survey question which helps control for each individual's initial judgement of vaccination. 

Vaccination status is the most central variable as I will use this as the dependent outcome variable to assess the effectiveness of the treatment, which are the ad campaigns. This pre-treatment vaccination status is modified by vaccination confidence, education, political lean, and age. Firstly, confidence about vaccines will certainly effect whether you chose to vaccinate. Those with higher education may have higher levels of trust in medical science and older people may be more health conscious, both leading to higher vaccine uptake. Based on other literatures in the field and the politicization of vaccination in recent years, liberals may be more inclined to vaccinate than moderates or conservatives. Since this is a data simulation, I generated the pre-treatment vaccinations based on these aforementioned effects. 


Assignment dataset-
The assignment dataset is another randomize generation which has 5000 participants where 1/3 receives Treatment 1 (reason ad), 1/3 receives Treatment 2 (emotions ad), and 1/3 do not receive
any treatment (control group). I generate binary indicators for each treatment group.


Endline dataset-
The endline dataset uses the information generated in the baseline dataset and adds a post-treatment vaccination status. This vaccination status is modified by whether the participant was randomly placed into either treatment groups or the control group. To simulate an effective ad campaign intervention, I  
gave those in the treatment groups a higher probability of receiving vaccination. 


Merge and regression
I merge together baseline, assignment, and endline survey datasets and generate our dependent vaccination based on pre and post vaccinations in the baseline and endling datasets. We use binary indicator "time" as the pre- and post- policy indicator and treatment1 and treatment2 as our DiD treatment effects. 


