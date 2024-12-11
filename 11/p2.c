#include "stdio.h"
#include "stdlib.h"
#include "math.h"

#include "input.h"

#define BUCKETS 10000
#define ull unsigned long long

typedef struct Node {
    ull num;
    int iters;
    ull result;
    struct Node* next;
} Node;

Node* cache[BUCKETS] = {NULL};

unsigned int hash(ull num, int iters) {
    return (num + iters) % BUCKETS;
}

ull get(ull num, int iters) {
    unsigned int index = hash(num, iters);
    Node* node = cache[index];
    while (node != NULL) {
        if (node->num == num && node->iters == iters) {
            return node->result;
        }
        node = node->next;
    }
    return -1;
}

void put(ull num, int iters, ull result) {
    ull index = hash(num, iters);
    Node* new_node = malloc(sizeof(Node));
    new_node->num = num;
    new_node->iters = iters;
    new_node->result = result;
    new_node->next = cache[index];
    cache[index] = new_node;
}

int num_digits(ull num) {
    if (num == 0) return 1;
    int count = 0;
    while (num != 0) {
        count++;
        num /= 10;
    }
    return count;
}

ull out(ull num, int iters) {
    if (iters == 0) {
        return 1;
    }

    ull res = get(num, iters);
    if (res != -1) {
        return res;
    }

    if (num == 0) {
        res = out(1, iters - 1);
        put(num, iters, res);
        return res;
    }

    int n = num_digits(num);

    if (n % 2 == 0) {
        ull half = n / 2;
        ull div = pow(10, half);
        ull a = num / div;
        ull b = num % div;

        res = out(a, iters - 1) + out(b, iters - 1);
        put(num, iters, res);
        return res;
    }

    res = out(num * 2024, iters - 1);
    put(num, iters, res);
    return res;
}

int main() {
    ull nums[] = INPUT;
    int len = 8;
    ull count = 0;

    for (size_t i = 0; i < len; i++) {
        count += out(nums[i], 75);
    }

    printf("%lld\n", count);
    return 0;
}
