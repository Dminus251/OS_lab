7250 // See MultiProcessor Specification Version 1.[14]
7251 
7252 struct mp {             // floating pointer
7253   uchar signature[4];           // "_MP_"
7254   void *physaddr;               // phys addr of MP config table
7255   uchar length;                 // 1
7256   uchar specrev;                // [14]
7257   uchar checksum;               // all bytes must add up to 0
7258   uchar type;                   // MP system config type
7259   uchar imcrp;
7260   uchar reserved[3];
7261 };
7262 
7263 struct mpconf {         // configuration table header
7264   uchar signature[4];           // "PCMP"
7265   ushort length;                // total table length
7266   uchar version;                // [14]
7267   uchar checksum;               // all bytes must add up to 0
7268   uchar product[20];            // product id
7269   uint *oemtable;               // OEM table pointer
7270   ushort oemlength;             // OEM table length
7271   ushort entry;                 // entry count
7272   uint *lapicaddr;              // address of local APIC
7273   ushort xlength;               // extended table length
7274   uchar xchecksum;              // extended table checksum
7275   uchar reserved;
7276 };
7277 
7278 struct mpproc {         // processor table entry
7279   uchar type;                   // entry type (0)
7280   uchar apicid;                 // local APIC id
7281   uchar version;                // local APIC verison
7282   uchar flags;                  // CPU flags
7283     #define MPBOOT 0x02           // This proc is the bootstrap processor.
7284   uchar signature[4];           // CPU signature
7285   uint feature;                 // feature flags from CPUID instruction
7286   uchar reserved[8];
7287 };
7288 
7289 struct mpioapic {       // I/O APIC table entry
7290   uchar type;                   // entry type (2)
7291   uchar apicno;                 // I/O APIC id
7292   uchar version;                // I/O APIC version
7293   uchar flags;                  // I/O APIC flags
7294   uint *addr;                  // I/O APIC address
7295 };
7296 
7297 
7298 
7299 
7300 // Table entry types
7301 #define MPPROC    0x00  // One per processor
7302 #define MPBUS     0x01  // One per bus
7303 #define MPIOAPIC  0x02  // One per I/O APIC
7304 #define MPIOINTR  0x03  // One per bus interrupt source
7305 #define MPLINTR   0x04  // One per system interrupt source
7306 
7307 
7308 
7309 
7310 
7311 
7312 
7313 
7314 
7315 
7316 
7317 
7318 
7319 
7320 
7321 
7322 
7323 
7324 
7325 
7326 
7327 
7328 
7329 
7330 
7331 
7332 
7333 
7334 
7335 
7336 
7337 
7338 
7339 
7340 
7341 
7342 
7343 
7344 
7345 
7346 
7347 
7348 
7349 
7350 // Blank page.
7351 
7352 
7353 
7354 
7355 
7356 
7357 
7358 
7359 
7360 
7361 
7362 
7363 
7364 
7365 
7366 
7367 
7368 
7369 
7370 
7371 
7372 
7373 
7374 
7375 
7376 
7377 
7378 
7379 
7380 
7381 
7382 
7383 
7384 
7385 
7386 
7387 
7388 
7389 
7390 
7391 
7392 
7393 
7394 
7395 
7396 
7397 
7398 
7399 
