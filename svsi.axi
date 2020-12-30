(**********************************************************************************************************************************************************************************)
PROGRAM_NAME = 'svsi'

#define svsi 1

#warn 'svsi'

(**********************************************************************************************************************************************************************************)
DEFINE_CONSTANT

integer PORT_SVSI        = 50002;
integer PORT_SVSI_SERIAL = 50004;

(**********************************************************************************************************************************************************************************)
/* DEFINE_FUNCTION */

define_function svsiSend(dev socket, char msg[])                { 
    send_string socket, "msg, $0D";                
}
define_function svsiGetStatus(dev socket)                       { 
    svsiSend(socket, '?');                         
}
define_function svsiSetLive(dev socket)                         { 
    svsiSend(socket, 'live');                      
}
define_function svsiSetLocalPlay(dev socket, integer localplay) { 
    svsiSend(socket, "'local:', itoa(localplay)"); 
}
define_function svsiSetCh(dev socket, integer stream)           {
    if (stream != 0) { 
        svsiSetLive(socket); svsiSend(socket, "'set:', itoa(stream)"); 
    } else { 
        svsiSetLocalPlay(socket, 1);
    }
}
define_function svsiSetAudioCh(dev socket, integer stream)      { 
    svsiSend(socket, "'seta:', itoa(stream)");     
}
define_function svsiSendIrRaw(integer socket, char irraw[])     { 
    svsiSend(socket, irraw);                       
}

(**********************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************)
