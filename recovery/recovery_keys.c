#include <linux/input.h>

#include "recovery_ui.h"
#include "common.h"
#include "extendedcommands.h"

int device_toggle_display(volatile char* key_pressed, int key_code) {
    return key_pressed[139] && key_pressed[KEY_VOLUMEUP];
}

int device_handle_key(int key_code, int visible) {
    if (visible) {
        switch (key_code) {
            case KEY_VOLUMEDOWN:
            case 139: // MENU
                return HIGHLIGHT_DOWN;

            case KEY_VOLUMEUP:
                return HIGHLIGHT_UP;

            case KEY_POWER:
            case 102: // HOME
                return SELECT_ITEM;
                
            case 158: // BACK
                    return GO_BACK;

            default:
                return NO_ACTION;
        }
    }

    return NO_ACTION;
}
