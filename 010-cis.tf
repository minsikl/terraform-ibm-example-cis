resource "ibm_cis" "cis1" {
  name              = "${var.cis_name}"
  plan              = "${var.cis_plan}"
  location          = "${var.cis_location}"
}

resource "ibm_cis_domain" "domain1" {
    domain = "${var.cis_domain}"
    cis_id = "${ibm_cis.cis1.id}"
}

resource "ibm_cis_origin_pool" "multikubernetes1" {
  cis_id = "${ibm_cis.cis1.id}"
  name = "multikubernetes1"
  origins {
    name = "${var.cis_origin1_name}"
    address = "${var.cis_origin1_address}"
    enabled = true
  }
  origins {
    name = "${var.cis_origin2_name}"
    address = "${var.cis_origin2_address}"
    enabled = true
  }
  origins {
    name = "${var.cis_origin3_name}"
    address = "${var.cis_origin3_address}"
    enabled = true
  }
  enabled = true
  check_regions = ["ENAM"]
}

resource "ibm_cis_global_load_balancer" "glb1" {
  cis_id = "${ibm_cis.cis1.id}"
  domain_id = "${ibm_cis_domain.domain1.id}"
  name = "icstore1.${var.cis_domain}"
  fallback_pool_id = "${ibm_cis_origin_pool.multikubernetes1.id}"
  default_pool_ids = ["${ibm_cis_origin_pool.multikubernetes1.id}"]
  proxied = false
}
