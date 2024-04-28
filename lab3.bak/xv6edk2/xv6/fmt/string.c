7100 #include "types.h"
7101 #include "x86.h"
7102 
7103 void*
7104 memset(void *dst, int c, uint n)
7105 {
7106   if ((int)dst%4 == 0 && n%4 == 0){
7107     c &= 0xFF;
7108     stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
7109   } else
7110     stosb(dst, c, n);
7111   return dst;
7112 }
7113 
7114 int
7115 memcmp(const void *v1, const void *v2, uint n)
7116 {
7117   const uchar *s1, *s2;
7118 
7119   s1 = v1;
7120   s2 = v2;
7121   while(n-- > 0){
7122     if(*s1 != *s2)
7123       return *s1 - *s2;
7124     s1++, s2++;
7125   }
7126 
7127   return 0;
7128 }
7129 
7130 void*
7131 memmove(void *dst, const void *src, uint n)
7132 {
7133   const char *s;
7134   char *d;
7135 
7136   s = src;
7137   d = dst;
7138   if(s < d && s + n > d){
7139     s += n;
7140     d += n;
7141     while(n-- > 0)
7142       *--d = *--s;
7143   } else
7144     while(n-- > 0)
7145       *d++ = *s++;
7146 
7147   return dst;
7148 }
7149 
7150 // memcpy exists to placate GCC.  Use memmove.
7151 void*
7152 memcpy(void *dst, const void *src, uint n)
7153 {
7154   return memmove(dst, src, n);
7155 }
7156 
7157 int
7158 strncmp(const char *p, const char *q, uint n)
7159 {
7160   while(n > 0 && *p && *p == *q)
7161     n--, p++, q++;
7162   if(n == 0)
7163     return 0;
7164   return (uchar)*p - (uchar)*q;
7165 }
7166 
7167 char*
7168 strncpy(char *s, const char *t, int n)
7169 {
7170   char *os;
7171 
7172   os = s;
7173   while(n-- > 0 && (*s++ = *t++) != 0)
7174     ;
7175   while(n-- > 0)
7176     *s++ = 0;
7177   return os;
7178 }
7179 
7180 // Like strncpy but guaranteed to NUL-terminate.
7181 char*
7182 safestrcpy(char *s, const char *t, int n)
7183 {
7184   char *os;
7185 
7186   os = s;
7187   if(n <= 0)
7188     return os;
7189   while(--n > 0 && (*s++ = *t++) != 0)
7190     ;
7191   *s = 0;
7192   return os;
7193 }
7194 
7195 
7196 
7197 
7198 
7199 
7200 int
7201 strlen(const char *s)
7202 {
7203   int n;
7204 
7205   for(n = 0; s[n]; n++)
7206     ;
7207   return n;
7208 }
7209 
7210 
7211 
7212 
7213 
7214 
7215 
7216 
7217 
7218 
7219 
7220 
7221 
7222 
7223 
7224 
7225 
7226 
7227 
7228 
7229 
7230 
7231 
7232 
7233 
7234 
7235 
7236 
7237 
7238 
7239 
7240 
7241 
7242 
7243 
7244 
7245 
7246 
7247 
7248 
7249 
