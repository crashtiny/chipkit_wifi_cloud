//*****************************************************************************
//
// chipkit_wifi_cloud.pde - Simple read/write sample using the Exosite Cloud API
//
// Copyright (c) 2013 Exosite LLC.  All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright 
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//  * Neither the name of Exosite LLC nor the names of its contributors may
//    be used to endorse or promote products derived from this software 
//    without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED "AS IS" AND WITH ALL FAULTS.
// NO WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT
// NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE. TI SHALL NOT, UNDER ANY
// CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
// DAMAGES, FOR ANY REASON WHATSOEVER.
//
//*****************************************************************************


/************************************************************************/
/*                                                                      */
/*                                                                      */
/************************************************************************/
/*  Revision History:                                                   */
/*                                                                      */
/*    08/11/2013: Created                                               */
/*                                                                      */
/************************************************************************/


/************************************************************************/

//************************************************************************
//************************************************************************
//***************************** SET YOUR CONFIGURATION *******************
//************************************************************************
//************************************************************************

/************************************************************************/
/*                                                                      */
/*              Include ONLY 1 hardware library that matches            */
/*              the network hardware you are using                      */
/*                                                                      */
/*              Refer to the hardware library header file               */
/*              for supported boards and hardware configurations        */
/*                                                                      */
/************************************************************************/
// #include <WiFiShieldOrPmodWiFi.h>                       // This is for the MRF24WBxx on a pmodWiFi or WiFiShield
#include <WiFiShieldOrPmodWiFi_G.h>                     // This is for the MRF24WGxx on a pmodWiFi or WiFiShield

/************************************************************************/
/*                    Required libraries, Do NOT comment out            */
/************************************************************************/
#include <DNETcK.h>
#include <DWIFIcK.h>
#include "Exosite.h"

/************************************************************************/
/*                                                                      */
/*              SET THESE VALUES FOR YOUR NETWORK                       */
/*                                                                      */
/************************************************************************/

// Specify the SSID
const char * szSsid = "WiFi SSID";                // <-- Fill in your WiFi AP SSID here!

// select 1 for the security you want, or none for no security
#define USE_WPA2_PASSPHRASE
//#define USE_WPA2_KEY
//#define USE_WEP40
//#define USE_WEP104
//#define USE_WF_CONFIG_H

// modify the security key to what you have.
#if defined(USE_WPA2_PASSPHRASE)
    const char * szPassPhrase = "PASSPHASE";  // <-- Fill in your WiFi AP passphase here!
    #define WiFiConnectMacro() DWIFIcK::connect(szSsid, szPassPhrase, &status)

#elif defined(USE_WPA2_KEY)

    DWIFIcK::WPA2KEY key = { 0x27, 0x2C, 0x89, 0xCC, 0xE9, 0x56, 0x31, 0x1E, 
                            0x3B, 0xAD, 0x79, 0xF7, 0x1D, 0xC4, 0xB9, 0x05, 
                            0x7A, 0x34, 0x4C, 0x3E, 0xB5, 0xFA, 0x38, 0xC2, 
                            0x0F, 0x0A, 0xB0, 0x90, 0xDC, 0x62, 0xAD, 0x58 };
    #define WiFiConnectMacro() DWIFIcK::connect(szSsid, key, &status)

#elif defined(USE_WEP40)

    const int iWEPKey = 0;
    DWIFIcK::WEP40KEY keySet = {    0xBE, 0xC9, 0x58, 0x06, 0x97,     // Key 0
                                    0x00, 0x00, 0x00, 0x00, 0x00,     // Key 1
                                    0x00, 0x00, 0x00, 0x00, 0x00,     // Key 2
                                    0x00, 0x00, 0x00, 0x00, 0x00 };   // Key 3
    #define WiFiConnectMacro() DWIFIcK::connect(szSsid, keySet, iWEPKey, &status)

#elif defined(USE_WEP104)

    const int iWEPKey = 0;
    DWIFIcK::WEP104KEY keySet = {   0x3E, 0xCD, 0x30, 0xB2, 0x55, 0x2D, 0x3C, 0x50, 0x52, 0x71, 0xE8, 0x83, 0x91,   // Key 0
                                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   // Key 1
                                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   // Key 2
                                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }; // Key 3
    #define WiFiConnectMacro() DWIFIcK::connect(szSsid, keySet, iWEPKey, &status)

#elif defined(USE_WF_CONFIG_H)

    #define WiFiConnectMacro() DWIFIcK::connect(0, &status)

#else   // no security - OPEN

    #define WiFiConnectMacro() DWIFIcK::connect(szSsid, &status)

#endif

//*************************************************************************
//*************************************************************************
//***************************** END OF CONFIGURATION **********************
//*************************************************************************
//*************************************************************************

//global variables
#define EXOSITE_SERVER "m2.exosite.com"
String cikData = "PUTYOURCIKHERE";      // <-- Fill in your CIK here! (https://portals.exosite.com -> Add Device)
TcpClient tcpClient;
Exosite exosite;

typedef enum
{
    NONE = 0,
    WRITE,
    READ,
    CLOSE,
    DONE,
} STATE;

STATE state = WRITE;
int ping = 0;


/*==============================================================================
* setup
*
* Arduino setup function.
*=============================================================================*/
void setup()
{
    DNETcK::STATUS status;
    int conID = DWIFIcK::INVALID_CONNECTION_ID;

    Serial.begin(9600);
    Serial.println("chipKIT WiFi Cloud 1.0");
    Serial.println("Exosite LLC, Copyright 2013");
    Serial.println("");

    if((conID = WiFiConnectMacro()) != DWIFIcK::INVALID_CONNECTION_ID)
    {
        Serial.print("Connection Created, ConID = ");
        Serial.println(conID, DEC);
        state = WRITE;
    }
    else
    {
        Serial.print("Unable to connection, status: ");
        Serial.println(status, DEC);
        state = CLOSE;
    }

    // use DHCP to get our IP and network addresses
    DNETcK::begin();

    delay(500);  
    exosite.init(&tcpClient, cikData);
}

/*==============================================================================
* loop 
*
* Arduino loop function.
*=============================================================================*/
void loop()
{
  String retVal;

  tcpClient.connect(EXOSITE_SERVER, 80);

  switch(state)
  {
    case WRITE:
      exosite.sendToCloud("ping", ping++);
      if ( ping >= 100)
        ping = 0;
      state = READ;
      break;
    case READ:
      exosite.readFromCloud("onoff", &retVal);
      Serial.print("Read : ");
      Serial.println(retVal);
      if (retVal.startsWith("0"))
        state = READ;
      else 
        state = WRITE;
      break;
    case CLOSE:
    case DONE:
    default:
      break;
  }
  delay(3000); 
}

