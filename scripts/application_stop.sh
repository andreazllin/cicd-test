#!/bin/bash
set +e -x
systemctl disable custom_app_name.service
systemctl stop custom_app_name.service
