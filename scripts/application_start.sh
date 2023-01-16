#!/bin/bash
set +e -x
systemctl enable test_md.service
systemctl start test_md.service
