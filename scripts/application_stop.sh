#!/bin/bash
set +e -x
systemctl disable test_md.service
systemctl stop test_md.service
