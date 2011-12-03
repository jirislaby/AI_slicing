// GPLv2

typedef unsigned short __u16;
typedef unsigned int __u32;
typedef unsigned long __u64; /* TODO */
typedef unsigned long size_t; /* TODO */

int param_array_get() {return 0;}
void param_array_set() {}
int param_get_int() {return 0;}
short param_get_short() {return 0;}
void param_set_int() {}
void param_set_short() {}

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

int memcmp(const void *cs, const void *ct, size_t count)
{
	const unsigned char *su1, *su2;
	int res = 0;

	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
		if ((res = *su1 - *su2) != 0)
			break;
	return res;
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

int atomic_sub_return(int i, atomic_t *v)
{
	return (v->counter -= i);
}

int atomic_dec_and_test(atomic_t *v)
{
	return atomic_sub_return(1, v) == 0;
}

int printk(const char *s, ...)
{
	return 0;
}
