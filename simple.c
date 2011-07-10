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

extern void mutex_lock(struct mutex *M);
extern void mutex_unlock(struct mutex *M);
extern int compute(void);

int status;

void a(void)
{
	struct mutex m;
	int a;

	mutex_lock(&m);
	status = 1;
	for (a = 0; a < 1000000; a++)
		compute();
	for (a = 0; a < 10; a++)
		if (compute()) {
			mutex_unlock(&m);
			status = 0;
			return;
		}
	mutex_unlock(&m);
	status = 0;
}
