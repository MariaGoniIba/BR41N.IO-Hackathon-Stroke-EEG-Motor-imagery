# BR41N.IO-Hackathon-Stroke-EEG-Motor-imagery
The following project is part of the BR41N.IO Designers' Hackathon organized by Gtec medical engineering. In this project, the idea is to decode left and hand movement through motor imagery using EEG data for stroke rehabilitation purposes.

# Paradigm
Participants went through BCI treatment consisting on 25 BCI sessions. We are provided with data from 3 participants first (PRE) and last (POST) BCI session. Each session lasts 1h at a time and is made up by a TRAINING and TEST run (i.e., recording). The instruction by the BCI whether the patient should imagine a left or right hand movement is provided 2 sec after the trigger. And the trigger can be 1(left) or -1(right). 

<p align="center">
    <img width="600" src="https://github.com/MariaGoniIba/BR41N.IO-Hackathon-Stroke-EEG-Motor-imagery/blob/main/Paradigm.png">
</p>

# Steps
Data was filtered with a 4th order band pass filter. We selected trials of 1.5 seconds starting at 3.5 seconds after the trigger. A set of temporal and frequencial features were extracted. Classifiers include a Random Forest and a linear SVM.

# Results
<p align="center">
    <img width="800" src="https://github.com/MariaGoniIba/BR41N.IO-Hackathon-Stroke-EEG-Motor-imagery/blob/main/Results.png">
</p>

Unfortunately, results were not good but this was a 24 hour event. The pipeline and features will be further explored in the near future. 

# Papers
* [Brain Computer Interface Treatment for Motor Rehabilitation of Upper Extremity of Stroke Patients — A Feasibility Study](https://www.frontiersin.org/articles/10.3389/fnins.2020.591435/full)
