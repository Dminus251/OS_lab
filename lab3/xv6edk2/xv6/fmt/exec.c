6800 #include "types.h"
6801 #include "param.h"
6802 #include "memlayout.h"
6803 #include "mmu.h"
6804 #include "proc.h"
6805 #include "defs.h"
6806 #include "x86.h"
6807 #include "elf.h"
6808 
6809 int
6810 exec(char *path, char **argv)
6811 {
6812   char *s, *last;
6813   int i, off;
6814   uint argc, sz, sp, ustack[3+MAXARG+1];
6815   struct elfhdr elf;
6816   struct inode *ip;
6817   struct proghdr ph;
6818   pde_t *pgdir, *oldpgdir;
6819   struct proc *curproc = myproc();
6820 
6821   begin_op();
6822 
6823   if((ip = namei(path)) == 0){
6824     end_op();
6825     cprintf("exec: fail\n");
6826     return -1;
6827   }
6828   ilock(ip);
6829   pgdir = 0;
6830 
6831   // Check ELF header
6832   if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
6833     goto bad;
6834   if(elf.magic != ELF_MAGIC)
6835     goto bad;
6836 
6837   if((pgdir = setupkvm()) == 0)
6838     goto bad;
6839 
6840   // Load program into memory.
6841   sz = 0;
6842   for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
6843     if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
6844       goto bad;
6845     if(ph.type != ELF_PROG_LOAD)
6846       continue;
6847     if(ph.memsz < ph.filesz)
6848       goto bad;
6849     if(ph.vaddr + ph.memsz < ph.vaddr)
6850       goto bad;
6851     if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
6852       goto bad;
6853     if(ph.vaddr % PGSIZE != 0)
6854       goto bad;
6855     if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
6856       goto bad;
6857   }
6858   iunlockput(ip);
6859   end_op();
6860   ip = 0;
6861 
6862   // Allocate two pages at the next page boundary.
6863   // Make the first inaccessible.  Use the second as the user stack.
6864   sz = PGROUNDUP(sz);
6865   if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
6866     goto bad;
6867   clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
6868   sp = sz;
6869 
6870   // Push argument strings, prepare rest of stack in ustack.
6871   for(argc = 0; argv[argc]; argc++) {
6872     if(argc >= MAXARG)
6873       goto bad;
6874     sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
6875     if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
6876       goto bad;
6877     ustack[3+argc] = sp;
6878   }
6879   ustack[3+argc] = 0;
6880 
6881   ustack[0] = 0xffffffff;  // fake return PC
6882   ustack[1] = argc;
6883   ustack[2] = sp - (argc+1)*4;  // argv pointer
6884 
6885   sp -= (3+argc+1) * 4;
6886   if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
6887     goto bad;
6888 
6889   // Save program name for debugging.
6890   for(last=s=path; *s; s++)
6891     if(*s == '/')
6892       last = s+1;
6893   safestrcpy(curproc->name, last, sizeof(curproc->name));
6894 
6895   // Commit to the user image.
6896   oldpgdir = curproc->pgdir;
6897   curproc->pgdir = pgdir;
6898   curproc->sz = sz;
6899   curproc->tf->eip = elf.entry;  // main
6900   curproc->tf->esp = sp;
6901   switchuvm(curproc);
6902   freevm(oldpgdir);
6903   return 0;
6904 
6905  bad:
6906   if(pgdir)
6907     freevm(pgdir);
6908   if(ip){
6909     iunlockput(ip);
6910     end_op();
6911   }
6912   return -1;
6913 }
6914 
6915 
6916 
6917 
6918 
6919 
6920 
6921 
6922 
6923 
6924 
6925 
6926 
6927 
6928 
6929 
6930 
6931 
6932 
6933 
6934 
6935 
6936 
6937 
6938 
6939 
6940 
6941 
6942 
6943 
6944 
6945 
6946 
6947 
6948 
6949 
