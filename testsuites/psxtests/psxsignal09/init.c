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

const char rtems_test_name[] = "SIG2STR AND STR2SIG";

static rtems_task Init(
  rtems_task_argument ignored
)
{
  rtems_print_printer_fprintf_putc(&rtems_test_printer);
  TEST_BEGIN();
  
  char test1[SIG2STR_MAX];
  char test2[SIG2STR_MAX];
  char test3[SIG2STR_MAX];
  char test4[SIG2STR_MAX];
  char test5[SIG2STR_MAX];
  char test6[SIG2STR_MAX];
  char test7[SIG2STR_MAX];
  char test8[SIG2STR_MAX];
  char test9[SIG2STR_MAX];
  int res1;
  int res2; 
  int res3;
  int res4; 
  int res5;
  int res6; 
  int res7;
  int res8;
  int res9;
  int retval1;
  int retval2;
  int retval3;
  int retval4;
  int retval5;
  int retval6;
  int retval7;
  int retval8;
  int retval9;
  int min = SIGRTMIN;
  int max = SIGRTMAX;
  
  printf( "\n" );
  printf( "SIGRTMIN is %d and SIGRTMAX is %d\n", min, max );
  printf( "\n" );

  printf( "Calling sig2str: \n" );

  /* Expected pass */
  retval1 = sig2str( 1, test1 );
  rtems_test_assert( retval1 == 0 );
  rtems_test_assert( strcmp( test1, "HUP" )==0 );
  printf( "The string test1 is: %s\n", test1 ); 

  /* Expected pass */
  retval2 = sig2str( 3, test2 );
  rtems_test_assert( retval2 == 0 );
  rtems_test_assert( strcmp( test2, "QUIT" )==0);
  printf( "The string test2 is: %s\n", test2 ); 

  /* Expected pass */
  retval3 = sig2str( 27, test3 );
  rtems_test_assert( retval3 == 0 );
  rtems_test_assert( strcmp( test3, "RTMIN" )==0 );
  printf( "The string test3 is: %s\n", test3 ); 

  /* Expected pass */
  retval4 = sig2str( 29, test4 );
  rtems_test_assert( retval4 == 0 );
  rtems_test_assert( strcmp( test4, "RTMIN+2" )==0 );
  printf( "The string test4 is: %s\n", test4 ); 

  /* Expected pass */
  retval5 = sig2str( 31, test5 );
  rtems_test_assert( retval5 == 0 );
  rtems_test_assert( strcmp( test5, "RTMAX" )==0);
  printf( "The string test5 is: %s\n", test5 ); 

  /* Expected pass */
  retval6 = sig2str( 30, test6 );
  rtems_test_assert( retval6 == 0 );
  rtems_test_assert( strcmp( test6, "RTMAX-1" )==0);
  printf( "The string test6 is: %s\n", test6 );

  /* Expected pass */
  retval7 = sig2str( 9, test7 );
  rtems_test_assert( retval7 == 0 );
  rtems_test_assert(strcmp( test7, "KILL" )==0);
  printf( "The string test7 is: %s\n", test7 );

  /* Expected fail, invalid signal number */
  retval8 = sig2str( 200, test8 );
  rtems_test_assert( retval8 == -1);
  rtems_test_assert( strcmp( test8, "Unknown signal 200" )==0);
  printf( "The string test8 is: %s\n", test8 );

  /* Expected fail, if signum is 0 the output is unspecified */
  retval9 = sig2str( 0, test9 );
  rtems_test_assert( retval9 == -1 );
  printf( "The string test9 is: %s\n", test9 );


  printf( "\n" ); 
  printf( "Calling str2sig: \n" );

  /* Expected pass */
  retval1 = str2sig( "PIPE", &res1 );
  rtems_test_assert( retval1 == 0); 
  rtems_test_assert( res1 == 13 ); 
  printf( "Result 1 is: %d\n", res1 );

  /* Expected pass */
  retval2 = str2sig( "TSTP", &res2 );
  rtems_test_assert( retval2 == 0); 
  rtems_test_assert( res2 == 18 ); 
  printf( "Result 2 is: %d\n", res2 );

  /* Expected pass */
  retval3 = str2sig( "KILL", &res3 );
  rtems_test_assert( retval3 == 0); 
  rtems_test_assert( res3 == 9 ); 
  printf( "Result 3 is: %d\n", res3 );

  /* Expected pass, String representation of integer */
  retval4 = str2sig( "10", &res4 );
  rtems_test_assert( retval4 == 0); 
  rtems_test_assert( res4 == 10 ); 
  printf( "Result 4 is: %d\n", res4 );

  /* Expected pass */
  retval5 = str2sig( "RTMIN", &res5 );
  rtems_test_assert( retval5 == 0); 
  rtems_test_assert( res5 == 27 ); 
  printf( "Result 5 is: %d\n", res5 );

  /* Expected pass */
  retval6 = str2sig( "RTMIN+1", &res6 );
  rtems_test_assert( retval6 == 0); 
  rtems_test_assert( res6 == 28 ); 
  printf( "Result 6 is: %d\n", res6 );

  /* Expected pass */
  retval7 = str2sig( "RTMAX-2", &res7 );
  rtems_test_assert( retval7 == 0); 
  rtems_test_assert( res7 == 29 ); 
  printf( "Result 7 is: %d\n", res7 );

  /* Expected fail, invalid signal name */
  retval8 = str2sig( "BOSS", &res8 );
  rtems_test_assert( retval8 == -1); 
  printf( "Result 8 is: %d\n", res8 );

  /* Expected fail, invalid signal name */
  retval9 = str2sig( "RTMIN+1000", &res9 );
  rtems_test_assert( retval9 == -1); 
  printf( "Result 9 is: %d\n", res9 );

  printf( "\n" );
  printf( "Calling str2sig using the result from previous call to sig2str\n" );
  
  /* Expected pass */
  retval1 = str2sig( test1, &res1 );
  rtems_test_assert( retval1 == 0 ); 
  rtems_test_assert( res1 == 1 ); 
  printf( "Result 1 is: %d\n", res1 ); 

  /* Expected pass */
  retval2 = str2sig( test2, &res2 );
  rtems_test_assert( retval2 == 0 ); 
  rtems_test_assert( res2 == 3 ); 
  printf( "Result 2 is: %d\n", res2 ); 

  /* Expected pass */
  retval3 = str2sig( test3, &res3 );
  rtems_test_assert( retval3 == 0 ); 
  rtems_test_assert( res3 == 27 ); 
  printf( "Result 3 is: %d\n", res3 ); 

  /* Expected fail, calling using string from invalid sig2str call */
  retval4 = str2sig( test8, &res4 );
  rtems_test_assert( retval4 == -1 ); 
  
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