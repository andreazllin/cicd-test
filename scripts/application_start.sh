#!/bin/bash
set +e -x
systemctl enable custom_app_name.service
systemctl start custom_app_name.service
