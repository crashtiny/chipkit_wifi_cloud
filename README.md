About chipkit_Wifi_cloud
========================================
This project is an simple example of using a chipKIT uC32 board equipped with DIGILENT WiFi Shield to send and receive data to/from the Exosite cloud. The example chipkit_wifi_cloud code reads "ONOFF" data from the cloud, report "PING" back to the cloud if read result is not 0.

License is BSD, Copyright 2013, Exosite LLC (see LICENSE file)

Tested with MPIDE-0023

========================================
Quick Start
========================================
1. Download the chipKIT development environment

  ** http://chipkit.net/started/install-chipkit-software/install-mpide-windows/

2. Download the network shield library and reference documents from

 ** http://www.digilentinc.com/Products/Detail.cfm?NavPath=2,892,1037&Prod=CHIPKIT-WIFI-SHIELD

3. Extract MPIDE into the folder you select

4. Start MPIDE, then look under File->Preferences and take note of your Sketchbook Location

5. Shutdown MPIDE, under your Sketchbook directory create a subdirectory called "libraries"; this directory may already exist.

6. Unzip the ChipKITNetworkShield in the libraries directory.

7. Download the chipkit_wifi_cloud project from the repo and new a folder "Exosite" under the "libraries" then unzip files into the Exosite folder

8. Start MPIDE, then open "File->Examples->Exosite->chipkit_wifi_cloud"

9. Edit the "WiFi SSID" and select the security type 

10. Fill the passphase under the security type you use

11. Edit the "PUTYOURCIKHERE" value in cloud.cpp to match your CIK value

  ** HINT: Obtain a CIK by signing up for a free account at https://portals.exosite.com. After activating your account, login and navigate to https://portals.exosite.com/manage/devices and click the +Add Device link

12. In Portals (https://portals.exosite.com), add two Data Sources to match the data resources (aliases) the code is using

  ** HINT: Go to https://portals.exosite.com/manage/data and click +Add Data Source

  ** HINT: Ensure the "Resource:" values are set to "ping" and "onoff" respectively to match the code

  ** HINT: Add an "On/Off Switch" widget to your dashboard to control data source "onoff"

13. Go to "Tools->Board" to select the corresponding chipKIT board type

14. In the MPIDE software, compile and verify there are no errors

15. Connect the board. Go to "Tools->Serial Port" to select the serial port your board is connected to

16. Go to File->Upload to I/O Board to upload the program

17. When "Done uploading" is displayed, go to https://portals.exosite.com to see your data in the cloud!

  ** You can set "onoff" value from widget to control data reporting

========================================
Release Info
========================================
* **Release 2013-08-14**
    - initial version
