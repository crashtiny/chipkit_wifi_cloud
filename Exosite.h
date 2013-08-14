//*****************************************************************************
//
// exosite.h - Prototypes for the Exosite Cloud API
//
// Copyright (c) 2013 Exosite LLC.  All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:

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

#ifndef Exosite_h
#define Exosite_h

#include <DNETcK.h>
#include <DWIFIcK.h>

class Exosite
{
  private:
    class TcpClient* client; // Port 80 is default for HTTP
    String cik;
    char rxdata[500];
    int ret;
    int stringPos;
    int rxlength;
    boolean DataRx;
    boolean RxLoop;
    char c;
    unsigned long timeout_time;
    unsigned long time_now;
    unsigned long timeout;
    String myDataString;


  public:
    Exosite(void);  //constructor
    void init(TcpClient *clt, String _cik);
    int sendToCloud(String res, int value);
    int readFromCloud(String res ,String* pResult);

};

#endif

