#!/bin/bash
# Copyright 2017 The Bootkube-CI Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
helm delete --purge osh-horizon
helm delete --purge osh-neutron
helm delete --purge osh-nova
helm delete --purge osh-cinder
helm delete --purge osh-heat
helm delete --purge osh-glance
helm delete --purge osh-keystone
helm delete --purge osh-memcached
helm delete --purge osh-etcd
helm delete --purge osh-rabbitmq
helm delete --purge osh-libvirt
helm delete --purge osh-ingress
helm delete --purge osh-openvswitch
helm delete --purge osh-ceph-radosgw-keystone
sudo rm -rf /var/lib/nova
sudo rm -rf /home/$USER/openstack-helm

export cronjobs=`(kubectl get cronjobs -n openstack | (awk -F"," '{print $1}') | (cut -d' ' -f1) | (sed '1d') | (awk '/[^[:upper:] ]/'))`
for job in $cronjobs;do
 `kubectl delete cronjob $job -n openstack`
done
