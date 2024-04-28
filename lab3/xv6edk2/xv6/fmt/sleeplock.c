4800 // Sleeping locks
4801 
4802 #include "types.h"
4803 #include "defs.h"
4804 #include "param.h"
4805 #include "x86.h"
4806 #include "memlayout.h"
4807 #include "mmu.h"
4808 #include "proc.h"
4809 #include "spinlock.h"
4810 #include "sleeplock.h"
4811 
4812 void
4813 initsleeplock(struct sleeplock *lk, char *name)
4814 {
4815   initlock(&lk->lk, "sleep lock");
4816   lk->name = name;
4817   lk->locked = 0;
4818   lk->pid = 0;
4819 }
4820 
4821 void
4822 acquiresleep(struct sleeplock *lk)
4823 {
4824   acquire(&lk->lk);
4825   while (lk->locked) {
4826     sleep(lk, &lk->lk);
4827   }
4828   lk->locked = 1;
4829   lk->pid = myproc()->pid;
4830   release(&lk->lk);
4831 }
4832 
4833 void
4834 releasesleep(struct sleeplock *lk)
4835 {
4836   acquire(&lk->lk);
4837   lk->locked = 0;
4838   lk->pid = 0;
4839   wakeup(lk);
4840   release(&lk->lk);
4841 }
4842 
4843 
4844 
4845 
4846 
4847 
4848 
4849 
4850 int
4851 holdingsleep(struct sleeplock *lk)
4852 {
4853   int r;
4854 
4855   acquire(&lk->lk);
4856   r = lk->locked;
4857   release(&lk->lk);
4858   return r;
4859 }
4860 
4861 
4862 
4863 
4864 
4865 
4866 
4867 
4868 
4869 
4870 
4871 
4872 
4873 
4874 
4875 
4876 
4877 
4878 
4879 
4880 
4881 
4882 
4883 
4884 
4885 
4886 
4887 
4888 
4889 
4890 
4891 
4892 
4893 
4894 
4895 
4896 
4897 
4898 
4899 
