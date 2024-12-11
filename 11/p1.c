#include "stdio.h"
#include "stdlib.h"
#include "math.h"

#include "input.h" // This just contains a macro with the input list so its not included in github

#define ull unsigned long long

typedef struct Stone {
    ull num;
    struct Stone *next;
} Stone;

int num_digits(ull num) {
    if (num == 0) return 1;
    int count = 0;
    while (num != 0) {
        count++;
        num /= 10;
    }
    return count;
}

int main() {
    int nums[] = INPUT;
    int len = 8;

    Stone *head = NULL, *cur = NULL;

    for (int i = 0; i < len; i++) {
        Stone *new_node = malloc(sizeof(Stone));
        new_node->num = nums[i];
        new_node->next = NULL;
        
        if (head == NULL) {
            head = new_node;
        } else {
            cur->next = new_node;
        }
        
        cur = new_node;
    }

    for (int i = 0; i < 25; i++) {
        cur = head;
        while (cur != NULL) {
            if (cur->num == 0) {
                cur->num = 1;
            } else {
                int n = num_digits(cur->num);
                if (n % 2 == 0) {
                    ull half = n / 2;
                    ull div = pow(10, half);
                    ull a = cur->num / div;
                    ull b = cur->num % div;

                    cur->num = a;
                    
                    Stone *new = malloc(sizeof(Stone));
                    new->num = b;
                    new->next = cur->next;
                    cur->next = new;

                    cur = new;
                } else {
                    cur->num *= 2024;
                }
            }
            cur = cur->next;
        }
    }

    int count = 0;
    cur = head;
    while (cur != NULL) {
        count++;
        cur = cur->next;
    }

    printf("%d\n", count);
    return 0;
}
