(**********************************************************************************************************************************************************************************)
MODULE_NAME = 'svsi_dec_response'(dev DV_SOCKET, char IP_DV_SOCKET[15], integer isOnline, integer stream_video, integer stream_audio, integer playmode, integer playlist)

#if_not_defined svsi    #include 'svsi'    #end_if

#warn 'svsi_dec_response'

(**********************************************************************************************************************************************************************************)
DEFINE_VARIABLE

(**********************************************************************************************************************************************************************************)
/* DEFINE_FUNCTION */

define_function svsiConnect()    { ip_client_open(DV_SOCKET.PORT, IP_DV_SOCKET, PORT_SVSI, IP_TCP); }
define_function svsiDisconnect() { ip_client_close(DV_SOCKET.PORT); }

define_function svsiParseDecMessage(char msg[]) {
    
    char    text[2000], temp[100], key_arr[100][100], val_arr[100][100];
    integer i, j;
    
    text = msg;
    i    = 1;
    
    while (find_string(text, "$0D", 1) && i < 99) {
        temp = remove_string(text, "$0D", 1);
        key_arr[i] = remove_string(temp, ':', 1);
        val_arr[i] = temp;
        key_arr[i] = left_string(key_arr[i], length_array(key_arr[i]) - 1);
        val_arr[i] = left_string(val_arr[i], length_array(val_arr[i]) - 1);
        i++;
    }
    
    for (j = 1; j <= length_array(key_arr); j++) {
        switch (key_arr[j]) {
            case 'IP': {
                if (val_arr[j] != IP_DV_SOCKET) { 
                    send_string 0, "'svsiParseDecMessage() -- ip not match'";
                    return; 
                }
            }
            case 'STREAM': {
                stream_video = atoi(val_arr[j]);
            }
            case 'STREAMAUDIO': {
                stream_audio = atoi(val_arr[j]);
                if (stream_audio == 0) {
                    stream_audio = stream_video
                }
            }
            case 'PLAYMODE': {
                playmode = (val_arr[j] == 'live');
            }
            case 'PLAYLIST': {
                playlist = atoi(val_arr[j]);
            }
        }
    }
}

(**********************************************************************************************************************************************************************************)
DEFINE_START {
    svsiConnect();
}

(**********************************************************************************************************************************************************************************)
DEFINE_EVENT

data_event[DV_SOCKET] { 
    online:  {
        isOnline = true;  
        svsiGetStatus(data.device); 
    }
    offline: {
        isOnline = false; 
        wait 30 { 
            svsiConnect(); 
        }
    }
    onerror: {
        isOnline = false; 
        if (data.number != 9 && data.number != 17) {
            wait 30 { 
                svsiConnect(); 
            } 
        } 
    }
    string: {
        svsiParseDecMessage(data.text)
    }
}

(**********************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************)
