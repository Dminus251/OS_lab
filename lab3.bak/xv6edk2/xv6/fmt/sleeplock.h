4100 // Long-term locks for processes
4101 struct sleeplock {
4102   uint locked;       // Is the lock held?
4103   struct spinlock lk; // spinlock protecting this sleep lock
4104 
4105   // For debugging:
4106   char *name;        // Name of lock.
4107   int pid;           // Process holding lock
4108 };
4109 
4110 
4111 
4112 
4113 
4114 
4115 
4116 
4117 
4118 
4119 
4120 
4121 
4122 
4123 
4124 
4125 
4126 
4127 
4128 
4129 
4130 
4131 
4132 
4133 
4134 
4135 
4136 
4137 
4138 
4139 
4140 
4141 
4142 
4143 
4144 
4145 
4146 
4147 
4148 
4149 
