#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "common_threads.h"

//
// Your code goes in the structure and functions below
//

typedef struct __rwlock_t { 
  sem_t lock; //세마포어 1. 이진 세마포어(기본 락)
  sem_t writelock; //세마포어 2. 하나의 writer와 여러 reader 허용 int readers; // 임계 영역 내에 읽기를 수행 중인 reader 수
  int waiting_writers; //*************대기 중인 writer 수	       
  int readers; //현재 reader의 수		      
} rwlock_t;

//lock과 writelock 두 개의 세마포어를 사용한다.
void rwlock_init(rwlock_t *rw) {
  rw->readers = 0;
  rw->waiting_writers = 0; //************추가
  sem_init(&rw->lock, 0, 1); //lock 세마포어를 1로 초기화 
			     //sem_wait()시 decrement하니까 1로 초기화.
  sem_init(&rw->writelock, 0, 1); //writerlock 세마포어를 1로 초기화
				  //마찬가지.

}

void rwlock_acquire_readlock(rwlock_t *rw) {
  sem_wait(&rw->lock); //이진 락 세마포어획득. decrement lock 세마포어
  rw->readers++;
  //********************추가
  while (rw->waiting_writers>0){
    sem_post(&rw->lock); //대기중인 wirter가 있으면 lock 세마포어 해제
    usleep(1); //이 동안 writer 스레드가 임계 영역 처리
    sem_wait(&rw->lock); //잠깐 쉬고 다시 lock 세마포어 획득	    
  }
  //********************
  if (rw->readers == 1) // 첫번째 reader가 writelock을 획득
      sem_wait(&rw->writelock); //쓸 수 없도록 writelock을 가짐
  sem_post(&rw->lock); //이진 락 세마포어 해제
}

void rwlock_release_readlock(rwlock_t *rw) {
  sem_wait(&rw->lock);
  rw->readers--;
  if (rw->readers == 0) // 마지막 reader가 writelock 해제
      sem_post(&rw->writelock);
  sem_post(&rw->lock);
}

void rwlock_acquire_writelock(rwlock_t *rw) {
  sem_wait(&rw->lock); //lock 세마포어 획득
  rw->waiting_writers++; //wating_writers 증가
  sem_post(&rw->lock); //lock 세마포어 해제

  sem_wait(&rw->writelock); //writelock 세마포어 획득 

  sem_wait(&rw->lock); //wating_writers++했으므로 readlock에서 lock 세마포어
		       //해제함. 이때 애가 lock 획득
  rw->waiting_writers--; //wating_writers 감소
  sem_post(&rw->lock); //lock 세마포어 해제
}

void rwlock_release_writelock(rwlock_t *rw) {
  sem_post(&rw->writelock); //writelock 세마포어 방출
}

//writelock 획득/
// Don't change the code below (just use it!)

int loops; //스레드를 몇 번 반복할지
int value = 0; //write로 증가시키는 변수

rwlock_t lock; //reader-writer lock 객체

void *reader(void *arg) { //loops만큼 value를 읽고 출력
    int i;
    for (i = 0; i < loops; i++) {
	rwlock_acquire_readlock(&lock); //line 25
	printf("read %d\n", value);
	rwlock_release_readlock(&lock);
    }
    return NULL;
}

void *writer(void *arg) { //loops만큼 value 증가시키고 출력	
    int i;
    for (i = 0; i < loops; i++) {
	rwlock_acquire_writelock(&lock); //writelock이 있어야 write할 수 있음
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
	Pthread_create(&pr[i], NULL, reader, NULL); //reader 스레드 호출
	//readers()는 rw->reader++ 연산 수행, 이게 1이 되면
	//writer 세마포어를 획득하므로 writer 스레드의 접근을 막음
    for (i = 0; i < num_writers; i++)
	Pthread_create(&pw[i], NULL, writer, NULL); //writer 스레드 호출

    for (i = 0; i < num_readers; i++)
	Pthread_join(pr[i], NULL);

    for (i = 0; i < num_writers; i++)
	Pthread_join(pw[i], NULL);

    printf("end: value %d\n", value);

    return 0;
}
