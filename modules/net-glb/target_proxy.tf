/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  # If no SSL certificates are defined, use the default one.
  # Otherwise, look in the ssl_certificates_config map.
  # Otherwise, use the SSL certificate id as is (already existing).
  ssl_certificates = (
    try(var.target_proxy_https_config.ssl_certificates, null) == null
    || length(coalesce(try(var.target_proxy_https_config.ssl_certificates, null), [])) == 0
    ? try(
      [google_compute_managed_ssl_certificate.managed["default"].id],
      [google_compute_ssl_certificate.unmanaged["default"].id],
      null
    )
    : [
      for cert in try(var.target_proxy_https_config.ssl_certificates, []) :
      try(
        google_compute_managed_ssl_certificate.managed[cert].id,
        google_compute_ssl_certificate.unmanaged[cert].id,
        cert
      )
    ]
  )
}

resource "google_compute_target_http_proxy" "http" {
  count       = var.https ? 0 : 1
  name        = var.name
  project     = var.project_id
  description = "Terraform managed."
  url_map     = google_compute_url_map.url_map.id
}

resource "google_compute_target_https_proxy" "https" {
  count            = var.https ? 1 : 0
  name             = var.name
  project          = var.project_id
  description      = "Terraform managed."
  url_map          = google_compute_url_map.url_map.id
  ssl_certificates = local.ssl_certificates
}
