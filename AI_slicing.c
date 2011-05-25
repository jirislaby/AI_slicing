#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

struct mutex {
	int spin;
};

struct list {
	int head;
};

struct X {
	struct mutex M;
	struct list L;
};

static void mutex_lock(struct mutex *M)
{
	printf("%s: %p\n", __func__, M);
}
static void mutex_unlock(struct mutex *M)
{
	printf("%s: %p\n", __func__, M);
}
static void list_add(struct list *where, struct list *what) {}

enum states {
	LOCK = 1 << 0,
	UNLOCK = 1 << 1,
	ERROR = 1 << 2,
};

static struct mutex M;
static unsigned long stat_ampM = UNLOCK;
static struct list L;
int die;

static inline int set_unset_cond(unsigned long *old, unsigned long cond,
		unsigned long unset, unsigned long set)
{
	unsigned long o = *old;
	if (o & cond) {
		*old = (o | set) & ~unset;
		return 1;
	}
	return 0;
}

static unsigned long trans(unsigned long old, enum states new)
{
	printf("%s: old=%lx newstate=%x\n", __func__, old, new);
	switch (new) {
	case LOCK:
		if (set_unset_cond(&old, LOCK, LOCK, ERROR))
			assert(0 && "double lock");
		set_unset_cond(&old, UNLOCK, UNLOCK, LOCK);
		break;
	case UNLOCK:
		if (set_unset_cond(&old, UNLOCK, UNLOCK, ERROR))
			assert(0 && "double unlock");
		set_unset_cond(&old, LOCK, LOCK, UNLOCK);
		break;
	default:
		assert(0);
		break;
	}

	printf("%s: new=%lx\n", __func__, old);
	return old;
}

/* a lock must be held to call this */
static int work(void)
{
	return die;
}

void l1(void)
{
	mutex_lock(&M); mutex_unlock(&M); mutex_lock(&M);
	stat_ampM = trans(stat_ampM, LOCK);
	if (work())
		return;
	stat_ampM = trans(stat_ampM, UNLOCK);
	mutex_unlock(&M);
}

void l2(void)
{
	int a;

	for (a = 0; a < 2; a++) {
		struct X *x = malloc(sizeof(*x));

		mutex_lock(&x->M);
		if (work())
			return;
		mutex_unlock(&x->M);
		list_add(&L, &x->L);
	}
}

static char buf[128];

void m1(void)
{
	char *p = NULL;
	if (!die)
		p = buf;
	printf("%s: %p\n", __func__, p);
	*p = 5;
}

int main(void)
{
	l1();
	die = 1;
	l1();
	die = 0;
	l2();
	die = 1;
	l2();

	die = 0;
	m1();
	die = 1;
	m1();
	return 0;
}
