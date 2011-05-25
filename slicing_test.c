#include <assert.h>
#include <klee/klee.h>

extern void die();

static int work(int a)
{
	return a > 900000;
}

unsigned long state;

int main(int argc, char **argv)
{
	unsigned long *s = &state;
	int a;

	a = ({ work(0); work(1); work(2); work(3); });

	klee_make_symbolic(&state, sizeof(state), "state");
	klee_make_symbolic(&a, sizeof(a), "loop-var");

	state = 1;

	for (a = 0; a < 200000; a++)
		if (work(a)) {
//			assert(state != 1);
//			return 1;
		}
	*s = 0;

	if (state)
		die();

	assert(state != 1);
	return 0;
}
