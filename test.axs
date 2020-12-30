(**********************************************************************************************************************************************************************************)
PROGRAM_NAME='test'

(**********************************************************************************************************************************************************************************)
/* INCLUDES */

#include 'svsi'

(**********************************************************************************************************************************************************************************)
DEFINE_DEVICE

TP     = 10001:001:000;
DEC_01 = 00000:002:000;
DEC_02 = 00000:003:000;
DEC_03 = 00000:004:000;

(**********************************************************************************************************************************************************************************)
DEFINE_VARIABLE

constant integer NUM_OF_DEC = 3

constant char IP_DEC[NUM_OF_DEC][15] = {
    {'192.168.1.61'},
    {'192.168.1.62'},
    {'192.168.1.63'}
};

constant dev DEC[NUM_OF_DEC] = { DEC_01, DEC_02, DEC_03 };

volatile integer decOnlineStatus[NUM_OF_DEC];
volatile integer decCurrentVidCh[NUM_OF_DEC];
volatile integer decCurrentAudCh[NUM_OF_DEC];
volatile integer decCurrntPlayMode[NUM_OF_DEC];
volatile integer decCurrentPlaylistCh[NUM_OF_DEC];

constant integer STREAM_NO[4] = { 101, 102, 103, 104 };

(**********************************************************************************************************************************************************************************)
/* DEFINE_MODULE */

define_module 'svsi_dec_response' dec01(DEC[1], IP_DEC[1], decOnlineStatus[1], decCurrentVidCh[1], decCurrentAudCh[1], decCurrntPlayMode[1], decCurrentPlaylistCh[1])
define_module 'svsi_dec_response' dec02(DEC[2], IP_DEC[2], decOnlineStatus[2], decCurrentVidCh[2], decCurrentAudCh[2], decCurrntPlayMode[2], decCurrentPlaylistCh[2])
define_module 'svsi_dec_response' dec03(DEC[3], IP_DEC[3], decOnlineStatus[3], decCurrentVidCh[3], decCurrentAudCh[3], decCurrntPlayMode[3], decCurrentPlaylistCh[3])

(**********************************************************************************************************************************************************************************)
DEFINE_EVENT

button_event[TP, 1] {
    push: {
        svsiSetCh(DEC[1], 11);
        svsiSetCh(DEC[2], 12);
        svsiSetCh(DEC[3], 13);
    }
}

button_event[TP, 2] {
    push: {
        svsiSetCh(DEC[1], STREAM_NO[1]);
        svsiSetCh(DEC[2], STREAM_NO[2]);
        svsiSetCh(DEC[3], STREAM_NO[3]);
    }
}

button_event[TP, 3] {
    push: {
        svsiGetStatus(DEC[1]);
        svsiGetStatus(DEC[2]);
        svsiGetStatus(DEC[3]);
    }
}

(**********************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************)