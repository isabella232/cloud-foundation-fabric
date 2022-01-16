# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "cmek_encryption" {
  description = "Flag to enable CMEK on GCP resources created."
  type        = bool
  default     = false
}

variable "data_eng_principals" {
  description = "Groups with Service Account Token creator role on service accounts in IAM format, eg 'group:group@domain.com'."
  type        = list(string)
  default     = []
}

variable "data_force_destroy" {
  description = "Flag to set 'force_destroy' on data services like biguqery or cloud storage."
  type        = bool
  default     = false
}

variable "network" {
  description = "Shared VPC to use. If not null networks will be created in projects."
  type = object({
    network = string
    subnet = object({
      load           = string
      transformation = string
      orchestration  = string
      trasformation  = string
    })
  })
  default = null
}

variable "prefix" {
  description = "Unique prefix used for resource names. Not used for project if 'project_create' is null."
  type        = string
}

variable "project_create" {
  description = "Provide values if project creation is needed, uses existing project if null. Parent is in 'folders/nnn' or 'organizations/nnn' format"
  type = object({
    billing_account_id = string
    parent             = string
  })
  default = null
}

variable "project_id" {
  description = "Project id, references existing project if `project_create` is null."
  type = object({
    landing       = string
    load          = string
    orchestration = string
    trasformation = string
  })
  default = {
    landing       = "lnd"
    load          = "lod"
    orchestration = "orc"
    trasformation = "trf"
  }
}

variable "project_services" {
  type = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "stackdriver.googleapis.com"
  ]
}

variable "region" {
  description = "The region where resources will be deployed."
  type        = string
  default     = "europe-west1"
}

variable "vpc_subnet_range" {
  description = "Ip range used for the VPC subnet created for the example."
  type        = string
  default     = "10.0.0.0/20"
}
