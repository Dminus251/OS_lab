#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "common_threads.h"

//
// Your code goes in the structure and functions below
//

// 구조체, 락 정의해야 함

typedef struct __rwlock_t { 
} rwlock_t;


void rwlock_init(rwlock_t *rw) {
}

void rwlock_acquire_readlock(rwlock_t *rw) {
}

void rwlock_release_readlock(rwlock_t *rw) {
}

void rwlock_acquire_writelock(rwlock_t *rw) {
}

void rwlock_release_writelock(rwlock_t *rw) {
}

//
// Don't change the code below (just use it!)
// 

int loops; //스레드를 몇 번 반복할지
int value = 0; //write로 증가시키는 변수

rwlock_t lock; //reader-writer lock 객체

void *reader(void *arg) { //loops만큼 value를 읽고 출력
    int i;
    for (i = 0; i < loops; i++) {
	rwlock_acquire_readlock(&lock);
	printf("read %d\n", value);
	rwlock_release_readlock(&lock);
    }
    return NULL;
}

void *writer(void *arg) { //loops만큼 value 증가시키고 출력	
    int i;
    for (i = 0; i < loops; i++) {
	rwlock_acquire_writelock(&lock);
	value++;
	printf("write %d\n", value);
	rwlock_release_writelock(&lock);
    }
    return NULL;
}

int main(int argc, char *argv[]) {
    assert(argc == 4); //3개의 인자를 받아야 함
    int num_readers = atoi(argv[1]); //첫 번째 인자는 reader 스레드 수
    int num_writers = atoi(argv[2]); //두 번째 인자는 writer 스레드 수
    loops = atoi(argv[3]); //세 번째 인자는 loops 수

    pthread_t pr[num_readers], pw[num_writers];

    rwlock_init(&lock);

    printf("begin\n");

    int i;
    for (i = 0; i < num_readers; i++)
	Pthread_create(&pr[i], NULL, reader, NULL);
    for (i = 0; i < num_writers; i++)
	Pthread_create(&pw[i], NULL, writer, NULL);

    for (i = 0; i < num_readers; i++)
	Pthread_join(pr[i], NULL);
    for (i = 0; i < num_writers; i++)
	Pthread_join(pw[i], NULL);

    printf("end: value %d\n", value);

    return 0;
}

