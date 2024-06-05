#!/bin/sh
# shellcheck disable=SC2006,SC2317

test_isolation()
{
    __ushunit_actual=`date`
    assertNotEquals "1234567890" "${__ushunit_actual}"
}