#!/bin/sh
# shellcheck disable=SC2317

oneTimeSetUp()
{
  echo "test message" >"${USHUNIT_TEMP_DIR}/file-exists"

  # stub
  date()
  {
    printf %b "1234567890"
  }
}

test_assertEquals()
{
  assertEquals 1 1
  assertEquals "ushunit" "ushunit"
  assertEquals "custom message" 1 1
}

test_assertNotEquals()
{
  assertNotEquals 1 2
  assertNotEquals "ushunit" "ushunittest"
  assertNotEquals "custom message" 1 2
}

test_assertTrue()
{
  assertTrue true
  assertTrue "custom message" true
}

test_assertFalse()
{
  assertFalse false
  assertFalse "custom message" false
}

test_assertNull()
{
  assertNull ""
  assertNull "custom message" ""
}

test_assertNotNull()
{
  assertNotNull "1"
  assertNotNull "custom message" "1"
}

test_assertContains()
{
  assertContains "this is a message" "is a messa"
  assertContains "custom message" "this is a message" "messa"
  assertContains true "this is a message" "^this"
  assertContains "custom message" true "this is a message" "^this"
  assertContains "custom message" false "this is a message" "this"
}

test_assertNotContains()
{
  assertNotContains "this is a message" "test"
  assertNotContains "custom message" "this is a message" "test"
  assertNotContains true "this is a message" "^the"
  assertNotContains "custom message" true "this is a message" "^thes"
  assertNotContains "custom message" false "this is a message" "test"
}

test_assertFileContains()
{
  assertFileContains "${USHUNIT_TEMP_DIR}/file-exists" "test message"
  assertFileContains "custom message" "${USHUNIT_TEMP_DIR}/file-exists" "test message"
  assertFileContains true "${USHUNIT_TEMP_DIR}/file-exists" "^test"
  assertFileContains "custom message" true "${USHUNIT_TEMP_DIR}/file-exists" "^test"
  assertFileContains "custom message" false "${USHUNIT_TEMP_DIR}/file-exists" "test"
}

test_assertFileNotContains()
{
  assertFileNotContains "${USHUNIT_TEMP_DIR}/file-exists" "non-existing message"
  assertFileNotContains "custom message" "${USHUNIT_TEMP_DIR}/file-exists" "non-existing message"
  assertFileNotContains true "${USHUNIT_TEMP_DIR}/file-exists" "^non-existing"
  assertFileNotContains "custom message" true "${USHUNIT_TEMP_DIR}/file-exists" "^non-existing"
  assertFileNotContains "custom message" false "${USHUNIT_TEMP_DIR}/file-exists" "non-existing"
}

test_assertFileExists()
{
  assertFileExists "${USHUNIT_TEMP_DIR}/file-exists"
  assertFileExists "custom message" "${USHUNIT_TEMP_DIR}/file-exists"
}

test_assertFileNotExists()
{
  assertFileNotExists "${USHUNIT_TEMP_DIR}/file-not-exists"
  assertFileNotExists "custom message" "${USHUNIT_TEMP_DIR}/file-not-exists"
}

test_assertDirectoryExists()
{
  assertDirectoryExists "${USHUNIT_TEMP_DIR}"
  assertDirectoryExists "custom message" "${USHUNIT_TEMP_DIR}"
}

test_assertDirectoryNotExists()
{
  assertDirectoryNotExists "${USHUNIT_TEMP_DIR}/directory-not-exists"
  assertDirectoryNotExists "custom message" "${USHUNIT_TEMP_DIR}/directory-not-exists"
}
