// GPLv2

#define NULL	(void *)0

#define BITS_PER_LONG	64 /* TODO */
#define HZ		250

#define EINVAL		22

#define BIT_MASK(nr)	(1UL << ((nr) % BITS_PER_LONG))
#define BIT_WORD(nr)	((nr) / BITS_PER_LONG)
#define BITOP_WORD(nr)	((nr) / BITS_PER_LONG)

typedef unsigned short __u16;
typedef unsigned int __u32;
#if BITS_PER_LONG == 32
#error TODO
#else
typedef unsigned long __u64;
typedef unsigned long size_t;
#endif
typedef unsigned gfp_t;

int param_array_get() {return 0;}
void param_array_set() {}
int param_get_int() {return 0;}
short param_get_short() {return 0;}
void param_set_int() {}
void param_set_short() {}

int memcmp(const void *cs, const void *ct, size_t count)
{
	const unsigned char *su1, *su2;
	int res = 0;

	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
		if ((res = *su1 - *su2) != 0)
			break;
	return res;
}

void *memcpy(void *dest, const void *src, size_t count)
{
	char *tmp = dest;
	const char *s = src;

	while (count--)
		*tmp++ = *s++;
	return dest;
}

size_t strlen(const char *s)
{
	const char *sc;

	for (sc = s; *sc != '\0'; ++sc)
		/* nothing */;
	return sc - s;
}

int strcmp(const char *cs, const char *ct)
{
	signed char __res;

	while (1) {
		if ((__res = *cs - *ct++) != 0 || !*cs++)
			break;
	}
	return __res;
}

int strncmp(const char *cs, const char *ct, size_t count)
{
	signed char __res = 0;

	while (count) {
		if ((__res = *cs - *ct++) != 0 || !*cs++)
			break;
		count--;
	}
	return __res;
}

char *strchr(const char *s, int c)
{
	for (; *s != (char)c; ++s)
		if (*s == '\0')
			return NULL;
	return (char *)s;
}

char *strcpy(char *dest, const char *src)
{
	char *tmp = dest;

	while ((*dest++ = *src++) != '\0')
		/* nothing */;
	return tmp;
}

char *strncpy(char *dest, const char *src, size_t count)
{
	char *tmp = dest;

	while (count) {
		if ((*tmp = *src) != 0)
			src++;
		tmp++;
		count--;
	}
	return dest;
}

size_t strlcpy(char *dest, const char *src, size_t size)
{
	size_t ret = strlen(src);

	if (size) {
		size_t len = (ret >= size) ? size - 1 : ret;
		memcpy(dest, src, len);
		dest[len] = '\0';
	}
	return ret;
}

char *strcat(char *dest, const char *src)
{
	char *tmp = dest;

	while (*dest)
		dest++;
	while ((*dest++ = *src++) != '\0')
		;
	return tmp;
}

unsigned long long simple_strtoull(const char *cp, char **endp,
		unsigned int base)
{
	/* TODO */
	if (endp)
		*endp = (char *)cp;
	return 0;
}

unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
{
	return simple_strtoull(cp, endp, base);
}

int strict_strtoul(const char *cp, unsigned int base, unsigned long *res)
{
	char *tail;
	unsigned long val;
	size_t len;

	*res = 0;
	len = strlen(cp);
	if (len == 0)
		return -EINVAL;

	val = simple_strtoul(cp, &tail, base);
	if ((*tail == '\0') ||
		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
		*res = val;
		return 0;
	}

	return -EINVAL;
}

struct mutex;
struct lock_class_key;
void __mutex_init(struct mutex *lock, const char *name,
		struct lock_class_key *key)
{
}

__u16 __fswab16(__u16 val)
{
	return	(((__u16)val & (__u16)0x00ffU) << 8) |
		(((__u16)val & (__u16)0xff00U) >> 8);
}

__u32 __fswab32(__u32 val)
{
	return	(((__u32)val & (__u32)0x000000ffUL) << 24) |
		(((__u32)val & (__u32)0x0000ff00UL) <<  8) |
		(((__u32)val & (__u32)0x00ff0000UL) >>  8) |
		(((__u32)val & (__u32)0xff000000UL) >> 24);
}

__u64 __fswab64(__u64 val)
{
	return	(__u64)(((__u64)val & (__u64)0x00000000000000ffULL) << 56) |
		(__u64)(((__u64)val & (__u64)0x000000000000ff00ULL) << 40) |
		(__u64)(((__u64)val & (__u64)0x0000000000ff0000ULL) << 24) |
		(__u64)(((__u64)val & (__u64)0x00000000ff000000ULL) <<  8) |
		(__u64)(((__u64)val & (__u64)0x000000ff00000000ULL) >>  8) |
		(__u64)(((__u64)val & (__u64)0x0000ff0000000000ULL) >> 24) |
		(__u64)(((__u64)val & (__u64)0x00ff000000000000ULL) >> 40) |
		(__u64)(((__u64)val & (__u64)0xff00000000000000ULL) >> 56);
}

unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
{
	unsigned long ret = *(volatile long *)ptr;

	switch (size) {
	case 1:
		*(volatile char *)ptr = x;
		break;
	case 2:
		*(volatile short *)ptr = x;
		break;
	case 4:
		*(volatile int *)ptr = x;
		break;
#if BITS_PER_LONG == 64
	case 8:
		*(volatile long *)ptr = x;
		break;
#endif
	}

	return ret;
}

static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
				      unsigned long new, int size)
{
	unsigned long prev = old;
	switch (size) {
	case 1:
		if ((char)old == *(volatile char *)ptr)
			*(volatile char *)ptr = new;
		return prev;
	case 2:
		if ((short)old == *(volatile short *)ptr)
			*(volatile short *)ptr = new;
		return prev;
	case 4:
		if ((int)old == *(volatile int *)ptr)
			*(volatile int *)ptr = new;
		return prev;
#if BITS_PER_LONG == 64
	case 8:
		if ((long)old == *(volatile long *)ptr)
			*(volatile long *)ptr = new;
		return prev;
#endif
	}
	return old;
}

typedef struct {
	int counter;
} atomic_t;

void atomic_dec(atomic_t *v)
{
	v->counter--;
}

void atomic_inc(atomic_t *v)
{
	v->counter++;
}

void atomic_add(int i, atomic_t *v)
{
	v->counter += i;
}

void atomic_sub(int i, atomic_t *v)
{
	v->counter -= i;
}

int atomic_add_return(int i, atomic_t *v)
{
	return v->counter += i;
}

int atomic_sub_return(int i, atomic_t *v)
{
	return v->counter -= i;
}

int atomic_dec_and_test(atomic_t *v)
{
	return atomic_sub_return(1, v) == 0;
}

#if BITS_PER_LONG == 64
typedef struct {
	long counter;
} atomic64_t;

void atomic64_dec(atomic64_t *v)
{
	v->counter--;
}

void atomic64_inc(atomic64_t *v)
{
	v->counter++;
}

void atomic64_add(long i, atomic64_t *v)
{
	v->counter += i;
}

void atomic64_sub(long i, atomic64_t *v)
{
	v->counter -= i;
}

typedef atomic64_t atomic_long_t;
#else
#error TODO
#endif

typedef struct {
	atomic_long_t a;
} local_t;

void local_dec(local_t *v)
{
	v->a.counter--;
}
void local_inc(local_t *v)
{
	v->a.counter++;
}

void __clear_bit(int nr, volatile unsigned long *addr)
{
	unsigned long mask = BIT_MASK(nr);
	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);

	*p &= ~mask;
}

void clear_bit(int nr, volatile unsigned long *addr)
{
	__clear_bit(nr, addr);
}

void __set_bit(int nr, volatile unsigned long *addr)
{
	unsigned long mask = BIT_MASK(nr);
	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);

	*p |= mask;
}

void set_bit(int nr, volatile unsigned long *addr)
{
	__set_bit(nr, addr);
}

int variable_test_bit(int nr, const volatile unsigned long *addr)
{
	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
}

int __test_and_set_bit(int nr, volatile unsigned long *addr)
{
	unsigned long mask = BIT_MASK(nr);
	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
	unsigned long old;

	old = *p;
	*p = old | mask;

	return (old & mask) != 0;
}

int test_and_set_bit(int nr, volatile unsigned long *addr)
{
	return __test_and_set_bit(nr, addr);
}

int __test_and_clear_bit(int nr, volatile unsigned long *addr)
{
	unsigned long mask = BIT_MASK(nr);
	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
	unsigned long old;

	old = *p;
	*p = old & ~mask;

	return (old & mask) != 0;
}

int test_and_clear_bit(int nr, volatile unsigned long *addr)
{
	return __test_and_clear_bit(nr, addr);
}

int fls(int x)
{
	int r = 32;

	if (!x)
		return 0;
	if (!(x & 0xffff0000u)) {
		x <<= 16;
		r -= 16;
	}
	if (!(x & 0xff000000u)) {
		x <<= 8;
		r -= 8;
	}
	if (!(x & 0xf0000000u)) {
		x <<= 4;
		r -= 4;
	}
	if (!(x & 0xc0000000u)) {
		x <<= 2;
		r -= 2;
	}
	if (!(x & 0x80000000u)) {
		x <<= 1;
		r -= 1;
	}
	return r;
}

unsigned long __fls(unsigned long word)
{
	int num = BITS_PER_LONG - 1;

#if BITS_PER_LONG == 64
	if (!(word & (~0ul << 32))) {
		num -= 32;
		word <<= 32;
	}
#endif
	if (!(word & (~0ul << (BITS_PER_LONG-16)))) {
		num -= 16;
		word <<= 16;
	}
	if (!(word & (~0ul << (BITS_PER_LONG-8)))) {
		num -= 8;
		word <<= 8;
	}
	if (!(word & (~0ul << (BITS_PER_LONG-4)))) {
		num -= 4;
		word <<= 4;
	}
	if (!(word & (~0ul << (BITS_PER_LONG-2)))) {
		num -= 2;
		word <<= 2;
	}
	if (!(word & (~0ul << (BITS_PER_LONG-1))))
		num -= 1;
	return num;
}

int ffs(int x)
{
	int r = 1;

	if (!x)
		return 0;
	if (!(x & 0xffff)) {
		x >>= 16;
		r += 16;
	}
	if (!(x & 0xff)) {
		x >>= 8;
		r += 8;
	}
	if (!(x & 0xf)) {
		x >>= 4;
		r += 4;
	}
	if (!(x & 3)) {
		x >>= 2;
		r += 2;
	}
	if (!(x & 1)) {
		x >>= 1;
		r += 1;
	}
	return r;
}

unsigned long __ffs(unsigned long word)
{
	int num = 0;

#if BITS_PER_LONG == 64
	if ((word & 0xffffffff) == 0) {
		num += 32;
		word >>= 32;
	}
#endif
	if ((word & 0xffff) == 0) {
		num += 16;
		word >>= 16;
	}
	if ((word & 0xff) == 0) {
		num += 8;
		word >>= 8;
	}
	if ((word & 0xf) == 0) {
		num += 4;
		word >>= 4;
	}
	if ((word & 0x3) == 0) {
		num += 2;
		word >>= 2;
	}
	if ((word & 0x1) == 0)
		num += 1;
	return num;
}

unsigned long ffz(unsigned long word)
{
	return __ffs(~word);
}

unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
			    unsigned long offset)
{
	const unsigned long *p = addr + BITOP_WORD(offset);
	unsigned long result = offset & ~(BITS_PER_LONG-1);
	unsigned long tmp;

	if (offset >= size)
		return size;
	size -= result;
	offset %= BITS_PER_LONG;
	if (offset) {
		tmp = *(p++);
		tmp &= (~0UL << offset);
		if (size < BITS_PER_LONG)
			goto found_first;
		if (tmp)
			goto found_middle;
		size -= BITS_PER_LONG;
		result += BITS_PER_LONG;
	}
	while (size & ~(BITS_PER_LONG-1)) {
		if ((tmp = *(p++)))
			goto found_middle;
		result += BITS_PER_LONG;
		size -= BITS_PER_LONG;
	}
	if (!size)
		return result;
	tmp = *p;

found_first:
	tmp &= (~0UL >> (BITS_PER_LONG - size));
	if (tmp == 0UL)	 /* Are any bits set? */
		return result + size;   /* Nope. */
found_middle:
	return result + __ffs(tmp);
}

unsigned long copy_to_user(void *to, const void *from, unsigned len)
{
	memcpy(to, from, len);
	return 0;
}

unsigned long copy_from_user(void *to, const void *from, unsigned len)
{
	memcpy(to, from, len);
	return 0;
}

struct device;
const char *dev_driver_string(const struct device *dev)
{
	return "";
}

int capable(int cap)
{
	return 1;
}

unsigned long msecs_to_jiffies(const unsigned int m)
{
	return (m + (1000 / HZ) - 1) / (1000 / HZ);
}

unsigned int jiffies_to_msecs(const unsigned long j)
{
	return (1000 / HZ) * j;
}

void *vmalloc(unsigned long size)
{
	extern void *malloc(size_t size);
	return malloc(size);
}

void vfree(const void *addr)
{
	extern void free(void *ptr);
	free((void *)addr);
}

void *__kmalloc(size_t size, gfp_t flags)
{
	extern void *malloc(size_t size);
	return malloc(size);
}

void lock_kernel(void) { }
void unlock_kernel(void) { }

static char current_data[16 * 1024];
struct task_struct;
struct task_struct *__ai_current_singleton = (struct task_struct *)current_data;

int __dynamic_dbg_enabled_helper(char *modname, int type, int value, int hash)
{
	return 0;
}

int sprintf(char *buf, const char *fmt, ...)
{
	buf[0] = 'A';
	buf[1] = 0;
	return 1;
}

int snprintf(char *buf, size_t size, const char *fmt, ...)
{
	return sprintf(buf, "A");
}

int scnprintf(char *buf, size_t size, const char *fmt, ...)
{
	return sprintf(buf, "A");
}

int xfs_error_trap(int e)
{
	return e;
}

void __assert_fail(const char *__assertion, const char *__file,
		unsigned int __line, const char *__function)
{
}

void assfail(char *expr, char *file, int line)
{
	__assert_fail(expr, file, line, "unknown");
}

void panic(const char *fmt, ...)
{
	__assert_fail(fmt, "unknown", 0, "unknown");
}
