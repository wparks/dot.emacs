/* test.c — Verify: c-mode or c-ts-mode, 4-space indent, no tabs */
#include <stdio.h>

typedef struct {
    int x;
    int y;
} Point;

int add(int a, int b) {
    if (a > 0) {
        return a + b;
    }
    return 0;
}

int main(void) {
    Point p = {1, 2};
    printf("sum: %d\n", add(p.x, p.y));
    return 0;
}
