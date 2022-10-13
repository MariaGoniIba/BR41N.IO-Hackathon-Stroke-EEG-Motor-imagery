# IEEE SMC BR41N.IO Hackathon: Motor imagery for motor rehabilitation of stroke patients
The following project is part of the IEEE SMC BR41N.IO Designers' Hackathon organized by Gtec medical engineering. In this project, the idea is to decode left and hand movement through motor imagery using EEG data for stroke rehabilitation purposes.

# Paradigm
Patients wore EEG caps with 16 active electrodes. EEG electrode positions were FC5, FC1, FCz, FC2, FC6, C5, C3, C1, Cz, C2, C4, C6, CP5, CP1, CP2, and CP6 according to the international 10/20 system and the following figure.
<p align="center">
    <img width="400" src="https://github.com/MariaGoniIba/BR41N.IO-Hackathon-Stroke-EEG-Motor-imagery/blob/main/montage_rX.png">
</p>

All participants were instructed to imagine the dorsiflexion wrist movement according to the system indications. This mental task is called Motor Imagery (MI). The Brain Computer Interface (BCI) treatment consists of 25 BCI sessions. We are provided with data from 3 participants first (PRE) and last (POST) BCI session. Each session lasts 1h at a time and is made up by a TRAINING and TEST run (i.e., recording). The instruction by the BCI whether the patient should imagine a left or right hand movement is provided 2 sec after the trigger. And the trigger can be 1(left) or -1(right). 

<p align="center">
    <img width="600" src="https://github.com/MariaGoniIba/BR41N.IO-Hackathon-Stroke-EEG-Motor-imagery/blob/main/Paradigm.png">
</p>

The aim is to distinguish the intention to move the right or left hand using the EEG recordings during the BCI intervention.

# Steps
Data was filtered with a 4th order band pass filter and averaged to a common reference. We selected trials of 1.5 seconds starting at 3.5 seconds after the trigger. A set of temporal and frequencial features were extracted. Classifiers include a Random Forest and a linear SVM.

# Results
<p align="center">
    <img width="800" src="https://github.com/MariaGoniIba/BR41N.IO-Hackathon-Stroke-EEG-Motor-imagery/blob/main/Results.png">
</p>

# Papers
* [Brain Computer Interface Treatment for Motor Rehabilitation of Upper Extremity of Stroke Patients — A Feasibility Study](https://www.frontiersin.org/articles/10.3389/fnins.2020.591435/full)
