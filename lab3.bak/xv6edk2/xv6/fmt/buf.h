4050 struct buf {
4051   int flags;
4052   uint dev;
4053   uint blockno;
4054   struct sleeplock lock;
4055   uint refcnt;
4056   struct buf *prev; // LRU cache list
4057   struct buf *next;
4058   struct buf *qnext; // disk queue
4059   uchar data[BSIZE];
4060 };
4061 #define B_VALID 0x2  // buffer has been read from disk
4062 #define B_DIRTY 0x4  // buffer needs to be written to disk
4063 
4064 
4065 
4066 
4067 
4068 
4069 
4070 
4071 
4072 
4073 
4074 
4075 
4076 
4077 
4078 
4079 
4080 
4081 
4082 
4083 
4084 
4085 
4086 
4087 
4088 
4089 
4090 
4091 
4092 
4093 
4094 
4095 
4096 
4097 
4098 
4099 
