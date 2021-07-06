/* SPDX-License-Identifier: BSD-2-Clause */

/**
 * @file
 * @brief Test of sig2str and str2sig methods
 *
 * This test file is used to verify that the methods sig2str and str2sig
 * are functioning as expected
 */

/*
 * Copyright (C) 2021 Matthew Joyce
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/* Defined to have access to SIG2STR_MAX and function prototypes in signal.h*/
#define _GNU_SOURCE

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <rtems.h>
#include <tmacros.h>
#include <signal.h>
#include <rtems/test.h>
#include "test_support.h"

//#include <sys/signal.h>

const char rtems_test_name[] = "SIG2STR AND STR2SIG TEST";

static rtems_task Init(
  rtems_task_argument ignored
)
{
  rtems_print_printer_fprintf_putc(&rtems_test_printer);
  TEST_BEGIN();
  printf( "SIG2STR AND STR2SIG TEST\n" );
  
  char test1[SIG2STR_MAX];
  char test2[SIG2STR_MAX];
  char test3[SIG2STR_MAX];
  char test4[SIG2STR_MAX];


  int res1;
  int res2; 
  int res3;
  int res4; 
  int retval1;
  int retval2;
  int retval3;
  int retval4;
  int min = SIGRTMIN;
  int max = SIGRTMAX;

  printf( "sigrtmin is %d and sigrtmax is %d\n", min, max );

  printf("Calling sig2str: \n");
  sig2str(31, test1);
  sig2str(9, test2);
  sig2str(29, test3); 
  sig2str(2147483647, test4);
  printf("test1 is now: %s\n", test1);
  printf("test2 is now: %s\n", test2);
  printf("test3 is now: %s\n", test3);
  printf("test4 is now: %s\n", test4);

  printf("Calling str2sig: \n");
  retval1 = str2sig("19", &res1);
  retval2 = str2sig("TSTP", &res2);
  retval3 = str2sig("RTMIN+12", &res3);
  retval4 = str2sig("RTMAX-2", &res4);
  printf("The result of the first call is: %d\n", res1); 
  printf("The second result of the second call is: %d\n", res2);
  printf("The second result of the third call is: %d\n", res3);
  printf("The second result of the fourth call is: %d\n", res4);

  // T_TEST_CASE(a_test_case)
  // {
  //   T_eq_int(res1, 19);
  // }

  printf("retval1 is %d\n", retval1); 
  printf("retval2 is %d\n", retval2); 
  printf("retval3 is %d\n", retval3); 
  printf("retval4 is %d\n", retval4); 

  /* Testing a call to str2sig using a previously successful call to sig2str.
  * value in pnum should equal signum*/
  printf("\n");
  str2sig(test1, &res1);
  str2sig(test2, &res2); 
  str2sig(test3, &res3);
  
  rtems_test_assert(res1 == 31);
  printf("res1 should equal 31. It is: %d\n", res1);
  rtems_test_assert(res2 == 9);
  printf("res2 should equal 9. It is: %d\n", res2);
  rtems_test_assert(res3 == 29);
  printf("res3 should equal 29. It is: %d\n", res3);


  TEST_END();
  rtems_test_exit( 0 );
}


/* NOTICE: the clock driver is explicitly disabled */
#define CONFIGURE_APPLICATION_DOES_NOT_NEED_CLOCK_DRIVER
#define CONFIGURE_APPLICATION_NEEDS_SIMPLE_CONSOLE_DRIVER

#define CONFIGURE_MAXIMUM_TASKS            1

#define CONFIGURE_RTEMS_INIT_TASKS_TABLE

#define CONFIGURE_INIT_TASK_ATTRIBUTES RTEMS_FLOATING_POINT

#define CONFIGURE_INITIAL_EXTENSIONS RTEMS_TEST_INITIAL_EXTENSION

#define CONFIGURE_INIT
#include <rtems/confdefs.h>