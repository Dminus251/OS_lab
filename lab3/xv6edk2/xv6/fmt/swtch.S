3200 # Context switch
3201 #
3202 #   void swtch(struct context **old, struct context *new);
3203 #
3204 # Save the current registers on the stack, creating
3205 # a struct context, and save its address in *old.
3206 # Switch stacks to new and pop previously-saved registers.
3207 
3208 .globl swtch
3209 swtch:
3210   movl 4(%esp), %eax
3211   movl 8(%esp), %edx
3212 
3213   # Save old callee-save registers
3214   pushl %ebp
3215   pushl %ebx
3216   pushl %esi
3217   pushl %edi
3218 
3219   # Switch stacks
3220   movl %esp, (%eax)
3221   movl %edx, %esp
3222 
3223   # Load new callee-save registers
3224   popl %edi
3225   popl %esi
3226   popl %ebx
3227   popl %ebp
3228   ret
3229 
3230 
3231 
3232 
3233 
3234 
3235 
3236 
3237 
3238 
3239 
3240 
3241 
3242 
3243 
3244 
3245 
3246 
3247 
3248 
3249 
