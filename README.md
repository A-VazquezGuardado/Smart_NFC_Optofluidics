[![DOI](https://zenodo.org/badge/390094581.svg)](https://zenodo.org/badge/latestdoi/390094581)


# Smart NFC Optofluidics

This repository contains a generated data from the optofluidics project. 
It also includes a stand-alone graphic user interface (GUI) implemented in MATLAB (The MathWorks Inc) to the control of the NFC devices in in-vivo behavioral experiments. 


## System requirements:

The GUI included in this repository uses serial connection with the LRM2500-A(B) NFC reader (Feig Electronics Inc), and offers an intuitive interface to provide configuration/operation access to indiviidual implantable devices. 

- This GUI runs in MATLAB 2017a and newer versions in both Mac and Windows operating systems.
- No additional toolboxes or libraries are needed to run this GUI.
- MATLAB and the NFC reader are connected via RS232 serial interface and requires a RS232 to USB adapter. Commercial systems such as those provided by NeuroLux Inc are self-contained hardware that do not require any additional adapter.

## Installation instructions:

- This GUI does not require installation. However, MATLAB must be installed prior to utilizing this software.
- Download the .m and .fig files and store them in a local folder.

## Operation:

- Connect the NFC reader or NeuroLux PDC box.
- Open the .m file in MATLAB and hit the run button to open the GUI.
- Select the serial port to establish communication with the hardware.

Detailed operation modes, such as configuration and operation of the devices, are described in the manuscript.

