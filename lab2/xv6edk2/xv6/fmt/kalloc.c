3250 // Physical memory allocator, intended to allocate
3251 // memory for user processes, kernel stacks, page table pages,
3252 // and pipe buffers. Allocates 4096-byte pages.
3253 
3254 #include "types.h"
3255 #include "defs.h"
3256 #include "param.h"
3257 #include "memlayout.h"
3258 #include "mmu.h"
3259 #include "spinlock.h"
3260 
3261 void freerange(void *vstart, void *vend);
3262 extern char end[]; // first address after kernel loaded from ELF file
3263                    // defined by the kernel linker script in kernel.ld
3264 
3265 struct run {
3266   struct run *next;
3267 };
3268 
3269 struct {
3270   struct spinlock lock;
3271   int use_lock;
3272   struct run *freelist;
3273 } kmem;
3274 
3275 // Initialization happens in two phases.
3276 // 1. main() calls kinit1() while still using entrypgdir to place just
3277 // the pages mapped by entrypgdir on free list.
3278 // 2. main() calls kinit2() with the rest of the physical pages
3279 // after installing a full page table that maps them on all cores.
3280 void
3281 kinit1(void *vstart, void *vend)
3282 {
3283   initlock(&kmem.lock, "kmem");
3284   kmem.use_lock = 0;
3285   freerange(vstart, vend);
3286 }
3287 
3288 void
3289 kinit2(void *vstart, void *vend)
3290 {
3291   freerange(vstart, vend);
3292   kmem.use_lock = 1;
3293 }
3294 
3295 
3296 
3297 
3298 
3299 
3300 void
3301 freerange(void *vstart, void *vend)
3302 {
3303   char *p;
3304   p = (char*)PGROUNDUP((uint)vstart);
3305   for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
3306     kfree(p);
3307 }
3308 
3309 // Free the page of physical memory pointed at by v,
3310 // which normally should have been returned by a
3311 // call to kalloc().  (The exception is when
3312 // initializing the allocator; see kinit above.)
3313 void
3314 kfree(char *v)
3315 {
3316   struct run *r;
3317 
3318   if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
3319     panic("kfree");
3320 
3321   // Fill with junk to catch dangling refs.
3322   memset(v, 1, PGSIZE);
3323 
3324   if(kmem.use_lock)
3325     acquire(&kmem.lock);
3326   r = (struct run*)v;
3327   r->next = kmem.freelist;
3328   kmem.freelist = r;
3329   if(kmem.use_lock)
3330     release(&kmem.lock);
3331 }
3332 
3333 // Allocate one 4096-byte page of physical memory.
3334 // Returns a pointer that the kernel can use.
3335 // Returns 0 if the memory cannot be allocated.
3336 char*
3337 kalloc(void)
3338 {
3339   struct run *r;
3340 
3341   if(kmem.use_lock)
3342     acquire(&kmem.lock);
3343   r = kmem.freelist;
3344   if(r)
3345     kmem.freelist = r->next;
3346   if(kmem.use_lock)
3347     release(&kmem.lock);
3348   return (char*)r;
3349 }
