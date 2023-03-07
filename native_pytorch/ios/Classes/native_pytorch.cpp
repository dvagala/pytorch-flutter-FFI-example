#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#include <vector>


extern "C" __attribute__((visibility("default"))) __attribute__((used)) int
native_add(int a, int b) {
    return a + b;
}
