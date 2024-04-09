7900 // PC keyboard interface constants
7901 
7902 #define KBSTATP         0x64    // kbd controller status port(I)
7903 #define KBS_DIB         0x01    // kbd data in buffer
7904 #define KBDATAP         0x60    // kbd data port(I)
7905 
7906 #define NO              0
7907 
7908 #define SHIFT           (1<<0)
7909 #define CTL             (1<<1)
7910 #define ALT             (1<<2)
7911 
7912 #define CAPSLOCK        (1<<3)
7913 #define NUMLOCK         (1<<4)
7914 #define SCROLLLOCK      (1<<5)
7915 
7916 #define E0ESC           (1<<6)
7917 
7918 // Special keycodes
7919 #define KEY_HOME        0xE0
7920 #define KEY_END         0xE1
7921 #define KEY_UP          0xE2
7922 #define KEY_DN          0xE3
7923 #define KEY_LF          0xE4
7924 #define KEY_RT          0xE5
7925 #define KEY_PGUP        0xE6
7926 #define KEY_PGDN        0xE7
7927 #define KEY_INS         0xE8
7928 #define KEY_DEL         0xE9
7929 
7930 // C('A') == Control-A
7931 #define C(x) (x - '@')
7932 
7933 static uchar shiftcode[256] =
7934 {
7935   [0x1D] CTL,
7936   [0x2A] SHIFT,
7937   [0x36] SHIFT,
7938   [0x38] ALT,
7939   [0x9D] CTL,
7940   [0xB8] ALT
7941 };
7942 
7943 static uchar togglecode[256] =
7944 {
7945   [0x3A] CAPSLOCK,
7946   [0x45] NUMLOCK,
7947   [0x46] SCROLLLOCK
7948 };
7949 
7950 static uchar normalmap[256] =
7951 {
7952   NO,   0x1B, '1',  '2',  '3',  '4',  '5',  '6',  // 0x00
7953   '7',  '8',  '9',  '0',  '-',  '=',  '\b', '\t',
7954   'q',  'w',  'e',  'r',  't',  'y',  'u',  'i',  // 0x10
7955   'o',  'p',  '[',  ']',  '\n', NO,   'a',  's',
7956   'd',  'f',  'g',  'h',  'j',  'k',  'l',  ';',  // 0x20
7957   '\'', '`',  NO,   '\\', 'z',  'x',  'c',  'v',
7958   'b',  'n',  'm',  ',',  '.',  '/',  NO,   '*',  // 0x30
7959   NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
7960   NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',  // 0x40
7961   '8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
7962   '2',  '3',  '0',  '.',  NO,   NO,   NO,   NO,   // 0x50
7963   [0x9C] '\n',      // KP_Enter
7964   [0xB5] '/',       // KP_Div
7965   [0xC8] KEY_UP,    [0xD0] KEY_DN,
7966   [0xC9] KEY_PGUP,  [0xD1] KEY_PGDN,
7967   [0xCB] KEY_LF,    [0xCD] KEY_RT,
7968   [0x97] KEY_HOME,  [0xCF] KEY_END,
7969   [0xD2] KEY_INS,   [0xD3] KEY_DEL
7970 };
7971 
7972 static uchar shiftmap[256] =
7973 {
7974   NO,   033,  '!',  '@',  '#',  '$',  '%',  '^',  // 0x00
7975   '&',  '*',  '(',  ')',  '_',  '+',  '\b', '\t',
7976   'Q',  'W',  'E',  'R',  'T',  'Y',  'U',  'I',  // 0x10
7977   'O',  'P',  '{',  '}',  '\n', NO,   'A',  'S',
7978   'D',  'F',  'G',  'H',  'J',  'K',  'L',  ':',  // 0x20
7979   '"',  '~',  NO,   '|',  'Z',  'X',  'C',  'V',
7980   'B',  'N',  'M',  '<',  '>',  '?',  NO,   '*',  // 0x30
7981   NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
7982   NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',  // 0x40
7983   '8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
7984   '2',  '3',  '0',  '.',  NO,   NO,   NO,   NO,   // 0x50
7985   [0x9C] '\n',      // KP_Enter
7986   [0xB5] '/',       // KP_Div
7987   [0xC8] KEY_UP,    [0xD0] KEY_DN,
7988   [0xC9] KEY_PGUP,  [0xD1] KEY_PGDN,
7989   [0xCB] KEY_LF,    [0xCD] KEY_RT,
7990   [0x97] KEY_HOME,  [0xCF] KEY_END,
7991   [0xD2] KEY_INS,   [0xD3] KEY_DEL
7992 };
7993 
7994 
7995 
7996 
7997 
7998 
7999 
8000 static uchar ctlmap[256] =
8001 {
8002   NO,      NO,      NO,      NO,      NO,      NO,      NO,      NO,
8003   NO,      NO,      NO,      NO,      NO,      NO,      NO,      NO,
8004   C('Q'),  C('W'),  C('E'),  C('R'),  C('T'),  C('Y'),  C('U'),  C('I'),
8005   C('O'),  C('P'),  NO,      NO,      '\r',    NO,      C('A'),  C('S'),
8006   C('D'),  C('F'),  C('G'),  C('H'),  C('J'),  C('K'),  C('L'),  NO,
8007   NO,      NO,      NO,      C('\\'), C('Z'),  C('X'),  C('C'),  C('V'),
8008   C('B'),  C('N'),  C('M'),  NO,      NO,      C('/'),  NO,      NO,
8009   [0x9C] '\r',      // KP_Enter
8010   [0xB5] C('/'),    // KP_Div
8011   [0xC8] KEY_UP,    [0xD0] KEY_DN,
8012   [0xC9] KEY_PGUP,  [0xD1] KEY_PGDN,
8013   [0xCB] KEY_LF,    [0xCD] KEY_RT,
8014   [0x97] KEY_HOME,  [0xCF] KEY_END,
8015   [0xD2] KEY_INS,   [0xD3] KEY_DEL
8016 };
8017 
8018 
8019 
8020 
8021 
8022 
8023 
8024 
8025 
8026 
8027 
8028 
8029 
8030 
8031 
8032 
8033 
8034 
8035 
8036 
8037 
8038 
8039 
8040 
8041 
8042 
8043 
8044 
8045 
8046 
8047 
8048 
8049 
