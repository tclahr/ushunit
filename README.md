# ushunit

ushunit is a [TAP](https://testanything.org/)-compliant free and open source unit testing framework for POSIX-compatible Bourne shell (/bin/sh). It provides a simple way to verify that your scripts behave as expected. It was initially developed to provide a consistent test solution for [UAC](https://github.com/tclahr/uac) (Unix-like Artifacts Collector) tool.

ushunit was inspired by python's [unittest](https://docs.python.org/3/library/unittest.html) and [shUnit2](https://github.com/kward/shunit2).

***

## 💾 Supported Operating Systems

ushunit runs on any Unix-like system (regardless of the processor architecture).

[![AIX](https://img.shields.io/static/v1?label=&message=AIX&color=brightgreen&style=for-the-badge)](#-supported-operating-systems)
[![ESXi](https://img.shields.io/static/v1?label=&message=ESXi&color=blue&style=for-the-badge)](#-supported-operating-systems)
[![FreeBSD](https://img.shields.io/static/v1?label=&message=FreeBSD&color=red&style=for-the-badge)](#-supported-operating-systems)
[![Linux](https://img.shields.io/static/v1?label=&message=Linux&color=lightgray&style=for-the-badge)](#-supported-operating-systems)
[![macOS](https://img.shields.io/static/v1?label=&message=macOS&color=blueviolet&style=for-the-badge)](#-supported-operating-systems)
[![NetBSD](https://img.shields.io/static/v1?label=&message=NetBSD&color=orange&style=for-the-badge)](#-supported-operating-systems)
[![NetScaler](https://img.shields.io/static/v1?label=&message=NetScaler&color=blue&style=for-the-badge)](#-supported-operating-systems)
[![OpenBSD](https://img.shields.io/static/v1?label=&message=OpenBSD&color=yellow&style=for-the-badge)](#-supported-operating-systems)
[![Solaris](https://img.shields.io/static/v1?label=&message=Solaris&color=lightblue&style=for-the-badge)](#-supported-operating-systems)

*Note that ushunit runs on systems like Network Attached Storage (NAS) devices, Network devices such as OpenWrt, and IoT devices.*

***

## 📄 Concepts

### Test case

A *test case* is the individual unit of testing. It is represented by a shell script that contains a collection of tests. It is used to aggregate tests that should be executed together.

### Test suite

A *test suite* is a collection of test cases. It is used to aggregate tests that should be executed together.

***

## ⚡ Basic example

Here is a quick sample script to show how to write your unit case in Bourne shell. The two individual tests are defined with functions whose names start with the letter ```test```. This naming convention informs ushunit about which functions represent tests.

ushunit provides a flexible way to test individual test cases or the whole test suite.

```sh
#!/bin/sh
# file: /my_test_suite/my_first_test_case.sh

test_assertEquals_success()
{
    assertEquals "ushunit" "ushunit"
}

testAssertNotEqualsSuccess()
{
    assertNotEquals "ushunit" "USHUNIT"
}
```

Running the unit test to test an individual test case should give the following results.

```sh
$ ./ushunit /my_test_suite/my_first_test_case.sh
1..2
ok 1 - test_assertEquals_success
ok 2 - testAssertNotEqualsSuccess
# Ran 2 tests. Passed: 2. Failed: 0. Skipped: 0.
```

Running the unit test to test all test cases within the test suite should give the following results.

```sh
#!/bin/sh
# file: /my_test_suite/my_second_test_case.sh

test_root_user_exists()
{
    assertFileContains "/etc/passwd" "root:x:"
}

test_string_not_empty()
{
    assertNotNull "ushunit"
}
```

```sh
$ ./ushunit /my_test_suite/*.sh
1..4
ok 1 - test_assertEquals_success
ok 2 - testAssertNotEqualsSuccess
ok 3 - test_root_user_exists
ok 4 - test_string_not_empty
# Ran 4 tests. Passed: 4. Failed: 0. Skipped: 0.
```

You might also want to run only specific tests, you may do so with the -f option.
This option accepts a regex pattern as a parameter and filters test functions against this pattern.

```sh
#!/bin/sh
# file: /my_test_suite/my_third_test_case.sh

test_assertEquals_success()
{
    assertEquals "ushunit" "ushunit"
}

testAssertNotEquals_success()
{
    assertNotEquals "ushunit" "USHUNIT"
}
test_AssertEquals_fail()
{
    assertEquals "ushunit" "USHUNIT"
}
test_AssertEqualsSucess()
{
    assertEquals "ushunit" "ushunit"
}
```

Running the unit test with -f "success" should give the following results.

```sh
$ ./ushunit -f "success" /my_test_suite/my_third_test_case.sh
1..2
ok 1 - test_assertEquals_success
ok 2 - testAssertNotEquals_success
# Ran 2 tests. Passed: 2. Failed: 0. Skipped: 0.
```

***

## 💻 Command line options

```
Usage: ./ushunit [OPTIONS] TEST_FILE...

Optional Arguments:
  -h, --help        Display this help and exit.
  -V, --version     Output version information and exit.
      --debug       Enable debug mode.
      
  -t, --temp-dir    PATH   
                    Write all temporary data to this directory.

Test Arguments:
  -i, --enable-isolation
                    All tests within the same test file are executed within
                    a child process, ensuring that variables or functions 
                    established in one file do not impact others.
  -f, --filter      PATTERN
                    Filter tests to run based on the given regex pattern.

Positional Arguments:
  TEST_FILE         Test file(s).

```

### Test arguments

**-i/--enable-isolation**

All tests within the same test file are executed within a child process, ensuring that variables or functions established in one file do not impact others. Please refer to the [Test isolation](#🚦-test-isolation-sandboxing) section for more information.

### Diagnostic arguments

**--debug**

Enable debug mode. The temporary directory will not be removed. This is the location where temporary and debugging data is stored during execution.

***

## 📑 Asserts and Functions

#### assertEquals [message] expected actual

Asserts that *expected* and *actual* are equal. The values can be either strings or integer values as both will be treated as strings. If the values do not compare equal, the test will fail. The *message* is optional and must be quoted.

#### assertNotEquals [message] unexpected actual

Asserts that *unexpected* and *actual* are not equal. The values can be either strings or integer values as both will be treated as strings. If the values do compare equal, the test will fail. The *message* is optional and must be quoted.

#### assertTrue [message] condition

Asserts that a given shell *condition* is true. The condition can be as simple as a shell *true* value, or a more complex shell condition expression. The *message* is optional and must be quoted.

#### assertFalse [message] condition

Asserts that a given shell *condition* is false. The condition can be as simple as a shell *false* value, or a more complex shell condition expression. The *message* is optional and must be quoted.

#### assertNull [message] value

Asserts that *value* is null (an empty string). The *message* is optional and must be quoted.

#### assertNotNull [message] value

Asserts that *value* is not null (a non-empty string). The *message* is optional and must be quoted.

#### assertContains [message] [regex] container content

Asserts that *container* contains *content*. The *container* and *content* can be either a string or integer value as both will be treated as strings. The *regex* is optional and must be *true* or *false*. If *true*, *content* will be treated as a regular expression. The *message* is optional and must be quoted.

#### assertNotContains [message] [regex] container content

Asserts that *container* does not contain *content*. The *container* and *content* can be either a string or integer value as both will be treated as strings. The *regex* is optional and must be *true* or *false*. If *true*, *content* will be treated as a regular expression. The *message* is optional and must be quoted.

#### assertFileContains [message] [regex] file content

Asserts that *file* content contains *content*. The *container* and *content* can be either a string or integer value as both will be treated as strings. The *regex* is optional and must be *true* or *false*. If *true*, *content* will be treated as a regular expression. The *message* is optional and must be quoted.

#### assertFileNotContains [message] [regex] file content

Asserts that *file* content does not contain *content*. The *container* and *content* can be either a string or integer value as both will be treated as strings. The *regex* is optional and must be *true* or *false*. If *true*, *content* will be treated as a regular expression. The *message* is optional and must be quoted.

#### assertFileExists [message] file

Asserts that *file* exists. The *message* is optional and must be quoted.

#### assertFileNotExists [message] file

Asserts that *file* does not exist. The *message* is optional and must be quoted.

#### assertDirectoryExists [message] directory

Asserts that *directory* exists. The *message* is optional and must be quoted.

#### assertDirectoryotExists [message] directory

Asserts that *directory* does not exist. The *message* is optional and must be quoted.

#### oneTimeSetUp

Function called before executing any tests. Typically, it's utilized to set up the environment for all tests within a test case, such as creating directories for output or setting environment variables. The default implementation does nothing.

#### oneTimeTearDown

Function called after executing all tests. Useful for tasks like removing temporary files or directories. The default implementation does nothing.

#### setUp

Function called immediately before each test. The default implementation does nothing.

#### tearDown

Function called immediately after each test. This is called even if the test failed. The default implementation does nothing.

***

## 📌 Skipping tests

#### skipTest [message]

Calling this during a test function will skip the current test. The *message* is optional and must be quoted.

```sh
#!/bin/sh
# file: skiptest_example.sh

test_tar_directory()
{
  if commandExists "tar"; then
    assertTrue "tar -zcf file.tar.gz directory"
  else
    skipTest "tar is not available on the system"
  fi
}

$ ./ushunit skiptest_example.sh
1..1
ok 1 - test_tar_directory # Skipped: tar is not available on the system
# Ran 1 tests. Passed: 0. Failed: 0. Skipped: 1.
```

***

## 🐶 Helpers

#### commandExists command

Checks if *command* exists (is available on the system). The *command* must be quoted.

```sh
#!/bin/sh

test_tar_directory()
{
  if commandExists "tar"; then
    assertTrue "tar -zcf file.tar.gz directory"
  else
    skipTest
  fi
}

```

***

## 📝 Constants

The following constants can be used within test cases and will be replaced at runtime:

|Constant|Replacement|
|---|---|
|USHUNIT_TEMP_DIR|Full path to the temp directory created by ushunit at runtime. It will be automatically cleaned up upon exit of ushunit.|

***

## 🚦 Test isolation (sandboxing)

When the ```-i/--enable-isolation``` option is utilized, all tests within the same test case are executed within a child process (sandbox). Consequently, each test case runs within its isolated environment, ensuring that variables or functions established in one test case do not impact others.

Let's suppose you have the following test suite (with two test cases).

```sh
#!/bin/sh
# file: test_case_01.sh

oneTimeSetUp()
{
  # stub
  date()
  {
    printf %b "1234567890"
  }
}

test_date()
{
  __actual=`date "+%s"`
  assertEquals "1234567890" "${__actual}"
}
```

```sh
#!/bin/sh
# file: test_case_02.sh

test_new_date()
{
  __actual=`date "+%s"`
  assertNotEquals "1234567890" "${__actual}"
}
```

If isolation is disabled (default behavior), the stub ```date``` function defined in the test case ```test_case_01.sh``` will persist across all tests within the test suite.

```sh
./ushunit test_suite/test_case_01.sh test_suite/test_case_02.sh
1..2
ok 1 - test_date
no ok 2 - test_new_date
  # Failed assertNotEquals: expected not [1234567890]
# Ran 2 tests. Passed: 1. Failed: 1. Skipped: 0.
```

If isolation is enabled, the stub ```date``` function defined in the test case ```test_case_01.sh``` will not impact other test cases as it will only be available within the test case it was defined.

```sh
./ushunit --enable-isolation test_suite/test_case_01.sh test_suite/test_case_02.sh
1..2
ok 1 - test_date
ok 2 - test_new_date
# Ran 2 tests. Passed: 2. Failed: 0. Skipped: 0.
```

***

## 💙 Contributing

You are always welcome to contribute to the project. Please read our [Contributing Guide](CONTRIBUTING.md) before submitting a Pull Request to the project.
